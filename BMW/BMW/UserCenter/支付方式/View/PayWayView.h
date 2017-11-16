//
//  PayMethodView.h
//  BMW
//
//  Created by LiuP on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PayWayView;

typedef enum{
    PayNone,
    PayWX,      /**< 微信 */
    PayAlipay,  /**< 支付宝 */
    PayOneNet,  /**< 一网通 */
    PayAPay,    /**< 通联支付 */
}PayWay;

@protocol PayWayViewDelegate <NSObject>

@optional

/**
 点击了账户资金

 @param payWayView
 @param btn
 */
- (void)payWayView:(PayWayView *)payWayView clickedAccountWithBtn:(UIButton *)btn;

/**
 选择了其他支付方式

 @param payWayView
 @param btn
 */
- (void)payWayView:(PayWayView *)payWayView clickedOtherBtn:(UIButton *)btn method:(PayWay)method;

/**
 点击确认支付

 @param payWayView
 @param btn
 */
- (void)payWayView:(PayWayView *)payWayView clickedSureWithBtn:(UIButton *)btn;

@end

@interface PayWayView : UIView

@property (nonatomic, assign) id<PayWayViewDelegate> delegate;
@property (nonatomic, copy) NSString * total;     /**< 支付总金额 */
@property (nonatomic, copy) NSString * orderCreatTime;     /**< 下单时间 */
@property (nonatomic, copy) NSString * orderNumber;      /**< 订单编号 */
@property (nonatomic, copy) NSString * personCash;          /**< 账户资金可用余额 */
@property (nonatomic, strong) UIButton * accountBtn;        /**< 账户资金的按钮 */
@property (nonatomic, strong) UIButton * bigAccountBtn; /**< 账户资金按钮，整行可点 */
@property (nonatomic, assign) BOOL sureBtnEnabled;          /**< 确认按钮是否可以使用 */
@property (nonatomic, assign) BOOL isFreezed;       /**< 此订单已经存在冻结的余额 */
@property (nonatomic, assign) BOOL hideAccount;     /**< 是否隐藏账户资金 */


/**
 

 @param frame
 @param oneNet 是否只显示一网通
 @return
 */
- (instancetype)initWithFrame:(CGRect)frame oneNet:(BOOL)oneNet;

/**
 是否显示提示使用其他支付方式
 */
- (void)chooseOtherMethodMessage:(NSString *)message
                            Show:(BOOL)show;


/**
 其他支付方式按钮状态

 @param normal 
 */
- (void)allOtherMethodBtnNormal:(BOOL)normal;
@end
