//
//  CodeModel.m
//  DP
//
//  Created by LiuP on 16/8/9.
//  Copyright © 2016年 sp. All rights reserved.
//

#import "CodeModel.h"

@implementation CodeModel


/**
 生成二维码地址

 @param shareUrl
 @param complete 
 */
+ (void)requestForCreateCodeWithShareUrl:(NSString *)shareUrl
                                complete:(void(^)(NSString * imageUrl, NSString * message, NSInteger code))complete
{
    NSString * userId = [JCUserContext sharedManager].currentUserInfo.memberID;
    NSDictionary * paraDic = @{@"url":shareUrl, @"userId":userId};
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"ProductionCode" parameters:paraDic callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSDictionary * dataDic = object[@"data"];
            complete(dataDic[@"codeImg"], @"Success", 100);
        }else {
            complete(nil, object, -1);
        }
    }];
}

@end
