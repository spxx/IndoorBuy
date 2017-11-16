//
//  OilCardModel.h
//  BMW
//
//  Created by LiuP on 2016/12/17.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OilCardModel;

typedef void(^OilCardComplete)(BOOL isSuccess, OilCardModel * model, NSString * message);
typedef void(^RecordComplete)(BOOL isSuccess, NSMutableArray * models, NSString * message);

@interface OilCardModel : NSObject
/********* 油卡面额 **********/
@property (nonatomic, assign, getter=isSelected) BOOL selected;
@property (nonatomic, copy) NSString * cash;
@property (nonatomic, copy) NSString * mCash;
/********* 油卡广告 **********/
@property (nonatomic, assign, getter=isShow) BOOL show;  /**< 是否展示 */
@property (nonatomic, copy) NSString * oilImage;
@property (nonatomic, copy) NSString * predeposit;       /**< 用户可用M币 */
@property (nonatomic, assign) NSInteger type;             /**< 跳转类型 */
@property (nonatomic, copy) NSString * link;             /**< 跳转参数 */
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * classID;           

/**
 获取M币账户
 
 @param complete
 */
+ (void)requestForMCashWithComplete:(void(^)(BOOL isSuccess, NSString * mCash, NSString * message))complete;

/**
 油卡面额

 @param complete
 */
+ (void)requestForMoneyItemWithComplete:(void(^)(NSMutableArray * models))complete;

/**
 获取油卡广告图
 
 @param complete
 */
+ (void)requestForOilCardADWithComplete:(OilCardComplete)complete;

/**
 油卡充值
 
 @param complete
 */
+ (void)requestForOilCardConvertWithCINum:(NSString *)CINum
                                    money:(NSString *)money
                                 password:(NSString *)password
                                 Complete:(void(^)(BOOL isSuccess, NSString * message))complete;
@end
