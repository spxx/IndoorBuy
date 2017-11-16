//
//  PayMethodModel.m
//  BMW
//
//  Created by LiuP on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "PayMethodModel.h"

@implementation PayMethodModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        /********余额支付检查与冻结余额********/
        self.pdAmount = [dic objectForKeyNotNull:@"pd_amount"];
        self.amount   = [dic objectForKeyNotNull:@"amount"];
        /********订单详情信息********/
        self.personCash = [dic objectForKeyNotNull:@"available"];
        self.personCash = [NSString stringWithFormat:@"%.2f", self.personCash.floatValue];
        self.freezedCash = [dic objectForKeyNotNull:@"available_free"];
        self.freezedCash = [NSString stringWithFormat:@"%.2f", self.freezedCash.floatValue];
        self.payCode     = [dic objectForKeyNotNull:@"payment_code"];
    }
    return self;
}


/**
 验证交易密码
 
 @param password
 @param complete
 */
+ (void)requestForVerifyWithPassword:(NSString *)password complete:(void(^)(BOOL isSuccess, NSString * message))complete
{
    NSString * userId = [JCUserContext sharedManager].currentUserInfo.memberID;
    NSDictionary * paraDic = @{@"userId":userId,
                               @"pass":password};
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"MoneyPay" parameters:paraDic callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            complete(YES, @"Success");
        }else {
            NSString * message = @"验证交易密码失败，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(NO, message);
        }
    }];
}

/**
 支付检查

 @param paySn
 @param complete
 */
+ (void)requestForUserMoneyWithPaySn:(NSString *)paySn password:(NSString *)password money:(NSString *)money complete:(void(^)(BOOL isSuccess, PayMethodModel * model, NSString * message))complete
{
    NSString * userID = [JCUserContext sharedManager].currentUserInfo.memberID;
    NSDictionary * paraDic = @{@"userId":userID,
                               @"paySn":paySn,
                               @"pay_password":password,
                               @"money":money};
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"IncomePay" parameters:paraDic callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSDictionary * data = object[@"data"];
            PayMethodModel * model = [[self alloc] initWithDic:data];
            complete(YES, model, @"Success");
            
        }else {
            NSString * message = @"支付出现问题，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(NO, nil, message);
        }
    }];
}

/**
 订单详情

 @param orderID
 @param complete 
 */
+ (void)requestForOrderDetailWithOrderID:(NSString *)orderID complete:(void(^)(BOOL isSuccess, PayMethodModel * model, NSString * message))complete
{
    NSString * userID = [JCUserContext sharedManager].currentUserInfo.memberID;
    NSDictionary * paraDic = @{@"userId":userID, @"orderId":orderID};
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"OrderDetail" parameters:paraDic callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSDictionary * data = object[@"data"];
            PayMethodModel * model = [[self alloc] initWithDic:data];
            complete(YES, model, @"Success");
        }else {
            NSString * message = @"获取订单信息失败，请稍后再试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(YES, nil, message);
        }
    }];
}

/**
 预支付

 @param paySn
 @param type 1:单独支付 2:混合支付
 @param complete
 */
+ (void)requestForMemberPayWithPaySn:(NSString *)paySn
                                type:(NSString *)type
                             payCode:(NSString *)payCode
                            complete:(void(^)(BOOL isSuccess, PayMethodModel * model, NSString * message))complete
{
    NSString * userID = [JCUserContext sharedManager].currentUserInfo.memberID;
    NSDictionary * paraDic = @{@"userId":userID, @"paySn":paySn, @"type":type, @"payCode":payCode};
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"MemberPay" parameters:paraDic callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSDictionary * data = object[@"data"];
            PayMethodModel * model = [[self alloc] initWithDic:data];
            complete(YES, model, @"Success");
        }else {
            NSString * message = @"支付出现问题，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(NO, nil, message);
        }
    }];
}

/**
 微信支付

 @param paraDic
 @param complete
 */
+ (void)requestForWXPayWithParaDic:(NSDictionary *)paraDic complete:(void(^)(BOOL isSuccess, NSDictionary * data, NSString * message))complete
{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"WxOrderPay" parameters:paraDic callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            complete(YES, object[@"data"], @"");
        }else {
            NSString * message = @"支付出现问题，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(NO, nil, message);
        }
    }];
}


/**
 招行一卡通

 @param amount
 @param orderSn
 @param complete
 */
+ (void)requestForOneNetWithAmount:(NSString *)amount
                           orderSn:(NSString *)orderSn
                          complete:(void(^)(BOOL isSuccess, PayMethodModel * model, NSString * message))complete
{
    NSDate *data = [NSDate date];
    NSDateFormatter *df1 = [[NSDateFormatter alloc]init];//格式化
    
    [df1 setDateFormat:@"yyyyMMddHHmmss"];
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc]init];//格式化
    
    [df2 setDateFormat:@"yyyyMMdd"];
    
    
    NSString* dateTime = [df1 stringFromDate:data];
    NSString* date = [df2 stringFromDate:data];
    
    NSDictionary *dataDic = @{@"agrNo":@"12345",
                              @"amount":[NSString stringWithFormat:@"%.2f",amount.floatValue],
                              @"branchNo":@"0028",
                              @"cardType":@"",
                              @"clientIP":@"",
                              @"date":date,
                              @"dateTime":dateTime,
                              @"expireTimeSpan":@"30",
                              @"lat":@"",
                              @"lon":@"",
                              @"merchantNo":YiwangtongNo,
                              @"merchantSerialNo":@"",
                              @"mobile":@"",
                              @"orderNo":orderSn,
                              @"payNoticePara":@"",
                              @"payNoticeUrl":YiwangtongPay,
                              @"returnUrl":@"http://CMBNPRM",
                              @"riskLevel":@"",
                              @"signNoticePara":@"",
                              @"signNoticeUrl":YiwangtongSign,
                              @"userID":[JCUserContext sharedManager].currentUserInfo.memberID};
    NSString *json = [TYTools dataJsonWithDic:dataDic];
    json = [TYTools JSONDataStringTranslation:json];
    
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"PwdPay" parameters:@{@"signdata":json} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            PayMethodModel * model = [[self alloc] init];
            model.oneNetData = [NSDictionary dictionaryWithDictionary:object[@"data"]];
            model.date = date;
            model.dateTime = dateTime;
            complete(YES, model, @"Success");

        }else{
            NSString * message = @"获取一网通信息失败，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(NO, nil, message);
        }
    }];
}


@end
