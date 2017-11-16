//
//  GoodsInfoModle.m
//  BMW
//
//  Created by gukai on 16/2/25.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "GoodsInfoModle.h"

@implementation GoodsInfoModle
-(id)initWithJsonObject:(NSDictionary *)jsonObject
{
    self = [super init];
    if (self) {
        self.goods_commomid = [NSString stringWithFormat:@"%@",[jsonObject objectForKeyNotNull:@"goods_commonid"]];
        self.goods_name = [jsonObject objectForKeyNotNull:@"goods_name"];
        self.goods_jingle = [jsonObject objectForKeyNotNull:@"goods_jingle"];
        self.gc_id = [jsonObject objectForKeyNotNull:@"gc_id"];
        self.gc_name = [jsonObject objectForKeyNotNull:@"gc_name"];
        self.origin_id = [jsonObject objectForKeyNotNull:@"origin_id"];
        self.origin_name = [jsonObject objectForKeyNotNull:@"origin_name"];
        self.store_id = [jsonObject objectForKeyNotNull:@"store_id"];
        self.store_name = [jsonObject objectForKeyNotNull:@"store_name"];
        self.spec_name = [jsonObject objectForKeyNotNull:@"spec_name"];
        self.spec_value = [jsonObject objectForKeyNotNull:@"spec_value"];
        self.brand_id = [jsonObject objectForKeyNotNull:@"brand_id"];
        self.brand_name = [jsonObject objectForKeyNotNull:@"brand_name"];
        self.type_id = [jsonObject objectForKeyNotNull:@"type_id"];
        self.goods_attr = [jsonObject objectForKeyNotNull:@"goods_attr"];
        self.goods_body = [jsonObject objectForKeyNotNull:@"goods_body"];
        self.good_state = [jsonObject objectForKeyNotNull:@"good_state"];
        self.goods_stateremark = [jsonObject objectForKeyNotNull:@"goods_stateremark"];
        self.goods_verify = [jsonObject objectForKeyNotNull:@"goods_verify"];
        self.goods_verifyremark = [jsonObject objectForKeyNotNull:@"goods_verifyremark"];
        self.goods_addtime = [jsonObject objectForKeyNotNull:@"goods_addtime"];
        self.goods_edittime = [jsonObject objectForKeyNotNull:@"goods_edittime"];
        self.goods_price = [jsonObject objectForKeyNotNull:@"goods_price"];
        self.goods_marketprice = [jsonObject objectForKeyNotNull:@"goods_marketprice"];
        self.goods_costprice = [jsonObject objectForKeyNotNull:@"goods_costprice"];
        self.goods_discount = [jsonObject objectForKeyNotNull:@"goods_discount"];
        self.goods_serial = [jsonObject objectForKeyNotNull:@"goods_serial"];
        self.transport_id = [jsonObject objectForKeyNotNull:@"transport_id"];
        self.transport_title = [jsonObject objectForKeyNotNull:@"transport_title"];
        self.goods_commend = [jsonObject objectForKeyNotNull:@"goods_commend"];
        self.goods_freight = [jsonObject objectForKeyNotNull:@"goods_freight"];
        self.goods_vat = [jsonObject objectForKeyNotNull:@"goods_vat"];
        self.areaid_1 = [jsonObject objectForKeyNotNull:@"areaid_1"];
        self.areaid_2 = [jsonObject objectForKeyNotNull:@"areaid_2"];
        self.goods_stcids = [jsonObject objectForKeyNotNull:@"goods_stcids"];
        self.plateid_top = [jsonObject objectForKeyNotNull:@"plateid_top"];
        self.plateid_bottom = [jsonObject objectForKeyNotNull:@"plateid_bottom"];
        self.p_tejia = [jsonObject objectForKeyNotNull:@"p_tejia"];
        self.p_mansong = [jsonObject objectForKeyNotNull:@"p_mansong"];
        self.is_new = [jsonObject objectForKeyNotNull:@"is_new"];
        self.platform = [jsonObject objectForKeyNotNull:@"platform"];
        self.goods_id = [jsonObject objectForKeyNotNull:@"goods_id"];
        self.goods_click = [jsonObject objectForKeyNotNull:@"goods_click"];
        self.goods_salenum = [jsonObject objectForKeyNotNull:@"goods_salenum"];
        self.goods_collect = [jsonObject objectForKeyNotNull:@"goods_collect"];
        self.goods_spec = [jsonObject objectForKeyNotNull:@"goods_spec"];
        self.goods_storage = [jsonObject objectForKeyNotNull:@"goods_storage"];
        self.color_id = [jsonObject objectForKeyNotNull:@"color_id"];
        self.evaluation_good_star = [jsonObject objectForKeyNotNull:@"evaluation_good_star"];
        self.evaluation_count = [jsonObject objectForKeyNotNull:@"evaluation_count"];
        self.sku_num = [jsonObject objectForKeyNotNull:@"sku_num"];
        self.send_type = [jsonObject objectForKeyNotNull:@"send_type"];
        self.send_code = [jsonObject objectForKeyNotNull:@"send_code"];
        self.intnational_num = [jsonObject objectForKeyNotNull:@"intnational_num"];
        self.goods_vip_price = [jsonObject objectForKeyNotNull:@"goods_vip_price"];
        self.originImage = [jsonObject objectForKeyNotNull:@"originImage"];

    }
    return self;
}

@end
