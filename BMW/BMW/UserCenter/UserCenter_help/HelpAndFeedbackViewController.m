//
//  HelpAndFeedbackViewController.m
//  BMW
//
//  Created by 白琴 on 16/3/23.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "HelpAndFeedbackViewController.h"
#import "FeedbackViewController.h"
#import "HelpCenterViewController.h"
#import "CustomerserviceViewController.h"

#define kTEL_NUMBER @"400-100-3923"


@interface HelpAndFeedbackViewController ()<UIAlertViewDelegate> {
    UILabel * _serviceTimeLabel;             //服务时间
}

@property (nonatomic, strong) UIView * serviceView;         //客服
@property (nonatomic, strong) UIView * helpView;            //帮助
@property (nonatomic, strong) UIView * feedbackView;        //反馈

@end

@implementation HelpAndFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助反馈";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    
    [self navigation];
    [self initUserInterface];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark -- 界面
- (void)initUserInterface {
    [self.view addSubview:self.serviceView];
    [self.view addSubview:self.helpView];
    [self.view addSubview:self.feedbackView];
}

- (UIView *)serviceView {
    if (!_serviceView) {
        _serviceView = [UIView new];
        _serviceView.viewSize = CGSizeMake(SCREEN_WIDTH, 45 * W_ABCW);
        [_serviceView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
        _serviceView.backgroundColor = [UIColor whiteColor];
        
        UIImageView * iconImageView = [UIImageView new];
        iconImageView.viewSize = CGSizeMake(18 * W_ABCW, 18 * W_ABCW);
        [iconImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, (_serviceView.viewHeight - iconImageView.viewHeight) / 2)];
        iconImageView.image = [UIImage imageNamed:@"icon_kefurexian_bzfk.png"];
        [_serviceView addSubview:iconImageView];
        
        UILabel * nameLabel = [UILabel new];
        nameLabel.viewSize = CGSizeMake(100, 30);
        nameLabel.font = fontForSize(13);
        nameLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        nameLabel.text = @"客服热线";
        [nameLabel sizeToFit];
        [nameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(iconImageView.viewRightEdge + 8 * W_ABCW, (_serviceView.viewHeight - nameLabel.viewHeight) / 2)];
        [_serviceView addSubview:nameLabel];
        
        UIImageView * arrowImageView = [UIImageView new];
        arrowImageView.viewSize = CGSizeMake(6 * W_ABCW, 10 * W_ABCW);
        [arrowImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15 * W_ABCW, (_serviceView.viewHeight - arrowImageView.viewHeight) / 2)];
        arrowImageView.image = [UIImage imageNamed:@"icon_xiaojiantou_gwc"];
        [_serviceView addSubview:arrowImageView];
        
        _serviceTimeLabel = [UILabel new];
        _serviceTimeLabel.viewSize = CGSizeMake(100, 30);
        _serviceTimeLabel.font = fontForSize(13);
        _serviceTimeLabel.textColor = [UIColor colorWithHex:0x181818];
        _serviceTimeLabel.text = kTEL_NUMBER;
        [_serviceTimeLabel sizeToFit];
        [_serviceTimeLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(arrowImageView.viewX - 8 * W_ABCW, (_serviceView.viewHeight - _serviceTimeLabel.viewHeight) / 2)];
        [_serviceView addSubview:_serviceTimeLabel];
        
        UIButton * clickedButton = [UIButton new];
        clickedButton.viewSize = _serviceView.viewSize;
        [clickedButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        [clickedButton addTarget:self action:@selector(clickedServiceButton) forControlEvents:UIControlEventTouchUpInside];
        [_serviceView addSubview:clickedButton];
        
        UIView * line = [UIView new];
        line.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5 * W_ABCW);
        [line align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _serviceView.viewBottomEdge)];
        line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_serviceView addSubview:line];
        
        _serviceView.viewSize = CGSizeMake(SCREEN_WIDTH, line.viewBottomEdge);
    }
    return _serviceView;
}

- (UIView *)helpView {
    if (!_helpView) {
        _helpView = [UIView new];
        _helpView.viewSize = CGSizeMake(SCREEN_WIDTH, 45 * W_ABCW);
        [_helpView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _serviceView.viewBottomEdge)];
        _helpView.backgroundColor = [UIColor whiteColor];
        
        UIImageView * iconImageView = [UIImageView new];
        iconImageView.viewSize = CGSizeMake(18 * W_ABCW, 18 * W_ABCW);
        [iconImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, (_helpView.viewHeight - iconImageView.viewHeight) / 2)];
        iconImageView.image = [UIImage imageNamed:@"icon_bangzhu_bzfk.png"];
        [_helpView addSubview:iconImageView];
        
        UILabel * nameLabel = [UILabel new];
        nameLabel.viewSize = CGSizeMake(100, 30);
        nameLabel.font = fontForSize(13);
        nameLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        nameLabel.text = @"帮助中心";
        [nameLabel sizeToFit];
        [nameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(iconImageView.viewRightEdge + 8 * W_ABCW, (_helpView.viewHeight - nameLabel.viewHeight) / 2)];
        [_helpView addSubview:nameLabel];
        
        UIImageView * arrowImageView = [UIImageView new];
        arrowImageView.viewSize = CGSizeMake(6 * W_ABCW, 10 * W_ABCW);
        [arrowImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15 * W_ABCW, (_helpView.viewHeight - arrowImageView.viewHeight) / 2)];
        arrowImageView.image = [UIImage imageNamed:@"icon_xiaojiantou_gwc"];
        [_helpView addSubview:arrowImageView];
        
        UIButton * clickedButton = [UIButton new];
        clickedButton.viewSize = _helpView.viewSize;
        [clickedButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        [clickedButton addTarget:self action:@selector(clickedHelpButton) forControlEvents:UIControlEventTouchUpInside];
        [_helpView addSubview:clickedButton];
        
        UIView * line = [UIView new];
        line.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5 * W_ABCW);
        [line align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _helpView.viewHeight)];
        line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_helpView addSubview:line];
    }
    return _helpView;
}

- (UIView *)feedbackView {
    if (!_feedbackView) {
        _feedbackView = [UIView new];
        _feedbackView.viewSize = CGSizeMake(SCREEN_WIDTH, 45 * W_ABCW);
        [_feedbackView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _helpView.viewBottomEdge + 10 * W_ABCW)];
        _feedbackView.backgroundColor = [UIColor whiteColor];
        
        UIImageView * iconImageView = [UIImageView new];
        iconImageView.viewSize = CGSizeMake(18 * W_ABCW, 18 * W_ABCW);
        [iconImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, (_feedbackView.viewHeight - iconImageView.viewHeight) / 2)];
        iconImageView.image = [UIImage imageNamed:@"icon_yijianfankui_bzfk.png"];
        [_feedbackView addSubview:iconImageView];
        
        UILabel * nameLabel = [UILabel new];
        nameLabel.viewSize = CGSizeMake(100, 30);
        nameLabel.font = fontForSize(13);
        nameLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        nameLabel.text = @"意见反馈";
        [nameLabel sizeToFit];
        [nameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(iconImageView.viewRightEdge + 8 * W_ABCW, (_feedbackView.viewHeight - nameLabel.viewHeight) / 2)];
        [_feedbackView addSubview:nameLabel];
        
        UIImageView * arrowImageView = [UIImageView new];
        arrowImageView.viewSize = CGSizeMake(6 * W_ABCW, 10 * W_ABCW);
        [arrowImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15 * W_ABCW, (_feedbackView.viewHeight - arrowImageView.viewHeight) / 2)];
        arrowImageView.image = [UIImage imageNamed:@"icon_xiaojiantou_gwc"];
        [_feedbackView addSubview:arrowImageView];
        
        UIView * line = [UIView new];
        line.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5 * W_ABCW);
        [line align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _feedbackView.viewHeight)];
        line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_feedbackView addSubview:line];
        
        UIButton * clickedButton = [UIButton new];
        clickedButton.viewSize = _feedbackView.viewSize;
        [clickedButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        [clickedButton addTarget:self action:@selector(clickedFeedbackButton) forControlEvents:UIControlEventTouchUpInside];
        [_feedbackView addSubview:clickedButton];

    }
    return _feedbackView;
}

#pragma mark -- 点击
/**
 *  点击客服
 */
- (void)clickedServiceButton {
    NSLog(@"客服");
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"拨号" message:kTEL_NUMBER delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertV show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", kTEL_NUMBER]]];
    }
}


/**
 *  点击帮助
 */
- (void)clickedHelpButton {
    NSLog(@"帮助");
    HelpCenterViewController * helpCenterVC = [[HelpCenterViewController alloc] init];
    [self.navigationController pushViewController:helpCenterVC animated:YES];
}
/**
 *  点击反馈
 */
- (void)clickedFeedbackButton {
    NSLog(@"反馈");
    if ([JCUserContext sharedManager].isUserLogedIn) {
        FeedbackViewController * feedbackVC = [[FeedbackViewController alloc] init];
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }else{
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
