//
//  CouponCenterViewController.m
//  BMW
//
//  Created by LiuP on 2016/12/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "CouponCenterViewController.h"
#import "CouponCenterView.h"
#import "AlertView.h"
#import "UserCouponViewController.h"

@interface CouponCenterViewController ()<CouponViewDelegate, AlertViewDelegate>

@property (nonatomic, strong) CouponCenterView * couponView;

@property (nonatomic, strong) AlertView * successAlert;

@property (nonatomic, strong) AlertView * limitAlert;

@end

@implementation CouponCenterViewController
- (void)dealloc
{
    if (_successAlert) {
        [_successAlert removeFromSuperview];
        _successAlert = nil;
    }
    if (_limitAlert) {
        [_limitAlert removeFromSuperview];
        _limitAlert = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    
    [self initUserInterface];
    [self requestForCouponListWithHUDShow:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)initUserInterface
{
    self.title = @"领券中心";
    [self navigation];
    
    _couponView = [[CouponCenterView alloc] initWithFrame:self.view.bounds];
    _couponView.delegate = self;
    [self.view addSubview:_couponView];
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = fontForSize(15);
    [button setTitle:@"我的券" forState:UIControlStateNormal];
    [button setTitleColor:COLOR_NAVIGATIONBAR_ITEM forState:UIControlStateNormal];
    [button addTarget:self action:@selector(myCouponAction:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];    
}

#pragma mark -- getter
- (AlertView *)successAlert
{
    if (!_successAlert) {
        _successAlert = [[AlertView alloc] initWithTarget:self AlertType:AlertGetCouponSuccess];
        [self.navigationController.view addSubview:_successAlert];
    }
    return _successAlert;
}

- (AlertView *)limitAlert
{
    if (!_limitAlert) {
        _limitAlert = [[AlertView alloc] initWithTarget:self AlertType:AlertGetCouponLimit];
        [self.navigationController.view addSubview:_limitAlert];
    }
    return _limitAlert;
}

#pragma mark -- 获取优惠券列表
/**
 获取优惠券列表
 */
- (void)requestForCouponListWithHUDShow:(BOOL)show
{
    if (show) {
        [self.HUD show:YES];
    }
    [CouponModel requestForCouponListWithComplete:^(BOOL isSuccess, NSMutableArray *models, NSString *message) {
        if (show) {
            [self.HUD hide:YES];
        }
        if (isSuccess) {
            self.couponView.models = models;
        }else {
            SHOW_EEROR_MSG(message);
        }
    }];
}

/**
 领取优惠券

 @param couponID
 */
- (void)requestForGetCouponWithCouponID:(CouponModel *)model
{
    if (model.status.integerValue == 2) { // 不可领取
        [self.limitAlert show:NO];
        return;
    }
    [self.HUD show:YES];
    [CouponModel requestForGetCouponWithCouponID:model.couponID complete:^(BOOL isSuccess, NSString *message) {
        [self.HUD hide:YES];
        if (isSuccess) {
            [self.successAlert show:NO];
            [self requestForCouponListWithHUDShow:NO];
        }else {
            [self.limitAlert show:NO];
        }
    }];
}

#pragma mark -- actions
- (void)myCouponAction:(UIButton *)sender
{
    NSLog(@"我的券");
    UserCouponViewController * userCouponVC = [[UserCouponViewController alloc] init];
    [self.navigationController pushViewController:userCouponVC animated:YES];
}

#pragma mark -- CouponViewDelegate
- (void)couponView:(CouponCenterView *)couponView didSelectedGetBtnWithModel:(CouponModel *)model
{
    [self requestForGetCouponWithCouponID:model];
}

#pragma mark -- AlertViewDelegate

@end
