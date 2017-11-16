//
//  MyBackCardTableViewCell.h
//  DP
//
//  Created by 孙鹏 on 15/10/25.
//  Copyright (c) 2015年 sp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankCardModel.h"

@interface MyBackCardTableViewCell : UITableViewCell

@property (nonatomic, strong)UILabel * backNameLabel;
@property (nonatomic, strong)UILabel * backNumberLabel;
@property (nonatomic, strong)UILabel * backCardInfoLabel;
@property (nonatomic, strong)UIImageView * iconImageView;


@property (nonatomic, strong)BankCardModel *bankModel;

@property (nonatomic, assign)BOOL isSpecial;


@end
