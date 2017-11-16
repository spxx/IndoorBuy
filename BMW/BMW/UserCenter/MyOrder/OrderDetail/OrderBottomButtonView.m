//
//  OrderBottomButtonView.m
//  BMW
//
//  Created by 白琴 on 16/3/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OrderBottomButtonView.h"
#import "MZTimerLabel.h"

@interface OrderBottomButtonView () <MZTimerLabelDelegate> {
    NSString * _state;
    UILabel * _timer_show;
    MZTimerLabel * _timerCutDown;
}

@end

@implementation OrderBottomButtonView

- (instancetype)initWithFrame:(CGRect)frame state:(NSString *)state addOrderTime:(NSString *)addOrderTime evaluationState:(NSString *)evaluationState ServerTime:(NSString *)ServerTime{
    self = [super initWithFrame:frame];
    if (self) {
        _state = state;
        
        UIView * line = [UIView new];
        line.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [line align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [self addSubview:line];
        
        /**
         *  button1、2、3、4按顺序从右往左
         */
        UIButton * button1 = [UIButton new];
        button1.viewSize = CGSizeMake(60 * W_ABCW, 26);
        [button1 align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15 * W_ABCW, (self.viewHeight - button1.viewHeight) / 2)];
        [button1 setTitleColor:COLOR_NAVIGATIONBAR_BARTINT forState:UIControlStateNormal];
        button1.layer.borderWidth = 1;
        button1.layer.borderColor = COLOR_NAVIGATIONBAR_BARTINT.CGColor;
        button1.layer.cornerRadius = 6;
        button1.titleLabel.font = fontForSize(12);
        [button1 addTarget:self action:@selector(processButton1:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button1];
        
        if ([state isEqualToString:@"10"]) {
            //如果是待付款
            NSInteger time = [ServerTime integerValue] - [addOrderTime integerValue];
            //24小时 == 86400秒
            if (time < 86400) {
                [button1 setTitle:nil forState:UIControlStateNormal];
                //UILabel设置成和UIButton一样的尺寸和位置
                _timer_show = [UILabel new];
                _timer_show.viewSize = CGSizeMake(100, 26);
                _timer_show.text = @"支付(00:00:00)";
                _timer_show.font = fontForSize(12);
                [_timer_show sizeToFit];
                _timer_show.viewSize = CGSizeMake(_timer_show.viewWidth + 18 * W_ABCW, 26);
                [_timer_show align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
                _timer_show.text = nil;
                button1.viewSize = _timer_show.viewSize;
                //把timer_show添加到按钮上
                [button1 addSubview:_timer_show];
                //创建MZTimerLabel类的对象_timerCutDown
                _timerCutDown = [[MZTimerLabel alloc] initWithLabel:_timer_show andTimerType:MZTimerLabelTypeTimer];
                //倒计时时间60s
                [_timerCutDown setCountDownTime:86400 - time];
                //倒计时格式,也可以是@"HH:mm:ss"
                _timerCutDown.timeFormat = @"支付(HH:mm:ss)";
                _timerCutDown.timeLabel.backgroundColor = [UIColor colorWithHex:0xfd5478];
                _timerCutDown.layer.cornerRadius = 6;
                _timerCutDown.layer.masksToBounds = YES;
                _timerCutDown.timeLabel.layer.cornerRadius = 6;
                _timerCutDown.timeLabel.layer.masksToBounds = YES;
                _timerCutDown.timeLabel.textColor = [UIColor whiteColor];//倒计时字体颜色
                _timerCutDown.timeLabel.font = [UIFont systemFontOfSize:12];//倒计时字体大小
                _timerCutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//居中
                //设置代理，以便后面倒计时结束时调用代理
                _timerCutDown.delegate = self;
                //开始计时
                [_timerCutDown start];
            }
        }
        UIButton * button2 = [UIButton new];
        button2.viewSize = CGSizeMake(60 * W_ABCW, 26);
        [button2 align:ViewAlignmentTopRight relativeToPoint:CGPointMake(button1.viewX - 7 * W_ABCW, (self.viewHeight - button2.viewHeight) / 2)];
        [button2 setTitleColor:[UIColor colorWithHex:0x3d3d3d] forState:UIControlStateNormal];
        button2.layer.borderWidth = 1;
        button2.layer.borderColor = [UIColor colorWithHex:0x69696b].CGColor;
        button2.layer.cornerRadius = 6;
        button2.titleLabel.font = fontForSize(12);
        [button2 addTarget:self action:@selector(processButton2:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button2];
        if ([state isEqualToString:@"0"]) {
            //已取消
            [button1 setTitle:@"重新购买" forState:UIControlStateNormal];
            [button1.titleLabel sizeToFit];
            button1.viewSize = CGSizeMake(button1.titleLabel.viewWidth + 18 * W_ABCW, button1.viewHeight);
//            button2.hidden = YES;
            [button2 setTitle:@"删除订单" forState:UIControlStateNormal];
        }
        else if ([state isEqualToString:@"10"]) {
            //待付款
            [button2 setTitle:@"取消订单" forState:UIControlStateNormal];
        }
        else if ([state isEqualToString:@"20"]) {
            //待发货
            [button1 setTitle:@"提醒发货" forState:UIControlStateNormal];
            [button1.titleLabel sizeToFit];
            button1.viewSize = CGSizeMake(button1.titleLabel.viewWidth + 18 * W_ABCW, button1.viewHeight);
            [button2 setTitle:@"申请退款" forState:UIControlStateNormal];
        }
        else if ([state isEqualToString:@"30"]) {
            //待收货
            [button1 setTitle:@"确认收货" forState:UIControlStateNormal];
            [button1.titleLabel sizeToFit];
            button1.viewSize = CGSizeMake(button1.titleLabel.viewWidth + 18 * W_ABCW, button1.viewHeight);
            [button2 setTitle:@"退款/退货" forState:UIControlStateNormal];
        }
        else if ([state isEqualToString:@"40"]) {
            //交易成功
            [button1 setTitle:@"再次购买" forState:UIControlStateNormal];
            [button1.titleLabel sizeToFit];
            button1.viewSize = CGSizeMake(button1.titleLabel.viewWidth + 18 * W_ABCW, button1.viewHeight);
            [button2 setTitle:@"评价订单" forState:UIControlStateNormal];
            if ([evaluationState boolValue]) {
                [button2 setTitle:@"已评价" forState:UIControlStateNormal];
                button2.userInteractionEnabled = NO;
            }
            
        }
        
        [button1 align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15 * W_ABCW, (self.viewHeight - button1.viewHeight) / 2)];
        [button2.titleLabel sizeToFit];
        button2.viewSize = CGSizeMake(button2.titleLabel.viewWidth + 18 * W_ABCW, button2.viewHeight);
        [button2 align:ViewAlignmentTopRight relativeToPoint:CGPointMake(button1.viewX - 7 * W_ABCW, (self.viewHeight - button2.viewHeight) / 2)];
        
        if ([state isEqualToString:@"40"]) {
            UIButton * button3 = [UIButton new];
            button3.viewSize = CGSizeMake(60 * W_ABCW, 26);
            [button3 setTitle:@"申请退货" forState:UIControlStateNormal];
            [button3 setTitleColor:[UIColor colorWithHex:0x3d3d3d] forState:UIControlStateNormal];
            [button3 addTarget:self action:@selector(processButton3:) forControlEvents:UIControlEventTouchUpInside];
            button3.layer.borderWidth = 1;
            button3.layer.borderColor = [UIColor colorWithHex:0x69696b].CGColor;
            button3.layer.cornerRadius = 6;
            button3.titleLabel.font = fontForSize(12);
            [button3.titleLabel sizeToFit];
            button3.viewSize = CGSizeMake(button3.titleLabel.viewWidth + 18 * W_ABCW, button3.viewHeight);
            [button3 align:ViewAlignmentTopRight relativeToPoint:CGPointMake(button2.viewX - 7 * W_ABCW, (self.viewHeight - button3.viewHeight) / 2)];
            [self addSubview:button3];
        }
    }
    return self;
}

- (void)processButton1:(UIButton *)sender {
    if ([_state isEqualToString:@"0"]) {
        //再次购买
        self.buyAgain();
    }
    else if ([_state isEqualToString:@"10"]) {
        //支付
        self.payOrder();
    }
    else if ([_state isEqualToString:@"20"]) {
        //提醒发货
        self.remindSendOutGoods();
    }
    else if ([_state isEqualToString:@"30"]) {
        //确认收货
        self.affirmReceiving();
    }
    else if ([_state isEqualToString:@"40"]) {
        //再次购买
        self.buyAgain();
    }
}
- (void)processButton2:(UIButton *)sender {
    if ([_state isEqualToString:@"0"]) {
        //删除订单
//        self.cancelOrder();
        self.deleteOrder();
    }
    else if ([_state isEqualToString:@"10"]) {
        //取消订单
        self.cancelOrder();
    }
    else if ([_state isEqualToString:@"20"]) {
        //退款退货
        self.refundOrReturns();
    }
    else if ([_state isEqualToString:@"30"]) {
        //退款退货
        self.refundOrReturns();
    }
    else if ([_state isEqualToString:@"40"]) {
        //评价订单
        self.evaluateOrder();
    }
}
- (void)processButton3:(UIButton *)sender {
    //申请退款
    self.refundOrReturns();
}

#pragma mark -- 其他
- (NSInteger)ComputingTimeWithString:(NSString *)timeString {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger addTime = [timeString integerValue];
    NSDate * addDate = [NSDate dateWithTimeIntervalSince1970:addTime];
    NSInteger addInterval = [zone secondsFromGMTForDate:addDate];
    NSDate * addLocaleDate = [addDate dateByAddingTimeInterval:addInterval];
    NSInteger addTime1 = [addLocaleDate timeIntervalSince1970];
    
    //获取当前时间
    NSDate *date = [NSDate date];
    NSInteger interval1 = [zone secondsFromGMTForDate:date];
    NSDate *localeDate1 = [date dateByAddingTimeInterval:interval1];
    NSInteger nowTime = [localeDate1 timeIntervalSince1970];
    
    NSInteger lTime = nowTime - addTime1;
    return lTime;
}
#pragma mark -- MZTimerLabelDelegate
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    [_timerCutDown pause];              //暂停倒计时
    [_timer_show removeFromSuperview];//移除倒计时模块
    self.countdownOver();

}


@end
