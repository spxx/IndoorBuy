//
//  Userentity.h
//  WorkByOther
//
//  Created by rr on 15/6/13.
//  Copyright (c) 2015年 wy. All rights reserved.
//

#import "MTLModel.h"

@interface Userentity : MTLModel

@property (nonatomic, strong)NSString * memberID;               //会员ID
@property (nonatomic, strong)NSString * memberName;             //会员名，即登陆手机号码
@property (nonatomic, strong)NSString * memberTrueName;         //会员真实姓名
@property (nonatomic, strong)NSString * memberAvatar;           //头像地址
@property (nonatomic, strong)NSString * memberSex;              //性别，1为男，0为女
@property (nonatomic, strong)NSString * memberEmail;            //会员邮箱
@property (nonatomic, strong)NSString * memberPoints;           //会员积分
@property (nonatomic, strong)NSString * informAllow;            //是否允许举报 1可以 2不可以
@property (nonatomic, strong)NSString * isBuy;                  //是否可用购买 1开启 0关闭
@property (nonatomic, strong)NSString * isAllowtalk;            //是否具有咨询和发送站内信息的权限 1开启 0关闭
@property (nonatomic, strong)NSString * memberState;            //会员的开启状态  1开启 0关闭
@property (nonatomic, strong)NSString * drpOriginCode;          //Drp 分销系统带入 code
//会员状态判断【0非会员10正式会员20卡申请中30绑卡失败40过期】
@property (nonatomic, strong)NSString * status;                 /**< 10 正式会员 */

@property (nonatomic, strong)NSString * payPassword;             //支付密码
@property (nonatomic, strong)NSString * availablePredeposit;    //用户余额

@property(nonatomic, strong)NSString *store_id; /**< 绑定的店铺id */
@property(nonatomic, strong)NSString *vip_level; /**< 0：普通用户 1:店长 2:服务商 3:合伙人 */
@property(nonatomic, strong)NSString *member_type;/**<  判断分销商*/
@property(nonatomic, strong)NSString *drp_recommend; /**< 分销商 */
@property(nonatomic, strong)NSString *member_recommend; /**<  非分销商*/

@property(nonatomic, copy) NSString * availableIncome;    /**< 可用收入 */

- (id)initWithJSONObject:(NSDictionary *)jsonObj;

@end
