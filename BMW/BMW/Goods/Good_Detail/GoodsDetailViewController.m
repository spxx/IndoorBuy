//
//  GoodsDetailViewController.m
//  BMW
//
//  Created by gukai on 16/3/8.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "GoodsParameterView.h"
#import "GoodsTopAlbum.h"
#import "GoodsInfoView.h"
#import "GoodsDetailModle.h"
#import "GoodsInfoModle.h"
#import "GoodsAddCarView.h"
#import "ChooseColorSize.h"
#import "ShareView.h"
#import "RootTabBarVC.h"
#import "ShoppingCarSettlementViewController.h"
#import "LoginViewController.h"
#import "XHImageViewer.h"
#import "AimationTools.h"
#import "CustomerserviceViewController.h"

#import "RemapayMentView.h"
#import "VIPIntroductionsViewController.h"
#import "VIPMyInfoVC.h"
#import "HomePageMoreViewController.h"

#import "CreateCodeVC.h"

#import "OpenShopViewController.h"

@interface GoodsDetailViewController ()<UIScrollViewDelegate,GoodParameterViewDelegate,GoodsTopAlbumDelegate,ChooseColorSizeDelegate,ShareVeiwDelegate,GoodsInfoViewDelegate,CAAnimationDelegate> {
    NSDictionary * _dataSourceDic;              //数据源
    UIButton * _shareButton;
}

@property(nonatomic,strong)UIScrollView * scrollView;

/**
 * 价格上部视图
 */
@property(nonatomic,strong)GoodsTopAlbum * goodsTopAlbum;
/**
 * 促销开始的中部视图
 */
@property(nonatomic,strong)GoodsInfoView * goodsInfoView;
/**
 * 继续上拉 查看图文详情
 */
@property(nonatomic,strong)UIView * bottomView;
/**
 * 下面的图文详情
 */
@property(nonatomic,strong)GoodsParameterView * goodsParameterView;
/**
 * 选择颜色尺码
 */
@property(nonatomic,strong)ChooseColorSize * chooseColorSize;


/**
 * 记录 第一页 的scrollerView
 */
@property(nonatomic,strong)UIView * firstPage;
/**
 * 记录第二页的 scrollerView
 */
@property(nonatomic,strong)UIView * secondPage;
/**
 * 底部的购买的视图
 */
@property(nonatomic,strong)UIView * bottomButtonView;
@property(nonatomic,strong)UIButton * readShopCarBtn;
@property(nonatomic,strong)UIButton * addCarBtn;
@property(nonatomic,strong)UIButton * buyButton;
@property(nonatomic,strong)UIImageView * shopNumImageView;
@property(nonatomic,strong)UILabel * shopNumLabel;
@property(nonatomic,copy)NSString * goodImage;
@property(nonatomic,strong)CALayer * layer;
@property(nonatomic,strong)UIImageView * tempImageView;
@property(nonatomic,copy)NSDictionary * VIPInfoDic;

@end

@implementation GoodsDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.scrollView.delegate = self;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [self getVIPInfoRequest];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.scrollView.delegate = nil;
    [self.goodsTopAlbum xiaohui];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)dealloc{
    NSLog(@"time  dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
    [self initData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isVipSuccess) name:@"isVipSuccess" object:nil];
    
}
-(void)initData
{
    [self netWork];
    [self getShopCarNumNetWork];
}
-(void)initUserInterface
{
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    self.view.userInteractionEnabled = NO;
    self.title = @"商品详情";
    [self initLeftItem];
    [self initShareBtn];
    [self initScrollerView];
    [self initFirstPageView];
    [self initSecondPageView];
    [self initBottomButtonView];
}
-(void)initLeftItem
{
    //配置导航栏的左侧返回按钮
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"icon_fanhui_gdtj.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(15, 0, 10, 18);
    UIBarButtonItem * backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backBtnItem;
}
-(void)initShareBtn
{
    
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton.userInteractionEnabled = NO;
    [_shareButton setBackgroundImage:[UIImage imageNamed:@"icon_fenxiang_spxq.png"] forState:UIControlStateNormal];
    _shareButton.frame = CGRectMake(0, 0, 20, 18);
    UIBarButtonItem * shareBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_shareButton];
    [_shareButton addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = shareBtnItem;
    
}
-(void)initScrollerView
{
    UIScrollView * scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
    [scrollerView setContentSize:CGSizeMake(scrollerView.viewWidth, 2 * scrollerView.viewHeight)];
    //scrollerView.pagingEnabled = YES;
    scrollerView.showsHorizontalScrollIndicator = NO;
    scrollerView.showsVerticalScrollIndicator = NO;
    scrollerView.delegate = self;
    scrollerView.bounces = YES;
    [self.view addSubview:scrollerView];
    self.scrollView = scrollerView;
}
/**
 * 商品介绍
 */
-(void)initFirstPageView
{
    UIView * firstPage = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.viewWidth, self.scrollView.viewHeight)];
    [self.scrollView addSubview:firstPage];
    //判断是否有促销进行展示，当前是默认有
    GoodsTopAlbum * goodsTopAlbum = [[GoodsTopAlbum alloc]initWithFrame:CGRectMake(0, 0, firstPage.viewWidth, 319 * W_ABCW + 131)];
    goodsTopAlbum.delegate = self;
    goodsTopAlbum.backgroundColor = [UIColor whiteColor];
    [firstPage addSubview:goodsTopAlbum];
    self.goodsTopAlbum = goodsTopAlbum;
    
    // 跨境购物服务说明
    GoodsInfoView * goodInfo = [[GoodsInfoView alloc]initWithFrame:CGRectMake(0, goodsTopAlbum.viewBottomEdge, firstPage.viewWidth, 36)];
    goodInfo.backgroundColor = [UIColor colorWithHex:0xffe9e6];
    goodInfo.delegate = self;
    [firstPage addSubview:goodInfo];
    self.goodsInfoView = goodInfo;
    
    ChooseColorSize * chooseColorSize = [[ChooseColorSize alloc]initWithFrame:CGRectMake(0, goodInfo.viewBottomEdge, SCREEN_WIDTH, 45)];
    chooseColorSize.delegate = self;
    chooseColorSize.backgroundColor = [UIColor whiteColor];
    [firstPage addSubview:chooseColorSize];
    self.chooseColorSize = chooseColorSize;
    self.chooseColorSize.hidden = YES;
    
    [firstPage addSubview:self.bottomView];
   
    firstPage.frame = CGRectMake(0, firstPage.viewY, SCREEN_WIDTH, self.bottomView.viewBottomEdge);
    self.firstPage = firstPage;
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.viewWidth, self.firstPage.viewBottomEdge+49)];
}

/**
 * 点击跨境购物说明的动画
 */
-(void)GoodsInfoViewClickButton:(CGFloat)height{
    self.chooseColorSize.viewY = self.goodsInfoView.viewBottomEdge;
    [_bottomView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, self.chooseColorSize.viewBottomEdge)];
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, _bottomView.viewBottomEdge+49)];
    self.firstPage.viewHeight = self.scrollView.contentSize.height;
}

/**
 * 图文详情
 */
-(void)initSecondPageView
{
    GoodsParameterView * goodsParameterView = [[GoodsParameterView alloc]initWithFrame:CGRectMake(0, self.scrollView.viewBottomEdge, self.scrollView.viewWidth, self.scrollView.viewHeight)];
    goodsParameterView.delegate = self;
    [self.view addSubview:goodsParameterView];
    self.goodsParameterView = goodsParameterView;
    self.secondPage = goodsParameterView;
    
}
/**
 * 底部购买视图
 */
-(void)initBottomButtonView
{
    UIView * bottomBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49 - 64, SCREEN_WIDTH, 49)];
    bottomBtnView.backgroundColor = [UIColor redColor];
    [self.view addSubview:bottomBtnView];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bottomBtnView.viewWidth/3, bottomBtnView.viewHeight)];
    view.backgroundColor = [UIColor blackColor];
    [bottomBtnView addSubview:view];
    
    UIImageView * imageViewback = [[UIImageView alloc]initWithFrame:view.bounds];
    imageViewback.backgroundColor = [UIColor blackColor];
    imageViewback.alpha = 0.8;
    imageViewback.userInteractionEnabled = YES;
    [view addSubview:imageViewback];
    
    
    UIButton * shopCarBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, view.viewWidth / 2, view.viewHeight)];
    [view addSubview:shopCarBtn];
    self.readShopCarBtn = shopCarBtn;
    
    UIImageView * imageShopCar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 17, 17)];
    imageShopCar.userInteractionEnabled = YES;
    imageShopCar.image = [UIImage imageNamed:@"icon_gouwuche_spxq.png"];
    imageShopCar.center = CGPointMake(shopCarBtn.viewWidth / 2, 17);
    [shopCarBtn addSubview:imageShopCar];
    
    UILabel * shopCarLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, shopCarBtn.viewWidth, 11)];
    shopCarLB.textAlignment = NSTextAlignmentCenter;
    shopCarLB.font = fontForSize(11);
    shopCarLB.center = CGPointMake(shopCarBtn.viewWidth / 2, shopCarBtn.viewHeight - 14);
    shopCarLB.userInteractionEnabled = YES;
    shopCarLB.text = @"购物车";
    shopCarLB.textColor = [UIColor colorWithHex:0xdadada];
    [shopCarBtn addSubview:shopCarLB];
    
    UIImageView * shopCarNum = [[UIImageView alloc]initWithFrame:CGRectMake(imageShopCar.viewX + 12, 5, 10, 10)];
//    shopCarNum.image = [UIImage imageNamed:@"icon_qipao_spxq.png"];
    shopCarNum.backgroundColor = [UIColor colorWithHex:0xfd5487];
    shopCarNum.layer.cornerRadius = shopCarNum.viewWidth / 2;
    shopCarNum.layer.borderWidth = 0.5;
    shopCarNum.layer.borderColor = [UIColor whiteColor].CGColor;
    
    UILabel * numLabel = [[UILabel alloc] initWithFrame:shopCarNum.bounds];
    numLabel.font = fontForSize(7);
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.textColor = [UIColor whiteColor];
    [shopCarNum addSubview:numLabel];
    [shopCarBtn addSubview:shopCarNum];
    self.shopNumImageView = shopCarNum;
    self.shopNumImageView.hidden = YES;
    self.shopNumLabel = numLabel;
    
    UIButton * gotoShopCar = [[UIButton alloc] initWithFrame:shopCarBtn.frame];
    [gotoShopCar addTarget:self action:@selector(goShopCarAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:gotoShopCar];
    
    UIButton * kefuBtn = [[UIButton alloc]initWithFrame:CGRectMake(shopCarBtn.viewRightEdge, shopCarBtn.viewY, shopCarBtn.viewWidth, shopCarBtn.viewHeight)];
    [view addSubview:kefuBtn];
    UIImageView * imagekefu = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 17, 17)];
    imagekefu.userInteractionEnabled = YES;
    imagekefu.image = [UIImage imageNamed:@"icon_kefu_spxq.png"];
    imagekefu.center = CGPointMake(kefuBtn.viewWidth / 2, 17);
    [kefuBtn addSubview:imagekefu];
    
    UILabel * kefuLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kefuBtn.viewWidth, 11)];
    kefuLB.textAlignment = NSTextAlignmentCenter;
    kefuLB.font = fontForSize(11);
    kefuLB.center = CGPointMake(kefuBtn.viewWidth / 2, kefuBtn.viewHeight - 14);
    kefuLB.userInteractionEnabled = YES;
    kefuLB.text = @"客服";
    kefuLB.textColor = [UIColor colorWithHex:0xdadada];
    [kefuBtn addSubview:kefuLB];

    UIButton *copyKefu = [[UIButton alloc] initWithFrame:kefuBtn.frame];
    [copyKefu addTarget:self action:@selector(goKefuAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:copyKefu];
    
    UIButton * addShopCarBtn = [[UIButton alloc]initWithFrame:CGRectMake(view.viewRightEdge, view.viewY, view.viewWidth, view.viewHeight)];
    addShopCarBtn.backgroundColor = [UIColor colorWithHex:0xfd5487];
    [addShopCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addShopCarBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [addShopCarBtn addTarget:self action:@selector(addShopCarAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtnView addSubview:addShopCarBtn];
    self.addCarBtn = addShopCarBtn;
    self.addCarBtn.userInteractionEnabled = NO;
    self.addCarBtn.backgroundColor = [UIColor colorWithHex:0xe1e1e1];

    UIButton * buyBtn = [[UIButton alloc]initWithFrame:CGRectMake(addShopCarBtn.viewRightEdge, view.viewY, view.viewWidth, view.viewHeight)];
    buyBtn.backgroundColor = [UIColor colorWithHex:0xff9402];
    [buyBtn setTitle:@"立刻购买" forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtnView addSubview:buyBtn];
    self.buyButton = buyBtn;
    self.buyButton.userInteractionEnabled = NO;
    self.buyButton.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
   
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 31)];
    line.backgroundColor = [UIColor colorWithHex:0x565656];
    line.center = CGPointMake(imageViewback.viewWidth / 2, imageViewback.viewHeight / 2);
    [imageViewback addSubview:line];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark -- get --
-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.goodsInfoView.viewBottomEdge, SCREEN_WIDTH, 52)];
        _bottomView.backgroundColor = [UIColor colorWithHex:0xefefef];
        
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(10, _bottomView.viewHeight / 2 - 1, 68, 1)];
        line1.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_bottomView addSubview:line1];
        
        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(_bottomView.viewWidth - line1.viewRightEdge, line1.viewY, line1.viewWidth, line1.viewHeight)];
        line2.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_bottomView addSubview:line2];
        
        UILabel * label  =[[UILabel alloc]initWithFrame:CGRectMake(line1.viewRightEdge, 0, SCREEN_WIDTH - line1.viewRightEdge * 2, _bottomView.viewHeight)];
        label.text = @"继续上拉，查看图文详情";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithHex:0x181818];
        label.font = fontForSize(12);
        [_bottomView addSubview:label];
    }
    return _bottomView;
}
#pragma mark -- <UIScrollViewDelegate>
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.scrollView) {
        CGFloat height = self.bottomView.viewHeight - self.scrollView.viewHeight + self.goodsInfoView.viewBottomEdge;
        if (scrollView.contentOffset.y >=height + 64) {
            //[scrollView setContentSize:CGSizeMake(scrollView.viewWidth, self.secondPage.viewBottomEdge)];
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.frame = CGRectMake(self.scrollView.viewX, -self.scrollView.viewHeight, self.scrollView.viewWidth, self.scrollView.viewHeight);
                self.secondPage.frame = CGRectMake(self.secondPage.viewX, 0, self.secondPage.viewWidth, self.scrollView.viewHeight);
            } completion:^(BOOL finished) {
               
             }];
        }
    }
}
#pragma mark -- Action --
/**
 * 返回
 */
-(void)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 * 分享
 */
-(void)shareAction:(UIButton *)sender
{
    if (![JCUserContext sharedManager].isUserLogedIn) {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        loginVC.isRegistPush = NO;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    ShareView * shareView = [[ShareView alloc] initWithTitle:@"该商品" QRCode:YES];
    shareView.delegate = self;
    [self.view.window addSubview:shareView];
}

/**
 * 查看购物车
 */
-(void)goShopCarAction:(UIButton *)sender
{
    if (![JCUserContext sharedManager].isUserLogedIn) {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        loginVC.isRegistPush = NO;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    RootTabBarVC *tabbar = ROOTVIEWCONTROLLER;
    tabbar.selectedIndex = 2;
    if ([self.navigationController isEqual:tabbar.viewControllers[3]] ||
        [self.navigationController isEqual:tabbar.viewControllers[0]]) {
        
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/**
 * 客服
 */
-(void)goKefuAction:(UIButton *)sender
{
    CustomerserviceViewController *custommerVC = [[CustomerserviceViewController alloc] init];
    custommerVC.htmlUrl = SERVICE_URL;
    [self.navigationController pushViewController:custommerVC animated:YES];
    
}
/**
 * 加入购物车
 */
-(void)addShopCarAction:(UIButton *)sender
{
    if (![JCUserContext sharedManager].isUserLogedIn) {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        loginVC.isRegistPush = NO;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    if ([_dataSourceDic[@"goods_info"][@"spec_name"] isKindOfClass:[NSNull class]]) {
        [GoodsDetailModle addToCartWithGoodsID:_dataSourceDic[@"goods_info"][@"goods_id"] andGoodsNum:@"1" andComplete:^(BOOL success, NSString *str) {
            if (success) {
                [self getShopCarNumNetWork];
                [self startAnimation];
            }else{
                SHOW_MSG(str);
            }
        }];
    }
    else {
        GoodsAddCarView * addCar = [[GoodsAddCarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)
                                                                  GoodsId:_dataSourceDic[@"goods_info"][@"goods_id"]
                                                            goodsCommonid:_dataSourceDic[@"goods_info"][@"goods_commonid"]
                                                               goodsPrice:_dataSourceDic[@"goods_info"][@"goods_price"]
                                                             goodsStorage:_dataSourceDic[@"goods_info"][@"goods_storage"]
                                                                goodsSpec:_dataSourceDic[@"goods_info"][@"goods_spec"]
                                                                 specName:_dataSourceDic[@"goods_info"][@"spec_name"]
                                                                specValue:_dataSourceDic[@"goods_info"][@"spec_value"]
                                                           specListMobile:_dataSourceDic[@"spec_list_mobile"]
                                                      GoodsDetailOrAddCar:@"addCar"];
        //点击了加入购物车
        [addCar setClickedAddCar:^(NSString * goodsId, NSString * num) {
            [GoodsDetailModle addToCartWithGoodsID:goodsId andGoodsNum:num andComplete:^(BOOL success, NSString *str) {
                if (success) {
                    [self getShopCarNumNetWork];
                    [self startAnimation];
                }else{
                    SHOW_MSG(str);
                }
            }];
        }];
        //加载页面，回调不调用会闪退
        [addCar setClickedBuy:^(NSString * goodsId, NSString * num) {
            
        }];
        [self.view addSubview:addCar];
    }
}
/**
 * 立刻购买
 */
-(void)buyAction:(UIButton *)sender
{
    if (![JCUserContext sharedManager].isUserLogedIn) {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        loginVC.isRegistPush = NO;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    GoodsDetailModle * detailModle = [[GoodsDetailModle alloc]initWithJsonObject:_dataSourceDic];
    GoodsInfoModle *infoModel =  [detailModle modleFormGoods_Info_Str];
    
    GoodsAddCarView * addCar;
    if(infoModel.p_tejia){
        if (infoModel.p_tejia[@"normal_discount_price"]) {
            if ([[[JCUserContext sharedManager].currentUserInfo status] isEqualToString:@"10"]) {
                addCar = [[GoodsAddCarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) GoodsId:_dataSourceDic[@"goods_info"][@"goods_id"] goodsCommonid:_dataSourceDic[@"goods_info"][@"goods_commonid"] goodsPrice:infoModel.p_tejia[@"normal_discount_price"] goodsStorage:_dataSourceDic[@"goods_info"][@"goods_storage"] goodsSpec:_dataSourceDic[@"goods_info"][@"goods_spec"] specName:_dataSourceDic[@"goods_info"][@"spec_name"] specValue:_dataSourceDic[@"goods_info"][@"spec_value"] specListMobile:_dataSourceDic[@"spec_list_mobile"] GoodsDetailOrAddCar:@"goodsDetail"];
            }else{
                addCar = [[GoodsAddCarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) GoodsId:_dataSourceDic[@"goods_info"][@"goods_id"] goodsCommonid:_dataSourceDic[@"goods_info"][@"goods_commonid"] goodsPrice:infoModel.p_tejia[@"normal_discount_price"] goodsStorage:_dataSourceDic[@"goods_info"][@"goods_storage"] goodsSpec:_dataSourceDic[@"goods_info"][@"goods_spec"] specName:_dataSourceDic[@"goods_info"][@"spec_name"] specValue:_dataSourceDic[@"goods_info"][@"spec_value"] specListMobile:_dataSourceDic[@"spec_list_mobile"] GoodsDetailOrAddCar:@"goodsDetail"];
            }
        }else if (infoModel.p_tejia[@"normal_price"]){
            addCar = [[GoodsAddCarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) GoodsId:_dataSourceDic[@"goods_info"][@"goods_id"] goodsCommonid:_dataSourceDic[@"goods_info"][@"goods_commonid"] goodsPrice:infoModel.p_tejia[@"normal_price"] goodsStorage:_dataSourceDic[@"goods_info"][@"goods_storage"] goodsSpec:_dataSourceDic[@"goods_info"][@"goods_spec"] specName:_dataSourceDic[@"goods_info"][@"spec_name"] specValue:_dataSourceDic[@"goods_info"][@"spec_value"] specListMobile:_dataSourceDic[@"spec_list_mobile"] GoodsDetailOrAddCar:@"goodsDetail"];
        }
    }else{
        addCar = [[GoodsAddCarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) GoodsId:_dataSourceDic[@"goods_info"][@"goods_id"] goodsCommonid:_dataSourceDic[@"goods_info"][@"goods_commonid"] goodsPrice:_dataSourceDic[@"goods_info"][@"goods_price"] goodsStorage:_dataSourceDic[@"goods_info"][@"goods_storage"] goodsSpec:_dataSourceDic[@"goods_info"][@"goods_spec"] specName:_dataSourceDic[@"goods_info"][@"spec_name"] specValue:_dataSourceDic[@"goods_info"][@"spec_value"] specListMobile:_dataSourceDic[@"spec_list_mobile"] GoodsDetailOrAddCar:@"goodsDetail"];
    }
    
    //点击了加入购物车
    [addCar setClickedAddCar:^(NSString * goodsId, NSString * num) {
        [BaseRequset sendPOSTRequestWithBMWApi2Method:@"CartAdd" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"goodsId":goodsId, @"num":num} callBack:^(RequestResult result, id object) {
            if (result == RequestResultSuccess) {
                SHOW_MSG(@"成功加入购物车");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppcarNum" object:nil];
                [self getShopCarNumNetWork];
                [self startAnimation];
            }
            else {
                NSString * string = object[@"message"];
                if (string.length > 0) {
                    SHOW_MSG(string);
                }
                else{
                    SHOW_MSG(@"加入购物车失败");
                };
            }
        }];
    }];
    //立即购买
    [addCar setClickedBuy:^(NSString * goodsId, NSString * num) {
        [self gotoShoppingCarSettlementViewControllerWithGoodsId:goodsId goodsNum:num];
    }];
    
    [self.view addSubview:addCar];
}
//进入结算页面的方法
- (void) gotoShoppingCarSettlementViewControllerWithGoodsId:(NSString *)goodsId goodsNum:(NSString *)goodsNum {
    ShoppingCarSettlementViewController * shoppingVC = [[ShoppingCarSettlementViewController alloc] init];
    shoppingVC.isCar = NO;
    shoppingVC.goodsId = goodsId;
    shoppingVC.goodsNumString = goodsNum;
    if ([_dataSourceDic[@"goods_info"][@"send_code"] isKindOfClass:[NSNull class]] || ((NSString *)_dataSourceDic[@"goods_info"][@"send_code"]).length == 0) {
        shoppingVC.isHaveA = NO;
    }
    else if([((NSString *)_dataSourceDic[@"goods_info"][@"send_code"]) isEqualToString:@"G"]||[((NSString *)_dataSourceDic[@"goods_info"][@"send_code"]) isEqualToString:@"g"]){
        shoppingVC.isHaveA = YES;
    }else{
        shoppingVC.isHaveA = NO;
    }
    [self.navigationController pushViewController:shoppingVC animated:YES];
}
#pragma mark -- ShareViewDelegate --
- (void)shareView:(ShareView *)shareView chooseItemWithDestination:(Share3RDParty)destination
{    
    UIImage * shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_dataSourceDic[@"goods_info"][@"goods_image"]]]];
    NSString * shareUrl = nil;
    if ([[JCUserContext sharedManager].currentUserInfo.drp_recommend boolValue]) {
        shareUrl = SHAREURL_DRP(GOODS, [JCUserContext sharedManager].currentUserInfo.drp_recommend, _dataSourceDic[@"goods_info"][@"goods_id"]);
    }else{
        shareUrl = SHAREURL_MEMBER(GOODS, [JCUserContext sharedManager].currentUserInfo.memberID, _dataSourceDic[@"goods_info"][@"goods_id"]);
    }
    NSString * goodsName = _dataSourceDic[@"goods_info"][@"goods_name"];
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
            codeVC.titleStr = goodsName;
            codeVC.shareUrl = shareUrl;
            [self.navigationController pushViewController:codeVC animated:YES];            
        }
            break;
        default:
            break;
    }
}

#pragma mark -- GoodsTopAlbumDelegate --
/**
 *限时抢购完成回调
 */
-(void)goodsRefersh{
    [self netWork];
}
//收藏的回调
-(void)goodsTopAlbumClickCollectButton:(UIButton *)sender
{
    if (![JCUserContext sharedManager].isUserLogedIn) {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        loginVC.isRegistPush = NO;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    if (sender.selected) {
        [GoodsDetailModle collectionedWithDic:_dataSourceDic andComplete:^(BOOL success) {
            if (success) {
                sender.selected = NO;
                SHOW_MSG(@"取消收藏成功");
            }
        }];
    }else{
        [GoodsDetailModle addcollectionWithDic:_dataSourceDic andComplete:^(BOOL success) {
            if (success) {
                sender.selected = YES;
                SHOW_MSG(@"收藏成功");
            }
        }];
    }
}
//跳转活动
-(void)gotoAcitiy:(NSString *)title andID:(NSString *)bind_id{
    HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
    homePageMoreVC.homePageMoreVCType = HomePageMoreVCShopCar;
    homePageMoreVC.brandName = title;
    homePageMoreVC.goods_platform_only = bind_id;
    homePageMoreVC.ID = homePageMoreVC.goods_platform_only;
    [self.navigationController pushViewController:homePageMoreVC animated:YES];

}


// 点击加入麦咖
-(void)goodsTopAlbumClickBeVIPButton:(UIButton *)sender
{
    if (![JCUserContext sharedManager].isUserLogedIn) {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        loginVC.isRegistPush = NO;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }else{
        OpenShopViewController *openShopVC = [[OpenShopViewController alloc] init];
        openShopVC.title = @"成为麦咖";
        openShopVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:openShopVC animated:YES];
    }
//    if ([[JCUserContext sharedManager].currentUserInfo.status isKindOfClass:[NSNull class]]) {
//        //不是会员
//        VIPIntroductionsViewController * vipIntroductionsVC = [[VIPIntroductionsViewController alloc] init];
//        vipIntroductionsVC.isProtocol = NO;
//        [self.navigationController pushViewController:vipIntroductionsVC animated:YES];
//    }
//    else{
//        NSInteger status = [[JCUserContext sharedManager].currentUserInfo.status integerValue];
//        switch (status) {
//            case 0:{
//                VIPIntroductionsViewController * vipIntroductionsVC = [[VIPIntroductionsViewController alloc] init];
//                vipIntroductionsVC.isProtocol = NO;
//                [self.navigationController pushViewController:vipIntroductionsVC animated:YES];
//            }
//                break;
//            case 20:{
//                //申请中
//                VIPIntroductionsViewController * vipIntroductionsVC = [[VIPIntroductionsViewController alloc] init];
//                vipIntroductionsVC.isProtocol = NO;
//                [self.navigationController pushViewController:vipIntroductionsVC animated:YES];
//            }
//                break;
//            case 30:{
//                //绑卡失败
//                [self VIPActivation];
//            }
//                break;
//            case 40:{
//                //过期
//                VIPMyInfoVC * vipMyInfoVC = [[VIPMyInfoVC alloc] init];
//                vipMyInfoVC.dataSourceDic = _VIPInfoDic;
//                [self.navigationController pushViewController:vipMyInfoVC animated:YES];
//            }
//                break;
//            case 50:{
//                //申请失败，重新申请
//                VIPIntroductionsViewController * vipIntroductionsVC = [[VIPIntroductionsViewController alloc] init];
//                vipIntroductionsVC.isProtocol = NO;
//                [self.navigationController pushViewController:vipIntroductionsVC animated:YES];
//            }
//                break;
//            default:
//                break;
//        }
//    }
}
#pragma mark -- ChooseColorSizeDelegate --
//点击的选择颜色尺码的回调
-(void)ChooseColorSizeClickTheBtn
{
    NSDictionary * goodsInfo = _dataSourceDic[@"goods_info"];
    if ([goodsInfo[@"spec_name"] isKindOfClass:[NSNull class]]) {
        if (![JCUserContext sharedManager].isUserLogedIn) {
            LoginViewController * loginVC = [[LoginViewController alloc] init];
            loginVC.isRegistPush = NO;
            [self.navigationController pushViewController:loginVC animated:YES];
            return;
        }
        
        [GoodsDetailModle addToCartWithGoodsID:goodsInfo[@"goods_id"] andGoodsNum:@"1" andComplete:^(BOOL success, NSString *str) {
            if (success) {
                [self getShopCarNumNetWork];
                [self startAnimation];
            }else{
                SHOW_MSG(str);
            }
        }];
    }
    else {
        GoodsAddCarView * addCar = [[GoodsAddCarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)
                                                                  GoodsId:goodsInfo[@"goods_id"]
                                                            goodsCommonid:goodsInfo[@"goods_commonid"]
                                                               goodsPrice:goodsInfo[@"goods_price"]
                                                             goodsStorage:goodsInfo[@"goods_storage"]
                                                                goodsSpec:goodsInfo[@"goods_spec"]
                                                                 specName:goodsInfo[@"spec_name"]
                                                                specValue:goodsInfo[@"spec_value"]
                                                           specListMobile:_dataSourceDic[@"spec_list_mobile"]
                                                      GoodsDetailOrAddCar:@"goodsDetail"];
        //点击了加入购物车
        [addCar setClickedAddCar:^(NSString * goodsId, NSString * num) {
            if (![JCUserContext sharedManager].isUserLogedIn) {
                LoginViewController * loginVC = [[LoginViewController alloc] init];
                loginVC.isRegistPush = NO;
                [self.navigationController pushViewController:loginVC animated:YES];
                return;
            }
            [GoodsDetailModle addToCartWithGoodsID:goodsId andGoodsNum:num andComplete:^(BOOL success, NSString *str) {
                if (success) {
                    [self getShopCarNumNetWork];
                    [self startAnimation];
                }else{
                    SHOW_MSG(str);
                }
            }];
        }];
        //点击立即购买
        [addCar setClickedBuy:^(NSString * goodsId, NSString * num) {
            if (![JCUserContext sharedManager].isUserLogedIn) {
                LoginViewController * loginVC = [[LoginViewController alloc] init];
                loginVC.isRegistPush = NO;
                [self.navigationController pushViewController:loginVC animated:YES];
                return;
            }
            
            [self gotoShoppingCarSettlementViewControllerWithGoodsId:goodsId goodsNum:@"1"];
        }];
        
        [self.view addSubview:addCar];
    }
}
#pragma mark -- GoodParameterViewDelegate --
//图文详情下拉返回宝贝详情回调
-(void)endRefreshing
{
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.frame = CGRectMake(self.scrollView.viewX, 0, self.scrollView.viewWidth, self.scrollView.viewHeight);
        self.secondPage.frame = CGRectMake(self.secondPage.viewX, self.scrollView.viewHeight, self.secondPage.viewWidth, self.scrollView.viewHeight);
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark -- 网络请求 --
-(void)updateShopNum:(NSString *)Number{
    
    if ([Number isEqualToString:@""]) {
        self.shopNumLabel.text = nil;
        self.shopNumImageView.hidden = YES;
    }
    else{
        self.shopNumImageView.hidden = NO;
        if ([Number integerValue]>99) {
            self.shopNumLabel.text = @"99";
        }
        else{
            self.shopNumLabel.text = Number;
        }
        
    }
}

-(void)getShopCarNumNetWork
{
    //购物车数量
    if ([JCUserContext sharedManager].isUserLogedIn) {
        [GoodsDetailModle shopCarNumWithComplete:^(BOOL success, NSString *str) {
            if (success) {
                [self updateShopNum:str];
            }else{
                NSLog(@"%@",str);
            }
        }];
    }
    
}
-(void)netWork
{
    NSMutableDictionary * paramDic = [NSMutableDictionary dictionary];
    if ([JCUserContext sharedManager].currentUserInfo.memberID && [JCUserContext sharedManager].currentUserInfo.memberID.length > 0) {
        [paramDic setObject:self.goodsId forKey:@"goodsId"];
        [paramDic setObject:[JCUserContext sharedManager].currentUserInfo.memberID forKey:@"userId"];
    }
    else{
        [paramDic setObject:self.goodsId forKey:@"goodsId"];
    }
    [GoodsDetailModle goodsDetailInfoWithDic:paramDic complete:^(BOOL success, NSString *str, NSDictionary *data) {
        if (success) {
            if (data) {
                _shareButton.userInteractionEnabled = YES;
                self.view.userInteractionEnabled = YES;
                self.addCarBtn.userInteractionEnabled = YES;
                self.buyButton.userInteractionEnabled = YES;
                self.addCarBtn.backgroundColor = [UIColor colorWithHex:0xfd5487];
                self.buyButton.backgroundColor = [UIColor colorWithHex:0xff9402];
                _dataSourceDic = [NSDictionary dictionaryWithDictionary:data];
                if (_dataSourceDic[@"goods_info"][@"p_mansong"]||_dataSourceDic[@"goods_info"][@"p_tejia"]) {
                    self.goodsTopAlbum.viewHeight = self.goodsTopAlbum.viewHeight+35;
                    self.goodsInfoView.viewY =  self.goodsTopAlbum.viewBottomEdge;
                    _bottomView.viewY =  self.goodsInfoView.viewBottomEdge;
                }
                GoodsDetailModle * detailModle = [[GoodsDetailModle alloc]initWithJsonObject:data];
                [self addDataToInterfaceWithGoodDetailModle:detailModle];
            }
        }else{
            SHOW_EEROR_MSG(str);
        }
    }];
}
#pragma mark -- 把数据加载到视图 --
-(void)addDataToInterfaceWithGoodDetailModle:(GoodsDetailModle *)modle
{
    NSArray *images = [TYTools JSONObjectWithString:modle.goods_image_mobile];
    self.goodImage = images[0];
    GoodsInfoModle * infoModle = [modle modleFormGoods_Info_Str];
    /**
     * 上部图文详情
     */
    self.goodsTopAlbum.infoModele  = modle;
    /**
     * 判断是否显示 选择规格
     */
    if ([infoModle.spec_name isKindOfClass:[NSDictionary class]]) {
        self.bottomView.frame = CGRectMake(self.bottomView.viewX, self.chooseColorSize.viewBottomEdge, self.bottomView.viewWidth, self.bottomView.viewHeight);
        self.chooseColorSize.hidden = NO;
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.viewWidth, self.firstPage.viewBottomEdge)];
        NSDictionary * dic = (NSDictionary*)infoModle.spec_name;
        NSString * specName = @"";
        if ([dic isKindOfClass:[NSDictionary class]]) {
            for (NSString * key in dic.allKeys) {
                specName = [specName stringByAppendingString:dic[key]];
            }
        }
        self.chooseColorSize.text = [NSString stringWithFormat:@"选择%@",specName];
    }
    
    /**
     * 下拉的图文详情
     */
    self.goodsParameterView.textPicUrl = infoModle.goods_body;
    //规格
    self.goodsParameterView.paramArr = modle.parameter;
    //服务字段goods_body当前版本写死在界面的
    //self.goodsParameterView.serviceUrl = infoModle.goods_body;
    
}
#pragma mark -- 购物车动画 --
-(void)startAnimation
{
    self.addCarBtn.userInteractionEnabled = NO;
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 65, 65)];
    [image sd_setImageWithURL:[NSURL URLWithString:self.goodImage]];
    self.tempImageView = image;
    [self startAnimationWithRect:image.frame view:image];
}
-(void)startAnimationWithRect:(CGRect)rect view:(UIImageView *)view
{
    CGFloat width = (SCREEN_WIDTH /3);
    
    CALayer * layer = [CALayer layer];
    layer.contents = (id)view.layer.contents;
    layer.contentsGravity = kCAGravityResizeAspectFill;
    layer.bounds = rect;
        layer.position = CGPointMake(width, SCREEN_HEIGHT - 49);
    
    [self.view.layer addSublayer:layer];
    self.layer = layer;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //加减 15 是 微调
    [path moveToPoint:CGPointMake(width + width / 3 + 15, SCREEN_HEIGHT - 64 - 49/2 - 15)];
    //加减 15 是 微调
     [path addCurveToPoint:CGPointMake(width / 4, SCREEN_HEIGHT - 64 - 49/2 - 10) controlPoint1:CGPointMake(width, SCREEN_HEIGHT - 49 - 64 - 130 * W_ABCW) controlPoint2:CGPointMake(width, SCREEN_HEIGHT - 49 - 64 - 130 * W_ABCW)];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //narrowAnimation.beginTime = 0.5;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:0.5];
    narrowAnimation.duration = 1;
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.1];
    
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,narrowAnimation];
    groups.duration = 1;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    [layer addAnimation:groups forKey:@"group"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    SHOW_MSG(@"成功加入购物车");
    self.addCarBtn.userInteractionEnabled = YES;
    if (anim == [self.layer animationForKey:@"group"]) {
       
        [self.layer removeFromSuperlayer];
        self.layer = nil;
        self.tempImageView = nil;
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.25f;
        //self.shopNumLabel.text = ;
        [self.shopNumLabel.layer addAnimation:animation forKey:nil];
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
        shakeAnimation.toValue = [NSNumber numberWithFloat:5];
        shakeAnimation.autoreverses = YES;
        [self.shopNumImageView.layer addAnimation:shakeAnimation forKey:nil];
    }
}
/**
 *  会员直接激活【在界面显示激活的时候点击调用】
 */
- (void)VIPActivation {
    [GoodsDetailModle ReActivateVipWithComplete:^(BOOL success, NSString *str, NSDictionary *data) {
        [self.HUD hide:YES];
        if (success) {
            [self isVipSuccess];
        }else{
            SHOW_EEROR_MSG(str);
        }
    }];
}
/**
 *  获取用户VIP信息
 */
- (void)getVIPInfoRequest {
    if ([JCUserContext sharedManager].isUserLogedIn) {
        [GoodsDetailModle getVipInfoWithComplete:^(BOOL success, NSString *str, NSDictionary *data) {
            if (success) {
                _VIPInfoDic = data;
                [self isVipSuccess];
            }else{
                SHOW_EEROR_MSG(str);
            }
        }];
    }
}
-(void)isVipSuccess
{
    if ([[JCUserContext sharedManager].currentUserInfo.status isEqualToString:@""]) {
        self.goodsTopAlbum.beVIPBtn.hidden = NO;
    }
    else{
        NSInteger status = [[JCUserContext sharedManager].currentUserInfo.status integerValue];
        switch (status) {
            case 10:
                self.goodsTopAlbum.beVIPBtn.hidden = YES;
                break;
            default:
                self.goodsTopAlbum.beVIPBtn.hidden = NO;
                if (_dataSourceDic[@"goods_info"][@"p_tejia"]) {
                    self.goodsTopAlbum.beVIPBtn.hidden = YES;
                }
                break;
        }
    }
}
@end
