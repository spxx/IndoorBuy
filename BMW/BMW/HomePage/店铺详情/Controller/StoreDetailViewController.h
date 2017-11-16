//
//  StoreDetailViewController.h
//  BMW
//
//  Created by LiuP on 2016/12/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BaseVC.h"

@interface StoreDetailViewController : BaseVC

@property (nonatomic, copy) NSString * storeID;     /**< 获取店铺信息的ID，存在为个人店。nil表示显示BMW店铺 */

@property (nonatomic, assign) NSInteger storeType;   /**< 1：BMW店，2：个人店 */

@end
