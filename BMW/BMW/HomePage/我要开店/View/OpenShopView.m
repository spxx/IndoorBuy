//
//  OpenShopView.m
//  BMW
//
//  Created by rr on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OpenShopView.h"

@interface OpenShopView ()
{
    UIImageView *_backImageV;
    UILabel *_priceLabel;
    UIScrollView *_scrollView;
}
@end


@implementation OpenShopView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUserInterface];
    }
    return self;
}

-(void)initUserInterface{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self addSubview:_scrollView];
    _backImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,0)];
//    UIImage *image = IMAGEWITHNAME(@"jpg_tupian_wykd.png");
//    CGFloat width = image.size.width;
//    CGFloat height = image.size.height;
//    _backImageV.viewHeight = height*self.viewWidth/width;
//    _backImageV.image = IMAGEWITHNAME(@"jpg_tupian_wykd.png");
    [_scrollView addSubview:_backImageV];
    UIView *placeV = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-45*W_ABCH-64, SCREEN_WIDTH-93*W_ABCW, 45*W_ABCH)];
    placeV.alpha = 0.6;
    placeV.backgroundColor = [UIColor colorWithHex:0xffffff];
    [self addSubview:placeV];
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*W_ABCW, 0, SCREEN_WIDTH-113*W_ABCW, 45*W_ABCH)];
    _priceLabel.textColor = [UIColor colorWithHex:0x000000];
    _priceLabel.font = fontForSize(12);
    [placeV addSubview:_priceLabel];
    _openBtn = [[UIButton alloc] initWithFrame:CGRectMake(placeV.viewRightEdge, placeV.viewY, 93*W_ABCW, 45*W_ABCH)];
    [_openBtn setBackgroundImage:[UIImage squareImageWithColor:COLOR_BACKGRONDCOLOR andSize:_openBtn.viewSize] forState:UIControlStateDisabled];
    _openBtn.userInteractionEnabled = YES;
    [_openBtn setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xfd5487] andSize:_openBtn.viewSize] forState:UIControlStateNormal];
    [_openBtn setTitle:@"成为麦咖" forState:UIControlStateNormal];
    [_openBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    [_openBtn addTarget:self action:@selector(gotoOpenShop) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_openBtn];
}


-(void)setModel:(OpenShopModel *)model{
    _model = model;
    _priceLabel.text = [NSString stringWithFormat:@"友情价：¥%.2f(数量有限)",[_model.price floatValue]];
//    WEAK_SELF;
    [_backImageV sd_setImageWithURL:[NSURL URLWithString:_model.backImageV] placeholderImage:IMAGEWITHNAME(@"jpg_tupian_wykd.png") options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            CGFloat width = image.size.width;
            CGFloat height = image.size.height;
            _backImageV.viewHeight = height*self.viewWidth/width;
            _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _backImageV.viewHeight);
        }
    }];
    _openBtn.userInteractionEnabled = YES;
}

-(void)gotoOpenShop{
    if ([self.delegate respondsToSelector:@selector(NewShop:)]) {
        [self.delegate NewShop:_model];
    }
    
}



@end
