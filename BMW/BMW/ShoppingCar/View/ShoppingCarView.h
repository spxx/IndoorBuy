//
//  ShoppingCarView.h
//  BMW
//
//  Created by LiuP on 2016/10/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListModel.h"
@class ShoppingCarView;

@protocol ShoppingViewDelegate <NSObject>

@optional
- (void)shoppingViewRefreshAction;

/**
 全选
 */
- (void)shoppingViewAllGoodsSelected:(BOOL)selected;

/**
 删除商品
 */
- (void)shoppingViewDeleteGoodsAction;

/**
 购物车为空去逛逛

 @param shoppingView
 @param btn
 */
- (void)shoppingView:(ShoppingCarView *)shoppingView gotoClassWithBtn:(UIButton *)btn;

/**
 购物车为空去收藏

 @param shoppingView
 @param btn
 */
- (void)shoppingView:(ShoppingCarView *)shoppingView gotoCollectionWithBtn:(UIButton *)btn;

/**
 顶部点击事件

 @param shoppingView
 @param tap          
 */
- (void)shoppingView:(ShoppingCarView *)shoppingView clickedTopItemWithTap:(UITapGestureRecognizer *)tap;

/**
 点击活动标签

 @param shoppingView
 @param model        
 */
- (void)shoppingView:(ShoppingCarView *)shoppingView activityActionWithModel:(GoodsListModel *)model;

/**
 选中商品

 @param shoppingView
 @param model
 @param select
 */
- (void)shoppingView:(ShoppingCarView *)shoppingView selectedGoodsWithModel:(GoodsModel *)model select:(BOOL)select;

/**
 加减商品

 @param shoppingView
 @param model
 @param btn
 @param amount
 */
- (void)shoppingView:(ShoppingCarView *)shoppingView addOrReduceActionWithModel:(GoodsModel *)model btn:(UIButton *)btn amount:(NSString *)amount;

/**
 点击商品

 @param shoppingView
 @param model
 */
- (void)shoppingView:(ShoppingCarView *)shoppingView didSelectGoodsWithModel:(GoodsModel *)model;

/**
 加入麦咖

 @param shoppingView
 @param btn          
 */
- (void)shoppingView:(ShoppingCarView *)shoppingView memberActionWithBtn:(UIButton *)btn;

/**
 结算

 @param shoppingView
 @param btn          
 */
- (void)shoppingView:(ShoppingCarView *)shoppingView settleActionWithBtn:(UIButton *)btn;

@end

@interface ShoppingCarView : UIView

@property (nonatomic, assign) id<ShoppingViewDelegate> delegate;

@property (nonatomic, retain) NSMutableArray * models;

@property (nonatomic, assign) BOOL isEditing;       /**< 是否处于编辑状态 */

@property (nonatomic, assign) BOOL settleBtnEnable; /**< 结算按钮是否可点 */

@property (nonatomic, assign) BOOL isMember;        /**< 用户是否是会员 */

@property (nonatomic, assign, getter=isEmpty) BOOL empty;   /**< 购物车是否显示为空 */

@property (nonatomic, copy) NSString *topcontentS; /**< 广告内容*/

/**
 初始化购物车

 @param frame
 @param empty

 @return
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 更新底部结算视图
 
 @param totalCash
 @param saveCash
 @param amount
 @param all
 */
- (void)updateBottomViewWithModel:(GoodsListModel *)model amount:(NSInteger)amount all:(BOOL)all;

- (void)endRefresh;
- (void)reloadData;
// 顶部标签
- (void)showTopView;
- (void)hideTopView;

@end
