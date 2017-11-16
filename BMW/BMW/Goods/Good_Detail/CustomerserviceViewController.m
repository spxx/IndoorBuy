//
//  CustomerserviceViewController.m
//  BMW
//
//  Created by rr on 16/3/29.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "CustomerserviceViewController.h"
#import "GoodsDetailViewController.h"
#import "HomePageMoreViewController.h"
#import <WebKit/WebKit.h>


@interface CustomerserviceViewController ()<UIWebViewDelegate, WKNavigationDelegate>
{
    NSURL *_url;
}

@property (nonatomic, strong) UIWebView * webView; /**<  */
@property (nonatomic, strong) WKWebView * wkWebView;
@end

@implementation CustomerserviceViewController
-(void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    //配置导航栏的左侧返回按钮
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"icon_fanhui_gdtj.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(15, 0, 10, 18);
    UIBarButtonItem * backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backBtnItem;
    [self initUserInterFace];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)initUserInterFace
{
    
    if (_htmlString && _htmlString.length < 3) {
        SHOW_EEROR_MSG(@"数据格式错误");
        return;
    }
    if (_url && _url.absoluteString.length < 3) {
        SHOW_EEROR_MSG(@"数据格式错误");
        return;
    }
}

#pragma mark -- getter
- (WKWebView *)wkWebView
{
    if (!_wkWebView) {
        WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc] init];
        config.suppressesIncrementalRendering = YES;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) configuration:config];
        _wkWebView.navigationDelegate = self;
        _wkWebView.multipleTouchEnabled = YES;
        _wkWebView.exclusiveTouch = YES;
        _wkWebView.contentMode = UIViewContentModeScaleToFill;
        _wkWebView.scrollView.userInteractionEnabled = YES;

        [self.view addSubview:_wkWebView];
    }
    return _wkWebView;
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _webView.delegate = self;
        _webView.contentMode = UIViewContentModeScaleToFill;
        _webView.scrollView.userInteractionEnabled = YES;
        [self.view addSubview:_webView];
    }
    return _webView;
}

#pragma mark -- action
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- setter
-(void)setHtmlUrl:(NSString *)htmlUrl{
    self.title = @"帮麦网";
    if (htmlUrl.length > 4) {
        if (![htmlUrl.lowercaseString hasPrefix:@"http"]) {
            htmlUrl = [NSString stringWithFormat:@"http://%@", htmlUrl];
        }
        _url = [[NSURL alloc] initWithString:htmlUrl];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:_url];
        [self.webView loadRequest:request];
    }
}

-(void)setHtmlString:(NSString *)htmlString{
    _htmlString = htmlString;
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

#pragma mark -- WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self.HUD show:YES];
    NSLog(@"%@",webView.URL.absoluteString);
    if ([webView.URL.host isEqualToString:INDOORBUY_WKWEB]) {
        [webView stopLoading];
        if ([webView.URL.path containsString:@"goods_id"]) {
            NSRange range = [webView.URL.path rangeOfString:@"goods_id"];
            NSString *goods_id = [[webView.URL.path substringFromIndex:range.location] substringWithRange:NSMakeRange(9, webView.URL.path.length-14-range.location)];
            GoodsDetailViewController *goodsVC = [[GoodsDetailViewController alloc] init];
            goodsVC.goodsId = goods_id;
            [self.navigationController pushViewController:goodsVC animated:YES];
            
        }else if([webView.URL.path containsString:@"gc_id"]){
            if ([webView.URL.path containsString:@"plat"]) {
                NSRange range = [webView.URL.path rangeOfString:@"gc_id"];
                NSString *gc_id = [[webView.URL.path substringFromIndex:range.location] substringWithRange:NSMakeRange(6, webView.URL.path.length-11-range.location)];
                HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
                homePageMoreVC.homePageMoreVCType = HomePageMoreVCShopCar;
                homePageMoreVC.brandName = @"商品";
                homePageMoreVC.goods_platform_only = gc_id;
                homePageMoreVC.ID = homePageMoreVC.goods_platform_only;
                [self.navigationController pushViewController:homePageMoreVC animated:YES];
                
            }else if ([webView.URL.path containsString:@"brand"]){
                NSRange range = [webView.URL.path rangeOfString:@"gc_id"];
                NSString *brand_id = [[webView.URL.path substringFromIndex:range.location] substringWithRange:NSMakeRange(6, webView.URL.path.length-11-range.location)];
                NSRange classRange = [webView.URL.path rangeOfString:@"brand"];
                NSString *classID = [[webView.URL.path substringToIndex:range.location] substringWithRange:NSMakeRange(classRange.location+6, range.location-classRange.location-7)];
                
                HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
                homePageMoreVC.homePageMoreVCType = HomePageMoreVCMoreBrand;
                homePageMoreVC.brandName = @"商品";
                homePageMoreVC.ID = brand_id;
                homePageMoreVC.brandClassId = classID;
                homePageMoreVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:homePageMoreVC animated:YES];
            }else if ([webView.URL.path containsString:@"class"]) {
                NSRange range = [webView.URL.path rangeOfString:@"gc_id"];
                NSString *gc_id = [[webView.URL.path substringFromIndex:range.location] substringWithRange:NSMakeRange(6, webView.URL.path.length-11-range.location)];
                NSDictionary *dataSource = @{@"gc_id":gc_id,@"gc_name":@"商品"};
                HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
                homePageMoreVC.dataDIc = dataSource;
                homePageMoreVC.noThirdClass = YES;
                homePageMoreVC.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:homePageMoreVC animated:YES];
            }
        }
    }
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.HUD hide:YES];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self.HUD hide:YES];
    NSLog(@"html11 = %@", error);
    if (error.code == -1005) {
        if (_url) {
            NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:_url];
            [webView loadRequest:request];
        }
    }else if (error.code == -999) {
        NSLog(@"取消加载");
    }else {
        SHOW_EEROR_MSG(@"网络链接中断，请重试");
        [self.navigationController popViewControllerAnimated:YES];
    }
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [self.HUD hide:YES];
    NSLog(@"html22 = %@", error);
    if (error.code == -1005) {
        if (_url) {
            NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:_url];
            [webView loadRequest:request];
        }
    }else if (error.code == -999) {
        NSLog(@"取消加载");
    }else {
        SHOW_EEROR_MSG(@"网络链接中断，请重试");
        [self.navigationController popViewControllerAnimated:YES];
    }
}


/********** 未使用 ***********/
#pragma mark -- UIWebViewDelegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"---%@---%@",error.description,_url);
    if (error.code == -1005) {
        if (_url) {
            [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
        }
    }
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.HUD show:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"finish");
    [self.HUD hide:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([request.URL.host isEqualToString:INDOORBUY_WKWEB]) {
        if ([request.URL.path containsString:@"goods_id"]) {
            NSRange range = [request.URL.path rangeOfString:@"goods_id"];
            NSString *goods_id = [[request.URL.path substringFromIndex:range.location] substringWithRange:NSMakeRange(9, request.URL.path.length-14-range.location)];
            GoodsDetailViewController *goodsVC = [[GoodsDetailViewController alloc] init];
            goodsVC.goodsId = goods_id;
            [self.navigationController pushViewController:goodsVC animated:YES];
            
        }else if([request.URL.path containsString:@"gc_id"]){
            if ([request.URL.path containsString:@"plat"]) {
                NSRange range = [request.URL.path rangeOfString:@"gc_id"];
                NSString *gc_id = [[request.URL.path substringFromIndex:range.location] substringWithRange:NSMakeRange(6, request.URL.path.length-11-range.location)];
                HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
                homePageMoreVC.homePageMoreVCType = HomePageMoreVCShopCar;
                homePageMoreVC.brandName = @"商品";
                homePageMoreVC.goods_platform_only = gc_id;
                homePageMoreVC.ID = homePageMoreVC.goods_platform_only;
                [self.navigationController pushViewController:homePageMoreVC animated:YES];
                
            }else if ([request.URL.path containsString:@"brand"]){
                NSRange range = [request.URL.path rangeOfString:@"gc_id"];
                NSString *brand_id = [[request.URL.path substringFromIndex:range.location] substringWithRange:NSMakeRange(6, request.URL.path.length-11-range.location)];
                NSRange classRange = [request.URL.path rangeOfString:@"brand"];
                NSString *classID = [[request.URL.path substringToIndex:range.location] substringWithRange:NSMakeRange(classRange.location+6, range.location-classRange.location-7)];
                
                HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
                homePageMoreVC.homePageMoreVCType = HomePageMoreVCMoreBrand;
                homePageMoreVC.brandName = @"商品";
                homePageMoreVC.ID = brand_id;
                homePageMoreVC.brandClassId = classID;
                homePageMoreVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:homePageMoreVC animated:YES];
            }else if ([request.URL.path containsString:@"class"]) {
                NSRange range = [request.URL.path rangeOfString:@"gc_id"];
                NSString *gc_id = [[request.URL.path substringFromIndex:range.location] substringWithRange:NSMakeRange(6, request.URL.path.length-11-range.location)];
                NSDictionary *dataSource = @{@"gc_id":gc_id,@"gc_name":@"商品"};
                HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
                homePageMoreVC.dataDIc = dataSource;
                homePageMoreVC.noThirdClass = YES;
                homePageMoreVC.navigationItem.hidesBackButton = YES;
                [self.navigationController pushViewController:homePageMoreVC animated:YES];
            }
        }
        return NO;
    }
    return YES;
}


@end

