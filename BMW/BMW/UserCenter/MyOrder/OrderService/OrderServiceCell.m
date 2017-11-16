//
//  OrderServiceCell.m
//  BMW
//
//  Created by gukai on 16/3/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OrderServiceCell.h"

@interface OrderServiceCell ()
@property(nonatomic,strong)UIImageView * goodsImage;
@property(nonatomic,strong)UILabel * infoLabel;
@property(nonatomic,strong)UILabel * lable;
@property(nonatomic,strong)UILabel * goodsNumLable;
@end
@implementation OrderServiceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUserInterface];
    }
    return self;
}
-(void)initUserInterface
{
    UIImageView * goodImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 79, 79)];
    goodImage.backgroundColor = [UIColor whiteColor];
    [self addSubview:goodImage];
    self.goodsImage = goodImage;
    
    
    UILabel * infoLable = [[UILabel alloc]initWithFrame:CGRectMake(goodImage.viewRightEdge + 12, goodImage.viewY, SCREEN_WIDTH - goodImage.viewRightEdge - 12 - 15, 40)];
    infoLable.text = @"德国爱他美奶粉Aptami l 1+(12个月以上)600g";
    infoLable.numberOfLines = 2;
    infoLable.font = fontForSize(12);
    infoLable.textColor = [UIColor colorWithHex:0x3d3d3d];
    infoLable.textAlignment = NSTextAlignmentLeft;
    [self addSubview:infoLable];
    self.infoLabel = infoLable;
    
    
    UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(infoLable.viewX, infoLable.viewBottomEdge + 3, infoLable.viewWidth, 10)];
    lable.font = fontForSize(10);
    lable.textColor = [UIColor colorWithHex:0x7f7f7f];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.text = @"红色，425g装";
    [self addSubview:lable];
    self.lable = lable;
    
    
    UILabel * goodsNum = [[UILabel alloc]initWithFrame:CGRectMake(infoLable.viewX, goodImage.viewBottomEdge - 15, lable.viewWidth, 12)];
    goodsNum.text = @"x2";
    goodsNum.textAlignment = NSTextAlignmentLeft;
    goodsNum.textColor = [UIColor colorWithHex:0x3d3d3d];
    goodsNum.font = fontForSize(12);
    [self addSubview:goodsNum];
    self.goodsNumLable = goodsNum;
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 99.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self addSubview:line];
    
}
-(void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:nil];
}
-(void)setInfoText:(NSString *)infoText
{
    _infoText = infoText;
    self.infoLabel.text = _infoText;
    [self.infoLabel setViewWidth:SCREEN_WIDTH - self.goodsImage.viewRightEdge - 12 - 15];
    [self.infoLabel sizeToFit];
    self.infoLabel.frame = CGRectMake(self.goodsImage.viewRightEdge + 12, self.goodsImage.viewY, _infoLabel.bounds.size.width, _infoLabel.bounds.size.height);
}
-(void)setGoodsNum:(NSInteger )goodsNum
{
    _goodsNum = goodsNum;
    self.goodsNumLable.text = [NSString stringWithFormat:@"x%ld",(long)_goodsNum];
}
-(void)setSpe_dic:(NSDictionary *)spe_dic
{
    _spe_dic = spe_dic;
    NSString * goods_sepc = @"";
    if (![_spe_dic isKindOfClass:[NSNull class]] && _spe_dic && _spe_dic.allKeys > 0) {
        for (NSString * key in _spe_dic.allKeys) {
            NSString * string = _spe_dic[key];
            goods_sepc = [goods_sepc stringByAppendingString:[NSString stringWithFormat:@"%@,",string]];
        }
        goods_sepc =  [goods_sepc substringToIndex:goods_sepc.length - 1];
        self.lable.text = goods_sepc;
        self.lable.frame = CGRectMake(self.infoLabel.viewX,self.infoLabel.viewBottomEdge + 3, self.lable.viewWidth, 10);
        
    }
    else{
        self.lable.text = nil;
    }
   
}
@end
