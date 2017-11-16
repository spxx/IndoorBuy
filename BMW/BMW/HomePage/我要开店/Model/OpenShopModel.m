//
//  OpenShopModel.m
//  BMW
//
//  Created by rr on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OpenShopModel.h"

@implementation OpenShopModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.backImageV = dic[@"image"];
        self.price = dic[@"maika_amount"];
        self.phone = dic[@"phone"];
        self.recommend = [dic[@"recommend"] boolValue];
    }
    return self;
}


+(void)requestImageandPrice:(void (^)(BOOL, OpenShopModel *, NSString *))finish{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"StoreImage" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            OpenShopModel *openmodel = [[OpenShopModel alloc] initWithDic:object[@"data"]];
            finish(YES,openmodel,@"success");
        }else{
            finish(NO,nil,@"failed");
        }
    }];
}


@end
