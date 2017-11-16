//
//  UserCollectTableViewCell.m
//  BMW
//
//  Created by 白琴 on 16/3/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "UserCollectListTableViewCell.h"

@interface UserCollectListTableViewCell () {
    UIImageView * _goodsImageView;                      //商品主图
    UIImageView * _goodsPlaceImageView;                 //商品产地
    UILabel * _goodsNameLabel;                          //商品名称
    UILabel * _goodsPriceLabel;                         //商品价格
    UILabel * _goodsVIPPriceLabel;                      //VIP价格
    UILabel * _goodsSizeLabel;                          //商品规格
    UIView * _fuzzyView;                                //下架商品的蒙版
    UILabel * _outGoodsLabel;                             //下架标注的灰条
    UIButton * _bigButton;
    
}

@end

@implementation UserCollectListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellAccessoryNone;
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    _chooseButton = [UIButton new];
    _chooseButton.viewSize = CGSizeMake(18 * W_ABCW, 18 * W_ABCW);
    [_chooseButton addTarget:self action:@selector(clickedChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    [_chooseButton setBackgroundImage:[UIImage imageNamed:@"icon_gouxuan_nor_gwc"] forState:UIControlStateNormal];
    [_chooseButton setBackgroundImage:[UIImage imageNamed:@"icon_gouxuan_cli_gwc"] forState:UIControlStateSelected];
    [_chooseButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, (99 * W_ABCW - _chooseButton.viewHeight) / 2)];
    [self.contentView addSubview:_chooseButton];
    _chooseButton.hidden = YES;
    
    _goodsImageView = [UIImageView new];
    _goodsImageView.viewSize = CGSizeMake(79 * W_ABCW, 76 * W_ABCW);
    [_goodsImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, 10 * W_ABCW)];
    [self.contentView addSubview:_goodsImageView];
    
    _goodsPlaceImageView = [UIImageView new];
    _goodsPlaceImageView.viewSize = CGSizeMake(15 * W_ABCW, 11 * W_ABCW);
    [_goodsPlaceImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(_goodsImageView.viewRightEdge, _goodsImageView.viewY)];
    [self.contentView addSubview:_goodsPlaceImageView];
    
    _goodsNameLabel = [UILabel new];
    _goodsNameLabel.viewSize = CGSizeMake(SCREEN_WIDTH - _goodsImageView.viewRightEdge - 12 * W_ABCW - 15 * W_ABCW, 30);
    [_goodsNameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_goodsImageView.viewRightEdge + 12 * W_ABCW, _goodsImageView.viewY)];
    _goodsNameLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
    [self.contentView addSubview:_goodsNameLabel];
    
    _goodsSizeLabel = [UILabel new];
    _goodsSizeLabel.viewSize = CGSizeMake(SCREEN_WIDTH - _goodsImageView.viewRightEdge - 12 * W_ABCW - 15 * W_ABCW, 30);
    [_goodsSizeLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_goodsImageView.viewRightEdge + 12 * W_ABCW, _goodsImageView.viewY+_goodsImageView.viewHeight/2)];
    _goodsSizeLabel.font = fontForSize(10);
    _goodsSizeLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    [self.contentView addSubview:_goodsSizeLabel];
    
    _goodsPriceLabel = [UILabel new];
    _goodsPriceLabel.viewSize = CGSizeMake(SCREEN_WIDTH - _goodsImageView.viewRightEdge - 12 * W_ABCW - 15 * W_ABCW, 30);
    [_goodsPriceLabel align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(_goodsImageView.viewRightEdge + 12 * W_ABCW, _goodsImageView.viewBottomEdge)];
    _goodsPriceLabel.font = fontForSize(12);
    _goodsPriceLabel.textColor = [UIColor colorWithHex:0xfd5487];
    [self.contentView addSubview:_goodsPriceLabel];
    
    _goodsVIPPriceLabel = [UILabel new];
    _goodsVIPPriceLabel.viewSize = CGSizeMake(SCREEN_WIDTH - _goodsImageView.viewRightEdge - 12 * W_ABCW - 15 * W_ABCW, 30);
    _goodsVIPPriceLabel.font = fontForSize(9);
    [_goodsVIPPriceLabel align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(_goodsPriceLabel.viewRightEdge + 5 * W_ABCW, _goodsImageView.viewBottomEdge)];
    _goodsVIPPriceLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    [self.contentView addSubview:_goodsVIPPriceLabel];
    
    _fuzzyView = [UIView new];
    _fuzzyView.viewSize = CGSizeMake(SCREEN_WIDTH, 99 * W_ABCW);
    [_fuzzyView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
    _fuzzyView.backgroundColor = [UIColor whiteColor];
    _fuzzyView.alpha = 0.6;
    [self.contentView addSubview:_fuzzyView];
    //下架灰色条
    _outGoodsLabel = [UILabel new];
    _outGoodsLabel.viewSize = CGSizeMake(_goodsImageView.viewWidth, 14 * W_ABCW);
    [_outGoodsLabel align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(_goodsImageView.viewX, _goodsImageView.viewBottomEdge)];
    _outGoodsLabel.text = @"已下架";
    _outGoodsLabel.textColor = [UIColor whiteColor];
    _outGoodsLabel.font = fontForSize(10);
    _outGoodsLabel.textAlignment = NSTextAlignmentCenter;
    _outGoodsLabel.backgroundColor = [UIColor blackColor];
    _outGoodsLabel.alpha = 0.6;
    [self.contentView addSubview:_outGoodsLabel];
    
    _fuzzyView.hidden = YES;
    _outGoodsLabel.hidden = YES;
    
    _bigButton = [UIButton new];
    _bigButton.viewSize = CGSizeMake(37.5 * W_ABCW, 99 * W_ABCW);
    [_bigButton addTarget:self action:@selector(clickedChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    [_bigButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, (99 * W_ABCW - _bigButton.viewHeight) / 2)];
    [self.contentView addSubview:_bigButton];
    
}

- (void)setDataSourceDic:(NSDictionary *)dataSourceDic {
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:dataSourceDic[@"goods_image"]] placeholderImage:[UIImage imageNamed:@"logo_bangmaiwang_splb"]];
    [_goodsPlaceImageView sd_setImageWithURL:[NSURL URLWithString:dataSourceDic[@"origin"]] placeholderImage:nil];
    
    _goodsNameLabel.numberOfLines = 2 ;
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 0;
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle};
    _goodsNameLabel.attributedText =[[NSAttributedString alloc] initWithString:dataSourceDic[@"goods_name"] attributes:attributes];
    _goodsNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_goodsNameLabel sizeToFit];
    [_goodsNameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_goodsImageView.viewRightEdge + 12 * W_ABCW, _goodsImageView.viewY)];
    
    if ([dataSourceDic[@"goods_spec"] isKindOfClass:[NSNull class]]) {
        _goodsSizeLabel.hidden = YES;
    }
    else {
        NSMutableString *goodsguige = [NSMutableString string];
        NSArray *allkeys =[dataSourceDic[@"goods_spec"] allKeys];
        if (allkeys.count==1) {
            _goodsSizeLabel.text = [[dataSourceDic[@"goods_spec"] allValues] firstObject];
        }else{
            [allkeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx==allkeys.count-1) {
                    [goodsguige insertString:[NSString stringWithFormat:@"%@,",dataSourceDic[@"goods_spec"][obj]] atIndex:0];
                }else{
                    [goodsguige insertString:[NSString stringWithFormat:@"%@",dataSourceDic[@"goods_spec"][obj]] atIndex:0];
                }
            }];
            _goodsSizeLabel.text = [NSString stringWithFormat:@"%@",goodsguige];
        }
        [_goodsSizeLabel sizeToFit];
        [_goodsSizeLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_goodsImageView.viewRightEdge + 12 * W_ABCW, _goodsImageView.viewY+_goodsImageView.viewHeight/2)];
    }
    _goodsPriceLabel.text = [NSString stringWithFormat:@"¥%@", dataSourceDic[@"goods_price"]];
    [_goodsPriceLabel sizeToFit];
    [_goodsPriceLabel align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(_goodsImageView.viewRightEdge + 12 * W_ABCW, _goodsImageView.viewBottomEdge)];
    
    _goodsVIPPriceLabel.text = [NSString stringWithFormat:@"¥%@", dataSourceDic[@"goods_vip_price"]];
    [_goodsVIPPriceLabel sizeToFit];
    [_goodsVIPPriceLabel align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(_goodsPriceLabel.viewRightEdge + 5 * W_ABCW, _goodsImageView.viewBottomEdge)];
    
    //不为1为下架
    if (![dataSourceDic[@"goods_state"] isEqualToString:@"1"]) {
        _fuzzyView.hidden = NO;
        _outGoodsLabel.hidden = NO;
        [self.contentView bringSubviewToFront:_chooseButton];
    }
}
/**
 *  是否为编辑
 */
- (void)setIsEdit:(BOOL)isEdit {
    if (isEdit) {
        _chooseButton.hidden = NO;
        _bigButton.hidden = NO;
        [_goodsImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_chooseButton.viewRightEdge + 12 * W_ABCW, 10 * W_ABCW)];
    }
    else {
        _chooseButton.hidden = YES;
        _bigButton.hidden = YES;
        [_goodsImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, 10 * W_ABCW)];
    }
    [self subViewFrame];
}
/**
 *  是否为全选
 */
- (void)setIsChooseAll:(BOOL)isChooseAll {
    if (isChooseAll) {
        _chooseButton.selected = YES;
    }
    else {
        _chooseButton.selected = NO;
    }
    
}

- (void)subViewFrame {
    [_goodsPlaceImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(_goodsImageView.viewRightEdge, _goodsImageView.viewY)];
    _goodsNameLabel.viewSize = CGSizeMake(SCREEN_WIDTH - _goodsImageView.viewRightEdge - 12 * W_ABCW - 15 * W_ABCW, 30);
    [_goodsNameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_goodsImageView.viewRightEdge + 12 * W_ABCW, _goodsImageView.viewY)];
    [_goodsSizeLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_goodsImageView.viewRightEdge + 12 * W_ABCW, _goodsImageView.viewY+_goodsImageView.viewHeight/2)];
    [_goodsPriceLabel align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(_goodsImageView.viewRightEdge + 12 * W_ABCW, _goodsImageView.viewBottomEdge)];
    [_goodsVIPPriceLabel align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(_goodsPriceLabel.viewRightEdge + 5 * W_ABCW, _goodsImageView.viewBottomEdge)];
    [_outGoodsLabel align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(_goodsImageView.viewX, _goodsImageView.viewBottomEdge)];
}


#pragma mark -- 点击
- (void)clickedChooseButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _chooseButton.selected = YES;
        self.clickedChooseButton(YES);
    }
    else {
        _chooseButton.selected = NO;
        self.clickedChooseButton(NO);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
