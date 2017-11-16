//
//  ADView.h
//  Custom
//
//  Created by LiuP on 2016/12/16.
//  Copyright © 2016年 LiuP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADModel.h"
@class ADView;

@protocol ADViewDelegate <NSObject>

@optional

/**
 点击滚动广告

 @param adView
 @param model 
 */
- (void)ADView:(ADView *)adView didSelectedADWithModel:(ADModel *)model;

@end

@interface ADView : UIView
@property (nonatomic, assign) id<ADViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray * models;


/**
 暂停动画
 */
- (void)pauseAnimation;

/**
 开始动画
 */
- (void)startAnimation;

@end
