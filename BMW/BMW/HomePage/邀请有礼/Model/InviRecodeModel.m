//
//  InviRecodeModel.m
//  BMW
//
//  Created by rr on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "InviRecodeModel.h"




@implementation InviRecodeModel

-(instancetype)initWithDic:(NSDictionary *)dic andTopDic:(NSDictionary *)topdic{
    if (self = [super init]) {
        self.cd = [[TYTools getTimeToShowWithTimestamp:[dic objectForKeyNotNull:@"cd"]] substringToIndex:10];
        self.inviter = [dic objectForKeyNotNull:@"inviter"];
        self.shareone_voucher_price = [dic objectForKeyNotNull:@"shareone_voucher_price"];
        self.shareone_vouchernum = [dic objectForKeyNotNull:@"shareone_vouchernum"];
        self.num = [topdic objectForKeyNotNull:@"num"];
        self.Tprice = [topdic objectForKeyNotNull:@"Tprice"];
    }
    return self;
}


+(void)requestRecordWithnum:(NSInteger )num finish:(void (^)(NSInteger, NSMutableArray *, NSString *))finish{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"ShareRecord" parameters:@{@"userName":[JCUserContext sharedManager].currentUserInfo.memberName,@"start":[NSString stringWithFormat:@"%ld",(long)num],@"limit":@"20"} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSLog(@"%@",object);
            NSMutableArray *dataArray = [NSMutableArray array];
            for (NSDictionary *dic in object[@"data"][@"content"]) {
                InviRecodeModel *model = [[InviRecodeModel alloc] initWithDic:dic andTopDic:object[@"data"][@"statistical"]];
                [dataArray addObject:model];
            }
            finish(100,dataArray,@"success");
        }else if (result == RequestResultEmptyData){
            finish(902,nil,@"emty");
        }else{
            finish(999,nil,object);
        }
        
    }];
}


@end
