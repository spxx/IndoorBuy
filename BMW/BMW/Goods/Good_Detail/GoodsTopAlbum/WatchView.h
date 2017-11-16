//
//  WatchView.h
//  BMW
//
//  Created by rr on 16/10/29.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WatchView : UIView

/**
 *  结束的回调
 */
@property (nonatomic, copy) void (^TimerStopComplete)();

/**
 *  根据指定结束时间开始倒计时
 *
 *  @param endStr NSString格式的结束时间
 */
- (void)countDownViewWithEndString:(NSString *)endStr;

-(void)xiaohui;

@end
