//
//  GotoVipViewController.m
//  BMW
//
//  Created by rr on 16/3/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "GotoVipViewController.h"
#import "WaitApplyViewController.h"
#import "TYVerify.h"
#import "OrderSuccessViewController.h"
#import "UserInfoViewController.h"
#import "ChoosePayWayView.h"


@interface GotoVipViewController ()
{
    UIButton * _submitOrderButton;
    NSArray *_placeText;
    NSArray *_nameArray;
    NSInteger _index;                           //支付方式
    BOOL _isChoosePayWay;                       //是否选择了支付方式
}
@property (nonatomic, strong)ChoosePayWayView * choosePayWayView;

@end

@implementation GotoVipViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"成为会员";
    if (_isVIP) {
        self.title = @"续费";
    }
    _isChoosePayWay = NO;
    
    [self navigation];
    [self initData];
    [self initUserInterFace];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPayResult:) name:@"AliPayResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResult:) name:@"WXPayResult" object:nil];
    
}

#pragma mark -- notification
- (void)aliPayResult:(NSNotification *)notification
{
    if ([notification.object[@"code"] isEqualToString:@"9000"]) {
        [self gotoSuccess];
    }
}
/**
 *  微信支付成功
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
#pragma mark -- set
-(void)setIsVIP:(BOOL)isVIP{
    _isVIP = isVIP;
}

-(void)setJoinOrRegis:(BOOL)joinOrRegis{
    _joinOrRegis = joinOrRegis;
}
#pragma mark -- 初始化
/**
 *  数据初始化
 */
-(void)initData{
    
    if (_joinOrRegis) {
        _nameArray = @[@"支付信息：",@"支付金额：",@"付款方式"];
        _placeText = @[@"麦咖年费",[NSString stringWithFormat:@"¥%@", self.orderInfoDic[@"money"]],@""];
        if (_isVIP) {
            NSString * time;
            //判断当前是否已经到期
            if ([[JCUserContext sharedManager].currentUserInfo.status integerValue] == 40) {
                //已到期
                NSString * endString = [TYTools getTimeToShowWithTimestamp:self.serviceTime];
                endString = [endString substringToIndex:10];
                time = [NSString stringWithFormat:@"%@ 至 %@", endString, [self getDateForOneYearLaterWithDateString:endString]];
            }
            else {
                //没有到期
                time = [NSString stringWithFormat:@"%@ 至 %@", self.endTime, [self getDateForOneYearLaterWithDateString:self.endTime]];
            }
            _nameArray = @[@"有效期：",@"支付信息：",@"支付金额：",@"付款方式"];
            _placeText = @[time,@"麦咖年费",[NSString stringWithFormat:@"¥%@", self.orderInfoDic[@"money"]],@""];
        }
    }else{
//        _nameArray = @[@"姓名：",@"手机号：",@"身份证号"];
//        _placeText = @[@"请输入您的会员名",@"请输入您的手机号",@"请输入正确的身份证号"];
    }
}

/**
 *  界面初始化
 */
-(void)initUserInterFace{
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 45*3*W_ABCH+1*W_ABCH)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    if(_joinOrRegis){
        topView.viewSize = CGSizeMake(SCREEN_WIDTH, 45*5*W_ABCH+2*W_ABCH+10*W_ABCH);
        if (_isVIP) {
            topView.viewSize = CGSizeMake(SCREEN_WIDTH, 45*6*W_ABCH+3*W_ABCH+10*W_ABCH);
        }
        for (int i = 0; i<_nameArray.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15*W_ABCW, 45.5*W_ABCH*i, 70*W_ABCW, 45*W_ABCH)];
            if (i==_nameArray.count-1) {
                label.frame = CGRectMake(15*W_ABCW, 45.5*W_ABCH*i+10*W_ABCH, 70*W_ABCW, 45*W_ABCH);
            }
            label.text = _nameArray[i];
            label.textColor = [UIColor colorWithHex:0x7f7f7f];
            label.font = fontForSize(13);
            [topView addSubview:label];
            
            UITextField *textfiled = [[UITextField alloc] initWithFrame:CGRectMake(93*W_ABCW, label.viewY, SCREEN_WIDTH-95*W_ABCW, 45*W_ABCH)];
            textfiled.userInteractionEnabled = NO;
            textfiled.text = _placeText[i];
            textfiled.textColor = [UIColor colorWithHex:0x181818];
            textfiled.font = fontForSize(13);
            if (i==_nameArray.count-2) {
                textfiled.textColor = [UIColor colorWithHex:0xfd5487];
            }
            [topView addSubview:textfiled];
        }
        UIView *lineO = [[UIView alloc] initWithFrame:CGRectMake(0, 45*W_ABCH, SCREEN_WIDTH, 0.5*W_ABCH)];
        lineO.backgroundColor = COLOR_BACKGRONDCOLOR;
        [topView addSubview:lineO];
        UIView *lineT = [[UIView alloc] initWithFrame:CGRectMake(0, 90*W_ABCH, SCREEN_WIDTH, 10*W_ABCH)];
        lineT.backgroundColor = COLOR_BACKGRONDCOLOR;
        [topView addSubview:lineT];
        if (_isVIP) {
            lineT.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5*W_ABCW);
            UIView *lineJian = [[UIView alloc] initWithFrame:CGRectMake(0, 136*W_ABCH, SCREEN_WIDTH, 10*W_ABCH)];
            lineJian.backgroundColor = COLOR_BACKGRONDCOLOR;
            [topView addSubview:lineJian];
        }

        [topView addSubview:self.choosePayWayView];
    }else{
//        for (int i = 0; i<3; i++) {
//            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15*W_ABCW, 45.5*W_ABCH*i, 70*W_ABCW, 45*W_ABCH)];
//            label.text = _nameArray[i];
//            label.textColor = [UIColor colorWithHex:0x7f7f7f];
//            label.font = fontForSize(13);
//            [topView addSubview:label];
//            
//            UITextField *textfiled = [[UITextField alloc] initWithFrame:CGRectMake(93*W_ABCW, label.viewY, SCREEN_WIDTH-95*W_ABCW, 45*W_ABCH)];
//            textfiled.tag = 90+i;
//            textfiled.placeholder = _placeText[i];
//            textfiled.textColor = [UIColor colorWithHex:0x181818];
//            textfiled.delegate = self;
//            textfiled.returnKeyType = UIReturnKeyNext;
//            if (i==2) {
//                textfiled.returnKeyType = UIReturnKeyDone;
//            }
//            textfiled.font = fontForSize(13);
//            [topView addSubview:textfiled];
//        }
//        UIView *lineO = [[UIView alloc] initWithFrame:CGRectMake(0, 45*W_ABCH, SCREEN_WIDTH, 0.5*W_ABCH)];
//        lineO.backgroundColor = COLOR_BACKGRONDCOLOR;
//        [topView addSubview:lineO];
//        
//        UIView *lineT = [[UIView alloc] initWithFrame:CGRectMake(0, 90*W_ABCH, SCREEN_WIDTH, 0.5*W_ABCH)];
//        lineT.backgroundColor = COLOR_BACKGRONDCOLOR;
//        [topView addSubview:lineT];
    }
    _submitOrderButton = [UIButton new];
    _submitOrderButton.viewSize = CGSizeMake(SCREEN_WIDTH-30*W_ABCW, 49);
    [_submitOrderButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15*W_ABCW,topView.viewBottomEdge+20*W_ABCH)];
    _submitOrderButton.titleLabel.font = fontForSize(16);
    if (_joinOrRegis) {
        [_submitOrderButton setTitle:@"立即支付" forState:UIControlStateNormal];
    }else{
        [_submitOrderButton setTitle:@"提 交" forState:UIControlStateNormal];
    }
    [_submitOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitOrderButton.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
    [_submitOrderButton addTarget:self action:@selector(clickedSumbmiyOrderButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitOrderButton];
}

/**
 *  支付方式
 */
- (ChoosePayWayView *)choosePayWayView {
    if (!_choosePayWayView) {
        CGRect frame;
        if (_isVIP) {
            frame = CGRectMake(0, 191*W_ABCH, SCREEN_WIDTH, 45*2*W_ABCH+1*W_ABCH);
        }
        else {
            frame = CGRectMake(0, 146*W_ABCH, SCREEN_WIDTH, 45*2*W_ABCH+1*W_ABCH);
        }
        _choosePayWayView = [[ChoosePayWayView alloc] initWithFrame:frame payWayArray:@[@"支付宝支付", @"微信支付"] payWayImageArray:@[@"icon_zhifubao_zffs.png", @"icon_weixin_zffs.png"] isNeedTitle:NO];
        _choosePayWayView.backgroundColor = [UIColor redColor];
        [_choosePayWayView setButtonPress:^(NSInteger index) {
            _index = index;
            _isChoosePayWay = YES;
        }];
    }
    return _choosePayWayView;
}
#pragma mark -- 点击事件
/**
 *  点击付费
 */
-(void)clickedSumbmiyOrderButton{
    if (_joinOrRegis) {
        if (_isVIP) {
            
        }
        else {
            if (!_isChoosePayWay) {
                SHOW_MSG(@"请选择支付方式");
                return;
            }
            //付费
            switch (_index) {
                case 0:
                    //支付宝支付
                    [TYTools paymentWithGoodsDetail:@{@"order_sn":self.orderInfoDic[@"paysn"], @"price":self.orderInfoDic[@"money"]} isAlipay:YES NotifyURLType:PayNotifyURLIsVIPBinding];
                    break;
                case 1:
                    //微信支付
                {
                    //价格分为单位
                    [self.HUD show:YES];
                    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"WxVipPay" parameters:@{@"price":[NSString stringWithFormat:@"%.0f", [self.orderInfoDic[@"money"] floatValue] * 100],@"orderSn":self.orderInfoDic[@"paysn"]} callBack:^(RequestResult result, id object) {
                        [self.HUD hide:YES];
                        if (result == RequestResultSuccess) {
                            [TYTools paymentWithGoodsDetail:object[@"data"] isAlipay:NO NotifyURLType:PayNotifyURLIsVIPBinding];
                        }
                    }];
                }
                    break;
                default:
                    break;
            }
        }
        
    }
}

//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    if (textField.tag==90) {
//        UITextField *textP = [self.view viewWithTag:91];
//        [textP becomeFirstResponder];
//        [textField endEditing:YES];
//    }else if (textField.tag==91){
//        UITextField *textCart = [self.view viewWithTag:92];
//        [textCart becomeFirstResponder];
//        [textField endEditing:YES];
//    }else{
//        [self.view endEditing:YES];
//    }
//    return YES;
//}

#pragma mark -- 获取某个时间的一年后的时间
- (NSString *)getDateForOneYearLaterWithDateString:(NSString *)dateString {
    //设置转换格式
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //NSString转NSDate
    NSDate * date = [formatter dateFromString:dateString];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date]; // Get necessary date components
    
    NSInteger year = [components year];
    year += 1;
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSString * monthString = [NSString stringWithFormat:@"%ld", (long)month];;
    NSString * dayString = [NSString stringWithFormat:@"%ld", (long)day];
    if (month < 10) {
        monthString = [NSString stringWithFormat:@"0%@", monthString];
    }
    if (day < 10) {
        dayString = [NSString stringWithFormat:@"0%@", dayString];
    }
    NSString * currentDateString = [NSString stringWithFormat:@"%ld-%@-%@", (long)year, monthString, dayString];
    return currentDateString;
}
#pragma mark -- 通知
-(void)gotoSuccess{
    //回到会员首页
//    NSLog(@"%@", self.navigationController.viewControllers);
////    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
//    if ([self.navigationController.viewControllers[1] isKindOfClass:[UserInfoViewController class]]) {
//        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
//    }else{
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
    OrderSuccessViewController * successVC = [[OrderSuccessViewController alloc] init];
    successVC.isVipSuccess = YES;
    [self.navigationController pushViewController:successVC animated:YES];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end

