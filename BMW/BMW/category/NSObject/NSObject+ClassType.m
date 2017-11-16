//
//  NSObject+ClassType.m
//  AutoGang
//
//  Created by luoxu on 15/2/17.
//  Copyright (c) 2015年 com.qcb008.QiCheApp. All rights reserved.
//

#import "NSObject+ClassType.h"

@implementation NSObject(ClassType)

- (BOOL)isArray{
    return [self isKindOfClass:[NSArray class]];
}

- (BOOL)isDictionary{
    return [self isKindOfClass:[NSDictionary class]];
}

- (BOOL)isString{
    return [self isKindOfClass:[NSString class]];
}

- (BOOL)isDate
{
  return [self isKindOfClass:[NSDate class]];
}

@end
