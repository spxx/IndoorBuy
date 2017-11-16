//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  MJRefreshLegendHeader.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "MJRefreshLegendHeader.h"
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"

@interface MJRefreshLegendHeader()
@property (nonatomic, weak) UIImageView *arrowImage;
@property (nonatomic, weak) UIActivityIndicatorView *activityView;
/** 加载图片 */  //  by--LiuP
@property (nonatomic, strong)UIImageView * loadingImage;
@end

@implementation MJRefreshLegendHeader
#pragma mark - 懒加载
- (UIImageView *)arrowImage
{
    if (!_arrowImage) {
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"arrow.png")]];
        [self addSubview:_arrowImage = arrowImage];
    }
    return _arrowImage;
}

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.bounds = self.arrowImage.bounds;
        [self addSubview:_activityView = activityView];
    }
    return _activityView;
}

- (UIImageView *)loadingImage
{
    if (!_loadingImage) {
        _loadingImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
        _loadingImage.alpha = 0.0;
        _loadingImage.image = [UIImage imageNamed:@"icon_jiazaizhong1.png"];
        [self addSubview:_loadingImage];
    }
    return _loadingImage;
}
#pragma mark - 初始化
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = COLOR_BACKGRONDCOLOR;
    
    // 箭头
    CGFloat arrowX = (self.stateHidden && self.updatedTimeHidden) ? self.mj_w * 0.5 : (self.mj_w * 0.5 - 100);
    self.arrowImage.center = CGPointMake(arrowX, self.mj_h * 0.5);
    
    // 指示器
    self.activityView.center = self.arrowImage.center;
//    self.loadingImage.center = self.arrowImage.center;
}


//-(void)changeToNight{
//    if ([KTJNightVersion currentStyle]==KTJNightVersionStyleNight) {
//        self.backgroundColor = [UIColor colorWithHex:0x222222];
//    }else{
//        self.backgroundColor = [UIColor colorWithHex:0xffffff];
//    }
//}
#pragma mark -- animation
- (void)animationLoading
{
    CABasicAnimation * bascicRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    bascicRotation.toValue = @(M_PI * 2);
    bascicRotation.duration = 1;
    bascicRotation.repeatCount = HUGE_VALF;
    bascicRotation.delegate = self;
    [self.arrowImage.layer addAnimation:bascicRotation forKey:@"transform.rotation"];
}

- (void)animationStop
{
    [self.arrowImage.layer removeAllAnimations];
}

#pragma mark - 公共方法
#pragma mark 设置状态
- (void)setState:(MJRefreshHeaderState)state
{
    if (self.state == state) return;
    
    // 旧状态
    MJRefreshHeaderState oldState = self.state;
    
    switch (state) {
        case MJRefreshHeaderStateIdle: {
            if (oldState == MJRefreshHeaderStateRefreshing) {
                self.arrowImage.transform = CGAffineTransformIdentity;
                
                [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                    self.activityView.alpha = 0.0;
                    self.loadingImage.alpha = 0.0;
                } completion:^(BOOL finished) {
                    self.arrowImage.alpha = 1.0;
                    self.activityView.alpha = 1.0;
                    [self.activityView stopAnimating];
//                    self.loadingImage.alpha = 0.0;
                    [self animationStop];
                }];
            } else {
                [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                    self.arrowImage.transform = CGAffineTransformIdentity;
                }];
            }
            break;
        }
            
        case MJRefreshHeaderStatePulling: {
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowImage.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            }];
            break;
        }
            
        case MJRefreshHeaderStateRefreshing: {
            [self.activityView startAnimating];
            [self animationLoading];
//            self.loadingImage.alpha = 1.0;
            self.arrowImage.alpha = 0.0;
            break;
        }
            
        default:
            break;
    }
    
    // super里面有回调，应该在最后面调用
    [super setState:state];
}

@end
