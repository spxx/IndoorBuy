//
//  AlertView.h
//  BMW
//
//  Created by LiuP on 2016/12/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlertView;


typedef enum{
    AlertGetCouponSuccess,      /**< 领取优惠券成功 */
    AlertGetCouponLimit,        /**< 领取优惠券已达上限 */
}AlertType;

@protocol AlertViewDelegate <NSObject>

@optional

/**
 点击确定

 @param alertView
 @param btn 
 */
- (void)alertView:(AlertView *)alertView didSelectedSureBtn:(UIButton *)btn;


@end

@interface AlertView : UIView

@property (nonatomic, assign) id<AlertViewDelegate> delegate;


- (instancetype)initWithTarget:(id<AlertViewDelegate>)target AlertType:(AlertType)alertType;

- (void)show:(BOOL)animation;
- (void)hide:(BOOL)animation;
@end
