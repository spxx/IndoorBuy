//
//  OilCardView.h
//  BMW
//
//  Created by LiuP on 2016/12/17.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoneyItemView.h"

@class OilCardView;

@protocol OilCardViewDelegate <NSObject>

@optional

/**
 点击广告图

 @param oilCardView
 @param model
 */
- (void)oilCardView:(OilCardView *)oilCardView clickedADWitModel:(OilCardModel *)model;
/**
 选中了金额
 
 @param oilCardView
 @param model
 */
- (void)oilCardView:(OilCardView *)oilCardView selectedItemWitModel:(OilCardModel *)model;

/**
 查看服务协议
 */
- (void)didSelectedProtocol;

@end

@interface OilCardView : UIView

@property (nonatomic, assign) id<OilCardViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray * models;
@property (nonatomic, strong) UITextField * CINumField;     /**< 卡号输入框 */
@property (nonatomic, copy) OilCardModel * adModel;
@property (nonatomic, strong) UIButton * selectBtn;


// 结束输入状态
- (void)endEidting;

@end
