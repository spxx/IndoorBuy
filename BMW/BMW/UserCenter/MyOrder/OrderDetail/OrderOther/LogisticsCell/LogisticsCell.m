//
//  LogisticsCell.m
//  BMW
//
//  Created by gukai on 16/3/24.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "LogisticsCell.h"

@interface LogisticsCell ()
@property(nonatomic,strong)UIView * lineSperate;

@end
@implementation LogisticsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
-(void)initUserInterface
{
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(56, 16, SCREEN_WIDTH - 27 - 56, 40)];
    if (self.logisticsCellType == LogisticsCellLogistic) {
        contentLabel.text = _dataDic[@"content"];
        
    }
    else {
        contentLabel.text = _dataDic[@"description"];
        
    }
    contentLabel.textAlignment = NSTextAlignmentLeft;
    if (self.index.row == 0) {
        contentLabel.textColor = [UIColor colorWithHex:0x29b062];
    }
    else{
        contentLabel.textColor = [UIColor colorWithHex:0xb2b2b2];
    }
    
    contentLabel.font = fontForSize(12);
    contentLabel.numberOfLines = 0;
    [contentLabel sizeToFit];
    contentLabel.frame = CGRectMake(56, 16, contentLabel.bounds.size.width, contentLabel.bounds.size.height);
    [self.contentView addSubview:contentLabel];
    
    
    UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(contentLabel.viewX, contentLabel.viewBottomEdge + 12, SCREEN_WIDTH - 27 - 56, 10)];
    if (self.logisticsCellType == LogisticsCellLogistic) {
        timeLabel.text = _dataDic[@"time"];

    }
    else {
        timeLabel.text = [TYTools getTimeToShowWithTimestamp:_dataDic[@"add_time"]];
    }
//    timeLabel.text = [TYTools getTimeToShowWithTimestamp:_dataDic[@"add_time"]];
    timeLabel.font = fontForSize(10);
    if (self.index.row == 0) {
         timeLabel.textColor = [UIColor colorWithHex:0x29b062];
    }
    else{
        timeLabel.textColor = [UIColor colorWithHex:0xb2b2b2];
    }
    
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:timeLabel];
    
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(contentLabel.viewX, timeLabel.viewBottomEdge + 14, SCREEN_WIDTH - 56, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self.contentView addSubview:line];
    self.lineSperate = line;
    
    UIView * lastBottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, line.viewY, SCREEN_WIDTH, 0.5)];
    lastBottomLine.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self.contentView addSubview:lastBottomLine];
    self.lastBottomLine = lastBottomLine;
    lastBottomLine.hidden = YES;

    
}
-(void)initLine
{
    if (self.index.row == 0) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 14, 15)];
        imageView.image = [UIImage imageNamed:@"icon_qipao_wdddxq.png"];
        [self.contentView addSubview:imageView];
        
        UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(imageView.viewX + imageView.viewWidth / 2 - 0.5, imageView.viewBottomEdge, 1, self.lineSperate.viewBottomEdge - imageView.viewBottomEdge)];
        lineV.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [self.contentView addSubview:lineV];
    }
    else{
        UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(15 + 7 - 0.5, 0,1 , self.lineSperate.viewBottomEdge)];
        lineV.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [self.contentView addSubview:lineV];
        
        
        UIView * cornerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 8)];
        cornerView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        cornerView.layer.cornerRadius = cornerView.viewWidth / 2;
        
        cornerView.layer.masksToBounds = YES;
        cornerView.center = CGPointMake(lineV.viewX + lineV.viewWidth / 2, lineV.viewHeight / 2);
        [self.contentView addSubview:cornerView];
    }
}
-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    [self initUserInterface];
    [self initLine];
}


-(void)setIndex:(NSIndexPath *)index
{
    _index = index;
}
@end
