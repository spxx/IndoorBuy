//
//  GoodsListModle.m
//  BMW
//
//  Created by gukai on 16/2/25.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "GoodsListModle.h"

@implementation GoodsListModle
-(id)initWithJsonObject:(NSDictionary *)jsonObject
{
    self = [super init];
    if (self) {
        self.goods_id = [jsonObject objectForKeyNotNull:@"goods_id"];
        self.goods_name = [jsonObject objectForKeyNotNull:@"goods_name"];
        self.goods_jingle = [jsonObject objectForKeyNotNull:@"goods_jingle"];
        self.stroe_name = [jsonObject objectForKeyNotNull:@"stroe_name"];
        self.gc_id = [jsonObject objectForKeyNotNull:@"gc_id"];
        self.goods_price = [jsonObject objectForKeyNotNull:@"goods_price"];
        self.goods_marketprice = [jsonObject objectForKeyNotNull:@"goods_marketprice"];
        self.goods_click = [jsonObject objectForKeyNotNull:@"goods_click"];
        self.goods_salenum = [jsonObject objectForKeyNotNull:@"goods_salenum"];
        self.goods_collect = [jsonObject objectForKeyNotNull:@"goods_collect"];
        self.goods_storage = [jsonObject objectForKeyNotNull:@"goods_storage"];
        self.goods_image = [jsonObject objectForKeyNotNull:@"goods_image"];
        self.goods_addtime = [jsonObject objectForKeyNotNull:@"goods_addtime"];
        self.goods_edittime = [jsonObject objectForKeyNotNull:@"goods_edittime"];
        self.goods_commend = [jsonObject objectForKeyNotNull:@"goods_commend"];
        self.evaluation_good_star = [jsonObject objectForKeyNotNull:@"evaluation_good_star"];
        self.evaluation_count = [jsonObject objectForKeyNotNull:@"evaluation_count"];
       
    }
    return self;
}
@end
