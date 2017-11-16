//
//  CouponViewCell.m
//  BMW
//
//  Created by LiuP on 2016/12/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "CouponViewCell.h"

@interface CouponViewCell ()

@property (nonatomic, strong) UIImageView * couponImage;  /**< 优惠券图片 */
@property (nonatomic, strong) UIButton * getBtn;           /**< 右侧领取按钮 */
@property (nonatomic, strong) UILabel * noCounpon;         /**< 已领完 */
@end

@implementation CouponViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface
{
    _couponImage = [UIImageView new];
    [self.contentView addSubview:_couponImage];
    
    _noCounpon = [UILabel new];
    _noCounpon.hidden = YES;
    _noCounpon.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.4];
    _noCounpon.viewSize = CGSizeMake(57 * W_ABCW, 57 * W_ABCW);
    _noCounpon.textColor = [UIColor whiteColor];
    _noCounpon.font = fontForSize(15 * W_ABCW);
    _noCounpon.textAlignment = NSTextAlignmentCenter;
    _noCounpon.layer.cornerRadius = _noCounpon.viewWidth / 2;
    _noCounpon.clipsToBounds = YES;
    _noCounpon.text = @"已领完";
    [self.contentView addSubview:_noCounpon];
    
    _getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getBtn addTarget:self action:@selector(getCouponAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_getBtn];
}

#pragma mark -- setter
- (void)setModel:(CouponModel *)model
{
    _model = model;
    [self.couponImage sd_setImageWithURL:[NSURL URLWithString:model.couponImage]];
    if (model.isHave) {
        self.noCounpon.hidden = YES;
        self.getBtn.userInteractionEnabled = YES;
    }else {
        self.noCounpon.hidden = NO;
        self.getBtn.userInteractionEnabled = NO;
    }
}

#pragma mark -- actions
- (void)getCouponAction:(UIButton *)sender
{
    if (self.getCouponBlock) {
        self.getCouponBlock(self.model);
    }
}

#pragma mark -- private
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _couponImage.frame = CGRectMake(7 * W_ABCW, 7 * W_ABCW, self.contentView.viewWidth - 14 * W_ABCW, self.contentView.viewHeight - 7 * W_ABCW);
    _noCounpon.center = CGPointMake(self.contentView.center.x, _couponImage.viewY + 4 * W_ABCW + _noCounpon.viewHeight / 2);
    _getBtn.frame = CGRectMake(0, 0, _couponImage.viewWidth, _couponImage.viewHeight);
}

@end
