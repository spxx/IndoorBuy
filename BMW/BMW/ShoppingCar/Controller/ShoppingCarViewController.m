//
//  ShoppingCarViewController.m
//  BMW
//
//  Created by rr on 16/3/1.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ShoppingCarViewController.h"
#import "ShoppingCarSettlementViewController.h"
#import "GoodsDetailViewController.h"
#import "LoginViewController.h"
#import "VIPIntroductionsViewController.h"
#import "UserCollectListViewController.h"
#import "ShoppingCarView.h"
#import "HomePageMoreViewController.h"
#import "CustomerserviceViewController.h"
#import "UITabBar+BadgeColor.h"

#import "OpenShopViewController.h"

@interface ShoppingCarViewController ()<NoNetDelegate, ShoppingViewDelegate>

@property (nonatomic, strong) UIButton * editBtn;

@property (nonatomic, strong) ShoppingCarView * shoppingCarView;

@property (nonatomic, copy) NSMutableArray * selectedGoods;       /**< 选中商品 */
@property (nonatomic, copy) NSMutableArray * selectedGoodsIDs;    /**< 选中商品的ID */

@property (nonatomic, copy) NSString * totalCash;
@property (nonatomic, copy) NSString * saveCash;
@property (nonatomic, copy) NSString * beVipSave;
@property (nonatomic, retain) GoodsListModel * carPriceModel;       /**< 存储计算价格 */
@property (nonatomic, assign) NSInteger carNum;                     /**< 购物车商品种类数量 */

@property (nonatomic, copy) NSString * carCountNum;                     /**< 购物车数量 */

@property (nonatomic, strong) NSDictionary *activityDic; /**< 活动 */



@end

@implementation ShoppingCarViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUserInterface];
    [self customNavigationBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetWorkingState) name:kReachabilityChangedNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 刷新数据时 检查是否有网络
    [self checkConnection:^(ConnectionType type) {
        if (type == ConnectionTypeNone ) {
            NSLog(@"无网");
            [self showNoNetOnView:self.view frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) type:NoNetDefault delegate:self];
        }
        else if (type == ConnectionTypeWifi){
            NSLog(@"wifi");
            
        }
        else if (type == ConnectionTypeData){
            NSLog(@"2g/3g");
        }
    }];

    [self requsetForCarList];
    if ([[JCUserContext sharedManager].currentUserInfo.drp_recommend boolValue]) {
        self.shoppingCarView.isMember = YES;
    }else {
        switch ([[JCUserContext sharedManager].currentUserInfo.vip_level integerValue]) {
            case 0:{
                self.shoppingCarView.isMember = NO;
            }
                break;
            default:{
                self.shoppingCarView.isMember = YES;
            }
                break;
        }
    }

}

#pragma mark -- notification
- (void)checkNetWorkingState
{
    [self checkConnection:^(ConnectionType type) {
        if (type == ConnectionTypeNone ) {
            NSLog(@"无网");
            [self showNoNetOnView:self.view frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) type:NoNetDefault delegate:self];
        }
        else if (type == ConnectionTypeWifi){
            NSLog(@"wifi");
            
        }
        else if (type == ConnectionTypeData){
            NSLog(@"2g/3g");
        }
    }];
}

#pragma mark -- UI
- (void)initUserInterface
{
    // 用于存储已选中的商品
    _selectedGoods = [NSMutableArray array];
    _selectedGoodsIDs = [NSMutableArray array];
    
    _shoppingCarView = [[ShoppingCarView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight - 49 - 64)];
    _shoppingCarView.delegate = self;
    [self.view addSubview:_shoppingCarView];

    [_shoppingCarView hideTopView];
}

-(void)customNavigationBar
{
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
    titleView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    self.navigationItem.titleView = titleView;
    
    _editBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-45, 0, 30, 44)];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitle:@"完成" forState:UIControlStateSelected];
    _editBtn.titleLabel.font = fontForSize(15);
    [_editBtn setTitleColor:COLOR_NAVIGATIONBAR_ITEM forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [_editBtn sizeToFit];
    _editBtn.viewHeight = 44;
    [titleView addSubview:_editBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    titleLabel.text = @"购物车";
    titleLabel.textColor = COLOR_NAVIGATIONBARTEXTCOLOR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = fontBoldForSize(17);
    [titleView addSubview:titleLabel];
}

// 刷新底部结算视图
- (void)updateBottomView
{
    // 计算价格
    
    // 是否是全选
    BOOL all = NO;
    if (self.selectedGoods.count >= 1) {
        self.shoppingCarView.settleBtnEnable = YES;
        if (self.carNum == self.selectedGoods.count) {
            all = YES;
        }
    }else {
        self.shoppingCarView.settleBtnEnable = NO;
        self.totalCash = @"0.00";
        self.saveCash  = @"0.00";
        self.beVipSave = @"0.00";
        self.carPriceModel.totalCash = self.totalCash;
        self.carPriceModel.saveCash  = self.saveCash;
        self.carPriceModel.beVipSave = self.beVipSave;
    }
    [self.shoppingCarView updateBottomViewWithModel:self.carPriceModel
                                             amount:self.selectedGoods.count
                                                all:all];
}

#pragma mark -- 获取数据
- (void)requsetForCarList
{
    self.carPriceModel = [[GoodsListModel alloc] init];
    self.carPriceModel.totalCash = @"0.00";
    self.carPriceModel.saveCash  = @"0.00";
    self.carPriceModel.beVipSave = @"0.00";

    [self requestActivity];

    [self manageShoppingCar];
}
-(void)requestActivity{
    //活动内容
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"BannerList" parameters:@{@"class":@"6"} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            _activityDic = [NSDictionary dictionaryWithDictionary:[object[@"data"] firstObject]];
            _shoppingCarView.topcontentS = _activityDic[@"text"];
            [_shoppingCarView showTopView];
        }else {
            NSLog(@"顶部活动：%@", object);
            [_shoppingCarView hideTopView];
        }
    }];
}

- (void)refreshCarNum
{
    // 购物车商品总数量数量
    [GoodsListModel requestForCarNumWithComplete:^(BOOL success, NSString * carNum) {
        NSLog(@"carNum:%@", carNum);
        _carCountNum = [NSString stringWithFormat:@"%@",carNum];
        if ([carNum intValue]>99) {
            [self.navigationController.tabBarController.tabBar showBadgeOnItemIndex:99];
        }else if([carNum intValue]==0){
            [self.navigationController.tabBarController.tabBar hideBadgeOnItemIndex];
        }else{
            [self.navigationController.tabBarController.tabBar showBadgeOnItemIndex:[carNum intValue]];
        }
    }];
}

/**
 管理购物车
 */
- (void)manageShoppingCar
{
    self.HUD.labelText = nil;
    [self.HUD show:YES];
    [GoodsListModel requsetForCarManageWithSelectedGoods:self.selectedGoods Complete:^(NSInteger code, NSMutableArray *models,GoodsListModel * price, NSString *msg) {
        [self.HUD hide:YES];
        [self.shoppingCarView endRefresh];
        [self refreshCarNum];
        if (code == 100) {
            self.carPriceModel = price;
            self.totalCash = price.totalCash;
            self.saveCash  = price.saveCash;
            self.beVipSave = price.beVipSave;
            self.shoppingCarView.models = models;
            self.shoppingCarView.empty = NO;
            self.editBtn.hidden = NO;                       // 是否显示编辑按钮
            // 购物车商品数量
            self.carNum = 0;
            // 筛选已选中的商品
            [self.selectedGoods removeAllObjects];
            for (GoodsListModel * model in models) {
                for (GoodsModel * goods in model.goodsModels) {
                    // 购物车商品种类数量
                    if (!goods.isGift) {
                        self.carNum ++;
                        
                        if ([self.selectedGoodsIDs containsObject:goods.goodsID]) {
                            goods.selected = YES;
                            [self.selectedGoods addObject:goods];
                        }
                    }
                }
            }
            if (models.count == 0) {
                self.shoppingCarView.empty = YES;
                self.editBtn.hidden = YES;                       // 是否显示编辑按钮
            }
            [self updateBottomView];
        }else {
            self.shoppingCarView.empty = YES;
            self.editBtn.hidden = YES;
            
            [self updateBottomView];
            SHOW_MSG(msg);
        }
    }];
}

#pragma mark -- ShoppingViewDelegate
- (void)shoppingViewRefreshAction
{
    [self requsetForCarList];
}

/**
 全选
 */
- (void)shoppingViewAllGoodsSelected:(BOOL)selected
{
    if (selected) {
        [self.selectedGoods removeAllObjects];
        [self.selectedGoodsIDs removeAllObjects];
        for (GoodsListModel * model in self.shoppingCarView.models) {
            for (GoodsModel * goodsModel in model.goodsModels) {
                if (!goodsModel.isGift) {
                    goodsModel.selected = YES;
                    [self.selectedGoods addObject:goodsModel];
                    [self.selectedGoodsIDs addObject:goodsModel.goodsID];
                }
            }
        }
    }else {
        for (GoodsListModel * model in self.shoppingCarView.models) {
            for (GoodsModel * goods in model.goodsModels) {
                if (!goods.isGift) {
                    goods.selected = NO;
                }
            }
        }
        [self.selectedGoods removeAllObjects];
        [self.selectedGoodsIDs removeAllObjects];
    }
    
    [self manageShoppingCar];
}

/**
 删除商品
 */
- (void)shoppingViewDeleteGoodsAction
{
    self.HUD.labelText = @"正在删除";
    [self.HUD show:YES];
    [GoodsListModel requsetForDeleteSelectedGoods:self.selectedGoods complete:^(BOOL success, NSString *msg) {
        [self.HUD hide:YES];
        if (success) {
            [self.selectedGoods removeAllObjects];
            [self.selectedGoodsIDs removeAllObjects];
            
            [self updateBottomView];
            [self requsetForCarList];
        }else {
            SHOW_MSG(msg);
        }
    }];
}

/**
 购物车为空去逛逛
 
 @param shoppingView
 @param btn
 */
- (void)shoppingView:(ShoppingCarView *)shoppingView gotoClassWithBtn:(UIButton *)btn
{
    RootTabBarVC * rootVC = ROOTVIEWCONTROLLER;
    rootVC.selectedIndex = 0;
}

/**
 购物车为空去收藏
 
 @param shoppingView
 @param btn
 */
- (void)shoppingView:(ShoppingCarView *)shoppingView gotoCollectionWithBtn:(UIButton *)btn
{
    UserCollectListViewController * collectionVC = [[UserCollectListViewController alloc] init];
    collectionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:collectionVC animated:YES];
}

/**
 顶部点击事件
 
 @param shoppingView
 @param tap
 */
- (void)shoppingView:(ShoppingCarView *)shoppingView clickedTopItemWithTap:(UITapGestureRecognizer *)tap
{
    NSLog(@"顶部标签");
    switch ([_activityDic[@"type"] integerValue]) {
        case 1:{
            //商品
            GoodsDetailViewController *goodsVC = [[GoodsDetailViewController alloc] init];
            goodsVC.goodsId = _activityDic[@"link"];
            goodsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsVC animated:YES];
        }
            break;
        case 2:
            //分类
        {
            NSDictionary *dataSource = @{@"gc_id":_activityDic[@"link"],@"gc_name":_activityDic[@"className"]};
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
            homePageMoreVC.brandName = _activityDic[@"brand_name"];
            homePageMoreVC.ID = _activityDic[@"link"];
            homePageMoreVC.brandClassId = _activityDic[@"class_id"];
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
            htmlVC.htmlUrl = _activityDic[@"link"];
            htmlVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:htmlVC animated:YES];
        }
            break;
        case 6:{
            HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
            homePageMoreVC.homePageMoreVCType = HomePageMoreVCShopCar;
            homePageMoreVC.brandName = _activityDic[@"platName"];
            homePageMoreVC.goods_platform_only = _activityDic[@"link"];
            homePageMoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:homePageMoreVC animated:YES];
        }
            break;
        default:
            break;
    }

    
}

/**
 点击活动标签
 
 @param shoppingView
 @param model
 */
- (void)shoppingView:(ShoppingCarView *)shoppingView activityActionWithModel:(GoodsListModel *)model
{
    NSLog(@"活动标签");
    HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
    homePageMoreVC.homePageMoreVCType = HomePageMoreVCShopCar;
    homePageMoreVC.brandName = model.actLabel;
    homePageMoreVC.goods_platform_only = model.actID;
    homePageMoreVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homePageMoreVC animated:YES];
}

/**
 选中商品
 
 @param shoppingView
 @param model
 @param select
 */
- (void)shoppingView:(ShoppingCarView *)shoppingView selectedGoodsWithModel:(GoodsModel *)model select:(BOOL)select
{
    model.selected = select;
    if (select) {
        [self.selectedGoods addObject:model];
        [self.selectedGoodsIDs addObject:model.goodsID];
    }else {
        [self.selectedGoods removeObject:model];
        [self.selectedGoodsIDs removeObject:model.goodsID];
    }
    [self manageShoppingCar];
}

/**
 加减商品
 
 @param shoppingView
 @param model
 @param btn
 @param amount
 */
- (void)shoppingView:(ShoppingCarView *)shoppingView addOrReduceActionWithModel:(GoodsModel *)model btn:(UIButton *)btn amount:(NSString *)amount
{
    btn.userInteractionEnabled = NO;
//    if (amount.integerValue < model.goodsNum.integerValue && amount.integerValue == 1) {
//        SHOW_EEROR_MSG(@"已经最少了，不能再减了亲");
//    }
    self.HUD.labelText = nil;
    [self.HUD show:YES];
    [GoodsListModel requestForEditCarListWithGoodsModel:model goodsNum:amount Complete:^(BOOL success, NSString *msg) {
        [self.HUD hide:YES];
        btn.userInteractionEnabled = YES;
        if (success) {
            [self manageShoppingCar];
        }else {
            SHOW_MSG(msg);
        }
    }];
}

/**
 点击商品
 
 @param shoppingView
 @param model
 */
- (void)shoppingView:(ShoppingCarView *)shoppingView didSelectGoodsWithModel:(GoodsModel *)model
{
    GoodsDetailViewController * goodsDetailVC =[[GoodsDetailViewController alloc]init];
    goodsDetailVC.goodsId = model.goodsID;
    goodsDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

/**
 加入麦咖
 
 @param shoppingView
 @param btn
 */
- (void)shoppingView:(ShoppingCarView *)shoppingView memberActionWithBtn:(UIButton *)btn
{
    NSLog(@"加入麦咖");
//    VIPIntroductionsViewController * VIPVC = [[VIPIntroductionsViewController alloc] init];
//    VIPVC.isProtocol = NO;
//    VIPVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:VIPVC animated:YES];
    if ([[JCUserContext sharedManager].currentUserInfo.drp_recommend boolValue]) {
        //分销商点击事件
        SHOW_MSG(@"您已经是分销商");
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
            }
                break;
        }
    }

}

/**
 结算
 
 @param shoppingView
 @param btn
 */
- (void)shoppingView:(ShoppingCarView *)shoppingView settleActionWithBtn:(UIButton *)btn
{
    NSLog(@"结算");
    ShoppingCarSettlementViewController *shoppingSetVC =[[ShoppingCarSettlementViewController alloc] init];
    shoppingSetVC.isCar = YES;
    NSMutableString *carIDString = [NSMutableString string];
    for (GoodsModel * goodsM in self.selectedGoods) {
        NSString *carId =  goodsM.carID;
        [carIDString appendFormat:@"%@", [NSString stringWithFormat:@"%@,",carId]];
        if ([goodsM.originCode length] == 0) {
            shoppingSetVC.isHaveA = NO;
        }
        else if([goodsM.originCode isEqualToString:@"G"]){
            shoppingSetVC.isHaveA = YES;
        }else{
            shoppingSetVC.isHaveA = NO;
        }
    }
    [carIDString deleteCharactersInRange:NSMakeRange(carIDString.length-1, 1)];
    shoppingSetVC.cartId = carIDString;
    shoppingSetVC.hidesBottomBarWhenPushed = YES;
    shoppingSetVC.goodsNumString = _carCountNum;
    [self.navigationController pushViewController:shoppingSetVC animated:YES];
    
    [self.selectedGoods removeAllObjects];
    [self.selectedGoodsIDs removeAllObjects];
}

#pragma mark -- actions
- (void)editAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.shoppingCarView.isEditing = sender.selected;
}

#pragma mark  --- NoNetDelegate --
-(void)NoNetDidClickRelaod:(UIButton *)sender
{
    [self checkConnection:^(ConnectionType type) {
        if (type == ConnectionTypeNone ) {
            NSLog(@"无网");
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前网络不可用，请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if (type == ConnectionTypeWifi){
            NSLog(@"wifi");
            [self hideNoNet];
            [self requsetForCarList];
        }
        else if (type == ConnectionTypeData){
            NSLog(@"2g/3g");
            [self hideNoNet];
            [self requsetForCarList];
        }
    }];
}



@end
