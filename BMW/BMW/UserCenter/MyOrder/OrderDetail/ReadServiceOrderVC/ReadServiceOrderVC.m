//
//  ReadServiceOrderVC.m
//  BMW
//
//  Created by gukai on 16/3/31.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ReadServiceOrderVC.h"
#import "OrderServiceView.h"
#import "ServicesProgressVC.h"
#import "CustomerserviceViewController.h"

@interface ReadServiceOrderVC ()<OrderServiceViewDelegate>

@end
@implementation ReadServiceOrderVC
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initLeftItem];
    [self initLine];
    [self initUserInterface];
}
-(void)initLeftItem
{
    //配置导航栏的左侧返回按钮
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"icon_fanhui_gdtj.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(15, 0, 10, 18);
    UIBarButtonItem * backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backBtnItem;
}
-(void)initLine
{
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self.view addSubview:line];
}
-(void)initUserInterface
{
    self.title = @"退换货订单";
    OrderServiceView  * orderServicView = [[OrderServiceView alloc]initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 0.5) withOrderId:self.orderId orderServiceType:OrderServiceInOrder];
    orderServicView.delegate = self;
    [self.view addSubview:orderServicView];
}
#pragma mark -- Action --
-(void)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)OrderServiceViewDidClickServiceOrderCell:(NSDictionary *)dataDic
{
    ServicesProgressVC * servicesProVC = [[ServicesProgressVC alloc]init];
    servicesProVC.serviceId = dataDic[@"id"];
    [self.navigationController pushViewController:servicesProVC animated:YES];
}

-(void)CustomerSerVice{
    CustomerserviceViewController *custommerVC = [[CustomerserviceViewController alloc] init];
    custommerVC.htmlUrl = SERVICE_URL;
    [self.navigationController pushViewController:custommerVC animated:YES];
}
@end
