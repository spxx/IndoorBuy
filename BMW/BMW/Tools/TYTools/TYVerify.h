//
//  Verify.h
//  成长轨迹
//
//  Created by Leo Tang on 14/12/17.
//  Copyright (c) 2014年 Leo Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYVerify : NSObject

/**
 *  验证密码合法
 *
 *  @param passWord 密码字符串
 *
 *  @return 验证结果
 */
+ (BOOL)validatePassword:(NSString *)passWord;

/**
 *  验证是否合法邮箱
 *
 *  @param email 邮箱字符串
 *
 *  @return 验证结果
 */
+ (BOOL)isValidateEmail:(NSString *)email;

/**
 *  验证是否合法电话号码
 *
 *  @param mobileNum 电话号码字符串
 *
 *  @return 验证结果
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/**
 *  验证是否合法身份证
 *
 *  @param sPaperId 身份证字符串
 *
 *  @return 验证结果
 */
+ (BOOL)isIdCard:(NSString *)sPaperId;

@end
