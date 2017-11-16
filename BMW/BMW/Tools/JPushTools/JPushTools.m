//
//  JPushTools.m
//  MyPush
//
//  Created by gukai on 16/2/1.
//  Copyright © 2016年 gukai. All rights reserved.
//

#import "JPushTools.h"
#import "JPUSHService.h"
#import <UIKit/UIKit.h>

@implementation JPushTools
+(void)JPushRegisterForRemoteNotificationTypesWithOptions:(NSDictionary *)launchOptions andAppkey:(NSString *)appkey andChannel:(NSString *)channel andApsForProduction:(BOOL)apsForProduction
{
    // Required
#ifdef __IPHONE_8_0
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
#endif
    // Required
    [JPUSHService setupWithOption:launchOptions appKey:appkey channel:channel apsForProduction:apsForProduction]; //如需兼容旧版本的方式，请继续使用[JPUSHService setupWithOption:launchOptions]初始化方法和添加pushConfig.plist文件声明AppKey等配置内容。
}
@end
