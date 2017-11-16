//
//  CouponModel.m
//  BMW
//
//  Created by LiuP on 2016/12/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "CouponModel.h"

@implementation CouponModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.status         = [dic objectForKeyNotNull:@"status"];
        self.couponAmount   = [[dic objectForKeyNotNull:@"voucher_t_total"] integerValue];
        self.couponCash     = [dic objectForKeyNotNull:@"voucher_t_price"];
        self.couponID       = [dic objectForKeyNotNull:@"voucher_t_id"];
        self.couponImage    = [dic objectForKeyNotNull:@"voucher_t_customimg"];
        if (self.couponAmount == 0) {
            self.have = NO;
        }else {
            self.have = YES;
        }
    }
    return self;
}

#pragma mark -- 接口
/**
 获取优惠券列表

 @param complete
 */
+ (void)requestForCouponListWithComplete:(Complete)complete
{
    NSString * userId = [JCUserContext sharedManager].currentUserInfo.memberID;
    NSDictionary * paraDic = @{@"userId":userId};
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"VoucherGetList" parameters:paraDic callBack:^(RequestResult result, id object) {
        NSMutableArray * models = [NSMutableArray array];
        if (result == RequestResultSuccess) {
            NSArray * data = object[@"data"];
            for (NSDictionary * dic in data) {
                [models addObject:[[self alloc] initWithDic:dic]];
            }
            complete(YES, models, @"Success");
        }else if (result == RequestResultEmptyData) {
            complete(NO, models, @"暂时没有可领取的优惠券");
        }else {
            NSString * message = @"获取优惠券信息失败，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(NO, nil, message);
        }
    }];
}

/**
 领取优惠券
 
 @param couponID
 @param complete
 */
+ (void)requestForGetCouponWithCouponID:(NSString *)couponID complete:(void(^)(BOOL isSuccess, NSString * message))complete
{
    NSString * userId = [JCUserContext sharedManager].currentUserInfo.memberID;
    NSString * userName = [JCUserContext sharedManager].currentUserInfo.memberName;
    NSDictionary * paraDic = @{@"userId":userId, @"userName":userName, @"vid":couponID};
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"VoucherGet" parameters:paraDic callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            complete(YES, @"Success");
        }else {
            NSString * message = @"领取优惠券失败，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(NO, message);
        }
    }];
}

@end
