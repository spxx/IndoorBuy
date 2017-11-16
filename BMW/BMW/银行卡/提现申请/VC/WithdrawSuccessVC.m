//
//  WithdrawSuccessVC.m
//  BMW
//
//  Created by LiuP on 2016/12/23.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "WithdrawSuccessVC.h"
#import "IncomeViewController.h"

@interface WithdrawSuccessVC ()

@end

@implementation WithdrawSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUserInterface];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)initUserInterface
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"结果详情";
    [self navigation];
    
    // 不显示自定义返回按钮
    self.navigationItem.hidesBackButton = YES;
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
    message.font = fontForSize(17);
    message.text = @"提现申请已提交，等待财务处理";
    [message sizeToFit];
    [self.view addSubview:message];
    
    CGFloat totalWidth = width + message.viewWidth + 5;
    CGFloat originX = (self.view.viewWidth - totalWidth) / 2;
    remindImage.frame = CGRectMake(originX, 80 * W_ABCW, width, width);
    message.center = CGPointMake(remindImage.viewRightEdge + 5 + message.viewWidth / 2, remindImage.center.y);
    
    CGFloat btnW = 90 * W_ABCW;
    CGFloat btnH = 24 * W_ABCW;
    CGFloat btnOriginX = (self.view.viewWidth - btnW * 2 - 28 * W_ABCW) / 2;
    NSArray * items = @[@"返回首页", @"完成"];
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
- (void)btnAction:(UIButton *)sender
{
    if (sender.tag == 100) {  // 返回首页
        [self.navigationController popToRootViewControllerAnimated:NO];
        RootTabBarVC * rootVC = ROOTVIEWCONTROLLER;
        rootVC.selectedIndex = 0;
    }else {  // 完成
        for (UIViewController * vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[IncomeViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
}


@end
