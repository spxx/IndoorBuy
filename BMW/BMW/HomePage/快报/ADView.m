//
//  ADView.m
//  Custom
//
//  Created by LiuP on 2016/12/16.
//  Copyright © 2016年 LiuP. All rights reserved.
//

#import "ADView.h"
@class ADRollView;

@protocol ADRollViewDelegate<NSObject>

@optional

/**
 点击了滚动广告
 
 @param adRollView
 @param model
 */
- (void)ADRollView:(ADRollView *)adRollView didSelectedADWithModel:(ADModel *)model;

@end

@interface ADRollView : UIView

@property (nonatomic, assign) id<ADRollViewDelegate> delegate;
//@property (nonatomic, strong) UILabel * label;      /**< 红色标签 */
@property (nonatomic, strong) UILabel * content;    /**< 快报内容 */
@property (nonatomic, retain) ADModel * model;

@end

@implementation ADRollView

- (void)dealloc
{
    self.delegate = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface
{
//    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
//    _label.font = [UIFont systemFontOfSize:11 * W_ABCW];
//    _label.textAlignment = NSTextAlignmentCenter;
//    _label.textColor = COLOR_NAVIGATIONBAR_BARTINT;
//    _label.text = @"";
//    [_label sizeToFit];
//    _label.frame = CGRectMake(0, 0, _label.viewWidth, self.viewHeight);
//    [self addSubview:_label];
    
    CGFloat origin_x = 6 * W_ABCW;
    _content = [[UILabel alloc] initWithFrame:CGRectMake(origin_x, 0, self.viewWidth - origin_x - 10 * W_ABCW, self.viewHeight)];
    _content.font = fontForSize(11 * W_ABCW);
    _content.textColor = [UIColor colorWithHex:0x868686];
    [self addSubview:_content];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rollADTapAction:)];
    [self addGestureRecognizer:tap];
}

#pragma mark -- setter
- (void)setModel:(ADModel *)model
{
    _model = model;
    _content.text = model.title;
}

#pragma mark -- action
- (void)rollADTapAction:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(ADRollView:didSelectedADWithModel:)]) {
        [self.delegate ADRollView:self didSelectedADWithModel:self.model];
    }
}

@end


@interface ADView ()<ADRollViewDelegate>
@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) ADRollView * firstRollView;    /**< 滚动视图 */
@property (nonatomic, strong) ADRollView * secondRollView;

@property (nonatomic, strong) NSTimer * timer;      /**< 控制动画 */
@property (nonatomic, assign) BOOL isFirstRoll;     /**< 当前是否显示的是第一页 */
@end

@implementation ADView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface
{
    _label = [[UILabel alloc] initWithFrame:CGRectMake(10 * W_ABCW, 5 * W_ABCW, 34 * W_ABCW, 18 * W_ABCW)];
    _label.clipsToBounds = YES;
    _label.layer.cornerRadius = 2;
    _label.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
    _label.textColor = COLOR_NAVIGATIONBAR_ITEM;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"快报";
    _label.font = [UIFont systemFontOfSize:11 * W_ABCW];
    [self addSubview:_label];
}
#pragma mark -- getter
- (ADRollView *)firstRollView
{
    if (!_firstRollView) {
        CGFloat origin_x = _label.viewRightEdge + 9 * W_ABCW;
        _firstRollView = [[ADRollView alloc] initWithFrame:CGRectMake(origin_x, 0, self.viewWidth - origin_x, self.viewHeight)];
        _firstRollView.delegate = self;
        [self addSubview:_firstRollView];
    }
    return _firstRollView;
}

- (ADRollView *)secondRollView
{
    if (!_secondRollView) {
        CGFloat origin_x = _label.viewRightEdge + 9 * W_ABCW;
        _secondRollView = [[ADRollView alloc] initWithFrame:CGRectMake(origin_x, self.viewHeight, self.viewWidth - origin_x, self.viewHeight)];
        _secondRollView.delegate = self;
        [self addSubview:_secondRollView];
    }
    return _secondRollView;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(animationStart:) userInfo:nil repeats:YES];
//        _timer = [NSTimer scheduledTimerWithTimeInterval:2.5 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        }];
    }
    return _timer;
}

-(void)animationStart:(NSTimer *)timer{
    // 执行动画
    if (self.isFirstRoll) {
        _secondRollView.center = CGPointMake(_secondRollView.center.x, self.viewHeight + self.viewHeight / 2);
        [UIView animateWithDuration:1 animations:^{
            _firstRollView.center = CGPointMake(_firstRollView.center.x, - self.viewHeight / 2);
            _secondRollView.center = CGPointMake(_secondRollView.center.x, self.viewHeight / 2);
        } completion:^(BOOL finished) {
            if (finished) {
                self.isFirstRoll = NO;
                [self rollModelsWithRollView:_firstRollView];
            }
        }];
    }else {
        _firstRollView.center = CGPointMake(_firstRollView.center.x, self.viewHeight + self.viewHeight / 2);
        [UIView animateWithDuration:1 animations:^{
            _secondRollView.center = CGPointMake(_secondRollView.center.x, - self.viewHeight / 2);
            _firstRollView.center = CGPointMake(_firstRollView.center.x, self.viewHeight / 2);
        } completion:^(BOOL finished) {
            if (finished) {
                self.isFirstRoll = YES;
                [self rollModelsWithRollView:_secondRollView];
            }
        }];
    }
}


#pragma mark -- setter
- (void)setModels:(NSMutableArray *)models
{
    _models = models;
    [self pauseAnimation];
    if (_models.count > 0) {
        if (_models.count >= 2) {
            self.firstRollView.model = _models.firstObject;
            self.secondRollView.model = _models[1];
            [self startAnimation];
        }else {
            self.firstRollView.model = _models.firstObject;
        }
    }else {
        NSLog(@"没有快报");
    }
}

#pragma mark -- ADRollViewDelegate
- (void)ADRollView:(ADRollView *)adRollView didSelectedADWithModel:(ADModel *)model
{
    if ([self.delegate respondsToSelector:@selector(ADView:didSelectedADWithModel:)]) {
        [self.delegate ADView:self didSelectedADWithModel:model];
    }
}

#pragma mark -- other
// models的数组也需要一起跟着滚动
- (void)rollModelsWithRollView:(ADRollView *)rollView
{
    ADModel * firstModel = [self.models objectAtIndex:0];
    [self.models removeObjectAtIndex:0];
    [self.models addObject:firstModel];
    rollView.model = self.models[1];
}

- (void)startAnimation
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        _timer.fireDate = [NSDate distantPast];
        [self.timer fire];
    });
}

- (void)pauseAnimation
{
    [_timer invalidate];
    _timer = nil;
    self.isFirstRoll = YES;
    _firstRollView.center = CGPointMake(_firstRollView.center.x, self.viewHeight / 2);
    _secondRollView.center = CGPointMake(_secondRollView.center.x, - self.viewHeight / 2);
}

//#pragma mark -- animation
//- (void)firstRollAnimation
//{
//    _firstRollView.center = CGPointMake(_firstRollView.center.x, self.viewHeight / 2);
//    _secondRollView.center = CGPointMake(_secondRollView.center.x, self.viewHeight + _secondRollView.viewHeight / 2);
//    [UIView animateWithDuration:1 animations:^{
//        _firstRollView.center = CGPointMake(_firstRollView.center.x, - self.viewHeight / 2);
//        _secondRollView.center = CGPointMake(_secondRollView.center.x, self.viewHeight / 2);
//    } completion:^(BOOL finished) {
//        if (finished) {
//            [self rollModelsWithRollView:_firstRollView];
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                [self secondRollAnimation];
//            });
//        }
//    }];
//}
//
//- (void)secondRollAnimation
//{
//    _firstRollView.center = CGPointMake(_firstRollView.center.x, self.viewHeight + _firstRollView.viewHeight / 2);
//    _secondRollView.center = CGPointMake(_secondRollView.center.x, self.viewHeight / 2);
//    [UIView animateWithDuration:1 animations:^{
//        _secondRollView.center = CGPointMake(_secondRollView.center.x, - self.viewHeight / 2);
//        _firstRollView.center = CGPointMake(_firstRollView.center.x, self.viewHeight / 2);
//    } completion:^(BOOL finished) {
//        if (finished) {
//            [self rollModelsWithRollView:_secondRollView];
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                [self firstRollAnimation];
//            });
//        }
//    }];
//}
//
//- (void)startRollAnimation
//{
////    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
////    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
////        [self firstRollAnimation];
////    });
//    [self firstRollAnimation];
//}
//
//- (void)stopRollAnimation
//{
//    if (_firstRollView) {
//        [_firstRollView.layer removeAllAnimations];
//        _firstRollView.delegate = nil;
//        [_firstRollView removeFromSuperview];
//        _firstRollView = nil;
//    }
//    if (_secondRollView) {
//        [_secondRollView.layer removeAllAnimations];
//        _secondRollView.delegate = nil;
//        [_secondRollView removeFromSuperview];
//        _secondRollView = nil;
//    }
//}

@end
