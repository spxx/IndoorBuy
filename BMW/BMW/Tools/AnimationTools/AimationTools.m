//
//  AimationTools.m
//  ChinaBank
//
//  Created by lanqs on 15/3/28.
//  Copyright (c) 2015年 gukai. All rights reserved.
//

#import "AimationTools.h"

#define PMK(A,B) [NSValue valueWithCGPoint:CGPointMake(A, B)]

@interface AimationTools ()<CAAnimationDelegate>

@end

@implementation AimationTools
+(CAAnimation *)parabolaAnimationStartPoint:(CGPoint)starPoint CenterPoint:(CGPoint)CenterPoint enPoint:(CGPoint)endPoint
{
    CGMutablePathRef pathCoin = CGPathCreateMutable();
    
    CGPathMoveToPoint(pathCoin, NULL, starPoint.x, starPoint.y);
    CGPathAddQuadCurveToPoint(pathCoin, NULL, CenterPoint.x, CenterPoint.y, endPoint.x, endPoint.y);
    CAKeyframeAnimation * keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimation.path = pathCoin;
    
    CGFloat from3DScale = 0.7;
    CGFloat to3DScale = from3DScale * 0.4;
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(from3DScale, from3DScale, from3DScale)], [NSValue valueWithCATransform3D:CATransform3DMakeScale(to3DScale, to3DScale, to3DScale)]];
    scaleAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    CABasicAnimation * basicRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    basicRotation.toValue = @(M_PI);
    
    CAAnimationGroup * gropAnimation = [[CAAnimationGroup alloc]init];
    gropAnimation.duration = 1.5;
    gropAnimation.animations = @[keyAnimation,scaleAnimation,basicRotation];
    gropAnimation.delegate = self;
    return gropAnimation;
}

+(CAAnimation *)shakeAnimation:(UIView *)sender
{
    CAKeyframeAnimation * keyAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnim.values = @[PMK(sender.layer.position.x + 15, sender.layer.position.y),PMK(sender.layer.position.x -15, sender.layer.position.y),];
    keyAnim.duration = 0.06;
    keyAnim.repeatCount = 2;
    return keyAnim;
}
+(void)parabolaAnimationStartPoint:(CGPoint)starPoint CenterPoint:(CGPoint)CenterPoint enPoint:(CGPoint)endPoint withView:(UIView *)view shakeView:(UIView *)shakeView numStr:(NSString *)num
{
    CGMutablePathRef pathCoin = CGPathCreateMutable();
    
    CGPathMoveToPoint(pathCoin, NULL, starPoint.x, starPoint.y);
    CGPathAddQuadCurveToPoint(pathCoin, NULL, CenterPoint.x, CenterPoint.y, endPoint.x, endPoint.y);
    CAKeyframeAnimation * keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimation.path = pathCoin;
    
    CGFloat from3DScale = 0.7;
    CGFloat to3DScale = from3DScale * 0.4;
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(from3DScale, from3DScale, from3DScale)], [NSValue valueWithCATransform3D:CATransform3DMakeScale(to3DScale, to3DScale, to3DScale)]];
    scaleAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    CABasicAnimation * basicRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    basicRotation.toValue = @(M_PI);
    
    CAAnimationGroup * gropAnimation = [[CAAnimationGroup alloc]init];
    gropAnimation.duration = 1.5;
    gropAnimation.animations = @[keyAnimation,scaleAnimation,basicRotation];
    gropAnimation.delegate = self;
    
    
    [view.layer addAnimation:gropAnimation forKey:@"group"];
    
    double delayInSeconds = gropAnimation.duration;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [AimationTools shakeAnimation:shakeView];
        if ([shakeView isKindOfClass:[UILabel class]]) {
            UILabel * label = (UILabel *)shakeView;
            label.text = num;
        }
    });
}
@end
