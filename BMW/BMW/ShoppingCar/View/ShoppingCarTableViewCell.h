//
//  ShoppingCarTableViewCell.h
//  BMW
//
//  Created by rr on 16/3/2.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListModel.h"

typedef void(^SelectedBlock)(GoodsModel * model, BOOL isSelected);

typedef void(^AddOrReduceBlock)(GoodsModel * model, UIButton * btn, NSString * amount);

@interface ShoppingCarTableViewCell : UITableViewCell
// 旧代码
@property(nonatomic, strong)UIButton *chooseButton;
@property(nonatomic, strong)NSDictionary *goodsDic;
@property(nonatomic, strong)void (^clickButton)(BOOL);
@property(nonatomic, assign)BOOL currenttState;
@property(nonatomic, strong)NSDictionary *editDic;
@property(nonatomic, strong)void (^reduceOrAdd)(BOOL,NSInteger);
//隐藏选择button
@property(nonatomic, assign)BOOL hideChooseB;
@property(nonatomic, strong)void (^changeGuiGe)();
@property(nonatomic, strong)void (^refreshView)();



// 新代码 ****************************
@property (nonatomic, retain) GoodsModel * model;

@property (nonatomic, assign) BOOL canEdit;                     /**< 是否可编辑 赠品不能编辑 */

@property (nonatomic, copy) SelectedBlock selectBlock;          /**< 是否选中的回调 */

@property (nonatomic, copy) AddOrReduceBlock addOrReduceBlock;  /**< 加减的回调 */

@property (nonatomic, assign) BOOL editBtnEnable;               /**< 加减按钮是否可用 */

- (void)updateAmount:(NSString *)amount;                        /**< 更新数量 */

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseID:(NSString *)reuseID;

@end
