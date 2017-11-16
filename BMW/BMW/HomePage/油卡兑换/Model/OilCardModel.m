//
//  OilCardModel.m
//  BMW
//
//  Created by LiuP on 2016/12/17.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OilCardModel.h"

@implementation OilCardModel
// 油卡广告
- (instancetype)initWithADDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        NSString * show = [dic objectForKeyNotNull:@"show"];
        if (show.integerValue == 1) {
            self.show = YES;
        }else {
            self.show = NO;
        }
        self.oilImage = [dic objectForKeyNotNull:@"image"];
        self.type     = [[dic objectForKeyNotNull:@"type"] integerValue];
        self.name     = [dic objectForKeyNotNull:@"name"];
        self.predeposit = [dic objectForKeyNotNull:@"predeposit"];
        self.link     = [dic objectForKeyNotNull:@"link"];
        self.classID  = [dic objectForKeyNotNull:@"class_id"];
    }
    return self;
}

#pragma mark -- 接口

/**
 获取M币账户

 @param complete
 */
+ (void)requestForMCashWithComplete:(void(^)(BOOL isSuccess, NSString * mCash, NSString * message))complete
{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetUserInfo" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSDictionary * data = object[@"data"];
            NSString * mCash = data[@"available_predeposit"];  // M币
            
            complete(YES, mCash, @"Success");
            
        }else {
            NSString * message = @"获取M币账户时出错，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(NO, @"", message);
        }
    }];
}

/**
 获取油卡广告图
 
 @param complete
 */
+ (void)requestForOilCardADWithComplete:(OilCardComplete)complete
{
    NSString * userId = [JCUserContext sharedManager].currentUserInfo.memberID;
    NSDictionary * paraDic = @{@"userId":userId};
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"OilCardImg" parameters:paraDic callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSDictionary * data = object[@"data"];
            OilCardModel * model = [[self alloc] initWithADDic:data];
            complete(YES, model, @"Success");
        }else if (result == RequestResultEmptyData) {
            complete(NO, nil, @"暂时没有油卡广告");
        }else {
            NSString * message = @"获取油卡广告信息失败，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(NO, nil, message);
        }
    }];
}


/**
 油卡充值

 @param complete
 */
+ (void)requestForOilCardConvertWithCINum:(NSString *)CINum
                                    money:(NSString *)money
                                 password:(NSString *)password
                                 Complete:(void(^)(BOOL isSuccess, NSString * message))complete
{
    NSString * userId = [JCUserContext sharedManager].currentUserInfo.memberID;
    NSDictionary * paraDic = @{@"userId":userId,
                               @"cardNumber":CINum,
                               @"money":money,
                               @"password":password};
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"ConvertOil" parameters:paraDic callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            complete(YES, @"Success");
        } else if (result == RequestResultEmptyData ) {
            complete(NO, @"密码错误");
        }else {
            NSString * message = @"M币兑换失败，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(NO, message);
        }
    }];
}



/**
 油卡面额

 @param complete 
 */
+ (void)requestForMoneyItemWithComplete:(void(^)(NSMutableArray * models))complete
{
    NSArray * cashs = @[@"100", @"200", @"500", @"600", @"800", @"1000"];
    NSArray * mCashs = @[@"兑换：100M币", @"兑换：200M币", @"兑换：500M币", @"兑换：600M币", @"兑换：800M币", @"兑换：1000M币"];
    
    NSMutableArray * models = [NSMutableArray array];
    for (int i = 0; i < cashs.count; i ++) {
        NSString * cash = cashs[i];
        NSString * mCash = mCashs[i];
        OilCardModel * model = [[self alloc] init];
        model.selected = NO;
        model.cash = cash;
        model.mCash = mCash;
        
        [models addObject:model];
    }
    
    complete(models);
}

@end
