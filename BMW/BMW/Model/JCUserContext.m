//
//  JCUserContext.m
//  WorkByOther
//
//  Created by rr on 15/6/13.
//  Copyright (c) 2015年 wy. All rights reserved.
//

#import "JCUserContext.h"

#define k_user_password @"loggedInUserPassword"
#define k_user_mobile @"loggedInUserMobile"
#define k_user_detail @"loggedInUserDetail"


@implementation JCUserContext

- (void)removeCurrentUser
{
    self.currentUserInfo = nil;
    //销毁timer
    self.otherPhone = nil;
    self.otherCount = 0;
    [self.otherTimer invalidate];
    self.otherTimer = nil;
    
    self.registPhone = nil;
    self.registCount = 0;
    [self.registTimer invalidate];
    self.registTimer = nil;
    
    self.payPasswordCount = 0;
    [self.payPasswordTimer invalidate];
    self.payPasswordTimer = nil;
    
}

- (BOOL)isUserLogedIn
{
    return self.currentUserInfo != nil;
}

- (NSString *)titleBouns{
    NSString * titleSize = [[NSUserDefaults standardUserDefaults]objectForKey:@"titleSize"];
    return titleSize;
}

- (void)titleSize:(NSString *)size{
    [[NSUserDefaults standardUserDefaults]setObject:size forKey:@"titleSize"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)updateUserInfo:(Userentity *)userInfo
{
    _currentUserInfo = userInfo;
    [self saveUserInfo:userInfo];
}

- (void)upDateObject:(id)object forKey:(id)key {
    NSMutableDictionary * rememberUserInfo = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:k_user_detail]];
    [rememberUserInfo setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults]setObject:rememberUserInfo forKey:k_user_detail];
    [[NSUserDefaults standardUserDefaults]synchronize];
    Userentity *user = [[Userentity alloc] initWithJSONObject:rememberUserInfo];
    [self updateUserInfo:user];
}


- (void)initUserState
{
    Userentity * savedUser = [self getSavedUserInfo];
    if (savedUser.memberID) {
        _currentUserInfo = savedUser;
    } else {
        [[NSUserDefaults standardUserDefaults]setObject:@"100" forKey:@"titleSize"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}
- (Userentity *)getSavedUserInfo
{
    
    NSDictionary * userDetail = [[NSUserDefaults standardUserDefaults]objectForKey:k_user_detail];
    
    NSString * memberID = [userDetail objectForKey:@"member_id"];
    NSString * memberName = [userDetail objectForKey:@"member_name"];
    NSString * memberTrueName = [userDetail objectForKey:@"member_truename"];
    NSString * memberAvatar = [userDetail objectForKey:@"member_avatar"];
    NSString * memberSex = [userDetail objectForKey:@"member_sex"];
    NSString * memberEmail = [userDetail objectForKey:@"member_email"];
    NSString * memberPoints = [userDetail objectForKey:@"member_points"];
    NSString * informAllow = [userDetail objectForKey:@"inform_allow"];
    NSString * isBuy = [userDetail objectForKey:@"is_buy"];
    NSString * isAllowtalk = [userDetail objectForKey:@"is_allowtalk"];
    NSString * memberState = [userDetail objectForKey:@"member_state"];
    NSString * drpOriginCode = [userDetail objectForKey:@"drp_origin_code"];
    NSString * status = [userDetail objectForKey:@"status"];
    NSString * payPassword = [userDetail objectForKey:@"pay_password"];
    NSString * availablePredeposit = [userDetail objectForKey:@"available_predeposit"];
    NSString * store_id = [userDetail objectForKey:@"store_id"];
    NSString * vip_level = [userDetail objectForKey:@"vip_level"];
    NSString * member_recommend = [userDetail objectForKey:@"member_recommend"];
    NSString * member_type = [userDetail objectForKey:@"member_type"];
    NSString * drp_recommend = [userDetail objectForKey:@"drp_recommend"];
    
    NSString * available_income = [userDetail objectForKey:@"available_income"];
    
    Userentity * detailUserInfo = [Userentity new];
    detailUserInfo.memberID = memberID;
    detailUserInfo.memberName = memberName;
    detailUserInfo.memberTrueName = memberTrueName;
    detailUserInfo.memberAvatar = memberAvatar;
    detailUserInfo.memberSex = memberSex;
    detailUserInfo.memberEmail = memberEmail;
    detailUserInfo.memberPoints = memberPoints;
    detailUserInfo.informAllow = informAllow;
    detailUserInfo.isBuy = isBuy;
    detailUserInfo.isAllowtalk = isAllowtalk;
    detailUserInfo.memberState = memberState;
    detailUserInfo.drpOriginCode = drpOriginCode;
    detailUserInfo.status = status;
    detailUserInfo.payPassword = payPassword;
    detailUserInfo.availablePredeposit = availablePredeposit;
    detailUserInfo.store_id = store_id;
    detailUserInfo.vip_level = vip_level;
    detailUserInfo.member_recommend = member_recommend;
    detailUserInfo.member_type = member_type;
    detailUserInfo.drp_recommend = drp_recommend;
    
    detailUserInfo.availableIncome = available_income;
    
    return detailUserInfo;
}


- (void)saveUserInfo:(Userentity *)userInfo
{
    [[NSUserDefaults standardUserDefaults]setObject:@{@"member_id":userInfo.memberID,
                                                      @"member_name":userInfo.memberName,
                                                      @"member_truename":userInfo.memberTrueName?userInfo.memberTrueName:[NSString stringWithFormat:@"BM%@", userInfo.memberID],
                                                      @"member_avatar":userInfo.memberAvatar?userInfo.memberAvatar:@"",
                                                      @"member_sex":userInfo.memberSex?userInfo.memberSex:@"未设置默认值",
                                                      @"member_email":userInfo.memberEmail?userInfo.memberEmail:@"未设置默认值",
                                                      @"member_points":userInfo.memberPoints,
                                                      @"inform_allow":userInfo.informAllow,
                                                      @"is_buy":userInfo.isBuy,
                                                      @"is_allowtalk":userInfo.isAllowtalk,
                                                      @"member_state":userInfo.memberState,
                                                      @"drp_origin_code":userInfo.drpOriginCode?userInfo.drpOriginCode:@"未设置默认值",
                                                      @"status":userInfo.status?userInfo.status:@"0",
                                                      @"pay_password":userInfo.payPassword?userInfo.payPassword:@"",
                                                      @"available_predeposit":userInfo.availablePredeposit,
                                                      @"available_income":userInfo.availableIncome,
                                                      @"store_id":userInfo.store_id?userInfo.store_id:@"0",
                                                      @"vip_level":userInfo.vip_level?userInfo.vip_level:@"0",
                                                      @"member_type":userInfo.member_type,
                                                      @"member_recommend":userInfo.member_recommend?userInfo.member_recommend:@"0",
                                                      @"drp_code":userInfo.drp_recommend?userInfo.drp_recommend:@"0"} forKey:k_user_detail];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (void)clearSavedUserInfo
{
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:k_user_detail];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - * Singlton *
+ (JCUserContext*)sharedManager
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^ {
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

@end


