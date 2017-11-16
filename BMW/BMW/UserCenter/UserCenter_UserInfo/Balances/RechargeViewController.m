//
//  RechargeViewController.m
//  BMW
//
//  Created by 白琴 on 16/5/25.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "RechargeViewController.h"
#import "ChoosePayWayView.h"
#import "OrderSuccessViewController.h"
#import "ZhaoHangViewController.h"

@interface RechargeViewController ()<UITextFieldDelegate, UIScrollViewDelegate> {
    UIScrollView * _scrollView;
    UITextField * _moneyTextField;              //充值金额
    NSInteger _index;                           //支付方式
    BOOL _isChoosePayWay;                       //是否选择了支付方式
    NSString * _alertMoneyString;               //提示金额
    UILabel * _nameLabel;
    NSDictionary *_dataSource;
}

@property (nonatomic, strong)UIView * headerView;
@property (nonatomic, strong)UIView * alertView;
@property (nonatomic, strong)ChoosePayWayView * choosePayWayView;



@end

@implementation RechargeViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPayResult:) name:@"AliPayResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResult:) name:@"WXPayResult" object:nil];
    _dataSource = [NSDictionary dictionary];
    [self navigation];
    [self initUserInterface];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self predepositWithRequest];
}

#pragma nark -- notification
- (void)aliPayResult:(NSNotification *)notification
{
    if ([notification.object[@"code"] isEqualToString:@"9000"]) {
        [self gotoSuccess];
    }
}

-(void)payResult:(NSNotification *)sender
{
    if ([sender.object[@"code"] isEqualToString:@"0"]) {
        [self gotoSuccess];
    }
}

- (void)gotoSuccess {
    OrderSuccessViewController * orderVC = [[OrderSuccessViewController alloc] init];
    orderVC.isRecgargeBalancesSuccess = YES;
    orderVC.isVipSuccess = NO;
    [self.navigationController pushViewController:orderVC animated:YES];
}

#pragma mark -- 界面 --
- (void)initUserInterface {
    _isChoosePayWay = NO;
    
    _scrollView = [UIScrollView new];
    _scrollView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 65);
    [_scrollView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
    _scrollView.backgroundColor = [UIColor colorWithHex:0xf1f1ed];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    [_scrollView addSubview:self.headerView];
    [_scrollView addSubview:self.alertView];
    [_scrollView addSubview:self.choosePayWayView];
    
    UIButton * rechargeButton = [UIButton new];
    rechargeButton.viewSize = CGSizeMake(SCREEN_WIDTH - 30 * W_ABCH, 45 * W_ABCH);
    [rechargeButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, _choosePayWayView.viewBottomEdge + 17 * W_ABCH)];
    rechargeButton.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
    [rechargeButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    [rechargeButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [rechargeButton addTarget:self action:@selector(clickedRechargeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rechargeButton];
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, rechargeButton.viewBottomEdge + 15 * W_ABCH);
}

/**
 *  当前账号和年费
 */
- (UIView *)headerView
{
    if (!_headerView) {
        NSArray * nameArray = @[@"当前账号：", @"充值金额："];
        _headerView = [UIView new];
        _headerView.viewSize = CGSizeMake(SCREEN_WIDTH, 45 * nameArray.count * W_ABCH);
        [_headerView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 10 * W_ABCH)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        for (int i = 0; i < nameArray.count; i ++) {
            UILabel * nameLabel = [UILabel new];
            nameLabel.viewSize = CGSizeMake(78 * W_ABCH, 45 * W_ABCH);
            nameLabel.font = fontForSize(13);
            nameLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
            nameLabel.text = nameArray[i];
            [nameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, i * nameLabel.viewHeight)];
            [_headerView addSubview:nameLabel];
            
            UITextField * textField = [UITextField new];
            textField.viewSize = CGSizeMake(SCREEN_WIDTH - 93 * W_ABCH, 45 * W_ABCH);
            [textField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(93 * W_ABCH, i * textField.viewHeight)];
            textField.font = fontForSize(13);
            textField.textColor = [UIColor colorWithHex:0x181818];
            textField.userInteractionEnabled = YES;
            if (i == 0) {
                textField.text = [JCUserContext sharedManager].currentUserInfo.memberName;
                textField.userInteractionEnabled = NO;
            }
            if (i == 1) {
                textField.placeholder = @"请输入充值金额";
                textField.delegate = self;
                textField.returnKeyType = UIReturnKeyDone;
                textField.keyboardType = UIKeyboardTypeDecimalPad;
                _moneyTextField = textField;
            }
            [_headerView addSubview:textField];
            
            UIView * lineView = [UIView new];
            lineView.viewSize = CGSizeMake(SCREEN_WIDTH - 30 * W_ABCH, 0.5 * W_ABCH);
            [lineView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, textField.viewBottomEdge - lineView.viewHeight)];
            lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
            [_headerView addSubview:lineView];
        }
    }
    return _headerView;
}
/**
 *  提示
 */
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [UIView new];
        _alertView.viewSize = CGSizeMake(SCREEN_WIDTH, 45 * W_ABCH);
        [_alertView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _headerView.viewBottomEdge)];
        _alertView.backgroundColor = COLOR_BACKGRONDCOLOR;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeybord)];
        [_alertView addGestureRecognizer:tap];
        
        _nameLabel = [UILabel new];
        _nameLabel.viewSize = CGSizeMake(SCREEN_WIDTH - 30 * W_ABCH, 0);
        _nameLabel.textColor = [UIColor colorWithHex:0x6f6f6f];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle};
        _nameLabel.attributedText =[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"余额充值不能少于0元，非麦咖会员，充值满%@元即可成为帮麦麦咖会员。", _alertMoneyString] attributes:attributes];
        _nameLabel.numberOfLines = 0;
        [_nameLabel sizeToFit];
        [_nameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, 10 * W_ABCH)];
//        [_alertView addSubview:_nameLabel];
        
        _alertView.viewSize = CGSizeMake(SCREEN_WIDTH, _nameLabel.viewHeight + 20 * W_ABCH);
    }
    return _alertView;
}
/**
 *  支付方式
 */
- (ChoosePayWayView *)choosePayWayView {
    if (!_choosePayWayView) {
        _choosePayWayView = [[ChoosePayWayView alloc] initWithFrame:CGRectMake(0, _alertView.viewBottomEdge, SCREEN_WIDTH, 45*4 * W_ABCH) payWayArray:@[@"支付宝支付", @"微信支付",@"一网通银行卡支付"] payWayImageArray:@[@"icon_zhifubao_zffs.png", @"icon_weixin_zffs.png",@"icon_yiwangtong_gwcjs.png"] isNeedTitle:YES];
        _choosePayWayView.backgroundColor = [UIColor redColor];
        WEAK_SELF;
        [_choosePayWayView setButtonPress:^(NSInteger index) {
            _index = index;
            _isChoosePayWay = YES;
            [weakSelf.view endEditing:YES];
        }];
    }
    return _choosePayWayView;
}

#pragma mark -- UITextFieldDelegate --
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

/**
 *
 *
 *  @param textField 输入之前的值
 *  @param range     输入的位置
 *  @param string    输入的字符
 *
 *  @return
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([textField.text rangeOfString:@"."].location!=NSNotFound) {
        if ([string isEqualToString:@"."]) {        /**< 只能输入一个点 */
            return NO;
        }else {                                     /**< 只能输入两位小数 */
            NSMutableString * text = [NSMutableString stringWithString:textField.text];
            [text insertString:string atIndex:range.location];
            NSArray * strs = [text componentsSeparatedByString:@"."];
            NSString * suffix = strs.lastObject;
            if (suffix.length > 2 ) {
                return NO;
            }else {
                return YES;
            }
        }
    }
    
    NSCharacterSet * cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    
    NSString * filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    BOOL basicTest = [string isEqualToString:filtered];
    if (basicTest) {
        return YES;
    }else {
        return NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@"."]) {
        textField.text = @"0";
    }
    textField.text = [NSString stringWithFormat:@"%.2f", textField.text.doubleValue];
}


#pragma mark -- UIScrollViewDelegate --
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark -- 点击 --
/**
 *  隐藏键盘
 */
- (void)hiddenKeybord {
    [self.view endEditing:YES];
}

- (void)clickedRechargeButton {
    [self.view endEditing:YES];
    if ([_moneyTextField.text integerValue] < 0||[_moneyTextField.text length]==0) {
        SHOW_MSG(@"最低充值金额大于0元");
        return;
    }
    if (!_isChoosePayWay) {
        SHOW_MSG(@"请选择支付方式");
        return;
    }
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"RechargeOrder" parameters:@{@"price":_moneyTextField.text,@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            _dataSource = object[@"data"];
            [self payWithOrderID:object[@"data"][@"paySn"] price:object[@"data"][@"price"]];
        }
        else {
            SHOW_MSG(@"请重试");
        }
    }];
    
}

- (void)payWithOrderID:(NSString *)orderId price:(NSString *)price {
    switch (_index) {
        case 0:
            //支付宝支付
            [TYTools paymentWithGoodsDetail:@{@"order_sn":orderId, @"price":price} isAlipay:YES NotifyURLType:PayNotifyURLIsBalanceRecgarge];
            break;
        case 1:
            //微信支付
        {
            [self.HUD show:YES];
            //[NSString stringWithFormat:@"%.0f", [price floatValue] * 100]
            [BaseRequset sendPOSTRequestWithBMWApi2Method:@"Recharge" parameters:@{@"price":[NSString stringWithFormat:@"%.0f", [price floatValue] * 100], @"orderSn":orderId} callBack:^(RequestResult result, id object) {
                [self.HUD hide:YES];
                if (result == RequestResultSuccess) {
                    [TYTools paymentWithGoodsDetail:object[@"data"] isAlipay:NO NotifyURLType:PayNotifyURLIsBalanceRecgarge];
                }
            }];
        }
            break;
        case 2:{
            [self getZhaohang:orderId];
        }
            break;
        default:
            break;
    }
}

-(void)getZhaohang:(NSString *)orderSN{
    NSDate *data = [NSDate date];
    NSDateFormatter *df1 = [[NSDateFormatter alloc]init];//格式化
    
    [df1 setDateFormat:@"yyyyMMddHHmmss"];
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc]init];//格式化
    
    [df2 setDateFormat:@"yyyyMMdd"];
    
    
    NSString* s1 = [df1 stringFromDate:data];
    NSString* s2 = [df2 stringFromDate:data];
    
    NSDictionary *dataDic = @{@"agrNo":@"12345",
                              @"amount":[NSString stringWithFormat:@"%.2f",[_moneyTextField.text floatValue]],
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
                              @"orderNo":orderSN,
                              @"payNoticePara":@"",
                              @"payNoticeUrl":YiwangtongyuePay,
                              @"returnUrl":@"http://CMBNPRM",
                              @"riskLevel":@"",
                              @"signNoticePara":@"",
                              @"signNoticeUrl":YiwangtongSign,
                              @"userID":[JCUserContext sharedManager].currentUserInfo.memberID};
    NSString *json = [TYTools dataJsonWithDic:dataDic];
    json = [TYTools JSONDataStringTranslation:json];
    
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"RechargePwdPay" parameters:@{@"signdata":json} callBack:^(RequestResult result, id object) {
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
                                 @"amount":[NSString stringWithFormat:@"%.2f",[_moneyTextField.text floatValue]],
                                 @"branchNo":@"0028",
                                 @"cardType":@"",
                                 @"clientIP":@"",
                                 @"date":timedate,
                                 @"dateTime":time,
                                 @"expireTimeSpan":@"30",
                                 @"lat":@"",
                                 @"lon":@"",
                                 @"merchantNo":YiwangtongNo,//@"000275",
                                 @"merchantSerialNo":member[@"merchantSerialNo"],
                                 @"mobile":@"",
                                 @"orderNo":member[@"orderNo"],
                                 @"payNoticePara":@"",
                                 @"payNoticeUrl":YiwangtongyuePay,
                                 @"returnUrl":@"http://CMBNPRM",
                                 @"riskLevel":@"",
                                 @"signNoticePara":@"",
                                 @"signNoticeUrl":YiwangtongSign,
                                 @"userID":[JCUserContext sharedManager].currentUserInfo.memberID};
    NSDictionary *dataDic =@{@"version":@"1.0",@"charset":@"UTF-8",@"sign":member[@"sign"],@"signType":@"SHA-256",@"reqData":requdata};
    ZhaoHangViewController *zhaoHanVC = [[ZhaoHangViewController alloc] init];
    zhaoHanVC.rechager = YES;
    zhaoHanVC.orderPaySn = _dataSource[@"paySn"];
    zhaoHanVC.dataDic = dataDic;
    [self.navigationController pushViewController:zhaoHanVC animated:YES];
}



#pragma mark -- 网络请求 --
/**
 *  获取提示金额
 */
- (void)predepositWithRequest {
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetPredeposit" parameters:nil callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result == RequestResultSuccess) {
            _alertMoneyString = [object[@"data"] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            [self updateAlertMoney];
        }
        else {
            SHOW_MSG(@"请重试");
        }
    }];
}

- (void)updateAlertMoney {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle};
    _nameLabel.attributedText =[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"余额充值不能少于0元，非麦咖会员，充值满%@元即可成为帮麦麦咖会员。", _alertMoneyString] attributes:attributes];
//    _nameLabel.numberOfLines = 0;
//    [_nameLabel sizeToFit];
    _nameLabel.viewHeight = 0;
    [_nameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, 10 * W_ABCH)];
    _alertView.viewSize = CGSizeMake(SCREEN_WIDTH, _nameLabel.viewHeight + 20 * W_ABCH);
    [_choosePayWayView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _alertView.viewBottomEdge)];
}

#pragma mark -- private-
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
