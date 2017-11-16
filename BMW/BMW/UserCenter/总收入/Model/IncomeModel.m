//
//  IncomeModel.m
//  BMW
//
//  Created by LiuP on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "IncomeModel.h"

@implementation IncomeModel

- (instancetype)initWithDic:(NSDictionary *)dic member:(MemberType)member
{
    self = [super init];
    if (self) {
        self.award      = [dic objectForKeyNotNull:@"invitation_people"];
        self.needNum    = [dic objectForKeyNotNull:@"people"];
        // 所有收入项目
        NSString * shareTotal       = [dic objectForKeyNotNull:@"share_total"];         // 邀请奖励
        shareTotal                  = [NSString stringWithFormat:@"%.2f", shareTotal.floatValue];
        NSString * backTotal        = [dic objectForKeyNotNull:@"back_total"];          // 专享返现
        backTotal                   = [NSString stringWithFormat:@"%.2f", backTotal.floatValue];
        NSString * slaveTotal       = [dic objectForKeyNotNull:@"slave_total"];         // 直属收益
        slaveTotal                  = [NSString stringWithFormat:@"%.2f", slaveTotal.floatValue];
        NSString * teamSaleTotal    = [dic objectForKeyNotNull:@"team_sale_total"];     // 团队销售
        teamSaleTotal               = [NSString stringWithFormat:@"%.2f", teamSaleTotal.floatValue];
        NSString * teamExtendTotal  = [dic objectForKeyNotNull:@"team_extend_total"];   // 团队扩展
        teamExtendTotal             = [NSString stringWithFormat:@"%.2f", teamExtendTotal.floatValue];
        NSString * teamHatchTotal   = [dic objectForKeyNotNull:@"team_hatch_total"];    // 团队孵化
        teamHatchTotal              = [NSString stringWithFormat:@"%.2f", teamHatchTotal.floatValue];
        if (member == MemberMK) {
            self.allIncomes = @[shareTotal, backTotal];
        }else if (member == MemberService ) {
            self.allIncomes = @[shareTotal, backTotal, slaveTotal];
        }else if (member == MemberPartner) {
            self.allIncomes = @[shareTotal, backTotal, slaveTotal, teamSaleTotal, teamExtendTotal, teamHatchTotal];
        }else {
            self.allIncomes = @[];
        }
        self.totalIncome = 0;
        for (NSString * cash in self.allIncomes) {
            self.totalIncome += cash.floatValue;
        }
        NSMutableArray * percents = [NSMutableArray array];
        for (NSString * cash in self.allIncomes) {
            NSString * percent = [NSString stringWithFormat:@"%f", cash.floatValue / self.totalIncome];
            [percents addObject:percent];
        }
        self.percents = [NSArray arrayWithArray:percents];
        // 红色部分item
        NSString * inSettlement     = [dic objectForKeyNotNull:@"in_settlement"];   // 结算中
        inSettlement                = [NSString stringWithFormat:@"%.2f", inSettlement.floatValue];
        NSString * totalMoney       = [dic objectForKeyNotNull:@"total_money"];     // 到账收入
        totalMoney                  = [NSString stringWithFormat:@"%.2f", totalMoney.floatValue];
        NSString * incomeAudit      = [dic objectForKeyNotNull:@"income_audit"];    // 提现审核
        incomeAudit                 = [NSString stringWithFormat:@"%.2f", incomeAudit.floatValue];
        NSString * incomeComplete   = [dic objectForKeyNotNull:@"income_complete"]; // 已提现
        incomeComplete              = [NSString stringWithFormat:@"%.2f", incomeComplete.floatValue];
        self.totalIncomes = @[totalMoney, inSettlement, incomeAudit, incomeComplete];
        
    }
    return self;
}


/**
 获取收入相关信息

 @param complete
 */
+ (void)requestForIncomeWithMember:(MemberType)member
                          Complete:(void(^)(BOOL isSuccess, IncomeModel * model, NSString * message))complete
{
    NSString * userId = [JCUserContext sharedManager].currentUserInfo.memberID;
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"MemberIncome" parameters:@{@"userId":userId} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSDictionary * data = object[@"data"];
            IncomeModel * model = [[self alloc] initWithDic:data member:member];
            complete(YES, model, @"Success");
        }else if (result == RequestResultEmptyData){
            complete(NO, nil, @"您暂时还有任何收入数据");
        }else {
            NSString * message = @"获取收入相关信息失败，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            complete(NO, nil, message);
        }
    }];
}

@end
