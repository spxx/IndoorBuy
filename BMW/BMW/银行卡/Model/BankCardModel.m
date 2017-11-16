//
//  BankCardModel.m
//  DP
//
//  Created by LiuP on 16/7/18.
//  Copyright © 2016年 sp. All rights reserved.
//

#import "BankCardModel.h"

@interface BankCardModel ()


@end

@implementation BankCardModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.bank           = [dic objectForKeyNotNull:@"bank"];
        self.bankCardID     = [dic objectForKeyNotNull:@"id"];

        NSString * bankOriginNum = [dic objectForKeyNotNull:@"cardnumber"];;
        self.bankCardOriginNum = bankOriginNum;
        // 隐藏后4位
        if (bankOriginNum.length >=4) {
            bankOriginNum = [bankOriginNum substringFromIndex:bankOriginNum.length - 4];
            self.bankCardNum = [NSString stringWithFormat:@"%@", bankOriginNum];
        }else {
            self.bankCardNum = @"";
        }
    }
    return self;
}

#pragma mark -- 网络相关

/**
 获取银行卡列表

 @param complete
 */
+ (void)requestForBankCardListWithComplete:(Complete)complete
{
    NSString * userId = [JCUserContext sharedManager].currentUserInfo.memberID;
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetBankList" parameters:@{@"userId":userId} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSArray * data = object[@"data"];
            NSString * message = object[@"message"];
            NSMutableArray * models = [NSMutableArray arrayWithCapacity:data.count];
            for (NSDictionary * dic in data) {
                [models addObject:[[self alloc] initWithDic:dic]];
            }
            complete(models, message, 100);
        }else if (result == RequestResultEmptyData){
            complete(nil, @"未添加银行卡", 902);

        }else {
            complete(nil, object, -1);
        }
    }];
}

/**
 删除银行卡

 @param model
 @param complete
 */
+ (void)deleteBankCardWithModel:(BankCardModel *)model Complete:(Complete)complete
{
    NSString * userId = [JCUserContext sharedManager].currentUserInfo.memberID;
    NSDictionary * paraDic = @{@"userId":userId, @"cardId":model.bankCardID};
    
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"DeleteBank" parameters:paraDic callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            complete(nil, @"解除绑定成功", 100);
        }
        else {
            complete(nil, @"解除绑定失败", -1);
        }
    }];
}

/**
 绑定银行卡

 @param name
 @param cardNum
 @param bankName
 @param complete
 */
+ (void)addBankCardWithName:(NSString *)name
                    cardNum:(NSString *)cardNum
                   bankName:(NSString *)bankName
                   Complete:(Complete)complete
{
    NSString * userID = [JCUserContext sharedManager].currentUserInfo.memberID;
    NSDictionary * paraDic = @{@"userId":userID, @"name":name, @"cardnumber":cardNum, @"bank":bankName};
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"BindingBank"
                                       parameters:paraDic
                                         callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            complete(nil, @"Success", 100);
        }else {
            NSString * message = @"绑定银行卡失败，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(nil, message, -1);
        }
    }];
}

@end
