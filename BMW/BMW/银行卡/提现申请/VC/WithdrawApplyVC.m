//
//  WithdrawApplyVC.m
//  DP
//
//  Created by LiuP on 15/10/27.
//  Copyright © 2015年 sp. All rights reserved.
//

#import "WithdrawApplyVC.h"
#import "ApplyRecordCell.h"
#import "WithdrawView.h"
#import "AskPasswordViewController.h"
#import "WithApplyRecordViewController.h"
#import "WithdrawBankCardView.h"
#import "AddBankCardViewController.h"
#import "UserCenterModel.h"
//#import "SetUpTradePasswordViewController.h"
#import "FindPasswordViewController.h"

@interface WithdrawApplyVC ()<WithdrawViewDelegate, WithdrawBankCardViewDelegate,UIAlertViewDelegate,SetPayPasswordDelegate>

@property (nonatomic,copy) NSArray * userBankArray;
@property (nonatomic,copy) NSString * userBankInfoId;

@property (nonatomic, copy) NSString * start;

@property (nonatomic, strong) WithdrawView * withView;
@property (nonatomic, strong) WithdrawBankCardView * cardView;
@property (nonatomic, retain) BankCardModel * selectedModel;
@end

@implementation WithdrawApplyVC

- (void)dealloc
{
    [self.cardView removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUserInterface];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UserCenterModel updateUserInfoWithComplete:^(NSString *message, NSInteger code) {
        NSLog(@"message = %@, code = %ld", message, code);
        if(code == 100){
//            _withView.totalCash.text = [JCUserContext sharedManager].currentUserInfo.money;
        }
    }];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];    
}

#pragma mark -- UI
- (void)initUserInterface
{
    [self navigation];
    self.title = @"提现";
    [self initRightItem];
    
    _withView = [[WithdrawView alloc] initWithFrame:self.view.bounds];
    _withView.delegate = self;
    [self.view addSubview:_withView];
    
    // 可提现金额
    NSString * cash = [JCUserContext sharedManager].currentUserInfo.availableIncome;
    _withView.totalCash.text = [NSString stringWithFormat:@"%.2f",[cash floatValue]];
    
    /**
     选择银行卡弹框
     
     */
    _cardView = [[WithdrawBankCardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _cardView.delegate = self;
    _cardView.hidden = YES;
    RootTabBarVC * rootVC = ROOTVIEWCONTROLLER;
    [rootVC.view addSubview:_cardView];
}

- (void)initRightItem
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = fontForSize(15);
    [button setTitle:@"提现记录" forState:UIControlStateNormal];
    [button setTitleColor:COLOR_NAVIGATIONBAR_ITEM forState:UIControlStateNormal];
    [button addTarget:self action:@selector(withdrawRecordAction:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setRightBarButtonItem:rightItem animated:YES];;
}

#pragma mark -- WithdrawViewDelegate
// 点击选择银行
- (void)withdrawView:(WithdrawView *)WithdrawView clickedBankWithBtn:(UIButton *)btn
{
    self.cardView.hidden = NO;
    [self initGetBankCardListRequest];
}
// 提现
-(void)withdrawView:(WithdrawView *)WithdrawView clickedWithdrawWithCash:(UITextField *)cash
{
    NSLog(@"申请提现");
    if (_withView.outputCash.text.length > 0) {
        if (_withView.userBankLabel.text.length == 0 || [_withView.userBankLabel.text isKindOfClass:[NSNull class]] || [_withView.userBankLabel.text isEqualToString:@"选择银行卡"]) {
            SHOW_MSG(@"请先选择银行卡");
            return;
        }
        if ([cash.text floatValue] == 0) {
            SHOW_MSG(@"请输入提现金额");
            return;
        }
        if (cash.text.floatValue > _withView.totalCash.text.floatValue) {
            SHOW_MSG(@"您的账户余额不足");
            return;
        }
        if (cash.text.floatValue < 100) {
            SHOW_MSG(@"提现金额必须大于100，请重新输入");
            return;
        }
        AskPasswordViewController *askVC = [[AskPasswordViewController alloc] init];
        askVC.model = self.selectedModel;
        askVC.money = _withView.outputCash.text;
        [self.navigationController pushViewController:askVC animated:YES];
    }else{
        SHOW_MSG(@"请输入提现金额");
    }
}



#pragma mark -- SetPayPasswordDelegate
// 设置交易密码成功
- (void)setPayPasswordSuccess
{
    //添加银行卡
    AddBankCardViewController * addCardVC = [[AddBankCardViewController alloc] init];
    [self.navigationController pushViewController:addCardVC animated:YES];
}

#pragma mark alterViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==alertView.firstOtherButtonIndex) {
        FindPasswordViewController * updateVC = [[FindPasswordViewController alloc] init];
        updateVC.isPayVC = YES;
        updateVC.isPayPassword = YES;
        updateVC.delegate = self;
        [self.navigationController pushViewController:updateVC animated:YES];
    }
}

#pragma mark -- WithdrawBankCardViewDelegate
//选择了银行
- (void)cardView:(WithdrawBankCardView *)cardView chooseBankCardWithModel:(BankCardModel *)model
{
    cardView.hidden = YES;
    if (model.bankCardID.integerValue == -1) {
        NSLog(@"使用新卡");
        if (![JCUserContext sharedManager].currentUserInfo.payPassword || ((NSString *)[JCUserContext sharedManager].currentUserInfo.payPassword).length == 0) {
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您尚未设置交易密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即设置", nil];
            [alterView show];
        }else{
            AskPasswordViewController * askPasswordVC = [[AskPasswordViewController alloc] init];
            askPasswordVC.passwordType = PasswordVerify;
            [self.navigationController pushViewController:askPasswordVC animated:YES];
        }
    }else {
        self.selectedModel = model;
        self.withView.userBankLabel.text = [NSString stringWithFormat:@"%@（%@）", model.bank, model.bankCardNum];
    }
}

#pragma mark - 网络请求
//获取银行卡列表
- (void)initGetBankCardListRequest
{
    [WithdrawModel requestForBanCardListWithComplete:^(NSMutableArray<BankCardModel *> *models, NSString *message, NSInteger code) {
        if (code == 100) {
            self.cardView.models = models;
        }else {
            self.cardView.models = [NSMutableArray array];
        }
    }];
}

#pragma mark -- actions
-(void)withdrawRecordAction:(UIBarButtonItem *)item
{
    if ([JCUserContext sharedManager].isUserLogedIn) {
        //提现记录
        WithApplyRecordViewController *withApplyVC = [[WithApplyRecordViewController alloc] init];
        [self.navigationController pushViewController:withApplyVC animated:YES];
    }else{
        LoginViewController *userLogin = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:userLogin animated:YES];
    }
    
}


@end
