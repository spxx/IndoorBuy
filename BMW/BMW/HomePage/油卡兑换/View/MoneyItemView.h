//
//  MoneyItemView.h
//  BMW
//
//  Created by LiuP on 2016/12/17.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OilCardModel.h"
@class MoneyItemView;

@protocol MoneyItemViewDelegate <NSObject>

@optional
- (void)moneyItemView:(MoneyItemView *)moneyItemView didSelectedItemWitModel:(OilCardModel *)model;

@end

@interface MoneyItemView : UIView
@property (nonatomic, assign) id<MoneyItemViewDelegate> delegate;

@property (nonatomic, retain) OilCardModel * model;

- (void)changeStatus;

@end
