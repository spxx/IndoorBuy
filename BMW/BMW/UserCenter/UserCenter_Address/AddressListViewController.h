//
//  AddressListViewController.h
//  BMW
//
//  Created by 白琴 on 16/3/2.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BaseVC.h"

@interface AddressListViewController : BaseVC

@property (nonatomic, copy)void(^chooeseAddressBlock)(NSDictionary * addressDic);

@property (nonatomic, assign)BOOL chooseAddress;

@end
