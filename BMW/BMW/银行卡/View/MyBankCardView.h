//
//  MyBankCardView.h
//  DP
//
//  Created by LiuP on 16/7/15.
//  Copyright © 2016年 sp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankCardModel.h"
#import "RemindLoginView.h"
@class MyBankCardView;

@protocol BankCardDelegate <NSObject>

@optional
/**
 *  删除银行卡
 *
 *  @param bankCardView
 *  @param model
 */
- (void)bankCardView:(MyBankCardView *)bankCardView deleteWithModel:(BankCardModel *)model;
/**
 *  添加银行卡
 */
- (void)addNewBankCardAction;
/**
 *  刷新
 */
- (void)refreshAction;
/**
 *  加载更多
 */
- (void)loadMoreActionWithModels:(NSMutableArray *)models;

@end

@interface MyBankCardView : UIView

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) id<BankCardDelegate> delegate;
@property (nonatomic, strong) NSMutableArray<BankCardModel *> * models;  /**< 银行卡数据源 */
@property (nonatomic, strong) RemindLoginView * remindNoCard;            /**< 显示没有银行卡的背景 */

@end
