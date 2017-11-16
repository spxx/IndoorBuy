//
//  FindPasswordViewController.m
//  BMW
//
//  Created by 白琴 on 16/3/2.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "FindPasswordViewController.h"

@interface FindPasswordViewController () <UITextFieldDelegate> {
    UITextField * _codeTextField;
    UITextField * _passwordTextField;
    UITextField * _mobileTextField;
    UIButton * _getCodeButton;
    UIButton * _finishButton;
    UIButton * _showPasswordButton;
    
    NSInteger _count;
    NSTimer * _timer;
}

@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isPayPassword) {
        if (![JCUserContext sharedManager].currentUserInfo.payPassword || ((NSString *)[JCUserContext sharedManager].currentUserInfo.payPassword).length == 0) {
            self.title = @"设置交易密码";
        }
        else {
            self.title = @"修改交易密码";
        }
    }
    else {
        self.title = @"找回密码";
    }
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    
    [self navigation];
    
    [self initUserInterface];
}

#pragma mark -- 界面
- (void)initUserInterface {
    //手机号码输入框
    _mobileTextField = [UITextField new];
    _mobileTextField.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
    [_mobileTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 10)];
    if (_isPrsent) {
        [_mobileTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 10+64)];
    }
    _mobileTextField.placeholder = @"请输入手机号码";
    _mobileTextField.font = fontForSize(13);
    _mobileTextField.delegate = self;
    _mobileTextField.backgroundColor = [UIColor whiteColor];
    _mobileTextField.textColor = [UIColor colorWithHex:0x181818];
    _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    //创建一个左侧视图
    _mobileTextField.leftViewMode = UITextFieldViewModeAlways;
    UIView * mobileLeftView = [UIView new];
    mobileLeftView.viewSize = CGSizeMake(42, _mobileTextField.viewHeight);
    [mobileLeftView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
    //在左侧视图上面添加一个图片视图
    UIImageView * mobileImageView = [UIImageView new];
    mobileImageView.viewSize = CGSizeMake(15, 22);
    [mobileImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, (mobileLeftView.viewHeight - mobileImageView.viewHeight) / 2)];
    [mobileImageView setImage:[UIImage imageNamed:@"icon_shouji_dl"]];
    [mobileLeftView addSubview:mobileImageView];
    //将左侧视图添加到TextField上
    _mobileTextField.leftView = mobileLeftView;
    [self.view addSubview:_mobileTextField];
    //分割线
    UIView * lineView = [UIView new];
    lineView.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
    [lineView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _mobileTextField.viewBottomEdge)];
    lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self.view addSubview:lineView];
    
    //验证码输入框
    _codeTextField = [UITextField new];
    _codeTextField.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
    if (self.isPayPassword) {
        _mobileTextField.hidden = YES;
        [_codeTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 10)];
    }
    else {
        [_codeTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, lineView.viewBottomEdge)];
    }
    
    _codeTextField.placeholder = @"请输入验证码";
    _codeTextField.font = fontForSize(13);
    _codeTextField.textColor = [UIColor colorWithHex:0x181818];
    _codeTextField.delegate = self;
    _codeTextField.backgroundColor = [UIColor whiteColor];
    _codeTextField.leftViewMode = UITextFieldViewModeAlways;
    _codeTextField.rightViewMode = UITextFieldViewModeAlways;
    UIView * codeLeftView = [UIView new];
    codeLeftView.viewSize = CGSizeMake(42, _codeTextField.viewHeight);
    [codeLeftView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
    UIImageView * codeImageView = [UIImageView new];
    codeImageView.viewSize = CGSizeMake(14, 16);
    [codeImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, (codeLeftView.viewHeight - codeImageView.viewHeight) / 2)];
    [codeImageView setImage:[UIImage imageNamed:@"icon_yanzhengma_zc"]];
    [codeLeftView addSubview:codeImageView];
    _codeTextField.leftView = codeLeftView;
    [self.view addSubview:_codeTextField];
    //配置右侧获取验证码按钮
    UIView * codeRightView = [UIView new];
    codeRightView.viewSize = CGSizeMake(119, _codeTextField.viewHeight);
    [codeRightView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
    _getCodeButton = [UIButton new];
    _getCodeButton.viewSize = CGSizeMake(84, 31);
    [_getCodeButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(codeRightView.viewRightEdge - 15, (codeRightView.viewHeight - _getCodeButton.viewHeight) / 2)];
    [_getCodeButton setBackgroundImage:[UIImage imageNamed:@"icon_yanzhengkuang_zc"] forState:UIControlStateNormal];
    [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getCodeButton setTitleColor:[UIColor colorWithHex:0x181818] forState:UIControlStateSelected];
    [_getCodeButton setTitleColor:[UIColor colorWithHex:0xc8c8ce] forState:UIControlStateNormal];
    [_getCodeButton addTarget:self action:@selector(getCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    _getCodeButton.userInteractionEnabled = NO;
    _getCodeButton.titleLabel.font = fontForSize(13);
    [codeRightView addSubview:_getCodeButton];
    _codeTextField.rightView = codeRightView;
    
    /**
     *  判断上次的倒计时是否还存在
     */
    if ([JCUserContext sharedManager].otherPhone) {
        _mobileTextField.text = [JCUserContext sharedManager].otherPhone;
        _getCodeButton.selected = YES;
        _getCodeButton.userInteractionEnabled = YES;
    }
    if (self.isPayPassword) {
        //交易密码
        if ([JCUserContext sharedManager].payPasswordCount != 0) {
            _getCodeButton.selected = YES;
            _getCodeButton.userInteractionEnabled = NO;
            [_getCodeButton setTitle:[NSString stringWithFormat:@"%ld秒",(long)[JCUserContext sharedManager].payPasswordCount] forState:UIControlStateNormal];
            _count = [JCUserContext sharedManager].payPasswordCount;
            //上一个timer
            [[JCUserContext sharedManager].payPasswordTimer invalidate];
            [JCUserContext sharedManager].payPasswordTimer = nil;
            //重开一个timer【不然不走倒计时】
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduce:) userInfo:nil repeats:YES];
        }
        else {
            _getCodeButton.userInteractionEnabled = YES;
        }
    }
    else {
        if ([JCUserContext sharedManager].otherCount != 0) {
            _getCodeButton.selected = YES;
            _getCodeButton.userInteractionEnabled = NO;
            [_getCodeButton setTitle:[NSString stringWithFormat:@"%ld秒",(long)[JCUserContext sharedManager].otherCount] forState:UIControlStateNormal];
            _count = [JCUserContext sharedManager].otherCount;
            //上一个timer
            [[JCUserContext sharedManager].otherTimer invalidate];
            [JCUserContext sharedManager].otherTimer = nil;
            //重开一个timer【不然不走倒计时】
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduce:) userInfo:nil repeats:YES];
        }
    }
    
    
    
    
    //分割线
    UIView * lineView1 = [UIView new];
    lineView1.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
    [lineView1 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _codeTextField.viewBottomEdge)];
    lineView1.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self.view addSubview:lineView1];
    
    //密码输入框
    _passwordTextField = [UITextField new];
    _passwordTextField.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
    [_passwordTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, lineView1.viewBottomEdge)];
    if (self.isPayPassword) {
        _getCodeButton.selected = YES;
        _passwordTextField.placeholder = @"请输入新密码(6位数字组合)";
        _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else {
        _passwordTextField.placeholder = @"请输入新密码(6-12位数字或字母组合)";
    }
    _passwordTextField.font = fontForSize(13);
    _passwordTextField.textColor = [UIColor colorWithHex:0x181818];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.delegate = self;
    _passwordTextField.backgroundColor = [UIColor whiteColor];
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    _passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    UIView * passwordLeftView = [UIView new];
    passwordLeftView.viewSize = CGSizeMake(42, _passwordTextField.viewHeight);
    [passwordLeftView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
    UIImageView * passwordImageView = [UIImageView new];
    passwordImageView.viewSize = CGSizeMake(14, 18);
    [passwordImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, (passwordLeftView.viewHeight - passwordImageView.viewHeight) / 2)];
    [passwordImageView setImage:[UIImage imageNamed:@"icon_mima_dl"]];
    [passwordLeftView addSubview:passwordImageView];
    _passwordTextField.leftView = passwordLeftView;
    [self.view addSubview:_passwordTextField];
    //配置右侧显示密码按钮
    UIButton * passwordRightView = [UIButton new];
    passwordRightView.viewSize = CGSizeMake(40, _passwordTextField.viewHeight);
    [passwordRightView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
    _showPasswordButton = [UIButton new];
    _showPasswordButton.viewSize = CGSizeMake(16, 12);
    [_showPasswordButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(passwordRightView.viewRightEdge - 15, (passwordRightView.viewHeight - _showPasswordButton.viewHeight) / 2)];
    [_showPasswordButton setBackgroundImage:[UIImage imageNamed:@"icon_xianshimima_nor"] forState:UIControlStateNormal];
    [_showPasswordButton setBackgroundImage:[UIImage imageNamed:@"icon_xianshimima_cli"] forState:UIControlStateSelected];
    [_showPasswordButton addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
    [passwordRightView addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
    [passwordRightView addSubview:_showPasswordButton];
    _passwordTextField.rightView = passwordRightView;
    
    //分割线
    UIView * lineView2 = [UIView new];
    lineView2.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
    [lineView2 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _passwordTextField.viewBottomEdge)];
    lineView2.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self.view addSubview:lineView2];
    
    _finishButton = [UIButton new];
    _finishButton.viewSize = CGSizeMake(SCREEN_WIDTH - 30, 45);
    [_finishButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, lineView2.viewBottomEdge + 20)];
    [_finishButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xcccccc] andSize:_finishButton.viewSize] forState:UIControlStateNormal];
    [_finishButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xfd5478] andSize:_finishButton.viewSize] forState:UIControlStateSelected];
    [_finishButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    _finishButton.userInteractionEnabled = NO;
    [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [_finishButton addTarget:self action:@selector(finishButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_finishButton];
}

#pragma mark - 网络请求
/**
 *  找回密码
 */
- (void)findButtonRequest {
    [self.view endEditing:YES];
    //验证密码格式
    if (![TYTools validatePassword:_passwordTextField.text]) {
        SHOW_MSG(@"密码格式不正确");
        return;
    }
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"FindPassword" parameters:@{@"mobile":_mobileTextField.text, @"code":_codeTextField.text, @"password":_passwordTextField.text} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result == RequestResultSuccess) {
            SHOW_MSG(@"找回成功");
            [JCUserContext sharedManager].otherTimer = nil;
            [JCUserContext sharedManager].otherPhone = nil;
            [JCUserContext sharedManager].otherCount = 0;
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (result == RequestResultEmptyData) {
            NSLog(@"%@", object);
            [self timerOver];
        }
        else if (result == RequestResultFailed){
            NSLog(@"%@", object);
            [self timerOver];
        }
        else if ([object[@"code"] integerValue] == 906) {
            SHOW_MSG(@"手机号码格式错误");
            [self timerOver];
        }
        else if ([object[@"code"] integerValue] == 908) {
            SHOW_MSG(@"验证码错误或过期");
            [self timerOver];
        }
        else if ([object[@"code"] integerValue] == 912) {
            SHOW_MSG(object[@"message"]);
            [self timerOver];
        }
        else if ([object[@"code"] integerValue] == 903) {
            SHOW_MSG(object[@"message"]);
            [self timerOver];
        }
    }];
}
/**
 *  获取验证码
 */
- (void)getCodeRequestWithInterfaceID:(NSString *)InterfaceID parameters:(NSDictionary *)parameters {
    [self.view endEditing:YES];
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:InterfaceID parameters:parameters callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result == RequestResultSuccess) {
            [self timeFire];
            SHOW_MSG(@"验证码已发送至您的手机");
        }else if (result == RequestResultEmptyData) {
            [self timerOver];
        }else if (result == RequestResultException) {
            [self timerOver];
        }else {
            NSString * message = @"获取验证码失败，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            SHOW_EEROR_MSG(message);
            [self timerOver];
        }
    }];
}
/**
 *  修改交易密码
 */
- (void)updateWithdrawPasswordRequest {
    [self.view endEditing:YES];
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"ChangePayPass" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"verify":_codeTextField.text, @"newpass":_passwordTextField.text} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result == RequestResultSuccess) {
            SHOW_MSG(@"修改成功");
            [JCUserContext sharedManager].payPasswordTimer = nil;
            [JCUserContext sharedManager].payPasswordCount = 0;
            //只需要判断payPassword有木有值，所以，随便写入一个值就好
            [[JCUserContext sharedManager] upDateObject:@"123123" forKey:@"pay_password"];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.isPayVC) {
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changePayPassword" object:nil];
            }
            
            // 新增 设置成功后，返回支付界面选中账户资金
            if ([self.delegate respondsToSelector:@selector(setPayPasswordSuccess)]) {
                [self.delegate setPayPasswordSuccess];
            }
            
        }
        else {
            SHOW_MSG(@"修改失败");
            [self timerOver];
        }
    }];
}
#pragma mark -- 点击事件
/**
 *  获取验证码
 */
- (void)getCodeButton:(UIButton *)sender {
    [self.view endEditing:YES];
    [JCUserContext sharedManager].otherPhone = _mobileTextField.text;
    if (self.isPayPassword) {
        [JCUserContext sharedManager].payPasswordTimer = _timer;
        [self getCodeRequestWithInterfaceID:@"PayPassMes" parameters:@{@"phone":[JCUserContext sharedManager].currentUserInfo.memberName, @"userId":[JCUserContext sharedManager].currentUserInfo.memberID}];
    }
    else {
        [JCUserContext sharedManager].otherTimer = _timer;
        [self getCodeRequestWithInterfaceID:@"FindPassVerifyCode" parameters:@{@"mobile":_mobileTextField.text}];
    }
}

- (void)timeFire
{
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
 *  完成
 */
- (void)finishButton:(UIButton *)sender {
    if (self.isPayPassword) {
        [self updateWithdrawPasswordRequest];
    }
    else {
        [self findButtonRequest];
    }
}
/**
 *  返回
 */
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.isPayVC) {
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changePayPassword" object:nil];
    }
}
/**
 *   找回或验证失败销毁timer
 */
- (void)timerOver {
    [JCUserContext sharedManager].otherPhone = nil;
    [JCUserContext sharedManager].otherCount = 0;
    [JCUserContext sharedManager].otherTimer = nil;
    [JCUserContext sharedManager].payPasswordTimer = nil;
    [JCUserContext sharedManager].otherCount = 0;
    _count = 0;
    _getCodeButton.selected = YES;
    _getCodeButton.userInteractionEnabled = YES;
    [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_timer invalidate];
    _timer = nil;
}

#pragma mark -- UITextFieldDelegate 
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //手机号
    if (textField == _mobileTextField) {
        if ((textField.text.length == 10&&![string isEqualToString:@""]) || string.length == 11) {
            if (self.isPayPassword) {
                if (_passwordTextField.text.length > 5 && _passwordTextField.text.length < 7 &&_codeTextField.text.length > 0) {
                    _finishButton.selected = YES;
                    _finishButton.userInteractionEnabled = YES;
                }
            }
            else {
                if ([JCUserContext sharedManager].otherPhone && [[JCUserContext sharedManager].otherPhone isEqualToString:[NSString stringWithFormat:@"%@%@", textField.text, string]]) {
                    NSLog(@"一样的号码");
                }
                else {
                    [JCUserContext sharedManager].otherPhone = textField.text;
                    [self timerOver];
                }
                if (_passwordTextField.text.length > 5 && _passwordTextField.text.length < 13 &&_codeTextField.text.length > 0) {
                    _finishButton.selected = YES;
                    _finishButton.userInteractionEnabled = YES;
                }
            }
            
        }
        else if (textField.text.length >10)
        {
            if([string isEqualToString:@""])
            {
                _finishButton.selected = NO;
                _finishButton.userInteractionEnabled = YES;
                return YES;
            }
            _finishButton.userInteractionEnabled = _finishButton.selected;
            return NO;
        }
    }
    //密码
    if (textField == _passwordTextField) {
        if (self.isPayPassword) {
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
        else {
            if (textField.text.length > 11) {
                if ([string isEqualToString:@""]) {
                    _finishButton.userInteractionEnabled = _finishButton.selected;
                    return YES;
                }
                _finishButton.userInteractionEnabled = _finishButton.selected;
                return NO;
            }
            else if ((textField.text.length-6==0||textField.text.length-5==0)&&[string isEqualToString:@""]){
                _finishButton.selected = NO;
            }
            else if (textField.text.length > 4)
            {
                if (_mobileTextField.text.length == 11&&_codeTextField.text.length > 0) {
                    _finishButton.selected = YES;
                    _finishButton.userInteractionEnabled = YES;
                }
            }
            else
            {
                _finishButton.selected = NO;
            }
        }
        
    }
    //验证码
    if (textField == _codeTextField) {
        if (textField.text.length > 5&&![string isEqualToString:@""]) {
            _finishButton.userInteractionEnabled = _finishButton.selected;
            return NO;
        }
        if (textField.text.length>4&&![string isEqualToString:@""]) {
            if (self.isPayPassword) {
                if (_passwordTextField.text.length > 5 && _passwordTextField.text.length < 7) {
                    _finishButton.selected = YES;
                }
            }
            else {
                if (_mobileTextField.text.length == 11 && _passwordTextField.text.length > 5 && _passwordTextField.text.length < 13) {
                    _finishButton.selected = YES;
                }
            }
            
        }else
        {
            _finishButton.selected = NO;
        }
    }
    _finishButton.userInteractionEnabled = _finishButton.selected;
    return YES;
}

#pragma mark - - 其他
/**
 *  倒计时
 */
- (void)reduce:(NSTimer *)time
{
    if (self.isPayPassword) {
        [JCUserContext sharedManager].payPasswordCount = _count;
    }
    else {
        [JCUserContext sharedManager].otherCount = _count;
    }
    _count--;
    if (_count == 0) {
        [self timerOver];
        return;
    }
    [_getCodeButton setTitle:[NSString stringWithFormat:@"%ld秒",(long)_count] forState:UIControlStateNormal];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
