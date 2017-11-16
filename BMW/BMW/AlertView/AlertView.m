//
//  AlertView.m
//  BMW
//
//  Created by LiuP on 2016/12/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "AlertView.h"


@interface AlertView ()

@property (nonatomic, assign) AlertType alertType;

@property (nonatomic, strong) UIView * contentView;
@end

@implementation AlertView

- (instancetype)initWithTarget:(id<AlertViewDelegate>)target AlertType:(AlertType)alertType
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.delegate = target;
        self.alertType = alertType;
        [self initUserInterfaceWithAlertType:alertType];
    }
    return self;
}

- (void)initUserInterfaceWithAlertType:(AlertType)alertType
{
    // 透明背景
    UIView * backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    backgroundView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.4];
    [self addSubview:backgroundView];
    
    CGFloat width = 250 * W_ABCW;
    CGFloat height = 145 * W_ABCW;
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _contentView.center = self.center;
    _contentView.clipsToBounds = YES;
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 7;
    [self addSubview:_contentView];
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.viewSize = CGSizeMake(30, 30);
    closeBtn.center = CGPointMake(_contentView.viewWidth - closeBtn.viewWidth / 2, closeBtn.viewHeight / 2);
    [closeBtn setImage:[UIImage imageNamed:@"icon_quxiao_lqzx.png"] forState:UIControlStateNormal]; // 23 * 23 的图片
    [closeBtn addTarget:self action:@selector(closeAlertAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:closeBtn];
    
    UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(0, 99 * W_ABCW, _contentView.viewWidth, 1)];
    separator.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
    [_contentView addSubview:separator];
    
    if (alertType == AlertGetCouponSuccess) {
        UIImageView * remindImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 17 * W_ABCW, 17 * W_ABCW)];
        remindImage.image = [UIImage imageNamed:@"icon_tishi_lqzx.png"]; // 17 * 17的图片
        [_contentView addSubview:remindImage];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
        label.textColor = COLOR_NAVIGATIONBAR_BARTINT;
        label.font = fontBoldForSize(15 * W_ABCW);
        label.text = @"领取成功！";
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        [_contentView addSubview:label];
        
        UILabel * message = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _contentView.viewWidth, 0)];
        message.font = fontForSize(11 * W_ABCW);
        message.textColor = [UIColor colorWithHex:0x666666];
        message.textAlignment = NSTextAlignmentCenter;
        message.text = @"优惠券已发送到您的账户";
        [message sizeToFit];
        message.center = CGPointMake(_contentView.viewWidth / 2, separator.viewY - 12 * W_ABCW - message.viewHeight / 2);
        [_contentView addSubview:message];
        
        // 计算位置
        CGFloat totalWidth = remindImage.viewWidth + label.viewWidth + 7 * W_ABCW;
        remindImage.center = CGPointMake((_contentView.viewWidth - totalWidth + remindImage.viewWidth) / 2, separator.viewY / 2);
        label.center = CGPointMake(remindImage.viewRightEdge + 7 * W_ABCW + label.viewWidth / 2, remindImage.center.y);
        
        [self initBottomBtnWithCount:1];
    }else if (alertType == AlertGetCouponLimit ) {
        UIImageView * remindImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 17 * W_ABCW, 17 * W_ABCW)];
        remindImage.image = [UIImage imageNamed:@"icon_tishi_lqzx.png"]; // 17 * 17的图片
        [_contentView addSubview:remindImage];

        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
        label.textColor = [UIColor colorWithHex:0x666666];
        label.font = fontBoldForSize(15 * W_ABCW);
        label.text = @"您领取张数已达上限！";
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        [_contentView addSubview:label];

        // 计算位置
        CGFloat totalWidth = remindImage.viewWidth + label.viewWidth + 7 * W_ABCW;
        remindImage.center = CGPointMake((_contentView.viewWidth - totalWidth + remindImage.viewWidth) / 2, separator.viewY / 2);
        label.center = CGPointMake(remindImage.viewRightEdge + 7 * W_ABCW + label.viewWidth / 2, remindImage.center.y);

        [self initBottomBtnWithCount:1];
    }
}

- (void)initBottomBtnWithCount:(NSInteger)count
{
    if (self.alertType == AlertGetCouponSuccess || self.alertType == AlertGetCouponLimit) {
        CGFloat height = 44 * W_ABCW;
        UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake(0, _contentView.viewHeight - height, _contentView.viewWidth, height);
        sureBtn.titleLabel.font = fontForSize(17);
        [sureBtn setTitleColor:COLOR_NAVIGATIONBAR_BARTINT forState:UIControlStateNormal];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:sureBtn];
    }
}

#pragma mark -- actions
- (void)closeAlertAction:(UIButton *)sender
{
    [self hide:NO];
}

- (void)sureBtnAction:(UIButton *)sender
{
    [self hide:NO];
}

#pragma mark -- other
- (void)show:(BOOL)animation
{
    self.hidden = NO;
    if (animation) {
        
    }else {
        
    }
}

- (void)hide:(BOOL)animation
{
    self.hidden = YES;;
    if (animation) {
        
    }else {
        
    }
}
@end
