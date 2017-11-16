//
//  RegistViewController.h
//  BMW
//
//  Created by 白琴 on 16/3/2.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BaseVC.h"

@interface RegistViewController : BaseVC

/**
 *  是否是从login界面push过来的
 */
@property (nonatomic, assign)BOOL isLoginPush;

/**
 *  是否购物车过来的
 */
@property (nonatomic, assign)BOOL isPrsent;

@end
