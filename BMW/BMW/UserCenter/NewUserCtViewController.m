//
//  NewUserCtViewController.m
//  BMW
//
//  Created by rr on 2016/12/6.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "NewUserCtViewController.h"
#import "NewCTView.h"
#import "UserInfoViewController.h"
#import "SettingPageViewController.h"
#import "RegistViewController.h"
#import "MyOrderViewController.h"
#import "AddressListViewController.h"
#import "UserCollectListViewController.h"
#import "HelpAndFeedbackViewController.h"
#import "UserCouponViewController.h"
#import "NewsCenterViewController.h"
#import "SettingPageViewController.h"
//#import "BalancesViewController.h"
#import "GoodsDetailViewController.h"
#import "HomePageMoreViewController.h"
#import "CustomerserviceViewController.h"
#import "HomePageM.h"
#import "OpenShopViewController.h"
#import "MyshopSetViewController.h"
#import "OpenShopModel.h"
#import "JoinBangMaiViewController.h"
#import "IncomeViewController.h"
#import "MyBankCardViewController.h"
#import "AccountViewController.h"
#import "AccountModel.h"

#define kTEL_NUMBER @"400-100-3923"

@interface NewUserCtViewController ()<NewCTDelegate,UIAlertViewDelegate>
{
    NSMutableArray *_messageArray;
    NSDictionary * _adveringDic;
}

@property(nonatomic,strong)NewCTView *newctView;

@property (nonatomic, copy) NSString * freezeM; /**< 冻结的M币 */

@end

@implementation NewUserCtViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //self.navigationController.navigationBarHidden = YES;
    if ([JCUserContext sharedManager].isUserLogedIn) {
        [self getUserInfoRequest];
    }else{
        [self LoginView];
    }
    [self updateView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _messageArray = [NSMutableArray array];
    _adveringDic = [NSDictionary dictionary];
    [self initUserInterface];
}

-(void)initUserInterface{
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    _newctView = [[NewCTView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT-49+20)];
    _newctView.delegate = self;
    [self.view addSubview:_newctView];
}

-(void)updateView{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"BackGround" parameters:nil callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            [self.newctView updateBackGround:object[@"data"][@"image"]];
        }
    }];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"Advertising" parameters:nil callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            _adveringDic = object[@"data"];
            [self.newctView updateAdverHeight:object[@"data"][@"image"]];
        }else{
            [self.newctView updateAdverHeight:nil];
        }
    }];
}

/**
 *  显示登录视图
 */
-(void)LoginView{
    [_newctView notLoginView];
}

#pragma mark -- NEWCT
-(void)ViewRf{
    if ([JCUserContext sharedManager].isUserLogedIn) {
        [self getUserInfoRequest];
    }else{
        [self LoginView];
    }
    [self updateView];
}

-(void)clickImageGoto{
    if ([JCUserContext sharedManager].currentUserInfo.memberID) {
        UserInfoViewController * userInfoVC = [[UserInfoViewController alloc] init];
        userInfoVC.headerImage =_newctView.touxiangImage.image;
        userInfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }
    else {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

-(void)BtnProess{
    IncomeViewController *incomeVC = [[IncomeViewController alloc] init];
    incomeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:incomeVC animated:YES];
}


-(void)loginBtn{
    if ([JCUserContext sharedManager].isUserLogedIn) {
        if ([[JCUserContext sharedManager].currentUserInfo.drp_recommend boolValue]) {
            //分销商点击事件
            
        }else {
            switch ([[JCUserContext sharedManager].currentUserInfo.vip_level integerValue]) {
                case 0:{
                    OpenShopViewController *openShopVC = [[OpenShopViewController alloc] init];
                    openShopVC.title = @"成为麦咖";
                    openShopVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:openShopVC animated:YES];
                }
                    break;
                default:{
//                    MyshopSetViewController *setShopVC = [[MyshopSetViewController alloc] init];
//                    setShopVC.store_iamge = self.newctView.touxiangImage.image;
//                    setShopVC.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:setShopVC animated:YES];
                }
                    break;
            }
        }
    }else{
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

-(void)regisBtn{
    RegistViewController * registVC = [[RegistViewController alloc] init];
    registVC.hidesBottomBarWhenPushed = YES;
    registVC.isLoginPush = NO;
    [self.navigationController pushViewController:registVC animated:YES];
}

-(void)gotoProcess{
    NSLog(@"点击设置");
    SettingPageViewController *settingVC = [[SettingPageViewController alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

-(void)myorder{
    if ([JCUserContext sharedManager].currentUserInfo.memberID) {
        MyOrderViewController *myoderVC = [[MyOrderViewController alloc] init];
        myoderVC.orderState = @"0";
        myoderVC.navigationItem.hidesBackButton = YES;
        myoderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myoderVC animated:YES];
    }
    else {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
-(void)stateB:(NSString *)orderB{
    if ([JCUserContext sharedManager].currentUserInfo.memberID) {
        MyOrderViewController *myoderVC = [[MyOrderViewController alloc] init];
        myoderVC.orderState = orderB;
        myoderVC.hidesBottomBarWhenPushed = YES;
        myoderVC.navigationItem.hidesBackButton = YES;
        [self.navigationController pushViewController:myoderVC animated:YES];
    }
    else {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

-(void)adverProcess{
    switch ([_adveringDic[@"type"] integerValue]) {
        case 1:{
            //商品
            GoodsDetailViewController *goodsVC = [[GoodsDetailViewController alloc] init];
            goodsVC.goodsId = _adveringDic[@"link"];
            goodsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsVC animated:YES];
        }
            break;
        case 2:
            //分类
        {
            NSDictionary *dataSource = @{@"gc_id":_adveringDic[@"link"],@"gc_name":_adveringDic[@"name"]};
            HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
            homePageMoreVC.dataDIc = dataSource;
            homePageMoreVC.noThirdClass = YES;
            homePageMoreVC.navigationItem.hidesBackButton = YES;
            homePageMoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:homePageMoreVC animated:YES];
        }
            break;
        case 3:
            //品牌
        {
            HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
            homePageMoreVC.homePageMoreVCType = HomePageMoreVCMoreBrand;
            homePageMoreVC.brandName = _adveringDic[@"name"];
            homePageMoreVC.ID = _adveringDic[@"link"];
            homePageMoreVC.brandClassId = _adveringDic[@"class_id"];
            homePageMoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:homePageMoreVC animated:YES];
        }
            break;
        case 4:
            //优惠券
            break;
        case 5:
            //HTML
        {
            CustomerserviceViewController *htmlVC = [[CustomerserviceViewController alloc] init];
            htmlVC.htmlUrl = _adveringDic[@"link"];
            htmlVC.hidesBottomBarWhenPushed = YES;
            if([_adveringDic[@"link"] length]>0){
                [self.navigationController pushViewController:htmlVC animated:YES];
            }
        }
            break;
        case 6:{
            HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
            homePageMoreVC.homePageMoreVCType = HomePageMoreVCShopCar;
            homePageMoreVC.brandName = _adveringDic[@"name"];
            homePageMoreVC.goods_platform_only = _adveringDic[@"link"];
            homePageMoreVC.ID = homePageMoreVC.goods_platform_only;
            homePageMoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:homePageMoreVC animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)clickedMonthVewWithTag:(NSInteger)tag{
    switch (tag) {
        case 0:{
            NSLog(@"余额");
            if ([JCUserContext sharedManager].currentUserInfo.memberID) {
                AccountViewController * accountVC = [[AccountViewController alloc] init];
                accountVC.account = AccountM;
                accountVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:accountVC animated:YES];
            }else {
                LoginViewController * loginVC = [[LoginViewController alloc] init];
                loginVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        }
            break;
        case 1:{
            NSLog(@"优惠券列表");
            if ([JCUserContext sharedManager].currentUserInfo.memberID) {
                UserCouponViewController * userCouponVC = [[UserCouponViewController alloc] init];
                userCouponVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:userCouponVC animated:YES];
            }else {
                LoginViewController * loginVC = [[LoginViewController alloc] init];
                loginVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        }
            break;
        case 2:{
            NSLog(@"银行卡");
            if ([JCUserContext sharedManager].currentUserInfo.memberID) {
                MyBankCardViewController * myBankCarVC = [[MyBankCardViewController alloc] init];
                myBankCarVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:myBankCarVC animated:YES];
            }else {
                LoginViewController * loginVC = [[LoginViewController alloc] init];
                loginVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

-(void)didseletedTag:(NSInteger)tag{
    switch (tag) {
        case 0:{
            NSLog(@"收货地址");
            if ([JCUserContext sharedManager].currentUserInfo.memberID) {
                AddressListViewController * addressVC = [[AddressListViewController alloc] init];
                addressVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:addressVC animated:YES];
            }
            else {
                LoginViewController * loginVC = [[LoginViewController alloc] init];
                loginVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        }
            break;
        case 1: {
            NSLog(@"收藏");
            if ([JCUserContext sharedManager].currentUserInfo.memberID) {
                UserCollectListViewController * userCollectListVC = [[UserCollectListViewController alloc] init];
                userCollectListVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:userCollectListVC animated:YES];
            }
            else {
                LoginViewController * loginVC = [[LoginViewController alloc] init];
                loginVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        }
            break;
        case 2:{
            NSLog(@"客服");
            CustomerserviceViewController *custommerVC = [[CustomerserviceViewController alloc] init];
            custommerVC.hidesBottomBarWhenPushed = YES;
            custommerVC.title = @"在线客服";
            custommerVC.htmlUrl = @"https://chat16.live800.com/live800/chatClient/chatbox.jsp?companyID=600129&configID=122963&jid=6439855724&s=1";
            [self.navigationController pushViewController:custommerVC animated:YES];
        }
            break;
        case 3:{
            NSLog(@"帮助");
            HelpAndFeedbackViewController * helpAndFeedbackVC = [[HelpAndFeedbackViewController alloc] init];
            helpAndFeedbackVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:helpAndFeedbackVC animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)gotoMyStore{
    MyshopSetViewController *mySetStoreVC = [[MyshopSetViewController alloc] init];
    mySetStoreVC.store_iamge = self.newctView.touxiangImage.image;
    mySetStoreVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mySetStoreVC animated:YES];
}

-(void)gotoXiaoxi{
    NewsCenterViewController *newsVC = [[NewsCenterViewController alloc] init];
    if ([JCUserContext sharedManager].isUserLogedIn) {
        newsVC.newsCenterType = NewsCenterDefault;
    }
    else{
        newsVC.newsCenterType = NewsCenterVisitor;
    }
    newsVC.noticeDataSource = _messageArray;
    newsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsVC animated:YES];
}

- (void)processSetButton {
    SettingPageViewController *settingVC = [[SettingPageViewController alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}



#pragma mark -- 网络请求
- (void)getUserInfoRequest {
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetUserInfo" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSDictionary * data = object[@"data"];
            NSString * mCash = data[@"available_predeposit"];  // M币
            self.newctView.moneyCount.text = mCash;
            
            Userentity *user = [[Userentity alloc] initWithJSONObject:data];
            [[JCUserContext sharedManager] updateUserInfo:user];
            [self updateHeadView];
            if ([[JCUserContext sharedManager].currentUserInfo.vip_level integerValue]>0) {
                [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetMemberIncome" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
                    if (result == RequestResultSuccess) {
                        [_newctView updateMystore:object[@"data"]];
                    }
                }];
            }
        }
    }];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"MessageTit" parameters:@{} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSArray *array = object[@"data"];
            NSMutableArray *messArray = [NSMutableArray array];
            for (int i = 0; i < array.count; i ++) {
                NSMutableDictionary * messDic = [NSMutableDictionary dictionaryWithDictionary:array[i]];
                if (messDic[@"message_url"] == [NSNull null]) {
                    [messDic setObject:@" " forKey:@"message_url"];
                }
                [messArray addObject:messDic];
            }
            _messageArray = messArray;
            [[NSUserDefaults standardUserDefaults]setObject:_messageArray forKey:@"message"];
        }else if(result == RequestResultEmptyData){
            [_messageArray removeAllObjects];
        }else{
            _messageArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"message"];
        }
    }];
    
    [HomePageM requestForNews:^(BOOL ishave) {
        [self refreshNews:ishave];
    }];
    
    //更新订单数量
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"OrderNumber" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSDictionary * data = object[@"data"];

            [self.newctView updateNumOrder:data];
            self.newctView.coupCount.text = [NSString stringWithFormat:@"%@", data[@"voucher"]];        // 更新优惠券
            self.newctView.bankCount.text = [NSString stringWithFormat:@"%@", data[@"cashcard_num"]];   // 更新银行卡数量
        }
    }];
    
}

-(void)updateHeadView{
    [self.newctView isloginView];
}

-(void)refreshNews:(BOOL )have{
    [self.newctView newsArray:have];
}





@end
