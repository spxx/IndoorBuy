//
//  OrderDetailViewController.h
//  BMW
//
//  Created by 白琴 on 16/3/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BaseVC.h"

@interface OrderDetailViewController : BaseVC

@property(nonatomic,assign)BOOL backToRoot;

@property (nonatomic, strong)NSDictionary * dataSourceDic;


/**
 *  跳转该页面的时候  传入的订单ID
 */
@property (nonatomic, strong)NSString * orderId;

@property (nonatomic, copy) NSString * backType;    // 是否使用了余额支付

@end
