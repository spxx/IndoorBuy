//
//  OrderBottomButtonView.h
//  BMW
//
//  Created by 白琴 on 16/3/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderBottomButtonView : UIView
/**
 *  提醒发货
 */
@property (nonatomic, copy)void(^remindSendOutGoods)();
/**
 *  再次购买
 */
@property (nonatomic, copy)void(^buyAgain)();
/**
 *  取消订单
 */
@property (nonatomic, copy)void(^cancelOrder)();
/**
 *  删除订单
 */
@property (nonatomic, copy)void(^deleteOrder)();
/**
 *  退款退货
 */
@property (nonatomic, copy)void(^refundOrReturns)();
/**
 *  评价订单
 */
@property (nonatomic, copy)void(^evaluateOrder)();
/**
 *  支付
 */
@property (nonatomic, copy)void(^payOrder)();
/**
 *  确认收货
 */
@property (nonatomic, copy)void(^affirmReceiving)();

/**
 *  倒计时结束
 */
@property (nonatomic, copy)void(^countdownOver)();


/**
 *  订单信息的下方按钮视图
 *
 *  @param frame            大小 位置
 *  @param state            状态
 *  @param addOrderTime     下单时间
 *  @param ServerTime       服务时间
 */
- (instancetype)initWithFrame:(CGRect)frame state:(NSString *)state addOrderTime:(NSString *)addOrderTime evaluationState:(NSString *)evaluationState ServerTime:(NSString *)ServerTime;

@end
