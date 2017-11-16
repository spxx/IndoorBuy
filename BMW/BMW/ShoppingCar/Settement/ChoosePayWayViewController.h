//
//  ChoosePayWayViewController.h
//  BMW
//
//  Created by 白琴 on 16/3/17.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BaseVC.h"

@interface ChoosePayWayViewController : BaseVC

/**
 *  是否返回最外层的界面
 */
@property (nonatomic, assign)BOOL isPopRootVC;
/**
 *  上一个界面传入
 */
@property (nonatomic, strong)NSMutableDictionary * dataSourceDic;
/**
 *  只有一种支付方式【支付方式为通联传YES 否则为NO】上一个界面传入
 */
@property (nonatomic, assign)BOOL isOnePayWay;

@end
