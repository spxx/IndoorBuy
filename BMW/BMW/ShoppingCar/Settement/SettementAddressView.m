//
//  SettementGoodsInfoView.m
//  BMW
//
//  Created by 白琴 on 16/3/12.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "SettementAddressView.h"

@interface SettementAddressView () {
    BOOL _isHaveAddress;
    UIImageView * _addImageView;
    UILabel * _alertLabel;
    UIImageView * _jianTouImageView;
    UIView * _line1;
    UIButton * _addressButton;
    UIView * _haveAddressView;
}

@end

@implementation SettementAddressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isHaveAddress = NO;
        self.backgroundColor = [UIColor colorWithHex:0xfffaf3];
        UIView * line = [UIView new];
        line.viewSize = CGSizeMake(SCREEN_WIDTH, 1);
        [line align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [self addSubview:line];
        _line1 = [UIView new];
        _line1.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        _line1.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [self addSubview:_line1];
        
        _jianTouImageView = [UIImageView new];
        _jianTouImageView.viewSize = CGSizeMake(6, 10);
        _jianTouImageView.image = [UIImage imageNamed:@"icon_xiaojiantou_gwc"];
        [self addSubview:_jianTouImageView];
        
        //没有选择收货信息的UI
        _addImageView = [UIImageView new];
        _addImageView.viewSize = CGSizeMake(18, 18);
        [_addImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, (self.viewHeight - _addImageView.viewHeight) / 2)];
        [_addImageView setImage:[UIImage imageNamed:@"icon_tianjia_js"]];
        [self addSubview:_addImageView];
        _alertLabel = [UILabel new];
        _alertLabel.viewSize = CGSizeMake(200, self.viewHeight);
        [_alertLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_addImageView.viewRightEdge + 10, 0)];
        _alertLabel.font = fontForSize(13);
        _alertLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
        _alertLabel.text = @"请选择收货地址";
        [self addSubview:_alertLabel];
        [_jianTouImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, (self.viewHeight - _jianTouImageView.viewHeight) / 2)];
        [_line1 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, self.viewHeight)];
        
        _addressButton = [UIButton new];
        _addressButton.viewSize = self.viewSize;
        [_addressButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        [_addressButton addTarget:self action:@selector(clickedAddressButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addressButton];
    }
    return self;
}

- (void)setAddressDic:(NSDictionary *)addressDic {
    if (!_addressDic) {
        [_addImageView removeFromSuperview];
        [_alertLabel removeFromSuperview];
        [_haveAddressView removeFromSuperview];
        
        //选择了收货地址之后
//        self.viewSize = CGSizeMake(SCREEN_WIDTH, 95);
        self.viewSize = CGSizeMake(SCREEN_WIDTH, 115);
        
        [self haveAddressView:addressDic];
        
        [_jianTouImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, (self.viewHeight - _jianTouImageView.viewHeight) / 2)];
        [_line1 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, self.viewHeight)];
        _addressButton.viewSize = self.viewSize;
        [self bringSubviewToFront:_jianTouImageView];
        [self bringSubviewToFront:_addressButton];
    }
}

- (void)haveAddressView:(NSDictionary *)addressDic {
    
    _haveAddressView = [[UIView alloc] initWithFrame:self.frame];
    _haveAddressView.backgroundColor = [UIColor colorWithHex:0xfffaf3];
    [self addSubview:_haveAddressView];
    
    
    UIImageView * peopleImageView = [UIImageView new];
    peopleImageView.viewSize = CGSizeMake(15, 16);
    [peopleImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 20.5)];
    peopleImageView.image = [UIImage imageNamed:@"icon_yonghu_js"];
    [_haveAddressView addSubview:peopleImageView];
    
    UILabel * nameLabel = [UILabel new];
    nameLabel.viewSize = CGSizeMake(100, 15);
    nameLabel.font = fontForSize(15);
    nameLabel.textColor = [UIColor colorWithHex:0x181818];
    nameLabel.text = addressDic[@"true_name"];
    [nameLabel sizeToFit];
    [nameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(peopleImageView.viewRightEdge + 10*W_ABCW, 20)];
    [_haveAddressView addSubview:nameLabel];
    
    UIImageView * mobileImageView = [UIImageView new];
    mobileImageView.viewSize = CGSizeMake(11, 15);
    [mobileImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(nameLabel.viewRightEdge + 40*W_ABCW, 20)];
    mobileImageView.image = [UIImage imageNamed:@"icon_shouji_js"];
    [_haveAddressView addSubview:mobileImageView];
    
    UILabel * mobileLabel = [UILabel new];
    mobileLabel.viewSize = CGSizeMake(100, 15);
    mobileLabel.font = fontForSize(15);
    mobileLabel.textColor = [UIColor colorWithHex:0x181818];
    mobileLabel.text = addressDic[@"mob_phone"];
    [mobileLabel sizeToFit];
    [mobileLabel align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(mobileImageView.viewRightEdge + 8*W_ABCW, mobileImageView.viewY+mobileImageView.viewHeight/2)];
    [_haveAddressView addSubview:mobileLabel];
    
    UILabel * IDCardNumberLabel = [UILabel new];
    IDCardNumberLabel.viewSize = CGSizeMake(100, 15);
    IDCardNumberLabel.font = fontForSize(15);
    IDCardNumberLabel.textColor = [UIColor colorWithHex:0x181818];
    IDCardNumberLabel.text = addressDic[@"idcard"];
    [IDCardNumberLabel sizeToFit];
    [IDCardNumberLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, peopleImageView.viewBottomEdge+14)];
//    [IDCardNumberLabel align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(mobileImageView.viewRightEdge + 8*W_ABCW, mobileImageView.viewY+mobileImageView.viewHeight/2)];
    [_haveAddressView addSubview:IDCardNumberLabel];
    
    
    UILabel * addressLabel = [UILabel new];
    addressLabel.viewSize = CGSizeMake(SCREEN_WIDTH - 30 - _jianTouImageView.viewWidth - 15, 40);
    addressLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13], NSParagraphStyleAttributeName:paragraphStyle};
    addressLabel.attributedText =[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", addressDic[@"area_info"], addressDic[@"address"]] attributes:attributes];
    addressLabel.numberOfLines = 2;
    addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [addressLabel sizeToFit];
//    [addressLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, nameLabel.viewBottomEdge + 14)];
    [addressLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, IDCardNumberLabel.viewBottomEdge + 14)];
    [_haveAddressView addSubview:addressLabel];
}


/**
 *  点击选择收货信息
 */
- (void)clickedAddressButton:(UIButton *)sender {
    NSLog(@"点击选择地址");
    if ([self.delegate respondsToSelector:@selector(chooseAddressBtn)]) {
        [self.delegate chooseAddressBtn];
    }
}

@end
