//
//  FirstView.h
//  BMW
//
//  Created by LiuP on 2016/12/6.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassCell.h"
#import "ClassItemCell.h"
#import "ClassHeaderView.h"

@class FirstView;

@protocol FirstViewDelegate <NSObject>

@optional

/**
 选中了一级分类

 @param firstView
 @param model 
 */
- (void)firstView:(FirstView *)firstView didSelectedFirstClass:(ClassModel *)model;

/**
 选择了二级分类/全部按钮

 @param firstView
 @param model
 */
- (void)firstView:(FirstView *)firstView didSelectedSecondClass:(ClassModel *)model;

/**
 选择了三级分类

 @param firstView
 @param model
 */
- (void)firstView:(FirstView *)firstView didSelectedThirdClass:(ClassModel *)model;

/**
 选择了banner

 @param firstView
 @param bannerModel 
 */
- (void)firstView:(FirstView *)firstView didSelectedBanner:(ClassModel *)bannerModel;

@end

@interface FirstView : UIView

@property (nonatomic, assign) id<FirstViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray * classModels; /**< 一级分类数据 */

@property (nonatomic, strong) NSMutableArray * itemModels;  /**< 二级分类数据 */

@property (nonatomic, retain) ClassModel * bannerModel;


/**
 是否显示加载指示器

 @param show
 */
- (void)itemIndicatorShow:(BOOL)show;

@end
