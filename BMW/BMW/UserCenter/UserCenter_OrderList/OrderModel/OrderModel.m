//
//  OrderModel.m
//  BMW
//
//  Created by rr on 16/2/18.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

-(id)initWithJsonObject:(NSDictionary *)jsonObject{
    if (self = [super init]) {
        self.order_id = [jsonObject objectForKeyNotNull:@"order_id"];
        self.order_sn = [jsonObject objectForKeyNotNull:@"order_sn"];
        self.pay_sn   = [jsonObject objectForKeyNotNull:@"pay_sn"];
        self.buyer_id = [jsonObject objectForKeyNotNull:@"buyer_id"];
        self.buyer_name = [jsonObject objectForKeyNotNull:@"buyer_name"];
        self.payment_time = [jsonObject objectForKeyNotNull:@"payment_time"];
        self.finnshed_time = [jsonObject objectForKeyNotNull:@"finnshed_time"];
        self.evaluation_state = [jsonObject objectForKeyNotNull:@"evaluation_state"];
        self.add_time = [jsonObject objectForKeyNotNull:@"add_time"];
        self.payment_code = [jsonObject objectForKeyNotNull:@"payment_code"];
        self.goods_amount = [jsonObject objectForKeyNotNull:@"goods_amount"];
        self.order_amount = [jsonObject objectForKeyNotNull:@"order_amount"];
        self.shipping_fee = [jsonObject objectForKeyNotNull:@"shipping_fee"];
        self.shipping_code = [jsonObject objectForKeyNotNull:@"shipping_code"];
        self.order_state  = [jsonObject objectForKeyNotNull:@"order_state"];
        self.order_type   = [jsonObject objectForKeyNotNull:@"order_type"];
        self.goods = [jsonObject objectForKeyNotNull:@"goods"];
        
    }
    return self;
}
@end
