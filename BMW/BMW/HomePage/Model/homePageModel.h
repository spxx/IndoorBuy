//
//  homePageModel.h
//  BMW
//
//  Created by rr on 16/3/4.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "MTLModel.h"

@interface homePageModel : MTLModel
/**
 * 商品ID;
 */
@property(nonatomic,copy)NSString * gc_id;
/**
 * 商品名称
 */
@property(nonatomic,copy)NSString * gc_name;
/**
 * 商品数组
 */
@property(nonatomic,copy)NSString * goods_array;



-(id)initWithJsonObject:(NSDictionary *)jsonObject;


@end
