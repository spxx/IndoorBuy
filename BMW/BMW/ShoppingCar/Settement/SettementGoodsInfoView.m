//
//  SettementGoodsInfoView.m
//  BMW
//
//  Created by 白琴 on 16/3/12.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "SettementGoodsInfoView.h"

@implementation SettementGoodsInfoView

- (instancetype)initWithFrame:(CGRect)frame dataSourece:(NSArray *)dataSourceArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i < dataSourceArray.count; i++) {
            NSDictionary * dataDic = dataSourceArray[i];
            NSArray * goods = [dataDic objectForKeyNotNull:@"goods"] ? [dataDic objectForKeyNotNull:@"goods"] : [dataDic objectForKeyNotNull:@"value"] ;
            
            UILabel * titleLabel = [UILabel new];
            titleLabel.viewSize = CGSizeMake(SCREEN_WIDTH - 15, 44);
            [titleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0 + i * 119)];
            titleLabel.font = fontForSize(12);
            titleLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
            titleLabel.text = [dataDic objectForKeyNotNull:@"tag_name"] ? [dataDic objectForKeyNotNull:@"tag_name"] : [dataDic objectForKeyNotNull:@"title"] ;
            [self addSubview:titleLabel];
            
            UIImageView * jiantouImageView = [UIImageView new];
            jiantouImageView.viewSize = CGSizeMake(6, 10);
            [jiantouImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, titleLabel.viewBottomEdge + (60 - jiantouImageView.viewHeight) / 2)];
            jiantouImageView.image = [UIImage imageNamed:@"icon_xiaojiantou_gwc"];
            [self addSubview:jiantouImageView];
            
            UILabel * goodsNumLabel = [UILabel new];
            goodsNumLabel.viewSize = CGSizeMake(100, 60);
            goodsNumLabel.font = fontForSize(12);
            goodsNumLabel.textColor = [UIColor colorWithHex:0x181818];
            goodsNumLabel.text = [NSString stringWithFormat:@"共%ld件商品", goods.count];
            [goodsNumLabel sizeToFit];
            [goodsNumLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(jiantouImageView.viewX - 7, titleLabel.viewBottomEdge + (60 - goodsNumLabel.viewHeight) / 2)];
            [self addSubview:goodsNumLabel];
            
            UIView * line = [UIView new];
            line.viewSize = CGSizeMake(SCREEN_WIDTH, 1);
            [line align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, titleLabel.viewBottomEdge + 60 + 15)];
            line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
            [self addSubview:line];
            
            
            for (int j = 0; j < goods.count; j ++) {
                NSDictionary * goodsDic = goods[j];
                
                UIImageView * goodsImageView = [UIImageView new];
                goodsImageView.viewSize = CGSizeMake(60, 60);
                [goodsImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 + j * (goodsImageView.viewWidth + 6), titleLabel.viewBottomEdge)];
                [self addSubview:goodsImageView];
                
                if (j == 3) {
                    goodsImageView.viewSize = CGSizeMake(20, 4);
                    [goodsImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 + j * (60 + 6) + 12, titleLabel.viewBottomEdge + (60 - goodsImageView.viewHeight) / 2)];
                    [goodsImageView setImage:[UIImage imageNamed:@"icon_more_js"]];
                    break;
                }
                else {
                    goodsImageView.layer.borderWidth = 0.5;
                    goodsImageView.layer.borderColor = [UIColor colorWithHex:0xebebeb].CGColor;
                    [goodsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",goodsDic[@"goods_image"]]] placeholderImage:[UIImage imageNamed:@"logo_bangmaiwang_splb"]];
                }
            }
            
            UIButton * goodsInfoButton = [UIButton new];
            goodsInfoButton.viewSize = CGSizeMake(self.viewWidth, 119);
            [goodsInfoButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0 + i * goodsInfoButton.viewHeight)];
            goodsInfoButton.tag = 13000 + i;
            [goodsInfoButton addTarget:self action:@selector(clickedGoodsInfoButton:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:goodsInfoButton];
        }
    }
    return self;
}

/**
 *  点击查看商品
 */
- (void)clickedGoodsInfoButton:(UIButton *)sender {
    NSInteger index = sender.tag - 13000;
    self.showGoodsListButton(index);
}

@end
