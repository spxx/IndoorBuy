//
//  ClassItemCell.m
//  BMW
//
//  Created by LiuP on 2016/12/6.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ClassItemCell.h"

@interface ClassItemCell ()

@property (nonatomic, strong) UIImageView * classImage;

@property (nonatomic, strong) UILabel * className;

@end

@implementation ClassItemCell

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
    _classImage = [UIImageView new];
    //_classImage.layer.borderWidth = 0.5;
    //_classImage.layer.borderColor = [UIColor colorWithHex:0xdfdfdf].CGColor;
    [self.contentView addSubview:_classImage];
    
    _className = [UILabel new];
    _className.font = fontForSize(10);
    _className.textColor = [UIColor colorWithHex:0x989898];
    _className.textAlignment = NSTextAlignmentCenter;
    _className.numberOfLines = 0;
    [self.contentView addSubview:_className];
}

#pragma mark -- private
- (void)layoutSubviews
{
    [super layoutSubviews];
    _classImage.frame = CGRectMake(0, 0, self.contentView.viewWidth, self.contentView.viewWidth);
    _className.frame = CGRectMake(0, _classImage.viewBottomEdge + 9, _classImage.viewWidth, _className.viewHeight);
}

#pragma mark -- setter
- (void)setModel:(ClassModel *)model
{
    _model = model;
    [_classImage sd_setImageWithURL:[NSURL URLWithString:model.itemImage] placeholderImage:nil];
    _className.text = model.itemName;
    [_className sizeToFit];
    _className.frame = CGRectMake(_className.viewX, _className.viewY, _classImage.viewWidth, _className.viewHeight);
}

@end
