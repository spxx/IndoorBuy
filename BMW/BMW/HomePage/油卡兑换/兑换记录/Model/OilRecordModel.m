//
//  OilRecordModel.m
//  BMW
//
//  Created by LiuP on 2016/12/17.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OilRecordModel.h"

@implementation OilRecordModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        NSString * cash = [dic objectForKeyNotNull:@"amount"];
        NSString * backM = [dic objectForKeyNotNull:@"back_pd"];
        NSString * state = [dic objectForKeyNotNull:@"state"];
        
        if (state.integerValue == 0) {
            self.handling = YES;
            self.status = @"充值中";
            self.message = @" ";
        }else if (state.integerValue == 1) {
            self.handling = NO;
            self.status = @"已完成";
            self.message = @" ";
        }else if (state.integerValue == 2) {
            self.handling = NO;
            self.status = @"已拒绝";
            self.message = [dic objectForKeyNotNull:@"remark"];
        }
        NSString * timeStamp = [dic objectForKeyNotNull:@"pay_time"];
        self.time = [TYTools getTimeToShowWithTimestamp:timeStamp];
        self.title = [NSString stringWithFormat:@"油卡兑换   %@M币（返%@M币）", cash, backM];
    }
    return self;
}


#pragma mark -- 接口

/**
 获取油卡兑换记录列表

 @param complete
 */
+ (void)requestForOilRecordListWithComplete:(OilRecordBack)complete
{
    NSString * userId = [JCUserContext sharedManager].currentUserInfo.memberID;
    NSDictionary * paraDic = @{@"userId":userId};
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"RecordOil" parameters:paraDic callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSArray * data = object[@"data"];
            NSMutableArray * models = [NSMutableArray array];
            for (NSDictionary * dic in data) {
                [models addObject:[[self alloc] initWithDic:dic]];
            }
            complete(YES, models, @"Success");
        }else if (result == RequestResultEmptyData) {
            complete(YES, nil, @"暂时没有相关兑换记录");
        }else {
            NSString * message = @"获取兑换记录信息失败，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(NO, nil, message);
        }
    }];
}

@end
