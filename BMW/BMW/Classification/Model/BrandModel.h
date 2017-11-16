//
//  BrandModel.h
//  BMW
//
//  Created by LiuP on 2016/12/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^BrandCallBack)(BOOL success, NSString * message, NSMutableArray * models);

@interface BrandModel : NSObject

@property (nonatomic, copy) NSString * brandName;
@property (nonatomic, copy) NSString * brandID;
@property (nonatomic, copy) NSString * brandPic;
@property (nonatomic, copy) NSString * brandClass;  /**< 品牌所属分类名字 */
@property (nonatomic, copy) NSString * classID;  /**< 品牌所属分类ID */

@property (nonatomic, copy) NSString * pinYin;  /**< 品牌名字的全拼，用于排序 */

/**
 获取一级分类下的品牌信息
 
 @param firstClassID
 @param complete
 */
+ (void)requestForBrandListWithFirstClassID:(NSString *)firstClassID Complete:(void(^)(BOOL success, NSString * message, NSMutableArray * models, NSMutableArray * indexs))complete;

/**
 获取一级分类下的热销品牌信息

 @param firstClassID
 @param complete
 */
+ (void)requestForHotBrandWithFirstClassID:(NSString *)firstClassID Complete:(BrandCallBack)complete;
@end
