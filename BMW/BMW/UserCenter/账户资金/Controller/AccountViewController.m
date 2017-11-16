//
//  AccountViewController.m
//  BMW
//
//  Created by LiuP on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "AccountViewController.h"
#import "RechargeViewController.h"
#import "RechargeRecordViewController.h"

@interface AccountViewController ()<AccountViewDelegate>

@property (nonatomic, strong) AccountView * accountView;

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUserInterface];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self requestForMCash];
}


#pragma mark -- UI

- (void)initUserInterface
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigation];
    
    _accountView = [[AccountView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight - 64)
                                              account:self.account];
    _accountView.delegate = self;
    [self.view addSubview:_accountView];
    
    if (self.account == AccountCash) {
        self.title = @"余额";
    }else {
        self.title = @"M币账户";
    }
}

#pragma mark -- 刷新M币
- (void)requestForMCash
{
    [self.HUD show:YES];
    [AccountModel requestForMCashWithUserID:nil Complete:^(BOOL isSuccess, AccountModel *model, NSString *message) {
        [self.HUD hide:YES];
        if (isSuccess) {
            _accountView.model = model;
        }else {
            SHOW_EEROR_MSG(message);
        }
    }];
}

#pragma mark -- AccountViewDelegate
- (void)accountView:(AccountView *)accountView didSelectedMenuWithItem:(ItemType)item
{
    switch (item) {
        case ItemMPay:{
            NSLog(@"M币充值");
            //充值
            RechargeViewController * rechargeVC = [[RechargeViewController alloc] init];
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }
            break;
        case ItemMRecord:{
            NSLog(@"M币充值记录");
            //充值记录
            RechargeRecordViewController * rechargeRecordVC = [[RechargeRecordViewController alloc] init];
            rechargeRecordVC.isRecharge = YES;
            [self.navigationController pushViewController:rechargeRecordVC animated:YES];
        }
            break;
        case ItemCashPay:{
        }
            break;
        case ItemCashRecord:{

        }
            break;
        case ItemCapitalRecord:{
            //资金记录
            RechargeRecordViewController * rechargeRecordVC = [[RechargeRecordViewController alloc] init];
            rechargeRecordVC.isRecharge = NO;
            [self.navigationController pushViewController:rechargeRecordVC animated:YES];
        }
            break;
        default:
            break;
    }
}


@end
