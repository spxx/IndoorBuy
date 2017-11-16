//
//  RemapayMentView.m
//  BMW
//
//  Created by rr on 16/3/29.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "RemapayMentView.h"

@interface RemapayMentView ()<UITextFieldDelegate>
{
    UITextField *_onePass;
    UIView * _backgroundView;
}

@property (nonatomic, strong) UIView * contentView;

@end


@implementation RemapayMentView


-(instancetype)initWithFrame:(CGRect)frame Withmoney:(double)payMoney AndOrderM:(float)orderMoney{
    if (self = [super initWithFrame:frame]) {
        _payMoney = payMoney;
        _orderMoney = [[NSString stringWithFormat:@"%.2f", orderMoney] floatValue];
        [self initUserInterface];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self PassWord];
    }
    return self;
}

-(void)PassWord{
    _backgroundView = [UIView new];
    _backgroundView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [_backgroundView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0;
    _backgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tagp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmissSelf)];
    [_backgroundView addGestureRecognizer:tagp];
    [self addSubview:_backgroundView];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-238*W_ABCW)/2, self.viewHeight, 238*W_ABCW, 111*W_ABCW)];
    _contentView.backgroundColor = [UIColor colorWithHex:0xefefef];
    _contentView.userInteractionEnabled = YES;
    [self addSubview:_contentView];
    
    _contentView.layer.borderWidth = 0.5;
    _contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    _contentView.layer.cornerRadius = 6;
    _contentView.layer.masksToBounds = YES;
    
    UIButton *dissButton = [[UIButton alloc] initWithFrame:CGRectMake(13*W_ABCW, 16*W_ABCW, 9, 9)];
    [dissButton setBackgroundImage:IMAGEWITHNAME(@"icon_quxiao_yezf.png") forState:UIControlStateNormal];
    [dissButton addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:dissButton];
    
    UIButton *bigButton = [[UIButton alloc] initWithFrame:CGRectMake(5*W_ABCW, 5*W_ABCW, 30, 30)];
    [bigButton addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:bigButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _contentView.viewWidth, 42*W_ABCW)];
    titleLabel.text = @"请输入交易密码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHex:0x181818];
    titleLabel.font = fontBoldForSize(17);
    [_contentView addSubview:titleLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.viewBottomEdge, _contentView.viewWidth, 0.5*W_ABCW)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [_contentView addSubview:line];
    
    _onePass = [[UITextField alloc] initWithFrame:CGRectMake(300*W_ABCW, line.viewBottomEdge+16*W_ABCW, 35*W_ABCW, 36*W_ABCW)];
    _onePass.textColor = [UIColor colorWithHex:0x181818];
    _onePass.font = fontBoldForSize(20);
    _onePass.delegate = self;
    _onePass.keyboardType = UIKeyboardTypeNumberPad;
    _onePass.secureTextEntry = YES;
    _onePass.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_onePass];
    
    UIView *passView = [[UIView alloc] initWithFrame:CGRectMake(14*W_ABCW, line.viewBottomEdge+16*W_ABCW, _contentView.viewWidth-28*W_ABCW, 36*W_ABCW)];
    passView.layer.borderWidth = 0.5*W_ABCW;
    passView.layer.borderColor = [UIColor colorWithHex:0xb2b2b2].CGColor;
    passView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginPass)];
    [passView addGestureRecognizer:tap];
    [_contentView addSubview:passView];
    
    for (int i = 0; i<6; i++) {
        UIView *shuL = [[UIView alloc] initWithFrame:CGRectMake(35*W_ABCW+i*35.5*W_ABCW, 0, 0.5*W_ABCW, 36*W_ABCW)];
        shuL.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [passView addSubview:shuL];
        if (i==5) {
            shuL.hidden = YES;
        }
        UIImageView *blackImageV = [[UIImageView alloc] initWithFrame:CGRectMake(8.5*W_ABCW+i*35*W_ABCW, 9*W_ABCW, 18*W_ABCW, 18*W_ABCW)];
        blackImageV.backgroundColor = [UIColor blackColor];
        blackImageV.layer.cornerRadius = 9*W_ABCW;
        blackImageV.layer.masksToBounds = YES;
        blackImageV.tag = 555+i;
        blackImageV.hidden = YES;
        [passView addSubview:blackImageV];
    }
    [_onePass becomeFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0.4;
        _contentView.center = CGPointMake(_contentView.center.x, 105*W_ABCH + _contentView.viewHeight / 2);
    }];
}

-(void)initUserInterface{
    
    _backgroundView = [UIView new];
    _backgroundView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [_backgroundView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0;
    _backgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tagp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmissSelf)];
    [_backgroundView addGestureRecognizer:tagp];
    [self addSubview:_backgroundView];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-238*W_ABCW)/2, self.viewHeight, 238*W_ABCW, 191*W_ABCW)];
    _contentView.backgroundColor = [UIColor colorWithHex:0xefefef];
    _contentView.userInteractionEnabled = YES;
    [self addSubview:_contentView];
    
    _contentView.layer.borderWidth = 0.5;
    _contentView.layer.borderColor = [UIColor whiteColor].CGColor;
    _contentView.layer.cornerRadius = 6;
    _contentView.layer.masksToBounds = YES;
    
    UIButton *dissButton = [[UIButton alloc] initWithFrame:CGRectMake(13*W_ABCW, 16*W_ABCW, 9, 9)];
    [dissButton setBackgroundImage:IMAGEWITHNAME(@"icon_quxiao_yezf.png") forState:UIControlStateNormal];
    [dissButton addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:dissButton];
    
    UIButton *bigButton = [[UIButton alloc] initWithFrame:CGRectMake(5*W_ABCW, 5*W_ABCW, 30, 30)];
    [bigButton addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:bigButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _contentView.viewWidth, 42*W_ABCW)];
    titleLabel.text = @"油卡兑换";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHex:0x181818];
    titleLabel.font = fontBoldForSize(17);
    [_contentView addSubview:titleLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.viewBottomEdge, _contentView.viewWidth, 0.5*W_ABCW)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [_contentView addSubview:line];
    
    UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(13*W_ABCW, line.viewBottomEdge, 65, 40*W_ABCW)];
    payLabel.text = @"可用M币:";
    payLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    payLabel.font = fontForSize(14);
    [_contentView addSubview:payLabel];
    
    UILabel *payMoneyL = [UILabel new];
    payMoneyL.viewSize = CGSizeMake(100, 40*W_ABCW);
    payMoneyL.text = [NSString stringWithFormat:@"%.2f元",_payMoney];
    payMoneyL.textAlignment = NSTextAlignmentRight;
    payMoneyL.textColor = [UIColor colorWithHex:0x7f7f7f];
    payMoneyL.font = fontForSize(14);
    [payMoneyL sizeToFit];
    payMoneyL.viewSize = CGSizeMake(payMoneyL.viewWidth, 40*W_ABCW);
    [payMoneyL align:ViewAlignmentTopRight relativeToPoint:CGPointMake(_contentView.viewWidth-14*W_ABCW, line.viewBottomEdge)];
    [_contentView addSubview:payMoneyL];
    
    UIView *lineOne = [[UIView alloc] initWithFrame:CGRectMake(13*W_ABCW, payMoneyL.viewBottomEdge, _contentView.viewWidth-26*W_ABCW, 0.5*W_ABCW)];
    lineOne.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [_contentView addSubview:lineOne];
    
    UILabel *orderL = [[UILabel alloc] initWithFrame:CGRectMake(13*W_ABCW, lineOne.viewBottomEdge, 65, 40*W_ABCW)];
    orderL.text = @"订单金额:";
    orderL.textColor = [UIColor colorWithHex:0x7f7f7f];
    orderL.font = fontForSize(14);
    [_contentView addSubview:orderL];
    
    UILabel *orderMoneyL = [UILabel new];
    orderMoneyL.viewSize = CGSizeMake(100, 40*W_ABCW);
    orderMoneyL.text = [NSString stringWithFormat:@"%.2f元",_orderMoney];
    orderMoneyL.textAlignment = NSTextAlignmentRight;
    orderMoneyL.textColor = [UIColor colorWithHex:0x7f7f7f];
    orderMoneyL.font = fontForSize(14);
    [orderMoneyL sizeToFit];
    orderMoneyL.viewSize = CGSizeMake(orderMoneyL.viewWidth, 40*W_ABCW);
    [orderMoneyL align:ViewAlignmentTopRight relativeToPoint:CGPointMake(_contentView.viewWidth-14*W_ABCW, lineOne.viewBottomEdge)];
    [_contentView addSubview:orderMoneyL];
    
    UIView *lineTwo = [[UIView alloc] initWithFrame:CGRectMake(13*W_ABCW, orderL.viewBottomEdge, _contentView.viewBottomEdge-26*W_ABCW, 0.5*W_ABCW)];
    lineTwo.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [_contentView addSubview:lineTwo];
    
    if (![JCUserContext sharedManager].currentUserInfo.payPassword || ((NSString *)[JCUserContext sharedManager].currentUserInfo.payPassword).length == 0) {
        UIButton *regisPassword = [UIButton new];
        regisPassword.viewSize = CGSizeMake(_contentView.viewWidth-28*W_ABCW, 36*W_ABCW);
        [regisPassword align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(14*W_ABCW, lineTwo.viewBottomEdge+16*W_ABCW)];
        [regisPassword setTitle:@"您还没有交易密码，去设置" forState:UIControlStateNormal];
        [regisPassword setTitleColor:[UIColor colorWithHex:0xfd5478] forState:UIControlStateNormal];
        regisPassword.titleLabel.font = fontForSize(13);
        regisPassword.layer.borderWidth = 0.5*W_ABCW;
        regisPassword.layer.borderColor = [UIColor colorWithHex:0xfd5478].CGColor;
        regisPassword.layer.cornerRadius = 3;
        regisPassword.layer.masksToBounds = YES;
        regisPassword.userInteractionEnabled = YES;
        [regisPassword addTarget:self action:@selector(changeShezhi) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:regisPassword];
        
    }else{
        _onePass = [[UITextField alloc] initWithFrame:CGRectMake(300*W_ABCW, lineTwo.viewBottomEdge+16*W_ABCW, 35*W_ABCW, 36*W_ABCW)];
        _onePass.textColor = [UIColor colorWithHex:0x181818];
        _onePass.font = fontBoldForSize(20);
        _onePass.delegate = self;
        _onePass.keyboardType = UIKeyboardTypeNumberPad;
        _onePass.secureTextEntry = YES;
        _onePass.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:_onePass];
        
        UIView *passView = [[UIView alloc] initWithFrame:CGRectMake(14*W_ABCW, lineTwo.viewBottomEdge+16*W_ABCW, _contentView.viewWidth-28*W_ABCW, 36*W_ABCW)];
        passView.layer.borderWidth = 0.5*W_ABCW;
        passView.layer.borderColor = [UIColor colorWithHex:0xb2b2b2].CGColor;
        passView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginPass)];
        [passView addGestureRecognizer:tap];
        [_contentView addSubview:passView];
        
        for (int i = 0; i<6; i++) {
            UIView *shuL = [[UIView alloc] initWithFrame:CGRectMake(35*W_ABCW+i*35.5*W_ABCW, 0, 0.5*W_ABCW, 36*W_ABCW)];
            shuL.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
            [passView addSubview:shuL];
            if (i==5) {
                shuL.hidden = YES;
            }
            UIImageView *blackImageV = [[UIImageView alloc] initWithFrame:CGRectMake(8.5*W_ABCW+i*35*W_ABCW, 9*W_ABCW, 18*W_ABCW, 18*W_ABCW)];
            blackImageV.backgroundColor = [UIColor blackColor];
            blackImageV.layer.cornerRadius = 9*W_ABCW;
            blackImageV.layer.masksToBounds = YES;
            blackImageV.tag = 555+i;
            blackImageV.hidden = YES;
            [passView addSubview:blackImageV];
        }
    }
    [_onePass becomeFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0.4;
        _contentView.center = CGPointMake(_contentView.center.x, 105*W_ABCH + _contentView.viewHeight / 2);
    }];
    
}

-(void)changeShezhi{
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0;
        _contentView.center = CGPointMake(_contentView.center.x, self.viewHeight + _contentView.viewHeight / 2);
    } completion:^(BOOL finished) {
        
        [_backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
    }];
    self.shezhiPassWord();
}



-(void)beginPass{
    
    if (_orderMoney>_payMoney) {
        SHOW_EEROR_MSG(@"余额不足，请选择其他支付方式");
    }else{
        [_onePass becomeFirstResponder];
    }
    
}

-(void)tapAction{
    [self endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0;
        _contentView.center = CGPointMake(_contentView.center.x, self.viewHeight + _contentView.viewHeight / 2);
    } completion:^(BOOL finished) {
        
        [_backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
    }];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        NSLog(@"回滚%ld",textField.text.length);
        UIImageView *imageV = [self viewWithTag:554+textField.text.length];
        imageV.hidden = YES;
    }else{
        NSLog(@"下一个%ld",textField.text.length);
        UIImageView *imageV = [self viewWithTag:555+textField.text.length];
        imageV.hidden = NO;
        if (textField.text.length==5) {
            NSString *finishString = [NSString stringWithFormat:@"%@%@",_onePass.text,string];
            self.finishPay(finishString);
            [UIView animateWithDuration:0.3 animations:^{
                _backgroundView.alpha = 0;
                _contentView.center = CGPointMake(_contentView.center.x, self.viewHeight + _contentView.viewHeight / 2);
            } completion:^(BOOL finished) {
                [_backgroundView removeFromSuperview];
                [self removeFromSuperview];
            }];
            return NO;
        }
    }
    return YES;
}

-(void)dissmissSelf{
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0;
        _contentView.center = CGPointMake(_contentView.center.x, self.viewHeight + _contentView.viewHeight / 2);
    } completion:^(BOOL finished) {
        
        [_backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
    }];
}

@end


