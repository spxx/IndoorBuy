//
//  RootTabBarVC.m
//  BMW
//
//  Created by rr on 16/2/17.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "RootTabBarVC.h"
#import "JPUSHService.h"
//#import "HomePageViewController.h"
#import "HomePageVC.h"
#import "ClassificationViewController.h"
#import "ShoppingCarViewController.h"
//#import "UserCenterViewController.h"
#import "NewUserCtViewController.h"
#import "DetailViewController.h"
#import "SHCGuideViewController.h"

#import "BaseNaVC.h"

#import "OrderDetailViewController.h"//订单详情
#import "ShowLogisticsInformationViewController.h"//物流界面
#import "ServicesProgressVC.h"//服务单
#import "ApplyRIntroductionsViewController.h"// 通知消息
#import "CustomerserviceViewController.h"//公告消息

#import "UITabBar+BadgeColor.h"

@interface RootTabBarVC ()


@property (nonatomic, retain)Reachability * conn;


@end

@implementation RootTabBarVC

- (void)dealloc
{
    [self.conn stopNotifier];
    [self removeJPushNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.conn startNotifier];
    [self initUserInterface];
    [self initJPushNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shoppCarNum) name:@"shoppcarNum" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkState) name:kReachabilityChangedNotification object:nil];
   
    [self shoppCarNum];
}

-(void)shoppCarNum{
    //购物车数量
    if ([JCUserContext sharedManager].isUserLogedIn) {
        [BaseRequset sendPOSTRequestWithBMWApi2Method:@"CartNum" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
            if (result==RequestResultSuccess) {
                if([[NSString stringWithFormat:@"%@",object[@"data"]] isEqualToString:@""]){
                    [self updateShopNum:@""];
                }else{
                    [self updateShopNum:[NSString stringWithFormat:@"%@",object[@"data"]]];
                }
            }else if (result==RequestResultEmptyData){
                [self updateShopNum:@""];
            }
        }];
    }
}

-(MBProgressHUD *)HUD{
    if (!_HUD) {
        _HUD = [[MBProgressHUD alloc] init];
        _HUD.opacity = 0.5;
        _HUD.mode = MBProgressHUDModeIndeterminate;
        [self.view addSubview:_HUD];
        return _HUD;
    }else{
        return _HUD;
    }
}

-(void)initUserInterface{
    
    HomePageVC * homePageVC = [[HomePageVC alloc]init];
    
    ClassificationViewController *classificationVC = [[ClassificationViewController alloc] init];
    classificationVC.title = @"分类";
    
    ShoppingCarViewController *shoppcarVC = [[ShoppingCarViewController alloc] init];
    shoppcarVC.title = @"购物车";
    
    NewUserCtViewController * userCenterVC = [[NewUserCtViewController alloc]init];
    userCenterVC.title = @"我的";
    
    BaseNaVC * homePageNaVC =[[BaseNaVC alloc]initWithRootViewController:homePageVC];
    homePageNaVC.navigationBar.translucent = NO;
    homePageNaVC.navigationBar.barTintColor = COLOR_NAVIGATIONBAR_BARTINT;

    BaseNaVC * classificationNaVC =[[BaseNaVC alloc]initWithRootViewController:classificationVC];
    classificationNaVC.navigationBar.translucent = NO;
    classificationNaVC.navigationBar.barTintColor = COLOR_NAVIGATIONBAR_BARTINT;
    
    BaseNaVC * shoppingcarNaVC =[[BaseNaVC alloc]initWithRootViewController:shoppcarVC];
    shoppingcarNaVC.navigationBar.translucent = NO;
    shoppingcarNaVC.navigationBar.barTintColor = COLOR_NAVIGATIONBAR_BARTINT;

    BaseNaVC * userCenterNaVC =[[BaseNaVC alloc]initWithRootViewController:userCenterVC];
    userCenterNaVC.navigationBar.translucent = NO;
    userCenterNaVC.navigationBar.barTintColor = COLOR_NAVIGATIONBAR_BARTINT;
    
    self.viewControllers = @[homePageNaVC,classificationNaVC,shoppingcarNaVC,userCenterNaVC];
    
    UITabBarItem * homePageItem = [[UITabBarItem alloc]initWithTitle:@"帮麦网" image:[[UIImage imageNamed:@"tab_bangmaiwang_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_bangmaiwang_cli.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UITabBarItem * classificationItem = [[UITabBarItem alloc]initWithTitle:@"分类" image:[[UIImage imageNamed:@"tab_fenlei_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_fenlei_cli.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UITabBarItem * shoppingcarItem = [[UITabBarItem alloc]initWithTitle:@"购物车" image:[[UIImage imageNamed:@"tab_gouwuche_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_gouwuche_cli.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UITabBarItem * userCenterItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:[[UIImage imageNamed:@"tab_wode_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"tab_wode_cli.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [homePageItem setTitlePositionAdjustment:UIOffsetMake(0, -4)];
    [classificationItem setTitlePositionAdjustment:UIOffsetMake(0, -4)];
    [shoppingcarItem setTitlePositionAdjustment:UIOffsetMake(0, -4)];
    [userCenterItem setTitlePositionAdjustment:UIOffsetMake(0, -4)];
    
    homePageNaVC.tabBarItem = homePageItem;
    classificationNaVC.tabBarItem = classificationItem;
    shoppingcarNaVC.tabBarItem = shoppingcarItem;
    userCenterNaVC.tabBarItem = userCenterItem;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary
                                                       dictionaryWithObjectsAndKeys:
                                                       COLOR_TABBARTEXTCOLOR_S,NSForegroundColorAttributeName,
                                                       FONT_HEITI_TC(10),NSFontAttributeName
                                                       , nil]
                                             forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary
                                                       dictionaryWithObjectsAndKeys:
                                                       COLOR_TABBARTEXTCOLOR_N,NSForegroundColorAttributeName,
                                                       FONT_HEITI_TC(10),NSFontAttributeName
                                                       , nil]
                                             forState:UIControlStateNormal];

    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_NAVIGATIONBARTEXTCOLOR}];
    
    self.tabBar.backgroundColor = COLOR_TABBARTINTCOLOR;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

-(void)updateShopNum:(NSString *)Number{
    UINavigationController *shoppNAVC = self.viewControllers[2];
    if ([Number isEqualToString:@""]) {
        [shoppNAVC.tabBarController.tabBar hideBadgeOnItemIndex];
    }else{
        if ([Number intValue]>99) {
            [shoppNAVC.tabBarController.tabBar showBadgeOnItemIndex:99];
        }else{
            [shoppNAVC.tabBarController.tabBar showBadgeOnItemIndex:[Number intValue]];
        }

    }
}
 
-(void)root_goToDetail:(NSDictionary *)info
{
    //收到自定义消息
    NSLog(@"%@",info);
    
    UINavigationController * navc  =  (UINavigationController *)self.selectedViewController;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newsChange" object:nil];
    NSString * type = info[@"type"];
    NSString * ID = info[@"id"];
    switch ([type integerValue]) {
        case 1:{
            NSLog(@"订单消息");
            
            OrderDetailViewController * orderDetailVC = [[OrderDetailViewController alloc]init];
            orderDetailVC.orderId = ID;
            orderDetailVC.hidesBottomBarWhenPushed = YES;
           [navc pushViewController:orderDetailVC animated:YES];
            
        }
            break;
        case 2:{
            NSLog(@"物流消息");
            
            ShowLogisticsInformationViewController * logisticsInfoVC = [[ShowLogisticsInformationViewController alloc]init];
            logisticsInfoVC.orderId = ID;
            logisticsInfoVC.hidesBottomBarWhenPushed = YES;
            [navc pushViewController:logisticsInfoVC animated:YES];
        }
            break;
        case 3:{
            NSLog(@"通知消息");
            [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetMessage" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"id":ID,@"type":@"2"} callBack:^(RequestResult result, id object) {
                NSLog(@"%@",object);
                if (result == RequestResultSuccess) {
                    ApplyRIntroductionsViewController *applyIntro = [[ApplyRIntroductionsViewController alloc] init];
                    applyIntro.title = object[@"data"][@"title"];
                    applyIntro.contentString = object[@"data"][@"body"];
                    applyIntro.hidesBottomBarWhenPushed = YES;
                    [navc pushViewController:applyIntro animated:YES];
                 }
               }];
            
        }
            break;
        case 4:{
            NSLog(@"服务单消息");
            ServicesProgressVC * servicesProgressVC = [[ServicesProgressVC alloc]init];
            servicesProgressVC.serviceId = ID;
            servicesProgressVC.hidesBottomBarWhenPushed = YES;
            [navc pushViewController:servicesProgressVC animated:YES];
            
        }
            break;
        case 5:{
            NSLog(@"公告消息");
            [BaseRequset sendPOSTRequestWithBMWApi2Method:@"MessageCon" parameters:@{@"messageId":ID} callBack:^(RequestResult result, id object) {
                if (result == RequestResultSuccess) {
                    CustomerserviceViewController *Message = [[CustomerserviceViewController alloc] init];
                    Message.title = @"公告";
                    Message.htmlString = object[@"data"][@"body"];
                    Message.hidesBottomBarWhenPushed = YES;
                    [navc pushViewController:Message animated:YES];
                    
                }
            }];
            
        }
            break;
            
        default:
            break;
    }
}
-(void)initJPushNotification
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];
}
-(void)removeJPushNotification
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidSetupNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidCloseNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidRegisterNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidLoginNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidReceiveMessageNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFServiceErrorNotification
                           object:nil];
}
#pragma mark -- JPush Action --
- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"连接");
    
}

- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"未连接。。。") ;
    
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"%@", [notification userInfo]);
    NSLog(@"已注册"); }

- (void)networkDidLogin:(NSNotification *)notification {
    NSLog(@"已登录");
    
    if ([JPUSHService registrationID]) {
        NSString * registrationID = [JPUSHService registrationID];
        [JCUserContext sharedManager].pushKey = registrationID;
        NSLog(@"%@",registrationID);
        NSLog(@"get RegistrationID");
    }
}

- (void)networkDidReceiveMessage:(NSNotification *)notification{
    //收到自定义消息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newsChange" object:nil];
    
}
- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"%@", error);
}

#pragma mark -- 网络监控 --
-(void)checkNetworkState
{
    [self checkConnection:^(ConnectionType type) {
        if (type == ConnectionTypeNone ) {
            NSLog(@"无网");
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"网络好像出现问题了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else if (type == ConnectionTypeWifi){
            NSLog(@"wifi");
           
        }
        else if (type == ConnectionTypeData){
            NSLog(@"2g/3g");
        }
    }];
}
#pragma mark -- 检测网络
- (void)checkConnection:(CheckConnection)checkResult
{
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForInternetConnection];
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        NSLog(@"有wifi");
        checkResult(ConnectionTypeWifi);
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        NSLog(@"使用手机自带网络进行上网");
        checkResult(ConnectionTypeData);
    } else { // 没有网络
        NSLog(@"没有网络");
        checkResult(ConnectionTypeNone);
    }
}
- (Reachability *)conn
{
    if (!_conn) {
        _conn = [Reachability reachabilityForInternetConnection];
    }
    return _conn;
}




@end
