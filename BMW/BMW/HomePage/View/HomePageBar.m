//
//  HomPageBar.m
//  DP
//
//  Created by LiuP on 16/7/25.
//  Copyright © 2016年 sp. All rights reserved.
//

#import "HomePageBar.h"

@interface HomePageBar ()

@property (nonatomic, strong) UIView * redPoint;

@property (nonatomic, strong) UIImageView * storeImage; /**< 店铺logo */

@end

@implementation HomePageBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        [self initUserInterface];
    }
    return self;
}


- (void)initUserInterface
{
    _alphaView = [[UIImageView alloc] initWithFrame:self.bounds];
    _alphaView.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
    _alphaView.alpha = 0.0;
    [self addSubview:_alphaView];
    
    _storeImage = [[UIImageView alloc]initWithFrame:CGRectMake(10 * W_ABCW, 29 , 29, 29)];
    _storeImage.layer.cornerRadius = _storeImage.viewWidth/2;
    _storeImage.image = IMAGEWITHNAME(@"jpg_morentouxiang_store.png");
    _storeImage.layer.masksToBounds = YES;
    _storeImage.userInteractionEnabled = NO;
    [self addSubview:_storeImage];
    
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(_storeImage.viewRightEdge-8,_storeImage.viewY+19, 12, 12)];
    iconImage.image = IMAGEWITHNAME(@"icon_mai_sy.png");
    [self addSubview:iconImage];
    
    UITapGestureRecognizer * scanerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scanCodeAction:)];
    [_storeImage addGestureRecognizer:scanerTap];
    
    UIImageView * messageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.viewWidth - 13 * W_ABCW - 22, 31 , 22, 22)];
    messageView.image = IMAGEWITHNAME(@"icon_xiaoxi_sy.png");
    messageView.userInteractionEnabled = YES;
    [self addSubview:messageView];
    
    _redPoint = [UIView new];
    _redPoint.hidden = YES;
    _redPoint.viewSize = CGSizeMake(10, 10);
    _redPoint.backgroundColor = [UIColor colorWithHex:0xfc4e40];
    _redPoint.layer.cornerRadius = _redPoint.viewWidth / 2;
    _redPoint.layer.borderWidth = 0.5;
    _redPoint.layer.borderColor = [UIColor whiteColor].CGColor;
    _redPoint.center = CGPointMake(messageView.viewWidth - 1, 1);
    [messageView addSubview:_redPoint];
    
    UITapGestureRecognizer * messageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mseeageAction:)];
    [messageView addGestureRecognizer:messageTap];
    
    UIImageView * shareView = [[UIImageView alloc]initWithFrame:CGRectMake(messageView.viewX - 12 * W_ABCW - 20, 33 , 20, 18)];
    shareView.image = IMAGEWITHNAME(@"icon_fenxiang_spxq.png");
    shareView.userInteractionEnabled = YES;
    [self addSubview:shareView];
    
    UITapGestureRecognizer * shareTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareAction:)];
    [shareView addGestureRecognizer:shareTap];


    
    CGFloat searchWidth = self.viewWidth - _storeImage.viewWidth - messageView.viewWidth -shareView.viewWidth - 25 * W_ABCW - 31 * W_ABCW;
    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(_storeImage.viewRightEdge + 11 * W_ABCW, 25, searchWidth, 34)];
    searchView.backgroundColor = [UIColor colorWithHex:0xffffff];
    searchView.layer.cornerRadius = 4;
    searchView.alpha = 0.3;
    [self addSubview:searchView];
    
    UIImageView * searchImage = [UIImageView new];
    searchImage.frame = CGRectMake(searchView.viewX + 11, searchView.viewY + 11, 12, 12);
    searchImage.image = IMAGEWITHNAME(@"icon_Search_sy.png");
    [self addSubview:searchImage];
    
    UILabel * searchLabel = [UILabel new];
    searchLabel.frame = CGRectMake(searchImage.viewRightEdge + 9, searchView.viewY, searchView.viewWidth - searchImage.viewWidth - 22, searchView.viewHeight);
    searchLabel.text = @"搜索帮麦商品";
    searchLabel.textColor = [UIColor whiteColor];
    searchLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:searchLabel];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchAction:)];
    [searchView addGestureRecognizer:tap];
    
    UIView * tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, 24)];
    [self addSubview:tapView];
    
    UITapGestureRecognizer * scrollToTop = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopAction:)];
    [tapView addGestureRecognizer:scrollToTop];
}

#pragma mark -- setter
- (void)setShowRedPoint:(BOOL)showRedPoint
{
    _showRedPoint = showRedPoint;
    self.redPoint.hidden = !showRedPoint;
}

- (void)setLogoModel:(HomePageM *)logoModel
{
    _logoModel = logoModel;
    if ([logoModel.storeLogo.lowercaseString hasPrefix:@"http"]) {
        [self.storeImage sd_setImageWithURL:[NSURL URLWithString:logoModel.storeLogo]
                           placeholderImage:nil
                                    options:SDWebImageAllowInvalidSSLCertificates | SDWebImageRefreshCached];
    }else {
        self.storeImage.image = IMAGEWITHNAME(logoModel.storeLogo);
    }
    if (logoModel.drp == 1) {
        self.storeImage.userInteractionEnabled = NO;        // 分销商不能进入店铺信息
    }else {
        self.storeImage.userInteractionEnabled = YES;
    }
}

#pragma mark -- actions
- (void)scanCodeAction:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(homePageBarClickedScanCodeAction)]) {
        [self.delegate homePageBarClickedScanCodeAction];
    }
}

- (void)mseeageAction:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(homePageBarClickedMessageAction)]) {
        [self.delegate homePageBarClickedMessageAction];
    }
}

-(void)shareAction:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(homePageBarClickedShareAction)]) {
        [self.delegate homePageBarClickedShareAction];
    }
}

- (void)searchAction:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(homePageBarClickedSearchAction)]) {
        [self.delegate homePageBarClickedSearchAction];
    }
}

- (void)tapTopAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"返回顶部");
    if ([self.delegate respondsToSelector:@selector(homePageBarTapTopAction)]) {
        [self.delegate homePageBarTapTopAction];
    }
}


@end
