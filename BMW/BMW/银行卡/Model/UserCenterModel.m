//
//  UserCenterModel.m
//  DP
//
//  Created by LiuP on 16/7/20.
//  Copyright © 2016年 sp. All rights reserved.
//

#import "UserCenterModel.h"


@implementation UserCenterModel

+ (void)requestForUploadImage:(UIImage *)image complete:(UserModelComplete)complete
{
//    [BaseRequset upLoadImageWithUrl:DP_UPLOAD_IMAGE_URL parmas:@{@"userid":[JCUserContext sharedManager].currentUserInfo.userid} withImage:image RequestSuccess:^(id result) {
//        if ([result[@"code"] integerValue] == 100) {
//            NSString * picUrl = [NSString stringWithFormat:@"%@", result[@"data"]];
//            if (![picUrl hasPrefix:@"http"]) {
//                picUrl = IMAGE_DP_URL(picUrl);
//            }
//            [JCUserContext sharedManager].currentUserInfo.headpic = picUrl;
//            [[JCUserContext sharedManager] updateUserInfo:[JCUserContext sharedManager].currentUserInfo];
//            complete(picUrl, result[@"message"], 100);
//        }else {
//            complete(nil, result[@"message"], [result[@"code"] integerValue]);
//        }
//    } failBlcok:^(id result) {
//        complete(nil, result, -1);
//    }];
}

/**
 *  更新用户信息
 *
 *  @param complete
 */
+ (void)updateUserInfoWithComplete:(void(^)(NSString *message, NSInteger code))complete
{
//    [BaseRequset sendPOSTRequestWithMethod:@"GetInfo" parameters:@{@"memberid":[JCUserContext sharedManager].currentUserInfo.userid} callBack:^(RequestResult result, id object) {
//        if (result == RequestResultSuccess) {
//            Userentity * user = [[Userentity alloc] initWithDic:object[@"data"]];
//            [[JCUserContext sharedManager] updateUserInfo:user];
//            [[JCUserContext sharedManager] initUserState];
//            if ([object[@"type"] integerValue] == 1) {
//                [JCUserContext sharedManager].currentUserInfo.geren = NO;
//            }
//            else{
//                [JCUserContext sharedManager].currentUserInfo.geren = YES;
//            }
//            complete(@"用户信息更新成功", 100);
//        }else {
//            complete(@"用户信息更新失败", -1);
//        }
//    }];
}

/**
 *  获取设置支付密码验证码
 *
 *  @param phone
 *  @param complete
 */
+ (void)requestForGetPayCodeWithPhone:(NSString *)phone Complete:(void(^)(NSString *message, NSInteger code))complete
{
//    NSString * userID = [JCUserContext sharedManager].currentUserInfo.userid;
//    NSDictionary * paraDic = @{@"userId":userID, @"phone":phone};
//    [BaseRequset sendPOSTRequestWithBMWMethod:@"PayPassMes" parameters:paraDic callBack:^(RequestResult result, id object) {
//        if (result == RequestResultSuccess) {
//            complete(@"验证码已发送至该手机", 100);
//        }else {
//            NSString * message = @"获取验证码失败";
//            if ([object isKindOfClass:[NSString class]]) {
//                message = object;
//            }
//            complete(message, -1);
//        }
//    }];
}

/**
 *  修改/设置支付密码
 *
 *  @param verify
 *  @param newPass
 *  @param complete
 */
+ (void)requestForSetPayPasswordWithVerify:(NSString *)verify newPass:(NSString *)newPass Complete:(void(^)(NSString *message, NSInteger code))complete
{
//    NSString * userID = [JCUserContext sharedManager].currentUserInfo.userid;
//    NSDictionary * paraDic = @{@"userId":userID, @"verify":verify, @"newpass":newPass};
//    [BaseRequset sendPOSTRequestWithMethod:@"EditPayPass" parameters:paraDic callBack:^(RequestResult result, id object) {
//        if (result == RequestResultSuccess) {
//            complete(@"支付密码设置成功", 100);
//        }else {
//            NSString * message = @"支付密码设置失败";
//            if ([object isKindOfClass:[NSString class]]) {
//                message = object;
//            }
//            complete(message, -1);
//        }
//    }];
}

/**
 *  手势密码设置
 *
 *  @param gesturePassword
 *  @param complete
 */
+ (void)requestForSetGPasswordWithGesturePassword:(NSString *)gesturePassword Complete:(void(^)(NSString *message, NSInteger code))complete
{
//    NSString * userID = [JCUserContext sharedManager].currentUserInfo.userid;
//    NSDictionary * paraDic = @{@"userId":userID, @"newpass":gesturePassword};
//    [BaseRequset sendPOSTRequestWithBMWMethod:@"SafePass" parameters:paraDic callBack:^(RequestResult result, id object) {
//        if (result == RequestResultSuccess) {
//            complete(@"安全密码设置成功", 100);
//        }else {
//            NSString * message = @"安全密码保存失败，请重绘";
//            complete(message, -1);
//        }
//    }];
}

/**
 *  手势密码验证
 *
 *  @param gesturePassword
 *  @param complete
 */
+ (void)requestForVerifyGPasswordWithGesturePassword:(NSString *)gesturePassword Complete:(void(^)(NSString *message, NSInteger code))complete
{
//    NSString * userID = [JCUserContext sharedManager].currentUserInfo.userid;
//    NSDictionary * paraDic = @{@"userId":userID, @"pass":gesturePassword};
//    [BaseRequset sendPOSTRequestWithBMWMethod:@"CheckSafePass" parameters:paraDic callBack:^(RequestResult result, id object) {
//        if (result == RequestResultSuccess) {
//            complete(@"安全密码验证成功", 100);
//        }else {
//            NSString * message = @"安全密码验证失败";
//            complete(message, -1);
//        }
//    }];
}

/**
 *   登录
 *
 *  @param userName
 *  @param password
 *  @param complete
 */
+ (void)requestForLoginWithUserName:(NSString *)userName password:(NSString *)password complete:(void(^)(NSDictionary * userInfo, NSString *message, NSInteger code))complete
{
//    [BaseRequset sendPOSTRequestWithMethod:@"Login" parameters:@{@"username":userName, @"password":password} callBack:^(RequestResult result, id object) {
//        if (result == RequestResultSuccess) {
//            [[JCUserContext sharedManager] clearSavedUserInfo];
//            NSDictionary * dataDic = object[@"data"];
//            if ([dataDic[@"type"] isKindOfClass:[NSNull class]]) {
//                [JCUserContext sharedManager].currentUserInfo.geren = YES;
//            }
//            else {
//                if ([dataDic[@"type"] isEqualToString:@"1"]) {
//                    [JCUserContext sharedManager].currentUserInfo.geren = NO;
//                }
//                else if ([dataDic[@"type"] isEqualToString:@"2"]) {
//                    [JCUserContext sharedManager].currentUserInfo.geren = YES;
//                }
//            }
//            Userentity * user = [[Userentity alloc] initWithDic:dataDic];
//            [[JCUserContext sharedManager] updateUserInfo:user];
//            complete(dataDic, @"Success", 100);
//        }else {
//            complete(nil, object, -1);
//        }
//    }];
}

/**
 *  登录接口，用于切换验证手势密码
 *
 *  @param password
 *  @param complete
 */
+ (void)requestForVerifyPassword:(NSString *)password complete:(void(^)(NSDictionary * userInfo, NSString *message, NSInteger code))complete
{
//    NSString * name = [JCUserContext sharedManager].currentUserInfo.mobile;
//    [BaseRequset sendPOSTRequestWithMethod:@"Login" parameters:@{@"username":name, @"password":password} callBack:^(RequestResult result, id object) {
//        if (result == RequestResultSuccess) {
//            NSDictionary * dataDic = object[@"data"];
//            complete(dataDic, @"Success", 100);
//        }else {
//            complete(nil, object, -1);
//        }
//    }];
}


/**
 *  忘记密码获取验证码
 *
 *  @param phone
 *  @param complete
 */
+ (void)requestForFindPasswordCodeWithPhone:(NSString *)phone complete:(void(^)(NSString * message, NSInteger code))complete
{
//    [BaseRequset sendPOSTRequestWithMethod:@"FindPasswordCode" parameters:@{@"mobile":phone} callBack:^(RequestResult result, id object) {
//        
//        if (result == RequestResultSuccess) {
//            complete(@"验证码已发送至该手机", 100);
//        }else {
//            complete(object, -1);
//        }
//    }];
}

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
                               complete:(void(^)(NSString * message, NSInteger code))complete
{
//    [BaseRequset sendPOSTRequestWithMethod:@"FindPassword" parameters:@{@"mobile":phone, @"code":verifyCode, @"password":newPassword} callBack:^(RequestResult result, id object) {
//        if (result == RequestResultSuccess) {
//            complete(@"密码修改成功，请使用新密码登录", 100);
//        }else {
//            complete(object, -1);
//        }
//    }];
}

/**
 *  检查用户是否设置了交易密码
 *
 *  @param complete
 */
+ (void)requsetForCheckPayPasswordExistWithComplete:(void(^)(NSString * message, NSInteger code))complete
{
    NSString * userID = [JCUserContext sharedManager].currentUserInfo.memberID;
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"PayCheck" parameters:@{@"userId":userID} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            complete(@"用户已设置交易密码", 100);
        }else if (result == RequestResultEmptyData){
            complete(@"用户未设置交易密码", -2);
        }else {
            complete(object, -1);
        }
    }];
}

@end
