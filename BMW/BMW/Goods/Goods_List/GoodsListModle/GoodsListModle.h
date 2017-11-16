//
//  GoodsListModle.h
//  BMW
//
//  Created by gukai on 16/2/25.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "MTLModel.h"

@interface GoodsListModle : MTLModel

/**
 * 商品ID;
 */
@property(nonatomic,copy)NSString * goods_id;
/**
 * 商品名称
 */
@property(nonatomic,copy)NSString * goods_name;
/**
 * 商品广告语
 */
@property(nonatomic,copy)NSString * goods_jingle;
/**
 * 店铺名称
 */
@property(nonatomic,copy)NSString * stroe_name;
/**
 * 分类ID
 */
@property(nonatomic,copy)NSString * gc_id;
/**
 * 商品价格
 */
@property(nonatomic,copy)NSString * goods_price;
/**
 * 商品市场价
 */
@property(nonatomic,copy)NSString * goods_marketprice;
/**
 * 商品浏览数
 */
@property(nonatomic,copy)NSString * goods_click;
/**
 * 商品销量
 */
@property(nonatomic,copy)NSString * goods_salenum;
/**
 * 收藏数
 */
@property(nonatomic,copy)NSString * goods_collect;
/**
 * 库存
 */
@property(nonatomic,copy)NSString * goods_storage;
/**
 * 商品图片
 */
@property(nonatomic,copy)NSString * goods_image;
/**
 * 商品添加时间
 */
@property(nonatomic,copy)NSString * goods_addtime;
/**
 * 商品修改时间
 */
@property(nonatomic,copy)NSString * goods_edittime;
/**
 * 商品推荐 1是，0否，默认0
 */
@property(nonatomic,copy)NSString * goods_commend;
/**
 * 好评星级
 */
@property(nonatomic,copy)NSString * evaluation_good_star;
/**
 * 评论数
 */
@property(nonatomic,copy)NSString * evaluation_count;





-(id)initWithJsonObject:(NSDictionary *)jsonObject;
@end
