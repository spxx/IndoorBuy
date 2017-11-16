//
//  QQTools.m
//  QQLogin
//
//  Created by 白琴 on 16/2/1.
//  Copyright © 2016年 白琴. All rights reserved.
//

#import "QQTools.h"

@interface QQTools () 

@end

@implementation QQTools

/**
 分享到QQ空间

 @param image
 @param title
 @param description
 @param utf8String
 */
+ (void)shareToQQZoneWithImage:(UIImage *)image title:(NSString *)title description:(NSString *)description utf8String:(NSString *)utf8String{
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:utf8String]
                                title:title
                                description:description
                                previewImageData:UIImagePNGRepresentation(image)];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
//    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //将内容分享到qzone
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    switch (sent) {
        case EQQAPIQZONENOTSUPPORTTEXT:
            NSLog(@"不支持文本类型");
            break;
        case EQQAPIQZONENOTSUPPORTIMAGE:
            NSLog(@"不支持图片类型");
            break;
        case EQQAPISENDSUCESS:
            break;
        default:
            break;
    }
}

/**
 分享到QQ

 @param image
 @param title
 @param description
 @param utf8String
 */
+ (void)shareToQQWithImage:(UIImage *)image title:(NSString *)title description:(NSString *)description utf8String:(NSString *)utf8String
{
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:utf8String]
                                title:title
                                description:description
                                previewImageData:UIImagePNGRepresentation(image)];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    //    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //将内容分享到qzone
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    switch (sent) {
        case EQQAPIQZONENOTSUPPORTTEXT:
            NSLog(@"不支持文本类型");
            break;
        case EQQAPIQZONENOTSUPPORTIMAGE:
            NSLog(@"不支持图片类型");
            break;
        case EQQAPISENDSUCESS:
            break;
        default:
            break;
    }
}


// 分享结果回调
- (void)onResp:(QQBaseResp *)resp {
    NSLog(@"QQ == %@  %d", resp.result, resp.type);
    if([resp isKindOfClass:[SendMessageToQQResp class]])
    {
        
        switch (resp.type) {
            case 0:{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            default:
                break;
        }
    }
}

- (void)onReq:(QQBaseReq *)req {
    
}

- (void)isOnlineResponse:(NSDictionary *)response {
    
}



#pragma mark -- TencentSessionDelegate
//登陆完成调用
- (void)tencentDidLogin
{
    
    NSLog(@"登录完成");
    if (self.tencentQAuth.accessToken && 0 != [self.tencentQAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        [self.tencentQAuth getUserInfo];
    }
    else
    {
        NSLog(@"登录不成功 没有获取accesstoken");
    }
}

//非网络错误导致登录失败：
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    NSLog(@"tencentDidNotLogin");
    if (cancelled)
    {
        NSLog(@"用户取消登录");
    }else{
        NSLog(@"登录失败");
    }
}
// 网络错误导致登录失败：
-(void)tencentDidNotNetWork
{
    NSLog(@"tencentDidNotNetWork");
}


-(void)getUserInfoResponse:(APIResponse *)response
{
    NSLog(@"QQrespons:%@",response.jsonResponse);
}

@end
