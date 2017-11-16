//
//  GoinV.m
//  BMW
//
//  Created by rr on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "GoinV.h"

@implementation GoinV

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUserInterface];
    }
    return self;
}

-(void)initUserInterface{
    self.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64*W_ABCH, SCREEN_WIDTH, 22*W_ABCH)];
    titleLabel.font = fontBoldForSize(22*W_ABCH);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"欢迎来到帮麦网";
    [titleLabel sizeToFit];
    titleLabel.viewWidth = SCREEN_WIDTH;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.viewBottomEdge+9*W_ABCH, SCREEN_WIDTH, 22*W_ABCH)];
    detailLabel.font = fontForSize(11*W_ABCH);
    detailLabel.numberOfLines = 0;
    detailLabel.text = @"购物逛全球，掘金在帮麦\n享受全球好物，实现你的创业梦";
    detailLabel.textColor = [UIColor whiteColor];
    [detailLabel sizeToFit];
    detailLabel.viewWidth = SCREEN_WIDTH;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:detailLabel];
    
    UIImageView *centerImage = [UIImageView new];
    centerImage.viewSize = CGSizeMake(240, 242);
    [centerImage align:ViewAlignmentTopLeft relativeToPoint:CGPointMake((SCREEN_WIDTH-centerImage.viewWidth)/2, detailLabel.viewBottomEdge+37*W_ABCH)];
    centerImage.image = IMAGEWITHNAME(@"jpg_shangdiantupian_hyldbmw.png");
    [self addSubview:centerImage];
    
    UIButton *gotoShopBtn = [[UIButton alloc] initWithFrame:CGRectMake(28*W_ABCW, centerImage.viewBottomEdge+41*W_ABCH, 120*W_ABCW, 31*W_ABCH)];
    gotoShopBtn.backgroundColor = [UIColor whiteColor];
    gotoShopBtn.titleLabel.font = fontForSize(15*W_ABCH);
    [gotoShopBtn setTitle:@"我要购物" forState:UIControlStateNormal];
    [gotoShopBtn addTarget:self action:@selector(GotoShopbtnProess) forControlEvents:UIControlEventTouchUpInside];
    [gotoShopBtn setTitleColor:COLOR_NAVIGATIONBAR_BARTINT forState:UIControlStateNormal];
    gotoShopBtn.layer.cornerRadius = 4;
    gotoShopBtn.layer.masksToBounds = YES;
    [self addSubview:gotoShopBtn];
    
    UILabel *gotoshopLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, gotoShopBtn.viewBottomEdge+12*W_ABCH, 120*W_ABCW, 12*W_ABCH)];
    gotoshopLabel.font = fontForSize(12*W_ABCH);
    gotoshopLabel.textColor = [UIColor whiteColor];
    gotoshopLabel.center = CGPointMake(gotoShopBtn.center.x, gotoShopBtn.viewBottomEdge+12*W_ABCW);
    gotoshopLabel.textAlignment = NSTextAlignmentCenter;
    gotoshopLabel.text = @"进入帮麦体验店购买";
    [self addSubview:gotoshopLabel];
    
    
    
    UIButton *wantShopBtn = [[UIButton alloc] initWithFrame:CGRectMake(gotoShopBtn.viewRightEdge+ 24*W_ABCW*W_ABCW, centerImage.viewBottomEdge+41*W_ABCH, 120*W_ABCW, 31*W_ABCH)];
    wantShopBtn.backgroundColor = [UIColor whiteColor];
    wantShopBtn.titleLabel.font = fontForSize(15*W_ABCH);
    [wantShopBtn setTitle:@"成为麦咖" forState:UIControlStateNormal];
    [wantShopBtn addTarget:self action:@selector(wantShopBtn) forControlEvents:UIControlEventTouchUpInside];
    [wantShopBtn setTitleColor:COLOR_NAVIGATIONBAR_BARTINT forState:UIControlStateNormal];
    wantShopBtn.layer.cornerRadius = 4;
    wantShopBtn.layer.masksToBounds = YES;
    [self addSubview:wantShopBtn];
    
    UILabel *wantshopLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, gotoShopBtn.viewBottomEdge+12*W_ABCH, 120*W_ABCW, 12*W_ABCH)];
    wantshopLabel.font = fontForSize(12*W_ABCH);
    wantshopLabel.textColor = [UIColor whiteColor];
    wantshopLabel.center = CGPointMake(wantShopBtn.center.x, gotoShopBtn.viewBottomEdge+12*W_ABCW);
    wantshopLabel.textAlignment = NSTextAlignmentCenter;
    wantshopLabel.text = @"加入帮麦，成为麦咖";
    [self addSubview:wantshopLabel];
    
}

-(void)GotoShopbtnProess{
    if ([self.delegate respondsToSelector:@selector(gotoShop)]) {
        [self.delegate gotoShop];
    }
}

-(void)wantShopBtn{
    if ([self.delegate respondsToSelector:@selector(wantToShop)]) {
        [self.delegate wantToShop];
    }
}



@end
