//
//  BrandModel.m
//  BMW
//
//  Created by LiuP on 2016/12/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BrandModel.h"
#import "pinyin.h"

@implementation BrandModel

- (instancetype)initWithHotBrandDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.brandID    = [dic objectForKeyNotNull:@"brand_id"];
        self.brandName  = [dic objectForKeyNotNull:@"brand_name"];
        self.brandPic   = [dic objectForKeyNotNull:@"brand_pic"];
        self.brandClass = [dic objectForKeyNotNull:@"brand_class"];
        self.classID    = [dic objectForKeyNotNull:@"class_id"];
    }
    return self;
}

- (instancetype)initWithBrandDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.brandID    = [dic objectForKeyNotNull:@"brand_id"];
        self.brandName  = [dic objectForKeyNotNull:@"brand_name"];
        //判断首字符是否为小写字母,改为大写首字母
        NSString * regex = @"^[a-z]+$";
        NSPredicate*predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if ([predicate evaluateWithObject:[self.brandName substringToIndex:1]]) {
            self.brandName = [self.brandName capitalizedString];
        }
        
        self.pinYin     = [self translateToPingYinWithBranName:self.brandName];
    }
    return self;
}


#pragma mark -- 数据处理
- (NSString *)translateToPingYinWithBranName:(NSString *)brandName
{
    NSString * pinYin = @"";
    // 去除两头的空格和回车
    brandName = [brandName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //判断首字符是否为字母
    //NSString *regex = @"[A-Za-z]+";
    NSString * regex = @"^[A-Za-z]+$";
    NSPredicate*predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    if ([predicate evaluateWithObject:[brandName substringToIndex:1]])
    {
        //首字母大写
        pinYin = [brandName capitalizedString];
    }else{
        if(![brandName isEqualToString:@""]){
            NSString *pinYinResult=[NSString string];
            for(int j= 0;j < 1;j ++){
                NSString * singlePinyinLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([brandName characterAtIndex:j])]uppercaseString];
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            pinYin = pinYinResult;
        }else{
            pinYin = @"";
        }
    }
    return pinYin;
}

// 排序+分组+返回右侧索引字母列表
+ (NSMutableArray *)groupModels:(NSMutableArray *)models
{
    // 按照拼音首字母对model进行排序
    NSArray * sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [models sortUsingDescriptors:sortDescriptors];

    NSMutableArray * indexs = [NSMutableArray array];
    NSMutableArray * tempArr = [NSMutableArray arrayWithArray:models];
    NSMutableArray * group = [NSMutableArray array];
    NSString * tempStr;
    //拼音分组
    [models removeAllObjects];
    for (BrandModel * model in tempArr) {
        NSString * firstCh = [model.pinYin substringToIndex:1];
        if ([tempStr isEqualToString:firstCh]) {
            [group addObject:model];
        }else {
            group = [NSMutableArray array];
            [group addObject:model];
            [models addObject:group];
            tempStr = firstCh;
        }
        // 索引字母列表
        if (![indexs containsObject:firstCh]) {
            [indexs addObject:firstCh];
        }
    }
    return indexs;
}

#pragma mark -- 网络请求
/**
 获取一级分类下的热销品牌信息

 @param firstClassID
 @param complete
 */
+ (void)requestForHotBrandWithFirstClassID:(NSString *)firstClassID Complete:(BrandCallBack)complete
{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"rBrandList" parameters:@{@"classId":firstClassID} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSMutableArray * models = [NSMutableArray array];
            NSArray * data = object[@"data"];
            for (NSDictionary * dic in data) {
                [models addObject:[[self alloc] initWithHotBrandDic:dic]];
            }
            complete(YES, @"Success", models);
        }else {
            if ([object isKindOfClass:[NSDictionary class]] && [object[@"code"] integerValue] == 999) {
                complete(NO, @"", nil);
                return;
            }
            NSString * message = @"获取热销品牌的信息失败，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = [object stringByReplacingOccurrencesOfString:@"\0" withString:@""];
            }
            complete(NO, message, nil);
        }
    }];
}

/**
 获取一级分类下的品牌信息
 
 @param firstClassID
 @param complete
 */
+ (void)requestForBrandListWithFirstClassID:(NSString *)firstClassID Complete:(void(^)(BOOL success, NSString * message, NSMutableArray * models, NSMutableArray * indexs))complete
{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"BrandList" parameters:@{@"classId":firstClassID} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSMutableArray * models = [NSMutableArray array];
            NSArray * data = object[@"data"];
            for (NSDictionary * dic in data) {
                BrandModel * model = [[self alloc] initWithBrandDic:dic];
                model.classID = firstClassID;
                [models addObject:model];
            }
            // 根据首字母是否相同进行排序分组并返回右侧索引字母列表
            NSMutableArray * indexs = [self groupModels:models];
            complete(YES, @"Success", models, indexs);
        }else {
            NSString * message = @"获取品牌的信息失败，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = [object stringByReplacingOccurrencesOfString:@"\0" withString:@""];
            }
            complete(NO, message, nil, nil);
        }
    }];
}


@end
