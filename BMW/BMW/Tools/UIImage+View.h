//
//  UIImage+View.h
//  WJDJ
//
//  Created by LiuP on 15/6/24.
//  Copyright (c) 2015年 shc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (View)
/**
 *  view转image
 *
 *  @param view
 *
 *  @return 
 */
+ (UIImage*)imageFromView:(UIView*)view;

+ (UIImage *)squareImageWithColor:(UIColor *)color andSize:(CGSize)size;
@end
