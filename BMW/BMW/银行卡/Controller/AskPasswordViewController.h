//
//  AskPasswordViewController.h
//  DP
//
//  Created by rr on 16/8/1.
//  Copyright © 2016年 sp. All rights reserved.
//

#import "BaseVC.h"
#import "BankCardModel.h"

typedef enum{
    PasswordDefault,  // 默认用于确认
    PasswordVerify,   // 验证
}PasswordType;

@interface AskPasswordViewController : BaseVC

@property(nonatomic,strong)NSString *money;

@property (nonatomic, retain) BankCardModel * model;

@property (nonatomic, assign) PasswordType passwordType;

@end
