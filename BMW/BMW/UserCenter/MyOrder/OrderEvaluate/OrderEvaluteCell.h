//
//  OrderEvaluteCell.h
//  BMW
//
//  Created by gukai on 16/3/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderEvaluteCell;
@protocol OrderEvaluteCellDelegate <NSObject>

@optional
-(void)OrderEvaluteCellDidClickStarBtn:(UIButton *)sender index:(NSIndexPath *)index;

//textView  开始编辑
-(void)OrderEvaluteCellDidBegainEditingTextView:(OrderEvaluteCell *)cell textView:(UITextView *)textView;
//textView  结束编辑
-(void)OrderEvaluteCellDidEndEditingTextView:(OrderEvaluteCell *)cell textView:(UITextView *)textView index:(NSIndexPath *)index;

@end
@interface OrderEvaluteCell : UITableViewCell
@property(nonatomic,strong)NSIndexPath * index;
@property(nonatomic,assign)id<OrderEvaluteCellDelegate> delegate;

@property(nonatomic,copy)NSString * imageUrl;
@property(nonatomic,copy)NSString * infoText;
@property(nonatomic,copy)NSString * evaluteString;
@property(nonatomic,assign)NSInteger starCount;
@end
