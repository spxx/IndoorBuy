//
//  JCDBCache.m
//  AutoGang
//
//  Created by ian luo on 15/3/2.
//  Copyright (c) 2015年 com.qcb008.QiCheApp. All rights reserved.
//

#import "JCDBCacheManager.h"
#import "FMDB.h"
#import "SQLiteTypeMap.h"

#import <objc/runtime.h>

#define DefaultDBPath @"default_cache.db"
#define AutoExpandClassPrefix @"JC"

@interface JCDBCacheManager()

@property (nonatomic, strong) FMDatabase * db;
@property (nonatomic, assign) Class refClass;
@property (nonatomic, strong) SQLiteTypeMap *sqliteTypeMap;

@end

@implementation JCDBCacheManager

#pragma mark - public
+ (JCDBCacheManager *)cacheForClass:(Class)clazz
{
  static NSMutableDictionary *cache = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    cache = [NSMutableDictionary new];
  });
  
  JCDBCacheManager *manager = cache[NSStringFromClass(clazz)];
  
  if (!manager) {
    manager = [self beginWithEntity:clazz];
    [cache setObject:manager forKeyedSubscript:NSStringFromClass(clazz)];
  }
  
  return manager;
}

+ (JCDBCacheManager *)beginWithEntity:(Class)classObj
{
  JCDBCacheManager *dbManager = [JCDBCacheManager new];
  [dbManager initiateTableForClass:classObj];
  
  return dbManager;
}

- (BOOL)deleteWithCondition:(NSString *)condition
{
  [self.db beginTransaction];
  
  Class class = self.refClass;
  NSString *tableName = NSStringFromClass(class);
  NSString *conditionStatement = condition.length > 0 ? [NSString stringWithFormat:@"WHERE %@",condition] : @"";
  NSString *statement = [NSString stringWithFormat:@"DELETE FROM %@ %@",tableName, conditionStatement];
  
  BOOL result = [self.db executeStatements:statement];
  
  if (result) {
    [self.db commit];
  }else{
    [self.db rollback];
  }
  
  NSAssert(result, [@"Delete Faild: \n%@" stringByAppendingString:[[self.db lastError] localizedDescription]]);
  return result;
}

- (BOOL)insert:(NSArray *)objs
{
  [self.db beginTransaction];
  
  Class class = self.refClass;
  NSString *tableName = NSStringFromClass(class);
  NSArray *propertyList = [self propertiesForClass:class level:1];
  NSMutableString *statement = [NSMutableString new];
  for (id entity in objs) {
    [statement appendFormat:@"INSERT INTO %@",tableName];
    NSMutableString *columns = [@" (" mutableCopy];
    NSMutableString *values = [@" VALUES (" mutableCopy];
    
    for (NSString *property in propertyList) {
      [columns appendFormat:@"%@,",property];
        [values appendFormat:@"'%@',",[self filtForSpecialCharactor:[self handleSavingTextType:[entity valueForKeyPath:[self memberKeypathforProperty:property]]]]];
    }
    
    if ([columns hasSuffix:@","]) {
      [columns deleteCharactersInRange:NSMakeRange(columns.length-1, 1)];
    }
    if ([values hasSuffix:@","]) {
      [values deleteCharactersInRange:NSMakeRange(values.length-1, 1)];
    }
    
    [columns appendString:@" )"];
    [values appendString:@" );"];
    
    [statement appendString:columns];
    [statement appendString:values];
  }
  
  BOOL result = [self.db executeStatements:statement];
  
  if (result) {
    [self.db commit];
  }else{
    [self.db rollback];
  }
  
  NSAssert(result, [@"Insert Faild: \n%@" stringByAppendingString:[[self.db lastError] localizedDescription]]);
  return result;
}

- (BOOL)update:(NSArray *)objs withConditions:(NSArray *)conditions
{
  [self.db beginTransaction];
  
  Class class = self.refClass;
  NSString *tableName = NSStringFromClass(class);
  NSArray *propertyList = [self propertiesForClass:class level:1];
  NSMutableString *statement = [NSMutableString new];
  for (unsigned int i = 0; i< objs.count;i++) {
    id entity = objs[i];
    NSString *conditoin = conditions[i];
    
    [statement appendFormat:@"UPDATE %@ SET ",tableName];
    NSMutableString *valuePare = [NSMutableString new];
    
    for (NSString *property in propertyList) {
      [valuePare appendFormat:@"%@ = '%@',",property,[self filtForSpecialCharactor:[self handleSavingTextType:[entity valueForKeyPath:[self memberKeypathforProperty:property]]]]];
    }
    
    if ([valuePare hasSuffix:@","]) {
      [valuePare deleteCharactersInRange:NSMakeRange(valuePare.length-1, 1)];
    }
    
    [statement appendString:valuePare];
    NSString *conditionStatement = [NSString stringWithFormat:@" WHERE %@ ;",conditoin];
    [statement appendString:conditionStatement];
  }
  
  BOOL result = [self.db executeStatements:statement];
  
  if (result) {
    result = [self.db commit];
      NSAssert(result, [@"commit Faild: \n%@" stringByAppendingString:[[self.db lastError] localizedDescription]]);
  }else{
    result = [self.db rollback];
      NSAssert(result, [@"rollback Faild: \n%@" stringByAppendingString:[[self.db lastError] localizedDescription]]);
  }
  
  NSAssert(result, [@"Update Faild: \n%@" stringByAppendingString:[[self.db lastError] localizedDescription]]);
  return result;
}

- (NSArray *)queryWithCondition:(NSString *)condition orderBy:(NSString *)order
{
  Class class = self.refClass;
  NSArray *tableMap = [self propertiesForClass:class level:1];
  NSString *tableName = NSStringFromClass(class);
  
  NSString *querySubStatement = @"";
  if (condition.length > 0) {
    querySubStatement = [querySubStatement stringByAppendingString:[self createConditionStatement:condition]];
  }
  
  if (order.length > 0) {
    querySubStatement = [querySubStatement stringByAppendingString:[self createOrderbyStatement:order]];
  }
  
  //    NSString *conditionStatement = condition.length > 0 ? [NSString stringWithFormat:@"WHERE %@",condition] : @"";
  NSString *statement = [NSString stringWithFormat:@"SELECT * FROM %@ %@",tableName, querySubStatement];
  FMResultSet * result = [self.db executeQuery:statement];
  
  NSMutableArray * mutableArray = [NSMutableArray new];
  while ([result next]) {
    NSMutableDictionary *clazzInstances = [NSMutableDictionary new];
      
    id obj = [class new];
    for (int i = 0; i < tableMap.count; i ++) {
      NSString *propertyName = tableMap[i];
      Class clazz = [self memberClazz:propertyName] ? [self memberClazz:propertyName] : class;
      id clazzInstance = [self clazzInstanceForProperty:propertyName in:clazzInstances];
      clazzInstance = clazzInstance ? clazzInstance : obj;
      [clazzInstance setValue:[self valueInResult:result atIndex:i propertyName:propertyName andClass:clazz] forKey:[self memberProperty:propertyName]];
    }
      
    for (NSString *memberInstanceKey in clazzInstances.allKeys) {
      [obj setValue:clazzInstances[memberInstanceKey] forKey:memberInstanceKey];
    }
    [mutableArray addObject:obj];
  }
  
  return [NSArray arrayWithArray:mutableArray];
}

- (NSArray *)queryWithCondition:(NSString *)condition
{
  return [self queryWithCondition:condition orderBy:nil];
}

- (NSArray *)queryWithOrder:(NSString *)orderby
{
  return [self queryWithCondition:nil orderBy:orderby];
}

- (NSString *)createConditionStatement:(NSString *)condition
{
  return condition.length > 0 ? [NSString stringWithFormat:@" WHERE %@",condition] : @"";
}

- (NSString *)createOrderbyStatement:(NSString *)orderBy
{
  return orderBy.length > 0 ? [NSString stringWithFormat:@" ORDER BY %@",orderBy] : @"";
}

- (NSArray *)query
{
  return [self queryWithCondition:nil];
}

#pragma mark private
- (void)resetDatabaseToLoginUser
{
//  JCUserEntity * user = [[JCUserContext sharedManager]currentUserInfo];
//  if (user)
//  {
//    NSString * filePath = [[JCAppContext sharedManager].cacheRootPath stringByAppendingFormat:@"user_%@_cache.db",user.userId];
//    [self openDBForPath:filePath];
//  }
}

- (void)resetDatabaseToDefaultUser
{
  NSString * libraryDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
  NSString * filePath = [[libraryDir stringByAppendingString:@"/Caches/"] stringByAppendingString:DefaultDBPath];
  [self openDBForPath:filePath];
}

- (void)openDBForPath:(NSString *)dbPath
{
  [self.db close];
  
  _db = [FMDatabase databaseWithPath:dbPath];
#ifdef DEBUG
  [self.db setTraceExecution:YES];
#endif
  if (![self.db open]){
    NSLog(@"Error: can't open db file at :%@",dbPath);
  }
  NSLog(@"Using Database :%@",dbPath);
}

- (void)initiateTableForClass:(Class)classObj{
  self.refClass = classObj;
  NSString *statement = [self tableInitStatementForClass:self.refClass];
  
//  if ([[JCUserContext sharedManager] isUserLogedIn]) {
//    [self resetDatabaseToLoginUser];
//  } else {
//  }
    [self resetDatabaseToDefaultUser];
  
  BOOL result = [self.db executeStatements:statement];
  if (!result) {
    NSAssert(result, [@"Create Table Faild: \n%@" stringByAppendingString:[[self.db lastError] localizedDescription]]);
  }
}

- (NSString *)filtForSpecialCharactor:(NSString *)string
{
    if ([string isKindOfClass:NSString.class]) {
        string = [string stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        return string;
    } else {
        return string;
    }
}

#pragma mark -
- (id)clazzInstanceForProperty:(NSString *)property in:(NSMutableDictionary *)pool
{
  Class clazz = [self memberClazz:property];
  if (!clazz) {
    return nil;
  } else {
    NSString *key = [self memberClazzPropertyName:property];
    id instance = pool[key];
    if (!instance) {
      instance = [clazz new];
      [pool setObject:instance forKey:key];
    }
    return instance;
  }
}

- (id)valueInResult:(FMResultSet *)resultset atIndex:(int)index propertyName:(NSString *)properyName andClass:(Class)class
{
  objc_property_t property_t = [self property_tForProperty:properyName andClazz:class];
  NSString *returnTypeString = [self.sqliteTypeMap sqliteTypeForProperty:property_t];
  
  if ([returnTypeString isEqualToString:@"REAL"]) {
    return @([resultset doubleForColumnIndex:index]);
  }else if([returnTypeString isEqualToString:@"INTEGER"]){
    return @([resultset intForColumnIndex:index]);
  }else if([returnTypeString isEqualToString:@"TEXT"]){
    return ObjectOrEmptyString([self handleReadingTextTypes:property_t value:ObjectOrEmptyString([resultset stringForColumnIndex:index])]);
  }else if([returnTypeString isEqualToString:@"BLOB"]){
    return [resultset dataForColumnIndex:index];
  }else{
    return nil;
  }
}

- (id)handleSavingTextType:(id)value
{
  if ([value isKindOfClass:[NSArray class]]) {
    NSMutableString *mString = [[value firstObject] mutableCopy];
    for (NSUInteger i = 1; i < [(NSArray *)value count]; i ++) {
      [mString appendFormat:@",%@",[(NSArray *)value objectAtIndex:i]];
    }
    return mString;
  } else if ([value isKindOfClass:[NSDate class]]) {
      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
      [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:SSSZ"];
      
      return [formatter stringFromDate:(NSDate *)value];
  } else if([value isKindOfClass:[NSDictionary class]]){
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  } else {
    return value;
  }
}

- (id)handleReadingTextTypes:(objc_property_t)property value:(NSString *)value
{
  Class clazz = NSClassFromString(clazzForProperty(property));
  if (clazz == [NSArray class]) {
    return [value componentsSeparatedByString:@","];
  } else if (clazz == [NSDate class]) {
      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
      [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:SSSZ"];
      NSDate *date=[formatter dateFromString:value];
    return date;
  } else if(clazz == [NSDictionary class]){
    NSError *error;
    id data = [NSJSONSerialization JSONObjectWithData:[value dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    return data;
  } else {
    if ([value isEqualToString:@"(null)"]) {
      value = @"";
    }
    return value;
  }
}

/*
 自动获取所有属性，父类如果是JC开头的话，自动获取一层，自己的属性如果是JC开头的对象的话，获取一层
 */
- (NSArray *)propertiesForClass:(Class)classObj level:(NSUInteger)level
{
  NSMutableArray *propertiesList = [NSMutableArray new];
  //get properties for super class
  Class superClass = class_getSuperclass(classObj);
  if (superClass != NSObject.class) {
    NSString *superClassString = NSStringFromClass(superClass);
    if ([superClassString hasPrefix:AutoExpandClassPrefix] && level < 2) {
      NSArray *superProperties = [self propertiesForClass:superClass level:level+1];
      if (superProperties) {
        propertiesList = [NSMutableArray arrayWithArray:superProperties];
      }
    }
  }
  
  unsigned int count = 0;
  objc_property_t *properties = class_copyPropertyList(classObj, &count);
  for (unsigned int i = 0; i < count; i ++) {
    NSString *type = clazzForProperty(properties[i]);
    if ([type hasPrefix:AutoExpandClassPrefix] && level < 2) {
      NSArray *memberProperties = [self propertiesForClass:NSClassFromString(type) level:level+1];
      if (memberProperties) {
        memberProperties = [self stringsAddPrefix:[NSString stringWithFormat:@"%s$%@___",property_getName(properties[i]),type] toStrings:memberProperties];
        [propertiesList addObjectsFromArray:memberProperties];
      }
    } else {
      [propertiesList addObject:[NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding]];
    }
  }
  free(properties);
  return [NSArray arrayWithArray:propertiesList];
}

- (NSString *)tableInitStatementForClass:(Class)classObj
{
  NSString *tableName = NSStringFromClass(classObj);
  NSArray *properties = [self propertiesForClass:classObj level:1];
  
  NSMutableString *mutableString = [[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",tableName] mutableCopy];
  for (NSString *property in properties) {
    objc_property_t property_t = [self property_tForProperty:property andClazz:classObj];
    NSString *type = [self.sqliteTypeMap sqliteTypeForProperty:property_t];
    [mutableString appendString:[property stringByAppendingFormat:@" %@,",type]];
  }
  
  if ([mutableString hasSuffix:@","]) {
    [mutableString deleteCharactersInRange:NSMakeRange(mutableString.length-1, 1)];
  }
  [mutableString appendString:@");"];
  
  return [NSString stringWithString:mutableString];
}

- (objc_property_t)property_tForProperty:(NSString *)property andClazz:(Class)classObj
{
  objc_property_t property_t = NULL;
  Class memberClazz = [self memberClazz:property];
  if (memberClazz) {
    property_t = class_getProperty(memberClazz, [[self memberProperty:property] UTF8String]);
  } else {
    property_t = class_getProperty(classObj, [property UTF8String]);
  }
  return property_t;
}

- (Class)memberClazz:(NSString *)propertyName
{
  NSArray *cs = [propertyName componentsSeparatedByString:@"___"];
  if (cs.count > 1) {
    NSString *memberClazzInfo = cs[cs.count - 2];
    NSArray *memberClazzInfoArray = [memberClazzInfo componentsSeparatedByString:@"$"];
    if (memberClazzInfoArray.count == 2) {
      return NSClassFromString(memberClazzInfoArray[1]);
    } else {
      return nil;
    }
  } else {
    return nil;
  }
}

- (NSString *)memberClazzPropertyName:(NSString *)propertyName
{
  NSArray *cs = [propertyName componentsSeparatedByString:@"___"];
  if (cs.count > 1) {
    NSString *memberClazzInfo = cs[cs.count - 2];
    NSArray *memberClazzInfoArray = [memberClazzInfo componentsSeparatedByString:@"$"];
    if (memberClazzInfoArray.count == 2) {
      return memberClazzInfoArray[0];
    } else {
      return nil;
    }
  } else {
    return nil;
  }
}

- (NSString *)memberProperty:(NSString *)propertyName
{
  NSArray *cs = [propertyName componentsSeparatedByString:@"___"];
  if (cs.count > 1) {
    return cs[cs.count - 1];
  } else {
    return propertyName;
  }
}

- (NSString *)memberKeypathforProperty:(NSString *)property
{
  //rootTopic$JCTopic_parentTopic$JCTopic_title
  NSArray *cs = [property componentsSeparatedByString:@"___"];
  if (cs.count > 1) {
    for (NSString *comp in cs) {
      NSArray *type = [comp componentsSeparatedByString:@"$"];
      if (type.count == 2) {
        property = [property stringByReplacingOccurrencesOfString:type[1] withString:@""];
      }
    }
  }
  property = [property stringByReplacingOccurrencesOfString:@"$" withString:@""];
  property = [property stringByReplacingOccurrencesOfString:@"___" withString:@"."];
  return property;
}

#pragma mark - getter
- (SQLiteTypeMap *)sqliteTypeMap
{
  if (!_sqliteTypeMap) {
    _sqliteTypeMap = [SQLiteTypeMap new];
  }
  return _sqliteTypeMap;
}

- (NSArray *)stringsAddPrefix:(NSString *)prefix toStrings:(NSArray *)strings
{
    NSMutableArray *newStrings = [NSMutableArray new];
    [strings enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [newStrings addObject:[prefix stringByAppendingString:obj]];
    }];
    
    return [NSArray arrayWithArray:newStrings];
}

@end
