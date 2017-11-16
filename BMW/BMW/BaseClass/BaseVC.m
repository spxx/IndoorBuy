//
//  BaseVC.m
//  成长轨迹
//
//  Created by Leo Tang on 15/2/9.
//  Copyright (c) 2015年 Leo Tang. All rights reserved.
//

#import "BaseVC.h"
#import <CoreLocation/CoreLocation.h>
#import "TYEncrypt.h"
#import "NotFoundView.h"
#import "IndicatorView.h"

@interface BaseVC ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *newsButton;
@property(nonatomic,strong)NotFoundView * notFound;
@property(nonatomic,strong)IndicatorView * indicatorView;

@end

@implementation BaseVC

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //**************方法一****************//
    //设置滑动回退
    __weak typeof(self) weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    //判断是否为第一个view
    if (self.navigationController && [self.navigationController.viewControllers count] == 1) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
#pragma mark - getter

- (MBProgressHUD *)HUD {
    
    if (!_HUD) {
        
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
//        _HUD.mode = MBProgressHUDModeAnnularDeterminate;
        _HUD.opacity = 0.5;
        _HUD.userInteractionEnabled = NO;
        [self.view addSubview:_HUD];
    }
    
    [self.view bringSubviewToFront:_HUD];
    return _HUD;
}

- (UIButton *)newsButton{
    if (!_networking) {
        _newsButton = [UIButton new];
        _newsButton.viewSize =CGSizeMake(22, 22);
        [_newsButton align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-20, 22)];
        [_newsButton setImage:[UIImage imageNamed:@"icon.xiaoxi_sy"] forState:UIControlStateNormal];
        [_newsButton addTarget:self action:@selector(goTonews) forControlEvents:UIControlEventTouchUpInside];
    }
    return _newsButton;
}

#pragma mark - Life cycle

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.viewDisappeared = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.viewDisappeared = YES;
}

- (void)dealloc
{
    NSLog(@"%@ - %@", self, NSStringFromSelector(_cmd));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.view setExclusiveTouch:YES];
    [self.view setExclusiveTouch:YES];
    

}

- (Reachability *)conn
{
    if (!_conn) {
        _conn = [Reachability reachabilityForInternetConnection];
    }
    return _conn;
}
#pragma mark -- 检测网络
- (void)checkConnection:(CheckConnection)checkResult
{
    // 1.检测wifi状态
    Reachability *wifi = [Reachability reachabilityForInternetConnection];
    
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    // 3.判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        NSLog(@"有wifi");
        checkResult(ConnectionTypeWifi);
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        NSLog(@"使用手机自带网络进行上网");
        checkResult(ConnectionTypeData);
    } else { // 没有网络
        NSLog(@"没有网络");
        checkResult(ConnectionTypeNone);
    }
}

- (RemindLoginView *)remindView
{
    if (!_remindView) {
        _remindView = [[RemindLoginView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) type:RemindTypeNoConnection];
        _remindView.hidden = YES;
        [self.view addSubview:_remindView];
    }
    return _remindView;
}


#pragma mark - private methods

/**
 *  定制导航栏样式
 */
- (void)customNavigationBar {
    
    // titleView
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    self.navigationItem.titleView = titleView;
}

/**
 *  导航栏
 */
- (void)navigation
{
    //导航栏分割线
    UIView * lineView = [UIView new];
    lineView.viewSize = CGSizeMake(SCREEN_WIDTH, 1);
    [lineView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
    lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self.view addSubview:lineView];
    [self.view bringSubviewToFront:lineView];
    //配置导航栏的左侧返回按钮
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"icon_fanhui_gdtj.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(15, 0, 10, 18);
    UIBarButtonItem * backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backBtnItem;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"4444");
//    [self.view endEditing:YES];
//}

- (void)keyboradHidden{
//    [_searText resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"66666");
    [self search:textField.text];
    [textField resignFirstResponder];
    return YES;
}
-(void)search:(NSString *)string{
    
}

- (void)newView:(UIButton *)sender{
//    NSLog(@"000");
}

/**
 *  还原导航栏样式
 */
- (void)resetNavigationBar {
    
    NSLog(@"%@ - %@", self, NSStringFromSelector(_cmd));
}
- (void)goTonews{
    
}
-(void)showNotFoundOnView:(UIView *)view frame:(CGRect)frame title:(NSString *)title
{
    [_notFound removeFromSuperview];
    _notFound = nil;
    _notFound = [[NotFoundView alloc]initWithFrame:frame andTitle:title];
    [view addSubview:_notFound];
    
}
-(void)hideNotFound
{
    [_notFound removeFromSuperview];
    _notFound = nil;
}
-(void)changeNotFoundStringColorWithRange:(NSRange)range
{
    return [_notFound changeStringColorWithRange:range];
}
#pragma mark -- 无网 --
-(void)showNoNetOnView:(UIView *)view frame:(CGRect)frame type:(NoNetType)type delegate:(id)delegate
{
    [_noNet removeFromSuperview];
    _noNet = nil;
    _noNet = [[NoNet alloc]initWithFrame:frame type:type delegate:delegate];
    [view addSubview:_noNet];
}
-(void)hideNoNet
{
    [_noNet removeFromSuperview];
    _noNet = nil;

}
#pragma mark -- 转指 --
-(void)showIndicatorOnView:(UIView *)view frame:(CGRect)frame
{
    [_indicatorView removeFromSuperview];
    _indicatorView = nil;
    _indicatorView = [[IndicatorView alloc]initWithFrame:frame];
    [view addSubview:_indicatorView];
    [_indicatorView.indicator startAnimating];
}
-(void)hideIndicator
{
    [_indicatorView.indicator stopAnimating];
    [_indicatorView removeFromSuperview];
    _indicatorView = nil;
}
@end

