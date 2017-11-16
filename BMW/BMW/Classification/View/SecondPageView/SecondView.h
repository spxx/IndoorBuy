//
//  SecondView.h
//  BMW
//
//  Created by LiuP on 2016/12/6.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandCell.h"
#import "ClassModel.h"
@class SecondView;

@protocol SecondViewDelegate <NSObject>

@optional

/**
 点击了右侧下拉按钮

 @param secondView
 @param btn
 */
- (void)secondView:(SecondView *)secondView didSelectedDownBtn:(UIButton *)btn;

/**
 选择顶部分类

 @param secondView
 @param model
 */
- (void)secondView:(SecondView *)secondView didSelectedClassWithModel:(ClassModel *)model;

/**
 选择品牌

 @param secondView
 @param model 
 */
- (void)secondView:(SecondView *)secondView didSelectedBrandWithModel:(BrandModel *)model;

@end

@interface SecondView : UIView

@property (nonatomic, assign) id<SecondViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray * classModels; /**< 顶部分类 */

@property (nonatomic, strong) NSMutableArray * models;    /**< 品牌列表 */

@property (nonatomic, strong) NSMutableArray * indexs;      /**< 右侧字母列表 */

//刷新顶部分类
- (void)reloadBrandClassMenu;

/**
 是否显示加载指示器
 
 @param show
 */
- (void)indicatorShow:(BOOL)show;

@end
