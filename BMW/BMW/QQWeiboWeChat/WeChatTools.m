//
//  WeChatTools.m
//  QQLogin
//
//  Created by 白琴 on 16/2/1.
//  Copyright © 2016年 白琴. All rights reserved.
//

#import "WeChatTools.h"

@implementation WeChatTools

+ (void) sendImageContent:(UIImage *)image title:(NSString *)title description:(NSString *)description webpageUrl:(NSString *)webpageUrl scene:(WXSceneType)scene {
    if ([WXApi isWXAppInstalled]) {
        WXWebpageObject * webObject = [WXWebpageObject new];
        webObject.webpageUrl = webpageUrl;
        WXMediaMessage * mediaMessage = [WXMediaMessage new];
        mediaMessage.title = title;
        mediaMessage.description = description;
        mediaMessage.mediaObject = webObject;
        mediaMessage.thumbData = UIImageJPEGRepresentation(image, 0.0);
        SendMessageToWXReq * req = [SendMessageToWXReq new];
        req.text = nil;
        req.message = mediaMessage;
        req.bText = NO;
        req.scene = scene;
        [WXApi sendReq:req];
    }
    else {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未安装微信" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - WXApiDelegate

- (void)onReq:(BaseReq *)req
{
    
}

- (void)onResp:(BaseResp *)resp
{
    NSLog(@"resp == %@", resp);
    //支付
    if ([resp isKindOfClass:[PayResp class]]) {
        NSString *strMsg;
        NSString *strTitle;
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
            case WXErrCodeUserCancel:
                strMsg = @"支付结果：取消！";
                NSLog(@"取消支付－PayCancel，retcode = %d", resp.errCode);
                break;
            default:
                strMsg = @"支付结果：失败！";
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        NSDictionary * dic = @{@"code":[NSString stringWithFormat:@"%d", resp.errCode] ,@"title":strTitle, @"msg":strMsg};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPayResult" object:dic];
    }
    //分享
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        switch (resp.errCode) {
            case -2: {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"取消分享" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
                
                break;
            case -5:{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"微信不支持" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            case -4:{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"授权失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            case 0:{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            case -3:{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - WXApiDelegate

- (void)getAccessTokenWithCode:(NSString *)code
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WX_Key,WX_Secret,code];
     NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (data)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dict objectForKey:@"errcode"])
                {
                     //获取token错误
                }else{
                    //存储AccessToken OpenId RefreshToken以便下次直接登陆
                    //AccessToken有效期两小时，RefreshToken有效期三十天
                    [self getUserInfoWithAccessToken:[dict objectForKey:@"access_token"] andOpenId:[dict objectForKey:@"openid"]];
                }
        }
    });
    });
    /*
     正确返回
     "access_token" = “Oez*****8Q";
     "expires_in" = 7200;
     openid = ooVLKjppt7****p5cI;
     "refresh_token" = “Oez*****smAM-g";
     scope = "snsapi_userinfo";
    */
    /*
     错误返回
     errcode = 40029;
     errmsg = "invalid code";
     */
}

- (void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dict objectForKey:@"errcode"])
                {
                    //AccessToken失效
                    [self getAccessTokenWithRefreshToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"WeiXinRefreshToken"]];
                }else{
                    //获取需要的数据
                }
            }
        });
    });
    /*
     city = ****;
     country = CN;
     headimgurl = "http://wx.qlogo.cn/mmopen/q9UTH59ty0K1PRvIQkyydYMia4xN3gib2m2FGh0tiaMZrPS9t4yPJFKedOt5gDFUvM6GusdNGWOJVEqGcSsZjdQGKYm9gr60hibd/0";
     language = "zh_CN";
     nickname = “****";
     openid = oo*********;
     privilege =     (
     );
     province = *****;
     sex = 1;
     unionid = “o7VbZjg***JrExs";
     */
    /*
     错误代码
     errcode = 42001;
     errmsg = "access_token expired";
     */
}


- (void)getAccessTokenWithRefreshToken:(NSString *)refreshToken
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",WX_Key,refreshToken];
    NSURL *url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if ([dict objectForKey:@"errcode"])
                {
                    //授权过期
                }else{
                    //重新使用AccessToken获取信息
                }
            }
        });
    });
    /*
     "access_token" = “Oez****5tXA";
     "expires_in" = 7200;
     openid = ooV****p5cI;
     "refresh_token" = “Oez****QNFLcA";
     scope = "snsapi_userinfo,";
     */
    /*
     错误代码
     "errcode":40030,
     "errmsg":"invalid refresh_token"
     */
}





@end
