//
//  ClassifyVIew.h
//  BMW
//
//  Created by LiuP on 2016/12/5.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstView.h"
#import "SecondView.h"

@class ClassifyView;

typedef enum{
    StatusClass,
    StatusBrand,
}Status;


@protocol ClassifyViewDelegate <NSObject>

@optional
/**
 选中了一级分类
 
 @param firstView
 @param model
 */
- (void)classView:(ClassifyView *)classView didSelectedFirstClass:(ClassModel *)model;

/**
 选中了二级分类
 
 @param firstView
 @param model
 */
- (void)classView:(ClassifyView *)classView didSelectedSecondClass:(ClassModel *)model;

/**
 选中了三级分类
 
 @param firstView
 @param model
 */
- (void)classView:(ClassifyView *)classView didSelectedThirdClass:(ClassModel *)model;

/**
 选择banner

 @param classView
 @param bannerModel
 */
- (void)classView:(ClassifyView *)classView didSelectedBanner:(ClassModel *)bannerModel;

/**
 选择品牌页面的分类

 @param classView
 @param model
 */
- (void)classView:(ClassifyView *)classView didSelectedBrandClassWithClass:(ClassModel *)model;

/**
 选择了品牌下拉菜单

 @param classView
 @param btn
 */
- (void)classView:(ClassifyView *)classView didSelectedDownBtn:(UIButton *)btn;

/**
 选择品牌

 @param classView
 @param model 
 */
- (void)classView:(ClassifyView *)classView didSelectedBrand:(BrandModel *)model;

/**
 滑动翻页

 @param classView
 @param status
 */
- (void)classView:(ClassifyView *)classView pageTurnWithStatus:(Status)status;
@end

@interface ClassifyView : UIView

@property (nonatomic, assign) id<ClassifyViewDelegate> delegate;
/************第一页相关数据*************/
@property (nonatomic, retain) NSMutableArray * classModels; /**< 一级分类 */
@property (nonatomic, strong) NSMutableArray * itemModels;   /**< 二三级分类 */
@property (nonatomic, retain) ClassModel * bannerModel;     
/************第二页相关数据*************/
@property (nonatomic, strong) NSMutableArray * brandClassModels;
@property (nonatomic, strong) NSMutableArray * brandModels; /**< 品牌列表 */
@property (nonatomic, strong) NSMutableArray * indexs;      /**< 右侧字母列表 */


/**
 翻页

 @param status 
 */
- (void)pageTurnWithStatus:(Status)status;

/**
 第一页的加载指示器

 @param show
 */
- (void)firstPageIndicatorShow:(BOOL)show;

/**
 第二页的加载指示器
 
 @param show
 */
- (void)secondPageIndicatorShow:(BOOL)show;
/**
 刷新品牌顶部分类
 */
- (void)reloadBrandClass;
@end
