//
//  VIPChoosePayView.m
//  BMW
//
//  Created by 白琴 on 16/5/9.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "VIPChoosePayView.h"

@interface VIPChoosePayView () {
    NSInteger _payTag;
}

@end

@implementation VIPChoosePayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
        [self initGesture];
    }
    return self;
}
-(void)initGesture
{
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tapGesture];
}
- (void)initUserInterface {
    UIView * testView = [UIView new];
    testView.viewSize = CGSizeMake(SCREEN_WIDTH, 192 * W_ABCH);
    [testView align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, SCREEN_HEIGHT)];
    testView.backgroundColor = [UIColor whiteColor];
    [self addSubview:testView];
    
    UILabel * titleLabel = [UILabel new];
    titleLabel.viewSize = CGSizeMake(100, 45*W_ABCH);
    [titleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, 0)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = fontForSize(13);
    titleLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    titleLabel.text = @"选择支付方式";
    [testView addSubview:titleLabel];
    
    
    NSArray * payWayArray = @[@"支付宝支付", @"微信支付"];
    NSArray * payWayImageArray = @[@"icon_zhifubao_zffs.png", @"icon_weixin_zffs.png"];
    for (int i = 0; i < payWayArray.count; i ++) {
        UIView * line = [UIView new];
        line.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5*W_ABCH);
        [line align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 45 * W_ABCH + 45*W_ABCH * i)];
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
        iconImageView.viewSize = CGSizeMake(22 * W_ABCH, 22 * W_ABCH);
        if (i == 2) {
            iconImageView.viewSize = CGSizeMake(22 * W_ABCH, 14 * W_ABCH);
        }
        [iconImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15*W_ABCW, line.viewBottomEdge + (45*W_ABCH - iconImageView.viewHeight) / 2)];
        iconImageView.image = [UIImage imageNamed:payWayImageArray[i]];
        [testView addSubview:iconImageView];
        
        UILabel * titleLabel = [UILabel new];
        titleLabel.viewSize = CGSizeMake(100, 45*W_ABCH);
        [titleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(iconImageView.viewRightEdge + 10*W_ABCW, line.viewBottomEdge)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = fontForSize(13);
        titleLabel.textColor = [UIColor colorWithHex:0x181818];
        titleLabel.text = payWayArray[i];
        [testView addSubview:titleLabel];
    }
    
    UIView * line = [UIView new];
    line.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5*W_ABCH);
    [line align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, testView.viewHeight - 45 * W_ABCH - 10 * W_ABCH)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [testView addSubview:line];
    
    UIButton * payButton = [UIButton new];
    payButton.viewSize = CGSizeMake(SCREEN_WIDTH, 45 * W_ABCH);
    [payButton align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, testView.viewHeight)];
    [payButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xfd5478] andSize:payButton.viewSize] forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    [payButton setTitle:@"确定支付（¥200）" forState:UIControlStateNormal];
    payButton.userInteractionEnabled = YES;
    payButton.selected = YES;
    [payButton addTarget:self action:@selector(clickedPayButton) forControlEvents:UIControlEventTouchUpInside];
    [testView addSubview:payButton];
}

- (void)clickedPayWayChooseButton:(UIButton *)sender {
    for (int i = 0; i < 2; i ++) {
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
}

- (void)clickedPayButton {
    if (_payTag) {
        self.buttonPress(_payTag - 19000);
        self.removeF(self);
    }
    else {
        SHOW_MSG(@"请选择支付方式");
    }
    
}

-(void)tapAction:(UIGestureRecognizer *)sender
{
    self.removeF(self);
}

@end
