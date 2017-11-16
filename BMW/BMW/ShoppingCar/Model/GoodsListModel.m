//
//  GoodsListModel.m
//  BMW
//
//  Created by LiuP on 2016/10/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "GoodsListModel.h"

@implementation GoodsListModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        // 活动
        self.actID          = [dic objectForKeyNotNull:@"bind_label_id"];
        if ([self.actID isEqualToString:@""]||[self.actID length]==0) {
            self.activity = ActivityNone;
        }else {
            self.activity = Activity;
            self.actLabel       = [dic objectForKeyNotNull:@"tag_name"];
            self.actContent     = [dic objectForKeyNotNull:@"description"];
        }

        // 商品
        NSArray * goods = [dic objectForKeyNotNull:@"goods"];
        NSMutableArray * goodsModels = [NSMutableArray array];
        for (NSDictionary * dic in goods) {
            [goodsModels addObject:[[GoodsModel alloc] initWithDic:dic]];
        }
        NSArray * gifts = [dic objectForKeyNotNull:@"gift"];
        if ([gifts isKindOfClass:[NSArray class]]) {
            for (NSDictionary * gift in gifts) {
                [goodsModels addObject:[[GoodsModel alloc] initWithGift:gift]];
            }
        }
        self.goodsModels = goodsModels;
    }
    return self;
}

- (instancetype)initWithPriceDic:(NSDictionary *)priceDic
{
    self = [super init];
    if (self) {
        NSString * save      = [priceDic objectForKeyNotNull:@"save"];
        NSString * total     = [priceDic objectForKeyNotNull:@"total"];
        NSString * vip_save  = [priceDic objectForKeyNotNull:@"vip_save"];
        self.totalCash = total;
        self.saveCash = save;
        self.beVipSave = vip_save;
    }
    return self;
}


#pragma mark -- 网络请求
/**
 购物车管理接口

 @param complete
 */
+ (void)requsetForCarManageWithSelectedGoods:(NSMutableArray *)selectedGoods Complete:(void(^)(NSInteger code, NSMutableArray * models, GoodsListModel * price, NSString * msg))complete
{
    NSString * memberID = [JCUserContext sharedManager].currentUserInfo.memberID;
    NSMutableArray * carIDs = [NSMutableArray array];
    for (GoodsModel * goods in selectedGoods) {
        [carIDs addObject:goods.carID];
    }
    NSDictionary * paraDic;
    if (carIDs.count >= 1) {
        NSString * goodsJson = [TYTools dataJsonWithDic:carIDs];
        paraDic = @{@"userId":memberID, @"check":goodsJson};
    }else {
        paraDic = @{@"userId":memberID, @"check":@""};
    }
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"CartList" parameters:paraDic callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSMutableArray * data = [NSMutableArray arrayWithArray:object[@"data"]];
            NSDictionary * priceDic = [data objectAtIndex:data.count - 1];
            [data removeLastObject];
            NSMutableArray * models = [NSMutableArray array];
            for (NSDictionary * dataDic in data) {
                [models addObject:[[self alloc] initWithDic:dataDic]];
            }
            GoodsListModel * priceModel = [[self alloc] initWithPriceDic:priceDic];
            complete(100, models, priceModel, @"获取成功");
        }else if (result == RequestResultEmptyData){
            complete(902, nil, nil, @"购物车为空");
        }else {
            NSString * message = @"获取购物车信息失败，请稍后再试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(-1, nil, nil, message);
        }
    }];
}


/**
 获取购物车数目

 @param complete 
 */
+ (void)requestForCarNumWithComplete:(void(^)(BOOL success, NSString * carNum))complete
{
    NSString * memberID = [JCUserContext sharedManager].currentUserInfo.memberID;
    NSDictionary * paraDic = @{@"userId":memberID};
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"CartNum" parameters:paraDic callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSString * carNum = [NSString stringWithFormat:@"%@",object[@"data"]];
            if ([carNum isEqualToString:@""]) {
                complete(NO, nil);
            }else {
                complete(YES, carNum);
            }
        }else {
            complete(NO, nil);
            NSLog(@"购物车数量:%@", object);
        }
    }];
}


/**
 编辑购物车

 @param model
 @param goodsNum
 @param complete 
 */
+ (void)requestForEditCarListWithGoodsModel:(GoodsModel *)model goodsNum:(NSString *)goodsNum Complete:(void(^)(BOOL success, NSString * msg))complete
{
    NSDictionary * paraDic = @{@"cartId":model.carID, @"goodsId":model.goodsID, @"num":goodsNum};
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"CartEdit" parameters:paraDic callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            complete(YES, @"Success");
        }else if(result == RequestResultException){
            if ([object[@"code"] integerValue] == 911) {
                NSLog(@"超过库存");
                complete(NO, @"超过库存");
            }else {
                NSString * message = @"编辑购物车失败，请稍后再试";
                if ([object isKindOfClass:[NSString class]]) {
                    message = object;
                }
                complete(NO, message);
            }
        }else {
            NSString * message = @"编辑购物车失败，请稍后再试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(NO, message);
        }
    }];
}

/**
 删除购物车商品

 @param selectedGoods
 @param complete
 */
+ (void)requsetForDeleteSelectedGoods:(NSMutableArray *)selectedGoods complete:(void(^)(BOOL success, NSString * msg))complete
{
    NSString * memberID = [JCUserContext sharedManager].currentUserInfo.memberID;
    NSString * carIDs   = @"";
    for (GoodsModel * goods in selectedGoods) {
        carIDs = [carIDs stringByAppendingString:[NSString stringWithFormat:@"%@,", goods.carID]];
    }
    if ([carIDs hasSuffix:@","]) {
        carIDs = [carIDs substringToIndex:carIDs.length - 1];
    }
    NSDictionary * paraDic = @{@"userId":memberID,@"cartId":carIDs,@"num":@"0"};
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"CartDel" parameters:paraDic callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            complete(YES, @"Success");
        }else {
            NSString * message = @"删除商品失败，请稍后再试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(NO, message);
        }
    }];
}
//
///**
// 计算价格
//
// @param selectedGoods
// */
//+ (void)requestForCarCashWithSelectedGoods:(NSMutableArray *)selectedGoods
//                              originModels:(NSMutableArray *)originModels
//                                  complete:(FinshCarPrice)complete
//{
//    NSString * memberID = [JCUserContext sharedManager].currentUserInfo.memberID;
//    NSMutableArray * goods = [NSMutableArray array];
//    for (GoodsModel * model in selectedGoods) {
//        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//        [dic setObject:model.goodsID forKey:@"goodsId"];
//        [dic setObject:model.goodsNum forKey:@"goodsNum"];
//        [goods addObject:dic];
//    }
//    NSString * goodsJson = [TYTools dataJsonWithDic:goods];
//    NSDictionary * paraDic = @{@"userId":memberID, @"goods":goodsJson};
//    
//    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GiftsTotal" parameters:paraDic callBack:^(RequestResult result, id object) {
//        if (result == RequestResultSuccess) {
//            NSDictionary * data = object[@"data"];
//            
//            // 匹配活动赠品
//            for (GoodsListModel * model in originModels) {
//                NSArray * tempGoods = [NSArray arrayWithArray:model.goodsModels];
//                for (GoodsModel * goods in tempGoods) {
//                    if (goods.isGift) {
//                        [model.goodsModels removeObject:goods];
//                    }
//                }
//                
//                if (model.activity == ActivityCutAndGift) {
//                    NSArray * gifts = data[@"gift"];
//                    for (NSDictionary * gift in gifts) {
//                        NSString * platformId = gift[@"platformId"];
//                        NSArray * goods       = gift[@"goods"];
//                        if ([platformId isEqualToString:model.actID]) {
//                            for (NSDictionary * dic in goods) {
//                                [model.goodsModels addObject:[[GoodsModel alloc] initWithGift:dic]];
//                            }
//                        }
//                    }
//                }
//            }
//            
//            GoodsListModel * model = [[self alloc] initWithPriceDic:data];
//            complete(YES, originModels, model, @"Success");
//        }else {
//            NSString * message = @"商品价格计算失败，请稍后再试";
//            if ([object isKindOfClass:[NSString class]]) {
//                message = object;
//            }
//            complete(NO, originModels, nil, message);
//        }
//    }];
//}

@end
