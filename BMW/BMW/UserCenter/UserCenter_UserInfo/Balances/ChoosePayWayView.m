//
//  ChoosePayWayView.m
//  BMW
//
//  Created by 白琴 on 16/5/25.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ChoosePayWayView.h"

@interface ChoosePayWayView () {
     NSInteger _payTag;
    NSArray * _payWayImageArray;
    NSArray * _payWayArray;
    BOOL _isNeedTitle;
}

@end

@implementation ChoosePayWayView

- (instancetype)initWithFrame:(CGRect)frame payWayArray:(NSArray *)payWayArray payWayImageArray:(NSArray *)payWayImageArray isNeedTitle:(BOOL)isNeedTitle {
    self = [super initWithFrame:frame];
    if (self) {
        _payWayArray = payWayArray;
        _payWayImageArray = payWayImageArray;
        _isNeedTitle = isNeedTitle;
        [self initUserInterface];
    }
    return self;
}
- (void)initUserInterface {
    UIView * testView = [UIView new];
    testView.viewSize = self.viewSize;
    [testView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
    testView.backgroundColor = [UIColor whiteColor];
    [self addSubview:testView];
    
    if (_isNeedTitle) {
        UILabel * titleLabel = [UILabel new];
        titleLabel.viewSize = CGSizeMake(100, 45*W_ABCH);
        [titleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, 0)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = fontForSize(13);
        titleLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        titleLabel.text = @"选择支付方式";
        [testView addSubview:titleLabel];
    }
    for (int i = 0; i < _payWayArray.count; i ++) {
        UIView * line = [UIView new];
        line.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5*W_ABCH);
        if (_isNeedTitle) {
            [line align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 45 * W_ABCH + 45*W_ABCH * i)];
        }
        else {
            [line align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 45*W_ABCH * i)];
        }
        line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [testView addSubview:line];
        
        UIButton * chooseButton = [UIButton new];
        chooseButton.viewSize = CGSizeMake(18 * W_ABCH, 18 * W_ABCH);
        [chooseButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15*W_ABCW, line.viewBottomEdge + (45*W_ABCH - chooseButton.viewHeight) / 2)];
        [chooseButton setBackgroundImage:[UIImage imageNamed:@"icon_gouxuan_nor_gwc"] forState:UIControlStateNormal];
        [chooseButton setBackgroundImage:[UIImage imageNamed:@"icon_gouxuan_cli_gwc"] forState:UIControlStateSelected];
        chooseButton.tag = 19000 + i;
        [chooseButton addTarget:self action:@selector(clickedPayWayChooseButton:) forControlEvents:UIControlEventTouchUpInside];
        [testView addSubview:chooseButton];
        
        UIButton * bigButton = [UIButton new];
        bigButton.viewSize = CGSizeMake(SCREEN_WIDTH - 30 * W_ABCH, 45 * W_ABCH);
        [bigButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, line.viewBottomEdge)];
        bigButton.tag = chooseButton.tag + 100;
        [bigButton addTarget:self action:@selector(clickedPayWayChooseButton:) forControlEvents:UIControlEventTouchUpInside];
        [testView addSubview:bigButton];
        
        
        UIImageView * iconImageView = [UIImageView new];
        iconImageView.image = [UIImage imageNamed:_payWayImageArray[i]];
        iconImageView.viewSize = iconImageView.image.size;
//        if (i == 2) {
//            iconImageView.viewSize = CGSizeMake(19 * W_ABCH, 22 * W_ABCH);
//        }
        [iconImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15*W_ABCW, line.viewBottomEdge + (45*W_ABCH - iconImageView.viewHeight) / 2)];
        [testView addSubview:iconImageView];
        
        UILabel * titleLabel = [UILabel new];
        titleLabel.viewSize = CGSizeMake(100, 45*W_ABCH);
        [titleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(iconImageView.viewRightEdge + 10*W_ABCW, line.viewBottomEdge)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = fontForSize(13);
        titleLabel.textColor = [UIColor colorWithHex:0x181818];
        titleLabel.text = _payWayArray[i];
        [titleLabel sizeToFit];
        titleLabel.viewHeight = 45*W_ABCH;
        [testView addSubview:titleLabel];
    }
    
    UIView * line = [UIView new];
    line.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5*W_ABCH);
    [line align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, testView.viewHeight)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [testView addSubview:line];
}

- (void)clickedPayWayChooseButton:(UIButton *)sender {
    for (int i = 0; i < _payWayArray.count; i ++) {
        UIButton * button = [self viewWithTag:19000 + i];
        button.selected = NO;
    }
    if (sender.tag >= 19100) {
        UIButton * button = [self viewWithTag:sender.tag - 100];
        button.selected = YES;
        _payTag = sender.tag - 100;
    }else{
        sender.selected = YES;
        _payTag = sender.tag;
    }
    self.buttonPress(_payTag - 19000);
}

@end
