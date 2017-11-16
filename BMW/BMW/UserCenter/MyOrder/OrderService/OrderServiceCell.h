//
//  OrderServiceCell.h
//  BMW
//
//  Created by gukai on 16/3/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderServiceCell : UITableViewCell
@property(nonatomic,copy)NSString * imageUrl;
@property(nonatomic,copy)NSString * infoText;
@property(nonatomic,assign)NSInteger  goodsNum;
@property(nonatomic,copy)NSDictionary * spe_dic;
@end
