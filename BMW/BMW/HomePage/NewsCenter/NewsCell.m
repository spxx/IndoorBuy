//
//  NewsCell.m
//  BMW
//
//  Created by rr on 16/3/22.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self loadViews];
    }
    return self;
}

-(void)loadViews{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*W_ABCW, 16*W_ABCH, 26, 13*W_ABCW)];
    _titleLabel.font = fontForSize(13);
    _titleLabel.textColor = [UIColor colorWithHex:0x181818];
    _titleLabel.text = @"订单";
    [_titleLabel sizeToFit];
    _titleLabel.viewHeight = 13*W_ABCW;
    [self addSubview:_titleLabel];
    
    _numImage = [[UIImageView alloc] initWithFrame:CGRectMake(_titleLabel.viewRightEdge+4*W_ABCW, _titleLabel.viewY-1*W_ABCW, 14*W_ABCW, 14*W_ABCW)];
//    _numImage.image = IMAGEWITHNAME(@"icon_shuliangqipao_xx.png");
    _numImage.backgroundColor = [UIColor colorWithHex:0xfd5487];
    _numImage.layer.cornerRadius = _numImage.viewWidth / 2;
    [self addSubview:_numImage];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.viewX, _titleLabel.viewBottomEdge+10*W_ABCH, SCREEN_WIDTH-46*W_ABCW, 12)];
//    _detailLabel.text = @"测试市场车侧滑车上车可接受的和看似简单开户行速度快好计算的海景房加共和国的精华液个";
    _detailLabel.numberOfLines = 1;
    _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _detailLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    _detailLabel.font = fontForSize(12);
    [self addSubview:_detailLabel];
    
    _row = [UIImageView new];
    _row.viewSize = CGSizeMake(6, 10);
    [_row align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15*W_ABCW, 33*W_ABCH)];
    _row.image= IMAGEWITHNAME(@"icon_xiaojiantou_sy.png");
    [self addSubview:_row];
    
    _timeLabel = [UILabel new];
    _timeLabel.viewSize = CGSizeMake(100, 11);
    _timeLabel.text = @"17:00";
    _timeLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    _timeLabel.font = fontForSize(11);
    [_timeLabel sizeToFit];
    _timeLabel.viewSize = CGSizeMake(_timeLabel.viewWidth, 11);
    [_timeLabel align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(_row.viewX-10*W_ABCW, _titleLabel.center.y)];
//    [self addSubview:_timeLabel];
}

-(void)setHideOrShow:(BOOL)hideOrShow{
    _hideOrShow = hideOrShow;
    if (_hideOrShow) {
        _numImage.hidden = YES;
        _timeLabel.hidden = YES;
    }else{
        _numImage.hidden = NO;
        _timeLabel.hidden = NO;
    }
}

-(void)setCount:(NSInteger)count{
    [_num removeFromSuperview];
    _num = nil;
    _num = [UILabel new];
    _num.viewSize = CGSizeMake(14*W_ABCW, 11);
    [_num align:ViewAlignmentCenter relativeToPoint:CGPointMake(_numImage.viewWidth/2, _numImage.viewHeight/2)];
    _num.text = [NSString stringWithFormat:@"%ld",count];
    if (count>99) {
        _num.text = @"N";
    }
    _num.font = fontForSize(11);
    _num.textAlignment = NSTextAlignmentCenter;
    _num.textColor =[UIColor whiteColor];
    [_numImage addSubview:_num];
}


-(void)setIsread:(BOOL)isread{
    if (isread) {
        _detailLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    }else{
        _detailLabel.textColor = [UIColor colorWithHex:0xfd5487];
    }
}


- (void)setTimeStr:(NSString *)timeStr
{
    _timeLabel.text = timeStr;
    [_timeLabel sizeToFit];
    [_timeLabel align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(_row.viewX-10*W_ABCW, _titleLabel.center.y)];
}





@end
