//
//  OrderServiceView.h
//  BMW
//
//  Created by gukai on 16/3/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    OrderServiceDefault,
    OrderServiceInOrder,
}OrderServiceType;

@protocol OrderServiceViewDelegate <NSObject>

@optional
-(void)OrderServiceViewDidClickServiceOrderCell:(NSDictionary *)dataDic;

-(void)CustomerSerVice;

-(void)orderServiceNetWorkSuccess;
-(void)orderServiceNetWorkFailed;

@end
@interface OrderServiceView : UIView
@property(nonatomic,assign)id<OrderServiceViewDelegate> delegate;
@property(nonatomic,copy)NSString * orderId;
@property(nonatomic,assign)OrderServiceType orderServiceType;

- (instancetype)initWithFrame:(CGRect)frame withOrderId:(NSString *)orderId orderServiceType:(OrderServiceType)type;
-(void)netWork;
@end
