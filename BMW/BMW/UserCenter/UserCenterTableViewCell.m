//
//  UserCenterTableViewCell.m
//  BMW
//
//  Created by rr on 16/3/15.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "UserCenterTableViewCell.h"

@implementation UserCenterTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self loadViews];
    }
    return self;
}

-(void)loadViews{
    _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15*W_ABCW, 11.5*W_ABCW, 22*W_ABCW, 22*W_ABCW)];
    [self addSubview:_imageV];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_imageV.viewRightEdge+10*W_ABCW,0,  SCREEN_WIDTH-100*W_ABCW, 45*W_ABCW)];
    _titleLabel.textColor = [UIColor colorWithHex:0x181818];
    _titleLabel.font = fontForSize(13);
    [self addSubview:_titleLabel];
    
    _jiantouR = [UIImageView new];
    _jiantouR.viewSize = CGSizeMake(6, 10);
    _jiantouR.image = IMAGEWITHNAME(@"icon_xiaojiantou_sy.png");
    [_jiantouR align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15*W_ABCW, 45*W_ABCW/2)];
    [self addSubview:_jiantouR];
    
    _detailLabel = [UILabel new];
    _detailLabel.viewSize = CGSizeMake(200, 45*W_ABCW);
    [_detailLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(_jiantouR.viewX-8*W_ABCW, 0)];
    _detailLabel.textAlignment = NSTextAlignmentRight;
    _detailLabel.font = fontForSize(13);
    _detailLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    [self addSubview:_detailLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 45*W_ABCW-0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self addSubview:line];
    
}

@end
