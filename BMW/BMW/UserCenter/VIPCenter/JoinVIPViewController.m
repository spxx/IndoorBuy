//
//  VIPJoinViewController.m
//  BMW
//
//  Created by 白琴 on 16/5/9.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "JoinVIPViewController.h"
#import "VIPIntroductionsViewController.h"
#import "VIPChoosePayView.h"
#import "UserInfoViewController.h"
#import "OrderSuccessViewController.h"      //支付成功的界面

@interface JoinVIPViewController ()  {
    UIScrollView * _scrollView;
    UIButton * _agreeProtocolButton;
    UIButton * _payButton;
}

@property (nonatomic, strong)UIView * currentAccountView;           //当前账号
@property (nonatomic, strong)UIView * alertView;                    //提示
@property (nonatomic, strong)UIView * bottomView;                   //协议和支付按钮

@end

@implementation JoinVIPViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加入麦咖";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPayResult:) name:@"AliPayResult" object:nil];
    
    
    [self navigation];
    [self initUserInterface];
}

#pragma mark -- notification
- (void)aliPayResult:(NSNotification *)notification
{
    if ([notification.object[@"code"] isEqualToString:@"9000"]) {
        [self gotoSuccess];
    }
}


#pragma mark -- UI
-(void)initUserInterface
{
    _scrollView = [UIScrollView new];
    _scrollView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 65);
    [_scrollView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
    _scrollView.backgroundColor = [UIColor colorWithHex:0xf1f1ed];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    [_scrollView addSubview:self.currentAccountView];
    [_scrollView addSubview:self.alertView];
    [_scrollView addSubview:self.bottomView];
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _bottomView.viewBottomEdge);
}
/**
 *  当前账号和年费
 */
- (UIView *)currentAccountView
{
    if (!_currentAccountView) {
        NSArray * nameArray = @[@"当前账号：", @"麦咖年费："];
        NSArray * valueArray = @[[JCUserContext sharedManager].currentUserInfo.memberName, @"¥200.00"];
        _currentAccountView = [UIView new];
        _currentAccountView.viewSize = CGSizeMake(SCREEN_WIDTH, 45 * nameArray.count * W_ABCH);
        [_currentAccountView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 10 * W_ABCH)];
        _currentAccountView.backgroundColor = [UIColor whiteColor];

        for (int i = 0; i < nameArray.count; i ++) {
            UILabel * nameLabel = [UILabel new];
            nameLabel.viewSize = CGSizeMake(78 * W_ABCH, 45 * W_ABCH);
            nameLabel.font = fontForSize(13);
            nameLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
            nameLabel.text = nameArray[i];
            [nameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, i * nameLabel.viewHeight)];
            [_currentAccountView addSubview:nameLabel];
            
            UILabel * valueLabel = [UILabel new];
            valueLabel.viewSize = CGSizeMake(SCREEN_WIDTH - 93 * W_ABCH, 45 * W_ABCH);
            valueLabel.font = fontForSize(13);
            valueLabel.textColor = [UIColor colorWithHex:0x181818];
            if (i == 1) {
                valueLabel.textColor = [UIColor colorWithHex:0xfd5487];
            }
            valueLabel.text = valueArray[i];
            [valueLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(93 * W_ABCH, i * valueLabel.viewHeight)];
            [_currentAccountView addSubview:valueLabel];
            
            UIView * lineView = [UIView new];
            lineView.viewSize = CGSizeMake(SCREEN_WIDTH - 30 * W_ABCH, 0.5 * W_ABCH);
            [lineView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, valueLabel.viewBottomEdge - lineView.viewHeight)];
            lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
            [_currentAccountView addSubview:lineView];
        }
    }
    return _currentAccountView;
    
}
/**
 *  提示
 */
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [UIView new];
        _alertView.viewSize = CGSizeMake(SCREEN_WIDTH, 45 * W_ABCH);
        [_alertView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _currentAccountView.viewBottomEdge)];
        _alertView.backgroundColor = [UIColor whiteColor];
        
        UILabel * nameLabel = [UILabel new];
        nameLabel.viewSize = CGSizeMake(SCREEN_WIDTH - 30 * W_ABCH, 30);
        nameLabel.textColor = [UIColor colorWithHex:0x6f6f6f];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle};
        nameLabel.attributedText =[[NSAttributedString alloc] initWithString:@"开通麦咖会员后，在有效期内消费超过2000元，将免除次年年费。" attributes:attributes];
        nameLabel.numberOfLines = 0;
        [nameLabel sizeToFit];
        [nameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, (_alertView.viewHeight - nameLabel.viewHeight) / 2)];
        [_alertView addSubview:nameLabel];
        
        
        UIView * lineView = [UIView new];
        lineView.viewSize = CGSizeMake(SCREEN_WIDTH - 30 * W_ABCH, 0.5 * W_ABCH);
        [lineView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, _alertView.viewHeight - lineView.viewHeight)];
        lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_alertView addSubview:lineView];
    }
    return _alertView;
}
/**
 *  协议和支付按钮
 */
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.viewSize = CGSizeMake(SCREEN_WIDTH, 45 * W_ABCH);
        [_bottomView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _alertView.viewBottomEdge + 10 * W_ABCH)];
        
        _agreeProtocolButton = [UIButton new];
        _agreeProtocolButton.viewSize = CGSizeMake(17 * W_ABCH, 17 * W_ABCH);
        [_agreeProtocolButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, 0)];
        [_agreeProtocolButton setBackgroundImage:[UIImage imageNamed:@"icon_gouxuan_nor_zc"] forState:UIControlStateNormal];
        [_agreeProtocolButton setBackgroundImage:[UIImage imageNamed:@"icon_gouxuan_cli_zc"] forState:UIControlStateSelected];
        [_agreeProtocolButton addTarget:self action:@selector(agreeProtocolButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_agreeProtocolButton];
        _agreeProtocolButton.selected = YES;
        
        UILabel * alertLabel = [UILabel new];
        alertLabel.viewSize = CGSizeMake(100, 30);
        alertLabel.text = @"已经阅读并同意";
        alertLabel.font = fontForSize(11);
        alertLabel.textColor = [UIColor colorWithHex:0x6f6f6f];
        [alertLabel sizeToFit];
        [alertLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_agreeProtocolButton.viewRightEdge + 8, 3)];
        [_bottomView addSubview:alertLabel];
        //《帮麦网用户协议》按钮
        UILabel * alertLabel1 = [UILabel new];
        alertLabel1.viewSize = CGSizeMake(100, 30);
        alertLabel1.text = @"《麦咖服务用户协议》";
        alertLabel1.font = fontForSize(11);
        alertLabel1.textColor = [UIColor colorWithHex:0xfd5478];
        [alertLabel1 sizeToFit];
        [alertLabel1 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(alertLabel.viewRightEdge, 3)];
        [_bottomView addSubview:alertLabel1];
        //覆盖一个大的button
        UIButton * bigButton = [UIButton new];
        bigButton.viewSize = CGSizeMake(alertLabel.viewWidth + alertLabel1.viewWidth, 30);
        [bigButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_agreeProtocolButton.viewRightEdge + 10 * W_ABCH, 0)];
        [bigButton addTarget:self action:@selector(protocolButton) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:bigButton];
        
        _payButton = [UIButton new];
        _payButton.viewSize = CGSizeMake(SCREEN_WIDTH - 30 * W_ABCH, 45 * W_ABCH);
        [_payButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, _agreeProtocolButton.viewBottomEdge + 17 * W_ABCH)];
        [_payButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xcccccc] andSize:_payButton.viewSize] forState:UIControlStateNormal];
        [_payButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xfd5478] andSize:_payButton.viewSize] forState:UIControlStateSelected];
        [_payButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
        [_payButton setTitle:@"立即支付" forState:UIControlStateNormal];
        _payButton.userInteractionEnabled = YES;
        _payButton.selected = YES;
        [_payButton addTarget:self action:@selector(clickedPayButton) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_payButton];
        
        _bottomView.viewSize = CGSizeMake(SCREEN_WIDTH, _payButton.viewBottomEdge + 15 * W_ABCH);
    }
    return _bottomView;
}

#pragma mark -- 事件
/**
 *  同意协议按钮
 */
- (void)agreeProtocolButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    _payButton.selected = sender.selected;
    _payButton.userInteractionEnabled = _payButton.selected;
}
/**
 *  查看协议
 */
- (void)protocolButton {
    VIPIntroductionsViewController * vip = [[VIPIntroductionsViewController alloc] init];
    vip.isProtocol = YES;
    [self.navigationController pushViewController:vip animated:YES];
}
/**
 *  点击支付
 */
- (void)clickedPayButton {
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"BeVip" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result == RequestResultSuccess) {
            [self showChoosePayMethodWithPayOrder:object[@"data"]];
        }
        else if ([object[@"code"] integerValue] == 999) {
            SHOW_MSG(object[@"data"]);
        }
        else if ([object[@"code"] integerValue] == 901) {
            SHOW_MSG(object[@"message"]);
        }
        else {
            
        }
    }];
}
/**
 *  显示选择支付方式界面
 *
 *  @param payOrder 支付单号
 */
- (void)showChoosePayMethodWithPayOrder:(NSString *)payOrder {
    UIView * backgroundView = [UIView new];
    backgroundView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [backgroundView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    [self.view.window addSubview:backgroundView];
    
    VIPChoosePayView *testView = [[VIPChoosePayView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view.window addSubview:testView];
    
    [testView setButtonPress:^(NSInteger index) {
        switch (index) {
            case 0:
                NSLog(@"支付宝支付");
                [TYTools paymentWithGoodsDetail:@{@"order_sn":payOrder} isAlipay:YES NotifyURLType:PayNotifyURLIsVIPApply];
                break;
            case 1:
                NSLog(@"微信支付");
                //价格分为单位
                [BaseRequset sendPOSTRequestWithBMWApi2Method:@"BmVipGet" parameters:@{@"price":[NSString stringWithFormat:@"20000"],@"orderSn":payOrder} callBack:^(RequestResult result, id object) {
                    if (result == RequestResultSuccess) {
                        [TYTools paymentWithGoodsDetail:object[@"data"] isAlipay:NO NotifyURLType:PayNotifyURLIsVIPApply];
                    }
                }];
                break;
            default:
                break;
        }
    }];
    [UIView animateWithDuration:0.5 animations:^{
        backgroundView.alpha = 0.4;
        [testView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
    }];
    [testView setRemoveF:^(UIView * choosePayView) {
        [UIView animateWithDuration:0.5 animations:^{
            backgroundView.alpha = 0;
            [choosePayView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, SCREEN_HEIGHT)];
        } completion:^(BOOL finished) {
            [backgroundView removeFromSuperview];
            [choosePayView removeFromSuperview];
        }];
    }];
}

#pragma mark -- 通知【支付结果】
-(void)gotoSuccess{
//    //回到会员首页
//    NSLog(@"%@", self.navigationController.viewControllers);
    //    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
//    if ([self.navigationController.viewControllers[1] isKindOfClass:[UserInfoViewController class]]) {
//        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
//    }else{
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
    OrderSuccessViewController * successVC = [[OrderSuccessViewController alloc] init];
    successVC.isVipSuccess = YES;
    [self.navigationController pushViewController:successVC animated:YES];
}
/**
 *  微信支付的结果
 */
-(void)payResult:(NSNotification *)sender{
    if ([sender.object[@"code"] isEqualToString:@"0"]) {
        [BaseRequset sendPOSTRequestWithBMWApi2Method:@"VipInfo" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
            if (result == RequestResultSuccess) {
                NSDictionary *VIPInfoDic = [NSDictionary dictionaryWithDictionary:object[@"data"]];
                //更新保存下来的状态值
                if (![VIPInfoDic[@"status"] isKindOfClass:[NSNull class]]) {
                    [[JCUserContext sharedManager] upDateObject:VIPInfoDic[@"status"] forKey:@"status"];
                }
                else {
                    [[JCUserContext sharedManager] upDateObject:@"0" forKey:@"status"];
                }
            }
            else {
                
            }
        }];
//        if ([self.navigationController.viewControllers[1] isKindOfClass:[UserInfoViewController class]]) {
//            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
//        }else{
//            [self.navigationController popToRootViewControllerAnimated:YES];
//        }
        OrderSuccessViewController * successVC = [[OrderSuccessViewController alloc] init];
        successVC.isVipSuccess = YES;
        [self.navigationController pushViewController:successVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
