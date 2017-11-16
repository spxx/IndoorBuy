//
//  ImageManager.h
//  框架
//
//  Created by 孙鹏 on 15/8/19.
//  Copyright (c) 2015年 白琴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageManager : NSObject

+ (instancetype)defaultManager;

/*图片的模糊处理*/
- (UIImage *)pictureBlurWithURL:(NSURL *)url;

/*图片的压缩*/
- (UIImage *)pictureCompressionWithUrl:(NSURL *)url size:(CGSize)size;

/*图片的叠加*/
///oneImage：大的图片【底】，twoImage：小的【eg:logo】，twoSmallImageRect：小的在大的上面的位置
- (UIImage *)addOneBigImage:(UIImage *)oneImage twoSmallImage:(UIImage *)twoImage twoSmallImageRect:(CGRect)twoSmallImageRect;

/*等比例缩放*/
///picAfterZoomWidth：缩放之后的图片的宽，picAfterZoomHeight：缩放之后的图片的高
- (UIImage *)getPicZoomImage:(UIImage *)image picAfterZoomWidth:(CGFloat)picAfterZoomWidth picAfterZoomHeight:(CGFloat)picAfterZoomHeight;

@end
