//
//  BrandCell.m
//  BMW
//
//  Created by LiuP on 2016/12/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BrandCell.h"

@implementation BrandCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
        self.textLabel.font = fontForSize(12);
    }
    return self;
}

#pragma mark -- private
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark -- setter
- (void)setModel:(BrandModel *)model
{
    _model = model;
    self.textLabel.text = model.brandName;
}
@end
