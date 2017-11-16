//
//  chooseShopModel.m
//  BMW
//
//  Created by rr on 2016/12/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "chooseShopModel.h"

@implementation chooseShopModel


-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.backImageV = [dic objectForKeyNotNull:@"img"];
        self.title = [dic objectForKeyNotNull:@"name"];
    }
    return  self;
}

+(void)requestImageandPrice:(void (^)(BOOL, chooseShopModel *, NSString *))finish{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"StoreWelcome" parameters:nil callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            chooseShopModel *model = [[chooseShopModel alloc] initWithDic:object[@"data"]];
            finish(YES,model,@"success");
        }else{
            finish(NO,nil,@"failed");
        }
    }];
}

+(void)OpenStoreCheck:(NSString *)phone complete:(void (^)(BOOL,NSDictionary *,NSString *))complete{
    if (phone) {
        [BaseRequset sendPOSTRequestWithBMWApi2Method:@"OpenStoreCheck" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"phone":phone} callBack:^(RequestResult result, id object) {
            if (result == RequestResultSuccess) {
                complete(YES,object[@"data"],@"success");
            } else if (result == RequestResultFailed){
                complete(NO,nil,object);
            }
            else{
                complete(NO,nil,@"操作失败，请重试");
            }
        }];
    }else{
        [BaseRequset sendPOSTRequestWithBMWApi2Method:@"IndoorbuyStore" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
            if (result == RequestResultSuccess) {
                complete(YES,object[@"data"],@"success");
            } else if (result == RequestResultFailed){
                complete(NO,nil,object);
            }
            else{
                complete(NO,nil,@"操作失败，请重试");
            }
        }];
    }
}




+(void)BindingStoreWithPhone:(NSString *)phone andFinish:(void (^)(BOOL, NSString *))finish{
    NSDictionary *dic =@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID};
    if (phone) {
        dic = @{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"phone":phone};
    }
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"BindingStore" parameters:dic callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            finish(YES,object[@"data"]);
        }else if (result == RequestResultFailed){
            finish(NO,object);
        }else{
            finish(NO,@"操作失败,请重试");
        }
    }];
}


@end
