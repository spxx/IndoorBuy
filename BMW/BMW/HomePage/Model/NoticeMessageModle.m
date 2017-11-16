//
//  NoticeMessageModle.m
//  BMW
//
//  Created by gukai on 16/4/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "NoticeMessageModle.h"

@implementation NoticeMessageModle
-(id)initWithJsonObject:(NSDictionary *)jsonObject
{
    self = [super init];
    if (self) {
        self.add_time = [jsonObject objectForKeyNotNull:@"add_time"];
        self.message_id = [jsonObject objectForKeyNotNull:@"message_id"];
        self.message_url = [jsonObject objectForKeyNotNull:@"message_url"];
        self.title = [jsonObject objectForKeyNotNull:@"title"];
    }
    return self;
}
@end
