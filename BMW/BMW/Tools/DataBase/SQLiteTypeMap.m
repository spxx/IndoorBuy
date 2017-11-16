//
//  SQLiteTypeMap.m
//  AutoGang
//
//  Created by ian luo on 15/3/2.
//  Copyright (c) 2015年 com.qcb008.QiCheApp. All rights reserved.
//

#import "SQLiteTypeMap.h"

@implementation SQLiteTypeMap

NSString * __s(Class class)
{
  return NSStringFromClass(class);
}

#pragma mark - public
- (NSString *)sqliteTypeForProperty:(objc_property_t)property
{
  NSString *columnType = [self objMap][clazzForProperty(property)];
  return columnType.length > 0 ? columnType : @"NONE";
}

- (NSDictionary *)objMap
{
  static NSDictionary *map = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    map = @{__s(NSString.class):@"TEXT",
            __s(NSDate.class):@"TEXT",
            __s(NSNull.class):@"NULL",
            __s(NSData.class):@"BLOB",
            __s(NSArray.class):@"TEXT",
            __s(NSDictionary.class):@"TEXT",
            @"int":@"INTEGER",
            @"float":@"REAL",
            };
  });
  return map;
}

- (NSString *)mappedTypeForClass:(Class)clazz
{
  return [self objMap][__s(clazz)];
}

NSString *clazzForProperty(objc_property_t property)
{
  const char * type = property_getAttributes(property);
  
  NSString * typeString = [[NSString alloc]initWithCString:type encoding:NSUTF8StringEncoding];
  NSArray * attributes = [typeString componentsSeparatedByString:@","];
  NSString * typeAttribute = [attributes objectAtIndex:0];
  NSString * propertyType = [typeAttribute substringFromIndex:1];
  const char * rawPropertyType = [propertyType UTF8String];
  
  if (strcmp(rawPropertyType, @encode(float)) == 0) {
    return @"int";
  } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
    return @"float";
  } else if (strcmp(rawPropertyType, @encode(id)) == 0) {
    return propertyType;
  }else if (strcmp(rawPropertyType, @encode(BOOL)) == 0) {
    return @"int";
  }else if (strcmp(rawPropertyType, @encode(NSInteger)) == 0) {
    return @"int";
  } else if (strcmp(rawPropertyType, @encode(NSUInteger)) == 0) {
    return @"int";
  } else if (strcmp(rawPropertyType, @encode(double)) == 0) {
    return @"float";
  } else {
    // According to Apples Documentation you can determine the corresponding encoding values
  }
  
  if ([typeAttribute hasPrefix:@"T@"]) {
    NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];
    return typeClassName;
  } else {
    return @"";
  }
}

@end
