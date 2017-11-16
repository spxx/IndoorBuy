//
//  WithdrawModel.h
//  DP
//
//  Created by LiuP on 16/8/2.
//  Copyright © 2016年 sp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BankCardModel.h"


@interface WithdrawModel : NSObject

@property (nonatomic, copy) NSString * amount;      /**< 金额 */
@property (nonatomic, copy) NSString * bankName;    /**< 银行名字 */
@property (nonatomic, copy) NSString * state;       /**< 1.申请中 2.审核通过 3.已拒绝 */
@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * remark;

@property (nonatomic, copy) NSString * bankCardNum;

/**
 *  获取银行卡列表
 *
 *  @param complete 
 */
+ (void)requestForBanCardListWithComplete:(Complete)complete;


/**
 申请提现
 
 @param paraDic
 @param complete
 */
+ (void)requestFotWithdrawWithParaDic:(NSDictionary *)paraDic complete:(void(^)(BOOL isSuccess, NSString * message))complete;

/**
 获取提现记录
 
 @param state 选传参数：1.申请中 2.审核通过 3.已拒绝
 @param complete
 */
+ (void)requestForWithdrawRecordWithState:(NSString *)state complete:(Complete)complete;
@end
