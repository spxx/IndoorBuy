//
//  GoodsParameterCell.m
//  BMW
//
//  Created by gukai on 16/3/9.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "GoodsParameterCell.h"
#import "UILabel+StringSize.h"
@interface GoodsParameterCell ()
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UILabel * detailLabel;
@property(nonatomic,strong)NSDictionary * attributes;
@end
@implementation GoodsParameterCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
-(void)initUserInterface
{
    UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(96 * W_ABCW, 15 , SCREEN_WIDTH - 96 * W_ABCW - 15, 20)];
    //detailLabel.text = _dataDic[@"value"];
    detailLabel.text = [_dataDic objectForKeyNotNull:@"value"];
    detailLabel.numberOfLines = 0;
    detailLabel.font = fontForSize(13);
    detailLabel.textColor = [UIColor colorWithHex:0x181818];
    [self.contentView addSubview:detailLabel];
    
    //根据文本计算高度
    CGSize size = [detailLabel boundingRectWithSize:CGSizeMake(detailLabel.viewWidth, 2000)];
    
    detailLabel.frame = CGRectMake(detailLabel.viewX, detailLabel.viewY, detailLabel.viewWidth,size.height);
    
    CGFloat cellNewHeight = detailLabel.viewBottomEdge + 15;
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, cellNewHeight)];
    //nameLabel.text = _dataDic[@"title"];
    nameLabel.text = [_dataDic objectForKeyNotNull:@"title"];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = fontForSize(13);
    nameLabel.textColor = [UIColor colorWithHex:0x6f6f6f];
    [self.contentView addSubview:nameLabel];
    
    
    UIView * line  =[[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 290 * W_ABCW) / 2, cellNewHeight - 0.5,290 * W_ABCW, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self.contentView addSubview:line];
    
    if ([self.delegate respondsToSelector:@selector(heightGoodParameterCell:index:newHeight:)]) {
        [self.delegate heightGoodParameterCell:self index:self.index newHeight:cellNewHeight];
    }
}
-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic =dataDic;
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    [self initUserInterface];
    
    
}
#pragma mark -- get --
-(NSDictionary *)attributes
{
    if (_attributes) {
        return _attributes;
    }
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    _attributes = @{NSFontAttributeName:fontForSize(13),NSParagraphStyleAttributeName:paragraphStyle};
    return _attributes;
}
@end
