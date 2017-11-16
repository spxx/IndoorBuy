//
//  ClassCell.m
//  BMW
//
//  Created by LiuP on 2016/12/6.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ClassCell.h"

@interface ClassCell ()

@property (nonatomic, strong) UILabel * gcName;

@property (nonatomic, strong) UIView * line;

@end

@implementation ClassCell

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
    _line = [UIView new];
    _line.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
    [self.contentView addSubview:_line];
    
    _gcName = [UILabel new];
    _gcName.font = fontForSize(12 * W_ABCW);
    _gcName.textAlignment = NSTextAlignmentCenter;
    _gcName.layer.borderColor = [UIColor colorWithHex:0xfd5487].CGColor;
    [self.contentView addSubview:_gcName];
}


- (void)setModel:(ClassModel *)model
{
    _model = model;
    _gcName.text = model.gcName;
    if (model.selected) {
        _gcName.textColor = [UIColor colorWithHex:0xfd5487];
        _gcName.layer.borderWidth = 1;
    }else {
        _gcName.textColor = [UIColor blackColor];
        _gcName.layer.borderWidth = 0;
    }
}

#pragma mark -- private
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _line.frame = CGRectMake(self.contentView.viewRightEdge - 0.5, 0, 0.5, self.contentView.viewHeight);
    _gcName.frame = CGRectMake(0, 0, self.contentView.viewWidth - 0.5, self.contentView.viewHeight);
}

@end
