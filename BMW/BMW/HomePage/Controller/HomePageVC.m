//
//  HomePageVC.m
//  BMW
//
//  Created by rr on 2016/12/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "HomePageVC.h"
#import "HomePageView.h"
#import "SHCGuideViewController.h"
#import "HomePageM.h"
#import "ADModel.h"
#import "BargainViewController.h"
#import "GoodsDetailViewController.h"
#import "HomePageMoreViewController.h"
#import "CustomerserviceViewController.h"
#import "NewsCenterViewController.h"
#import "HomeSearchViewController.h"
#import "InvitationViewController.h"
#import "StoreDetailViewController.h"

#import "CouponCenterViewController.h"
#import "OilCardViewController.h"
#import "GoinShopViewController.h"
#import "ShareView.h"
#import "CreateCodeVC.h"

@interface HomePageVC ()<HomePageDelegate,ShareVeiwDelegate>
{
    HomePageView *_homePageView;
    HomePageM *_homePM;
}

@property (nonatomic, retain) HomePageM * storeModel;
@property (nonatomic, strong) NSMutableArray * rollModels;      /**< 保存请求下来的滚动广告 */
@end

@implementation HomePageVC

#pragma mark -- 生命周期
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if ([JCUserContext sharedManager].isUserLogedIn) {
        if (![[JCUserContext sharedManager].currentUserInfo.drp_recommend boolValue]) {
            if ([[JCUserContext sharedManager].currentUserInfo.vip_level integerValue]==0) {
                if(![[JCUserContext sharedManager].currentUserInfo.store_id boolValue]){
                    GoinShopViewController *goinVC = [[GoinShopViewController alloc] init];
                    goinVC.hidesBottomBarWhenPushed = YES;
                    goinVC.navigationController.navigationItem.hidesBackButton = YES;
                    [self.navigationController pushViewController:goinVC animated:YES];
                }
            }
        }
    }
    [_homePageView startAnimation];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_homePageView pauseAnimation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _homePM = [[HomePageM alloc] init];
    [self initData];
    [self initUserInterface];
    [self customNavigationBar];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsButtonChange) name:@"newsChange" object:nil];
    //将当前版本号存下来，如果有判断是否最新YES走广告NO走本地
    NSString * userGuideKey = [@"hello" stringByAppendingString:@"1.0"];
    if (![[NSUserDefaults standardUserDefaults]objectForKey:userGuideKey]) {
        SHCGuideViewController *guidVC = [SHCGuideViewController new];
        [guidVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:guidVC animated:YES completion:^{
        }];
    }else{
        NSString *indexBanben = [[NSUserDefaults standardUserDefaults]objectForKey:userGuideKey];
        if ([indexBanben isEqualToString:@"1.0"]) {
        }else{
            //显示本地
            SHCGuideViewController *guidVC = [SHCGuideViewController new];
            [guidVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:guidVC animated:YES completion:^{
                [[NSUserDefaults standardUserDefaults]setObject:@"1.0" forKey:userGuideKey];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }];
        }
    }
}

-(void)initData
{
    [self.HUD show:YES];
    [HomePageM requestForAdverListWithComplete:^(NSArray *models, NSString *message, NSInteger code) {
        [self.HUD hide:YES];
        [_homePageView endRefresh];
        if (code == 100) {
            NSLog(@"%@",models);
            _homePM.adverImageArray = models;
        }else if(code == 902){
            SHOW_MSG(@"暂无数据");
        }else{
            _homePM.adverImageArray = models;
        }
        _homePageView.models = _homePM;
    }];
    [HomePageM requestForGoodsListWithComplete:^(NSArray *models, NSString *message, NSInteger code) {
        [self.HUD hide:YES];
        [_homePageView endRefresh];
        if (code == 100) {
            _homePM.goodsModels = models;
        }else if(code == 902){
            SHOW_MSG(@"暂无数据");
        }else{
            _homePM.goodsModels = models;
        }
        _homePageView.models = _homePM;
    }];
    
    [HomePageM requestForNews:^(BOOL ishave) {
        _homePageView.showRedPoint = ishave;
    }];
    [HomePageM requestGetNewsArray:^(NSArray *messageArray) {
        _homePM.newsArray = messageArray;
    }];
    
    [ADModel adRequestWithComplete:^(NSMutableArray<ADModel *> *models, NSString *message, NSInteger code) {
        _homePageView.ADModels = models;
    }];
    [ADModel requestForRollADListWithComplete:^(BOOL isSuccess, NSMutableArray *models, NSString *message) {
        _homePageView.rollModels = models;
    }];
    
//    // 获取店铺logo
//    [HomePageM requestForStoreLogoWithComplete:^(HomePageM * model) {
//        self.storeModel = model;
//        _homePageView.logoModel = model;
//    }];
}

-(void)initUserInterface{
    _homePageView = [[HomePageView alloc] initWithFrame:self.view.frame];
    _homePageView.delegate = self;
    [self.view addSubview:_homePageView];
}

-(void)newsButtonChange{
    
}

#pragma mark -- HomePageDelegate
-(void)homePageViewRefreshAction
{
    [self initData];
}


-(void)clickShare
{
    //分享
    if (![JCUserContext sharedManager].isUserLogedIn) {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        loginVC.isRegistPush = NO;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    ShareView * shareView = [[ShareView alloc] initWithTitle:@"整个店铺" QRCode:YES];
    shareView.delegate = self;
    [self.view.window addSubview:shareView];
}

#pragma mark -- ShareViewDelegate --
- (void)shareView:(ShareView *)shareView chooseItemWithDestination:(Share3RDParty)destination
{
    UIImage * shareImage = IMAGEWITHNAME(@"classifyAll.jpg");

    NSString * shareUrl = nil;
    if ([[JCUserContext sharedManager].currentUserInfo.drp_recommend boolValue]) {
        shareUrl = SHAREURL_DRP(SHOP, [JCUserContext sharedManager].currentUserInfo.drp_recommend, @"");
    }else{
        shareUrl = SHAREURL_MEMBER(SHOP, [JCUserContext sharedManager].currentUserInfo.memberID, @"");
    }
    NSString * goodsName = @"帮麦网";
    switch (destination) {
        case ShareWXSession:
            NSLog(@"微信好友");
            [ShareTools respondsShareWeiXin:@0
                                      image:shareImage
                                      title:BMW_TITLE
                                description:goodsName
                                 webpageUrl:shareUrl];
            break;
        case ShareWXFriend:
            NSLog(@"微信朋友圈");
            [ShareTools respondsShareWeiXin:@1
                                      image:shareImage
                                      title:BMW_TITLE
                                description:goodsName
                                 webpageUrl:shareUrl];
            break;
            
        case ShareSina:
            NSLog(@"新浪");
            [ShareTools respondsShareWeiboWithRedirectUrl:@"https://www.indoorbuy.com"
                                                    scope:@"all"
                                                     text:[NSString stringWithFormat:@"%@。%@。%@",BMW_TITLE, goodsName, shareUrl]
                                                 objectID:@""
                                               shareImage:shareImage];
            break;
        case ShareQQ:
            NSLog(@"QQ");
            [ShareTools respondsShareQQWithShareTitle:BMW_TITLE
                                             shareUrl:shareUrl
                                     shareDescription:goodsName
                                           shareImage:shareImage];
            break;
        case ShareQQZone:
            NSLog(@"QQ空间");
            [ShareTools respondsShareQQZoneWithShareTitle:BMW_TITLE
                                                 shareUrl:shareUrl
                                         shareDescription:goodsName
                                               shareImage:shareImage];
            break;
        case ShareCreatCode:{
            NSLog(@"生成二维码");
            CreateCodeVC * codeVC = [[CreateCodeVC alloc] init];
            codeVC.hidesBottomBarWhenPushed = YES;
            codeVC.titleStr = goodsName;
            codeVC.shareUrl = shareUrl;
            [self.navigationController pushViewController:codeVC animated:YES];
        }
            break;
        default:
            break;
    }
}



// 点击店铺logo
-(void)clickMyShop
{
    if (self.storeModel.drp == 1) {
        // 分销商不能查看店铺
        return;
    }
    StoreDetailViewController *storeDetialVC = [[StoreDetailViewController alloc] init];
    storeDetialVC.hidesBottomBarWhenPushed = YES;
    storeDetialVC.storeID = self.storeModel.storeID;
    storeDetialVC.storeType = self.storeModel.storeType;
    [self.navigationController pushViewController:storeDetialVC animated:YES];
}

// 点击消息
-(void)homePageViewClickedMessageAction{
    NewsCenterViewController *newsVC = [[NewsCenterViewController alloc] init];
    if ([JCUserContext sharedManager].isUserLogedIn) {
        newsVC.newsCenterType = NewsCenterDefault;
    }
    else{
        newsVC.newsCenterType = NewsCenterVisitor;
    }
    newsVC.noticeDataSource = _homePM.newsArray;
    newsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsVC animated:YES];
}

// 点击搜索
-(void)homePageViewClickedSearchAction{
    HomeSearchViewController *homeSearch = [[HomeSearchViewController alloc] init];
    homeSearch.navigationItem.hidesBackButton = YES;
    homeSearch.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeSearch animated:YES];
}

// 点击标签
- (void)homePageView:(HomePageView *)homePageView clickedClassWithTag:(NSInteger)tag{
    switch (tag) {
        case 0:{
            //邀请有礼
            if ([JCUserContext sharedManager].isUserLogedIn) {
                InvitationViewController *inviVC = [[InvitationViewController alloc] init];
                inviVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:inviVC animated:YES];
            }else{
                LoginViewController * loginVC = [[LoginViewController alloc] init];
                loginVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        }
            break;
        case 1:{
            //领券中心
            if ([JCUserContext sharedManager].currentUserInfo.memberID) {
                CouponCenterViewController * couponVC = [[CouponCenterViewController alloc] init];
                couponVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:couponVC animated:YES];
            }else {
                LoginViewController * loginVC = [[LoginViewController alloc] init];
                loginVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        }
            break;
        case 2:{
            //油卡兑换
            if ([JCUserContext sharedManager].currentUserInfo.memberID) {
                OilCardViewController * oilCardVC = [[OilCardViewController alloc] init];
                oilCardVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:oilCardVC animated:YES];
            }else {
                LoginViewController * loginVC = [[LoginViewController alloc] init];
                loginVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        }
            break;
        case 3:{
            //特惠上新
            BargainViewController * bargainVC = [[BargainViewController alloc]init];
            bargainVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bargainVC animated:YES];
        }
            break;
        default:
            break;
    }
}

// 轮播图
-(void)homePageView:(HomePageView *)homePageView didSelectedItemWithBanner:(NSDictionary *)banner{
    NSLog(@"跳转内容");
    switch ([banner[@"type"] integerValue]) {
        case 1:{
            //商品
            GoodsDetailViewController *goodsVC = [[GoodsDetailViewController alloc] init];
            goodsVC.goodsId = banner[@"link"];
            goodsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsVC animated:YES];
        }
            break;
        case 2:
            //分类
        {
            NSDictionary *dataSource = @{@"gc_id":banner[@"link"],@"gc_name":banner[@"className"]};
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
            homePageMoreVC.brandName = banner[@"brand_name"];
            homePageMoreVC.ID = banner[@"link"];
            homePageMoreVC.brandClassId = banner[@"class_id"];
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
            htmlVC.htmlUrl = [banner objectForKeyNotNull:@"link"];
            htmlVC.hidesBottomBarWhenPushed = YES;
            if ([[banner objectForKeyNotNull:@"link"] length] > 0) {
                [self.navigationController pushViewController:htmlVC animated:YES];
            }
        }
            break;
        case 6:{
            HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
            homePageMoreVC.homePageMoreVCType = HomePageMoreVCShopCar;
            homePageMoreVC.brandName = banner[@"platName"];
            homePageMoreVC.goods_platform_only = banner[@"link"];
            homePageMoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:homePageMoreVC animated:YES];
        }
        default:
            break;
    }
}

// 快报
- (void)homePageView:(HomePageView *)homePageView clickedADRollWithADModel:(ADModel *)adModel
{
    switch (adModel.messageType.integerValue) {
        case 0:{
            //外部链接
            if([adModel.messageUrl length] > 0){
                CustomerserviceViewController *htmlVC = [[CustomerserviceViewController alloc] init];
                htmlVC.htmlUrl = adModel.messageUrl;
                htmlVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:htmlVC animated:YES];
            }else {
                SHOW_EEROR_MSG(@"未找到相关信息");
            }
        }
            break;
        case 1:{
            //商品
            GoodsDetailViewController *goodsVC = [[GoodsDetailViewController alloc] init];
            goodsVC.goodsId = adModel.messageUrl;
            goodsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsVC animated:YES];
        }
            break;
        case 2:{
            // 分类
            NSDictionary *dataSource = @{@"gc_id":adModel.messageUrl,@"gc_name":adModel.name};
            HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
            homePageMoreVC.dataDIc = dataSource;
            homePageMoreVC.noThirdClass = YES;
            homePageMoreVC.navigationItem.hidesBackButton = YES;
            homePageMoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:homePageMoreVC animated:YES];
        }
            break;
        case 3:{
            //品牌
            HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
            homePageMoreVC.homePageMoreVCType = HomePageMoreVCMoreBrand;
            homePageMoreVC.brandName = adModel.name;
            homePageMoreVC.ID = adModel.messageUrl;
            homePageMoreVC.brandClassId = adModel.classId;
            homePageMoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:homePageMoreVC animated:YES];
        }
            break;
        case 4:{
            // 标签
            HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
            homePageMoreVC.homePageMoreVCType = HomePageMoreVCShopCar;
            homePageMoreVC.brandName = adModel.name;
            homePageMoreVC.goods_platform_only = adModel.messageUrl;
            homePageMoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:homePageMoreVC animated:YES];
        }
            break;
        case 5:{
            // 公告文本
            [HomePageM requestForMessageWithID:adModel.messageID complete:^(BOOL isSuccess, NSString *text, NSString *message) {
                if (isSuccess) {
                    CustomerserviceViewController *Message = [[CustomerserviceViewController alloc] init];
                    Message.title = @"公告";
                    Message.htmlString = text;
                    Message.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:Message animated:YES];
                }else {
                    SHOW_EEROR_MSG(message);
                }
            }];
        }
            break;
        default:
            break;
    }
}

// 广告图
-(void)homePageView:(HomePageView *)homePageView clickedADPicWithADModel:(ADModel *)admodel{
    switch ([admodel.type integerValue]) {
        case 1:{
            //商品
            GoodsDetailViewController *goodsVC = [[GoodsDetailViewController alloc] init];
            goodsVC.goodsId = admodel.link;
            goodsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsVC animated:YES];
        }
            break;
        case 2:
            //分类
        {
            NSDictionary *dataSource = @{@"gc_id":admodel.link,@"gc_name":admodel.className};
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
            homePageMoreVC.brandName = admodel.brandName;
            homePageMoreVC.ID = admodel.link;
            homePageMoreVC.brandClassId = admodel.classId;
            homePageMoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:homePageMoreVC animated:YES];
        }
            break;
        case 4: {
            HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
            homePageMoreVC.homePageMoreVCType = HomePageMoreVCShopCar;
            homePageMoreVC.brandName = admodel.platName;
            homePageMoreVC.goods_platform_only = admodel.link;
            homePageMoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:homePageMoreVC animated:YES];
        }
            break;
        case 5:
            //HTML
        {
            CustomerserviceViewController *htmlVC = [[CustomerserviceViewController alloc] init];
            htmlVC.htmlUrl = admodel.link;
            htmlVC.hidesBottomBarWhenPushed = YES;
            if([admodel.link length]>0){
                [self.navigationController pushViewController:htmlVC animated:YES];
            }
        }
            break;
        case 6:{
            HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
            homePageMoreVC.homePageMoreVCType = HomePageMoreVCShopCar;
            homePageMoreVC.brandName = admodel.platName;
            homePageMoreVC.goods_platform_only = admodel.link;
            homePageMoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:homePageMoreVC animated:YES];
        }
            break;
        default:
            break;
    }
}


-(void)homePageView:(HomePageView *)homePageView clickedMoreWithClassModel:(NSDictionary *)classModel{
    HomePageMoreViewController *homePgeMVC = [[HomePageMoreViewController alloc] init];
    homePgeMVC.dataDIc = classModel;
    homePgeMVC.hidesBottomBarWhenPushed = YES;
    homePgeMVC.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:homePgeMVC animated:YES];
}

- (void)homePageView:(HomePageView *)homePageView didSelectedItemWithGoodsModel:(NSDictionary *)dataDic{
    NSString * goodId = [NSString stringWithFormat:@"%@",dataDic[@"goods_id"]];
    GoodsDetailViewController * goodsDetailVC =[[GoodsDetailViewController alloc]init];
    goodsDetailVC.goodsId = goodId;
    goodsDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}


@end

