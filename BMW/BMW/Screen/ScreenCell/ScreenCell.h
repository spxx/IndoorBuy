//
//  ScreenCell.h
//  BMW
//
//  Created by gukai on 16/3/2.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenModle.h"
@class ScreenCell;
@protocol ScreenCellDelegate <NSObject>

@optional
/**
 * 初始化row的界面返回 row 的高度
 */
-(void)screenCell:(ScreenCell *)cell indexPath:(NSIndexPath *)index cellHeight:(CGFloat)height;

@end
@interface ScreenCell : UITableViewCell
/**
 * 记录筛选的条件
 */
@property(nonatomic,strong)ScreenModle * screenModle;
@property(nonatomic,copy)NSDictionary * dataDic;
@property(nonatomic,copy)NSMutableArray * dataSource;
@property(nonatomic,strong)NSIndexPath * index;
@property(nonatomic,assign)id<ScreenCellDelegate> delegate;





@end
