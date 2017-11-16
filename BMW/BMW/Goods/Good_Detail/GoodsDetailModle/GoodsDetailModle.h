//
//  GoodsDetailModle.h
//  BMW
//
//  Created by gukai on 16/2/25.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "MTLModel.h"
#import "GoodsInfoModle.h"
@interface GoodsDetailModle : MTLModel
/**
 * 当前商品信息 json字符串
 */
@property(nonatomic,copy)NSString * goods_info;
/**
 * 商品图片 json字符串
 */
@property(nonatomic,copy)NSString * goods_image;
/**
 * 商品缩略图 json字符串
 */
@property(nonatomic,copy)NSString * goods_image_mobile;
/**
 * 其他规格对应ID json字符串
 */
@property(nonatomic,copy)NSString * spec_list_mobile;
/**
 * 其他规格图片 json字符串
 */
@property(nonatomic,copy)NSString * spec_image;
/**
 * 判断用户是否收藏
 */
@property(nonatomic,copy)NSString * isCollection;

@property(nonatomic,copy)NSArray * parameter;

-(id)initWithJsonObject:(NSDictionary *)jsonObject;


/**
 *  把 good_info 的 json 字符串转成 GoodsInfoModle
 *  @param goods_info:传入属性 goods_info
 */
-(GoodsInfoModle *)modleFormGoods_Info_Str;


/**
 获取物品信息详情
 
 @param dic      物品id
 @param complete 返回物品属性
 */
+(void)goodsDetailInfoWithDic:(NSDictionary *)dic complete:(void(^)(BOOL success, NSString * str,NSDictionary * data))complete;

/**
 购物车数量

 @param complete 购物车数量
 */
+(void)shopCarNumWithComplete:(void(^)(BOOL success,NSString * str))complete;

/**
 VIP信息获取

 @param complete 是否已经是Vip
 */
+(void)getVipInfoWithComplete:(void(^)(BOOL success,NSString * str,NSDictionary *data))complete;

/**
 激活vip

 @param complete vip
 */
+(void)ReActivateVipWithComplete:(void(^)(BOOL success,NSString *str,NSDictionary *data))complete;

/**
 取消收藏
 
 @param complete
 */
+(void)collectionedWithDic:(NSDictionary *)dic andComplete:(void(^)(BOOL success))complete;

/**
 收藏
 @param dic 商品id
 @param complete 收藏
 */
+(void)addcollectionWithDic:(NSDictionary *)dic andComplete:(void(^)(BOOL success))complete;

/**
 加入购物车
 
 @param goodsID  商品ID
 @param num      商品数量
 @param complete 
 */
+(void)addToCartWithGoodsID:(NSString *)goodsID andGoodsNum:(NSString *)num andComplete:(void(^)(BOOL success,NSString * str))complete;




@end
