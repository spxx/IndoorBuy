//
//  CouponCenterView.h
//  BMW
//
//  Created by LiuP on 2016/12/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponViewCell.h"
@class CouponCenterView;

@protocol CouponViewDelegate <NSObject>

@optional

/**
 点击了获取优惠券

 @param couponView
 @param model 
 */
- (void)couponView:(CouponCenterView *)couponView didSelectedGetBtnWithModel:(CouponModel *)model;
@end

@interface CouponCenterView : UIView

@property (nonatomic, assign) id<CouponViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray * models;

@end
