//
//  ClassModel.m
//  BMW
//
//  Created by LiuP on 2016/12/6.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ClassModel.h"

@implementation ClassModel

- (instancetype)initWithFirstDic:(NSDictionary *)firstDic
{
    self = [super init];
    if (self) {
        /*********** 一级分类信息 ************/
        self.selected = NO;
        self.gcID    = [firstDic objectForKeyNotNull:@"gc_id"];
        self.gcName  = [firstDic objectForKeyNotNull:@"gc_name"];
        self.gcImage = [firstDic objectForKeyNotNull:@"image"];
    }
    return self;
}

- (instancetype)initWithSecondDic:(NSDictionary *)secondDic
{
    self = [super init];
    if (self) {
        /*********** 二级分类信息 ************/
        self.sectionID    = [secondDic objectForKeyNotNull:@"gc_id"];
        self.sectionName  = [secondDic objectForKeyNotNull:@"gc_name"];
        if ([secondDic.allKeys containsObject:@"deep3"]) {
            self.thirdModels = [NSMutableArray array];
            NSArray * thirdData = secondDic[@"deep3"];
            for (NSDictionary * thirdDic in thirdData) {
                [self.thirdModels addObject:[[ClassModel alloc] initWithThirdDic:thirdDic]];
            }
        }
    }
    return self;
}

- (instancetype)initWithThirdDic:(NSDictionary *)thirdDic
{
    self = [super init];
    if (self) {
        /*********** 三级分类信息 ************/
        self.itemID    = [thirdDic objectForKeyNotNull:@"gc_id"];
        self.itemName  = [thirdDic objectForKeyNotNull:@"gc_name"];
        self.itemImage = [thirdDic objectForKeyNotNull:@"gc_banner"];
        CGRect rect = [TYTools boundingString:self.itemName size:CGSizeMake(55 * W_ABCW, 100) fontSize:10];
        self.lines = rect.size.height / 11;
    }
    return self;
}

#pragma mark -- 网络请求

/**
 一级分类信息

 @param complete
 */
+ (void)requestForGCFirstClassWithComplete:(ClassCallBack)complete
{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GcFirstClass" parameters:nil callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSArray * data = object[@"data"];
            NSMutableArray * models = [NSMutableArray array];
            for (NSDictionary * dic in data) {
                [models addObject:[[self alloc] initWithFirstDic:dic]];
            }
            // 默认第一个为选中
            ClassModel * model = models.firstObject;
            model.selected = YES;
            complete(YES, @"Success", models);
        }else {
            NSString * message = @"获取该分类的信息失败，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = [object stringByReplacingOccurrencesOfString:@"\0" withString:@""];
            }
            complete(NO, message, nil);
        }
    }];
}

/**
 获取一级分类下的二三级分类和banner信息

 @param GCID
 @param complete
 */
+ (void)requestForGCListWithGCID:(NSString *)GCID complete:(void(^)(BOOL success, NSString * message, NSMutableArray * models, ClassModel * bannerModel))complete
{
    NSAssert(GCID != nil, @"GCID 不能为空");
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GcAllClass" parameters:@{@"gcid":GCID} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            id data = object[@"data"];
            NSMutableArray * models = [NSMutableArray array];
            ClassModel * bannerModel;
            if ([data isKindOfClass:[NSDictionary class]]) {
                for (NSDictionary * dic in data[@"deep2"]) {
                    [models addObject:[[self alloc] initWithSecondDic:dic]];
                }
                if ([((NSDictionary *)data).allKeys containsObject:@"gc_banner"]) {
                    bannerModel = [[ClassModel alloc] init];
                    bannerModel.gcName      = [data objectForKeyNotNull:@"name"];
                    bannerModel.bannerImage = [data objectForKeyNotNull:@"gc_banner"];
                    bannerModel.bannerUrl   = [data objectForKeyNotNull:@"gc_url"];
                    bannerModel.gcType      = [data objectForKeyNotNull:@"gc_type"];
                    bannerModel.gcID        = [data objectForKeyNotNull:@"gc_id"];
                }
            }else {
                for (NSDictionary * dic in data) {
                    [models addObject:[[self alloc] initWithSecondDic:dic]];
                }
            }
 
            complete(YES, @"Success", models, bannerModel);
        }else {
            NSString * message = @"获取分类信息失败，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = [object stringByReplacingOccurrencesOfString:@"\0" withString:@""];
            }
            complete(NO, message, nil, nil);
        }
    }];
}

@end
