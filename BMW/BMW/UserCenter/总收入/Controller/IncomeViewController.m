//
//  IncomeViewController.m
//  BMW
//
//  Created by LiuP on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "IncomeViewController.h"
#import "IncomeView.h"
#import "WithdrawApplyVC.h"


@interface IncomeViewController ()<IncomeViewDelegate>

@property (nonatomic, strong) IncomeView * incomeView;

@property (nonatomic, assign) MemberType member;

@end

@implementation IncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUserInterface];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self requestForIncome];
}

#pragma mark -- UI
- (void)initUserInterface
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的收入";
    [self navigation];
    
    NSString * level = [JCUserContext sharedManager].currentUserInfo.vip_level;
    switch (level.integerValue) {
        case 1: self.member = MemberMK;
            break;
        case 2: self.member = MemberService;
            break;
        case 3: self.member = MemberPartner;
            break;
        default:
            break;
    }
    _incomeView = [[IncomeView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight - 64)
                                             member:self.member];
    _incomeView.delegate = self;
    [self.view addSubview:_incomeView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = fontForSize(15);
    [button setTitle:@"提现" forState:UIControlStateNormal];
    [button setTitleColor:COLOR_NAVIGATIONBAR_ITEM forState:UIControlStateNormal];
    [button addTarget:self action:@selector(withdrawAction:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

- (void)requestForIncome
{
    [self.HUD show:YES];
    [IncomeModel requestForIncomeWithMember:self.member Complete:^(BOOL isSuccess, IncomeModel * model, NSString * message) {
        [self.HUD hide:YES];
        if (isSuccess) {
            self.incomeView.model = model;
        }else {
            SHOW_EEROR_MSG(message);
        }
    }];
}

#pragma mark -- actions
- (void)withdrawAction:(UIButton *)sender
{
    NSLog(@"提现");
    WithdrawApplyVC * withdrawApplyVC = [[WithdrawApplyVC alloc] init];
    [self.navigationController pushViewController:withdrawApplyVC animated:YES];
}

#pragma mark -- IncomeViewDelegate

@end
