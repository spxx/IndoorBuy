//
//  ScreenSectionView.m
//  BMW
//
//  Created by gukai on 16/3/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ScreenSectionView.h"

@implementation ScreenSectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}
-(void)initUserInterface
{
    _bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
    _bottomLine.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self addSubview:_bottomLine];
    
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 80, 13)];
    _textLabel.font = fontForSize(13);
    _textLabel.textColor = [UIColor colorWithHex:0x181818];
   // _textLabel.backgroundColor = [UIColor redColor];
    [self addSubview:_textLabel];
    
    _arrows = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 15 - 10, 15, 10, 6)];
    //_arrows.backgroundColor = [UIColor orangeColor];
    _arrows.image = [UIImage imageNamed:@"icon_xialajiantou_sx.png"];
    [self addSubview:_arrows];
    
    _detailLabel  =[[UILabel alloc]initWithFrame:CGRectMake(_arrows.viewX - 205, _textLabel.viewY, 200, _textLabel.viewHeight)];
    //_detailLabel.backgroundColor = [UIColor orangeColor];
    _detailLabel.font = FONT_HEITI_SC(13);
    _detailLabel.textAlignment = NSTextAlignmentRight;
    _detailLabel.textColor = [UIColor colorWithHex:0x5e5e5e];
    [self addSubview:_detailLabel];
    
    _button = [[UIButton alloc]initWithFrame:self.bounds];
    _button.backgroundColor = [UIColor clearColor];
    [_button addTarget:self action:@selector(spreadSectionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
}
-(void)arrowRotationDownAnimation{
    [UIView animateWithDuration:0.3 animations:^{
        _arrows.transform = CGAffineTransformRotate(_arrows.transform, -M_PI);
    } completion:^(BOOL finished) {
        
        
    }];
}
-(void)arrowRotationUpAnimation{
    [UIView animateWithDuration:0.3 animations:^{
        _arrows.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
       
        
    }];
}
-(void)arrowDownState
{
    _arrows.transform = CGAffineTransformMakeRotation(-M_PI);
}
-(void)arrowUpState
{
    _arrows.transform = CGAffineTransformIdentity;
}
#pragma mark -- spreadSectionBtnAction --
-(void)spreadSectionBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self arrowRotationDownAnimation];
    }
    else{
        [self arrowRotationUpAnimation];
    }
    if ([self.delegate respondsToSelector:@selector(ScreenSectionClickButton:)]) {
        [self.delegate ScreenSectionClickButton:sender];
    }
}

@end
