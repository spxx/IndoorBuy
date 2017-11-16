//
//  UITextField+UserLoginStyle.m
//  AutoGang
//
//  Created by luoxu on 15/2/12.
//  Copyright (c) 2015年 com.qcb008.QiCheApp. All rights reserved.
//

#import "UITextField+UserLoginStyle.h"

@implementation UITextField(UserLoginStyle)

- (void)applyMobilePhoneTextFiledStyle
{
    UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"86"]];
    [leftView setContentMode:UIViewContentModeCenter];
    [leftView sizeToFit];
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.placeholder = @"请输入11位手机号码";
    self.keyboardType = UIKeyboardTypePhonePad;
    self.backgroundColor = [UIColor whiteColor];
    [self roundCorner:self.viewHeight/2];
}

- (void)applyPasswordTextFiledStyle
{
    UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pwd_icon"]];
    [leftView setContentMode:UIViewContentModeCenter];
    [leftView sizeToFit];
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
    [self setSecureTextEntry:YES];
    self.placeholder = @"请输入密码";
    self.backgroundColor = [UIColor whiteColor];
    [self roundCorner:self.viewHeight/2];
}

- (void)applyPasswordRegisterTextFiledStyle
{
    UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"suo"]];
    [leftView setContentMode:UIViewContentModeCenter];
    [leftView sizeToFit];
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
    [self setSecureTextEntry:YES];
    self.placeholder = @"密码由6-20位字母组成";
    self.backgroundColor = [UIColor whiteColor];
    [self roundCorner:self.viewHeight/2];
}

- (void)applyMobileCodeTextFiledStyle
{
    UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pwd_icon"]];
    [leftView setContentMode:UIViewContentModeCenter];
    [leftView sizeToFit];
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.placeholder = @"请输入验证码";
    self.backgroundColor = [UIColor whiteColor];
    [self roundCorner:self.viewHeight/2];
}
@end
