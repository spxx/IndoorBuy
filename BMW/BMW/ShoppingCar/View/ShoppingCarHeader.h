//
//  ShoppingCarHeader.h
//  BMW
//
//  Created by LiuP on 2016/10/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListModel.h"

typedef void(^ActivityBlock)(GoodsListModel * model);

@interface ShoppingCarHeader : UITableViewHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier model:(GoodsListModel *)model activity:(BOOL)activity;

@property (nonatomic, copy) ActivityBlock activityBlock;

@end
