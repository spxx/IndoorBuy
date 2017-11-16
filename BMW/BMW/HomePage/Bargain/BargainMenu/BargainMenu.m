//
//  BargainMenu.m
//  BMW
//
//  Created by gukai on 16/3/5.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BargainMenu.h"

@interface BargainMenu ()
@property(nonatomic,strong)UIButton * currentBtn;

@end
@implementation BargainMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame muneData:(NSArray *)muneData
{
    self = [super initWithFrame:frame];
    if (self) {
        _menuData = muneData;
        [self initUserInterface];
    }
    return self;
}
-(void)initUserInterface
{
    CGFloat btn_with = self.viewWidth/_menuData.count;
    UIButton * lastBtn;
    for (int i = 0; i < _menuData.count; i ++) {
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(lastBtn.viewRightEdge, 0, btn_with, self.viewHeight)];
        button.titleLabel.font = fontForSize(14);
        [button setTitle:_menuData[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHex:0x181818] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHex:0xfd5487] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(muneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        lastBtn = button;
        if (i == 0) {
            button.selected = YES;
            self.currentBtn = button;
        }
    }
}
-(void)muneButtonAction:(UIButton *)sender
{
    if (self.currentBtn == sender) {
        return;
    }
    self.currentBtn.selected = NO;
    sender.selected = YES;
    self.currentBtn = sender;
    if ([self.delegate respondsToSelector:@selector(bargainMenuClickMuneButton:)]) {
        [self.delegate bargainMenuClickMuneButton:sender];
    }
}
@end
