//
//  RegisView.h
//  BMW
//
//  Created by rr on 2016/11/28.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisDeleGate <NSObject>

/**
 注册按钮点击
 */
-(void)clickRegisRequest;

/**
 获取验证码
 */
-(void)getCodeRequest;

/**
 查看协议
 */
-(void)protocolButton;

@end



@interface RegisView : UIView

@property(nonatomic, strong)UITextField * mobileTextField;
@property(nonatomic, strong)UITextField * passwordTextField;
@property(nonatomic, strong)UITextField * codeTextField;
@property(nonatomic, strong)UITextField * drpcodeTextField;

@property(nonatomic, strong)UIButton *showPasswordButton;
@property(nonatomic, strong)UIButton *getCodeButton;
@property(nonatomic, strong)UIButton *rigistButton;
@property(nonatomic, strong)UIButton *agreeProtocolButton;

@property(nonatomic, assign)NSInteger count;
@property(nonatomic, strong)NSTimer * timer;
@property(nonatomic, assign)BOOL isPrsent;

@property(nonatomic, assign)id <RegisDeleGate> delegate;

-(instancetype)initWithFrame:(CGRect)frame withPresent:(BOOL)ispresent;

-(void)timerOver;

@end
