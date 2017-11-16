//
//  WatchView.m
//  BMW
//
//  Created by rr on 16/10/29.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "WatchView.h"


@interface WatchView ()
{
    dispatch_source_t _timer;
}
/** 小时 */
@property (strong, nonatomic) UILabel *hourLabel;
/** 分钟 */
@property (strong, nonatomic) UILabel *minuteLabel;
/** 秒 */
@property (strong, nonatomic) UILabel *secondLabel;
/** 毫秒 */
@property (strong, nonatomic) UILabel *lastLabel;

@end


@implementation WatchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

-(void)initUserInterface{
    _hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    _hourLabel.textColor = [UIColor colorWithHex:0xffffff];
    _hourLabel.font = fontForSize(12);
    _hourLabel.textAlignment = NSTextAlignmentCenter;
    _hourLabel.backgroundColor = [UIColor blackColor];
    _hourLabel.layer.cornerRadius = 2;
    _hourLabel.layer.masksToBounds = YES;
    [self addSubview:_hourLabel];
    
    UILabel *testL = [[UILabel alloc] initWithFrame:CGRectMake(_hourLabel.viewRightEdge+4, 0, 12, 16)];
    testL.textColor = [UIColor blackColor];
    testL.font = fontForSize(12);
    testL.text = @":";
    [testL sizeToFit];
    testL.viewHeight = 16;
    [self addSubview:testL];
    
    _minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(testL.viewRightEdge+4, 0, 16, 16)];
    _minuteLabel.textColor = [UIColor colorWithHex:0xffffff];
    _minuteLabel.font = fontForSize(12);
    _minuteLabel.textAlignment = NSTextAlignmentCenter;
    _minuteLabel.backgroundColor = [UIColor blackColor];
    _minuteLabel.layer.cornerRadius = 2;
    _minuteLabel.layer.masksToBounds = YES;
    [self addSubview:_minuteLabel];
    
    UILabel *testL1 = [[UILabel alloc] initWithFrame:CGRectMake(_minuteLabel.viewRightEdge+4, 0, 12, 16)];
    testL1.textColor = [UIColor blackColor];
    testL1.font = fontForSize(12);
    testL1.text = @":";
    [testL1 sizeToFit];
    testL1.viewHeight = 16;
    [self addSubview:testL1];
    
    _secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(testL1.viewRightEdge+4, 0, 16, 16)];
    _secondLabel.textColor = [UIColor colorWithHex:0xffffff];
    _secondLabel.font = fontForSize(12);
    _secondLabel.textAlignment = NSTextAlignmentCenter;
    _secondLabel.backgroundColor = [UIColor blackColor];
    _secondLabel.layer.cornerRadius = 2;
    _secondLabel.layer.masksToBounds = YES;
    [self addSubview:_secondLabel];
    
    UILabel *testL2 = [[UILabel alloc] initWithFrame:CGRectMake(_secondLabel.viewRightEdge+4, 0, 12, 16)];
    testL2.textColor = [UIColor blackColor];
    testL2.font = fontForSize(12);
    testL2.text = @":";
    [testL2 sizeToFit];
    testL2.viewHeight = 16;
    [self addSubview:testL2];
    
    _lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(testL2.viewRightEdge+4, 0, 16, 16)];
    _lastLabel.textColor = [UIColor colorWithHex:0xffffff];
    _lastLabel.font = fontForSize(12);
    _lastLabel.textAlignment = NSTextAlignmentCenter;
    _lastLabel.backgroundColor = [UIColor blackColor];
    _lastLabel.layer.cornerRadius = 2;
    _lastLabel.layer.masksToBounds = YES;
    [self addSubview:_lastLabel];
    
}


/**
 *  根据指定时间间隔开始倒计时
 */
- (void)fireWithTimeIntervar:(NSTimeInterval)timerInterval
{
    if (_timer == nil) {
        __block int timeout = timerInterval*100; //倒计时时间
        
        if (timeout != 0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 0.01*NSEC_PER_SEC, 0); //毫秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout <= 0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.hourLabel.text = @"00";
                        self.minuteLabel.text = @"00";
                        self.secondLabel.text = @"00";
                        self.lastLabel.text = @"00";
                    });
                    // 结束的回调
                    if (_TimerStopComplete) {
                        _TimerStopComplete();
                    }
                }else{
                    int days = (int)(timeout/(3600*24))/100;
                    int hours = (int)(timeout-days*24*360000)/360000;
                    int minute = (int)(timeout-days*24*360000-hours*360000)/60/100;
                    int second = (timeout-(days*24*360000+hours*360000+minute*6000))/100;
                    int last = (timeout-(days*24*360000+ hours*360000 + minute*6000+100*second)) ;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (hours < 10) {
                            self.hourLabel.text = [NSString stringWithFormat:@"0%d",hours];
                        }else {
                            self.hourLabel.text = [NSString stringWithFormat:@"%d",hours];
                        }
                        if (minute < 10) {
                            self.minuteLabel.text = [NSString stringWithFormat:@"0%d",minute];
                        }else{
                            self.minuteLabel.text = [NSString stringWithFormat:@"%d",minute];
                        }
                        if (second < 10) {
                            self.secondLabel.text = [NSString stringWithFormat:@"0%d",second];
                        }else {
                            self.secondLabel.text = [NSString stringWithFormat:@"%d",second];
                        }
                        if (last<10) {
                            self.lastLabel.text = [NSString stringWithFormat:@"0%d",last];
                        }else{
                            self.lastLabel.text = [NSString stringWithFormat:@"%d",last];
                        }
                        [self.hourLabel sizeToFit];
                        [self.minuteLabel sizeToFit];
                        [self.secondLabel sizeToFit];
                        [self.lastLabel sizeToFit];
                        
                        self.hourLabel.viewWidth = self.hourLabel.viewWidth+2;
                        self.minuteLabel.viewHeight = self.minuteLabel.viewWidth+2;
                        self.secondLabel.viewHeight = self.secondLabel.viewWidth+2;
                        self.lastLabel.viewHeight = self.lastLabel.viewWidth+2;
                        
                        self.hourLabel.viewHeight = 16;
                        self.minuteLabel.viewHeight = 16;
                        self.secondLabel.viewHeight = 16;
                        self.lastLabel.viewHeight = 16;
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}

-(void)xiaohui{
    dispatch_source_cancel(_timer);
    _timer = nil;
}

-(void)countDownViewWithEndString:(NSString *)endStr{
    [self fireWithTimeIntervar:[endStr intValue]];
}




@end
