//
//  UpdatePasswordViewController.m
//  BMW
//
//  Created by 白琴 on 16/3/15.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "UpdatePasswordViewController.h"
#import "LoginViewController.h"

@interface UpdatePasswordViewController () <UITextFieldDelegate>{
    UITextField * _oldTextField;
    UITextField * _newTextField;
    UIButton * _saveButton;
}

@property (nonatomic, strong)UIView * textFieldView;

@end

@implementation UpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改登录密码";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self navigation];
    [self initUserInterface];
}

#pragma mark -- 界面
/**
 *  基本界面
 */
- (void)initUserInterface {
    [self.view addSubview:self.textFieldView];
    
    //保存按钮
    _saveButton = [UIButton new];
    _saveButton.viewSize = CGSizeMake(SCREEN_WIDTH - 30, 45);
    [_saveButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, _textFieldView.viewBottomEdge + 20)];
    [_saveButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xcccccc] andSize:_saveButton.viewSize] forState:UIControlStateNormal];
    [_saveButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xfd5478] andSize:_saveButton.viewSize] forState:UIControlStateSelected];
    [_saveButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [_saveButton addTarget:self action:@selector(processPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.userInteractionEnabled = NO;
    [self.view addSubview:_saveButton];
}

- (UIView *)textFieldView {
    if (!_textFieldView) {
        _textFieldView = [UIView new];
        _textFieldView.viewSize = CGSizeMake(SCREEN_WIDTH, 90);
        [_textFieldView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 10)];
        _textFieldView.backgroundColor = COLOR_BACKGRONDCOLOR;
        
        //密码输入框
        _oldTextField = [UITextField new];
        _oldTextField.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_oldTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        _oldTextField.backgroundColor = [UIColor whiteColor];
        _oldTextField.placeholder = @"请输入旧密码";
        _oldTextField.font = fontForSize(13);
        _oldTextField.textColor = [UIColor colorWithHex:0x181818];
        _oldTextField.secureTextEntry = YES;
        _oldTextField.delegate = self;
        _oldTextField.leftViewMode = UITextFieldViewModeAlways;
        _oldTextField.rightViewMode = UITextFieldViewModeAlways;
        UIView * passwordLeftView = [UIView new];
        passwordLeftView.viewSize = CGSizeMake(42, _oldTextField.viewHeight);
        [passwordLeftView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
        UIImageView * passwordImageView = [UIImageView new];
        passwordImageView.viewSize = CGSizeMake(14, 18);
        [passwordImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, (passwordLeftView.viewHeight - passwordImageView.viewHeight) / 2)];
        [passwordImageView setImage:[UIImage imageNamed:@"icon_mima_dl"]];
        [passwordLeftView addSubview:passwordImageView];
        _oldTextField.leftView = passwordLeftView;
        [_textFieldView addSubview:_oldTextField];
        //配置右侧显示密码按钮
        UIView * passwordRightView = [UIView new];
        passwordRightView.viewSize = CGSizeMake(40, _oldTextField.viewHeight);
        [passwordRightView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        UIButton * showPasswordButton = [UIButton new];
        showPasswordButton.viewSize = CGSizeMake(16, 12);
        [showPasswordButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(passwordRightView.viewRightEdge - 15, (passwordRightView.viewHeight - showPasswordButton.viewHeight) / 2)];
        [showPasswordButton setBackgroundImage:[UIImage imageNamed:@"icon_xianshimima_nor"] forState:UIControlStateNormal];
        [showPasswordButton setBackgroundImage:[UIImage imageNamed:@"icon_xianshimima_cli"] forState:UIControlStateSelected];
        [showPasswordButton addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
         showPasswordButton.tag = 16000;
        [passwordRightView addSubview:showPasswordButton];
        _oldTextField.rightView = passwordRightView;
        
        
        //密码输入框
        _newTextField = [UITextField new];
        _newTextField.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_newTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _oldTextField.viewBottomEdge)];
        _newTextField.backgroundColor = [UIColor whiteColor];
        _newTextField.placeholder = @"请输入新密码";
        _newTextField.font = fontForSize(13);
        _newTextField.textColor = [UIColor colorWithHex:0x181818];
        _newTextField.secureTextEntry = YES;
        _newTextField.delegate = self;
        _newTextField.leftViewMode = UITextFieldViewModeAlways;
        _newTextField.rightViewMode = UITextFieldViewModeAlways;
        UIView * newPasswordLeftView = [UIView new];
        newPasswordLeftView.viewSize = CGSizeMake(42, _newTextField.viewHeight);
        [newPasswordLeftView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
        UIImageView * newPasswordImageView = [UIImageView new];
        newPasswordImageView.viewSize = CGSizeMake(14, 18);
        [newPasswordImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, (newPasswordLeftView.viewHeight - newPasswordImageView.viewHeight) / 2)];
        [newPasswordImageView setImage:[UIImage imageNamed:@"icon_mima_dl"]];
        [newPasswordLeftView addSubview:newPasswordImageView];
        _newTextField.leftView = newPasswordLeftView;
        [_textFieldView addSubview:_newTextField];
        //配置右侧显示密码按钮
        UIView * newPasswordRightView = [UIView new];
        newPasswordRightView.viewSize = CGSizeMake(40, _newTextField.viewHeight);
        [newPasswordRightView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        UIButton * newShowPasswordButton = [UIButton new];
        newShowPasswordButton.viewSize = CGSizeMake(16, 12);
        [newShowPasswordButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(newPasswordRightView.viewRightEdge - 15, (newPasswordRightView.viewHeight - newShowPasswordButton.viewHeight) / 2)];
        [newShowPasswordButton setBackgroundImage:[UIImage imageNamed:@"icon_xianshimima_nor"] forState:UIControlStateNormal];
        [newShowPasswordButton setBackgroundImage:[UIImage imageNamed:@"icon_xianshimima_cli"] forState:UIControlStateSelected];
        [newShowPasswordButton addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
        newShowPasswordButton.tag = 16001;
        [newPasswordRightView addSubview:newShowPasswordButton];
        _newTextField.rightView = newPasswordRightView;
        
        for (int i = 0; i < 2; i ++) {
            //分割线
            UIView * lineView1 = [UIView new];
            lineView1.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
            [lineView1 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 45 + i * 45)];
            lineView1.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
            [_textFieldView addSubview:lineView1];
        }
        
        

    }
    return _textFieldView;
}

#pragma mark --  UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //旧密码
    if (textField == _oldTextField) {
        if (textField.text.length > 11) {
            if ([string isEqualToString:@""]) {
                _saveButton.userInteractionEnabled = _saveButton.selected;
                return YES;
            }
            _saveButton.userInteractionEnabled = _saveButton.selected;
            return NO;
        }
        else if ((textField.text.length-6==0||textField.text.length-5==0)&&[string isEqualToString:@""]){
            _saveButton.selected = NO;
        }
        else if (textField.text.length > 4)
        {
            if (_newTextField.text.length > 5 && _newTextField.text.length < 13) {
                _saveButton.selected = YES;
                _saveButton.userInteractionEnabled = YES;
            }
        }
        else
        {
            _saveButton.selected = NO;
        }
    }
    //新密码
    if (textField == _newTextField) {
        if (textField.text.length > 11) {
            if ([string isEqualToString:@""]) {
                _saveButton.userInteractionEnabled = _saveButton.selected;
                return YES;
            }
            _saveButton.userInteractionEnabled = _saveButton.selected;
            return NO;
        }
        else if ((textField.text.length-6==0||textField.text.length-5==0)&&[string isEqualToString:@""]){
            _saveButton.selected = NO;
        }
        else if (textField.text.length > 4)
        {
            if (_oldTextField.text.length > 5 && _oldTextField.text.length < 13) {
                _saveButton.selected = YES;
                _saveButton.userInteractionEnabled = YES;
            }
        }
        else
        {
            _saveButton.selected = NO;
        }
    }

    return YES;
}

#pragma mark -- 点击事件
/**
 *  显示密码
 */
- (void)showPassword:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        if (sender.tag == 16000) {
            _oldTextField.secureTextEntry = NO;
        }
        else if (sender.tag == 16001) {
            _newTextField.secureTextEntry = NO;
        }
    }
    else {
        if (sender.tag == 16000) {
            _oldTextField.secureTextEntry = YES;
        }
        else if (sender.tag == 16001) {
            _newTextField.secureTextEntry = YES;
        }
    }
}
/**
 *  登录密码修改
 */
- (void)processPasswordButton:(UIButton *)sender {
    NSLog(@"登录密码修改");
    [self updateLoginPasswordRequest];
}
/**
 *  返回
 */
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 网络请求
/**
 *  修改登录密码
 */
- (void)updateLoginPasswordRequest {
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"changePasswd" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"passwd":_oldTextField.text, @"newpass":_newTextField.text} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result == RequestResultSuccess) {
            SHOW_MSG(@"修改成功");
            [self loginOutNetWork];
        }
        else if ([object[@"code"] integerValue] == 904) {
            SHOW_MSG(@"密码错误");
        }
        else {
            SHOW_MSG(@"修改失败");
        }
        
    }];
}

-(void)loginOutNetWork
{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"Logout" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSLog(@"注销成功");
            [[JCUserContext sharedManager] removeCurrentUser];
            [[JCUserContext sharedManager] clearSavedUserInfo];
            LoginViewController * loginVC = [[LoginViewController alloc] init];
            loginVC.isRegistPush = YES;
            [self.navigationController pushViewController:loginVC animated:YES];
        }
        else{
            NSLog(@"注销失败");
            
        }
        
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
