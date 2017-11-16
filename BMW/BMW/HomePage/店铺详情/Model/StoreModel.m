//
//  StoreModel.m
//  BMW
//
//  Created by LiuP on 2016/12/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "StoreModel.h"

@implementation StoreModel


- (instancetype)initWithBMWDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.BMWStore = YES;
        self.weChat         = @"waoomall";
        self.publicWeChat   = @"帮麦跨境电商";
        self.servicePhone   = @"400-100-3923";
        
        NSString * headImage = [dic objectForKeyNotNull:@"member_avatar"];
        self.headImage = headImage.length > 0 ? headImage : @"jpg_tiyandiantouxiang_sy.png";
        
        self.storeDescription = [dic objectForKeyNotNull:@"description"];
        self.storeName = [dic objectForKeyNotNull:@"store_name"];
        self.codeImage = [dic objectForKeyNotNull:@"codeImg"];
    }
    return self;
}

- (instancetype)initWithPersonDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.BMWStore = NO;
        self.headImage = [dic objectForKeyNotNull:@"member_avatar"];
        self.storeName = [dic objectForKeyNotNull:@"store_name"];
        self.weChat = [dic objectForKeyNotNull:@"store_wx"];

        self.phone = [dic objectForKeyNotNull:@"store_tel"];
        self.QQ    = [dic objectForKeyNotNull:@"store_qq"];
        self.storeDescription = [dic objectForKeyNotNull:@"description"];
        self.codeImage = [dic objectForKeyNotNull:@"codeImg"];
    }
    return self;
}


/**
 获取店铺信息
 
 @param complete
 */
+ (void)requestForStoreInfoWithStoreID:(NSString *)storeID BMW:(BOOL)BMW complete:(Complete)complete
{
    NSString * shareUrl = @"http://m.indoorbuy.com";
    NSDictionary * paraDic = @{@"storeId":storeID, @"storeUrl":shareUrl};
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"ShowStore" parameters:paraDic callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSDictionary * data = object[@"data"];
            if (BMW) { // BMW 店
                StoreModel * model = [[self alloc] initWithBMWDic:data];
                complete(YES, model, @"Success");
            }else {
                StoreModel * model = [[StoreModel alloc] initWithPersonDic:data];
                complete(YES, model, @"Success");
            }
        }else if (result == RequestResultEmptyData) {
            complete(NO, nil, @"未找到相关店铺信息");
        }else {
            NSString * message = @"获取店铺信息失败，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(NO, nil, message);
        }
    }];
}

@end
