//
//  HelpCenterTableViewCell.m
//  BMW
//
//  Created by 白琴 on 16/3/23.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "HelpCenterTableViewCell.h"

@interface HelpCenterTableViewCell () {
    UIView * _iconView;
    UILabel * _contentLabel;
}

@end

@implementation HelpCenterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellAccessoryNone;
        _iconView = [UIView new];
        _iconView.viewSize = CGSizeMake(8 * W_ABCW, 8 * W_ABCW);
        [_iconView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, (self.viewHeight - _iconView.viewHeight)/ 2)];
        _iconView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        _iconView.layer.cornerRadius = _iconView.viewHeight / 2;
        _iconView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconView];
        
        _contentLabel = [UILabel new];
        _contentLabel.viewSize = CGSizeMake(SCREEN_WIDTH - _iconView.viewRightEdge - 6 * W_ABCW, self.viewHeight);
        _contentLabel.font = fontForSize(13);
        _contentLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
        [_contentLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_iconView.viewRightEdge + 6 * W_ABCW, 0)];
        [self.contentView addSubview:_contentLabel];
    }
    return self;
}

- (void)setContentString:(NSString *)contentString {
    [_iconView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, (self.viewHeight - _iconView.viewHeight)/ 2)];
    _contentLabel.text = contentString;
    [_contentLabel sizeToFit];
    [_contentLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_iconView.viewRightEdge + 6 * W_ABCW, (self.viewHeight - _contentLabel.viewHeight) / 2)];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
