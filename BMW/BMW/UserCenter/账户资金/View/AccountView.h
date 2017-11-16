//
//  AccountView.h
//  BMW
//
//  Created by LiuP on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountModel.h"
@class AccountView;

typedef enum{
    ItemNone,
    ItemMPay,           /**< M币充值 */
    ItemMRecord,        /**< M币充值记录 */
    ItemCashPay,        /**< 余额充值 */
    ItemCashRecord,     /**< 余额充值记录 */
    ItemCapitalRecord,  /**< 资金记录 */
}ItemType;

typedef enum {
    AccountCash,     /**< 余额 */
    AccountM,        /**< M币 */
}AccountType;

@protocol AccountViewDelegate <NSObject>

@optional

/**
 选择了菜单

 @param accountView 
 @param item
 */
- (void)accountView:(AccountView *)accountView didSelectedMenuWithItem:(ItemType)item;

@end

@interface AccountView : UIView
@property (nonatomic, retain) AccountModel * model;
@property (nonatomic, assign) id<AccountViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame account:(AccountType)account;
@end
