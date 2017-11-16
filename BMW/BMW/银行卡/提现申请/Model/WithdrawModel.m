//
//  WithdrawModel.m
//  DP
//
//  Created by LiuP on 16/8/2.
//  Copyright © 2016年 sp. All rights reserved.
//

#import "WithdrawModel.h"

@implementation WithdrawModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.amount = [dic objectForKeyNotNull:@"amount"];
        self.bankName = [dic objectForKeyNotNull:@"bank_name"];
        self.state    = [dic objectForKeyNotNull:@"state"];
        self.time = [dic objectForKeyNotNull:@"add_time"];
        self.remark = [dic objectForKeyNotNull:@"remark"];
        self.bankCardNum = [dic objectForKeyNotNull:@"bank_no"];
    }
    return self;
}



/**
 获取银行卡列表

 @param complete
 */
+ (void)requestForBanCardListWithComplete:(Complete)complete
{
    [BankCardModel requestForBankCardListWithComplete:^(NSMutableArray<BankCardModel *> *models, NSString *message, NSInteger code) {
        for (BankCardModel * model in models) {
            if ([model.bankCardNum hasPrefix:@"尾号"]) {
                model.bankCardNum = [model.bankCardNum substringFromIndex:2];
            }
        }
        complete(models, message, code);
    }];
}


/**
 申请提现

 @param paraDic
 @param complete
 */
+ (void)requestFotWithdrawWithParaDic:(NSDictionary *)paraDic complete:(void(^)(BOOL isSuccess, NSString * message))complete
{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"BankWithdrawal" parameters:paraDic callBack:^(RequestResult result, id object) {

        NSLog(@"申请提现 == %@", object);
        if (result == RequestResultSuccess) {
            complete(YES, @"申请成功");
        }else {
            NSString * message = @"申请提现失败，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(NO, message);
        }
    }];

}


/**
 获取提现记录

 @param state
 @param complete
 */
+ (void)requestForWithdrawRecordWithState:(NSString *)state complete:(Complete)complete
{
    NSString * userID = [JCUserContext sharedManager].currentUserInfo.memberID;
    NSDictionary * paraDic;
    if (state) {
        paraDic = @{@"userId":userID, @"state":state};
    }else {
        paraDic = @{@"userId":userID};
    }
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"WithdrawalRecord" parameters:paraDic callBack:^(RequestResult result, id object) {
        NSMutableArray * models = [NSMutableArray array];
        if (result == RequestResultSuccess) {
            NSArray * data = object[@"data"];
            for (NSDictionary * dic in data) {
                [models addObject:[[self alloc] initWithDic:dic]];
            }
            complete(models, @"Success", 100);
        } else if (result == RequestResultEmptyData) {
            NSString * message;
            if (state.integerValue == 0) {
                message = @"还没有申请中的提现记录";
            }else if (state.integerValue == 1) {
                message = @"还没有已提现记录";
            }else {
                message = @"还没有被拒绝的提现记录";
            }

            complete(models, message, 902);
        } else {
            NSString * message = @"获取提现记录失败，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(models, message, -1);
        }
    }];
}

@end
