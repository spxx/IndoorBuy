//
//  HomePageView.h
//  BMW
//
//  Created by rr on 2016/12/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageM.h"
#import "HomeCell.h"
#import "HomePageTopView.h"
#import "ClassModel.h"
#import "GoodsListModel.h"


@class HomePageView;

@protocol HomePageDelegate <NSObject>

@optional

- (void)homePageViewRefreshAction;

- (void)homePageViewClickedScanerCodeAction;

- (void)homePageViewClickedSearchAction;

- (void)homePageViewClickedMessageAction;

/**
 *  点击分类
 *
 *  @param homePageView
 *  @param tag
 */
- (void)homePageView:(HomePageView *)homePageView clickedClassWithTag:(NSInteger)tag;


/**
 *  选中Banner
 *
 *  @param homePageView
 *  @param model
 */
- (void)homePageView:(HomePageView *)homePageView didSelectedItemWithBanner:(NSDictionary *)banner;

/**
 *  选中商品
 *
 *  @param homePageView
 *  @param model
 */
- (void)homePageView:(HomePageView *)homePageView didSelectedItemWithGoodsModel:(NSDictionary *)dataDic;

/**
 *  点击更多
 *
 *  @param homePageView
 *  @param classModel
 */
- (void)homePageView:(HomePageView *)homePageView clickedMoreWithClassModel:(NSDictionary *)classModel;

/**
 *  点击分享
 *
 *  @param homePageView
 *  @param classModel
 */
- (void)clickShare;

/**
 *  点击广告
 *
 *  @param homePageView
 *  @param classModel
 */
- (void)homePageView:(HomePageView *)homePageView clickedADPicWithADModel:(ADModel *)admodel;

/**
 快报

 @param homePageView
 @param admodel 
 */
- (void)homePageView:(HomePageView *)homePageView clickedADRollWithADModel:(ADModel *)adModel;
/**
 *进入店铺详情
 */
- (void)clickMyShop;
@end

@interface HomePageView : UIView


@property (nonatomic, strong) NSMutableArray * ADModels;

@property (nonatomic, strong) NSMutableArray * rollModels;

@property (nonatomic, strong) HomePageM *models;

@property (nonatomic, strong) UICollectionView *collectionView;


@property (nonatomic, assign) id<HomePageDelegate> delegate;

@property (nonatomic, assign) BOOL showRedPoint;

@property (nonatomic, copy) HomePageM * logoModel;   /**< logo相关 */


- (void)endRefresh;

/**
 暂停动画
 */
- (void)pauseAnimation;

/**
 开始动画
 */
- (void)startAnimation;
@end
