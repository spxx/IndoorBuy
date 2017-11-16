//
//  OilRecordModel.h
//  BMW
//
//  Created by LiuP on 2016/12/17.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OilRecordBack)(BOOL success, NSMutableArray * models, NSString * message);

@interface OilRecordModel : NSObject
@property (nonatomic, assign, getter=isHandling) BOOL handling;     /**< 是否在充值中 */
@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, copy) NSString * status;

/**
 获取油卡兑换记录列表
 
 @param complete
 */
+ (void)requestForOilRecordListWithComplete:(OilRecordBack)complete;
@end
