//
//  ApplyRecordCell.h
//  DP
//
//  Created by LiuP on 15/10/27.
//  Copyright © 2015年 sp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cashLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNameAndNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *reasonLabel;

@property (nonatomic, copy)NSDictionary * dataDic;
@end
