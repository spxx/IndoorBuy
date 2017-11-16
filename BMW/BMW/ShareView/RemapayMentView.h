//
//  RemapayMentView.h
//  BMW
//
//  Created by rr on 16/3/29.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemapayMentView : UIView

@property(nonatomic, assign)double payMoney;

@property(nonatomic, assign)float orderMoney;

@property(nonatomic, strong) void(^finishPay)(NSString *password);

@property(nonatomic, strong) void(^shezhiPassWord)();

-(instancetype)initWithFrame:(CGRect)frame Withmoney:(double)payMoney AndOrderM:(float)orderMoney;

@end
