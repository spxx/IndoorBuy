//
//  BaseVC.h
//  成长轨迹
//
//  Created by Leo Tang on 15/2/9.
//  Copyright (c) 2015年 Leo Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemindLoginView.h"
#import "NoNet.h"


typedef enum{
    ConnectionTypeNone,
    ConnectionTypeWifi,
    ConnectionTypeData,
}ConnectionType;

typedef void(^CheckConnection)(ConnectionType type);

@interface BaseVC : UIViewController

@property (nonatomic, retain) Reachability * conn;

// 控制
@property (nonatomic, assign) BOOL viewDisappeared;
@property (nonatomic, assign) BOOL networking;

// 菊花
@property (nonatomic, strong) MBProgressHUD *HUD;

@property (nonatomic, strong) RemindLoginView * remindView;

@property(nonatomic,strong)NoNet * noNet;

- (void)customNavigationBar; // 定制导航栏
- (void)resetNavigationBar;  // 取消导航栏定制

- (void)newView:(UIButton*)sender;
- (void)keyboradHidden;
//- (void)goTonews;
//- (void)search:(NSString *)string;

- (void)checkConnection:(CheckConnection)checkResult;


#pragma mark -- 找到或没找到 --

/**
 * show 没找到
 */
-(void)showNotFoundOnView:(UIView *)view frame:(CGRect)frame title:(NSString *)title;
/**
 * hidden 没找到
 */
-(void)hideNotFound;

/**
 * 改变某些字段的颜色
 */
-(void)changeNotFoundStringColorWithRange:(NSRange)range;

#pragma mark -- show 或 hidden 无网时的视图 --
/**
 * show 无网
 */
-(void)showNoNetOnView:(UIView *)view frame:(CGRect)frame type:(NoNetType)type delegate:(id)delegate;
/**
 * 隐藏无网
 */
-(void)hideNoNet;

#pragma mark -- Indicator --
-(void)showIndicatorOnView:(UIView *)view frame:(CGRect)frame;
-(void)hideIndicator;

- (void)navigation;

@end
