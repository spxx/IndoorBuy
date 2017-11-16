//
//  UserCouponsTableViewCell.m
//  BMW
//
//  Created by 白琴 on 16/3/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "UserCouponsTableViewCell.h"

@implementation UserCouponsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self loadView];
    }
    return self;
}

- (void)loadView {
    _iconImageView = [UIImageView new];
    _iconImageView.viewSize = CGSizeMake(SCREEN_WIDTH - 30 * W_ABCW, 75 * W_ABCW);
    [_iconImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, 15*W_ABCW)];
    [self.contentView addSubview:_iconImageView];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(15 * W_ABCW, _iconImageView.viewBottomEdge, SCREEN_WIDTH - 30 * W_ABCW, 36 * W_ABCW)];
    view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:view];
    
    _timeLabel = [UILabel new];
    _timeLabel.viewSize = CGSizeMake(view.viewWidth - 20 * W_ABCW, 36 * W_ABCW);
    [_timeLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(25 * W_ABCW, _iconImageView.viewBottomEdge)];
    _timeLabel.font = fontForSize(12);
    _timeLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
    //_timeLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_timeLabel];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
