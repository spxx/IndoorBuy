//
//  WithdrawBankCardView.h
//  DP
//
//  Created by LiuP on 16/8/2.
//  Copyright © 2016年 sp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankCardModel.h"
@class WithdrawBankCardView;

@protocol WithdrawBankCardViewDelegate <NSObject>

@optional
- (void)cardView:(WithdrawBankCardView *)cardView chooseBankCardWithModel:(BankCardModel *)model;

@end

@interface WithdrawBankCardView : UIView

@property (nonatomic, strong) NSMutableArray * models;

@property (nonatomic, assign) id<WithdrawBankCardViewDelegate> delegate;

@end
