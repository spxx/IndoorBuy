//
//  ClassHeaderView.m
//  BMW
//
//  Created by LiuP on 2016/12/6.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ClassHeaderView.h"

@interface ClassHeaderView ()

@property (nonatomic, strong) UIImageView * bannerImage;
@property (nonatomic, strong) UIView * sectionHeader;
@property (nonatomic, strong) UILabel * gcName;

@property (nonatomic, strong) UIView * rightView;
@property (nonatomic, strong) UILabel * all;
@property (nonatomic, strong) UIImageView * arrow;
@end

@implementation ClassHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface
{
    _bannerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 0)];
    _bannerImage.userInteractionEnabled = YES;
    _bannerImage.layer.borderWidth = 0.5;
    _bannerImage.layer.borderColor = [UIColor colorWithHex:0xdfdfdf].CGColor;
    [self addSubview:_bannerImage];
    
    _sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, _bannerImage.viewBottomEdge, self.viewWidth, 30)];
    [self addSubview:_sectionHeader];
    
    _gcName = [[UILabel alloc] initWithFrame:CGRectMake(4, 10, 100, 12)];
    _gcName.font = fontForSize(10);
    _gcName.textColor = [UIColor colorWithHex:0x666666];
    [_sectionHeader addSubview:_gcName];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, _gcName.viewBottomEdge, self.viewWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
    [_sectionHeader addSubview:line];
    
    CGFloat width = 40;
    _rightView = [[UIView alloc] initWithFrame:CGRectMake(self.viewWidth - width, 0, width, self.viewHeight)];
    [_sectionHeader addSubview:_rightView];
    
    _arrow = [UIImageView new];
    _arrow.viewSize = CGSizeMake(6, 13);
    _arrow.center = CGPointMake(_rightView.viewWidth - _arrow.viewWidth / 2, _rightView.viewHeight / 2);
    _arrow.image = [UIImage imageNamed:@"icon_jiantou_fl.png"];
    [_rightView addSubview:_arrow];
    
    _all = [UILabel new];
    _all.text = @"全部";
    _all.font = fontForSize(10);
    _all.textColor = [UIColor colorWithHex:0xfd5487];
    [_all sizeToFit];
    _all.center = CGPointMake(_arrow.viewX - 7 - _all.viewWidth / 2, _arrow.center.y);
    [_rightView addSubview:_all];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allAction:)];
    [_rightView addGestureRecognizer:tap];
    
    UITapGestureRecognizer * bannerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerAction:)];
    [_bannerImage addGestureRecognizer:bannerTap];
}
#pragma mark -- setter
- (void)setModel:(ClassModel *)model
{
    _model = model;
    self.gcName.text = model.sectionName;
}

- (void)setBannerModel:(ClassModel *)bannerModel
{
    _bannerModel = bannerModel;
    [_bannerImage sd_setImageWithURL:[NSURL URLWithString:_bannerModel.bannerImage] placeholderImage:nil];
}

#pragma mark -- actions
- (void)allAction:(UITapGestureRecognizer *)tap
{
    self.allAction(self.model);
}

- (void)bannerAction:(UITapGestureRecognizer *)tap
{
    self.bannerAction(self.bannerModel);
}

#pragma mark -- private
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_bannerModel) {
        _bannerImage.hidden = NO;
        _bannerImage.viewSize = CGSizeMake(_bannerImage.viewWidth, 85 * W_ABCW);
    }else {
        _bannerImage.hidden = YES;
        _bannerImage.viewSize = CGSizeMake(_bannerImage.viewWidth, 0);
    }
    _sectionHeader.frame = CGRectMake(0, _bannerImage.viewBottomEdge, _sectionHeader.viewWidth, _sectionHeader.viewHeight);
    _rightView.viewSize = CGSizeMake(_rightView.viewWidth, _sectionHeader.viewHeight);
    _arrow.center = CGPointMake(_rightView.viewWidth - _arrow.viewWidth / 2, _rightView.viewHeight / 2);
    _all.center = CGPointMake(_arrow.viewX - 7 - _all.viewWidth / 2, _arrow.center.y);
}

@end
