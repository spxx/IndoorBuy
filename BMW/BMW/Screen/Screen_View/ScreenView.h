//
//  ScreenView.h
//  BMW
//
//  Created by gukai on 16/3/2.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenModle.h"

typedef enum {
    ScreenViewDefault,
    ScreenViewNoBrand,
    ScreenViewNoThirdClass,
}ScreenViewType;

@class ScreenView;

@protocol ScreenViewDelegate <NSObject>
@optional
/**
 * 触发screenView的点击的手势
 */
-(void)screenView:(ScreenView *)view touchTapGesture:(UIGestureRecognizer *)gesture;
/**
 * 触发screenView的滑动的手势
 */
-(void)screenView:(ScreenView *)view touchSwipeGesture:(UIGestureRecognizer *)gesture;
/**
 * 点击的了确认
 */
-(void)screenView:(ScreenView *)view clickSureBtn:(UIButton *)sender;
@end


@interface ScreenView : UIView
/**
 * 分类ID
 */
@property(nonatomic,copy)NSString * classId;

/**
 * 标签选项ID
 */
@property(nonatomic,copy)NSString * goods_platform_only;

/**
 * screenModle 记录筛选的条件
 */
@property(nonatomic,strong)ScreenModle * screenModle;
/**
 * 代理
 */
@property(nonatomic,assign)id<ScreenViewDelegate> delegate;

@property(nonatomic,assign)ScreenViewType  screenViewType;

-(instancetype)initWithFrame:(CGRect)frame classId:(NSString *)classId screenModle:(ScreenModle *)modle;

-(instancetype)initWithFrame:(CGRect)frame classId:(NSString *)classId screenModle:(ScreenModle *)modle andScreenType:(ScreenViewType)type;

-(instancetype)initWithFrame:(CGRect)frame goods_platform_only:(NSString *)goods_platform_only screenModle:(ScreenModle *)modle andScreenType:(ScreenViewType)type;

/**
 * 展现筛选视图
 */
-(void)showScreenViewOnSuperView:(UIView *)view;
/**
 * 隐藏筛选视图
 */
-(void)hiddenScreenView;
@end
