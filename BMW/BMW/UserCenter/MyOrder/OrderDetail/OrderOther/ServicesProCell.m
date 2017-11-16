//
//  ServicesProCell.m
//  BMW
//
//  Created by gukai on 16/3/23.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ServicesProCell.h"

@implementation ServicesProCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //[self initUserInterface];
    }
    return self;
}
-(void)initUserInterface
{
    UILabel * goodsInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 24)];
    goodsInfoLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
    goodsInfoLabel.textAlignment = NSTextAlignmentLeft;
    goodsInfoLabel.font = fontForSize(12);
    goodsInfoLabel.numberOfLines = 0;
    goodsInfoLabel.text = _dataDic[@"goods_name"];
    [goodsInfoLabel sizeToFit];
    [self.contentView addSubview:goodsInfoLabel];
    
    
    UILabel * sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodsInfoLabel.viewX, goodsInfoLabel.viewBottomEdge + 8, SCREEN_WIDTH - 100, 10)];
    sizeLabel.textAlignment = NSTextAlignmentLeft;
    sizeLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    sizeLabel.font = fontForSize(10);
//    NSDictionary * dic =  [_dataDic objectForKeyNotNull:@"goods_spec"];
    NSDictionary * dic = _dataDic[@"goods_spec"];
    NSString * goods_sepc = @"";
    if (![dic isKindOfClass:[NSNull class]]) {
        if (dic && dic.allKeys > 0) {
            for (NSString * key in dic.allKeys) {
                NSString * string = dic[key];
                goods_sepc = [goods_sepc stringByAppendingString:[NSString stringWithFormat:@"%@,",string]];
            }
            goods_sepc =  [goods_sepc substringToIndex:goods_sepc.length - 1];
            
        }
    }
    
    sizeLabel.text = goods_sepc;
    [self.contentView addSubview:sizeLabel];
    
    
    UILabel * goodNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 100,sizeLabel.viewY + 2 , 100, 12)];
    goodNumLabel.textAlignment = NSTextAlignmentRight;
    goodNumLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
    goodNumLabel.font = fontForSize(12);
    goodNumLabel.text = [NSString stringWithFormat:@"x%@",_dataDic[@"goods_num"]];
    [self.contentView addSubview:goodNumLabel];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, goodNumLabel.viewBottomEdge + 5.5 , SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self.contentView addSubview:line];
    
    
}
-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    [self initUserInterface];
}
@end
