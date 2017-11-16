//
//  MyorderTableViewCell.h
//  BMW
//
//  Created by rr on 16/3/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyorderTableViewCellDelegate <NSObject>

@optional
-(void)MyorderTableViewCellDidClickEvaluateBtn:(UIButton *)sender index:(NSIndexPath *)index dataDic:(NSDictionary *)dataDic;

@end

@interface MyorderTableViewCell : UITableViewCell
@property(nonatomic, strong)NSDictionary *goodsDic;

@property(nonatomic,strong)NSString *type;

@property(nonatomic,strong)NSDictionary *lastDic;

@property(nonatomic,assign)id<MyorderTableViewCellDelegate> delegate;
@property(nonatomic,strong)NSIndexPath * index;

/**
 *  支付
 */
@property (nonatomic,copy)void(^paymentButton)();
/**
 *  倒计时结束
 */
@property (nonatomic,copy)void(^countdownOver)();
//取消订单
@property(nonatomic,copy)void(^cancleOrder)();
//创建服务单
@property(nonatomic,copy)void(^crectaServiceO)();
//提醒发货
@property(nonatomic,copy)void(^remindSend)();
//确认收货
@property(nonatomic,copy)void(^Confirm)();
//物流信息
@property(nonatomic,copy)void(^wayInfo)();
//重新购买
@property(nonatomic,copy)void(^repeatBuy)();
//删除订单
@property(nonatomic,copy)void(^deleteOrder)();


@end
