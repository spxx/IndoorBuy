//
//  HomePageM.m
//  BMW
//
//  Created by rr on 2016/12/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "HomePageM.h"
#import "GoodsListModel.h"
#import "ADModel.h"

@implementation HomePageM

- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.gc_id          = [dic objectForKeyNotNull:@"gc_id"];
        self.gc_name        = [dic objectForKeyNotNull:@"gc_name"];
        
        self.goodsJsonStr   = [TYTools dataJsonWithDic:[dic objectForKeyNotNull:@"goods"]];
    }
    return self;
}


/**
 初始化店铺logo相关信息

 @param dic
 @return
 */
- (instancetype)initWithStoreDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.drp            = [[dic objectForKeyNotNull:@"drp"] integerValue];
        self.storeLogo      = [dic objectForKeyNotNull:@"member_avatar"];
        self.storeID        = [dic objectForKeyNotNull:@"store_id"];
        self.storeType      = [[dic objectForKeyNotNull:@"store_type"] integerValue];
        if (self.storeType == 1) {
            NSString * headImage = [dic objectForKeyNotNull:@"member_avatar"];
            self.storeLogo = headImage.length > 0 ? headImage : @"jpg_tiyandiantouxiang_sy.png";
        }
        if (self.drp == 1) {
            self.storeLogo = [JCUserContext sharedManager].currentUserInfo.memberAvatar;
        }
    }
    return self;
}



#pragma mark -- 网络相关
/**
 获取店铺logo
 
 @param complete
 */
+ (void)requestForStoreLogoWithComplete:(void(^)(HomePageM * model))complete
{
    NSString * userID = [JCUserContext sharedManager].currentUserInfo.memberID;
    NSDictionary * paraDic = nil;
    if (userID) {
        paraDic = @{@"userId":userID};
    }
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetIndexLogo" parameters:paraDic callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSDictionary * data = object[@"data"];
            HomePageM * model = [[HomePageM alloc] initWithStoreDic:data];
            complete(model);
        }else {
            // 请求失败 用户无法点击进入
            HomePageM * model = [[HomePageM alloc] init];
            model.drp = 1;
            model.storeLogo = [JCUserContext sharedManager].currentUserInfo.memberAvatar;
            complete(model);
        }
    }];
}

/**
 获取商品列表
 
 @param complete
 */
+ (void)requestForGoodsListWithComplete:(Completed)complete
{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"HomePage" parameters:nil callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            JCDBCacheManager *cac = [JCDBCacheManager cacheForClass:HomePageM.class];
            NSArray *testArray = [cac queryWithCondition:nil];
            NSArray *sectionArray = object[@"data"];
            BOOL result;
            NSMutableArray * goodsList = [NSMutableArray array];
            if (testArray.count==0) {
                result = [cac insert:goodsList];
                if (result) {
                    NSLog(@"写入成功");
                }
            }else{
                result = [cac update:goodsList withConditions:testArray];
                if (result) {
                    NSLog(@"更新成功");
                }
            }
            complete(sectionArray, @"Success", 100);

        }else{
            JCDBCacheManager *cac = [JCDBCacheManager cacheForClass:HomePageM.class];
            NSArray *testArray = [cac queryWithCondition:nil];
            NSMutableArray *cachArray = [NSMutableArray array];
            for (HomePageM *homeM in testArray) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                NSArray *goods = [TYTools JSONObjectWithString:homeM.goodsJsonStr];
                [dic setValue:homeM.gc_id forKey:@"gc_id"];
                [dic setValue:homeM.gc_name forKey:@"gc_name"];
                [dic setValue:goods forKey:@"goods"];
                [cachArray addObject:dic];
            }
            complete(cachArray, @"Success", 100);
        }
    }];
}

+(void)requestForAdverListWithComplete:(AdCompleted)adcomplete{
    
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"BannerList" parameters:@{@"class":@"2"} callBack:^(RequestResult result, id object) {
        NSLog(@"%@",object);
        if (result == RequestResultSuccess) {
            NSArray *adverArray = object[@"data"];
            NSData * advData = [NSKeyedArchiver archivedDataWithRootObject:adverArray];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"adverImageArray"];
            [[NSUserDefaults standardUserDefaults] setObject:advData forKey:@"adverImageArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            for (int i = 0; i < adverArray.count; i ++) {
                UIImageView * imageView =[[UIImageView alloc]init];
                [imageView sd_setImageWithURL:[NSURL URLWithString:adverArray[i][@"image"]] placeholderImage:nil];
            }
            
            adcomplete(adverArray,@"success",100);
        }else if(result == RequestResultEmptyData){
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"adverImageArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            adcomplete(nil,@"emp",902);
        }else{
            NSData * advData = [[NSUserDefaults standardUserDefaults] objectForKey:@"adverImageArray"];
            NSArray *adverArray = [NSKeyedUnarchiver unarchiveObjectWithData:advData];
            adcomplete(adverArray,@"failed",999);
            
        }
    }];
}

+(void)requestForNews:(void (^)(BOOL))finished{
    if ([JCUserContext sharedManager].isUserLogedIn) {
        [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetMessageNum" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"type":@"2"} callBack:^(RequestResult result, id object) {
            if (result == RequestResultSuccess) {
                NSInteger newsCount = [object[@"data"] integerValue];
                if (newsCount > 0) {
                    finished(YES);
                }
            }else{
                finished(NO);
            }
        }];
        
        [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetMessageNum" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"type":@"1"} callBack:^(RequestResult result, id object) {
            if (result == RequestResultSuccess) {
                NSInteger newsCount = [object[@"data"] integerValue];
                if (newsCount > 0) {
                    finished(YES);
                }
            }else{
                finished(NO);
            }
        }];
    }
}

+(void)requestGetNewsArray:(void (^)(NSArray *))finished{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"MessageTit" parameters:@{} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSArray *array = object[@"data"];
            NSMutableArray *messArray = [NSMutableArray array];
            for (int i = 0; i < array.count; i ++) {
                NSMutableDictionary * messDic = [NSMutableDictionary dictionaryWithDictionary:array[i]];
                if (messDic[@"message_url"] == [NSNull null]) {
                    [messDic setObject:@" " forKey:@"message_url"];
                }
                [messArray addObject:messDic];
            }
            
            [[NSUserDefaults standardUserDefaults]setObject:messArray forKey:@"message"];
            finished(messArray);
        }else if(result == RequestResultEmptyData){
            finished(nil);
        }else{
            NSArray  *messageArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"message"];
            finished(messageArray);
        }
    }];
}


/**
 获取消息（滚动广告的公告文本）

 @param ID
 @param complete
 */
+ (void)requestForMessageWithID:(NSString *)ID complete:(void(^)(BOOL isSuccess, NSString * text, NSString * message))complete
{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"MessageCon" parameters:@{@"messageId":ID} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSString * htmlStr = [object[@"data"] objectForKeyNotNull:@"body"];
            complete(YES, htmlStr, @"Success");
        }else {
            NSString * message = @"获取快报信息失败，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(NO, @"", message);
        }
    }];

}

+(void)requestForGoodsListWithKey:(NSString *)key Complete:(Completed)complete{
    //    [BaseRequset sendPOSTRequestWithMethod:@"GoodsList" parameters:@{@"keywd":key,@"salenum":@"0",@"start":@"1",@"limit":@"20"} callBack:^(RequestResult result, id object) {
    //      NSMutableArray *models = [NSMutableArray array];
    //    if (result == RequestResultSuccess) {
    //      NSArray * data = object[@"data"];
    
    //    for (NSDictionary * dic in data) {
    //  GoodsListModel * model = [[GoodsListModel alloc]initWithDic:dic];
    //      [models addObject:model];
    //}
    //complete(models, @"Success", 100);
    
    // }else {
    //     complete(nil, object, -1);
    // }
    //}];
}

+(void)requestForGoodsListWithKey:(NSString *)key andPrice:(NSString *)price Complete:(Completed)complete{
//    NSMutableDictionary * paraDic = [NSMutableDictionary dictionaryWithDictionary:@{@"keywd":key,
//                                                                                    @"price":price,
//                                                                                    @"start":@"1",
//                                                                                    @"limit":@"20"}];
   // [BaseRequset sendPOSTRequestWithMethod:@"GoodsList" parameters:paraDic callBack:^(RequestResult result, id object) {
     //   NSMutableArray *models = [NSMutableArray array];
      //  if (result == RequestResultSuccess) {
        //    NSArray * data = object[@"data"];
            
          //  for (NSDictionary * dic in data) {
            //    GoodsListModel * model = [[GoodsListModel alloc]initWithDic:dic];
              //  [models addObject:model];
            //}
            //complete(models, @"Success", 100);
       // }else {
         //   complete(nil, object, -1);
       // }
   // }];
    
}

+(void)requestForGoodsListWith:(NSArray *)models andKey:(NSString *)key Complete:(Completed)complete{
//    NSMutableDictionary * paraDic = [NSMutableDictionary dictionaryWithDictionary:@{@"keywd":key,
//                                                                                    @"salenum":@"0",
//                                                                                    @"start":@"1",
//                                                                                    @"limit":@"20"}];
    
    //    if (models) {
    //        [paraDic setObject:[NSString stringWithFormat:@"%lu", models.count + 1] forKey:@"start"];
    //    }
    //    [BaseRequset sendPOSTRequestWithMethod:@"GoodsList" parameters:paraDic callBack:^(RequestResult result, id object) {
    //        NSMutableArray *models = [NSMutableArray array];
    //        if (result == RequestResultSuccess) {
    //            NSArray * data = object[@"data"];
    
    //            for (NSDictionary * dic in data) {
    //                GoodsListModel * model = [[GoodsListModel alloc]initWithDic:dic];
    //                [models addObject:model];
    //            }
    //            complete(models, @"Success", 100);
    //        }else {
    //            complete(nil, object, -1);
    //        }
    
    //  }];
}

+(void)requestForGoodsListWith:(NSArray *)models andKey:(NSString *)key andPrice:(NSString *)price Complete:(Completed)complete{
    
//    NSMutableDictionary * paraDic = [NSMutableDictionary dictionaryWithDictionary:@{@"keywd":key,
//                                                                                    @"price":price,
//                                                                                    @"start":@"1",
//                                                                                    @"limit":@"20"}];
//    
//    if (models) {
//        [paraDic setObject:[NSString stringWithFormat:@"%lu", models.count + 1] forKey:@"start"];
//    }
    
//    [BaseRequset sendPOSTRequestWithMethod:@"GoodsList" parameters:paraDic callBack:^(RequestResult result, id object) {
//        NSMutableArray *models = [NSMutableArray array];
//        if (result == RequestResultSuccess) {
//            NSArray * data = object[@"data"];
            
//            for (NSDictionary * dic in data) {
//                GoodsListModel * model = [[GoodsListModel alloc]initWithDic:dic];
//                [models addObject:model];
//            }
//            complete(models, @"Success", 100);
//        }else {
//            complete(nil, object, -1);
//        }
//    }];
    
}

@end
