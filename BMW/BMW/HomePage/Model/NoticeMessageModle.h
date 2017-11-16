//
//  NoticeMessageModle.h
//  BMW
//
//  Created by gukai on 16/4/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "MTLModel.h"

@interface NoticeMessageModle : MTLModel
@property(nonatomic,copy)NSString * add_time;
@property(nonatomic,copy)NSString * message_id;
@property(nonatomic,copy)NSString * message_url;
@property(nonatomic,copy)NSString * title;

-(id)initWithJsonObject:(NSDictionary *)jsonObject;
@end
