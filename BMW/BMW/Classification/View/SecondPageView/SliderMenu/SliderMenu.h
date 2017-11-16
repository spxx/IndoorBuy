//
//  SliderMune.h
//  BMW
//
//  Created by gukai on 16/3/3.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SliderCell.h"
@class SliderMenu;

@protocol SliderMenuDelegate <NSObject>

@optional
/**
 点击了分类

 @param sliderMenu
 @param model
 */
- (void)sliderMenu:(SliderMenu *)sliderMenu didSelectedClassWithModel:(ClassModel *)model;

/**
 点击了右侧下拉按钮

 @param sliderMenu
 @param btn 
 */
- (void)sliderMenu:(SliderMenu *)sliderMenu didSelectedDownBtnWithBtn:(UIButton *)btn;

@end
@interface SliderMenu : UIView

@property (nonatomic, assign) id<SliderMenuDelegate> delegate;

@property (nonatomic, strong) NSMutableArray * classModels;

- (void)reloadBrandClass;

@end
