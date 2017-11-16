//
//  NSObject+ClassType.h
//  AutoGang
//
//  Created by luoxu on 15/2/17.
//  Copyright (c) 2015年 com.qcb008.QiCheApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(ClassType)

- (BOOL)isArray;

- (BOOL)isDictionary;

- (BOOL)isString;

- (BOOL)isDate;

@end
