//
//  ScreenCollectionCell.h
//  BMW
//
//  Created by gukai on 16/3/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenModle.h"
@class ScreenCollectionCell;
@protocol ScreenCollectionCellDelegate <NSObject>

@optional
-(void)screenCollectionCell:(ScreenCollectionCell *)cell index:(NSIndexPath *)index dataDic:(NSDictionary *)dataDic button:(UIButton *)sender;
@end

@interface ScreenCollectionCell : UICollectionViewCell
@property(nonatomic,strong)UIButton * button;
@property(nonatomic,copy)NSMutableArray * dataSource;
@property(nonatomic,strong)NSIndexPath * index;
@property(nonatomic,copy)NSDictionary * dataDic;
@property(nonatomic,assign)id<ScreenCollectionCellDelegate> delegate;
/**
 * 记录当前的 价格按钮
 */
@property(nonatomic,strong)UIButton * currentPriceBtn;
/**
 * 记录筛选的条件
 */
@property(nonatomic,strong)ScreenModle * screenModle;
@end
