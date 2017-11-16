//
//  GoodsModel.m
//  BMW
//
//  Created by LiuP on 2016/10/29.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        NSString * goodsImage = [dic objectForKeyNotNull:@"goods_image"];
        if (![goodsImage hasPrefix:@"http"]) {
            self.goodsImage = IMAGE_URL(goodsImage);
        }else {
            self.goodsImage = goodsImage;
        }
        //规格
        id object = [dic objectForKeyNotNull:@"goods_spec"];
        NSString * standard;
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary * standardDic = (NSDictionary *)object;
            NSString * tempStr = @"";
            for (NSString * key in standardDic.allKeys) {
                tempStr = [tempStr stringByAppendingFormat:@"%@；", [standardDic objectForKeyNotNull:key]];
            }
            if ([tempStr hasSuffix:@"；"]) {
                tempStr = [tempStr substringToIndex:tempStr.length -1];
            }
            standard = [NSString stringWithString:tempStr];
        }else {
            standard = (NSString *)object;
        }
        // 占位
        if (standard.length == 0) {
            standard = @" ";
        }
        self.standard = standard;
        // 商品基本信息
        self.carID          = [dic objectForKeyNotNull:@"cart_id"];
        self.goodsID        = [dic objectForKeyNotNull:@"goods_id"];
        self.goodsName      = [dic objectForKeyNotNull:@"goods_name"];
        self.goodsNum       = [dic objectForKeyNotNull:@"goods_num"];
        self.storeName      = [dic objectForKeyNotNull:@"store_name"];
        self.storeID        = [dic objectForKeyNotNull:@"store_id"];
        self.origin         = [dic objectForKeyNotNull:@"send_type"];
        self.normalPrice    = [[dic objectForKeyNotNull:@"tejia_price"] length]>0?[dic objectForKeyNotNull:@"tejia_price"]:[dic objectForKeyNotNull:@"goods_price"];
        self.vipPrice       = [[dic objectForKeyNotNull:@"tejia_price_vip"] length]>0?[dic objectForKeyNotNull:@"tejia_price_vip"]:[dic objectForKeyNotNull:@"goods_vip_price"];
        self.vipPrice = [self.vipPrice length]>0?self.vipPrice:@"0.00";
        //麦咖专享返现
        if (([self.normalPrice floatValue] - [self.vipPrice floatValue])>0) {
            self.vipPrice = [NSString stringWithFormat:@"%.2f",([self.normalPrice floatValue] - [self.vipPrice floatValue])];
        }else{
            self.vipPrice = @"0.00";
        }
        if ([dic objectForKeyNotNull:@"t_p_v"]) {
            if (([self.normalPrice floatValue] - [[dic objectForKeyNotNull:@"t_p_v"] floatValue])>0) {
                self.vipPrice = [NSString stringWithFormat:@"%.2f",([self.normalPrice floatValue] - [[dic objectForKeyNotNull:@"t_p_v"] floatValue])];
            }else{
                self.vipPrice = @"0.00";
            }
        }
        self.originCode     = [[dic objectForKeyNotNull:@"send_code"] uppercaseString];
        self.selected       = NO;
        self.isGift         = NO;
        
    }
    return self;
}

- (instancetype)initWithGift:(NSDictionary *)gift
{
    self = [super init];
    if (self) {
        self.goodsID    = [gift objectForKeyNotNull:@"goods_id"];
        NSString * goodsImage = [gift objectForKeyNotNull:@"goods_image"];
        if (![goodsImage hasPrefix:@"http"]) {
            self.goodsImage = IMAGE_URL(goodsImage);
        }else {
            self.goodsImage = goodsImage;
        }
        self.goodsName      = [gift objectForKeyNotNull:@"goods_name"];
        self.normalPrice    = @"0.00";
        self.vipPrice       = self.normalPrice;
        self.goodsNum       = [gift objectForKeyNotNull:@"goods_num"];
        self.origin         = [gift objectForKeyNotNull:@"send_type"];
        self.originCode     = [[gift objectForKeyNotNull:@"send_code"] uppercaseString];
        self.standard       = @" ";
        self.selected       = NO;
        self.isGift         = YES;
    }
    return self;
}

@end
