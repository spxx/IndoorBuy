//
//  ApplyRefundViewController.h
//  BMW
//
//  Created by rr on 16/3/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BaseVC.h"

typedef void(^SubmitServiceOrderSuccessBlock)(void);

@interface ApplyRefundViewController : BaseVC

@property(nonatomic, copy)NSArray *dataArray;

@property(nonatomic, copy)NSDictionary *dataDic;

@property(nonatomic,strong)SubmitServiceOrderSuccessBlock submitServiceOrderSuccess;

@end
