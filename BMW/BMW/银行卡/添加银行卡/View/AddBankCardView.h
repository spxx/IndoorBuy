//
//  AddBankCardView.h
//  DP
//
//  Created by LiuP on 16/8/2.
//  Copyright © 2016年 sp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddBankCardView;

@protocol AddBankCardViewDelegate <NSObject>

@optional
/**
 *  点击绑定银行卡
 *
 *  @param addCardView
 *  @param btn
 *  @param cardName
 *  @param cardNum
 *  @param bankName
 */
- (void)addCardView:(AddBankCardView *)addCardView
     clickedBindBtn:(UIButton *)btn
               name:(NSString *)name
            cardNum:(NSString *)cardNum
           bankName:(NSString *)bankName;

/**
 *  查看用户协议
 */
- (void)addCardViewCheckUserProtocolAction;
@end

@interface AddBankCardView : UIView

@property (nonatomic, assign) id<AddBankCardViewDelegate> delegate;

- (void)clearText;

@end
