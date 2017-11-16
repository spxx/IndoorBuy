//
//  WaitApplyViewController.m
//  BMW
//
//  Created by rr on 16/3/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "WaitApplyViewController.h"
#import "UserInfoViewController.h"
#import "GotoVipViewController.h"

@interface WaitApplyViewController ()

@end

@implementation WaitApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"加入会员";
    
    
    
    [self navigation];
    [self initUserinterface];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)back{
//
    if ([self.navigationController.viewControllers[3] isKindOfClass:[GotoVipViewController class]]) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }else{
        [self.navigationController  popViewControllerAnimated:YES];
    }
}

-(void)initUserinterface{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *indrouceL = [[UILabel alloc] initWithFrame:CGRectMake(56*W_ABCW, 87*W_ABCH, SCREEN_WIDTH-112*W_ABCW, 31)];
    indrouceL.text = @"申请成功，客服将尽快与您联系\n请保持电话畅通";
    indrouceL.textAlignment = NSTextAlignmentCenter;
    indrouceL.textColor = [UIColor colorWithHex:0x525151];
    indrouceL.font = fontForSize(13);
    indrouceL.numberOfLines = 0;
    [indrouceL sizeToFit];
    indrouceL.viewSize = CGSizeMake(SCREEN_WIDTH-112*W_ABCW, indrouceL.viewHeight);
    [self.view addSubview:indrouceL];
    
    UIButton  *submitOrderButton = [UIButton new];
    submitOrderButton.viewSize = CGSizeMake(SCREEN_WIDTH, 49);
    [submitOrderButton align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0,SCREEN_HEIGHT-64)];
    submitOrderButton.titleLabel.font = fontForSize(16);
    [submitOrderButton setTitle:@"确认" forState:UIControlStateNormal];
    [submitOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitOrderButton.backgroundColor = [UIColor colorWithHex:0xfd5487];
    [submitOrderButton addTarget:self action:@selector(orderClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitOrderButton];
}


-(void)orderClicked{
    NSLog(@"%@", self.navigationController.viewControllers);
//    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    if ([self.navigationController.viewControllers[1] isKindOfClass:[UserInfoViewController class]]) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


@end
