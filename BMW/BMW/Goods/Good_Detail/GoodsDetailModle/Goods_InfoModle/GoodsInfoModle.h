//
//  GoodsInfoModle.h
//  BMW
//
//  Created by gukai on 16/2/25.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "MTLModel.h"

@interface GoodsInfoModle : MTLModel
/**
 * 当前商品公共表ID
 */
@property(nonatomic,copy)NSString * goods_commomid;
/**
 * 商品名称
 */
@property(nonatomic,copy)NSString * goods_name;
/**
 * 商品广告语
 */
@property(nonatomic,copy)NSString * goods_jingle;
/**
 * 商品分类ID
 */
@property(nonatomic,copy)NSString * gc_id;
/**
 * 商品分类名
 */
@property(nonatomic,copy)NSString * gc_name;
/**
 * 商品产地ID
 */
@property(nonatomic,copy)NSString * origin_id;
/**
 * 产地名称
 */
@property(nonatomic,copy)NSString * origin_name;
/**
 * 店铺ID
 */
@property(nonatomic,copy)NSString * store_id;
/**
 * 店铺名称
 */
@property(nonatomic,copy)NSString * store_name;
/**
 * 规格名称
 */
@property(nonatomic,copy)NSString * spec_name;
/**
 * 规格参数
 */
@property(nonatomic,copy)NSString * spec_value;
/**
 * 品牌ID
 */
@property(nonatomic,copy)NSString * brand_id;
/**
 * 品牌名称
 */
@property(nonatomic,copy)NSString * brand_name;
/**
 * 类型ID
 */
@property(nonatomic,copy)NSString * type_id;
/**
 * 商品参数 json字符串
 */
@property(nonatomic,copy)NSString * goods_attr;
/**
 * 商品描述
 */
@property(nonatomic,copy)NSString * goods_body;
/**
 * 商品状态(待定)
 */
@property(nonatomic,copy)NSString * good_state;
/**
 * 商品状态描述(待定)
 */
@property(nonatomic,copy)NSString * goods_stateremark;
/**
 * 商品核实(待定)
 */
@property(nonatomic,copy)NSString * goods_verify;
/**
 * 商品核实描述(待定)
 */
@property(nonatomic,copy)NSString * goods_verifyremark;
/**
 * 商品添加时间
 */
@property(nonatomic,copy)NSString * goods_addtime;
/**
 * 商品修改时间
 */
@property(nonatomic,copy)NSString * goods_edittime;
/**
 * 商品价格
 */
@property(nonatomic,copy)NSString * goods_price;
/**
 * 商品市场价格
 */
@property(nonatomic,copy)NSString * goods_marketprice;
/**
 * vip价格
 */
@property(nonatomic,copy)NSString * goods_vip_price;
/**
 * 商品成本价格
 */
@property(nonatomic,copy)NSString * goods_costprice;
/**
 * 商品折扣
 */
@property(nonatomic,copy)NSString * goods_discount;
/**
 * 商品分期(待定)
 */
@property(nonatomic,copy)NSString * goods_serial;
/**
 * 运费模板ID
 */
@property(nonatomic,copy)NSString * transport_id;
/**
 * 运费模板名称(待定)
 */
@property(nonatomic,copy)NSString * transport_title;
/**
 * 商品推荐 1是，0否，默认0
 */
@property(nonatomic,copy)NSString * goods_commend;
/**
 * 运费
 */
@property(nonatomic,copy)NSString * goods_freight;
/**
 * 是否开具增值发票税
 */
@property(nonatomic,copy)NSString * goods_vat;
/**
 * 一级地区ID
 */
@property(nonatomic,copy)NSString * areaid_1;
/**
 * 二级地区ID
 */
@property(nonatomic,copy)NSString * areaid_2;
/**
 * 店铺分类ID,首尾用,隔开
 */
@property(nonatomic,copy)NSString * goods_stcids;
/**
 * 是否限时
 */
@property(nonatomic,copy)NSDictionary * p_tejia;
/**
 * 是否满赠满减
 */
@property(nonatomic,copy)NSDictionary * p_mansong;
/**
 * (待定)
 */
@property(nonatomic,copy)NSString * plateid_top;
/**
 * (待定)
 */
@property(nonatomic,copy)NSString * plateid_bottom;
/**
 * 是否新货(待定)
 */
@property(nonatomic,copy)NSString * is_new;
/**
 * (待定)
 */
@property(nonatomic,copy)NSString * platform;
/**
 * 商品ID
 */
@property(nonatomic,copy)NSString * goods_id;
/**
 * 商品点击数
 */
@property(nonatomic,copy)NSString * goods_click;
/**
 * 商品销售总量
 */
@property(nonatomic,copy)NSString * goods_salenum;
/**
 * 商品收藏总量
 */
@property(nonatomic,copy)NSString * goods_collect;
/**
 * 当前商品规格 json字符串
 */
@property(nonatomic,copy)NSString * goods_spec;
/**
 * 商品库存
 */
@property(nonatomic,copy)NSString * goods_storage;
/**
 * 颜色模板ID
 */
@property(nonatomic,copy)NSString * color_id;
/**
 * 好评星级
 */
@property(nonatomic,copy)NSString * evaluation_good_star;
/**
 * 评论数
 */
@property(nonatomic,copy)NSString * evaluation_count;
/**
 * SKU编码
 */
@property(nonatomic,copy)NSString * sku_num;
/**
 * 发货方式
 */
@property(nonatomic,copy)NSString * send_type;
/**
 * 发货仓代码
 */
@property(nonatomic,copy)NSString * send_code;
/**
 * 国际代码
 */
@property(nonatomic,copy)NSString * intnational_num;
/**
 * 产地国家图片url
 */
@property(nonatomic,copy)NSString * originImage;



-(id)initWithJsonObject:(NSDictionary *)jsonObject;
@end
