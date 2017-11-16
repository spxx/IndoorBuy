//
//  WithDrawApplyView.h
//  DP
//
//  Created by rr on 16/8/1.
//  Copyright © 2016年 sp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithdrawModel.h"
@class WithdrawView;

@protocol WithdrawViewDelegate <NSObject>

-(void)withdrawView:(WithdrawView *)WithdrawView clickedBankWithBtn:(UIButton *)btn;

-(void)withdrawView:(WithdrawView *)WithdrawView clickedWithdrawWithCash:(UITextField *)cash;

@end



@interface WithdrawView : UIView

@property(nonatomic,strong)UILabel *userBankLabel;

@property (nonatomic, strong)UITextField * outputCash;

@property(nonatomic,strong)UILabel *totalCash;

@property(nonatomic,weak)id<WithdrawViewDelegate> delegate;

@end
