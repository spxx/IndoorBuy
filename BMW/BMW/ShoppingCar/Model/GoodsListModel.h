//
//  GoodsListModel.h
//  BMW
//
//  Created by LiuP on 2016/10/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsModel.h"
@class GoodsListModel;

typedef enum{
    ActivityNone,           /**< 没的活动 */
    Activity,
    ActivityCutAndGift,     /**< 满减满送 */
    ActivitySpecialPrice,   /**< 限时特价 */
}ActivityType;

typedef void(^FinshCarPrice)(BOOL success, NSMutableArray * models, GoodsListModel * model, NSString * msg);

@interface GoodsListModel : NSObject

@property (nonatomic, assign) ActivityType activity;    /**< 活动类型 */
@property (nonatomic, copy) NSString * actContent;      /**< 活动描述 */
@property (nonatomic, copy) NSString * actLabel;        /**< 活动标签 */
@property (nonatomic, copy) NSString * actID;           /**< 查看更多使用的ID */
@property (nonatomic, strong) NSMutableArray<GoodsModel *> * goodsModels; /**< 商品数据模型 */

// 底部价格
@property (nonatomic, copy) NSString * totalCash;       /**< 合计 */
@property (nonatomic, copy) NSString * saveCash;        /**< 节省 */
@property (nonatomic, copy) NSString * beVipSave;       /**< vip再省 */

/**
 购物车管理
 
 @param complete
 */
+ (void)requsetForCarManageWithSelectedGoods:(NSMutableArray *)selectedGoods Complete:(void(^)(NSInteger code, NSMutableArray * models, GoodsListModel * price, NSString * msg))complete;

/**
 获取购物车数目
 
 @param complete
 */
+ (void)requestForCarNumWithComplete:(void(^)(BOOL success, NSString * carNum))complete;

/**
 编辑购物车
 
 @param model
 @param goodsNum
 @param complete
 */
+ (void)requestForEditCarListWithGoodsModel:(GoodsModel *)model
                                   goodsNum:(NSString *)goodsNum
                                   Complete:(void(^)(BOOL success, NSString * msg))complete;

/**
 删除购物车商品
 
 @param selectedGoods
 @param complete
 */
+ (void)requsetForDeleteSelectedGoods:(NSMutableArray *)selectedGoods complete:(void(^)(BOOL success, NSString * msg))complete;
//
///**
// 计算价格
//
// @param selectedGoods
// @param complete
// */
//+ (void)requestForCarCashWithSelectedGoods:(NSMutableArray *)selectedGoods
//                              originModels:(NSMutableArray *)originModels
//                                  complete:(FinshCarPrice)complete;

@end
