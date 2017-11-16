//
//  OrderList.h
//  BMW
//
//  Created by rr on 16/2/18.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "MTLModel.h"

@interface OrderList : MTLModel
/*
 *订单ID
 */
@property(nonatomic,strong) NSString *order_id;
/*
 *订单号
 */
@property(nonatomic,strong) NSString *order_sn;
/*
 *支付号
 */
@property(nonatomic,strong) NSString *pay_sn;
/*
 *购买者ID
 */
@property(nonatomic,strong) NSString *buyer_id;
/*
 *购买者名字
 */
@property(nonatomic,strong) NSString *buyer_name;
/*
 *订单生成时间
 */
@property(nonatomic,strong) NSString *add_time;
/*
 *是否评价
 *0未评价、1已评价
 */
@property(nonatomic,strong) NSString *evaluation_state;
/*
 *商品总价格
 */
@property(nonatomic,strong) NSString *goods_amount;
/*
 *订单总价格
 */
@property(nonatomic,strong) NSString *order_amount;
/*
 *运费
 */
@property(nonatomic,strong) NSString *shipping_fee;
/*
 *订单状态
 *0已取消、10(默认)未付款、20已付款、30已发货、40已收货
 */
@property(nonatomic,strong) NSString *order_state;
/*
 *物流单号
 */
@property(nonatomic,strong) NSString *shipping_code;
/*
 *订单类型
 *0普通类型、1秒杀订单、2特卖订单、3员工订单
 */
@property(nonatomic,strong) NSString *order_type;

-(id)initWithJsonObject:(NSDictionary *)jsonObject;

@end
