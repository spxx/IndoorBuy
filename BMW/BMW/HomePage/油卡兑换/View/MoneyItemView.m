//
//  MoneyItemView.m
//  BMW
//
//  Created by LiuP on 2016/12/17.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "MoneyItemView.h"

static NSString * fontName = @"Britannic Bold";

@interface MoneyItemView ()
@property (nonatomic, strong) UILabel * cash;      /**< 充值金额 */
@property (nonatomic, strong) UILabel * MCash;     /**< M币 */

@end

@implementation MoneyItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5;
        self.layer.borderColor = COLOR_NAVIGATIONBAR_BARTINT.CGColor;
        self.layer.borderWidth = 1;
                
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface
{
    _cash = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 0)];
    _cash.font = [UIFont fontWithName:fontName size:18 * W_ABCW];
    _cash.textColor = [UIColor whiteColor];
    _cash.text = @" ";
    _cash.textAlignment = NSTextAlignmentCenter;
    [_cash sizeToFit];
    _cash.viewSize = CGSizeMake(self.viewWidth, _cash.viewHeight);
    [self addSubview:_cash];
    
    _MCash = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 0)];
    _MCash.font = [UIFont systemFontOfSize:11 * W_ABCW];
    _MCash.textColor = [UIColor whiteColor];
    _MCash.text = @" ";
    _MCash.textAlignment = NSTextAlignmentCenter;
    [_MCash sizeToFit];
    _MCash.viewSize = CGSizeMake(self.viewWidth, _MCash.viewHeight);
    [self addSubview:_MCash];
    
    CGFloat origin_y = (self.viewHeight - _cash.viewHeight  - _MCash.viewHeight - 4 * W_ABCW) / 2;
    _cash.center = CGPointMake(_cash.center.x, origin_y + _cash.viewHeight / 2);
    _MCash.center = CGPointMake(_MCash.center.x, _cash.viewBottomEdge + 4 * W_ABCW + _MCash.viewHeight / 2);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapItemAction:)];
    [self addGestureRecognizer:tap];
}

#pragma mark -- setter
- (void)setModel:(OilCardModel *)model
{
    _model = model;
    NSString * cashStr =  [@"￥" stringByAppendingString:model.cash];
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] initWithString:cashStr];
    [attribute addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:fontName size:18 * W_ABCW]
                      range:NSMakeRange(0, cashStr.length)];
    _cash.attributedText = attribute;
    _MCash.text = model.mCash;
    
    [self changeStatus];
}
#pragma mark -- actions
- (void)tapItemAction:(UITapGestureRecognizer *)tap
{
    if (_model.isSelected) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(moneyItemView:didSelectedItemWitModel:)]) {
        [self.delegate moneyItemView:self didSelectedItemWitModel:self.model];
    }
}

#pragma mark -- other

- (void)changeStatus
{
    if (_model.isSelected) {
        self.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
        _cash.textColor = [UIColor whiteColor];
        _MCash.textColor = [UIColor whiteColor];
    }else {
        self.backgroundColor = [UIColor whiteColor];
        _cash.textColor = COLOR_NAVIGATIONBAR_BARTINT;
        _MCash.textColor = COLOR_NAVIGATIONBAR_BARTINT;
    }
}

@end
