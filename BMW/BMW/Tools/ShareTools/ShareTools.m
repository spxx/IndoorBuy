//
//  ShareTools.m
//  BMW
//
//  Created by gukai on 16/3/11.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ShareTools.h"
#import "WeChatTools.h"
#import "QQTools.h"
#import "SinaWeiboTools.h"
#import "AppDelegate.h"
@implementation ShareTools

#pragma mark - 微信分享
/**
 * 微信分享
 * 参数:
 * index 0:分享给朋友  1:分享至朋友圈
 * shareImage: 分享的图片
 * shareDescription: 分享描述
 */
+(void)respondsShareWeiXin:(NSNumber *)index image:(UIImage *)shareImage title:(NSString *)title description:(NSString *)shareDescription webpageUrl:(NSString *)webpageUrl {
    //图片
    UIImage * image = shareImage;
    
    NSString * description = shareDescription;
    //朋友
    if ([index isEqualToNumber:@0]) {
        [WeChatTools sendImageContent:image title:title description:description webpageUrl:webpageUrl scene:WXSceneTypeSession];
    }
    //朋友圈
    if ([index isEqualToNumber:@1]) {
        [WeChatTools sendImageContent:image title:title description:description webpageUrl:webpageUrl scene:WXSceneTypeTimeline];
    }
}
#pragma mark - QQ分享
/**
 * QQ分享
 * shareTitle：标题
 * shareDescription：描述
 * shareImage：图片
 */
+ (void)respondsShareQQWithShareTitle:(NSString *)shareTitle
                             shareUrl:(NSString *)shareUrl
                     shareDescription:(NSString *)shareDescription
                           shareImage:(UIImage *)shareImage
{
    NSString * utf8String = shareUrl;
    NSString * title = shareTitle;
    NSString * description = shareDescription;
    [QQTools shareToQQWithImage:shareImage title:title description:description utf8String:utf8String];
}

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
                               shareImage:(UIImage *)shareImage
{
    NSString * utf8String = shareUrl;
    NSString * title = shareTitle;
    NSString * description = shareDescription;
    [QQTools shareToQQZoneWithImage:shareImage title:title description:description utf8String:utf8String];
}

#pragma mark - 新浪微博
/**
 * 微博分享
 * redirectUrl：微博开放平台第三方应用授权回调页地址，默认为`http://`
 * scope：微博开放平台第三方应用scope，多个scrope用逗号分隔
 * text：消息的文本内容，长度小于140个汉字
 * objectID：对象唯一ID，用于唯一标识一个多媒体内容。当第三方应用分享多媒体内容到微博时，应该将此参数设置为被分享的内容在自己的系统中的唯一标识。不能为空，长度小于255
 * imageUrl：图片地址url
 */
+ (void)respondsShareWeiboWithRedirectUrl:(NSString *)redirectUrl scope:(NSString *)scope text:(NSString *)text objectID:(NSString *)objectID shareImage:(UIImage *)shareImage {
    
    
    AppDelegate * myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = redirectUrl;
    authRequest.scope = scope;
    
    WBMessageObject *message = [WBMessageObject message];
    message.text = text;
    //图片
    WBImageObject * imageObject = [WBImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(shareImage, 1.0);
//    UIImageJPEGRepresentation([self imageCompressForWidth:shareImage targetWidth:300], 0.0);
    message.imageObject = imageObject;
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{};
    [WeiboSDK sendRequest:request];
}
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
