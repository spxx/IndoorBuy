//
//  GoodsDetailModle.m
//  BMW
//
//  Created by gukai on 16/2/25.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "GoodsDetailModle.h"

@implementation GoodsDetailModle
-(id)initWithJsonObject:(NSDictionary *)jsonObject
{
    self = [super init];
    if (self) {
        
        self.goods_image = [TYTools dataJsonWithDic:[jsonObject objectForKeyNotNull:@"goods_image"]];
        
        self.goods_image_mobile = [TYTools dataJsonWithDic:[jsonObject objectForKeyNotNull:@"goods_image_mobile"]];
        
        self.spec_image = [TYTools dataJsonWithDic:[jsonObject objectForKeyNotNull:@"spec_image"]];
        
        self.spec_list_mobile = [TYTools dataJsonWithDic:[jsonObject objectForKeyNotNull:@"spec_list_mobile"]];
        
        self.goods_info = [TYTools dataJsonWithDic:[jsonObject objectForKeyNotNull:@"goods_info"]];
        self.isCollection = [jsonObject objectForKeyNotNull:@"isCollection"];
        self.parameter = [jsonObject objectForKeyNotNull:@"parameter"];
        
    }
    return self;
}
-(GoodsInfoModle *)modleFormGoods_Info_Str
{
    if (self.goods_info) {
        GoodsInfoModle * modle = [[GoodsInfoModle alloc]initWithJsonObject:[TYTools JSONObjectWithString:self.goods_info]];
        return modle;
    }
    else{
        return nil;
    }
}

+(void)goodsDetailInfoWithDic:(NSDictionary *)dic complete:(void (^)(BOOL, NSString *,NSDictionary *))complete{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GoodsDetail" parameters:dic callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSDictionary * dic = object[@"data"];
            complete(YES,@"获取成功",dic);
        }
        else if (result == RequestResultEmptyData){
            complete(YES,@"暂无可用信息",nil);
        }
        else if (result == RequestResultException){
            complete(NO,@"服务器故障，程序猿正在修复",nil);
        }
        else if (result == RequestResultFailed){
            complete(NO,@"网络出现故障",nil);
        }
    }];
}

+(void)shopCarNumWithComplete:(void (^)(BOOL, NSString *))complete{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"CartNum" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
        if (result==RequestResultSuccess) {
            complete(YES,[NSString stringWithFormat:@"%@",object[@"data"]]);
        }else if(result == RequestResultFailed){
            complete(NO,@"购物车数量出问题了");
        }
    }];
}

+(void)getVipInfoWithComplete:(void (^)(BOOL, NSString *,NSDictionary *))complete{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"VipInfo" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
        
        if (result == RequestResultSuccess) {
            NSDictionary *VipInfo = [NSDictionary dictionaryWithDictionary:object[@"data"]];
            complete(YES,@"获取成功",VipInfo);
            //更新保存下来的状态值
            if (![VipInfo[@"status"] isKindOfClass:[NSNull class]]) {
                [[JCUserContext sharedManager] upDateObject:VipInfo[@"status"] forKey:@"status"];
            }
            else {
                [[JCUserContext sharedManager] upDateObject:@"0" forKey:@"status"];
            }
        }
        else if(result == RequestResultException){
            complete(YES,object[@"data"],nil);
        }else{
            complete(YES,@"网络故障，请联网重试",nil);
        }
    }];

}

+(void)ReActivateVipWithComplete:(void (^)(BOOL, NSString *, NSDictionary *))complete{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"ReActivate" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            complete(YES,@"激活成功",object[@"data"]);
        }else if (result == RequestResultException){
            complete(NO,object[@"data"],nil);
        }
        else {
            complete(NO,@"网络故障，请稍后重试",nil);
        }
    }];

}

+(void)collectionedWithDic:(NSDictionary *)dic andComplete:(void (^)(BOOL))complete{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"Coldel" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"goodsId":dic[@"goods_info"][@"goods_id"]} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            complete(YES);
        }
    }];
}

+(void)addcollectionWithDic:(NSDictionary *)dic andComplete:(void (^)(BOOL))complete{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"Coladd" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"goodsId":dic[@"goods_info"][@"goods_id"]} callBack:^(RequestResult result, id object) {
        if (RequestResultSuccess == result) {
            complete(YES);
        }
    }];
}

+(void)addToCartWithGoodsID:(NSString *)goodsID andGoodsNum:(NSString *)num andComplete:(void (^)(BOOL, NSString *))complete{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"CartAdd" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"goodsId":goodsID, @"num":num} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppcarNum" object:nil];
            complete(YES,@"加入购物车成功");
        }
        else if(result == RequestResultException){
            NSString * string = object[@"message"];
            if (string.length > 0) {
                complete(NO,string);
            }
            else{
                complete(NO,@"加入购物车失败");
            }
        }else{
            complete(NO,@"网络故障");
        }
    }];
}










@end


