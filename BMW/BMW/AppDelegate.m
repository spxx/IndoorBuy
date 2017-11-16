//
//  AppDelegate.m
//  BMW
//
//  Created by rr on 16/1/25.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
#import "JPushTools.h"
#import "RootTabBarVC.h"

#import <AlipaySDK/AlipaySDK.h>

//第三方登录
#import "QQTools.h"
#import "WXApi.h"
#import "WeChatTools.h"
#import "WeiboSDK.h"
#import "SinaWeiboTools.h"

#import "ShoppingCarViewController.h"
#import "LoginViewController.h"
#import "HomePageViewController.h"
#import "AccountModel.h"

@interface AppDelegate ()<UIAlertViewDelegate, WXApiDelegate, WeiboSDKDelegate,UITabBarControllerDelegate>
@property(nonatomic,strong)RootTabBarVC * rootVC;
@property (nonatomic, strong)TencentOAuth * tencentQAuth;
@property(nonatomic,assign)BOOL backEnterForeground;
@end

@implementation AppDelegate
#define JPUSH_APPKEY @"af245b72ecb3a5bb9490a7f7"
#define JPUSH_CHANNEL @"IndoorBuy"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //判断是否有登录
    [self isLogin];
    
    //注册微信
    [WXApi registerApp:WX_Key];
    //注册QQ
    TencentOAuth * tencent = [[TencentOAuth alloc] initWithAppId:QQ_APPKEY andDelegate:nil];
    self.tencentQAuth = tencent;
    //注册新浪微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:Sina_Key];
    
    //注册极光远程推送
    [JPushTools JPushRegisterForRemoteNotificationTypesWithOptions:launchOptions andAppkey:JPUSH_APPKEY andChannel:JPUSH_CHANNEL andApsForProduction:YES];
   
    
    
    RootTabBarVC * rootTabBarVC = [[RootTabBarVC alloc]init];
    rootTabBarVC.delegate = self;
    self.rootVC = rootTabBarVC;
    _window.rootViewController = rootTabBarVC;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    [_window makeKeyAndVisible];
    [NSThread sleepForTimeInterval:1.5];
    
    NSLog(@"微信  %@", WXApi.getApiVersion);
    NSLog(@"QQ  %@", TencentOAuth.sdkVersion);
    NSLog(@"微博  %@", WeiboSDK.getSDKVersion);
    
    return YES;
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UINavigationController *navc = (UINavigationController *)viewController;
    if ([navc.viewControllers.firstObject isKindOfClass:[ShoppingCarViewController class]]) {
        if (![JCUserContext sharedManager].isUserLogedIn) {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            loginVC.hidesBottomBarWhenPushed = YES;
//            loginVC.isPresent = YES;
//            UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
////            UIModalTransitionStyleFlipHorizontal 翻滚 UIModalTransitionStyleCrossDissolve
//            naVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [tabBarController.selectedViewController pushViewController:loginVC animated:YES];
            return NO;
        }
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //后台进入前端调用号外接口
    self.backEnterForeground = YES;
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -- Jpush  Action ---
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // 注册设备的 deviceToken
    NSLog(@"My token is: %@", deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
  //注册远程通知失败
    
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    //点击通知栏进入（iOS 6.0 及以下的消息处理）
    
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    //点击通知栏进入（iOS 7.0 及以上的消息处理）
   
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"newsChange" object:nil];
    if (self.backEnterForeground) {
        self.backEnterForeground = NO;
        [self.rootVC root_goToDetail:userInfo];
    }
    else{
        
    }
    
}

#pragma mark -- 判断是否登录
/**
 *  判断是否登录
 */
- (void)isLogin {
    NSDictionary * rememberUserInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"loggedInUserDetail"];
    NSString * member_id = [rememberUserInfo objectForKey:@"member_id"];
    if (member_id == nil) {
        NSLog(@"没有登录");
    }
    else {
        NSLog(@"登录过");
        [AccountModel requestForMCashWithUserID:member_id Complete:^(BOOL isSuccess, AccountModel *model, NSString *message) {
            if (isSuccess) {
                
            }else {
                Userentity * user = [[Userentity alloc] initWithJSONObject:rememberUserInfo];
                [[JCUserContext sharedManager] updateUserInfo:user];                
            }
        }];
    }
}

#pragma mark - QQ
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url] || [WeiboSDK handleOpenURL:url delegate:self] || [WXApi handleOpenURL:url delegate:self];
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([options[@"UIApplicationOpenURLOptionsSourceApplicationKey"] isEqualToString:@"com.tencent.mqq"]) {
        QQTools * qq = [[QQTools alloc] init];
        return [QQApiInterface handleOpenURL:url delegate:qq];
    }
    else if ([options[@"UIApplicationOpenURLOptionsSourceApplicationKey"] isEqualToString:@"com.sina.weibo"]) {
        SinaWeiboTools * sinaTools = [[SinaWeiboTools alloc] init];
        return [WeiboSDK handleOpenURL:url delegate:sinaTools];
    }
    else if ([options[@"UIApplicationOpenURLOptionsSourceApplicationKey"] isEqualToString:@"com.tencent.xin"]) {
        WeChatTools * wx = [[WeChatTools alloc] init];
        return [WXApi handleOpenURL:url delegate:wx];
    }
    else if ([options[@"UIApplicationOpenURLOptionsSourceApplicationKey"] isEqualToString:@"com.alipay.iphoneclient"]) {
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                NSDictionary * dic = @{@"code":resultDic[@"resultStatus"]};
                if([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]){
                    //成功
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPayResult" object:dic];
                }else if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"6001"]){
                    SHOW_MSG(@"取消了本次交易");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPayResult" object:dic];
                }else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPayResult" object:dic];
                }
            }];
        }
    }    
    return YES;
}


#pragma mark - 新浪微博
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    NSLog(@"新浪微博response ====  %@, code ==  %d", response, (int)response.statusCode);
    if ((int)response.statusCode == -1) {
        NSLog(@"新浪微博返回-1");
    }
    if ((int)response.statusCode == 0) {
        NSLog(@"新浪微博返回0");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}


@end
