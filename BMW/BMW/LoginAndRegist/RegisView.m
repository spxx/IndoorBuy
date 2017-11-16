//
//  RegisView.m
//  BMW
//
//  Created by rr on 2016/11/28.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "RegisView.h"

@interface RegisView ()<UITextFieldDelegate>

@property (nonatomic, strong)UIView * whiteView;
@property (nonatomic, strong)UIView * endView;

@end


@implementation RegisView

- (instancetype)initWithFrame:(CGRect)frame withPresent:(BOOL)ispresent
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_BACKGRONDCOLOR;
        _isPrsent = ispresent;
        [self initUserInterface];
    }
    return self;
}

-(void)initUserInterface{
    [self addSubview:self.whiteView];
    [self addSubview:self.endView];
}

- (UIView *)whiteView {
    if (!_whiteView) {
        //白色的背景View
        _whiteView = [UIView new];
        _whiteView.viewSize = CGSizeMake(SCREEN_WIDTH, 100);
        [_whiteView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 10)];
//        if (_isPrsent) {
//            [_whiteView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 10+64)];
//        }
        _whiteView.backgroundColor = [UIColor whiteColor];
        
        //手机号码输入框
        _mobileTextField = [UITextField new];
        _mobileTextField.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_mobileTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        _mobileTextField.placeholder = @"请输入手机号码";
        _mobileTextField.font = fontForSize(13);
        _mobileTextField.delegate = self;
        _mobileTextField.textColor = [UIColor colorWithHex:0x181818];
        _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
        if ([JCUserContext sharedManager].registPhone) {
            _mobileTextField.text = [JCUserContext sharedManager].registPhone;
        }
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
        [_whiteView addSubview:_mobileTextField];
        //分割线
        UIView * lineView = [UIView new];
        lineView.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [lineView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 40)];
        lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_whiteView addSubview:lineView];
        
        
        //验证码输入框
        _codeTextField = [UITextField new];
        _codeTextField.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_codeTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, lineView.viewBottomEdge)];
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.font = fontForSize(13);
        _codeTextField.textColor = [UIColor colorWithHex:0x181818];
        _codeTextField.delegate = self;
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
        [_whiteView addSubview:_codeTextField];
        //配置右侧显示密码按钮
        UIView * codeRightView = [UIView new];
        codeRightView.viewSize = CGSizeMake(119, _codeTextField.viewHeight);
        [codeRightView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        _getCodeButton = [UIButton new];
        _getCodeButton.viewSize = CGSizeMake(84, 31);
        [_getCodeButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(codeRightView.viewRightEdge - 15, (codeRightView.viewHeight - _getCodeButton.viewHeight) / 2)];
        [_getCodeButton setBackgroundImage:[UIImage imageNamed:@"icon_yanzhengkuang_zc"] forState:UIControlStateNormal];
        [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getCodeButton setTitleColor:[UIColor colorWithHex:0x181818] forState:UIControlStateSelected];
        [_getCodeButton addTarget:self action:@selector(getCodeButton:) forControlEvents:UIControlEventTouchUpInside];
        _getCodeButton.userInteractionEnabled = NO;
        [_getCodeButton setTitleColor:[UIColor colorWithHex:0xc8c8ce] forState:UIControlStateNormal];
        _getCodeButton.titleLabel.font = fontForSize(13);
        [codeRightView addSubview:_getCodeButton];
        _codeTextField.rightView = codeRightView;
        
        /**
         *  判断上次的倒计时是否还存在
         */
        if ([JCUserContext sharedManager].registCount != 0) {
            _getCodeButton.selected = YES;
            _getCodeButton.userInteractionEnabled = NO;
            [_getCodeButton setTitle:[NSString stringWithFormat:@"%ld秒",(long)[JCUserContext sharedManager].registCount] forState:UIControlStateNormal];
            _count = [JCUserContext sharedManager].registCount;
            //上一个timer
            [[JCUserContext sharedManager].registTimer invalidate];
            [JCUserContext sharedManager].registTimer = nil;
            //重开一个timer【不然不走倒计时】
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduce:) userInfo:nil repeats:YES];
        }
        
        //分割线
        UIView * lineView1 = [UIView new];
        lineView1.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [lineView1 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _codeTextField.viewBottomEdge)];
        lineView1.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_whiteView addSubview:lineView1];
        
        //密码输入框
        _passwordTextField = [UITextField new];
        _passwordTextField.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_passwordTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, lineView1.viewBottomEdge)];
        _passwordTextField.placeholder = @"密码(6-12位数字或字母组合)";
        _passwordTextField.font = fontForSize(13);
        _passwordTextField.textColor = [UIColor colorWithHex:0x181818];
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.delegate = self;
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
        [_whiteView addSubview:_passwordTextField];
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
        [_whiteView addSubview:lineView2];
        
        //手机号码输入框
        _drpcodeTextField = [UITextField new];
        _drpcodeTextField.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_drpcodeTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, lineView2.viewBottomEdge)];
        _drpcodeTextField.placeholder = @"请输入分销商编号（选填）";
        _drpcodeTextField.font = fontForSize(13);
        _drpcodeTextField.delegate = self;
        _drpcodeTextField.textColor = [UIColor colorWithHex:0x181818];
        _drpcodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        //创建一个左侧视图
        _drpcodeTextField.leftViewMode = UITextFieldViewModeAlways;
        UIView * drpcodeView = [UIView new];
        drpcodeView.viewSize = CGSizeMake(42, _mobileTextField.viewHeight);
        [drpcodeView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        //在左侧视图上面添加一个图片视图
        UIImageView * drpcodeImageView = [UIImageView new];
        drpcodeImageView.viewSize = CGSizeMake(18, 17);
        [drpcodeImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, (drpcodeView.viewHeight - drpcodeImageView.viewHeight) / 2)];
        [drpcodeImageView setImage:[UIImage imageNamed:@"icon_fenxiaoshangbianhao_zc.png"]];
        [drpcodeView addSubview:drpcodeImageView];
        //将左侧视图添加到TextField上
        _drpcodeTextField.leftView = drpcodeView;
//        [_whiteView addSubview:_drpcodeTextField];
        //分割线
        UIView * line3View = [UIView new];
        line3View.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [line3View align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _drpcodeTextField.viewBottomEdge)];
        line3View.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
//        [_whiteView addSubview:line3View];
        
        //重新计算白色背景视图的高度
        _whiteView.viewSize = CGSizeMake(SCREEN_WIDTH, lineView2.viewBottomEdge);
    }
    return _whiteView;
}

- (UIView *)endView {
    if (!_endView) {
        _endView = [UIView new];
        _endView.viewSize = CGSizeMake(SCREEN_WIDTH, 100);
        [_endView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _whiteView.viewBottomEdge + 10)];
        
        _agreeProtocolButton = [UIButton new];
        _agreeProtocolButton.viewSize = CGSizeMake(17, 17);
        [_agreeProtocolButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
        [_agreeProtocolButton setBackgroundImage:[UIImage imageNamed:@"icon_gouxuan_nor_zc"] forState:UIControlStateNormal];
        [_agreeProtocolButton setBackgroundImage:[UIImage imageNamed:@"icon_gouxuan_cli_zc"] forState:UIControlStateSelected];
        [_agreeProtocolButton addTarget:self action:@selector(agreeProtocolButton:) forControlEvents:UIControlEventTouchUpInside];
        [_endView addSubview:_agreeProtocolButton];
        _agreeProtocolButton.selected = YES;
        
        UILabel * alertLabel = [UILabel new];
        alertLabel.viewSize = CGSizeMake(100, 30);
        alertLabel.text = @"已经阅读并同意";
        alertLabel.font = fontForSize(11);
        alertLabel.textColor = [UIColor colorWithHex:0x6f6f6f];
        [alertLabel sizeToFit];
        [alertLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_agreeProtocolButton.viewRightEdge + 8, 3)];
        [_endView addSubview:alertLabel];
        //《帮麦网用户协议》按钮
        UIButton * protocolButton = [UIButton new];
        protocolButton.viewSize = CGSizeMake(140, 11);
        [protocolButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(alertLabel.viewRightEdge, 3)];
        protocolButton.titleLabel.font = fontForSize(11);
        [protocolButton setTitleColor:[UIColor colorWithHex:0xfd5478] forState:UIControlStateNormal];
        [protocolButton setTitle:@"《帮麦网用户协议》" forState:UIControlStateNormal];
        [protocolButton addTarget:self action:@selector(protocolButton) forControlEvents:UIControlEventTouchUpInside];
        [protocolButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_endView addSubview:protocolButton];
        
        
        //注册按钮
        _rigistButton = [UIButton new];
        _rigistButton.viewSize = CGSizeMake(SCREEN_WIDTH - 30, 45);
        [_rigistButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, alertLabel.viewBottomEdge + 20)];
        [_rigistButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xcccccc] andSize:_rigistButton.viewSize] forState:UIControlStateNormal];
        [_rigistButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xfd5478] andSize:_rigistButton.viewSize] forState:UIControlStateSelected];
        [_rigistButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
        [_rigistButton setTitle:@"注册" forState:UIControlStateNormal];
        _rigistButton.userInteractionEnabled = NO;
        [_rigistButton addTarget:self action:@selector(clickedRegistButton) forControlEvents:UIControlEventTouchUpInside];
        
        [_endView addSubview:_rigistButton];
        
        _endView.viewSize = CGSizeMake(SCREEN_WIDTH, _rigistButton.viewBottomEdge);
    }
    return _endView;
}

/**
 注册按钮点击
 */
-(void)clickedRegistButton{
    if ([self.delegate respondsToSelector:@selector(clickRegisRequest)]) {
        [self endEditing:YES];
        [self.delegate clickRegisRequest];
    }
}


/**
 获取验证码

 @param sender 倒计时
 */
-(void)getCodeButton:(UIButton *)sender{
    [JCUserContext sharedManager].registPhone = _mobileTextField.text;
    _getCodeButton.userInteractionEnabled = NO;
    _count = 60;
    _getCodeButton.selected = YES;
    [_getCodeButton setTitle:[NSString stringWithFormat:@"%ld秒",(long)_count] forState:UIControlStateNormal];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduce:) userInfo:nil repeats:YES];
    [_timer fire];
    [JCUserContext sharedManager].registTimer = _timer;
    if ([self.delegate respondsToSelector:@selector(getCodeRequest)]) {
        [self endEditing:YES];
        [self.delegate getCodeRequest];
    }
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //手机号
    if (textField == _mobileTextField) {
        if ((textField.text.length == 10&&![string isEqualToString:@""])) {
            if ([JCUserContext sharedManager].registPhone && [[JCUserContext sharedManager].registPhone isEqualToString:[NSString stringWithFormat:@"%@%@", textField.text, string]]) {
                NSLog(@"一样的号码");
            }
            else {
                [JCUserContext sharedManager].registPhone = textField.text;
                [self timerOver];
            }
            if (_passwordTextField.text.length > 5 && _passwordTextField.text.length < 13 &&_codeTextField.text.length > 0 && _agreeProtocolButton.selected == YES) {
                _rigistButton.selected = YES;
                _rigistButton.userInteractionEnabled = YES;
            }
        }
        else if (textField.text.length >10)
        {
            if([string isEqualToString:@""])
            {
                _rigistButton.selected = NO;
                _rigistButton.userInteractionEnabled = YES;
                return YES;
            }
            _rigistButton.userInteractionEnabled = _rigistButton.selected;
            return NO;
        }
    }
    //密码
    if (textField == _passwordTextField) {
        if (textField.text.length > 11) {
            if ([string isEqualToString:@""]) {
                _rigistButton.userInteractionEnabled = _rigistButton.selected;
                return YES;
            }
            _rigistButton.userInteractionEnabled = _rigistButton.selected;
            return NO;
        }
        else if ((textField.text.length-6==0||textField.text.length-5==0)&&[string isEqualToString:@""]){
            _rigistButton.selected = NO;
        }
        else if (textField.text.length > 4)
        {
            if (_mobileTextField.text.length == 11&&_codeTextField.text.length > 0 && _agreeProtocolButton.selected == YES) {
                _rigistButton.selected = YES;
                _rigistButton.userInteractionEnabled = YES;
            }
        }
        else
        {
            _rigistButton.selected = NO;
        }
    }
    //验证码
    if (textField == _codeTextField) {
        if (textField.text.length > 5&&![string isEqualToString:@""]) {
            _rigistButton.userInteractionEnabled = _rigistButton.selected;
            return NO;
        }
        if (textField.text.length>4&&![string isEqualToString:@""]) {
            if (_mobileTextField.text.length == 11 && _passwordTextField.text.length > 5 && _passwordTextField.text.length < 13 && _agreeProtocolButton.selected == YES) {
                _rigistButton.selected = YES;
            }
        }else
        {
            _rigistButton.selected = NO;
        }
    }
    _rigistButton.userInteractionEnabled = _rigistButton.selected;
    return YES;
}

#pragma mark - - 点击事件
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
 *  同意协议
 */
- (void)agreeProtocolButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected && _mobileTextField.text.length == 11 && _codeTextField.text.length == 6 && _passwordTextField.text.length > 5 && _passwordTextField.text.length < 21) {
        _rigistButton.selected = YES;
        _rigistButton.userInteractionEnabled = YES;
    }
    else {
        _rigistButton.selected = NO;
        _rigistButton.userInteractionEnabled = NO;
    }
}


/**
 查看协议
 */
-(void)protocolButton{
    if ([self.delegate respondsToSelector:@selector(protocolButton)]) {
        [self.delegate protocolButton];
    }
}

#pragma mark - - 其他
/**
 *  倒计时
 *
 *  @param time <#time description#>
 */
- (void)reduce:(NSTimer *)time
{
    [JCUserContext sharedManager].registCount = _count;
    _count--;
    if (_count == 0) {
        [self timerOver];
        return;
    }
    
    [_getCodeButton setTitle:[NSString stringWithFormat:@"%ld秒",(long)_count] forState:UIControlStateNormal];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}
/**
 *   注册或验证失败销毁timer
 */
- (void)timerOver {
    [JCUserContext sharedManager].registTimer = nil;
    [JCUserContext sharedManager].registPhone = nil;
    [JCUserContext sharedManager].registCount = 0;
    _count = 0;
    _getCodeButton.selected = YES;
    _getCodeButton.userInteractionEnabled = YES;
    [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_timer invalidate];
    _timer = nil;
}


@end
