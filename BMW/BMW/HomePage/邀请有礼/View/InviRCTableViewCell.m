//
//  InviRCTableViewCell.m
//  BMW
//
//  Created by rr on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "InviRCTableViewCell.h"

@interface InviRCTableViewCell ()
{
    UILabel *_inviterLabel;
    UILabel *_cdLabel;
    UILabel *_priceLabel;
}
@end

@implementation InviRCTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUserInterface];
    }
    return self;
}

-(void)initUserInterface{
    
    self.contentView.backgroundColor = [UIColor colorWithHex:0xfffbeb];
    _inviterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, self.viewHeight)];
    _inviterLabel.textColor = [UIColor colorWithHex:0x666666];
    _inviterLabel.font = fontForSize(12);
    _inviterLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_inviterLabel];
    
    _cdLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, self.viewHeight)];
    _cdLabel.textColor = [UIColor colorWithHex:0x666666];
    _cdLabel.font = fontForSize(12);
    _cdLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_cdLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, self.viewHeight)];
    _priceLabel.textColor = [UIColor colorWithHex:0x666666];
    _priceLabel.font = fontForSize(12);
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_priceLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewHeight-1, SCREEN_WIDTH, 1)];
    line.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self.contentView addSubview:line];
}


-(void)setModel:(InviRecodeModel *)model{
    _model = model;
    _inviterLabel.text = [_model.inviter stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    _cdLabel.text = _model.cd;
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   
                                   [UIFont systemFontOfSize:12.0],NSFontAttributeName,
                                   
                                   COLOR_NAVIGATIONBAR_BARTINT,NSForegroundColorAttributeName,nil];
    NSString *shareOneP = [NSString stringWithFormat:@"%@元优惠券",_model.shareone_voucher_price];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:shareOneP];
    [attri setAttributes:attributeDict range:NSMakeRange(0,[shareOneP length]-3)];
    _priceLabel.attributedText =attri;
}






@end
