//
//  SliderButton.m
//  BMW
//
//  Created by 白琴 on 16/3/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "SliderButton.h"

@interface SliderButton () {
    UIButton * _currentButton;
    UIView * _redLine;
}

@end

@implementation SliderButton


- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.layer.shadowOffset = CGSizeMake(0, 2);
        //self.layer.shadowColor = [UIColor blackColor].CGColor;
        //self.layer.shadowOpacity = 1;
        
        self.backgroundColor = [UIColor whiteColor];
        UIImageView * backImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        backImageView.image = [UIImage imageNamed:@"tab.dingbuqiehuan_zfjs.png"];
        [self addSubview:backImageView];
        
        self.showsHorizontalScrollIndicator = NO;
        CGFloat btn_w = SCREEN_WIDTH / 3;
        //        CGFloat space_w = 10 * W_AW;
        for (int i = 0; i < titles.count; i ++) {
            UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(i * (btn_w), 0, btn_w, CGRectGetHeight(self.frame))];
            button.tag = 200 + i;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.titleLabel.font = FONT_HEITI_SC(15);
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHex:0x181818] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHex:0xfd5487] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(slideMenuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            button.titleLabel.font = FONT_HEITI_SC(14);
            //根据屏幕设置button字体大小
//            CGFloat height = SCREEN_HEIGHT;
//            if (height == IPHONE4S_SCREEN_HEIGHT) {
//                button.titleLabel.font = FONT_HEITI_SC(13);
//            }
//            if (height == IPHONE5S_SCREEN_HEIGHT) {
//                button.titleLabel.font = FONT_HEITI_SC(14);
//            }
//            if (height == IPHONE6_SCREEN_HEIGHT) {
//                button.titleLabel.font = FONT_HEITI_SC(15);
//            }
//            if (height == IPHONE6P_SCREEN_HEIGHT) {
//                button.titleLabel.font = FONT_HEITI_SC(16);
//            }
            if (i == titles.count - 1) {
                UIImageView * backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(button.frame), self.frame.size.height)];
                backImageView.image = [UIImage imageNamed:@"tab.dingbuqiehuan_zfjs.png"];
                [self insertSubview:backImageView atIndex:0];
            }
        }
        _currentButton = (UIButton *)[self viewWithTag:200];
        _currentButton.selected = YES;
        
        self.contentSize = CGSizeMake(titles.count * (btn_w), frame.size.height);
        
        _redLine = [[UIView alloc]initWithFrame:CGRectMake(_currentButton.frame.origin.x, frame.size.height - 2, btn_w, 2)];
        _redLine.backgroundColor = [UIColor colorWithHex:0xfd5487];
        [self addSubview:_redLine];
        
    }
    return self;
}


#pragma mark -- actions
- (void)slideMenuButtonPressed:(UIButton *)sender
{
//    [MB_CANTOUCH_HUB hide:YES];
    //NSLog(@"%@",MB_CANTOUCH_HUB.hidden?@"yes":@"no");
    if (sender.selected == YES) {
        return;
    }
    
    sender.selected = !sender.selected;
    _currentButton.selected = NO;
    _currentButton = sender;
    
    [self animationOfRedLine];
    
    /**
     *  代理回调
     */
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:sender.tag - 200 inSection:0];
    [self.slideButtonDelegate sledeMenu:sender didSelectAtIndexPath:indexPath];
}
/**
 *  移动红线
 */
- (void)animationOfRedLine
{
    [UIView animateWithDuration:0.2 animations:^{
        _redLine.frame = CGRectMake(_currentButton.frame.origin.x, self.frame.size.height - 2, _currentButton.frame.size.width, 2);
    }];
}

@end
