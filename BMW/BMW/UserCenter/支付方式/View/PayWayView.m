//
//  PayMethodView.m
//  BMW
//
//  Created by LiuP on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "PayWayView.h"

@interface PayWayView ()

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIView * orderView;       /**< 订单信息 */
@property (nonatomic, strong) UILabel * orderNum;       /**< 订单编号 */
@property (nonatomic, strong) UILabel * orderTime;      /**< 订单时间 */
@property (nonatomic, strong) UIView * accountView;     /**< 账户资金 */
@property (nonatomic, strong) UILabel * cash;           /**< 可用资金 */
@property (nonatomic, strong) UILabel * message;        /**< 使用账户资金提示信息 */
@property (nonatomic, strong) UIView * methodView;      /**< 其他支付方式 */
@property (nonatomic, strong) UIButton * sureBtn;       /**< 确认支付按钮 */
@property (nonatomic, strong) UIView * totalView;       /**< 总金额 */
@property (nonatomic, strong) UILabel * totalCash;      /**< 实际金额 */

@property (nonatomic, strong) UIButton * selectedBtn;    /**< 其他支付方式选中的按钮 */
@property (nonatomic, assign) BOOL isAPay;            /**< 是否只显示 通联支付 */

@end

@implementation PayWayView : UIView

- (instancetype)initWithFrame:(CGRect)frame oneNet:(BOOL)oneNet
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isAPay = oneNet;
        [self initUserInterface];
        
    }
    return self;
}

- (void)initUserInterface
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight - 47 * W_ABCW)];
    _scrollView.backgroundColor = COLOR_BACKGRONDCOLOR;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    [self initOrderView];
    [self initAccountView];
    [self initSureBtn];
}

- (void)initOrderView
{
    _orderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 70 * W_ABCW + 0.5)];
    _orderView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_orderView];
    
    _orderNum = [[UILabel alloc] initWithFrame:CGRectMake(15 * W_ABCW, 0, _orderView.viewWidth - 30 * W_ABCW, 35 * W_ABCW)];
    _orderNum.font = fontForSize(12 * W_ABCW);
    _orderNum.text = @"订单编号：";
    [_orderView addSubview:_orderNum];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, _orderNum.viewBottomEdge, _orderView.viewWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
    [_orderView addSubview:line];

    _orderTime = [[UILabel alloc] initWithFrame:CGRectMake(_orderNum.viewX, line.viewBottomEdge, _orderNum.viewWidth, _orderNum.viewHeight)];
    _orderTime.font = fontForSize(12 * W_ABCW);
    _orderTime.text = @"下单时间：";
    [_orderView addSubview:_orderTime];
}

- (void)initAccountView
{
    _accountView = [[UIView alloc] initWithFrame:CGRectMake(0, _orderView.viewBottomEdge + 5 * W_ABCW, self.viewWidth, _orderView.viewHeight)];
    _accountView.backgroundColor = [UIColor whiteColor];
    _accountView.clipsToBounds = YES;
    [_scrollView addSubview:_accountView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(_orderNum.viewX, 0, _orderNum.viewWidth, _orderNum.viewHeight)];
    label.font = fontForSize(12 * W_ABCW);
    label.text = @"选择支付方式";
    [_accountView addSubview:label];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, label.viewBottomEdge - 0.5, _orderView.viewWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
    [_accountView addSubview:line];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(3 * W_ABCW, line.viewBottomEdge, label.viewHeight, label.viewHeight);
    [btn setImage:IMAGEWITHNAME(@"icon_weixuanze_jrbmd_nor.png") forState:UIControlStateNormal];  // 12 * 12
    [btn setImage:IMAGEWITHNAME(@"icon_yixuanze_jrbmd_cli.png") forState:UIControlStateSelected];
    [btn setImage:IMAGEWITHNAME(@"icon_yixuanze_jrbmd_cli.png") forState:UIControlStateDisabled];
//    [btn addTarget:self action:@selector(accountAction:) forControlEvents:UIControlEventTouchUpInside];
    [_accountView addSubview:btn];
    self.accountBtn = btn;
    
    UIButton *bigBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, btn.viewY, SCREEN_WIDTH, _orderNum.viewHeight)];
    bigBtn.tag = 200;
    [bigBtn addTarget:self action:@selector(accountAction:) forControlEvents:UIControlEventTouchUpInside];
    [_accountView addSubview:bigBtn];
    self.bigAccountBtn = bigBtn;
    
    UIImageView * iconImage = [UIImageView new];
    iconImage.viewSize = CGSizeMake(20 * W_ABCW, 20 * W_ABCW);
    iconImage.layer.cornerRadius = iconImage.viewWidth / 2;
    iconImage.clipsToBounds =  YES;
    iconImage.center = CGPointMake(btn.viewRightEdge - 3 * W_ABCW + iconImage.viewWidth / 2, btn.center.y);
    [_accountView addSubview:iconImage];
    
    UILabel * method = [UILabel new];
    method.font = fontForSize(12 * W_ABCW);
    method.frame = CGRectMake(iconImage.viewRightEdge + 9 * W_ABCW, btn.viewY, 100, label.viewHeight);
    [_accountView addSubview:method];
    
    if (self.isAPay) {
        iconImage.image = IMAGEWITHNAME(@"icon_tonglian_zffs.png");
        method.text = @"通联支付";
        
        [self initTotalView];
    }else {
        iconImage.image = IMAGEWITHNAME(@"icon_zhanghuzijin_jrbmd.png");
        method.text = @"账户资金";
        _cash = [UILabel new];
        _cash.viewSize = CGSizeMake(self.viewWidth - method.viewRightEdge - 15 * W_ABCW, label.viewHeight);
        _cash.center = CGPointMake(self.viewWidth - 13 * W_ABCW - _cash.viewWidth / 2, iconImage.center.y);
        _cash.font = fontForSize(12 * W_ABCW);
        _cash.textAlignment = NSTextAlignmentRight;
        [_accountView addSubview:_cash];
        
        _message = [[UILabel alloc] initWithFrame:CGRectMake(15 * W_ABCW, _accountView.viewBottomEdge, self.viewWidth - 30 * W_ABCW, 25 * W_ABCW)];
        _message.numberOfLines = 0;
        _message.hidden = YES;
        _message.textAlignment = NSTextAlignmentCenter;
        _message.font = fontForSize(10 * W_ABCW);
        _message.textColor = COLOR_NAVIGATIONBAR_BARTINT;
        [_scrollView addSubview:_message];
        
        [self initMethodView];
        [self initTotalView];
    }
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, btn.viewBottomEdge - 0.5, _orderView.viewWidth, 0.5)];
    line2.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
    [_accountView addSubview:line2];
}

- (void)initMethodView
{
    _methodView = [[UIView alloc] initWithFrame:CGRectMake(0, _accountView.viewBottomEdge, self.viewWidth, 105 * W_ABCW + 1)];
    _methodView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_methodView];
    
    NSArray * images = @[@"icon_zhifubao_jrbmd.png", @"icon_weixin_jrbmd.png",@"icon_yiwnagtong_jrbmd.png"];
    NSArray * methods = @[@"支付宝", @"微信", @"一网通银行卡"];
    CGFloat methodH = 35 * W_ABCW;
    for (int i = 0; i < images.count; i ++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(3 * W_ABCW, (methodH + 0.5) * i, methodH, methodH);
        btn.tag = 100 + i;
        [btn setImage:IMAGEWITHNAME(@"icon_weixuanze_jrbmd_nor.png") forState:UIControlStateNormal];  // 12 * 12
        [btn setImage:IMAGEWITHNAME(@"icon_yixuanze_jrbmd_cli.png") forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(methodAction:) forControlEvents:UIControlEventTouchUpInside];
        [_methodView addSubview:btn];
        
        UIImageView * iconImage = [UIImageView new];
        iconImage.image = IMAGEWITHNAME(images[i]);
        iconImage.viewSize = CGSizeMake(20 * W_ABCW, 20 * W_ABCW);
        iconImage.layer.cornerRadius = iconImage.viewWidth / 2;
        iconImage.clipsToBounds =  YES;
        iconImage.center = CGPointMake(btn.viewRightEdge - 3 * W_ABCW + iconImage.viewWidth / 2, btn.center.y);
        [_methodView addSubview:iconImage];
        
        UILabel * method = [UILabel new];
        method.font = fontForSize(12 * W_ABCW);
        method.frame = CGRectMake(iconImage.viewRightEdge + 9 * W_ABCW, btn.viewY, 100, btn.viewHeight);
        method.text = methods[i];
        [_methodView addSubview:method];
        
        if (i < images.count - 1) {
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, btn.viewBottomEdge, _methodView.viewWidth, 0.5)];
            line.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
            [_methodView addSubview:line];
        }
        UIButton *bigBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, btn.viewY, SCREEN_WIDTH, methodH)];
        bigBtn.tag = 1000 + i;
        [bigBtn addTarget:self action:@selector(methodAction:) forControlEvents:UIControlEventTouchUpInside];
        [_methodView addSubview:bigBtn];
        

    }
}

- (void)initTotalView
{
    CGFloat originY;
    if (self.isAPay) {
        originY = _accountView.viewBottomEdge + 5 * W_ABCW;
    }else {
        originY = _methodView.viewBottomEdge + 5 * W_ABCW;
    }
    _totalView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, self.viewWidth, 32 * W_ABCW)];
    _totalView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_totalView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(_orderNum.viewX, 0, 100, _totalView.viewHeight)];
    label.font = fontForSize(12 * W_ABCW);
    label.text = @"实际金额";
    [_totalView addSubview:label];
    
    _totalCash = [UILabel new];
    _totalCash.viewSize = CGSizeMake(_totalView.viewWidth - label.viewRightEdge - 15 * W_ABCW, _totalView.viewHeight);
    _totalCash.center = CGPointMake(_totalView.viewWidth - 15 * W_ABCW - _totalCash.viewWidth / 2, _totalCash.viewHeight / 2);
    _totalCash.textAlignment = NSTextAlignmentRight;
    _totalCash.font = fontForSize(13 * W_ABCW);
    _totalCash.textColor = COLOR_NAVIGATIONBAR_BARTINT;
    _totalCash.text = @"¥0.00";
    [_totalView addSubview:_totalCash];
}

- (void)initSureBtn
{
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.enabled = NO;
    _sureBtn.frame = CGRectMake(0, self.viewHeight - 47 * W_ABCW, self.viewWidth, 47 * W_ABCW);
    [_sureBtn setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xdfdfdf] andSize:_sureBtn.viewSize]
                        forState:UIControlStateDisabled];
    [_sureBtn setBackgroundImage:[UIImage squareImageWithColor:COLOR_NAVIGATIONBAR_BARTINT andSize:_sureBtn.viewSize]
                        forState:UIControlStateNormal];
    [_sureBtn setTitle:@"确认支付0.00元" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(surePayAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sureBtn];
}

#pragma mark -- setter
- (void)setSureBtnEnabled:(BOOL)sureBtnEnabled
{
    self.sureBtn.enabled = sureBtnEnabled;
}

- (void)setOrderNumber:(NSString *)orderNumber
{
    _orderNumber = orderNumber;
    self.orderNum.text = [@"订单编号：" stringByAppendingString:orderNumber];
}

- (void)setOrderCreatTime:(NSString *)orderCreatTime
{
    _orderCreatTime = orderCreatTime;
    self.orderTime.text = [@"下单时间：" stringByAppendingString:orderCreatTime];
}

- (void)setTotal:(NSString *)total
{
    _total = total;
    self.totalCash.text = [@"¥" stringByAppendingString:total];
    [self.sureBtn setTitle:[NSString stringWithFormat:@"确认支付%@元", total]
                  forState:UIControlStateNormal];
}

- (void)setPersonCash:(NSString *)personCash
{
    _personCash = personCash;
    if (self.isFreezed) {
        self.cash.text = [NSString stringWithFormat:@"(已授权%@)", personCash];
    }else {
        self.cash.text = [NSString stringWithFormat:@"(可用%@)", personCash];
    }
}

- (void)setIsFreezed:(BOOL)isFreezed
{
    _isFreezed = isFreezed;
    self.accountBtn.selected = NO;
    if (isFreezed) {
        self.accountBtn.enabled = NO;
        self.bigAccountBtn.userInteractionEnabled = NO;
    }else {
        self.accountBtn.enabled = YES;
        self.bigAccountBtn.userInteractionEnabled = YES;
    }
}

- (void)setHideAccount:(BOOL)hideAccount
{
    if (hideAccount) {
        self.accountView.viewSize = CGSizeMake(self.accountView.viewWidth, _orderNum.viewHeight);
        [self layoutSubviews];
    }
}

#pragma mark -- actions
// 选择了账户资金
- (void)accountAction:(UIButton *)btn
{
    if (self.isAPay) {
        self.accountBtn.selected = !self.accountBtn.selected;
        PayWay method;
        if (btn.selected) {
            method = PayAPay;
            self.sureBtnEnabled = YES; // 确认按钮可使用
        }else {
            method = PayNone;
            self.sureBtnEnabled = NO; // 确认按钮不可使用
        }
        if ([self.delegate respondsToSelector:@selector(payWayView:clickedOtherBtn:method:)]) {
            [self.delegate payWayView:self clickedOtherBtn:self.accountBtn method:method];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(payWayView:clickedAccountWithBtn:)]) {
            [self.delegate payWayView:self clickedAccountWithBtn:self.accountBtn];
        }
    }
}

// 选择了其他支付方式
- (void)methodAction:(UIButton *)btn
{
    UIButton *sender = nil;
    if (btn.tag>=1000) {
        sender = [_methodView viewWithTag:btn.tag - 900];
    }else{
        sender = [_methodView viewWithTag:btn.tag];
    }
    
    sender.selected = !sender.selected;
    if (self.selectedBtn && self.selectedBtn != sender) {
        self.selectedBtn.selected = NO;
    }
    
    PayWay method = PayNone;
    if (sender.selected) {
        self.selectedBtn = sender;
        if (btn.tag == 100 || btn.tag == 1000) {
            method = PayAlipay;
        }
        if (btn.tag == 101 || btn.tag == 1001) {
            method = PayWX;
        }
        if (btn.tag == 102 || btn.tag == 1002) {
            method = PayOneNet;
        }
        self.selectedBtn = sender;
        self.sureBtnEnabled = YES; // 确认按钮可使用
    }else {
        self.sureBtnEnabled = NO; // 确认按钮不可使用
    }
    if ([self.delegate respondsToSelector:@selector(payWayView:clickedOtherBtn:method:)]) {
        [self.delegate payWayView:self clickedOtherBtn:sender method:method];
    }
}

// 确认支付
- (void)surePayAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(payWayView:clickedSureWithBtn:)]) {
        [self.delegate payWayView:self clickedSureWithBtn:btn];
    }
}

#pragma mark -- other
- (void)chooseOtherMethodMessage:(NSString *)message Show:(BOOL)show
{
    self.message.hidden = !show;
    self.message.frame = CGRectMake(15 * W_ABCW, _accountView.viewBottomEdge, self.viewWidth - 30 * W_ABCW, 25 * W_ABCW);
    self.message.text = message;
    [self.message sizeToFit];
    self.message.viewSize = CGSizeMake(self.message.viewWidth, self.message.viewHeight + 12 * W_ABCW);
    self.message.center = CGPointMake(self.viewWidth / 2, self.message.center.y);
    [self layoutSubviews];
}

- (void)allOtherMethodBtnNormal:(BOOL)normal
{
    if (normal) {
        self.selectedBtn.selected = NO;
    }
}

#pragma mark -- private
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.isAPay) {
        self.totalView.frame = CGRectMake(0, _accountView.viewBottomEdge + 5 * W_ABCW, self.viewWidth, self.totalView.viewHeight);
    }else {
        if (self.message.hidden) {
            self.methodView.frame = CGRectMake(0, _accountView.viewBottomEdge, self.viewWidth, self.methodView.viewHeight);
        }else {
            self.methodView.frame = CGRectMake(0, self.message.viewBottomEdge, self.viewWidth, self.methodView.viewHeight);
        }
        self.totalView.frame = CGRectMake(0, _methodView.viewBottomEdge + 5 * W_ABCW, self.viewWidth, self.totalView.viewHeight);
    }
    self.scrollView.contentSize = CGSizeMake(self.viewWidth, _totalView.viewBottomEdge + 10);
}
@end
