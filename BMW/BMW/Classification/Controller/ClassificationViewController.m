//
//  ClassificationViewController.m
//  BMW
//
//  Created by rr on 16/3/1.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ClassificationViewController.h"
#import "ClassifyView.h"
#import "ClassTitleView.h"
#import "CustomerserviceViewController.h"
#import "HomePageMoreViewController.h"//更多
#import "HomeSearchViewController.h"
#import "GoodsDetailViewController.h"
#import "HomePageMoreViewController.h"
#import "ClassifyMenu.h"


@interface ClassificationViewController ()<NoNetDelegate, ClassifyViewDelegate, ClassTitleViewDelegate, ClassifyMenuDelegate>

@property (nonatomic, strong) ClassifyView * classifyView;
@property (nonatomic, strong) ClassTitleView * titleView;
@property (nonatomic, strong) ClassifyMenu * classMenu;
@end

@implementation ClassificationViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterfaceClassification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetWorkingState) name:kReachabilityChangedNotification object:nil];
    
    [self checkConnection:^(ConnectionType type) {
        if (type == ConnectionTypeNone ) {
            NSLog(@"无网");
            [self showNoNetOnView:self.view frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) type:NoNetDefault delegate:self];
        }
        else if (type == ConnectionTypeWifi){
           NSLog(@"wifi");
           
        }
        else if (type == ConnectionTypeData){
            NSLog(@"2g/3g");
        }
    }];
}

#pragma mark -- notification
- (void)checkNetWorkingState
{
    [self checkConnection:^(ConnectionType type) {
        if (type == ConnectionTypeNone ) {
            NSLog(@"无网");
            [self showNoNetOnView:self.view frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) type:NoNetDefault delegate:self];
        }
        else if (type == ConnectionTypeWifi){
            NSLog(@"wifi");
            
        }
        else if (type == ConnectionTypeData){
            NSLog(@"2g/3g");
        }
    }];
}

#pragma mark -- getter
- (ClassifyMenu *)classMenu
{
    if (!_classMenu) {
        _classMenu = [[ClassifyMenu alloc] initWithFrame:CGRectMake(0, 64, self.view.viewWidth, self.view.viewHeight)];
        _classMenu.delegate = self;
        [self.tabBarController.view addSubview:_classMenu];
    }
    return _classMenu;
}

#pragma mark -- UI
-(void)initUserInterfaceClassification
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _classifyView = [[ClassifyView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight - 49 - 64)];
    _classifyView.delegate = self;
    [self.view addSubview:_classifyView];
    
    _titleView = [[ClassTitleView alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    _titleView.delegate = self;
    self.navigationItem.titleView = _titleView;
    
    // 暂时屏蔽搜索
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.viewSize = CGSizeMake(30, 30);
    [searchBtn setImage:[UIImage imageNamed:@"icon_sousuo_fl.png"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 2, 0);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
    [self requestForFirstClass];
}
#pragma mark -- actions
- (void)searchAction:(UIButton *)sender
{
    HomeSearchViewController *homeSearch = [[HomeSearchViewController alloc] init];
    homeSearch.navigationItem.hidesBackButton = YES;
    homeSearch.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeSearch animated:YES];
}

#pragma mark -- ClassifyMenuDelegate
// 点击了品牌页展开的分类
- (void)classifyMenu:(ClassifyMenu *)classifyMenu didSelectedClassWithModel:(ClassModel *)model
{
    [classifyMenu hideClassifyMenu];
    for (ClassModel * model in self.classMenu.classModels) {
        if (model.selected) {
            model.selected = NO;
        }
    }
    model.selected = YES;
    [self.classifyView reloadBrandClass];
    [self requestForBrandListWitGCID:model.gcID];
}

#pragma mark -- ClassifyViewDelegate
// 点击一级分类
- (void)classView:(ClassifyView *)classView didSelectedFirstClass:(ClassModel *)model
{
    [self requestForSecondClassWithGCID:model.gcID];
}

// 点击二级分类
- (void)classView:(ClassifyView *)classView didSelectedSecondClass:(ClassModel *)model
{
    HomePageMoreViewController * homePageMoreVC = [[HomePageMoreViewController alloc]init];
    // 待更多页面需要改版在修改这里的的Model
    homePageMoreVC.dataDIc = @{@"gc_id":model.sectionID, @"gc_name":model.sectionName};
    homePageMoreVC.noThirdClass = NO;
    homePageMoreVC.hidesBottomBarWhenPushed = YES;
    homePageMoreVC.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:homePageMoreVC animated:YES];
}

// 点击三级分类
- (void)classView:(ClassifyView *)classView didSelectedThirdClass:(ClassModel *)model
{
    HomePageMoreViewController * homePageMoreVC = [[HomePageMoreViewController alloc]init];
    // 待更多页面需要改版在修改这里的的Model
    homePageMoreVC.dataDIc = @{@"gc_id":model.itemID, @"gc_name":model.itemName};
    homePageMoreVC.noThirdClass = YES;
    homePageMoreVC.hidesBottomBarWhenPushed = YES;
    homePageMoreVC.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:homePageMoreVC animated:YES];
}

// 选择热销品牌
- (void)classView:(ClassifyView *)classView didSelectedHotBrand:(BrandModel *)model
{
    HomePageMoreViewController * homePageMoreVC = [[HomePageMoreViewController alloc]init];
    homePageMoreVC.homePageMoreVCType = HomePageMoreVCMoreBrand;
    homePageMoreVC.brandName = model.brandName;
    homePageMoreVC.ID = model.brandID;
    homePageMoreVC.brandClassId = model.classID;
    homePageMoreVC.hidesBottomBarWhenPushed = YES;
    homePageMoreVC.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:homePageMoreVC animated:YES];
}

// 选择品牌页面顶部下拉菜单
- (void)classView:(ClassifyView *)classView didSelectedDownBtn:(UIButton *)btn
{
    [self.classMenu showClassifyMenu];
}

// 选择品牌页面的顶部分类
- (void)classView:(ClassifyView *)classView didSelectedBrandClassWithClass:(ClassModel *)model
{
    [self requestForBrandListWitGCID:model.gcID];
}

// 选择品牌列表
- (void)classView:(ClassifyView *)classView didSelectedBrand:(BrandModel *)model
{
    HomePageMoreViewController * homePageMoreVC = [[HomePageMoreViewController alloc]init];
    homePageMoreVC.homePageMoreVCType = HomePageMoreVCMoreBrand;
    homePageMoreVC.brandName = model.brandName;
    homePageMoreVC.ID = model.brandID;
    homePageMoreVC.brandClassId = model.classID;
    homePageMoreVC.hidesBottomBarWhenPushed = YES;
    homePageMoreVC.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:homePageMoreVC animated:YES];
}

// 选择banner
- (void)classView:(ClassifyView *)classView didSelectedBanner:(ClassModel *)bannerModel
{
    switch (bannerModel.gcType.integerValue) {
        case 1:{
            GoodsDetailViewController *goodsVC = [[GoodsDetailViewController alloc] init];
            goodsVC.goodsId = bannerModel.bannerUrl;
            goodsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsVC animated:YES];
        }
            break;
        case 2:{
            HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
            homePageMoreVC.homePageMoreVCType = HomePageMoreVCShopCar;
            homePageMoreVC.brandName = bannerModel.gcName;
            homePageMoreVC.goods_platform_only = bannerModel.bannerUrl;
            homePageMoreVC.ID = homePageMoreVC.goods_platform_only;
            homePageMoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:homePageMoreVC animated:YES];
        }
            break;
        case 3:{
            if (bannerModel.bannerUrl.length > 4) {
                CustomerserviceViewController *htmlVC = [[CustomerserviceViewController alloc] init];
                htmlVC.htmlUrl = bannerModel.bannerUrl;
                htmlVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:htmlVC animated:YES];
            }else {
                NSLog(@"banner地址不正确");
            }
        }
            break;
        case 4:{
            // 品牌
            HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
            homePageMoreVC.homePageMoreVCType = HomePageMoreVCMoreBrand;
            homePageMoreVC.brandName = bannerModel.gcName;
            homePageMoreVC.ID = bannerModel.bannerUrl;
            homePageMoreVC.brandClassId = bannerModel.gcID;
            homePageMoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:homePageMoreVC animated:YES];
        }
            break;
        default:
            break;
    }
}

// 滑动翻页
- (void)classView:(ClassifyView *)classView pageTurnWithStatus:(Status)status
{
    if (status == StatusClass) {
        [self.titleView exchangeBtnStatus:ClassStatusClass];
    }else {
        [self.titleView exchangeBtnStatus:ClassStatusBrand];
        
        if (!self.classifyView.brandModels && self.classifyView.brandClassModels) {
            for (ClassModel * model in self.classifyView.brandClassModels) {
                if (model.selected) {
                    [self requestForBrandListWitGCID:model.gcID];
                    break;
                }
            }
        }
    }
}
#pragma mark -- ClassTitleViewDelegate
- (void)classTitleView:(ClassTitleView *)classTitleView didSelectedBtnWithStatus:(ClassStatus)status
{
    if (status == ClassStatusClass) {
        [self.classifyView pageTurnWithStatus:StatusClass];
        [self.classMenu hideClassifyMenu];
    }else {
        [self.classifyView pageTurnWithStatus:StatusBrand];
        
        if (!self.classifyView.brandModels && self.classifyView.brandClassModels) {
            for (ClassModel * model in self.classifyView.brandClassModels) {
                if (model.selected) {
                    [self requestForBrandListWitGCID:model.gcID];
                    break;
                }
            }
        }
    }
}

#pragma mark -- 数据请求
// 获取一级分类数据
- (void)requestForFirstClass
{
    [ClassModel requestForGCFirstClassWithComplete:^(BOOL success, NSString *message, NSMutableArray *models) {
        if (success) {
            [self hideNoNet];
            self.classifyView.classModels = models;
            self.classifyView.brandClassModels = [NSMutableArray arrayWithArray:models];;
            self.classMenu.classModels = self.classifyView.brandClassModels;
            ClassModel * firstModel = models.firstObject;
            [self requestForSecondClassWithGCID:firstModel.gcID];
            
        }else {
            SHOW_EEROR_MSG(message);
            [self showNoNetOnView:self.view
                            frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)
                             type:NoNetDefault
                         delegate:self];
        }
    }];
}

// 获取二级分类数据
- (void)requestForSecondClassWithGCID:(NSString *)GCID
{
    [self.classifyView firstPageIndicatorShow:YES];
    [ClassModel requestForGCListWithGCID:GCID complete:^(BOOL success, NSString *message, NSMutableArray *models, ClassModel * bannerModel) {
        [self.classifyView firstPageIndicatorShow:NO];
        if (success) {
            self.classifyView.itemModels = models;
            self.classifyView.bannerModel = bannerModel;
        }else {
            self.classifyView.itemModels = models;
            self.classifyView.bannerModel = bannerModel;
            SHOW_EEROR_MSG(message);
            [self showNoNetOnView:self.view
                            frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)
                             type:NoNetDefault
                         delegate:self];
        }
    }];
}

// 获取品牌列表
- (void)requestForBrandListWitGCID:(NSString *)GCID
{
    // 热打品牌
//    [BrandModel requestForHotBrandWithFirstClassID:GCID Complete:^(BOOL success, NSString *message, NSMutableArray *models) {
//        if (success) {
//            self.classifyView.hotModels = models;
//        }else {
//            self.classifyView.hotModels = models;
//        }
//    }];
    [self.classifyView secondPageIndicatorShow:YES];
    [BrandModel requestForBrandListWithFirstClassID:GCID Complete:^(BOOL success, NSString *message, NSMutableArray *models, NSMutableArray * indexs) {
        [self.classifyView secondPageIndicatorShow:NO];
        if (success) {
            self.classifyView.indexs = indexs;
            self.classifyView.brandModels = models;
        }else {
            SHOW_EEROR_MSG(message);
            [self showNoNetOnView:self.view
                            frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)
                             type:NoNetDefault
                         delegate:self];
        }
    }];
}

#pragma mark -- NoNetDelegate --
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
            
            [self requestForFirstClass];
        }
        else if (type == ConnectionTypeData){
            NSLog(@"2g/3g");
            [self requestForFirstClass];
        }
    }];
    
}

@end
