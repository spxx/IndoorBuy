//
//  AddBankCardViewController.h
//  DP
//
//  Created by gukai on 15/10/27.
//  Copyright (c) 2015年 sp. All rights reserved.
//

#import "BaseVC.h"

typedef void(^AddBankCardSuccessBlock)(void);

@interface AddBankCardViewController : BaseVC

@property(nonatomic,strong)AddBankCardSuccessBlock addBankSuccess;

@end
