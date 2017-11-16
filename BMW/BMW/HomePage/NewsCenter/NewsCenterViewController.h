//
//  NewsCenterViewController.h
//  BMW
//
//  Created by rr on 16/3/22.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BaseVC.h"

typedef enum {
    NewsCenterDefault,//默认 第一次 显示：订单 公告 通知
    NewsCenterVisitor,// 未登录的用户 只显示公告
    NewsCenterOrder,//订单列表
    NewsCenterNotice,//公告列表
    NewsCenterInform,//通知列表
}
NewsCenterVCType;
@interface NewsCenterViewController : BaseVC

@property(nonatomic,assign) BOOL whereFrom;

@property(nonatomic,copy) NSMutableArray *dataArray;
@property(nonatomic,copy)NSArray  * noticeDataSource;//公告传进来的数据源
@property(nonatomic,assign)NewsCenterVCType  newsCenterType;
@end
