//
//  PayMethodViewController.m
//  BMW
//
//  Created by LiuP on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "PayMethodViewController.h"
#import "PayWayView.h"
#import "PayMethodModel.h"
#import "RemapayMentView.h"
#import "AccountModel.h"
// 通联支付
#import "APay.h"
#import "PaaCreater.h"
#import "FindPasswordViewController.h"
#import "RemapayMentView.h"
#import "OrderSuccessViewController.h"
#import "ZhaoHangViewController.h"

// 支付方式
static NSString * aliPay        = @"alipay";
static NSString * WxPay         = @"wxpay";
static NSString * PwdPay        = @"pwdpay";
static NSString * predeposit    = @"predeposit";


NSString * remindMessage(CGFloat freezeMcash, CGFloat lastAmount)
{
    NSString * message = [NSString stringWithFormat:@"账户授权支付%.2f元，还差%.2f元，请选择其他方式支付：", freezeMcash, lastAmount];
    return message;
}

@interface PayMethodViewController ()<PayWayViewDelegate, APayDelegate, SetPayPasswordDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) PayWayView * payMethodView;

@property (nonatomic, assign) PayWay payWay;

@property (nonatomic, assign) BOOL useAccount;  /**< 是否使用账户资金 */
@property (nonatomic, assign) BOOL isFreezed;       /**< 此订单已经存在冻结的余额 */
@end

@implementation PayMethodViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPayResult:) name:@"AliPayResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WXPayResult:) name:@"WXPayResult" object:nil];
    [self initUserInterface];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshOrderStatus];
}

- (void)initUserInterface
{
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    self.title = @"支付方式";
    [self navigation];
    
    _payMethodView = [[PayWayView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight - 64)
                                                oneNet:self.isAPay];
    _payMethodView.delegate = self;
    _payMethodView.total = self.totalCash;
    _payMethodView.orderNumber = self.orderNum;
    _payMethodView.orderCreatTime = [self changeTimeStampWitmTimeStamp:self.orderTime];
    [self.view addSubview:_payMethodView];
    
    _payMethodView.personCash = [NSString stringWithFormat:@"%.2f", self.personCash.floatValue];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

#pragma mark -- 刷新订单状态
- (void)refreshOrderStatus
{
    [self.HUD show:YES];
    self.payMethodView.bigAccountBtn.userInteractionEnabled = NO;
    [PayMethodModel requestForOrderDetailWithOrderID:self.orderID  complete:^(BOOL isSuccess, PayMethodModel *model, NSString *message) {
        [self.HUD hide:YES];
        if (isSuccess) {
            self.payMethodView.bigAccountBtn.userInteractionEnabled = YES;
            if ([model.payCode isEqualToString:aliPay] ||       // 此订单单独使用过第三方支付，隐藏账户资金的选项
                [model.payCode isEqualToString:PwdPay] ||
                [model.payCode isEqualToString:WxPay]) {
                self.payMethodView.hideAccount = YES;
            }
            if (model.freezedCash.floatValue > 0) { // 是否存在冻结金额
                self.isFreezed = YES;
                self.useAccount = YES;
            }else {
                self.useAccount = NO;
                self.isFreezed = NO;
            }
            self.payMethodView.isFreezed = self.isFreezed;
            self.payMethodView.personCash = model.personCash;
            self.personCash = model.personCash;
            
            if (self.isFreezed) {   // 此订单存在冻结金额
                self.personCash = model.freezedCash;
                self.payMethodView.personCash = model.freezedCash; // 账户资金显示 （已授权使用的金额，即已冻结的金额）
                NSString * message = remindMessage(model.freezedCash.floatValue, self.totalCash.floatValue - model.freezedCash.floatValue);
                [self.payMethodView chooseOtherMethodMessage:message
                                                        Show:YES];
            }
        }else {
            SHOW_EEROR_MSG(message);
        }
    }];
}

#pragma nark -- notification
- (void)aliPayResult:(NSNotification *)notification
{
    if ([notification.object[@"code"] isEqualToString:@"9000"]) {
        [self gotoSuccess];
    }else {
        [self refreshOrderStatus];
    }
}

- (void)WXPayResult:(NSNotification *)notification
{
    if ([notification.object[@"code"] isEqualToString:@"0"]) {
        [self gotoSuccess];
    }else {
        [self refreshOrderStatus];
    }
}

#pragma mark -- other
// 判断账户资金是否充足
- (BOOL)isPersonEnough
{
    return _payMethodView.personCash.floatValue >= self.totalCash.floatValue;
}

// 转换时间戳
- (NSString *)changeTimeStampWitmTimeStamp:(NSString *)timeStamp
{
    return [TYTools getTimeToShowWithTimestamp:timeStamp];
}

/**
 * 返回
 */
-(void)back
{
    if (self.isPopRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 返回支付方式的字符串
- (NSString *)whichPayMehtodWithPayWay:(PayWay)payWay
{
    NSString * payCode = @"";
    switch (payWay) {
        case PayNone:
            break;
        case PayAlipay: payCode = aliPay;
            break;
        case PayWX: payCode = WxPay;
            break;
        case PayOneNet: payCode = PwdPay;
            break;
        case PayAPay:
            break;
        default:
            break;
    }
    return payCode;
}

#pragma mark -- PayWayViewDelegate
// 点击账户资金
- (void)payWayView:(PayWayView *)payWayView clickedAccountWithBtn:(UIButton *)btn
{
    if (![JCUserContext sharedManager].currentUserInfo.payPassword || ((NSString *)[JCUserContext sharedManager].currentUserInfo.payPassword).length == 0) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到您未设置交易密码，请设置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
        [alert show];
        return ;
    }
    if (btn.selected) {
        btn.selected = NO;
        self.useAccount = NO;
        // 隐藏提示信息
        NSString * message = remindMessage(0,0);
        [self.payMethodView chooseOtherMethodMessage:message
                                                Show:NO];
        if (self.payWay == PayNone) {
            payWayView.sureBtnEnabled = NO;
        }
    }else {
        // 弹出输入交易密码
        [self inputPasswordWithBtn:btn];
    }
}

// 点击其他支付方式
- (void)payWayView:(PayWayView *)payWayView clickedOtherBtn:(UIButton *)btn method:(PayWay)method
{
    if (!self.isAPay) {
        if ([self isPersonEnough]) {  // 账户资金充足的情况下，使用其他方式支付
            self.useAccount = NO;
            payWayView.accountBtn.selected = NO;
        }
    }
    self.payWay = method;
}

// 确认支付
- (void)payWayView:(PayWayView *)payWayView clickedSureWithBtn:(UIButton *)btn
{
    [self.HUD show:YES];
    if (self.useAccount) { // 支付
        NSString * type;
        NSString * payCode = [self whichPayMehtodWithPayWay:self.payWay];
        if ([self isPersonEnough]) {
            type = @"2";
            payCode = predeposit;
        }else {
            type = @"2";
            payCode = [predeposit stringByAppendingFormat:@",%@", payCode];
        }
        if (self.isFreezed) { // 已经存在冻结金额，必然为混合支付
            type = @"2";
            payCode = [predeposit stringByAppendingFormat:@",%@", payCode];
        }
        [PayMethodModel requestForMemberPayWithPaySn:self.orderPaySn
                                                type:type
                                             payCode:payCode
                                            complete:^(BOOL isSuccess, PayMethodModel *model, NSString *message) {
            if (isSuccess) {
                if (model.amount.floatValue > 0) {
                    [self creatPayWithAmount:model.amount payWay:self.payWay];
                }else {
                    NSLog(@"余额支付成功");
                    [self gotoSuccess];
                }
            }else {
                [self.HUD hide:YES];
                SHOW_EEROR_MSG(message);
            }
        }];
    }else {
        if (self.payWay == PayAPay) { // 通联支付
            [self creatPayWithAmount:self.totalCash payWay:self.payWay];
        }else {
            NSString * payCode = [self whichPayMehtodWithPayWay:self.payWay];
            [PayMethodModel requestForMemberPayWithPaySn:self.orderPaySn
                                                    type:@"1"
                                                 payCode:payCode
                                                complete:^(BOOL isSuccess, PayMethodModel *model, NSString *message) {
                if (isSuccess) {
                    [self creatPayWithAmount:model.amount payWay:self.payWay];
                }else {
                    [self.HUD hide:YES];
                    SHOW_EEROR_MSG(message);
                }
            }];
        }
    }
}

#pragma mark -- 开始进行第三方支付
- (void)creatPayWithAmount:(NSString *)amount payWay:(PayWay)payWay
{
    switch (payWay) {
        case PayNone: NSLog(@"未选择第三方支付");
            break;
        case PayAlipay: {
            NSLog(@"支付宝");
            [self.HUD hide:YES];
            NSDictionary * dataDic = @{@"pay_sn":self.orderPaySn,
                                       @"order_amount":amount,
                                       @"order_sn":self.orderNum};
            [TYTools paymentWithGoodsDetail:dataDic
                                   isAlipay:YES
                              NotifyURLType:PayNotifyURLIsDefault];
        }
            break;
        case PayWX: {
            NSLog(@"微信支付");
            NSDictionary * paraDic = @{@"price":[NSString stringWithFormat:@"%.2f", amount.floatValue],
                                       @"orderSn":self.orderPaySn};
            [PayMethodModel requestForWXPayWithParaDic:paraDic
                                              complete:^(BOOL isSuccess, NSDictionary *data, NSString *message) {
                [self.HUD hide:YES];
                if (isSuccess) {
                    [TYTools paymentWithGoodsDetail:data
                                           isAlipay:NO
                                      NotifyURLType:PayNotifyURLIsDefault];
                }else {
                    SHOW_EEROR_MSG(message);
                }
            }];
        }
            break;
        case PayOneNet:{
            NSLog(@"一网通");
            [PayMethodModel requestForOneNetWithAmount:amount
                                               orderSn:self.orderNum
                                              complete:^(BOOL isSuccess, PayMethodModel * model, NSString *message) {
                  [self.HUD hide:YES];
                  if (isSuccess) {
                      [self loadWebViewWithModel:model amount:amount];
                  }else {
                      SHOW_EEROR_MSG(message);
                  }
            }];
        }
            break;
        case PayAPay: {
            NSLog(@"通联支付");
            [self.HUD hide:YES];
            //@"1"
            NSString *payData = [PaaCreater randomPaaWithgoodsName:self.orderPaySn
                                                            amount:[NSString stringWithFormat:@"%.0f", amount.floatValue * 100]];
            //@param mode
            //00 生产环境
            //01 测试环境
            //在测试与生产环境之间切换的时候请注意修改mode参数
            [APay startPay:payData viewController:self delegate:self mode:@"00"];
        }
            break;
        default:
            break;
    }
}

#pragma mark -- 进入一卡通支付
-(void)loadWebViewWithModel:(PayMethodModel *)model amount:(NSString *)amount
{
    NSDictionary *requdata =   @{@"agrNo":model.oneNetData[@"agrNo"],
                                 @"amount":[NSString stringWithFormat:@"%.2f",  amount.floatValue],
                                 @"branchNo":@"0028",
                                 @"cardType":@"",
                                 @"clientIP":@"",
                                 @"date":model.date,
                                 @"dateTime":model.dateTime,
                                 @"expireTimeSpan":@"30",
                                 @"lat":@"",
                                 @"lon":@"",
                                 @"merchantNo":YiwangtongNo,
                                 @"merchantSerialNo":model.oneNetData[@"merchantSerialNo"],
                                 @"mobile":@"",
                                 @"orderNo":model.oneNetData[@"orderNo"],
                                 @"payNoticePara":@"",
                                 @"payNoticeUrl":YiwangtongPay,
                                 @"returnUrl":@"http://CMBNPRM",
                                 @"riskLevel":@"",
                                 @"signNoticePara":@"",
                                 @"signNoticeUrl":YiwangtongSign,
                                 @"userID":[JCUserContext sharedManager].currentUserInfo.memberID};
    NSDictionary * dataDic = @{@"version":@"1.0",@"charset":@"UTF-8",@"sign":model.oneNetData[@"sign"],@"signType":@"SHA-256",@"reqData":requdata};
    ZhaoHangViewController *zhaoHanVC = [[ZhaoHangViewController alloc] init];
    zhaoHanVC.orderPaySn = self.orderID;
    zhaoHanVC.dataDic = dataDic;
    [self.navigationController pushViewController:zhaoHanVC animated:YES];
}

#pragma mark -- APay Result
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

#pragma mark -- other
- (void)gotoSuccess
{
    OrderSuccessViewController * successVC = [[OrderSuccessViewController alloc] init];
    successVC.orderID = self.orderID;
    [self.navigationController pushViewController:successVC animated:YES];
}

#pragma mark -- 弹框输入交易密码
/**
 *  输入交易密码
 */
- (void)inputPasswordWithBtn:(UIButton *)btn
{
    RemapayMentView * remapayment = [[RemapayMentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view.window addSubview:remapayment];
    
    WEAK_SELF;
    [remapayment setFinishPay:^(NSString * password) {
        NSString * money = @"0.00";
        if (self.payMethodView.personCash.floatValue >= self.totalCash.floatValue) {
            money = self.totalCash;
        }else {
            money = self.payMethodView.personCash;
        }
        [self.HUD show:YES];
        [PayMethodModel requestForUserMoneyWithPaySn:self.orderPaySn password:password money:money complete:^(BOOL isSuccess, PayMethodModel *model, NSString *message) {
            [self.HUD hide:YES];
            if (isSuccess) {
                if (model.pdAmount.floatValue > 0) {
                    weakSelf.useAccount = YES;
                    btn.selected = YES;
                    if (model.amount.floatValue > 0) {
                        // 余额不够，还需要选择其他方式
                        NSString * message = remindMessage(model.pdAmount.floatValue, model.amount.floatValue);
                        [weakSelf.payMethodView chooseOtherMethodMessage:message
                                                                    Show:YES];
                    }else {
                        // 余额够了，激活确认按钮
                        weakSelf.payMethodView.sureBtnEnabled = YES;
                        weakSelf.payWay = PayNone;
                        [weakSelf.payMethodView allOtherMethodBtnNormal:YES];
                    }
                }else {
                    SHOW_MSG(@"余额不足，请选择其他方式支付");
                }
            }else {
                SHOW_EEROR_MSG(message);
            }
        }];
    }];
}

#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        FindPasswordViewController * updateVC = [[FindPasswordViewController alloc] init];
        updateVC.isPayVC = YES;
        updateVC.isPayPassword = YES;
        updateVC.delegate = self;
        [self.navigationController pushViewController:updateVC animated:YES];
    }
}

#pragma mark -- SetPayPasswordDelegate
- (void)setPayPasswordSuccess
{
    self.useAccount = YES;
    self.payMethodView.accountBtn.selected = YES;
    if ([self isPersonEnough]) { // 账户自己充足，确认按钮可用
        self.payMethodView.sureBtnEnabled = YES;
    }else {
        // 账户资金不足时，根据是否选中显示提示使用其他方式支付
        NSString * message = remindMessage(self.personCash.floatValue, self.totalCash.floatValue - self.personCash.floatValue);
        [self.payMethodView chooseOtherMethodMessage:message
                                                Show:YES];
    }
}

@end

