//
//  OilRecordCell.m
//  BMW
//
//  Created by LiuP on 2016/12/17.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OilRecordCell.h"

@interface OilRecordCell ()

@property (nonatomic, strong) UILabel * time;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * message;
@property (nonatomic, strong) UILabel * status;

@end

@implementation OilRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
     
        [self initUserInterface];
    }
    return self;
}

#pragma mark -- UI
- (void)initUserInterface
{
    _time = [UILabel new];
    _time.font = fontForSize(9 * W_ABCW);
    _time.textColor = [UIColor colorWithHex:0x585757];
    [self.contentView addSubview:_time];
    
    _title = [UILabel new];
    _title.font = fontForSize(12 * W_ABCW);
    _title.textColor = [UIColor colorWithHex:0x000000];
    [self.contentView addSubview:_title];
    
    _message = [UILabel new];
    _message.font = fontForSize(9 * W_ABCW);
    _message.textColor = [UIColor colorWithHex:0x585757];
    [self.contentView addSubview:_message];
    
    _status = [UILabel new];
    _status.font = fontForSize(9 * W_ABCW);
    _status.textColor = [UIColor colorWithHex:0x000000];
    [self.contentView addSubview:_status];

}

#pragma mark -- setter
- (void)setModel:(OilRecordModel *)model
{
    _model = model;
    _time.viewSize = CGSizeMake(50, 0);
    _title.viewSize = CGSizeMake(50, 0);
    _message.viewSize = CGSizeMake(50, 0);
    _status.viewSize = CGSizeMake(50, 0);

    _time.text = model.time;
    [_time sizeToFit];
    _title.text = model.title;
    [_title sizeToFit];
    _message.text = model.message;
    [_message sizeToFit];
    _status.text = model.status;
    [_status sizeToFit];
    
    if (model.isHandling) {
        _status.textColor = [UIColor colorWithHex:0x000000];
    }else {
        _status.textColor = [UIColor colorWithHex:0x585757];
    }
}

#pragma mark -- private
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat space = (self.contentView.viewHeight - 10 * W_ABCW - _time.viewHeight - _message.viewHeight - _title.viewHeight) / 2;
    _time.frame = CGRectMake(15 * W_ABCW, 5 * W_ABCW, _time.viewWidth, _time.viewHeight);
    _title.frame = CGRectMake(_time.viewX, _time.viewBottomEdge + space, _title.viewWidth, _title.viewHeight);
    _message.frame = CGRectMake(_title.viewX, _title.viewBottomEdge + space, _message.viewWidth, _message.viewHeight);
    _status.center = CGPointMake(self.contentView.viewRightEdge - 15 * W_ABCW - _status.viewWidth / 2, _title.center.y);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}



@end
