//
//  MyBackCardTableViewCell.m
//  DP
//
//  Created by 孙鹏 on 15/10/25.
//  Copyright (c) 2015年 sp. All rights reserved.
//

#import "MyBackCardTableViewCell.h"

@implementation MyBackCardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)initUserInterface
{
    _backNameLabel = [UILabel new];
    _backNameLabel.viewSize = CGSizeMake(200 * W_ABCW, 15);
    [_backNameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15*W_ABCW,13*W_ABCH)];
    _backNameLabel.font = fontForSize(13*W_ABCH);
    _backNameLabel.textColor = [UIColor colorWithHex:0x181818];
    _backNameLabel.text = _bankModel.bank;
    [_backNameLabel sizeToFit];
    _backNameLabel.viewSize = CGSizeMake(_backNameLabel.viewWidth, _backNameLabel.viewHeight);
    [_backNameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15*W_ABCW,12*W_ABCH)];
    [self.contentView addSubview:_backNameLabel];
    
    _backCardInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_backNumberLabel.frame) + 9, _backNumberLabel.frame.origin.y, 100 * W_ABCW, 11*W_ABCH)];
    _backCardInfoLabel.font = fontForSize(11*W_ABCH);
    _backCardInfoLabel.textColor = [UIColor colorWithHex:0x969696];
    _backCardInfoLabel.text = @"储蓄卡";
    [_backCardInfoLabel sizeToFit];
    _backCardInfoLabel.viewSize = CGSizeMake(_backCardInfoLabel.viewWidth, _backCardInfoLabel.viewHeight);
    [_backCardInfoLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_backNameLabel.viewX, _backNameLabel.viewBottomEdge+5*W_ABCH)];
    [self.contentView addSubview:_backCardInfoLabel];
    
    _backNumberLabel = [UILabel new];
    _backNumberLabel.viewSize = CGSizeMake(60 * W_ABCW, 13*W_ABCH);
    [_backNumberLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0,0)];
    _backNumberLabel.font = fontForSize(13*W_ABCH);
    _backNumberLabel.textColor = [UIColor colorWithHex:0x969696];
    _backNumberLabel.text = [NSString stringWithFormat:@"**** **** **** %@",_bankModel.bankCardNum];
    [_backNumberLabel sizeToFit];
    _backNumberLabel.viewSize = CGSizeMake(_backNumberLabel.viewWidth, _backNumberLabel.viewHeight);
    [_backNumberLabel align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15*W_ABCH, 25*W_ABCH)];
    [self.contentView addSubview:_backNumberLabel];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0,  55*W_ABCH - 0.5*W_ABCH, SCREEN_WIDTH, 0.5*W_ABCH)];
    line.backgroundColor = [UIColor colorWithHex:0xdedede];
    [self.contentView addSubview:line];
}


-(void)setBankModel:(BankCardModel *)bankModel{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    _bankModel = bankModel;
    [self initUserInterface];
}

-(void)setIsSpecial:(BOOL)isSpecial{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    [self initAddUserInterface];
}

-(void)initAddUserInterface{
    _iconImageView = [UIImageView new];
    _iconImageView.viewSize = CGSizeMake(22, 22);
    [_iconImageView align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(15*W_ABCW, 75*W_ABCH/2)];
    [_iconImageView setImage:[UIImage imageNamed:@"icon_tianjia_wdyhk.png"]];
    [self.contentView addSubview:_iconImageView];
    
    _backNameLabel = [UILabel new];
    _backNameLabel.viewSize = CGSizeMake(200 * W_ABCW, 15);
    [_backNameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_iconImageView.viewRightEdge+10*W_ABCW, 0)];
    _backNameLabel.font = fontForSize(13*W_ABCH);
    _backNameLabel.text = @"添加银行卡";
    _backNameLabel.textColor = [UIColor colorWithHex:0x181818];
    [_backNameLabel sizeToFit];
    _backNameLabel.viewSize = CGSizeMake(_backNameLabel.viewWidth, 75*W_ABCH);
    [_backNameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_iconImageView.viewRightEdge+10*W_ABCW, 0)];
    [self.contentView addSubview:_backNameLabel];
    
    UIImageView * jianTouImageView = [UIImageView new];
    jianTouImageView.viewSize = CGSizeMake(8,15);
    [jianTouImageView align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15*W_ABCW,75*W_ABCH/2)];
    [jianTouImageView setImage:[UIImage imageNamed:@"icon_jiantou_qyzc"]];
    [self.contentView addSubview:jianTouImageView];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0,  75*W_ABCH - 0.5*W_ABCH, SCREEN_WIDTH, 0.5*W_ABCH)];
    line.backgroundColor = [UIColor colorWithHex:0xdedede];
    [self.contentView addSubview:line];
}





@end
