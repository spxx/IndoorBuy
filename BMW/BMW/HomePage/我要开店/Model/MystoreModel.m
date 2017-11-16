//
//  MystoreModel.m
//  BMW
//
//  Created by rr on 2016/12/22.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "MystoreModel.h"

@implementation MystoreModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.store_name = [dic objectForKeyNotNull:@"store_name"];
        self.store_qq   = [dic objectForKeyNotNull:@"store_qq"];
        self.store_wx   = [dic objectForKeyNotNull:@"store_wx"];
        self.store_tel  = [dic objectForKeyNotNull:@"store_tel"];
        self.member_avatar = [dic objectForKeyNotNull:@"member_avatar"];
    }
    return self;
}


+(void)requestMystoreInfoComplete:(void (^)(BOOL success, MystoreModel * model, NSString *message))complete{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"getStoreInfo" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            MystoreModel *mymodel = [[MystoreModel alloc] initWithDic:object[@"data"]];
            complete(YES,mymodel,@"success");
        }else if (result == RequestResultFailed){
            complete(NO,nil,object);
        }else{
            complete(NO,nil,@"操作失败，请重试");
        }
    }];
}



@end
