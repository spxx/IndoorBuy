//
//  ZhaoHangViewController.m
//  BMW
//
//  Created by rr on 16/10/25.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ZhaoHangViewController.h"
#import <cmbkeyboard/CMBWebKeyboard.h>
#import <cmbkeyboard/NSString+Additions.h>
#import "OrderSuccessViewController.h"


@interface ZhaoHangViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>
{
}
@property(nonatomic,strong)UIWebView *webView;
@end

@implementation ZhaoHangViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"招商银行一网通支付";
    [self navigation];
    [self initUserInterface];
    [self initData];
    
    if (self.rechager) {
        NSMutableArray * VCs = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
        [VCs removeObjectsInRange:NSMakeRange(VCs.count - 2, 1)];
        self.navigationController.viewControllers = [NSArray arrayWithArray:VCs];
    }
}

-(void)initUserInterface{
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_webView];
    _webView.delegate = self;
}
-(void)initData{
    NSURL *url = [NSURL URLWithString:YiwangtongURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod: @"POST"];
    NSString *json = [TYTools dataJsonWithDic:_dataDic];
    json = [TYTools JSONDataStringTranslation:json];
#pragma mark 特别注意
    //一网通调用参数之前必须去掉空格
    json = [json stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *body = [NSString stringWithFormat:@"jsonRequestData=%@",json];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self.webView loadRequest:request];
}
static BOOL FROM = FALSE;
- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    
    if ([request.URL.host isCaseInsensitiveEqualToString:@"cmbls"]) {
        CMBWebKeyboard *secKeyboard = [CMBWebKeyboard shareInstance];
        [secKeyboard showKeyboardWithRequest:request];
        secKeyboard.webView = _webView;
        UITapGestureRecognizer* myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        myTap.delegate = self;
        [self.view addGestureRecognizer:myTap]; //这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
        myTap.cancelsTouchesInView = NO;
        return NO;
    }
    if ([request.URL.host isCaseInsensitiveEqualToString:@"CMBNPRM"]) {
        if (_rechager) {
            [self.navigationController popViewControllerAnimated:YES];
            return NO;
        }else{
            OrderSuccessViewController * successVC = [[OrderSuccessViewController alloc] init];
            successVC.orderID = self.orderPaySn; // self.dataSourceDic[@"order_id"];
            [self.navigationController pushViewController:successVC animated:YES];
            return NO;
        }
    }
    if ([request.URL.host isCaseInsensitiveEqualToString:@"http://CMBNPRM-POP"]) {
        if([request.URL.absoluteString containsString:@"PayOK"]){
            NSMutableArray * VCs = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
            [VCs removeObjectsInRange:NSMakeRange(1, VCs.count-1)];
            self.navigationController.viewControllers = [NSArray arrayWithArray:VCs];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (FROM) {
        
        return;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [[CMBWebKeyboard shareInstance] hideKeyboard];
    
}

- (void)dealloc
{
    [[CMBWebKeyboard shareInstance] hideKeyboard];
    _webView.delegate = nil;
}





@end
