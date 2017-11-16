//
//  Userentity.m
//  WorkByOther
//
//  Created by rr on 15/6/13.
//  Copyright (c) 2015年 wy. All rights reserved.
//

#import "Userentity.h"

@implementation Userentity


- (id)initWithJSONObject:(NSDictionary *)jsonObj
{
    if (self = [super init]) {
        self.memberID = [jsonObj objectForKeyNotNull:@"member_id"];
        self.memberName = [jsonObj objectForKeyNotNull:@"member_name"];
        self.memberTrueName = [jsonObj objectForKeyNotNull:@"member_truename"];
        self.memberAvatar = [jsonObj objectForKeyNotNull:@"member_avatar"];
        self.memberSex = [jsonObj objectForKeyNotNull:@"member_sex"];
        self.memberEmail = [jsonObj objectForKeyNotNull:@"member_email"];
        self.memberPoints = [jsonObj objectForKeyNotNull:@"member_points"];
        self.informAllow = [jsonObj objectForKeyNotNull:@"inform_allow"];
        self.isBuy = [jsonObj objectForKeyNotNull:@"is_buy"];
        self.isAllowtalk = [jsonObj objectForKeyNotNull:@"is_allowtalk"];
        self.memberState = [jsonObj objectForKeyNotNull:@"member_state"];
        self.drpOriginCode = [jsonObj objectForKeyNotNull:@"drp_origin_code"];
        self.status = [jsonObj objectForKeyNotNull:@"status"];
        self.payPassword = [jsonObj objectForKeyNotNull:@"pay_password"];
        self.availablePredeposit = [jsonObj objectForKeyNotNull:@"available_predeposit"];
        
        self.store_id = [NSString stringWithFormat:@"%@",[jsonObj objectForKeyNotNull:@"store_id"]];
        self.vip_level = [jsonObj objectForKeyNotNull:@"vip_level"];
        self.member_type = [jsonObj objectForKeyNotNull:@"member_type"];
        if ([[jsonObj objectForKeyNotNull:@"member_type"] isEqualToString:@"1"]) {
            self.member_recommend = @"";
            self.drp_recommend  =  [jsonObj objectForKeyNotNull:@"drp_code"];
        }
        
        self.availableIncome = [jsonObj objectForKeyNotNull:@"available_income"];
    }
    return self;
}


@end
