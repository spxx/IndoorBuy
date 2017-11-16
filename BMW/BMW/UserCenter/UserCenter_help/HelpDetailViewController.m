//
//  HelpDetailViewController.m
//  BMW
//
//  Created by 白琴 on 16/3/23.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "HelpDetailViewController.h"

@interface HelpDetailViewController ()

@end

@implementation HelpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助中心";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self navigation];
    [self getArticleDetailWithRequest];
}
#pragma mark -- 界面
/**
 *  基本界面
 */
- (void)initUserInterfaceWithString:(NSString *)string {
    UIView * backgroundView = [UIView new];
    backgroundView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 65);
    [backgroundView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    //正文
    UIWebView * contextWebView = [UIWebView new];
    contextWebView.backgroundColor = [UIColor whiteColor];
    contextWebView.opaque = NO;
    contextWebView.viewSize = CGSizeMake(backgroundView.viewWidth - 30 * W_ABCW, backgroundView.viewHeight - 15 * W_ABCW);
    [contextWebView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, 15 * W_ABCW)];
    //加载html代码
    CGFloat fontSize = 13;
    NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
                            "<head> \n"
                            "<style type=\"text/css\"> \n"
                            "body {font-size: %f;line-height:21px;}\n"
                            "</style> \n"
                            "</head> \n"
                            "<body>%@</body> \n"
                            "</html>", fontSize, string];
    [contextWebView loadHTMLString:htmlString baseURL:nil];
    contextWebView.scrollView.showsVerticalScrollIndicator = NO;
    contextWebView.scrollView.showsHorizontalScrollIndicator = NO;
    
    [backgroundView addSubview:contextWebView];
}

#pragma mark -- 网络请求
- (void)getArticleDetailWithRequest {
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"Article" parameters:@{@"id":self.articleID, @"type":self.articleType} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result == RequestResultSuccess) {
            [self initUserInterfaceWithString:object[@"data"][@"text"]];
        }
        else if (result == RequestResultEmptyData) {
            NSLog(@"没有数据");
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
