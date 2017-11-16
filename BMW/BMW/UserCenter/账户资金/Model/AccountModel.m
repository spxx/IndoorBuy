//
//  AccountModel.m
//  BMW
//
//  Created by LiuP on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "AccountModel.h"

@implementation AccountModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.freezeM = [dic objectForKeyNotNull:@"freeze_predeposit"];
        if (self.freezeM.length == 0) {
            self.freezeM = @"0.00";
        }else {
            self.freezeM = [NSString stringWithFormat:@"%.2f", self.freezeM.floatValue];
        }
        self.mCash = [dic objectForKeyNotNull:@"available_predeposit"];
        if (self.mCash.length == 0) {
            self.mCash = @"0.00";
        }else {
            self.mCash = [NSString stringWithFormat:@"%.2f", self.mCash.floatValue];
        }


        
    }
    return self;
}


/**
 获取M币账户
 
 @param complete
 */
+ (void)requestForMCashWithUserID:(NSString *)userID Complete:(void(^)(BOOL isSuccess, AccountModel * model, NSString * message))complete
{
    NSDictionary * paraDic;
    if (userID) {
        paraDic = @{@"userId":userID};
    }else {
        paraDic = @{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID};
    }
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetUserInfo" parameters:paraDic callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSDictionary * data = object[@"data"];
            AccountModel * model = [[self alloc] initWithDic:data];
            
            Userentity *user = [[Userentity alloc] initWithJSONObject:data];
            [[JCUserContext sharedManager] updateUserInfo:user];
            
            complete(YES, model, @"Success");
        }else {
            NSString * message = @"获取M币账户时出错，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(NO, nil, message);
        }
    }];
}


@end
