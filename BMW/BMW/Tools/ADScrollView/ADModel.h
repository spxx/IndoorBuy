//
//  ADModel.h
//  Custom
//
//  Created by LiuP on 16/6/8.
//  Copyright © 2016年 LiuP. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ADModel;


typedef void(^CompleteBlock)(NSMutableArray<ADModel *> * models, NSString * message, NSInteger code);
typedef void(^Complete)(BOOL isSuccess, NSMutableArray * models, NSString * message);
@interface ADModel : NSObject
/************ 轮播图 *************/
@property (nonatomic, copy) NSString * imageUrl;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * sort;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * link;     /**< 商品详情 */
@property (nonatomic, copy) NSString * adClass;
@property (nonatomic, copy) NSString * classId;  /**< 品牌对应分类ID */
@property (nonatomic, copy) NSString * className; /**< 分类名 */
@property (nonatomic, copy) NSString * brandName; /**< 品牌名 */
@property (nonatomic, copy) NSString * platName; /**< 标签名 */
/*************快报信息****************/
@property (nonatomic, copy) NSString * messageID;       /**< 快报的ID */
@property (nonatomic, copy) NSString * title;           /**< 快报标题 */
@property (nonatomic, copy) NSString * name;            /**< 快报对应页面标题 */
@property (nonatomic, copy) NSString * messageUrl;      /**< 对应跳转链接和ID */
@property (nonatomic, copy) NSString * messageType;     /**<  1： message_url 为商品id； 2：分类id；3： 品牌id； 4：标签id；5：直接跳转到 公告文本  */

/**
 获取滚动广告数据
 
 @param complete
 */
+ (void)requestForRollADListWithComplete:(Complete)complete;



/**
 获取轮播图

 @param complete
 */
+ (void)adRequestWithComplete:(CompleteBlock)complete;



@end
