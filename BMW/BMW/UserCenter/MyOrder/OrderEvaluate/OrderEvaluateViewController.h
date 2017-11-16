//
//  OrderEvaluateViewController.h
//  BMW
//
//  Created by gukai on 16/3/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BaseVC.h"

typedef void(^RefreshBlock)(void);
@interface OrderEvaluateViewController : BaseVC
@property(nonatomic,copy)NSArray * dataSource;
@property(nonatomic,copy)NSDictionary * orderDic;

@property(nonatomic,strong)RefreshBlock refresh;
@end
