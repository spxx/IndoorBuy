//
//  UITabBar+BadgeColor.m
//  BMW
//
//  Created by rr on 2016/12/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "UITabBar+BadgeColor.h"

@implementation UITabBar (BadgeColor)

- (void)showBadgeOnItemIndex:(int)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:888];
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888;
    badgeView.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
    CGRect tabFrame = self.frame;
    //确定小红点的位置
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(SCREEN_WIDTH/4*2.6, y-1, 18, 18);
    UILabel *numLabel = [UILabel new];
    numLabel.textColor = [UIColor whiteColor];
    numLabel.text = [NSString stringWithFormat:@"%d",index];
    numLabel.font = fontForSize(14);
    [numLabel sizeToFit];
    [numLabel align:ViewAlignmentCenter relativeToPoint:CGPointMake(badgeView.viewWidth/2, badgeView.viewHeight/2)];
    [badgeView addSubview:numLabel];
    badgeView.layer.cornerRadius = badgeView.frame.size.width/2;
    [self addSubview:badgeView];
    
}
- (void)hideBadgeOnItemIndex{
    //移除小红点
    [self removeBadgeOnItemIndex:888];
}
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews)
    {
        if (subView.tag == 888) {
            [subView removeFromSuperview];
        }
    }
}


@end

