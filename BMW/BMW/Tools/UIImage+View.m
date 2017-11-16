//
//  UIImage+View.m
//  WJDJ
//
//  Created by LiuP on 15/6/24.
//  Copyright (c) 2015年 shc. All rights reserved.
//

#import "UIImage+View.h"

@implementation UIImage (View)

+ (UIImage*)imageFromView:(UIView*)view
{
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, view.layer.contentsScale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
+ (UIImage *)squareImageWithColor:(UIColor *)color andSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, ceil(size.width), ceil(size.height)));
    UIImage * image  = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
