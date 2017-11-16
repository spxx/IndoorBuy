//
//  OrderServiceFootView.h
//  BMW
//
//  Created by gukai on 16/3/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderServiceFootViewDelegate <NSObject>

@optional
-(void)OrderServiceFootViewDidClickCancelApply:(UIButton *)sender section:(NSInteger)section;
-(void)OrderServiceFootViewDidClickCancelApplyFollowUpProgress:(UIButton *)sender section:(NSInteger)section;
-(void)OrderServiceFootViewDidClickDeleteServiceBtn:(UIButton *)sender section:(NSInteger)section;

@end
@interface OrderServiceFootView : UIView
@property(nonatomic,copy)NSString * add_time;
@property(nonatomic,assign)NSInteger state;
@property(nonatomic,assign)id<OrderServiceFootViewDelegate> delegate;
@property(nonatomic,assign)NSInteger section;
@end
