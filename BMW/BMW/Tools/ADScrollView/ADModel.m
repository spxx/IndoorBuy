//
//  ADModel.m
//  Custom
//
//  Created by LiuP on 16/6/8.
//  Copyright © 2016年 LiuP. All rights reserved.
//

#import "ADModel.h"

@implementation ADModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.imageUrl   = [NSString stringWithFormat:@"%@",[dic objectForKeyNotNull:@"image"]];
        self.ID         = [dic objectForKeyNotNull:@"id"];
        self.type       = [dic objectForKeyNotNull:@"type"];
        self.status     = [dic objectForKeyNotNull:@"status"];
        self.sort       = [dic objectForKeyNotNull:@"sort"];
        self.link       = [dic objectForKeyNotNull:@"link"];
        self.adClass    = [dic objectForKeyNotNull:@"class"];
        self.classId    = [dic objectForKeyNotNull:@"class_id"];
        self.className  = [dic objectForKeyNotNull:@"className"];
        self.brandName  = [dic objectForKeyNotNull:@"brand_name"];
        self.platName   = [dic objectForKeyNotNull:@"platName"];
        
        self.messageID   = [dic objectForKeyNotNull:@"message_id"];
        self.messageType = [dic objectForKeyNotNull:@"message_type"];
        self.messageUrl  = [dic objectForKeyNotNull:@"message_url"];
        self.title       = [dic objectForKeyNotNull:@"title"];
        self.name        = [dic objectForKeyNotNull:@"name"];
    }
    return self;
}


#pragma mark -- 接口
+ (void)adRequestWithComplete:(CompleteBlock)complete
{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"BannerList" parameters:@{@"class":@"1"} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSMutableArray * models = [NSMutableArray array];
            JCDBCacheManager *cac = [JCDBCacheManager cacheForClass:ADModel.class];
            NSArray *conditions = [cac queryWithCondition:nil];
            NSArray * data = [NSArray arrayWithArray:object[@"data"]];
            for (NSDictionary *dic in data) {
                ADModel * model = [[ADModel alloc] initWithDic:dic];
                [models addObject:model];
            }
            BOOL result;
            if (conditions.count==0) {
                result = [cac insert:models];
                if (result) {
                    NSLog(@"缓存成功");
                }
            }else{
                result = [cac deleteWithCondition:nil];
                if (result) {
                    NSLog(@"ADModel:清空旧缓存成功");
                    result = [cac insert:models];
                    if (result) {
                        NSLog(@"ADModel:添加新缓存成功");
                    }
                }
            }
            complete(models, @"Success", 100);
        }else{
            JCDBCacheManager *cac = [JCDBCacheManager cacheForClass:ADModel.class];
            NSArray *conditions = [cac queryWithCondition:nil];
            NSMutableArray * models = [NSMutableArray arrayWithArray:conditions];
            complete(models, @"获取的缓存数据", 100);
        }

    }];
}

/**
 获取滚动广告数据
 
 @param complete
 */
+ (void)requestForRollADListWithComplete:(Complete)complete
{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"MessageTit" parameters:nil callBack:^(RequestResult result, id object) {
        NSMutableArray * models = [NSMutableArray array];
        if (result == RequestResultSuccess) {
            NSArray * data = object[@"data"];
            for (NSDictionary * dic in data) {
                [models addObject:[[self alloc] initWithDic:dic]];
            }
            complete(YES, models, @"Success");
        }else if (result == RequestResultEmptyData) {
            complete(NO, models, @"暂时没有快报信息");
        }else {
            NSString * message = @"获取快报信息失败，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(NO, nil, message);
        }
    }];
}
@end
