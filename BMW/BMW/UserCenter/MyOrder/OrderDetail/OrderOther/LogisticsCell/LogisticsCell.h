//
//  LogisticsCell.h
//  BMW
//
//  Created by gukai on 16/3/24.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LogisticsCellDefault,
    LogisticsCellLogistic,
}LogisticsCellType;
@interface LogisticsCell : UITableViewCell
@property(nonatomic,copy)NSDictionary * dataDic;
@property(nonatomic,strong)NSIndexPath * index;
@property(nonatomic,strong)UIView * lastBottomLine;
@property(nonatomic,assign)LogisticsCellType logisticsCellType;
@end
