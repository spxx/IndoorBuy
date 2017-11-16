//
//  ApplyRecordCell.m
//  DP
//
//  Created by LiuP on 15/10/27.
//  Copyright © 2015年 sp. All rights reserved.
//

#import "ApplyRecordCell.h"

@interface ApplyRecordCell ()

@end

@implementation ApplyRecordCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    if (_dataDic != dataDic) {
        _dataDic = dataDic;
        _cashLabel.text = dataDic[@""];
        
    }
}

@end
