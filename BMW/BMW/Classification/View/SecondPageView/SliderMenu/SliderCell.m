//
//  SliderCell.m
//  BMW
//
//  Created by gukai on 16/3/3.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "SliderCell.h"

@interface SliderCell ()

@property(nonatomic,strong)UILabel * label;

@end

@implementation SliderCell
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
    _label = [UILabel new];
    _label.font = fontForSize(13);
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor colorWithHex:0x7f7f7f];
    [self.contentView addSubview:_label];
   
}

- (void)setModel:(ClassModel *)model
{
    _model = model;
    _label.text = _model.gcName;
    if (model.selected) {
        _label.textColor = [UIColor colorWithHex:0xfd5487];
    }else {
        _label.textColor = [UIColor colorWithHex:0x7f7f7f];
    }
}

#pragma mark -- private
- (void)layoutSubviews
{
    [super layoutSubviews];
    _label.frame = self.bounds;
}

@end
