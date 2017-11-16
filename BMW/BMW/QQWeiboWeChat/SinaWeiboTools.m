//
//  SinaWeiboTools.m
//  QQLogin
//
//  Created by 白琴 on 16/2/1.
//  Copyright © 2016年 白琴. All rights reserved.
//

#import "SinaWeiboTools.h"

@implementation SinaWeiboTools

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    NSLog(@"request:== %@", request);
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    NSLog(@"response:== %@", response);
}

@end
