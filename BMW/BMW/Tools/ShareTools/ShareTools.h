//
//  ShareTools.h
//  BMW
//
//  Created by gukai on 16/3/11.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareTools : NSObject
/**
 *  @param index            0:分享给朋友  1:分享至朋友圈
 *  @param shareImage       分享的图片
 *  @param title            标题
 *  @param shareDescription 分享描述
 *  @param webpageUrl       链接
 */
+(void)respondsShareWeiXin:(NSNumber *)index image:(UIImage *)shareImage title:(NSString *)title description:(NSString *)shareDescription webpageUrl:(NSString *)webpageUrl;
/**
 * QQ分享
 * shareTitle：标题
 * shareDescription：描述
 * shareImage：图片
 */
+ (void)respondsShareQQWithShareTitle:(NSString *)shareTitle shareUrl:(NSString *)shareUrl shareDescription:(NSString *)shareDescription shareImage:(UIImage *)shareImage;
/**
 分享到QQ空间
 
 @param shareTitle
 @param shareUrl
 @param shareDescription
 @param shareImage
 */
+ (void)respondsShareQQZoneWithShareTitle:(NSString *)shareTitle
                                 shareUrl:(NSString *)shareUrl
                         shareDescription:(NSString *)shareDescription
                               shareImage:(UIImage *)shareImage;
/**
 * 微博分享
 * redirectUrl：微博开放平台第三方应用授权回调页地址，默认为`http://`
 * scope：微博开放平台第三方应用scope，多个scrope用逗号分隔
 * text：消息的文本内容，长度小于140个汉字
 * objectID：对象唯一ID，用于唯一标识一个多媒体内容。当第三方应用分享多媒体内容到微博时，应该将此参数设置为被分享的内容在自己的系统中的唯一标识。不能为空，长度小于255
 * shareImage：图片
 */
+ (void)respondsShareWeiboWithRedirectUrl:(NSString *)redirectUrl scope:(NSString *)scope text:(NSString *)text objectID:(NSString *)objectID shareImage:(UIImage *)shareImage;
@end
