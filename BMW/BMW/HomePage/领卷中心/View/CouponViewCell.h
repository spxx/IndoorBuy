//
//  CouponViewCell.h
//  BMW
//
//  Created by LiuP on 2016/12/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

typedef void(^GetCouponBlock)(CouponModel * model);
@interface CouponViewCell : UITableViewCell

@property (nonatomic, retain) CouponModel * model;
@property (nonatomic, copy) GetCouponBlock getCouponBlock;

@end
