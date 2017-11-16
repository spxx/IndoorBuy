//
//  WeChatTools.h
//  QQLogin
//
//  Created by 白琴 on 16/2/1.
//  Copyright © 2016年 白琴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

#import "WXApiObject.h"

typedef NS_ENUM(NSInteger, WXSceneType) {
    
    WXSceneTypeSession  = 0,        /**< 聊天界面    */
    
    WXSceneTypeTimeline = 1,        /**< 朋友圈      */
    
};


@interface WeChatTools : NSObject <WXApiDelegate>

+ (void) sendImageContent:(UIImage *)image title:(NSString *)title description:(NSString *)description webpageUrl:(NSString *)webpageUrl scene:(WXSceneType)scene;

@end
