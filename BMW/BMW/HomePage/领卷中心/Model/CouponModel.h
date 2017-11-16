//
//  CouponModel.h
//  BMW
//
//  Created by LiuP on 2016/12/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Complete)(BOOL isSuccess, NSMutableArray * models, NSString * message);

@interface CouponModel : NSObject
@property (nonatomic, assign) NSInteger couponAmount;         /**< 数量 */
@property (nonatomic, copy) NSString * couponCash;            /**< 金额 */
@property (nonatomic, copy) NSString * couponImage;
@property (nonatomic, copy) NSString * couponID;
@property (nonatomic, copy) NSString * status;                /**< 1 可领取 2 不可领取 */
@property (nonatomic, assign, getter=isHave) BOOL  have;           /**< 该优惠券是否已领完 */


/**
 获取优惠券列表
 
 @param complete
 */
+ (void)requestForCouponListWithComplete:(Complete)complete;

/**
 领取优惠券

 @param couponID
 @param complete 
 */
+ (void)requestForGetCouponWithCouponID:(NSString *)couponID complete:(void(^)(BOOL isSuccess, NSString * message))complete;
@end
