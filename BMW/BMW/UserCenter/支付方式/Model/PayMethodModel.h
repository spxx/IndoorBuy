//
//  PayMethodModel.h
//  BMW
//
//  Created by LiuP on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayMethodModel : NSObject
/********一网通数据********/
@property (nonatomic, retain) NSDictionary * oneNetData;
@property (nonatomic, copy) NSString * date;
@property (nonatomic, copy) NSString * dateTime;
/********余额支付检查与冻结余额********/
@property (nonatomic, copy) NSString * pdAmount;    /**< 用余额支付的金额 */
@property (nonatomic, copy) NSString * amount;      /**< 还剩多少需要支付 */
/********订单详情信息********/
@property (nonatomic, copy) NSString * personCash;  /**< 用户余额 */
@property (nonatomic, copy) NSString * freezedCash; /**< 已支付的金额（冻结的金额） */
@property (nonatomic, copy) NSString * payCode;     /**< 订单使用过的支付方式 */

/**
 余额支付 检查
 
 @param paySn
 @param complete  支付金额
 */
+ (void)requestForUserMoneyWithPaySn:(NSString *)paySn
                            password:(NSString *)password
                               money:(NSString *)money
                            complete:(void(^)(BOOL isSuccess, PayMethodModel * model, NSString * message))complete;

/**
 订单详情

 @param orderID
 @param complete 
 */
+ (void)requestForOrderDetailWithOrderID:(NSString *)orderID complete:(void(^)(BOOL isSuccess, PayMethodModel * model, NSString * message))complete;

/**
 预支付

 @param paySn
 @param type 1:单独支付 2:混合支付
 @param payCode  支付宝alipay 一网通pwdpay 微信wxpay 支付predeposit , 多个以逗号隔开
 @param complete
 */
+ (void)requestForMemberPayWithPaySn:(NSString *)paySn
                                type:(NSString *)type
                             payCode:(NSString *)payCode
                            complete:(void(^)(BOOL isSuccess, PayMethodModel * model, NSString * message))complete;


/**
 微信支付
 
 @param paraDic
 @param complete
 */
+ (void)requestForWXPayWithParaDic:(NSDictionary *)paraDic complete:(void(^)(BOOL isSuccess, NSDictionary * data, NSString * message))complete;

/**
 招行一卡通
 
 @param amount
 @param orderSn
 @param complete
 */
+ (void)requestForOneNetWithAmount:(NSString *)amount
                           orderSn:(NSString *)orderSn
                          complete:(void(^)(BOOL isSuccess, PayMethodModel * model, NSString * message))complete;

/**
 验证交易密码
 
 @param password
 @param complete
 */
+ (void)requestForVerifyWithPassword:(NSString *)password complete:(void(^)(BOOL isSuccess, NSString * message))complete;
@end
