//
//  ClassifyCollectionCell.m
//  BMW
//
//  Created by gukai on 16/3/14.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ClassifyCollectionCell.h"

@interface ClassifyCollectionCell ()

@property (nonatomic,strong) UILabel * label;

@end

@implementation ClassifyCollectionCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}
-(void)initUserInterface
{
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = fontForSize(12);
    _label.textColor = [UIColor colorWithHex:0x6f6f6f];
    _label.layer.borderWidth = 0.5;
    _label.layer.borderColor = [UIColor colorWithHex:0xe1e1e1].CGColor;
    _label.layer.cornerRadius = 2;
    _label.layer.masksToBounds = YES;
    _label.userInteractionEnabled = YES;
    [self addSubview:_label];
}

- (void)setModel:(ClassModel *)model
{
    _model = model;
    _label.text = model.gcName;
}

#pragma mark -- private
- (void)layoutSubviews
{
    [super layoutSubviews];
    _label.frame = self.bounds;
}
@end
