//
//  AimationTools.h
//  ChinaBank
//
//  Created by lanqs on 15/3/28.
//  Copyright (c) 2015年 gukai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AimationTools : NSObject
+(CAAnimation *)parabolaAnimationStartPoint:(CGPoint)starPoint CenterPoint:(CGPoint)CenterPoint enPoint:(CGPoint)endPoint;
+(CAAnimation *)shakeAnimation:(UIView *)sender;

+(void)parabolaAnimationStartPoint:(CGPoint)starPoint CenterPoint:(CGPoint)CenterPoint enPoint:(CGPoint)endPoint withView:(UIView *)view shakeView:(UIView *)shakeView numStr:(NSString *)num;
@end
