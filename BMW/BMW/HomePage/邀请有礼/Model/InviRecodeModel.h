//
//  InviRecodeModel.h
//  BMW
//
//  Created by rr on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InviRecodeModel : NSObject

@property(nonatomic, strong) NSString *cd;/***邀请时间*/

@property(nonatomic, strong) NSString *inviter;/***账户名*/

@property(nonatomic, strong) NSString *shareone_voucher_price;/***邀请奖励*/

@property(nonatomic, strong) NSString *shareone_vouchernum; /***优惠劵数量*/

@property(nonatomic, strong) NSString *num;/***邀请人数*/

@property(nonatomic, strong) NSString *Tprice;/***奖励的优惠劵总面额*/


+(void)requestRecordWithnum:(NSInteger )num finish:(void(^)(NSInteger,NSMutableArray*,NSString *))finish;


@end
