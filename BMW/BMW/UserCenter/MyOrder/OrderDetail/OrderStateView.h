//
//  OrderStateView.h
//  BMW
//
//  Created by 白琴 on 16/3/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderStateView : UIView

@property (nonatomic, copy)void(^showLogisticsInformation)();
/**
 *  订单状态
 *
 *  @param frame         view的大小及位置
 *  @param dataSourceDic 数据源
 */
- (instancetype)initWithFrame:(CGRect)frame dataSourceDic:(NSDictionary *)dataSourceDic;

@end
