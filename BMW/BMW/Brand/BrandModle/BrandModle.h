//
//  BrandModle.h
//  BMW
//
//  Created by gukai on 16/2/24.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "MTLModel.h"

@interface BrandModle : MTLModel
/**
 *  品牌ID
 */
@property(nonatomic,copy)NSString * brand_id;
/**
 *  品牌名
 */
@property(nonatomic,copy)NSString * brand_name;
/**
 *  品牌分类名
 */
@property(nonatomic,copy)NSString * brand_class;
/**
 *  所属分类ID
 */
@property(nonatomic,copy)NSString * class_id;
/**
 *  图片地址
 */
@property(nonatomic,copy)NSString * brand_pic;

-(id)initWithJsonObject:(NSDictionary *)jsonObject;
@end
