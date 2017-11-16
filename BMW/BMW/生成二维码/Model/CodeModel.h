//
//  CodeModel.h
//  DP
//
//  Created by LiuP on 16/8/9.
//  Copyright © 2016年 sp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CodeModel : NSObject


/**
 生成二维码图片

 @param shareUrl
 @param complete 
 */
+ (void)requestForCreateCodeWithShareUrl:(NSString *)shareUrl
                                complete:(void(^)(NSString * imageUrl, NSString * message, NSInteger code))complete;

@end
