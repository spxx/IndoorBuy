//
//  GoodsModel.h
//  BMW
//
//  Created by LiuP on 2016/10/29.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject

@property (nonatomic, copy) NSString * goodsID;
@property (nonatomic, copy) NSString * carID;           /**< 购物车ID */
@property (nonatomic, copy) NSString * goodsImage;
@property (nonatomic, copy) NSString * goodsName;
@property (nonatomic, copy) NSString * goodsNum;        /**< 商品数量 */
@property (nonatomic, copy) NSString * normalPrice;     /**< 普通价 */
@property (nonatomic, copy) NSString * vipPrice;        /**< 麦咖价 */
@property (nonatomic, copy) NSString * standard;        /**< 规格 */
@property (nonatomic, copy) NSString * storeID;         /**< 店铺ID */
@property (nonatomic, copy) NSString * storeName;       /**< 店铺名称 */
@property (nonatomic, copy) NSString * origin;          /**< 来源 */
@property (nonatomic, copy) NSString * originCode;      /**< 来源标识 */
@property (nonatomic, assign) BOOL selected;            /**< 选中的商品 */


@property (nonatomic, assign) BOOL isGift;              /**< 是否是赠品 */


/**
 非赠品

 @param dic

 @return
 */
- (instancetype)initWithDic:(NSDictionary *)dic;

/**
 赠品

 @param gift

 @return 
 */
- (instancetype)initWithGift:(NSDictionary *)gift;

@end
