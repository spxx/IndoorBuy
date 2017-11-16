//
//  GoodsInfoView.m
//  BMW
//
//  Created by gukai on 16/3/8.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "GoodsInfoView.h"

@interface GoodsInfoView (){
    UIButton *_rowButton;
}
@property(nonatomic,strong)UIImageView * imageView;


//购物服务说明
@property(nonatomic,strong)UILabel * goodIntroLabel;
@property(nonatomic,strong)UILabel * expressdayLabel;
@property(nonatomic,strong)UILabel * invoiceLabel;
@property(nonatomic,strong)UILabel * serviceLabel;
@property(nonatomic,strong)UILabel * lastLabel;
@end
@implementation GoodsInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;

}
-(void)initUserInterface
{
    UILabel *introLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 36)];
    introLabel.text = @"跨境购物服务说明";
    introLabel.textColor = [UIColor colorWithHex:0x181818];
    introLabel.font = fontForSize(11);
    [self addSubview:introLabel];
    
    UIImageView *noticeImageV = [UIImageView new];
    noticeImageV.viewSize = CGSizeMake(12,12);
    [noticeImageV align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-10, 18)];
    noticeImageV.image = IMAGEWITHNAME(@"icon_shuoming_spxq.png");
    [self addSubview:noticeImageV];
    
    _rowButton = [UIButton new];
    _rowButton.viewSize = CGSizeMake(40, 30);
    [_rowButton align:ViewAlignmentBottomCenter relativeToPoint:CGPointMake(SCREEN_WIDTH/2, 36)];
    [_rowButton setImage:IMAGEWITHNAME(@"icon_xialajiantou_spxq.png") forState:UIControlStateNormal];
    [_rowButton setImage:IMAGEWITHNAME(@"icon_shanglajiantou_spxq.png") forState:UIControlStateSelected];
    [_rowButton addTarget:self action:@selector(rowButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rowButton];
    
    
    UIButton * bigButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
    [bigButton addTarget:self action:@selector(rowButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bigButton];
    
    _goodIntroLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, introLabel.viewBottomEdge, SCREEN_WIDTH - 20, 10)];
    _goodIntroLabel.textAlignment = NSTextAlignmentLeft;
    _goodIntroLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
    _goodIntroLabel.font = fontForSize(10);
    _goodIntroLabel.text = @"1.由于跨境商品特殊性，此商品如无质量问题不支持7天无理由退货;";
    _goodIntroLabel.hidden = YES;
    [self addSubview:_goodIntroLabel];
    
    _expressdayLabel = [[UILabel alloc]initWithFrame:CGRectMake(_goodIntroLabel.viewX, _goodIntroLabel.viewBottomEdge + 6, _goodIntroLabel.viewWidth, _goodIntroLabel.viewHeight)];
    _expressdayLabel.textAlignment = NSTextAlignmentLeft;
    _expressdayLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
    _expressdayLabel.font = fontForSize(10);
    _expressdayLabel.text = @"2.保税区发货需要5-10个工作日到货，海外直邮商品需要15-20个工作日到货;";
    _expressdayLabel.hidden = YES;
    [self addSubview:_expressdayLabel];
    
    _invoiceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_expressdayLabel.viewX, _expressdayLabel.viewBottomEdge + 6, _expressdayLabel.viewWidth, _expressdayLabel.viewHeight)];
    _invoiceLabel.textAlignment = NSTextAlignmentLeft;
    _invoiceLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
    _invoiceLabel.font = fontForSize(10);
    _invoiceLabel.text = @"3.商品通关有可能需要您提供购买人的身份证信息;";
    _invoiceLabel.hidden = YES;
    [self addSubview:_invoiceLabel];

    
    _serviceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_invoiceLabel.viewX, _invoiceLabel.viewBottomEdge + 6, _invoiceLabel.viewWidth, _invoiceLabel.viewHeight)];
    _serviceLabel.textAlignment = NSTextAlignmentLeft;
    _serviceLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
    _serviceLabel.font = fontForSize(10);
    _serviceLabel.text = @"4.跨境商品属于境外购买行为，无法开具发票，请您谅解;";
    _serviceLabel.hidden = YES;
    [self addSubview:_serviceLabel];
    
    _lastLabel = [[UILabel alloc]initWithFrame:CGRectMake(_serviceLabel.viewX, _serviceLabel.viewBottomEdge + 6, _serviceLabel.viewWidth, _serviceLabel.viewHeight)];
    _lastLabel.textAlignment = NSTextAlignmentLeft;
    _lastLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
    _lastLabel.font = fontForSize(10);
    _lastLabel.text = @"5.如有问题请联系客服人员;";
    _lastLabel.hidden = YES;
    [self addSubview:_lastLabel];
    

}


-(void)rowButton:(UIButton *)sender{
    _rowButton.selected = !_rowButton.selected;
    if (_rowButton.selected) {
        _rowButton.selected = YES;
        self.viewHeight = 115;
        [_rowButton align:ViewAlignmentBottomCenter relativeToPoint:CGPointMake(SCREEN_WIDTH/2, self.viewHeight+4)];
        _goodIntroLabel.hidden = NO;
        _expressdayLabel.hidden = NO;
        _invoiceLabel.hidden = NO;
        _serviceLabel.hidden = NO;
        _lastLabel.hidden = NO;

    }else{
        _rowButton.selected = NO;
        self.viewHeight = 36;
        [_rowButton align:ViewAlignmentBottomCenter relativeToPoint:CGPointMake(SCREEN_WIDTH/2, self.viewHeight)];
        _goodIntroLabel.hidden = YES;
        _expressdayLabel.hidden = YES;
        _invoiceLabel.hidden = YES;
        _serviceLabel.hidden = YES;
        _lastLabel.hidden = YES;
    }
    if ([self.delegate respondsToSelector:@selector(GoodsInfoViewClickButton:)]) {
        [self.delegate GoodsInfoViewClickButton:self.viewHeight];
    }
}



#pragma mark -- set --
-(void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:nil];
}

-(void)setGoodsIntro:(NSString *)goodsIntro
{
    _goodsIntro = goodsIntro;
    self.goodIntroLabel.text = _goodsIntro;
}
-(void)setExpressday:(NSString *)expressday
{
    _expressday = expressday;
    self.expressdayLabel.text = _expressday;
}
@end
