//
//  GotoVipViewController.h
//  BMW
//
//  Created by rr on 16/3/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BaseVC.h"

@interface GotoVipViewController : BaseVC
/**
 *  服务器时间[续费时传入]
 */
@property (nonatomic, strong)NSString * serviceTime;
/**
 *  到期时间[续费时传入]
 */
@property (nonatomic, strong)NSString * endTime;
/**
 *  会员激活之后返回的数据[会员激活界面传入]
 */
@property(nonatomic, strong)NSDictionary * orderInfoDic;
/**
 *  YES 进入付费界面    NO进入加入会员界面
 */
@property(nonatomic,assign)BOOL joinOrRegis;

/**
 *  是vip 则进入续费界面
 */
@property(nonatomic,assign)BOOL isVIP;

@end
