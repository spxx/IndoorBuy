//
//  QQTools
//  QQLogin
//
//  Created by 白琴 on 16/2/1.
//  Copyright © 2016年 白琴. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/TencentApiInterface.h>

typedef enum : NSUInteger {
    LoginWithQQ, // 用QQ登录
    LoginWithSinaWeibo, // 用新浪微博登录
    LoginWithWeChat //用微信登录
} LoginWith;

@interface QQTools : NSObject <QQApiInterfaceDelegate>

@property (nonatomic, strong)TencentOAuth * tencentQAuth;

/**
 分享到空间

 @param image
 @param title
 @param description
 @param utf8String
 */
+ (void)shareToQQZoneWithImage:(UIImage *)image title:(NSString *)title description:(NSString *)description utf8String:(NSString *)utf8String;

/**
 分享到QQ好友

 @param image
 @param title
 @param description
 @param utf8String 
 */
+ (void)shareToQQWithImage:(UIImage *)image title:(NSString *)title description:(NSString *)description utf8String:(NSString *)utf8String;

@end
