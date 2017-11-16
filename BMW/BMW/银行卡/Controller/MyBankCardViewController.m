//
//  MyBankCardViewController.m
//  DP
//
//  Created by 孙鹏 on 15/10/25.
//  Copyright (c) 2015年 sp. All rights reserved.
//

#import "MyBankCardViewController.h"
#import "AddBankCardViewController.h"
#import "MyBankCardView.h"
#import "BankCardModel.h"
#import "AskPasswordViewController.h"
#import "SetUpTradePasswordViewController.h"
#import "UserCenterModel.h"
#import "FindPasswordViewController.h"

@interface MyBankCardViewController ()<BankCardDelegate, SetPayPasswordDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) MyBankCardView * bankCardView;

@end

@implementation MyBankCardViewController

#pragma mark -- cicrle life

- (void)dealloc
{
    //删除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self refreshAction];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.title = @"我的银行卡";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTabelView:) name:@"bandingSuccess" object:nil];
    [self navigation];
    [self initUserInterface];
}

#pragma mark -- UI
- (void)initUserInterface
{
    _bankCardView = [[MyBankCardView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    _bankCardView.delegate = self;
    [self.view addSubview:_bankCardView];
    
}

#pragma mark -- 通知事件
- (void)updateTabelView:(NSNotification *)notification
{
    
   
}

#pragma mark -- BankCardDelegate
/**
 *  删除银行卡
 *
 *  @param bankCardView
 *  @param model        需要删除的银行卡
 */
- (void)bankCardView:(MyBankCardView *)bankCardView deleteWithModel:(BankCardModel *)model
{
    [BankCardModel deleteBankCardWithModel:model
                                  Complete:^(NSMutableArray<BankCardModel *> *models, NSString *message, NSInteger code) {
                                      if (code == 100) {
                                          SHOW_SUCCESS_MSG(message);
                                          [self.bankCardView.models removeObject:model];
                                          [self.bankCardView.tableView reloadData];
                                      }else {
                                          SHOW_EEROR_MSG(message);
                                      }
                                  }];
}


/**
 *  刷新
 */
- (void)refreshAction
{
    [self.HUD show:YES];
    [BankCardModel requestForBankCardListWithComplete:^(NSMutableArray<BankCardModel *> *models, NSString *message, NSInteger code) {
        [self.HUD hide:YES];
        [self.bankCardView.tableView.header endRefreshing];
        if (code == 100) {
            self.bankCardView.models = models;
            self.bankCardView.tableView.hidden = NO;
            self.bankCardView.remindNoCard.hidden = YES;
        }else if (code == 902) {
            [self.bankCardView.tableView reloadData];
        }else {
            SHOW_MSG(message);
        }
    }];
}


/**
 *  添加新的银行卡
 */
- (void)addNewBankCardAction
{
    if (![JCUserContext sharedManager].currentUserInfo.payPassword || ((NSString *)[JCUserContext sharedManager].currentUserInfo.payPassword).length == 0) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到您未设置交易密码，请设置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
        [alert show];
        return ;
    }

    AskPasswordViewController * askPasswordVC = [[AskPasswordViewController alloc] init];
    askPasswordVC.passwordType = PasswordVerify;
    [self.navigationController pushViewController:askPasswordVC animated:YES];
}

#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        FindPasswordViewController * updateVC = [[FindPasswordViewController alloc] init];
        updateVC.isPayVC = YES;
        updateVC.isPayPassword = YES;
        updateVC.delegate = self;
        [self.navigationController pushViewController:updateVC animated:YES];
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

@end
