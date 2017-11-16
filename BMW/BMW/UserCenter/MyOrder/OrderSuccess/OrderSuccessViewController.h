//
//  OrderSuccessViewController.h
//  BMW
//
//  Created by rr on 16/3/17.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BaseVC.h"

@interface OrderSuccessViewController : BaseVC

//@property(nonatomic, assign)NSDictionary *dataSource;

@property (nonatomic, copy) NSString * orderID;


@property(nonatomic, assign)BOOL whereFrom;
/**
 *  vip支付成功界面
 */
@property (nonatomic, assign)BOOL isVipSuccess;
/**
 *  余额充值支付成功界面
 */
@property (nonatomic, assign)BOOL isRecgargeBalancesSuccess;

@end
