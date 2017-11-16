//
//  FMDBTools.m
//  FMDBTools
//
//  Created by gukai on 16/1/5.
//  Copyright © 2016年 gukai. All rights reserved.
//

#import "FMDBTools.h"
#import "FMDB.h"
//数据库沙盒路径
#define SQLITE_PATH [NSString stringWithFormat:@"%@/Caches/default_cache.db", [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]]

@interface FMDBTools ()

// +(BOOL)openDataBase:(NSString *)dbname;//打开数据库
// +(BOOL)closeDataBase:(NSString *)dbname;//关闭数据库


/**
 *  根据数据库名称得到数据的沙盒路径
 *  
 *  @param  dbname:数据库名称
 *
 *  @return 数据库的沙盒路径
 */
+(NSString *)getDataBaseFilePath:(NSString *)dbname;

/**
 *  创建建表的SQL语句
 *
 *  @param  tableName:表名
 *
 *  @param  value_map:对应key值在表中创建相应的类型为String类型的字段
 *
 *  @return 返回完整的SQL建表语句
 */
+ (NSString *)createTableSQL:(NSString *)tableName value_map:(NSDictionary *)value_map;

/**
 *  创建 Select 语句
 *
 *  @param  column_list:对应的字段，要查询的字段
 *
 *  @param  condition_map:条件 比如：@{ name = gukai }，名字是gukai的数据
 *
 *  @return 返回完整的Select语句
 */
+(NSString *)createSelectSQL:(NSString *)tableName column_list:(NSArray *)column_list condition_map:(NSDictionary *)condition_map;

/**
 *  创建 update 语句
 *
 *  @param tableName:表名
 *
 *  @param value_map:新值
 *
 *  @param condition_map:条件
 *
 *  @return 返回 update 语句
 */
+(NSString *)createUpdateSQL:(NSString *)tableName value_map:(NSDictionary *)value_map condition_map:(NSDictionary *)condition_map;

/**
 *  创建 Insert 语句
 *
 *  @param tableName:表名
 *
 *  @param value_map:新值(在某表中插入一条数据)
 *
 *  @return 返回 Insert 语句
 */
+(NSString *)createInsertSQL:(NSString *)tableName value_map:(NSDictionary *)value_map;

/**
 *  创建 Delete 语句
 *
 *  @param tableName:表名
 *
 *  @param condition_map:条件，比如@{ age = 18 },会删除表中的所有age = 18 的数据
 *
 *  @return 返回 Insert 语句
 */
+(NSString *)createDeleteSQL:(NSString *)tableName condition_map:(NSDictionary *)condition_map;

/**
 *  创建 Delete 表语句
 *
 *  @param tableName:表名
 *
 *  @return 返回 删除表的SQL语句
 */
+(NSString *)createDeleteTableSQL:(NSString *)tableName;
@end
@implementation FMDBTools
#pragma mark -- private --
/**
 *  根据数据库名称得到数据的沙盒路径
 *
 *  @param  dbname:数据库名称
 *
 *  @return 数据库的沙盒路径
 */
+(NSString *)getDataBaseFilePath:(NSString *)dbname
{
    
   // return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:dbname];
    return [NSString stringWithFormat:@"%@.sqlite",[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:dbname]];
}

/**
 *  创建 Select 语句
 *
 *  @param  column_list:对应的字段，要查询的字段
 *
 *  @param  condition_map:条件 比如：@{ name = gukai }，名字是gukai的数据
 *
 *  @return 返回完整的Select语句
 */
+(NSString *)createSelectSQL:(NSString *)tableName column_list:(NSArray *)column_list condition_map:(NSDictionary *)condition_map
{
    
    if (tableName == nil || tableName.length == 0) {
        return nil;
    }
    NSString *sqlString = @"select";
    
    NSString *fields = @"";
    
    if (column_list == nil || [column_list count]<1) {
        fields = @" * ";
    } else {
        for (int i = 0; i<[column_list count]; i++) {
            NSString *seperator = [fields length]<1?@" ":@",";
            fields = [[fields stringByAppendingString:seperator] stringByAppendingString:[column_list objectAtIndex:i]];
        }
        
        fields = [fields stringByAppendingString:@" "];
    }
    
    sqlString = [sqlString stringByAppendingString:fields];
    sqlString = [sqlString stringByAppendingString:@"from "];
    sqlString = [sqlString stringByAppendingString:tableName];
    
    if (condition_map == nil || [condition_map count]<1) {
        return sqlString;
    }
    sqlString = [sqlString stringByAppendingString:@" where "];
    
    NSString *conditions = @"";
    
    
    for (int j =0; j < [[condition_map allKeys] count]; j++) {
        
        NSString *key = [[condition_map allKeys] objectAtIndex:j];
        NSString *value = [condition_map objectForKey:key];
        value = [NSString stringWithFormat:@"'%@'",value];
        NSString *seperator = [conditions length]<1?@"":@" and ";
        
        conditions = [[[[conditions stringByAppendingString:seperator] stringByAppendingString:key] stringByAppendingString:@"="] stringByAppendingString:value];
    }
    
    sqlString = [sqlString stringByAppendingString:conditions];
    
    return sqlString;

}
/**
 *  创建 update 语句
 *
 *  @param tableName:表名
 *
 *  @param value_map:新值
 *
 *  @param condition_map:条件
 *
 *  @return 返回 update 语句
 */
+(NSString *)createUpdateSQL:(NSString *)tableName value_map:(NSDictionary *)value_map condition_map:(NSDictionary *)condition_map
{
    if (tableName == nil || value_map == nil || tableName.length == 0 || value_map.allKeys.count == 0) {
        return nil;
    }
    NSString *sqlString = @"update ";
    
    sqlString = [sqlString stringByAppendingString:tableName];
    
    sqlString = [sqlString stringByAppendingString:@" set"];
    
    NSString *updateFields = @"";
    
    for (int i = 0; i<[[value_map allKeys] count]; i++) {
        
        NSString *seperator = [updateFields length]<1?@" ":@",";
        NSString *key = [[value_map allKeys] objectAtIndex:i];
        NSString *value = [value_map objectForKey:key];
        value = [NSString stringWithFormat:@"\"%@\"",value];
        
        updateFields = [[[[updateFields stringByAppendingString:seperator] stringByAppendingString:key] stringByAppendingString:@"="] stringByAppendingString:value];
    }
    
    sqlString = [sqlString stringByAppendingString:updateFields];
    
    if (condition_map == nil || [condition_map count]<1) {
        return sqlString;
    }
    sqlString = [sqlString stringByAppendingString:@" where "];
    
    NSString *conditions = @"";
    
    for (int j =0; j < [[condition_map allKeys] count]; j++) {
        
        NSString *key = [[condition_map allKeys] objectAtIndex:j];
        NSString *value = [condition_map objectForKey:key];
         value = [NSString stringWithFormat:@"'%@'",value];
        
        NSString *seperator = [conditions length]<1?@"":@" and ";
        
        conditions = [[[[conditions stringByAppendingString:seperator] stringByAppendingString:key] stringByAppendingString:@"="] stringByAppendingString:value];
    }
    
    sqlString = [sqlString stringByAppendingString:conditions];
    
    return sqlString;

}
/**
 *  创建建表的SQL语句
 *
 *  @param  tableName:表名
 *
 *  @param  value_map:对应key值在表中创建相应的类型为String类型的字段
 *
 *  @return 返回完整的SQL建表语句
 */
+ (NSString *)createTableSQL:(NSString *)tableName value_map:(NSDictionary *)value_map
{
    if (tableName == nil || tableName.length == 0) {
        return nil;
    }
    NSString * sqlString = @"CREATE TABLE IF NOT EXISTS ";
    sqlString = [sqlString stringByAppendingString:tableName];
    sqlString = [sqlString stringByAppendingString:@" (id INTEGER PRIMARY KEY,"];
    NSString * keyString = @"";
    for (int i = 0; i < value_map.allKeys.count; i ++) {
        
        NSString * key = [NSString stringWithFormat:@"%@",value_map.allKeys[i]];
        NSString * seperator = [NSString stringWithFormat:@" %@ TEXT NOT NULL,",key];
        keyString = [keyString stringByAppendingString:seperator];
    }
   sqlString = [sqlString stringByAppendingString:keyString];
   sqlString = [sqlString substringToIndex:sqlString.length - 1];
    sqlString = [sqlString stringByAppendingString:@" )"];
    return sqlString;
    
}

/**
 *  创建 Insert 语句
 *
 *  @param tableName:表名
 *
 *  @param value_map:新值(在某表中插入一条数据)
 *
 *  @return 返回 Insert 语句
 */
+(NSString *)createInsertSQL:(NSString *)tableName value_map:(NSDictionary *)value_map
{
    if (tableName == nil || value_map == nil) {
        return nil;
    }
    NSString *sqlString = @"insert into ";
    sqlString = [sqlString stringByAppendingString:tableName];
    sqlString = [sqlString stringByAppendingString:@" ("];
    
    NSString *keyString = @"";
    
    for (int i = 0 ; i<[[value_map allKeys] count]; i++) {
        NSString *seperator = [keyString length]<1?@"":@",";
        NSString *key = [[value_map allKeys] objectAtIndex:i];
        keyString = [[keyString stringByAppendingString:seperator] stringByAppendingString:key];
    }
    sqlString = [sqlString stringByAppendingString:keyString];
    sqlString = [sqlString stringByAppendingString:@") values ("];
    
    NSString *valueString = @"";
    for (int j = 0 ; j<[[value_map allKeys] count]; j++) {
        
        NSString *seperator = [valueString length]<1?@"\"":@",\"";
        NSString *key = [[value_map allKeys] objectAtIndex:j];
        valueString = [[valueString stringByAppendingString:seperator] stringByAppendingString:[value_map objectForKey:key]];
        valueString = [valueString stringByAppendingString:@"\""];
    }
    
    sqlString = [sqlString stringByAppendingString:valueString];
    sqlString = [sqlString stringByAppendingString:@")"];
    
    return sqlString;

}

/**
 *  创建 Delete 语句
 *
 *  @param tableName:表名
 *
 *  @param condition_map:条件，比如@{ age = 18 },会删除表中的所有age = 18 的数据
 *
 *  @return 返回 Insert 语句
 */
+(NSString *)createDeleteSQL:(NSString *)tableName condition_map:(NSDictionary *)condition_map
{
    if (tableName == nil || tableName.length == 0) {
        return nil;
    }
    NSString *sqlString = @"delete from ";
    sqlString = [sqlString stringByAppendingString:tableName];
    
    if (condition_map == nil || [condition_map count]<1) {
        return sqlString;
    }
    sqlString = [sqlString stringByAppendingString:@" where "];
    
    NSString *conditions = @"";
    
    for (int j =0; j < [[condition_map allKeys] count]; j++) {
        
        NSString *key = [[condition_map allKeys] objectAtIndex:j];
        NSString *value = [condition_map objectForKey:key];
         value = [NSString stringWithFormat:@"'%@'",value];
        NSString *seperator = [conditions length]<1?@"":@" and ";
        
        conditions = [[[[conditions stringByAppendingString:seperator] stringByAppendingString:key] stringByAppendingString:@"="] stringByAppendingString:value];
    }
    
    sqlString = [sqlString stringByAppendingString:conditions];
    return sqlString;
    
}

/**
 *  创建 Delete 表语句
 *
 *  @param tableName:表名
 *
 *  @return 返回 删除表的SQL语句
 */
+(NSString *)createDeleteTableSQL:(NSString *)tableName
{
    if (tableName == nil || tableName.length == 0) {
        return nil;
    }
    NSString *sqlString = @"delete from ";
    sqlString = [sqlString stringByAppendingString:tableName];
    return sqlString;
    
}
#pragma mark -- 公开方法 --
/**
 *   在沙盒路径下 /Documents/ 创建数据库
 *
 *   @param dbname: 数据库名称
 *
 *   @return 创建成功返回ture, 否则返回fales
 */
+ (BOOL)createDataBase:(NSString *)dbname
{
    FMDatabase *database = [FMDatabase databaseWithPath:SQLITE_PATH];
    NSLog(@"%@",SQLITE_PATH);
    if (![database open]) {
        return false;
    }
    else{
        return true;
    }
}

/**
 *  在对应的数据库中创建表
 *
 *  @param dbname: 数据库名称
 *
 *  @param tableName: 表名
 *
 *  @param value_map: 传入一个字典对象,将会对字典里面的所有key值在数据库中生成对应列字段
 *
 *
 *  @return 建表成功返回ture, 否则返回fales
 *
 *  注意: 此方法字典里面的key对应的value值必须是字符串，不能为其他类型
 */
+ (BOOL)createTableInDataBase:(NSString *)dbname tableName:(NSString *)tableName value_map:(NSDictionary *)value_map;
{
    NSString * sql = [FMDBTools createTableSQL:tableName value_map:value_map];
    return [FMDBTools execUpdate:dbname sql:sql];
}

/**
 *  在对应的数据库中进行查询
 *
 *  @param dbname: 数据库名称
 *
 *  @param  sql: SQL操作语句
 *
 *
 *  @return 根据查询的条件返回的结果
 */
+ (NSMutableArray *)execQuery:(NSString *)dbname sql:(NSString *)sql
{
    NSString *filePath = [FMDBTools getDataBaseFilePath:dbname];
    FMDatabase *database = [FMDatabase databaseWithPath:filePath];
    
    if (![database open]) {
        return nil;
    }
    NSMutableArray * results = [NSMutableArray array];
    FMResultSet *resultSet = [database executeQuery:sql];
    while ([resultSet next]) {
        NSMutableDictionary *record = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        for (int i =0 ; i<[resultSet columnCount]; i++) {
            NSString *key = [resultSet columnNameForIndex:i];
            NSString *value = [resultSet stringForColumn:key];
            [record setObject:value forKey:key];
        }
        
        [results addObject:record];
        record = nil;
    }
    return results;

}

/**
 *  在对应的数据库中进行查询
 *
 *  @param  dbname: 数据库名称
 *
 *  @param  tableName: 表名
 *
 *  @param  column_list: 要查询的列,传入nil将会返回一个对象
 *
 *  @param  condition_map: 条件,根据条件查询，例如字典：@{age = 20},
            查询年龄为20的数据
 *
 *
 *  @return 根据查询条件返回结果
 */
+ (NSMutableArray *)executeQuery:(NSString *)dbname tableName:(NSString *)tableName column_list:(NSArray *)column_list condition_map:(NSDictionary *)condition_map
{
    NSString * sql = [FMDBTools createSelectSQL:tableName column_list:column_list condition_map:condition_map];
    
    NSMutableArray * results = [FMDBTools execQuery:dbname sql:sql];
    
    return results;

}

/**
 *  在对应的数据库中进行增，删，改，查的操作，传入SQL语句即可
 *
 *  @param  dbname: 数据库名称
 *
 *  @param  sql: SQL操作语句
 *
 *
 *  @return 操作成功返回ture,否则返回false
 */
+(BOOL)execUpdate:(NSString *)dbname sql:(NSString *)sql
{
    NSString * filePath = [FMDBTools getDataBaseFilePath:dbname];
    FMDatabase *database = [FMDatabase databaseWithPath:filePath];
    
    if (![database open]) {
        return false;
    }
    
    if (![database executeUpdate:sql]) {
        return false;
    }
    return true;
}

/**
 *  在对应的数据库中对某表进行修改操作
 *
 *  @param  dbname: 数据库名称
 *
 *  @param  tableName: 表名
 *
 *  @param  value_map: 对应的新值，是一个字典，key为对应要修改的字段，value为新值（必须表中对应的 key 值列才会修改成功）
 *
 *  @param  condition_map: 条件，根据条件进行修改
 *
 *
 *  @return 操作成功返回ture,否则返回false
 */
+ (BOOL)executeUpdate:(NSString *)dbname tableName:(NSString *)tableName value_map:(NSDictionary *)value_map condition_map:(NSDictionary *)condition_map
{
    NSString * sql = [self createUpdateSQL:tableName value_map:value_map condition_map:condition_map];
    return [FMDBTools execUpdate:dbname sql:sql];
}

/**
 *  在对应的数据库中对某表进行插入一条新数据
 *
 *  @param  dbname: 数据库名称
 *
 *  @param  tableName: 表名
 *
 *  @param  value_map: 对应的对象，是一个字典，key为对应的字段，value为新值(传入一个具有该表所有字段为key值的对象)
 *
 *
 *  @return 插入成功返回ture,否则返回false
 */
+ (BOOL)executeInsert:(NSString *)dbname tableName:(NSString *)tableName value_map:(NSDictionary *)value_map
{
    NSString * sql = [FMDBTools createInsertSQL:tableName value_map:value_map];
    return [FMDBTools execUpdate:dbname sql:sql];
}

/**
 *  在对应的数据库中对应某表进行删除数据
 *
 *  @param  dbname: 数据库名称
 *
 *  @param  tableName: 表名
 *
 *  @param  condition_map: 条件，根据条件删除
 *
 *
 *  @return 删除成功返回ture,否则返回false
 */
+ (BOOL)executeDelete:(NSString *)dbname tableName:(NSString *)tableName condition_map:(NSDictionary *)condition_map
{
    NSString * sql = [FMDBTools createDeleteSQL:tableName condition_map:condition_map];
    return [FMDBTools execUpdate:dbname sql:sql];
}

/**
 *  在对应的数据库中删除某表
 *
 *  @param  dbname: 数据库名称
 *
 *  @param  tableName: 表名
 *
 *
 *  @return 删除成功返回ture,否则返回false
 */

+ (BOOL)executeDeleteTable:(NSString *)dbname tableName:(NSString *)tableName
{
    NSString * sql = [FMDBTools createDeleteTableSQL:tableName];
    return [FMDBTools execUpdate:dbname sql:sql];
}






@end
