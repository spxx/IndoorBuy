//
//  UserCenterModel.h
//  DP
//
//  Created by LiuP on 16/7/20.
//  Copyright © 2016年 sp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UserModelComplete)(NSString * urlPath, NSString * message, NSInteger code);

@interface UserCenterModel : NSObject

/**
 *  上传图片
 *
 *  @param image
 *  @param complete 
 */
+ (void)requestForUploadImage:(UIImage *)image complete:(UserModelComplete)complete;
/**
 *  更新用户信息
 *
 *  @param complete 
 */
+ (void)updateUserInfoWithComplete:(void(^)(NSString *message, NSInteger code))complete;

/**
 *  设置支付密码验证码
 *
 *  @param phone
 *  @param complete
 */
+ (void)requestForGetPayCodeWithPhone:(NSString *)phone
                             Complete:(void(^)(NSString *message, NSInteger code))complete;

/**
 *  设置支付密码
 *
 *  @param phone
 *  @param complete
 */
+ (void)requestForSetPayPasswordWithVerify:(NSString *)verify
                                   newPass:(NSString *)newPass
                                  Complete:(void(^)(NSString *message, NSInteger code))complete;

/**
 *  手势密码设置
 *
 *  @param gesturePassword
 *  @param complete
 */
+ (void)requestForSetGPasswordWithGesturePassword:(NSString *)gesturePassword
                                         Complete:(void(^)(NSString *message, NSInteger code))complete;

/**
 *  手势密码验证
 *
 *  @param gesturePassword
 *  @param complete
 */
+ (void)requestForVerifyGPasswordWithGesturePassword:(NSString *)gesturePassword
                                            Complete:(void(^)(NSString *message, NSInteger code))complete;

/**
 *   登录
 *
 *  @param userName
 *  @param password
 *  @param complete
 */
+ (void)requestForLoginWithUserName:(NSString *)userName
                           password:(NSString *)password
                           complete:(void(^)(NSDictionary * userInfo, NSString *message, NSInteger code))complete;
/**
 *  登录接口，用于切换验证手势密码
 *
 *  @param password
 *  @param complete
 */
+ (void)requestForVerifyPassword:(NSString *)password
                        complete:(void(^)(NSDictionary * userInfo, NSString *message, NSInteger code))complete;

/**
 *  忘记密码获取验证码
 *
 *  @param phone
 *  @param complete
 */
+ (void)requestForFindPasswordCodeWithPhone:(NSString *)phone
                                   complete:(void(^)(NSString * message, NSInteger code))complete;

/**
 *  忘记密码
 *
 *  @param phone
 *  @param verifyCode
 *  @param newPassword
 *  @param complete
 */
+ (void)requestForFindPasswordWithPhone:(NSString *)phone
                             verifyCode:(NSString *)verifyCode
                            newPassword:(NSString *)newPassword
                               complete:(void(^)(NSString * message, NSInteger code))complete;

/**
 *  检查用户是否设置了交易密码
 *
 *  @param complete
 */
+ (void)requsetForCheckPayPasswordExistWithComplete:(void(^)(NSString * message, NSInteger code))complete;

@end
