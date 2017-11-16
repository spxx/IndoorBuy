//
//  OrderSuccessViewController.m
//  BMW
//
//  Created by rr on 16/3/17.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OrderSuccessViewController.h"
#import "OrderDetailViewController.h"
#import "UserInfoViewController.h"
#import "VIPMyInfoVC.h"
#import "RootTabBarVC.h"
//#import "BalancesViewController.h"
#import "AccountViewController.h"


@interface OrderSuccessViewController ()
{
    UIButton *_changeEdit;
    UILabel *_titleLabel;
    UILabel *_successF;
    UIButton *_lookOrder;
    UIButton *_backHome;
}
@end

@implementation OrderSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"支付成功";
    
    [self navigation];
    [self initInterface];
}

-(void)back{
    if (self.isRecgargeBalancesSuccess) {
        UIViewController * VC;
        for (UIViewController * controller in self.navigationController.viewControllers) {
            if ([VC isKindOfClass:[AccountViewController class]]) {
                VC = controller;
                break;
            }
        }
        if (VC) {
            [self.navigationController popToViewController:VC animated:YES];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

-(void)initInterface{
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(110*W_ABCW, 80*W_ABCH, 26, 26)];
    imageV.image = IMAGEWITHNAME(@"icon_chenggong_zfjg.png");
    [self.view addSubview:imageV];
    
    _successF = [[UILabel alloc] initWithFrame:CGRectMake(imageV.viewRightEdge+7*W_ABCW, 80*W_ABCH+7, 150, 12*W_ABCH)];
    _successF.text = @"订单支付成功";
    _successF.textColor = [UIColor colorWithHex:0x878787];
    _successF.font = fontForSize(12*W_ABCH);
    [self.view addSubview:_successF];
    
    _lookOrder = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100-18*W_ABCW, imageV.viewBottomEdge+43*W_ABCH, 100, 26*W_ABCH)];
    _lookOrder.layer.borderWidth = 0.5;
    _lookOrder.layer.borderColor = [UIColor colorWithHex:0x69696b].CGColor;
    _lookOrder.layer.cornerRadius = 3;
    _lookOrder.layer.masksToBounds = YES;
    [_lookOrder setTitle:@"查看订单" forState:UIControlStateNormal];
    [_lookOrder setTitleColor:[UIColor colorWithHex:0x3d3d3d] forState:UIControlStateNormal];
    _lookOrder.titleLabel.font = fontForSize(13*W_ABCH);
    [_lookOrder addTarget:self action:@selector(gotoOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_lookOrder];
    
    _backHome = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+18*W_ABCW, imageV.viewBottomEdge+43*W_ABCH, 100, 26*W_ABCH)];
    _backHome.layer.borderWidth = 0.5;
    _backHome.layer.borderColor = [UIColor colorWithHex:0xfd5478].CGColor;
    _backHome.layer.cornerRadius = 3;
    _backHome.layer.masksToBounds = YES;
    [_backHome setTitle:@"回到首页" forState:UIControlStateNormal];
    [_backHome setTitleColor:[UIColor colorWithHex:0xfd5478] forState:UIControlStateNormal];
    _backHome.titleLabel.font = fontForSize(13*W_ABCH);
    [_backHome addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backHome];
    
    if (self.isVipSuccess) {
        [imageV align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(90 * W_ABCW, 80*W_ABCH)];
        imageV.image = IMAGEWITHNAME(@"icon_tixing_ssjg");
        _successF.text = @"恭喜您已成为麦咖会员";
        [_successF align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(imageV.viewRightEdge+7*W_ABCW, 80*W_ABCH+7)];
        [_lookOrder setTitle:@"去逛逛" forState:UIControlStateNormal];
        [_backHome setTitle:@"查看麦咖信息" forState:UIControlStateNormal];
    }
    
    if (self.isRecgargeBalancesSuccess) {
        _successF.text = @"M币充值成功";
        [_successF align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(imageV.viewRightEdge+7*W_ABCW, 80*W_ABCH+7)];
        _lookOrder.hidden = YES;
        [_backHome setTitle:@"查看M币" forState:UIControlStateNormal];
        [_backHome align:ViewAlignmentTopLeft relativeToPoint:CGPointMake((SCREEN_WIDTH - _backHome.viewWidth) / 2, _backHome.viewY)];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)setWhereFrom:(BOOL)whereFrom{
    _whereFrom = whereFrom;
    if (_whereFrom) {
        
    }else{
        
    }
}


-(void)backHome{
    if (self.isVipSuccess) {
        [self getVIPInfoRequest];
    }
    else if (self.isRecgargeBalancesSuccess) {
        UIViewController * VC;
        for (UIViewController * controller in self.navigationController.viewControllers) {
            if ([VC isKindOfClass:[AccountViewController class]]) {
                VC = controller;
                break;
            }
        }
        if (VC) {
            [self.navigationController popToViewController:VC animated:YES];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    else {
        //回到首页
        RootTabBarVC *tabbar = ROOTVIEWCONTROLLER;
        tabbar.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
}

-(void)gotoOrder{
    if (self.isVipSuccess) {
        //去逛逛
        RootTabBarVC *tabbar = ROOTVIEWCONTROLLER;
        tabbar.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    else {
        //查看订单
        OrderDetailViewController *orderVC = [[OrderDetailViewController alloc] init];
        orderVC.backToRoot = YES;
        orderVC.orderId = self.orderID;
        [self.navigationController pushViewController:orderVC animated:YES];
    }
}

/**
 *  获取用户VIP信息
 */
- (void)getVIPInfoRequest {
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"VipInfo" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result == RequestResultSuccess) {
            NSDictionary * VIPInfoDic = [NSDictionary dictionaryWithDictionary:object[@"data"]];
            //更新保存下来的状态值
            if (![VIPInfoDic[@"status"] isKindOfClass:[NSNull class]]) {
                [[JCUserContext sharedManager] upDateObject:VIPInfoDic[@"status"] forKey:@"status"];
            }
            else {
                [[JCUserContext sharedManager] upDateObject:@"0" forKey:@"status"];
            }
            //查看麦咖信息
            VIPMyInfoVC * vipMyInfoVC = [[VIPMyInfoVC alloc] init];
            vipMyInfoVC.dataSourceDic = VIPInfoDic;
            [self.navigationController pushViewController:vipMyInfoVC animated:YES];
        }
        else {
            
        }
    }];
}
#pragma mark -- set --
-(void)setIsVipSuccess:(BOOL)isVipSuccess
{
    _isVipSuccess = isVipSuccess;
    if (_isVipSuccess) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"isVipSuccess" object:nil];
    }
}
@end


