//
//  ClassModel.h
//  BMW
//
//  Created by LiuP on 2016/12/6.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ClassCallBack)(BOOL success, NSString * message, NSMutableArray * models);

@interface ClassModel : NSObject
/*********** 一级分类信息 ************/
@property (nonatomic, copy) NSString * gcName;
@property (nonatomic, copy) NSString * gcImage;
@property (nonatomic, copy) NSString * gcID;
@property (nonatomic, assign) BOOL selected;
/*********** 二级分类信息 ************/
@property (nonatomic, copy) NSString * sectionName;
@property (nonatomic, copy) NSString * sectionID;
@property (nonatomic, strong) NSMutableArray * thirdModels;
@property (nonatomic, assign) NSInteger lines;
/*********** 三级分类信息 ************/
@property (nonatomic, copy) NSString * itemName;
@property (nonatomic, copy) NSString * itemID;
@property (nonatomic, copy) NSString * itemImage;
/*********** 顶部banner信息 ************/
@property (nonatomic, copy) NSString * bannerImage;
@property (nonatomic, copy) NSString * bannerUrl;
@property (nonatomic, copy) NSString * gcType;  /**< 1 为商品id   2为标签id  3 外部链接 */

/**
 一级分类信息
 
 @param complete
 */
+ (void)requestForGCFirstClassWithComplete:(ClassCallBack)complete;

/**
 获取一级分类下的二三级分类和banner信息

 @param GCID
 @param complete
 */
+ (void)requestForGCListWithGCID:(NSString *)GCID complete:(void(^)(BOOL success, NSString * message, NSMutableArray * models, ClassModel * bannerModel))complete;

@end
