//
//  VIPMyInfoVC.m
//  BMW
//
//  Created by gukai on 16/3/22.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "VIPMyInfoVC.h"
#import "GotoVipViewController.h"
#import "UserInfoViewController.h"

@interface VIPMyInfoVC ()
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)UILabel * validityLabel;
@property(nonatomic,strong)UILabel * balanceLabel;
@property(nonatomic,strong)UILabel * myCardLabel;

@property(nonatomic,strong)UIView * validityView;
@property(nonatomic,strong)UIView * balanceView;
@property(nonatomic,strong)UIView * myCardView;
@end
@implementation VIPMyInfoVC
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initUserInterface];
    
}
/**
 *  关闭手势的原因：
 *  从购物车界面进入会员。支付成功之点击查看会员信息，然后返回需返回首页
 */
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

-(void)initUserInterface
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"麦咖会员";
    
    [self initScrollView];
    [self initValidity];
    [self initBalance];
    [self initMyCard];
    [self initBottomLabel];
    [self navigation];
    
}
-(void)initScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _scrollView.backgroundColor = [UIColor colorWithHex:0xf1f1ed];
    [self.view addSubview:_scrollView];
}
//有效期
-(void)initValidity
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 45)];
    view.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view];
    self.validityView = view;
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 68, view.viewHeight)];
    nameLabel.text = @"有效期：";
    nameLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    nameLabel.font = fontForSize(13);
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:nameLabel];
    
    
//    UIImageView * arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 6, view.viewHeight / 2 - 5, 6, 10)];
//    arrow.image = [UIImage imageNamed:@"icon_xiaojiantou_gwc.png"];
//    [view addSubview:arrow];
//    
//    
//    UILabel * continueLabel = [[UILabel alloc]initWithFrame:CGRectMake(arrow.viewX - 8 - 40, 0, 40, view.viewHeight)];
//    continueLabel.text = @"续费";
//    continueLabel.textColor = [UIColor colorWithHex:0x181818];
//    continueLabel.font = fontForSize(13);
//    continueLabel.textAlignment = NSTextAlignmentRight;
//    [view addSubview:continueLabel];
    
    
    UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.viewRightEdge + 10, 0, SCREEN_WIDTH - nameLabel.viewRightEdge - 15, view.viewHeight)];
    if ([_dataSourceDic[@"validitydate"] isKindOfClass:[NSNull class]]) {
        detailLabel.text = @"";
    }
    else {
        detailLabel.text = [NSString stringWithFormat:@"%@", _dataSourceDic[@"validitydate"]];
    }
    
    detailLabel.textAlignment= NSTextAlignmentLeft;
    detailLabel.textColor = [UIColor colorWithHex:0x181818];
    detailLabel.font = fontForSize(13);
    [view addSubview:detailLabel];
    self.validityLabel = detailLabel;
    
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, view.viewHeight - 0.5, view.viewWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [view addSubview:line];
    
//    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, view.viewWidth, view.viewHeight)];
//    [btn addTarget:self action:@selector(validityAction:) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:btn];
    
}
//账户余额
-(void)initBalance
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, self.validityView.viewBottomEdge, SCREEN_WIDTH, 45)];
    view.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view];
    self.balanceView = view;
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 68, view.viewHeight)];
    nameLabel.text = @"账户余额：";
    nameLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    nameLabel.font = fontForSize(13);
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:nameLabel];
    
    
    
    UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.viewRightEdge + 10, 0, self.validityLabel.viewWidth, view.viewHeight)];
    detailLabel.text = [NSString stringWithFormat:@"￥%@ (冻结中￥%@)", _dataSourceDic[@"available_predeposit"], _dataSourceDic[@"freeze_predeposit"]];
    detailLabel.textAlignment= NSTextAlignmentLeft;
    detailLabel.textColor = [UIColor colorWithHex:0x181818];
    detailLabel.font = fontForSize(13);
    [view addSubview:detailLabel];
    self.balanceLabel = detailLabel;
    
    
    
//    UIImageView * arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 6, view.viewHeight / 2 - 5, 6, 10)];
//    arrow.image = [UIImage imageNamed:@"icon_xiaojiantou_gwc.png"];
//    [view addSubview:arrow];
    
    
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, view.viewHeight - 0.5, view.viewWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [view addSubview:line];
    
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, view.viewWidth, view.viewHeight)];
    [btn addTarget:self action:@selector(balanceAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
}
//我的麦卡
-(void)initMyCard
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, self.balanceView.viewBottomEdge + 10, SCREEN_WIDTH, 45)];
    view.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:view];
    self.myCardView = view;
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 68, view.viewHeight)];
    nameLabel.text = @"我的麦咖：";
    nameLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    nameLabel.font = fontForSize(13);
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:nameLabel];
    
    
    
    UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.viewRightEdge + 10, 0, self.validityLabel.viewWidth, view.viewHeight)];
    if ([_dataSourceDic[@"member_card"] isKindOfClass:[NSNull class]]) {
        detailLabel.text = @"";
    }
    else {
        detailLabel.text = [NSString stringWithFormat:@"%@", _dataSourceDic[@"member_card"]];
    }
    detailLabel.textAlignment= NSTextAlignmentLeft;
    detailLabel.textColor = [UIColor colorWithHex:0x181818];
    detailLabel.font = fontForSize(13);
    [view addSubview:detailLabel];
    self.myCardLabel = detailLabel;
    
    
    
//    UIImageView * arrow = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 6, view.viewHeight / 2 - 5, 6, 10)];
//    arrow.image = [UIImage imageNamed:@"icon_xiaojiantou_gwc.png"];
//    [view addSubview:arrow];
    
    
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, view.viewHeight - 0.5, view.viewWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [view addSubview:line];
    
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, view.viewWidth, view.viewHeight)];
    [btn addTarget:self action:@selector(myCardAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    
}
-(void)initBottomLabel
{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, self.myCardView.viewBottomEdge + 12, SCREEN_WIDTH - 15 * 2, 12)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithHex:0x6f6f6f];
    label.font = fontForSize(12);
    label.text = @"温馨提示：新近金额将会从确认收货时间开始冻结7天";
    [_scrollView addSubview:label];
    
    [_scrollView  setContentSize:CGSizeMake(SCREEN_WIDTH, label.viewBottomEdge + 10)];
}
#pragma mark -- Action --
-(void)back
{
    if ([self.navigationController.viewControllers[1] isKindOfClass:[UserInfoViewController class]]) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
/**
 * 点击有效期[续费]
 */
-(void)validityAction:(UIButton *)sender
{
    GotoVipViewController * gotoVC = [[GotoVipViewController alloc] init];
    gotoVC.joinOrRegis = YES;
    gotoVC.isVIP = YES;
    gotoVC.endTime = _dataSourceDic[@"validitydate"];
    gotoVC.serviceTime = _dataSourceDic[@"ServerTime"];
    [self.navigationController pushViewController:gotoVC animated:YES];
}
/**
 * 点击账户余额
 */
-(void)balanceAction:(UIButton *)sender
{
}
/**
 * 点击我的麦卡
 */
-(void)myCardAction:(UIButton *)sender
{
}
@end
