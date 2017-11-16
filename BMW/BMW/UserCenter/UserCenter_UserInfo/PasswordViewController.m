
//
//  PasswordViewController.m
//  BMW
//
//  Created by 白琴 on 16/3/15.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "PasswordViewController.h"
#import "UpdatePasswordViewController.h"
#import "FindPasswordViewController.h"

@interface PasswordViewController ()

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"密码修改";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self navigation];
    [self initUserInterface];
}
#pragma mark -- 界面
/**
 *  基本界面
 */
- (void)initUserInterface {
    NSArray * titleArray = @[@"登录密码修改", @"交易密码修改"];
    for (int i = 0; i < 2; i ++) {
        UIButton * iconButton = [UIButton new];
        iconButton.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [iconButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 10 + i * (iconButton.viewHeight + 1))];
        iconButton.backgroundColor = [UIColor whiteColor];
        iconButton.tag = 100000 + i;
        [iconButton addTarget:self action:@selector(processLoginPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:iconButton];
        UILabel * iconTitleLabel = [UILabel new];
        iconTitleLabel.viewSize = CGSizeMake(100, iconButton.viewHeight);
        [iconTitleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
        iconTitleLabel.text = titleArray[i];
        iconTitleLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        iconTitleLabel.font = fontForSize(13);
        [iconButton addSubview:iconTitleLabel];
        UIImageView * iconJianTouImageView = [UIImageView new];
        iconJianTouImageView.viewSize = CGSizeMake(6, 10);
        [iconJianTouImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, (iconButton.viewHeight - iconJianTouImageView.viewHeight) / 2)];
        iconJianTouImageView.image = [UIImage imageNamed:@"icon_xiaojiantou_gwc"];
        [iconButton addSubview:iconJianTouImageView];
        
        UIView * line = [UIView new];
        line.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [line align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 55 + i * 45)];
        line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [self.view addSubview:line];
    }
}

#pragma mark -- 点击事件
/**
 *  登录密码修改
 */
- (void)processLoginPasswordButton:(UIButton *)sender {
    NSLog(@"登录密码修改");
    switch (sender.tag) {
        case 100000:
        {
            UpdatePasswordViewController * updatePasswordVC = [[UpdatePasswordViewController alloc] init];
            [self.navigationController pushViewController:updatePasswordVC animated:YES];
            break;
        }
        case 100001:
        {
            FindPasswordViewController * updatePasswordVC = [[FindPasswordViewController alloc] init];
            updatePasswordVC.isPayPassword = YES;
            updatePasswordVC.isPayVC = NO;
            [self.navigationController pushViewController:updatePasswordVC animated:YES];
            break;
        }
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
