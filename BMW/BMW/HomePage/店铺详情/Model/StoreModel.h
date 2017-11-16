//
//  StoreModel.h
//  BMW
//
//  Created by LiuP on 2016/12/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StoreModel;

typedef void(^Complete)(BOOL isSuccess, StoreModel * model, NSString * message);

@interface StoreModel : NSObject
@property (nonatomic, assign, getter=isBMWStore) BOOL BMWStore;     /**< 是帮麦店，还是个人店 */
@property (nonatomic, copy) NSString * headImage;
@property (nonatomic, copy) NSString * storeName;
@property (nonatomic, copy) NSString * weChat;
@property (nonatomic, copy) NSString * codeImage;       /**< 二维码 */
/***********个人店铺信息************/
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * QQ;
@property (nonatomic, copy) NSString * storeDescription;
/***********BMW店铺信息************/
@property (nonatomic, copy) NSString * publicWeChat;
@property (nonatomic, copy) NSString * servicePhone;


/**
 获取店铺信息

 @param storeID 存在表示上级为个人，不存在显示BMW的店铺信息
 @param complete 
 */
+ (void)requestForStoreInfoWithStoreID:(NSString *)storeID
                                   BMW:(BOOL)BMW
                              complete:(Complete)complete;
@end

