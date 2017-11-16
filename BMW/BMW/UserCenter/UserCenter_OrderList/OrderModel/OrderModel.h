//
//  OrderModel.h
//  BMW
//
//  Created by rr on 16/2/18.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "MTLModel.h"

@interface OrderModel : MTLModel
/*
 *订单ID
 */
@property(nonatomic,strong) NSString *order_id;
/*
 *订单编号
 */
@property(nonatomic,strong) NSString *order_sn;
/*
 *支付编号
 */
@property(nonatomic,strong) NSString *pay_sn;
/*
 *用户编号
 */
@property(nonatomic,strong) NSString *buyer_id;
/*
 *支付时间
 */
@property(nonatomic,strong) NSString *payment_time;
/*
 *订单完成时间
 */
@property(nonatomic,strong) NSString *finnshed_time;
/*
 *用户邮箱
 */
@property(nonatomic,strong) NSString *buyer_email;
/*
 *用户名
 */
@property(nonatomic,strong) NSString *buyer_name;
/*
 *是否评价
 *0未评价、1已评价
 */
@property(nonatomic,strong) NSString *evaluation_state;
/*
 *新增时间
 */
@property(nonatomic,strong) NSString *add_time;
/*
 *支付方式名称代码
 */
@property(nonatomic,strong) NSString *payment_code;
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
 *物流单号
 */
@property(nonatomic,strong) NSString *shipping_code;
/*
 *订单状态
 *0已取消、10(默认)未付款、20已付款、30已发货、40已收货
 */
@property(nonatomic,strong) NSString *order_state;
/*
 *订单类型
 *0普通类型、1秒杀订单、2特卖订单、3员工订单
 */
@property(nonatomic,strong) NSString *order_type;
/*
 *订单下商品
 *商品ID goods_id 商品名称 goods_name 商品价格 goods_price 商品购买数量 goods_num
 *商品支付价格 goods_pay_price
 *购买商品途径
 *1默认、2团购商品、3限时折扣商品、4组合套装、5赠品
 *促销活动ID(团购ID/限时折扣ID/优惠套装ID)promotions_id与goods_type搭配使用
 *商品缩略图 goods_image
 */
@property(nonatomic,strong) NSArray *goods;


-(id)initWithJsonObject:(NSDictionary *)jsonObject;

@end
