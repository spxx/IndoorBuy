//
//  SetUpTradePasswordViewController.m
//  LDP
//
//  Created by 白琴 on 16/8/8.
//  Copyright © 2016年 baiqin. All rights reserved.
//

#import "SetUpTradePasswordViewController.h"
#import "UserCenterModel.h"

@interface SetUpTradePasswordViewController ()<UITextFieldDelegate> {
    UIButton * _getCodeButton;                  //获取验证码按钮
    UIButton * _showPasswordButton;             //显示密码
    UIButton * _finishButton;
    
    NSInteger _count;
    NSTimer * _timer;
}
/**
 *  验证码输入框
 */
@property (nonatomic, strong)UITextField * codeTextField;
/**
 *  密码输入框
 */
@property (nonatomic, strong)UITextField * passwordTextField;

@end

@implementation SetUpTradePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self initUserInterface];
}
#pragma mark -- 界面
- (void)initUserInterface {
    [self.view addSubview:self.codeTextField];
    [self.view addSubview:self.passwordTextField];
    
    _finishButton = [UIButton new];
    _finishButton.viewSize = CGSizeMake(SCREEN_WIDTH - 30, 45);
    [_finishButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, _passwordTextField.viewBottomEdge + 15 * W_ABCH)];
    [_finishButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xcccccc] andSize:_finishButton.viewSize] forState:UIControlStateNormal];
    [_finishButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xfc4e40] andSize:_finishButton.viewSize] forState:UIControlStateSelected];
    [_finishButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    _finishButton.userInteractionEnabled = NO;
    _finishButton.layer.cornerRadius = 4;
    _finishButton.layer.masksToBounds = YES;
    [_finishButton setTitle:@"确定" forState:UIControlStateNormal];
    [_finishButton addTarget:self action:@selector(finishButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_finishButton];
}

- (UITextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [UITextField new];
        _codeTextField.viewSize = CGSizeMake(SCREEN_WIDTH, 45 * W_ABCH);
        [_codeTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 10 * W_ABCH)];
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.font = [UIFont systemFontOfSize:13];
        _codeTextField.textColor = [UIColor colorWithHex:0x181818];
        _codeTextField.delegate = self;
        _codeTextField.backgroundColor = [UIColor whiteColor];
        _codeTextField.leftViewMode = UITextFieldViewModeAlways;
        _codeTextField.rightViewMode = UITextFieldViewModeAlways;
        UIView * codeLeftView = [UIView new];
        codeLeftView.viewSize = CGSizeMake(42 * W_ABCH, _codeTextField.viewHeight);
        [codeLeftView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, 0)];
        UIImageView * codeImageView = [UIImageView new];
        codeImageView.viewSize = CGSizeMake(17 * W_ABCH, 17 * W_ABCH);
        [codeImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, (codeLeftView.viewHeight - codeImageView.viewHeight) / 2)];
        [codeImageView setImage:[UIImage imageNamed:@"icon_yanzhengma_szjymm"]];
        [codeLeftView addSubview:codeImageView];
        _codeTextField.leftView = codeLeftView;
        [self.view addSubview:_codeTextField];
        //配置右侧获取验证码按钮
        UIView * codeRightView = [UIView new];
        codeRightView.viewSize = CGSizeMake(119 * W_ABCH, _codeTextField.viewHeight);
        [codeRightView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        _getCodeButton = [UIButton new];
        _getCodeButton.viewSize = CGSizeMake(84 * W_ABCH, 31 * W_ABCH);
        [_getCodeButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(codeRightView.viewRightEdge - 15, (codeRightView.viewHeight - _getCodeButton.viewHeight) / 2)];
        _getCodeButton.layer.borderWidth = 0.5;
        _getCodeButton.layer.borderColor = [UIColor colorWithHex:0xe1e1e1].CGColor;
        _getCodeButton.layer.cornerRadius = 4;
        [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getCodeButton setTitleColor:[UIColor colorWithHex:0x181818] forState:UIControlStateSelected];
        [_getCodeButton setTitleColor:[UIColor colorWithHex:0xc8c8ce] forState:UIControlStateNormal];
        [_getCodeButton addTarget:self action:@selector(getCodeButton:) forControlEvents:UIControlEventTouchUpInside];
        [_getCodeButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xffffff] andSize:_getCodeButton.viewSize] forState:UIControlStateNormal];
        [_getCodeButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xf5f5f5] andSize:_getCodeButton.viewSize] forState:UIControlStateHighlighted];
        _getCodeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [codeRightView addSubview:_getCodeButton];
        _codeTextField.rightView = codeRightView;
        
        //分割线
        UIView * lineView2 = [UIView new];
        lineView2.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5 * W_ABCH);
        [lineView2 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _codeTextField.viewBottomEdge)];
        lineView2.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [self.view addSubview:lineView2];
    }
    return _codeTextField;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        //密码输入框
        _passwordTextField = [UITextField new];
        _passwordTextField.viewSize = CGSizeMake(SCREEN_WIDTH, 45 * W_ABCH);
        [_passwordTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _codeTextField.viewBottomEdge + 0.5 * W_ABCH)];
        _getCodeButton.selected = YES;
        _passwordTextField.placeholder = @"请输入6位交易密码";
        _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
        _passwordTextField.font = [UIFont systemFontOfSize:13];
        _passwordTextField.textColor = [UIColor colorWithHex:0x181818];
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.delegate = self;
        _passwordTextField.backgroundColor = [UIColor whiteColor];
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        _passwordTextField.rightViewMode = UITextFieldViewModeAlways;
        UIView * passwordLeftView = [UIView new];
        passwordLeftView.viewSize = CGSizeMake(42 * W_ABCH, _passwordTextField.viewHeight);
        [passwordLeftView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, 0)];
        UIImageView * passwordImageView = [UIImageView new];
        passwordImageView.viewSize = CGSizeMake(17 * W_ABCH, 17 * W_ABCH);
        [passwordImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, (passwordLeftView.viewHeight - passwordImageView.viewHeight) / 2)];
        [passwordImageView setImage:[UIImage imageNamed:@"icon_mima_dlmmxg"]];
        [passwordLeftView addSubview:passwordImageView];
        _passwordTextField.leftView = passwordLeftView;
        [self.view addSubview:_passwordTextField];
        //配置右侧显示密码按钮
        UIButton * passwordRightView = [UIButton new];
        passwordRightView.viewSize = CGSizeMake(40 * W_ABCH, _passwordTextField.viewHeight);
        [passwordRightView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        _showPasswordButton = [UIButton new];
        _showPasswordButton.viewSize = CGSizeMake(16 * W_ABCH, 12 * W_ABCH);
        [_showPasswordButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(passwordRightView.viewRightEdge - 15 * W_ABCH, (passwordRightView.viewHeight - _showPasswordButton.viewHeight) / 2)];
        [_showPasswordButton setBackgroundImage:[UIImage imageNamed:@"icon_kejian_dlmmxg"] forState:UIControlStateNormal];
        [_showPasswordButton setBackgroundImage:[UIImage imageNamed:@"icon_xianshimima_cli"] forState:UIControlStateSelected];
        [_showPasswordButton addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
        [passwordRightView addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
        [passwordRightView addSubview:_showPasswordButton];
        _passwordTextField.rightView = passwordRightView;
        
        //分割线
        UIView * lineView2 = [UIView new];
        lineView2.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5 * W_ABCH);
        [lineView2 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _passwordTextField.viewBottomEdge)];
        lineView2.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [self.view addSubview:lineView2];
    }
    return _passwordTextField;
}
#pragma mark -- UITextFieldDelegate 
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //密码
    if (textField == _passwordTextField) {
        if (textField.text.length > 5&&![string isEqualToString:@""]) {
            _finishButton.userInteractionEnabled = _finishButton.selected;
            return NO;
        }
        if (textField.text.length>4&&![string isEqualToString:@""]) {
            if (_codeTextField.text.length > 0) {
                _finishButton.selected = YES;
            }
        }else
        {
            _finishButton.selected = NO;
        }
    }
    //验证码
    if (textField == _codeTextField) {
        if (textField.text.length > 5&&![string isEqualToString:@""]) {
            _finishButton.userInteractionEnabled = _finishButton.selected;
            return NO;
        }
        if (textField.text.length>4&&![string isEqualToString:@""]) {
            if (_passwordTextField.text.length > 5 && _passwordTextField.text.length < 7) {
                _finishButton.selected = YES;
            }
        }else
        {
            _finishButton.selected = NO;
        }
    }
    _finishButton.userInteractionEnabled = _finishButton.selected;
    return YES;
}


#pragma mark -- 点击
/**
 *  点击获取验证码
 */
- (void)getCodeButton:(UIButton *)sender
{
    NSLog(@"点击获取验证码");
    [self.view endEditing:YES];
//    [UserCenterModel requestForGetPayCodeWithPhone:[JCUserContext sharedManager].currentUserInfo.mobile Complete:^(NSString *message, NSInteger code) {
//        if (code == 100) {
//            SHOW_SUCCESS_MSG(message);
//        }else{
//            SHOW_EEROR_MSG(message);
//        }
//    }];
    _getCodeButton.userInteractionEnabled = NO;
    _count = 60;
    _getCodeButton.selected = YES;
    [_getCodeButton setTitle:[NSString stringWithFormat:@"%ld秒",(long)_count] forState:UIControlStateNormal];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduce:) userInfo:nil repeats:YES];
    [_timer fire];
}

/**
 *  显示密码
 */
- (void)showPassword:(UIButton *)sender {
    sender.selected = !sender.selected;
    _showPasswordButton.selected = sender.selected;
    if (sender.selected) {
        _passwordTextField.secureTextEntry = NO;
    }
    else {
        _passwordTextField.secureTextEntry = YES;
    }
}
/**
 *  点击确定
 */
- (void)finishButton:(UIButton *)sender {
    NSLog(@"点击确定");
    [self.view endEditing:YES];
    [UserCenterModel requestForSetPayPasswordWithVerify:_codeTextField.text newPass:_passwordTextField.text Complete:^(NSString *message, NSInteger code) {
        if (code == 100) {
            if ([self.title isEqualToString:@"设置交易密码"]) {
                SHOW_SUCCESS_MSG(@"交易密码设置成功");
            }else {
                SHOW_SUCCESS_MSG(@"交易密码修改成功");
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            SHOW_EEROR_MSG(message);
        }
    }];
}

#pragma mark - - 其他
/**
 *  倒计时
 */
- (void)reduce:(NSTimer *)time
{
    _count--;
    if (_count == 0) {
        _count = 0;
        _getCodeButton.selected = YES;
        _getCodeButton.userInteractionEnabled = YES;
        [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        _timer = nil;
        return;
    }
    [_getCodeButton setTitle:[NSString stringWithFormat:@"%ld秒",(long)_count] forState:UIControlStateNormal];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


@end
