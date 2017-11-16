//
//  HomePageTopView.h
//  DP
//
//  Created by LiuP on 16/7/22.
//  Copyright © 2016年 sp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADScrollView.h"
#import "ClassModel.h"
@class HomePageTopView;

@protocol HomePageTopViewDelegate <NSObject>

@optional
/**
 *  选择一般分类
 *
 *  @param homePageTopView
 *  @param classModel
 */
- (void)homePageTopView:(HomePageTopView *)homePageTopView clickedClassWithClassModel:(ClassModel *)classModel;
/**
 *  选择特惠上新/全部分类
 *
 *  @param homePageTopView
 *  @param tag             1:特惠上新  2:全部分类
 */
- (void)homePageTopView:(HomePageTopView *)homePageTopView clickedOtherClassWithTag:(NSInteger)tag;
/**
 *  点击广告图
 *
 *  @param homePageTopView
 *  @param adModel         
 */
- (void)homePageTopView:(HomePageTopView *)homePageTopView clickedADPicWithADModel:(ADModel *)adModel;

/**
 点击滚动广告

 @param homePageTopView
 @param adModel 
 */
- (void)homePageTopView:(HomePageTopView *)homePageTopView clickedRollADWithADModel:(ADModel *)adModel;

@end


@interface HomePageTopView : UIView

@property (nonatomic, assign) id<HomePageTopViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray<ADModel *> * ADModels;

@property (nonatomic, strong) NSMutableArray * rollModels;


/**
 暂停动画
 */
- (void)pauseAnimation;

/**
 开始动画
 */
- (void)startAnimation;
@end
