//
//  ChoosePayWayView.h
//  BMW
//
//  Created by 白琴 on 16/5/25.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePayWayView : UIView

/**
 *index 0:支付宝 1:微信 2:一网通
 */
@property(nonatomic, strong) void(^buttonPress)(NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame payWayArray:(NSArray *)payWayArray payWayImageArray:(NSArray *)payWayImageArray isNeedTitle:(BOOL)isNeedTitle;

@end
