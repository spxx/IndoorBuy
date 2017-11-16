//
//  AskPasswordViewController.m
//  DP
//
//  Created by rr on 16/8/1.
//  Copyright © 2016年 sp. All rights reserved.
//

#import "AskPasswordViewController.h"
#import "AddBankCardViewController.h"
#import "UserCenterModel.h"
#import "WithdrawModel.h"
#import "PayMethodModel.h"
#import "WithdrawSuccessVC.h"

@interface AskPasswordViewController ()<UITextFieldDelegate>
{
    UITextField *_onePass;
    UILabel *_moneyLabel;
}

@end

@implementation AskPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigation];
    self.title = @"请输入交易密码";
    if (self.passwordType == PasswordVerify) {
        self.title = @"添加银行卡";
    }
    [self initUserInterface];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_onePass becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_onePass resignFirstResponder];

}

#pragma mark -- UI
-(void)initUserInterface
{
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    
    UILabel *applyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20*W_ABCH, SCREEN_WIDTH, 15*W_ABCH)];
    applyLabel.textColor = [UIColor colorWithHex:0x181818];
    applyLabel.font = fontForSize(15*W_ABCH);
    applyLabel.text = @"提现金额（元）";
    applyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:applyLabel];
    
    _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, applyLabel.viewBottomEdge+10*W_ABCW, SCREEN_WIDTH, 15*W_ABCH)];
    _moneyLabel.text = _money;
    _moneyLabel.textColor = COLOR_NAVIGATIONBAR_BARTINT;
    _moneyLabel.font = fontForSize(15*W_ABCH);
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_moneyLabel];
    
    if (self.passwordType == PasswordVerify) {
        [applyLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 40*W_ABCH)];
        applyLabel.text = @"请输入交易密码,以验证身份";
        [_moneyLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, applyLabel.viewBottomEdge+5*W_ABCW)];
        _moneyLabel.viewHeight = 0;
    }
    
    _onePass = [[UITextField alloc] init];
    _onePass.textColor = [UIColor colorWithHex:0x181818];
    _onePass.font = fontBoldForSize(20);
    _onePass.delegate = self;
    _onePass.keyboardType = UIKeyboardTypeNumberPad;
    _onePass.secureTextEntry = YES;
    _onePass.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_onePass];
    
    CGFloat width = 45 * W_ABCW * 6;
    UIView *passView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - width) / 2, _moneyLabel.viewBottomEdge + 16*W_ABCW, width, 45 * W_ABCW)];
    passView.layer.borderWidth = 0.5*W_ABCW;
    passView.layer.borderColor = COLOR_NAVIGATIONBAR_BARTINT.CGColor;
    passView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginPass)];
    [passView addGestureRecognizer:tap];
    [self.view addSubview:passView];
    
    CGFloat itemWidth = passView.viewWidth / 6.0;
    
    for (int i = 0; i < 6; i++) {
        if (i < 5) {
            UIView *shuL = [[UIView alloc] initWithFrame:CGRectMake(itemWidth + i * itemWidth, 0, 0.5, passView.viewHeight)];
            shuL.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
            [passView addSubview:shuL];
        }
        UIImageView *blackImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18*W_ABCW, 18*W_ABCW)];
        [blackImageV align:ViewAlignmentCenter relativeToPoint:CGPointMake(i * itemWidth + itemWidth / 2, passView.viewHeight / 2)];
        blackImageV.backgroundColor = [UIColor blackColor];
        blackImageV.layer.cornerRadius = blackImageV.viewWidth / 2;
        blackImageV.layer.masksToBounds = YES;
        blackImageV.tag = 555+i;
        blackImageV.hidden = YES;
        [passView addSubview:blackImageV];
    }
}

#pragma mark -- setter
-(void)setMoney:(NSString *)money
{
    _money = [NSString stringWithFormat:@"%.2f",[money doubleValue]];
    if (_moneyLabel) {
        _moneyLabel.text = money;
    }
}

- (void)setModel:(BankCardModel *)model
{
    _model = model;
}

#pragma mark -- actions
-(void)beginPass{
    
//    if (_orderMoney>_payMoney) {
//        SHOW_EEROR_MSG(@"余额不足，请选择其他支付方式");
//    }else{
//        [_onePass becomeFirstResponder];
//    }
}

#pragma mark -- UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        NSLog(@"回滚:%ld, %@",textField.text.length, textField.text);

        UIImageView *imageV = [self.view viewWithTag:554+textField.text.length];
        imageV.hidden = YES;

    }else{
        NSLog(@"下一个%ld, %@",textField.text.length, textField.text);
        UIImageView *imageV = [self.view viewWithTag:555+textField.text.length];
        imageV.hidden = NO;
        NSString *finishString = [NSString stringWithFormat:@"%@%@",_onePass.text, string];
        if (finishString.length == 6) {
            
            [PayMethodModel requestForVerifyWithPassword:finishString complete:^(BOOL isSuccess, NSString *message) {
                if (isSuccess) {
                    [self finishInputActionWithPassword:finishString];
                }else {
                    SHOW_EEROR_MSG(message);
                }
            }];
            
        }else if(finishString.length>6){
            return NO;
        }
    }
    return YES;
}

#pragma mark -- private
-(void)finishInputActionWithPassword:(NSString *)password
{
    if (self.passwordType == PasswordVerify) {
        //添加银行卡
        AddBankCardViewController * addCardVC = [[AddBankCardViewController alloc] init];
        [self.navigationController pushViewController:addCardVC animated:YES];
    }else{
        //申请提现
        NSString * userID = [JCUserContext sharedManager].currentUserInfo.memberID;
        NSDictionary * paraDic = @{@"cardId":self.model.bankCardID,
                                   @"amount":_money,
                                   @"userId":userID,
                                   @"pay_password":password};
        [self.HUD show:YES];
        [WithdrawModel requestFotWithdrawWithParaDic:paraDic complete:^(BOOL isSuccess, NSString *message) {
            [self.HUD hide:YES];
            if (isSuccess) {
                WithdrawSuccessVC * successVC = [[WithdrawSuccessVC alloc] init];
                [self.navigationController pushViewController:successVC animated:YES];
            }else {
                SHOW_EEROR_MSG(message);
            }
        }];
    }
}

@end
