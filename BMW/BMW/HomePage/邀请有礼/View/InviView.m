//
//  InviView.m
//  BMW
//
//  Created by rr on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "InviView.h"

@interface InviView ()
{
    UIImageView *_topImageV;
    UIScrollView *_scrollView;
    UILabel *_invuText;
    UIButton *_inviButton;
    
}
@end

@implementation InviView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUserInterface];
    }
    return self;
}

-(void)initUserInterface{

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self addSubview:_scrollView];
    
    _topImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 294*W_ABCH)];
    [_topImageV sd_setImageWithURL:nil placeholderImage:IMAGEWITHNAME(@"")];
    [_scrollView addSubview:_topImageV];
    
    _invuText = [[UILabel alloc] initWithFrame:CGRectMake(0, _topImageV.viewBottomEdge+18*W_ABCH, SCREEN_WIDTH, 12*W_ABCH)];
    _invuText.textAlignment = NSTextAlignmentCenter;
    _invuText.text = @"推荐好友注册，双方都能拿邀请大礼包哟~";
    _invuText.font = fontForSize(12*W_ABCH);
    _invuText.textColor = [UIColor colorWithHex:0x000000];
    [_scrollView addSubview:_invuText];
//
//    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, invuText.viewBottomEdge+9*W_ABCH, SCREEN_WIDTH, 15)];
//    priceLabel.textColor = COLOR_NAVIGATIONBAR_BARTINT;
//    priceLabel.text = @"58元邀请礼包";
//    priceLabel.font = fontForSize(15);
//    priceLabel.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:priceLabel];
    
    _inviButton = [UIButton new];
    _inviButton.viewSize = CGSizeMake(280*W_ABCW, 37*W_ABCH);
    [_inviButton align:ViewAlignmentTopCenter relativeToPoint:CGPointMake(SCREEN_WIDTH/2, _invuText.viewBottomEdge+10*W_ABCH)];
    _inviButton.layer.cornerRadius = _inviButton.viewHeight/2;
    _inviButton.layer.masksToBounds = YES;
    [_inviButton setBackgroundColor:COLOR_NAVIGATIONBAR_BARTINT];
    [_inviButton setTitle:@"邀请好友，立享礼包" forState:UIControlStateNormal];
    [_inviButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    _inviButton.titleLabel.font = fontForSize(15*W_ABCH);
    [_inviButton addTarget:self action:@selector(shareBtn) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_inviButton];
}

-(void)updateImageV:(NSString *)url{
    [_topImageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            CGFloat bilie = SCREEN_WIDTH/image.size.width;
            _topImageV.viewSize = CGSizeMake(SCREEN_WIDTH, image.size.height*bilie);
            _invuText.viewY = _topImageV.viewBottomEdge+18*W_ABCH;
            _inviButton.viewY = _invuText.viewBottomEdge+10*W_ABCH;
            _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _inviButton.viewBottomEdge+20+64);
        }
    }];
}

-(void)shareBtn{
    if ([self.delegate respondsToSelector:@selector(InviTion)]) {
        [self.delegate InviTion];
    }
}


@end
