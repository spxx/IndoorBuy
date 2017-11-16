//
//  GoodsParameterCell.h
//  BMW
//
//  Created by gukai on 16/3/9.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsParameterCell;
@protocol GoodsParameterCellDelegate <NSObject>

@optional
-(void)heightGoodParameterCell:(GoodsParameterCell *)cell index:(NSIndexPath *)index newHeight:(CGFloat)height;

@end
@interface GoodsParameterCell : UITableViewCell
@property(nonatomic,strong)NSIndexPath * index;
@property(nonatomic,copy)NSDictionary * dataDic;
@property(nonatomic,assign)id<GoodsParameterCellDelegate> delegate;
@end
