//
//  AddBankCardViewController.m
//  DP
//
//  Created by gukai on 15/10/27.
//  Copyright (c) 2015年 sp. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "AddBankCardView.h"
#import "BankCardModel.h"
#import "UserProtocolVC.h"
#import "addBank.h"

@interface AddBankCardViewController ()<AddBankCardViewDelegate>

@property (nonatomic, strong) AddBankCardView * addBankCardView;

@end

@implementation AddBankCardViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"绑定银行卡";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self navigation];
    
    // 移除stack里的输入交易密码控制器
    NSMutableArray * VCs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [VCs removeObjectAtIndex:VCs.count - 2];
    self.navigationController.viewControllers = VCs;
    [self initUserInterface];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark -- UI
-(void)initUserInterface
{
    _addBankCardView = [[AddBankCardView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight - 64)];
    _addBankCardView.delegate = self;
    [self.view addSubview:_addBankCardView];
}

#pragma mark -- AddBankCardViewDelegate
// 绑定银行卡
- (void)addCardView:(AddBankCardView *)addCardView
     clickedBindBtn:(UIButton *)btn
               name:(NSString *)name
            cardNum:(NSString *)cardNum
           bankName:(NSString *)bankName
{
    [self.HUD show:YES];
    [BankCardModel addBankCardWithName:name
                               cardNum:cardNum
                              bankName:bankName
                              Complete:^(NSMutableArray<BankCardModel *> *models, NSString *message, NSInteger code) {
        [self.HUD hide:YES];
        if (code == 100) {
            SHOW_SUCCESS_MSG(@"绑定成功");
            [self.addBankCardView clearText];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            SHOW_EEROR_MSG(message);
        }
    }];
}
// 用户协议
- (void)addCardViewCheckUserProtocolAction
{
    UserProtocolVC * protocolVC = [[UserProtocolVC alloc] init];
    [self.navigationController pushViewController:protocolVC animated:YES];
}

@end
