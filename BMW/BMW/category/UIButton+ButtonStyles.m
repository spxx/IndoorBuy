//
//  UIButton+ButtonStyles.m
//  AutoGang
//
//  Created by luoxu on 15/2/12.
//  Copyright (c) 2015年 com.qcb008.QiCheApp. All rights reserved.
//

#import "UIButton+ButtonStyles.h"
#import "UIImage+View.h"

@implementation UIButton(ButtonStyles)

- (void)applyLoginButtonStyle
{
    [self setTitle:@"登录" forState:UIControlStateNormal];
    [self roundCorner:self.viewHeight/2];
    self.titleLabel.font = fontBoldForSize(15);
    [self setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0x4c90f9]
 andSize:self.viewSize] forState:UIControlStateNormal];
}

- (void)applyRegisterButtonStyle
{
    [self setTitle:@"注册" forState:UIControlStateNormal];
    [self roundCorner:self.viewHeight/2];
    self.titleLabel.font = fontBoldForSize(15);
    [self setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0x4c90f9] andSize:self.viewSize] forState:UIControlStateNormal];
}

@end
