//
//  InvitationModel.m
//  BMW
//
//  Created by rr on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "InvitationModel.h"

@implementation InvitationModel

+(void)requestImage:(void (^)(BOOL, NSDictionary *, NSString *))finish{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetShareImage" parameters:nil callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSLog(@"%@",object[@"data"]);
            finish(YES,object[@"data"],@"success");
        }else{
            finish(NO,nil,@"暂无广告图片");
        }
    }];
}

@end
