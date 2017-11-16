//
//  ChoosePayWayViewController.m
//  BMW
//
//  Created by 白琴 on 16/3/17.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ChoosePayWayViewController.h"
#import "OrderSuccessViewController.h"
#import "RemapayMentView.h"
#import "FindPasswordViewController.h"
#import "RootTabBarVC.h"

#import "APay.h"
#import "PaaCreater.h"
#import "ChoosePayWayView.h"

#import "ZhaoHangViewController.h"

@interface ChoosePayWayViewController ()<APayDelegate> {
    UIScrollView * _scrollView;
    
    //支付方式
    UILabel * _payWayLabel;                             //支付方式显示
    BOOL _isPayWay;                                     //是否选择支付方式
    UIButton * _lastPayWayButton;                       //上一次选择的支付方式
    
    UIButton * _payButton;                             //确认支付按钮
    
//    NSInteger _Paytag;
    NSArray * _payWayArray;
    NSInteger _index;                           //支付方式
}

/**
 *  支付方式
 */
@property (nonatomic, strong)ChoosePayWayView * payWayView;
/**
 *  支付金额
 */
@property (nonatomic, strong)UIView * amountView;


@end

@implementation ChoosePayWayViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付方式";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPayResult:) name:@"AliPayResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"changePayPassword" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResult:) name:@"WXPayResult" object:nil];
    
    [self navigation];
    [self initData];
    [self initUserInterface];
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

#pragma mark -- notification
- (void)aliPayResult:(NSNotification *)notification
{
    if ([notification.object[@"code"] isEqualToString:@"9000"]) {
        [self gotoSuccess];
    }
}

-(void)payResult:(NSNotification *)sender{
    NSLog(@"%@",sender);
    if ([sender.object[@"code"] isEqualToString:@"0"]) {
        [self gotoSuccess];
    }
}

- (void)initData {
    _isPayWay = NO;
}

#pragma mark -- 界面
- (void)initUserInterface {
    _scrollView = [UIScrollView new];
    _scrollView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 65 - 47 * W_ABCH);
    [_scrollView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
    _scrollView.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self.view addSubview:_scrollView];
    
    //下单时间和订单号
    UIView * whiteView = [UIView new];
    whiteView.viewSize = CGSizeMake(SCREEN_WIDTH, 64 * W_ABCH);
    [whiteView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:whiteView];
    
    UILabel * orderSNLabel = [UILabel new];
    orderSNLabel.viewSize = CGSizeMake(100 * W_ABCH, 20 * W_ABCH);
    orderSNLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    orderSNLabel.font = fontForSize(12);
    orderSNLabel.text = [NSString stringWithFormat:@"订单编号:  %@", self.dataSourceDic[@"order_sn"]];
    [orderSNLabel sizeToFit];
    [orderSNLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, 15 * W_ABCH)];
    [whiteView addSubview:orderSNLabel];
    
    UILabel * orderAddTimeLabel = [UILabel new];
    orderAddTimeLabel.viewSize = CGSizeMake(100 * W_ABCH, 20 * W_ABCH);
    orderAddTimeLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    orderAddTimeLabel.font = fontForSize(11);
    orderAddTimeLabel.text = [NSString stringWithFormat:@"下单时间:  %@", [TYTools getTimeToShowWithTimestamp:self.dataSourceDic[@"add_time"]]];
    [orderAddTimeLabel sizeToFit];
    [orderAddTimeLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, orderSNLabel.viewBottomEdge + 10 * W_ABCH)];
    [whiteView addSubview:orderAddTimeLabel];
    
    UIView * lineView = [UIView new];
    lineView.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5 * W_ABCH);
    [lineView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, whiteView.viewHeight)];
    lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [whiteView addSubview:lineView];
    
    
    [_scrollView addSubview:self.payWayView];
    [_scrollView addSubview:self.amountView];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _amountView.viewBottomEdge);
    
    //按钮
    _payButton = [UIButton new];
    _payButton.viewSize = CGSizeMake(SCREEN_WIDTH, 47 * W_ABCH);
    [_payButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _scrollView.viewBottomEdge)];
    [_payButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xfd5478] andSize:_payButton.viewSize] forState:UIControlStateNormal];
    [_payButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    [_payButton setTitle:[NSString stringWithFormat:@"确认支付%.2f元", [self.dataSourceDic[@"order_amount"] floatValue]] forState:UIControlStateNormal];
    _payButton.titleLabel.font = fontForSize(16);
    [_payButton addTarget:self action:@selector(clickedPayButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_payButton];
    
}

/**
 *  支付方式
 */
- (ChoosePayWayView *)payWayView {
    if (!_payWayView) {
        NSArray * payWayImageArray;
        if (self.isOnePayWay) {
            _payWayArray = @[@"通联支付"];
            payWayImageArray = @[@"icon_tonglian_zffs"];
        }
        else {
//            @"一网通银行卡支付",@"icon_yiwangtong_gwcjs.png"
            _payWayArray = @[@"支付宝支付", @"微信支付",@"一网通银行卡支付",@"余额支付"];
            payWayImageArray = @[@"icon_zhifubao_zffs.png", @"icon_weixin_zffs.png",@"icon_yiwangtong_gwcjs.png",@"icon_yuezhifu_gwc.png"];
        }
        _payWayView = [[ChoosePayWayView alloc] initWithFrame:CGRectMake(0, 74 * W_ABCH, SCREEN_WIDTH, 45 * W_ABCH + 45 * W_ABCH * _payWayArray.count) payWayArray:_payWayArray payWayImageArray:payWayImageArray isNeedTitle:YES];
        _payWayView.backgroundColor = [UIColor redColor];
        [_payWayView setButtonPress:^(NSInteger index) {
            _index = index;
            _isPayWay = YES;
        }];
    }
    return _payWayView;
}
- (UIView *)amountView {
    if (!_amountView) {
        _amountView = [UIView new];
        _amountView.viewSize = CGSizeMake(SCREEN_WIDTH, 45 * W_ABCH);
        [_amountView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _payWayView.viewBottomEdge + 10 * W_ABCH)];
        _amountView.backgroundColor = [UIColor whiteColor];
        
        UILabel * titleLabel = [UILabel new];
        titleLabel.viewSize = CGSizeMake(100 * W_ABCH, 45 * W_ABCH);
        titleLabel.text = @"实际金额";
        titleLabel.font = fontForSize(13);
        titleLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        [titleLabel sizeToFit];
        [titleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, (45 * W_ABCH - titleLabel.viewHeight) / 2)];
        [_amountView addSubview:titleLabel];
        
        UILabel * amountLabel = [UILabel new];
        amountLabel.viewSize = CGSizeMake(100 * W_ABCH, 45 * W_ABCH);
        amountLabel.font = fontForSize(13);
        amountLabel.textColor = [UIColor colorWithHex:0xfd5487];
        amountLabel.text = [NSString stringWithFormat:@"¥%.2f", [self.dataSourceDic[@"order_amount"] floatValue]];
        [amountLabel sizeToFit];
        [amountLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15 * W_ABCH, (45 * W_ABCH - amountLabel.viewHeight) / 2)];
        [_amountView addSubview:amountLabel];
    }
    return _amountView;
}

#pragma mark -- 点击事件
/**
 *  点击支付
 */
- (void)clickedPayButton {
    if (!_isPayWay) {
        SHOW_MSG(@"请选择支付方式");
        return;
    }else{
        switch (_index) {
            case 0: {
                if (self.isOnePayWay) {
                    NSLog(@"点击通联支付");
                    //@"1"
                    NSString *payData = [PaaCreater randomPaaWithgoodsName:_dataSourceDic[@"pay_sn"] amount:                    [NSString stringWithFormat:@"%.0f",[_dataSourceDic[@"order_amount"] floatValue]*100]];
                    //@param mode
                    //00 生产环境
                    //01 测试环境
                    //在测试与生产环境之间切换的时候请注意修改mode参数
                    [APay startPay:payData viewController:self delegate:self mode:@"00"];
                }
                else {
                    [TYTools paymentWithGoodsDetail:self.dataSourceDic isAlipay:YES NotifyURLType:PayNotifyURLIsDefault];
                }
                
                break;
            }
            case 1:
                NSLog(@"微信支付");
            {
                [self.HUD show:YES];
                [BaseRequset sendPOSTRequestWithBMWApi2Method:@"WxOrderPay" parameters:@{@"price":[NSString stringWithFormat:@"%.2f",[_dataSourceDic[@"order_amount"] floatValue]],@"orderSn":self.dataSourceDic[@"pay_sn"]} callBack:^(RequestResult result, id object) {
                    [self.HUD hide:YES];
                    if (result == RequestResultSuccess) {
                        [TYTools paymentWithGoodsDetail:object[@"data"] isAlipay:NO NotifyURLType:PayNotifyURLIsDefault];
                    }
                }];
            }
                break;
            case 2:{
                NSLog(@"一网通银行卡支付");
                [self getZhaohang];
            }
                break;
            case 3:{
                NSLog(@"余额支付");
                [self getMemberMoney];
            }
            default:
                break;
        }
    }
}

-(void)getZhaohang{
    NSDate *data = [NSDate date];
    NSDateFormatter *df1 = [[NSDateFormatter alloc]init];//格式化
    
    [df1 setDateFormat:@"yyyyMMddHHmmss"];
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc]init];//格式化
    
    [df2 setDateFormat:@"yyyyMMdd"];

    
    NSString* s1 = [df1 stringFromDate:data];
    NSString* s2 = [df2 stringFromDate:data];

    NSDictionary *dataDic = @{@"agrNo":@"12345",
                              @"amount":[NSString stringWithFormat:@"%.2f",[_dataSourceDic[@"order_amount"] floatValue]],
                              @"branchNo":@"0028",
                              @"cardType":@"",
                              @"clientIP":@"",
                              @"date":s2,
                              @"dateTime":s1,
                              @"expireTimeSpan":@"30",
                              @"lat":@"",
                              @"lon":@"",
                              @"merchantNo":YiwangtongNo,//000275,
                              @"merchantSerialNo":@"",
                              @"mobile":@"",
                              @"orderNo":self.dataSourceDic[@"order_sn"],
                              @"payNoticePara":@"",
                              @"payNoticeUrl":YiwangtongPay,
                              @"returnUrl":@"http://CMBNPRM",
                              @"riskLevel":@"",
                              @"signNoticePara":@"",
                              @"signNoticeUrl":YiwangtongSign,
                              @"userID":[JCUserContext sharedManager].currentUserInfo.memberID};
    NSString *json = [TYTools dataJsonWithDic:dataDic];
    json = [TYTools JSONDataStringTranslation:json];
    
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"PwdPay" parameters:@{@"signdata":json} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            [self loadWebView:object[@"data"] andTimeDate:s2 andTime:s1];
            NSLog(@"%@",object);
        }else{
            SHOW_EEROR_MSG(object);
            NSLog(@"%@",object);
        }
    }];
}


-(void)loadWebView:(NSDictionary *)member andTimeDate:(NSString *)timedate andTime:(NSString *)time{
    NSDictionary *requdata =   @{@"agrNo":member[@"agrNo"],
                                 @"amount":[NSString stringWithFormat:@"%.2f",[_dataSourceDic[@"order_amount"] floatValue]],
                                 @"branchNo":@"0028",
                                 @"cardType":@"",
                                 @"clientIP":@"",
                                 @"date":timedate,
                                 @"dateTime":time,
                                 @"expireTimeSpan":@"30",
                                 @"lat":@"",
                                 @"lon":@"",
                                 @"merchantNo":YiwangtongNo,//000275,
                                 @"merchantSerialNo":member[@"merchantSerialNo"],
                                 @"mobile":@"",
                                 @"orderNo":member[@"orderNo"],
                                 @"payNoticePara":@"",
                                 @"payNoticeUrl":YiwangtongPay,
                                 @"returnUrl":@"http://CMBNPRM",
                                 @"riskLevel":@"",
                                 @"signNoticePara":@"",
                                 @"signNoticeUrl":YiwangtongSign,
                                 @"userID":[JCUserContext sharedManager].currentUserInfo.memberID};
    NSDictionary *dataDic =@{@"version":@"1.0",@"charset":@"UTF-8",@"sign":member[@"sign"],@"signType":@"SHA-256",@"reqData":requdata};
    ZhaoHangViewController *zhaoHanVC = [[ZhaoHangViewController alloc] init];
    zhaoHanVC.orderPaySn = self.dataSourceDic[@"pay_sn"];
    zhaoHanVC.dataDic = dataDic;
    [self.navigationController pushViewController:zhaoHanVC animated:YES];
}


/**
 * 返回
 */
-(void)back
{
    if (self.isPopRootVC) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- 网络请求
/**
 *  获取用户余额
 */
- (void)getMemberMoney {
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetMemberMoney" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result == RequestResultSuccess) {
            double drpMoney = 0;
            double userMoney = 0;
            if ([object[@"data"][@"drpMoney"] isKindOfClass:[NSNull class]]) {
                drpMoney= 0.00;
            }
            else {
                drpMoney = [object[@"data"][@"drpMoney"] doubleValue];
            }
            if ([object[@"data"][@"userMoney"] isKindOfClass:[NSNull class]]) {
                userMoney= 0.00;
            }
            else {
                userMoney = [object[@"data"][@"userMoney"] doubleValue];
            }
            [self remapayMentWithUserMoney:drpMoney+userMoney];
        }
        else {
            SHOW_EEROR_MSG(@"获取用户余额失败");
        }
    }];
}

#pragma mark -- 其他
/**
 *  余额支付
 */
- (void)remapayMentWithUserMoney:(CGFloat)userMoney {
//    RootTabBarVC * rootVC = (RootTabBarVC *)ROOTVIEWCONTROLLER;
//
//    UIView * backgroundView = [UIView new];
//    backgroundView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
//    [backgroundView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
//    backgroundView.backgroundColor = [UIColor blackColor];
//    backgroundView.alpha = 0;
//    [rootVC.view addSubview:backgroundView];
    
    RemapayMentView * remapayment = [[RemapayMentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) Withmoney:userMoney AndOrderM:[self.dataSourceDic[@"order_amount"] floatValue]];
    [self.view.window addSubview:remapayment];
    
//    [UIView animateWithDuration:0.3 animations:^{
//        backgroundView.alpha = 0.4;
//        [remapayment align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
//    }];
    [remapayment setFinishPay:^(NSString * password) {
        //密码输入完成
        [BaseRequset sendPOSTRequestWithBMWApi2Method:@"MemberPay" parameters:@{@"paySn":self.dataSourceDic[@"pay_sn"],@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"pass":password} callBack:^(RequestResult result, id object) {
            if (result == RequestResultSuccess) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPayResult" object:nil];
            }
            else if (result == RequestResultFailed) {
                SHOW_EEROR_MSG(@"网络错误，请重试");
            }
            else if ([object[@"code"] integerValue] == 913){
                SHOW_EEROR_MSG(object[@"message"]);
            }
            else if ([object[@"code"] integerValue] == 904){
                //密码错误
                SHOW_EEROR_MSG(object[@"message"]);
            }
            else if ([object[@"code"] integerValue] == 999){
                if (((NSString *)object[@"data"]).length != 0) {
                    SHOW_EEROR_MSG(object[@"data"]);
                }
                else {
                    SHOW_EEROR_MSG(object[@"message"]);
                }
            }
            else{
//                SHOW_EEROR_MSG(@"密码错误请重新输入");
            }
        }];
    }];
    
    [remapayment setShezhiPassWord:^{
        NSLog(@"点击设置密码");
        FindPasswordViewController * updateVC = [[FindPasswordViewController alloc] init];
        updateVC.isPayVC = YES;
        updateVC.isPayPassword = YES;
        [self.navigationController pushViewController:updateVC animated:YES];
    }];
}



/**
 *  隐藏或显示超出视图高度的部分视图
 */
- (void)hideViewWithSuperView:(UIView *)superView hide:(BOOL)hide {
    for (UIView * view in superView.subviews) {
        if (hide) {
            if (view.viewBottomEdge > superView.viewHeight) {
                view.hidden = YES;
            }
        }
        else {
            view.hidden = NO;
        }
    }
}

-(void)gotoSuccess
{
    OrderSuccessViewController *orderS = [[OrderSuccessViewController alloc] init];
//    orderS.navigationItem.hidesBackButton = YES;
    orderS.orderID = self.dataSourceDic[@"order_id"];
    [self.navigationController pushViewController:orderS animated:YES];
}

- (void)refreshView {
    [self getMemberMoney];
}

- (void)APayResult:(NSString *)result {
    
    NSLog(@"%@", result);
    NSArray *parts = [result componentsSeparatedByString:@"="];
    NSError *error;
    NSData *data = [[parts lastObject] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSInteger payResult = [dic[@"payResult"] integerValue];
    if (payResult == APayResultSuccess) {
        NSLog(@"支付结果: 成功");
        [self gotoSuccess];
    } else if (payResult == APayResultFail) {
        NSLog(@"支付结果:失败");
    } else if (payResult == APayResultCancel) {
        SHOW_MSG(@"取消了支付");
        NSLog(@"支付结果:取消");
    }
}




@end
