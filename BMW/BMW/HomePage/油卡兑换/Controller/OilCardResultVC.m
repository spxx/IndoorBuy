//
//  OilCardResultVC.m
//  BMW
//
//  Created by LiuP on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OilCardResultVC.h"

@interface OilCardResultVC ()

@end

@implementation OilCardResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUserInterface];
}

- (void)initUserInterface
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"支付完成";
    [self navigation];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = fontForSize(15);
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:COLOR_NAVIGATIONBAR_ITEM forState:UIControlStateNormal];
    [button addTarget:self action:@selector(finshAction:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    // 不显示自定义返回按钮
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = COLOR_NAVIGATIONBAR_BARTINT;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:COLOR_NAVIGATIONBARTEXTCOLOR}];
    
    [self initContentView];
}

- (void)initContentView
{
    CGFloat width = 25;
    UIImageView * remindImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    remindImage.image = [UIImage imageNamed:@"icon_tishi_zfcg.png"];
    [self.view addSubview:remindImage];
    
    UILabel * message = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
    message.font = fontForSize(22 * W_ABCW);
    message.text = @"订单支付成功";
    [message sizeToFit];
    [self.view addSubview:message];
    
    CGFloat totalWidth = width + message.viewWidth + 5;
    CGFloat originX = (self.view.viewWidth - totalWidth) / 2;
    remindImage.frame = CGRectMake(originX, 80 * W_ABCW, width, width);
    message.center = CGPointMake(remindImage.viewRightEdge + 5 + message.viewWidth / 2, remindImage.center.y);
    
    CGFloat btnW = 90 * W_ABCW;
    CGFloat btnH = 24 * W_ABCW;
    CGFloat btnOriginX = (self.view.viewWidth - btnW * 2 - 28 * W_ABCW) / 2;
    NSArray * items = @[@"充值记录", @"返回首页"];
    for (int i = 0; i < items.count; i ++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnOriginX + (28 * W_ABCW + btnW) * i, message.viewBottomEdge + 51 * W_ABCW, btnW, btnH);
        btn.layer.cornerRadius = btnH / 2;
        btn.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
        btn.clipsToBounds = YES;
        btn.titleLabel.font = fontForSize(15);
        btn.tag = 100 + i;
        [btn setTitle:items[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

#pragma mark -- actions
- (void)finshAction:(UIButton *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnAction:(UIButton *)sender
{
    if (sender.tag == 100) {  // 充值记录
        if ([self.delegate respondsToSelector:@selector(oilCardResultToRecord)]) {
            [self.delegate oilCardResultToRecord];
        }
    }else {  // 返回首页
        [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
        if ([self.delegate respondsToSelector:@selector(oilCardResultToHomePage)]) {
            [self.delegate oilCardResultToHomePage];
        }
    }
}
@end
