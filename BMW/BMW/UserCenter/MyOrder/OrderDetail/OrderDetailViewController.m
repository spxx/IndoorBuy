//
//  OrderDetailViewController.m
//  BMW
//
//  Created by 白琴 on 16/3/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderStateView.h"                  //订单状态
#import "SettementGoodsInfoView.h"          //商品信息
#import "ShoppingCarGoodsList.h"
#import "OrderBottomButtonView.h"
#import "ShowLogisticsInformationViewController.h"       //查看物流信息
#import "OrderEvaluateViewController.h"
#import "ApplyRefundViewController.h"
//#import "ChoosePayWayViewController.h"
#import "PayMethodViewController.h"
#import "ReadServiceOrderVC.h"//查看退换货订单


@interface OrderDetailViewController () <UIAlertViewDelegate> {
    UIScrollView * _scrollView;
    
    //金额
    CGFloat _amount;                                    //商品总金额
    UILabel * _amountLabel;                             //金额显示
    UILabel * _freightLabel;                            //运费
    UIButton * _amountJiantouButton;                    //金额的上拉啦按钮
    UIView * _amountBottomLine;                         //金额的下标线
    NSMutableArray * _amountTitleArray;                 //金额内容
    NSMutableArray * _amountValueArray;
}

@property (nonatomic, strong)OrderStateView * orderStateView;
@property (nonatomic, strong)SettementGoodsInfoView * goodsInfoView;
@property (nonatomic, strong)UIView * payWayView;
@property (nonatomic, strong)UIView * couponsView;
@property (nonatomic, strong)UIView * BBSView;              //买家留言
@property (nonatomic, strong)UIView * amountView;
@property (nonatomic, strong)OrderBottomButtonView * bottomButtonView;
@property (nonatomic, strong)UIView * readServiceOrder;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    
    
    [self getOrderDetailRequest];
    [self navigation];
    [self initUserInterface];
}

#pragma mark -- 界面
/**
 *  基本界面
 */
- (void)initUserInterface {
    _scrollView = [UIScrollView new];
    _scrollView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 60);
    [_scrollView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
}
/**
 *  界面加载
 */
- (void)viewLoad {
    [_scrollView addSubview:self.orderStateView];
    [_scrollView addSubview:self.goodsInfoView];
    switch ([self.dataSourceDic[@"order_state"] integerValue]) {
        case 0:{
            //已取消
            [_scrollView addSubview:self.couponsView];
            [_couponsView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _goodsInfoView.viewBottomEdge + 10)];
        }
            break;
        case 10:{
            //待付款
            [_scrollView addSubview:self.couponsView];
            [_couponsView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _goodsInfoView.viewBottomEdge + 10)];
        }
            break;
        case 20:{
            //待发货
            [_scrollView addSubview:self.payWayView];
            [_scrollView addSubview:self.couponsView];
            
        }
            break;
        case 30:{
            //待收货
            [_scrollView addSubview:self.payWayView];
            [_scrollView addSubview:self.couponsView];
        }
            break;
        case 40:{
            //交易成功
            [_scrollView addSubview:self.payWayView];
            [_scrollView addSubview:self.couponsView];
        }
            break;
            
        default:
            break;
    }
    [_scrollView addSubview:self.amountView];
    //加入留言部分
    if (![self.dataSourceDic[@"order_message"] isKindOfClass:[NSNull class]]) {
        [_scrollView addSubview:self.BBSView];
        if (![self.dataSourceDic[@"serviceInfo"] isEqualToString:@"0"]) {
            [_scrollView addSubview:self.readServiceOrder];
            [_readServiceOrder align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _BBSView.viewBottomEdge + 10)];
            [_amountView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _readServiceOrder.viewBottomEdge + 10)];
        }
        else {
            [_amountView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _BBSView.viewBottomEdge + 10)];
        }
    }
    else {
        if (![self.dataSourceDic[@"serviceInfo"] isEqualToString:@"0"]) {
            [_scrollView addSubview:self.readServiceOrder];
            [_amountView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _readServiceOrder.viewBottomEdge + 10)];
        }
    }
    
//    if (![self.dataSourceDic[@"serviceInfo"] isEqualToString:@"0"]) {
//        [_scrollView addSubview:self.readServiceOrder];
//        [_amountView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _readServiceOrder.viewBottomEdge + 10)];
//    }
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _amountView.viewBottomEdge + 10);
    [self.view addSubview:self.bottomButtonView];
}
/**
 *  移除界面
 */
- (void)removeSubViews {
    for (UIView * view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    [_bottomButtonView removeFromSuperview];
    _orderStateView = nil;
    _bottomButtonView = nil;
}
/**
 *  订单顶部状态
 */
- (OrderStateView *)orderStateView {
    if (!_orderStateView) {
        _orderStateView = [[OrderStateView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 100) dataSourceDic:self.dataSourceDic];
        _orderStateView.backgroundColor = [UIColor whiteColor];
        //查看物流信息
        __weak typeof(self)weakSelf = self;
        [_orderStateView setShowLogisticsInformation:^{
            ShowLogisticsInformationViewController * showLFVC = [[ShowLogisticsInformationViewController alloc] init];
            showLFVC.orderId = weakSelf.dataSourceDic[@"order_id"];
            [weakSelf.navigationController pushViewController:showLFVC animated:YES];
        }];
    }
    return _orderStateView;
}
/**
 *  商品信息
 */
- (SettementGoodsInfoView *)goodsInfoView {
    if (!_goodsInfoView) {
        NSInteger count = ((NSArray *)self.dataSourceDic[@"goods"]).count;
        _goodsInfoView = [[SettementGoodsInfoView alloc] initWithFrame:CGRectMake(0, _orderStateView.viewBottomEdge + 10, SCREEN_WIDTH, 119 * count + count - 1) dataSourece:self.dataSourceDic[@"goods"]];
        __weak typeof(self) weakself = self;
        [_goodsInfoView setShowGoodsListButton:^(NSInteger index) {
            ShoppingCarGoodsList *goodsList = [[ShoppingCarGoodsList alloc] init];
            goodsList.dataDic = weakself.dataSourceDic[@"goods"][index];
            [weakself.navigationController pushViewController:goodsList animated:YES];
        }];
    }
    return _goodsInfoView;
}
/**
 *  支付方式
 */
- (UIView *)payWayView {
    if (!_payWayView) {
        _payWayView = [UIView new];
        _payWayView.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_payWayView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _goodsInfoView.viewBottomEdge + 10)];
        _payWayView.backgroundColor = [UIColor whiteColor];
        
        UILabel * titleLabel = [UILabel new];
        titleLabel.viewSize = CGSizeMake(100, 45);
        [titleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
        titleLabel.text = @"支付方式";
        titleLabel.font = fontForSize(13);
        titleLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        [_payWayView addSubview:titleLabel];

        UILabel * payWayLabel = [UILabel new];
        payWayLabel.viewSize = CGSizeMake(100, 45);
        [payWayLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, 0)];
        payWayLabel.textAlignment = NSTextAlignmentRight;
        payWayLabel.font = fontForSize(13);
        payWayLabel.textColor = [UIColor colorWithHex:0x181818];
        NSArray *payArray = [[self.dataSourceDic objectForKeyNotNull:@"payment_code"] componentsSeparatedByString:@","];
        NSString *xxxxx = [payArray lastObject];
        if ([[xxxxx lowercaseString] isEqualToString:@"alipay"]) {
            payWayLabel.text = @"支付宝支付";
        }
        else if ([[xxxxx lowercaseString] isEqualToString:@"wxpay"]) {
            payWayLabel.text = @"微信支付";
        }
        else if ([[xxxxx lowercaseString] isEqualToString:@"predeposit"]) {
            payWayLabel.text = @"余额支付";
        }
        else if ([xxxxx.lowercaseString isEqualToString:@"allinpay"]) {
            payWayLabel.text = @"通联支付";
        }else if([xxxxx.lowercaseString isEqualToString:@"pwdpay"]){
            payWayLabel.text = @"一网通支付";
        }
        if (payArray.count>=2) {
            payWayLabel.text = [NSString stringWithFormat:@"余额支付,%@",payWayLabel.text];
        }
        
        [_payWayView addSubview:payWayLabel];
        
        UIView * payWayBottomLine = [UIView new];
        payWayBottomLine.viewSize = CGSizeMake(SCREEN_WIDTH, 1);
        [payWayBottomLine align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _payWayView.viewHeight)];
        payWayBottomLine.backgroundColor = [UIColor colorWithHex:0xd4d4d4];
        [_payWayView addSubview:payWayBottomLine];
    }
    return _payWayView;
}
/**
 * 退换货订单
 */
-(UIView *)readServiceOrder
{
    if (!_readServiceOrder) {
        _readServiceOrder = [[UIView alloc]initWithFrame:CGRectMake(0, _couponsView.viewBottomEdge + 10, SCREEN_WIDTH, 45)];
        _readServiceOrder.backgroundColor = [UIColor whiteColor];
        
        UILabel * titleLabel = [UILabel new];
        titleLabel.viewSize = CGSizeMake(100, 45);
        [titleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
        titleLabel.text = @"查看退换货订单";
        titleLabel.font = fontForSize(13);
        titleLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        [_readServiceOrder addSubview:titleLabel];
        
        
        UIImageView * jiantouImageView = [UIImageView new];
//        jiantouImageView.viewSize = CGSizeMake(6, 10);
//        [jiantouImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, titleLabel.viewBottomEdge + (60 - jiantouImageView.viewHeight) / 2)];
        jiantouImageView.frame = CGRectMake(SCREEN_WIDTH - 15 - 6, _readServiceOrder.viewHeight / 2 - 5, 6, 10);
        jiantouImageView.image = [UIImage imageNamed:@"icon_xiaojiantou_gwc"];
        [_readServiceOrder addSubview:jiantouImageView];
        
        UIButton * readServiceBtn = [[UIButton alloc]initWithFrame:_readServiceOrder.bounds];
        [readServiceBtn addTarget:self action:@selector(readServiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_readServiceOrder addSubview:readServiceBtn];
    }
    return _readServiceOrder;
}
/**
 *  优惠券
 */
- (UIView *)couponsView {
    if (!_couponsView) {
        _couponsView = [UIView new];
        _couponsView.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_couponsView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _payWayView.viewBottomEdge + 10)];
        _couponsView.backgroundColor = [UIColor whiteColor];
        
        UILabel * titleLabel = [UILabel new];
        titleLabel.viewSize = CGSizeMake(100, 45);
        [titleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
        titleLabel.text = @"优惠券";
        titleLabel.font = fontForSize(13);
        titleLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        [_couponsView addSubview:titleLabel];
    
        
        UILabel * couponsLabel = [UILabel new];
        couponsLabel.viewSize = CGSizeMake(100, 45);
        [couponsLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, 0)];
        couponsLabel.textAlignment = NSTextAlignmentRight;
        couponsLabel.font = fontForSize(13);
        couponsLabel.textColor = [UIColor colorWithHex:0x181818];
        if ([self.dataSourceDic[@"voucher_code"] isKindOfClass:[NSNull class]]) {
            couponsLabel.text = @"未选择优惠券";
        }
        else {
            couponsLabel.text = [NSString stringWithFormat:@"%@¥%@", self.dataSourceDic[@"voucher"][@"voucher_title"], self.dataSourceDic[@"voucher"][@"voucher_price"]];
        }
        
        [_couponsView addSubview:couponsLabel];
        
        UIView * couponsBottomLine = [UIView new];
        couponsBottomLine.viewSize = CGSizeMake(SCREEN_WIDTH, 1);
        [couponsBottomLine align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _couponsView.viewHeight)];
        couponsBottomLine.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_couponsView addSubview:couponsBottomLine];
    }
    return _couponsView;
}
/**
 *  买家留言
 */
- (UIView *)BBSView {
    if (!_BBSView) {
        _BBSView = [UIView new];
        _BBSView.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_BBSView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _couponsView.viewBottomEdge + 10)];
        _BBSView.backgroundColor = [UIColor whiteColor];
        
        UILabel * titleLabel = [UILabel new];
        titleLabel.viewSize = CGSizeMake(100, 45);
        [titleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
        titleLabel.text = @"买家留言";
        titleLabel.font = fontForSize(13);
        titleLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        [_BBSView addSubview:titleLabel];
        
        
        UILabel * couponsLabel = [UILabel new];
        couponsLabel.viewSize = CGSizeMake(SCREEN_WIDTH - titleLabel.viewRightEdge - 15, 45);
        [couponsLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, 0)];
        couponsLabel.textAlignment = NSTextAlignmentRight;
        couponsLabel.textColor = [UIColor colorWithHex:0x181818];
        couponsLabel.text = self.dataSourceDic[@"order_message"];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13], NSParagraphStyleAttributeName:paragraphStyle};
        couponsLabel.attributedText =[[NSAttributedString alloc] initWithString:couponsLabel.text attributes:attributes];
        couponsLabel.numberOfLines = 0;
        [couponsLabel sizeToFit];
        [couponsLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, 16)];
        [_BBSView addSubview:couponsLabel];
        
        _BBSView.viewHeight = couponsLabel.viewBottomEdge + 16;
        
        UIView * couponsBottomLine = [UIView new];
        couponsBottomLine.viewSize = CGSizeMake(SCREEN_WIDTH, 1);
        [couponsBottomLine align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _BBSView.viewHeight)];
        couponsBottomLine.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_BBSView addSubview:couponsBottomLine];
    }
    return _BBSView;
}
/**
 *  金额
 */
- (UIView *)amountView {
    if (!_amountView) {
        _amountView = [UIView new];
        _amountView.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_amountView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _couponsView.viewBottomEdge + 10)];
        _amountView.backgroundColor = [UIColor whiteColor];
        
        UILabel * titleLabel = [UILabel new];
        titleLabel.viewSize = CGSizeMake(100, 45);
        titleLabel.text = @"应付总额";
        titleLabel.font = fontForSize(13);
        titleLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        [titleLabel sizeToFit];
        [titleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, (45 - titleLabel.viewHeight) / 2)];
        [_amountView addSubview:titleLabel];
        
        _amountLabel = [UILabel new];
        _amountLabel.viewSize = CGSizeMake(100, 45);
        _amountLabel.font = fontForSize(13);
        _amountLabel.textColor = [UIColor colorWithHex:0xfd5487];
        if ([[[self.dataSourceDic objectForKeyNotNull:@"additional"] objectForKeyNotNull:@"payprice"] objectForKeyNotNull:@"value"] == nil) {
            _amountLabel.text = @"¥0.00";
        }
        else{
             _amountLabel.text = [NSString stringWithFormat:@"¥%@", self.dataSourceDic[@"additional"][@"payprice"][@"value"]];
            
        }
       
        [_amountLabel sizeToFit];
        [_amountLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, (45 - _amountLabel.viewHeight) / 2)];
        [_amountView addSubview:_amountLabel];
        
        _freightLabel = [UILabel new];
        _freightLabel.viewSize = CGSizeMake(100, 45);
        _freightLabel.font = fontForSize(11);
        _freightLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        [_freightLabel align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(_amountLabel.viewRightEdge + 10, _amountLabel.viewBottomEdge)];
        
        NSDictionary * freightDic = [NSDictionary dictionaryWithDictionary:self.dataSourceDic[@"additional"][@"freight"]];
        if (![freightDic[@"value"] isKindOfClass:[NSNull class]]) {
            if ([freightDic[@"value"] integerValue] != 0) {
                _freightLabel.text = [NSString stringWithFormat:@"(含运费¥%@)", freightDic[@"value"]];
                [_freightLabel sizeToFit];
                [_freightLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, (45 - _amountLabel.viewHeight) / 2)];
                [_amountView addSubview:_freightLabel];
                [_amountLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(_freightLabel.viewX - 10, (45 - _amountLabel.viewHeight) / 2)];
            }

        }
        
        
        for (int i = 0; i < _amountTitleArray.count; i ++) {
            UIView * line = [UIView new];
            line.viewSize = CGSizeMake(SCREEN_WIDTH - 30, 0.5);
            [line align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 45 + i * 45)];
            line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
            [_amountView addSubview:line];
            
            UILabel * titleLabel = [UILabel new];
            titleLabel.viewSize = CGSizeMake(100, 45);
            [titleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, line.viewBottomEdge)];
            titleLabel.font = fontForSize(13);
            titleLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
            
            [_amountView addSubview:titleLabel];
            
            UILabel * moneyLabel = [UILabel new];
            moneyLabel.viewSize = CGSizeMake(100, 45);
            [moneyLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, line.viewBottomEdge)];
            moneyLabel.textAlignment = NSTextAlignmentRight;
            moneyLabel.font = fontForSize(13);
            moneyLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
            [_amountView addSubview:moneyLabel];
            
            if ([_amountTitleArray[i] isEqualToString:@"应付金额"]) {
                moneyLabel.textColor = [UIColor colorWithHex:0xfd5487];
            }
            
            titleLabel.text = _amountTitleArray[i];
            moneyLabel.text = [NSString stringWithFormat:@"¥%@", _amountValueArray[i]];
        }
        _amountView.viewSize = CGSizeMake(SCREEN_WIDTH, 45 + _amountTitleArray.count * 45);
        
        _amountBottomLine = [UIView new];
        _amountBottomLine.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [_amountBottomLine align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _amountView.viewHeight)];
        _amountBottomLine.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_amountView addSubview:_amountBottomLine];
    }
    return _amountView;
}

- (OrderBottomButtonView *)bottomButtonView {
    if (!_bottomButtonView) {
        _bottomButtonView = [[OrderBottomButtonView alloc] initWithFrame:CGRectMake(0, _scrollView.viewBottomEdge, SCREEN_WIDTH, 60) state:self.dataSourceDic[@"order_state"] addOrderTime:self.dataSourceDic[@"add_time"] evaluationState:self.dataSourceDic[@"evaluation_state"] ServerTime:self.dataSourceDic[@"serverTime"]];
        _bottomButtonView.backgroundColor = COLOR_BACKGRONDCOLOR;
        
        __weak typeof(self)weakSelf = self;
        [_bottomButtonView setCountdownOver:^{
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"订单长时间未支付，已失效，请重新下单购买" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 17050;
            [alertView show];
        }];
        //支付
        [_bottomButtonView setPayOrder:^{
            NSLog(@"支付");
            
            NSDictionary * dataDic = weakSelf.dataSourceDic;
            PayMethodViewController * payMethodVC = [[PayMethodViewController alloc] init];
            payMethodVC.isPopRoot = NO;
            payMethodVC.totalCash = dataDic[@"order_amount"];
            payMethodVC.orderTime = dataDic[@"add_time"];
            payMethodVC.orderNum  = dataDic[@"order_sn"];
            payMethodVC.orderPaySn = dataDic[@"pay_sn"];
            payMethodVC.orderID   = dataDic[@"order_id"];

            NSDictionary *dic =  dataDic[@"goods"][0];
            if ([dic[@"send_code"] isKindOfClass:[NSNull class]] || ((NSString *)dic[@"send_code"]).length == 0) {
                //不是海外
                payMethodVC.isAPay = NO;
            }
            else if ([dic[@"send_code"] isEqualToString:@"G"]||[dic[@"send_code"] isEqualToString:@"g"]){
                //海外
                payMethodVC.isAPay = YES;
            }
            else {
                payMethodVC.isAPay = NO;
            }            
            [weakSelf.navigationController pushViewController:payMethodVC animated:YES];

//            ChoosePayWayViewController * choosePayWayVC = [[ChoosePayWayViewController alloc] init];
//            choosePayWayVC.dataSourceDic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.dataSourceDic];
//            choosePayWayVC.isPopRootVC = NO;
//            NSDictionary *SendDic = weakSelf.dataSourceDic[@"goods"][0];
//            if ([SendDic[@"value"][0][@"send_code"] isKindOfClass:[NSNull class]] || ((NSString *)SendDic[@"value"][0][@"send_code"]).length == 0) {
//                //不是海外
//                choosePayWayVC.isOnePayWay = NO;
//            }
//            else if ([SendDic[@"value"][0][@"send_code"] isEqualToString:@"G"]||[SendDic[@"value"][0][@"send_code"] isEqualToString:@"g"]){
//                //海外
//                choosePayWayVC.isOnePayWay = YES;
//            }
//            else {
//                choosePayWayVC.isOnePayWay = NO;
//            }
//            [weakSelf.navigationController pushViewController:choosePayWayVC animated:YES];
        }];
        //退款退货
        [_bottomButtonView setRefundOrReturns:^{
            NSLog(@"退款退货");
            [weakSelf.HUD show:YES];
            [BaseRequset sendPOSTRequestWithBMWApi2Method:@"ServiceReady" parameters:@{@"orderId":weakSelf.orderId} callBack:^(RequestResult result, id object) {
                [weakSelf.HUD hide:YES];
                if (result == RequestResultSuccess) {
                    ApplyRefundViewController *applyVC = [[ApplyRefundViewController alloc] init];
                    applyVC.submitServiceOrderSuccess = ^{
                        [weakSelf removeSubViews];
                        [weakSelf getOrderDetailRequest];
                    };
                    applyVC.dataDic = weakSelf.dataSourceDic;
                    applyVC.dataArray = object[@"data"];
                    [weakSelf.navigationController pushViewController:applyVC animated:YES];
                }else if(result == RequestResultEmptyData){
                    SHOW_EEROR_MSG(@"服务订单已经生成");
                }
            }];
        }];
        //提醒发货
        [_bottomButtonView setRemindSendOutGoods:^{
            NSLog(@"提醒发货");
            [BaseRequset sendPOSTRequestWithBMWApi2Method:@"RemindSend" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"orderId":weakSelf.dataSourceDic[@"order_id"]} callBack:^(RequestResult result, id object) {
                if (result==RequestResultSuccess) {
                    SHOW_MSG(@"提醒成功");
                }
            }];
        }];
        //评价订单
        [_bottomButtonView setEvaluateOrder:^{
            NSLog(@"评价订单");
            //拆分数据格式重组
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            [dic setObject:weakSelf.dataSourceDic[@"order_id"] forKey:@"order_id"];
            NSMutableArray * goodsArray = [NSMutableArray array];
            NSArray * array = weakSelf.dataSourceDic[@"goods"];
            for (int i = 0; i < array.count; i ++) {
                for (int j = 0; j < ((NSArray *)array[i][@"value"]).count; j ++) {
                    [goodsArray addObject:array[i][@"value"][j]];
                }
            }
            [dic setObject:goodsArray forKey:@"goods"];
            
            OrderEvaluateViewController * orderEvaluateVC = [[OrderEvaluateViewController alloc] init];
            orderEvaluateVC.orderDic = dic;
            orderEvaluateVC.refresh = ^{
                [weakSelf removeSubViews];
                [weakSelf getOrderDetailRequest];
            };
            [weakSelf.navigationController pushViewController:orderEvaluateVC animated:YES];
        }];
        //取消订单
        [_bottomButtonView setCancelOrder:^{
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"取消订单" message:@"确定取消此订单吗？" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:@"暂不取消", nil];
            alterView.tag = 17051;
            [alterView show];
        }];
        //再次购买
        [_bottomButtonView setBuyAgain:^{
            NSLog(@"再次购买");
            NSArray * goodsarray = weakSelf.dataSourceDic[@"goods"];
            NSMutableArray * testArray = [NSMutableArray array];
            for (int i = 0; i < goodsarray.count; i ++) {
                for (int j = 0; j < ((NSArray *)goodsarray[i][@"value"]).count; j ++) {
                    [testArray addObject:goodsarray[i][@"value"][j]];
                }
            }
            
            NSMutableArray *jsonArray = [NSMutableArray array];
            for (NSDictionary *dic in testArray) {
                NSDictionary *creatDic = @{@"goodsId":dic[@"goods_id"],@"num":dic[@"goods_num"]};
                [jsonArray addObject:creatDic];
            }
            NSString *json = [TYTools dataJsonWithDic:jsonArray];
            json = [TYTools JSONDataStringTranslation:json];
            
            [BaseRequset sendPOSTRequestWithBMWApi2Method:@"CartAddAll" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"goodsInfo":json} callBack:^(RequestResult result, id object) {
                if (result == RequestResultSuccess) {
                    [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                    RootTabBarVC *tabbar = ROOTVIEWCONTROLLER;
                    tabbar.selectedIndex = 2;
                }
            }];
        }];
        //确认收货
        [_bottomButtonView setAffirmReceiving:^{
            NSLog(@"确认收货");
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"确认收货" message:@"确认已经收到此商品吗？" delegate:weakSelf cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
            alterView.tag = 17052;
            [alterView show];
            
        }];
        //删除订单
        [_bottomButtonView setDeleteOrder:^{
            NSLog(@"删除订单");
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"删除订单" message:@"确定删除此订单吗？" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alterView.tag = 17053;
            [alterView show];
        }];
        
    }
    return _bottomButtonView;
}
#pragma mark -- 点击事件
/**
 *  返回
 */
-(void)back{
    if (self.backToRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -- 其他
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

/**
 *  计算金额
 */
- (void)calculationAmountWithOtherAmount:(NSDictionary *)otherAmount {
    _amountTitleArray = [NSMutableArray array];
    _amountValueArray = [NSMutableArray array];
    NSMutableArray * keyArray = [NSMutableArray arrayWithObjects:otherAmount[@"goods_total"], otherAmount[@"activity"], otherAmount[@"tariff"], otherAmount[@"freight"], otherAmount[@"payprice"],otherAmount[@"back_total"], nil];
    for (int i = 0; i < keyArray.count; i ++) {
        [_amountTitleArray addObject:keyArray[i][@"title"]];
        
        if ([keyArray[i][@"value"] isKindOfClass:[NSNull class]]) {
            [_amountValueArray addObject:@"0.00"];

        }
        else{
            if ([keyArray[i][@"value"] floatValue] == 0) {
                [_amountValueArray addObject:@"0.00"];
            }
            else {
                [_amountValueArray addObject:keyArray[i][@"value"]];
            }
        }
        
    }
}

#pragma mark -- 网络请求
- (void)getOrderDetailRequest {
    [self.HUD show:YES];
    NSString * userID = [JCUserContext sharedManager].currentUserInfo.memberID;
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"OrderDetail" parameters:@{@"userId":userID, @"orderId":self.orderId} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result == RequestResultSuccess) {
            NSLog(@"订单详情 === %@", object[@"data"]);
            self.dataSourceDic = [NSDictionary dictionaryWithDictionary:object[@"data"]];
            [self calculationAmountWithOtherAmount:self.dataSourceDic[@"additional"]];
            if ([self.dataSourceDic[@"address"] isKindOfClass:[NSDictionary class]]) {
                [self viewLoad];
            }   
        }else {
            NSString * message = @"获取订单信息失败，请稍后再试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }

            SHOW_MSG(message);
        }
    }];
}
#pragma mark -- UIAlertViewDelegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 17050) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (alertView.tag == 17051) {
        if (buttonIndex==0) {
            //取消订单
            [BaseRequset sendPOSTRequestWithBMWApi2Method:@"DelOrder" parameters:@{@"pay_sn":self.dataSourceDic[@"pay_sn"]} callBack:^(RequestResult result, id object) {
                if (result==RequestResultSuccess) {
                    SHOW_MSG(@"取消成功");
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    NSString * message = @"取消订单失败，请稍后再试";
                    if ([object isKindOfClass:[NSString class]]) {
                        message = object;
                    }
                    
                    SHOW_MSG(message);
                }

            }];
        }
    }
    else if (alertView.tag == 17052) {
        if (buttonIndex==0) {
            //确认收货
            [BaseRequset sendPOSTRequestWithBMWApi2Method:@"OrderConfirm" parameters:@{@"orderId":self.dataSourceDic[@"order_id"]} callBack:^(RequestResult result, id object) {
                if (result==RequestResultSuccess) {
                    [self removeSubViews];
                    [self getOrderDetailRequest];
                }else {
                    NSString * message = @"服务器故障，请稍后再试";
                    if ([object isKindOfClass:[NSString class]]) {
                        message = object;
                    }
                    
                    SHOW_MSG(message);
                }
            }];
        }
    }
    else if (alertView.tag == 17053) {
        if (buttonIndex == 1) {
            //删除订单
            [BaseRequset sendPOSTRequestWithBMWApi2Method:@"logicDelOrder" parameters:@{@"order_id":self.dataSourceDic[@"order_id"]} callBack:^(RequestResult result, id object) {
                if (result==RequestResultSuccess) {
                    SHOW_MSG(@"删除成功");
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    NSString * message = @"删除订单失败，请稍后再试";
                    if ([object isKindOfClass:[NSString class]]) {
                        message = object;
                    }
                    
                    SHOW_MSG(message);
                }
            }];
        }
    }
    
}
#pragma mark -- Action --
-(void)readServiceBtnAction:(UIButton *)sender
{
    ReadServiceOrderVC * readServiceVC = [[ReadServiceOrderVC alloc]init];
    readServiceVC.orderId = self.orderId;
    [self.navigationController pushViewController:readServiceVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
