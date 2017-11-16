//
//  HomePageM.h
//  BMW
//
//  Created by rr on 2016/12/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GoodsListModel.h"

@class HomePageModel;


typedef void(^Completed)(NSArray * models, NSString * message, NSInteger code);

typedef void(^AdCompleted)(NSArray * models, NSString * message, NSInteger code);


@interface HomePageM : NSObject
/**
 * 商品ID;
 */
@property(nonatomic,copy)NSString * gc_id;
/**
 * 商品分类名称
 */
@property(nonatomic,copy)NSString * gc_name;
/**
 * 原始商品数据
 */
@property (nonatomic, copy) NSString * goodsJsonStr;

/**
 *  广告列表
 */
@property (nonatomic, copy) NSArray * adverImageArray;


/**
 *  转化为商品Model的数据
 */
@property (nonatomic, copy) NSArray * goodsModels;

/**
 *  消息数据
 */
@property (nonatomic, copy) NSArray * newsArray;
/**************店铺logo相关****************/
@property (nonatomic, assign) NSInteger drp;        /**< drp为1 分销商不能跳转到店铺 */
@property (nonatomic, copy) NSString * storeLogo;   /**< 店铺logo头像 */
@property (nonatomic, copy) NSString * storeID;     /**< 展示店铺信息的ID */
@property (nonatomic, assign) NSInteger storeType;  /**< 1：跳转到帮麦体验店 2：跳转到storeID对应的店铺 */



/**
 获取店铺logo

 @param complete 
 */
+ (void)requestForStoreLogoWithComplete:(void(^)(HomePageM * model))complete;

/**
 获取商品列表

 @param complete
 */
+ (void)requestForGoodsListWithComplete:(Completed)complete;

/**
 获取广告

 @param adcomplete
 */
+ (void)requestForAdverListWithComplete:(AdCompleted)adcomplete;

/**
 *是否有消息
 */
+ (void)requestForNews:(void(^)(BOOL))finished;
/**
 *
 */
+ (void)requestGetNewsArray:(void (^)(NSArray *))finished;



/**
 获取消息（滚动广告的公告文本）
 
 @param ID
 @param complete
 */
+ (void)requestForMessageWithID:(NSString *)ID complete:(void(^)(BOOL isSuccess, NSString * text, NSString * message))complete;



/**
 *刷新 价格
 */
+ (void)requestForGoodsListWithKey:(NSString *)key andPrice:(NSString *)price Complete:(Completed)complete;

/**
 *刷新 销量
 */
+ (void)requestForGoodsListWithKey:(NSString *)key Complete:(Completed)complete;

/**
 *获取更多关键字搜索 价格
 */
+ (void)requestForGoodsListWith:(NSArray *)models andKey:(NSString *)key andPrice:(NSString *)price Complete:(Completed)complete;

/**
 *获取更多关键字搜索 销量
 */
+ (void)requestForGoodsListWith:(NSArray *)models andKey:(NSString *)key Complete:(Completed)complete;


@end
