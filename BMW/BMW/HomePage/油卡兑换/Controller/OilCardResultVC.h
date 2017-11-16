//
//  OilCardResultVC.h
//  BMW
//
//  Created by LiuP on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BaseVC.h"

@protocol OilCardResultDelegate <NSObject>

@optional

/**
 查看兑换记录
 */
- (void)oilCardResultToRecord;

/**
 返回首页
 */
- (void)oilCardResultToHomePage;

@end

@interface OilCardResultVC : BaseVC

@property (nonatomic, assign) id<OilCardResultDelegate> delegate;

@end
