//
//  ImageManager.m
//  框架
//
//  Created by 孙鹏 on 15/8/19.
//  Copyright (c) 2015年 白琴. All rights reserved.
//

#import "ImageManager.h"

@implementation ImageManager

+ (instancetype)defaultManager
{
    static dispatch_once_t pred = 0;
    __strong static id defaultImageManager = nil;
    dispatch_once( &pred, ^{
        defaultImageManager = [[self alloc] init];
    });
    return defaultImageManager;
}
//图片的模糊处理
- (UIImage *)pictureBlurWithURL:(NSURL *)url {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithContentsOfURL:url];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@3.0f forKey: @"inputRadius"];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage: result fromRect:[result extent]];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    
    return blurImage;
}

//图片的压缩
- (UIImage *)pictureCompressionWithUrl:(NSURL *)url size:(CGSize)size {
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}


//图片叠加，比如：
// 添加logo水印
- (UIImage *)addOneBigImage:(UIImage *)oneImage twoSmallImage:(UIImage *)twoImage twoSmallImageRect:(CGRect)twoSmallImageRect{
    UIGraphicsBeginImageContext(oneImage.size);
    [oneImage drawInRect:CGRectMake(0, 0, oneImage.size.width, oneImage.size.height)];
    [twoImage drawInRect:twoSmallImageRect];
//    [twoImage drawInRect:CGRectMake((oneImage.size.width - twoImage.size.width)/2,
//                                     (oneImage.size.height - twoImage.size.height)/2,
//                                     twoImage.size.width,
//                                     twoImage.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}


//等比例缩放
//PicAfterZoomWidth:缩放后图片宽  PicAfterZoomHeight:缩放后图片高 (预定义)
- (UIImage *)getPicZoomImage:(UIImage *)image picAfterZoomWidth:(CGFloat)picAfterZoomWidth picAfterZoomHeight:(CGFloat)picAfterZoomHeight {
    UIImage * img;
    int h = img.size.height;
    int w = img.size.width;
    if (h <= picAfterZoomWidth && w <= picAfterZoomHeight) {
        img = image;
    }else {
        float b = (float)picAfterZoomWidth/w < (float)picAfterZoomHeight/h ? (float)picAfterZoomWidth/w : (float)picAfterZoomHeight/h;
        CGSize itemSize = CGSizeMake(b*w, b*h);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0, 0, b*w, b*h);
        [img drawInRect:imageRect];
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return img;
}







@end
