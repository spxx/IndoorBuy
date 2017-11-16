//
//  HomeCell.m
//  BMW
//
//  Created by gukai on 16/3/3.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "HomeCell.h"

@interface HomeCell ()
@property(nonatomic,strong)UIImageView * goodsImageView;
@property(nonatomic,strong)UIImageView * countryImageView;
@property(nonatomic,strong)UILabel * goodsInfoLabel;
@property(nonatomic,strong)UILabel * goodPriceLabel;
@property(nonatomic,strong)UILabel * VIPPriceLabel;
@property(nonatomic,strong)NSDictionary * attributes;

//覆盖界面

@property(nonatomic,strong)UIImageView *placeImageV;

@end
@implementation HomeCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)initUserInterface
{
    self.viewHeight = 223;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithHex:0xebebeb].CGColor;
    
    
    _goodsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth,153)];
    _goodsImageView.backgroundColor = [UIColor whiteColor];
    NSString * imageURL = [NSString stringWithFormat:@"%@",_dataDic[@"goods_image"]];
    if (![imageURL hasPrefix:@"http"]) {
        imageURL = [NSString stringWithFormat:@"http://pic.indoorbuy.com/%@",imageURL];
    }
    
    UIImageView *centerImage = [UIImageView new];
    centerImage.viewSize = CGSizeMake(102, 24);
    [centerImage align:ViewAlignmentCenter relativeToPoint:CGPointMake(_goodsImageView.viewWidth/2,_goodsImageView.viewHeight/2)];
    centerImage.image = IMAGEWITHNAME(@"logo_sy.png");
    [_goodsImageView addSubview:centerImage];
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [centerImage removeFromSuperview];
    }];
    [self.contentView addSubview:_goodsImageView];
    
    NSString *countryS = [_dataDic[@"originimage"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    
    _countryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.viewWidth - 3 - 17, 3, 17, 12)];
    _countryImageView.layer.borderWidth = 0.5;
    _countryImageView.layer.borderColor = COLOR_BACKGRONDCOLOR.CGColor;
    [_countryImageView sd_setImageWithURL:[NSURL URLWithString:countryS] placeholderImage:nil];
    [self.contentView addSubview:_countryImageView];
    
    _goodsInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, _goodsImageView.viewBottomEdge + 6, self.viewWidth - 8 * 2, 36)];
    _goodsInfoLabel.font = fontForSize(12);
    _goodsInfoLabel.numberOfLines = 2;
    _goodsInfoLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
    _goodsInfoLabel.textAlignment = NSTextAlignmentLeft;
    _goodsInfoLabel.attributedText = [[NSAttributedString alloc]initWithString:_dataDic[@"goods_name"] attributes:self.attributes];
    _goodsInfoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [self.contentView addSubview:_goodsInfoLabel];
    
    
    _goodPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_goodsInfoLabel.viewX, _goodsInfoLabel.viewBottomEdge + 7, 80, 12)];
    _goodPriceLabel.textAlignment = NSTextAlignmentLeft;
    _goodPriceLabel.textColor = [UIColor colorWithHex:0xfd5487];
    _goodPriceLabel.font = fontBoldForSize(12);
    _goodPriceLabel.text = [NSString stringWithFormat:@"￥ %@",_dataDic[@"goods_price"]];
    [_goodPriceLabel sizeToFit];
    _goodPriceLabel.viewSize = CGSizeMake(_goodPriceLabel.viewWidth, 12);
    [self.contentView addSubview:_goodPriceLabel];
    
    _VIPPriceLabel = [UILabel new];
    _VIPPriceLabel.viewSize = CGSizeMake(80, 9);
    [_VIPPriceLabel align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(_goodPriceLabel.viewRightEdge +5, _goodPriceLabel.center.y)];
    _VIPPriceLabel.textAlignment = NSTextAlignmentLeft;
    _VIPPriceLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    _VIPPriceLabel.font = fontForSize(9);
    if(_dataDic[@"normal_discount_price"]){
        if (([[_dataDic objectForKeyNotNull:@"normal_discount_price"] floatValue] - [_dataDic[@"goods_price"] floatValue]) > 0) {
            _VIPPriceLabel.text =  [NSString stringWithFormat:@"麦咖专享返现￥ %.2f",([[_dataDic objectForKeyNotNull:@"normal_discount_price"] floatValue] - [_dataDic[@"goods_price"] floatValue])];
        }else{
            _VIPPriceLabel.text = @"麦咖专享返现￥ 0.00";
        }
    }else{
        if (([_dataDic[@"goods_price"] floatValue] - [_dataDic[@"goods_vip_price"] floatValue])>0) {
            _VIPPriceLabel.text = [NSString stringWithFormat:@"麦咖专享返现￥ %.2f",([_dataDic[@"goods_price"] floatValue] - [_dataDic[@"goods_vip_price"] floatValue])];
        }else{
            _VIPPriceLabel.text = @"麦咖专享返现￥ 0.00";
        }
    }
    [_VIPPriceLabel sizeToFit];
    _VIPPriceLabel.viewSize = CGSizeMake(_VIPPriceLabel.viewWidth,9);
    [self.contentView addSubview:_VIPPriceLabel];
    
    _placeImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 52, 52)];
    NSString *spec_url = [_dataDic[@"icon_img"] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    [_placeImageV sd_setImageWithURL:[NSURL URLWithString:spec_url] placeholderImage:nil];
    [self.contentView addSubview:_placeImageV];

    
}
-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = [NSMutableDictionary dictionaryWithDictionary:dataDic];
    NSString * originimage = _dataDic[@"origin_image"];
    if (![originimage isKindOfClass:[NSNull class]] && originimage && originimage.length > 0) {
        [_dataDic setObject:originimage forKey:@"originimage"];
    }
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    [self initUserInterface];
}

-(void)setAdverDic:(NSDictionary *)adverDic{
    _adverDic = adverDic;
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    NSURL * url = [NSURL URLWithString:_adverDic[@"image"]];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    BOOL existBool = [manager diskImageExistsForURL:url];//判断是否有缓存
    UIImage * image;
    if (existBool) {
        image = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
        CGFloat bilie = SCREEN_WIDTH/image.size.width;
        UIImageView *adverImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, image.size.height * bilie)];
        adverImage.backgroundColor = [UIColor whiteColor];
        
        UIImageView *centerImage = [UIImageView new];
        centerImage.viewSize = CGSizeMake(102, 24);
        [centerImage align:ViewAlignmentCenter relativeToPoint:CGPointMake(adverImage.viewWidth/2,adverImage.viewHeight/2)];
        centerImage.image = IMAGEWITHNAME(@"logo_sy.png");
        [adverImage addSubview:centerImage];
        
        [adverImage sd_setImageWithURL:[NSURL URLWithString:_adverDic[@"image"]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [centerImage removeFromSuperview];
        }];
        [self.contentView addSubview:adverImage];
    }else{
        UIImageView *adverImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.viewHeight)];
        adverImage.backgroundColor = [UIColor whiteColor];
        
        UIImageView *centerImage = [UIImageView new];
        centerImage.viewSize = CGSizeMake(102, 24);
        [centerImage align:ViewAlignmentCenter relativeToPoint:CGPointMake(adverImage.viewWidth/2,adverImage.viewHeight/2)];
        [adverImage addSubview:centerImage];
        
        [adverImage sd_setImageWithURL:[NSURL URLWithString:_adverDic[@"image"]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [centerImage removeFromSuperview];
        }];
        [self.contentView addSubview:adverImage];
    }
    
    
}



-(void)setModle:(GoodsListModle *)modle
{
    _modle = modle;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:modle.goods_image] placeholderImage:nil];
    [_countryImageView sd_setImageWithURL:[NSURL URLWithString:modle.goods_image] placeholderImage:nil];
    _goodsInfoLabel.attributedText = [[NSAttributedString alloc]initWithString:modle.goods_jingle attributes:self.attributes];
    _goodPriceLabel.text = [NSString stringWithFormat:@"￥ %@",_modle.goods_marketprice];
    [_goodPriceLabel sizeToFit];
    _VIPPriceLabel.text = [NSString stringWithFormat:@"￥ %@",_modle.goods_price];
    _VIPPriceLabel.frame = CGRectMake(_goodPriceLabel.viewRightEdge + 5, _goodPriceLabel.viewY + 5, 80, 15);
    [_VIPPriceLabel sizeToFit];
}
#pragma mark -- set --
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
    _attributes = @{NSFontAttributeName:fontForSize(12),NSParagraphStyleAttributeName:paragraphStyle};
    return _attributes;
}
@end
