//
//  PercentView.m
//  BMW
//
//  Created by LiuP on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "PercentView.h"

@interface PercentView ()

@property (nonatomic, copy) NSString * title;

@end

@implementation PercentView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = self.frame.size.width / 2;
        self.clipsToBounds = YES;
        
        self.title = title;
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 0)];
    label.font = fontForSize(16 * W_ABCW);
    label.textColor = COLOR_NAVIGATIONBAR_BARTINT;
    label.text = self.title;
    [label sizeToFit];
    label.center = CGPointMake(self.viewWidth / 2, self.viewHeight / 2);
    [self addSubview:label];
}

#pragma mark -- setter
- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;    
    [self setNeedsDisplay];
}

- (void)setColors:(NSMutableArray *)colors
{
    _colors = colors;
}

#pragma mark -- private

-(void)drawRect:(CGRect)rect{
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    
    // 没有任何收入时显示纯色主题
    CGContextMoveToPoint(ctr, rect.size.width / 2, rect.size.height / 2);
    CGContextAddArc(ctr, rect.size.width / 2, rect.size.height / 2, self.frame.size.width / 2, 0, 2 * M_PI, 0);
    [COLOR_NAVIGATIONBAR_BARTINT set];
    CGContextFillPath(ctr);

    CGFloat sum = 0;
    CGFloat startRadius = 0;
    CGFloat endRadius = 0;
    for (int  i = 0 ; i < self.dataSource.count; i++) {
        startRadius = endRadius;
        
        endRadius = ([self.dataSource[i] floatValue]) *  M_PI * 2 + startRadius;
        
        CGContextMoveToPoint(ctr, rect.size.width / 2, rect.size.height / 2);
        CGContextAddArc(ctr, rect.size.width / 2, rect.size.height / 2, self.frame.size.width / 2.0, startRadius, endRadius, 0);
        [(UIColor *)self.colors[i] set];
        CGContextFillPath(ctr);
        sum += [self.dataSource[i] floatValue];
    }
    
    //原点坐标 半径 开始、结束的弧度 0顺时针 1逆时针
    CGFloat width = 17 * W_ABCW; // 圆圈宽度
    CGContextMoveToPoint(ctr, rect.size.width / 2, rect.size.height / 2);
    CGContextAddArc(ctr, rect.size.width / 2, rect.size.height / 2, self.frame.size.width / 2.0 - width, 0, 2 * M_PI, 0);
    [[UIColor whiteColor] set];
    CGContextFillPath(ctr);
}


@end
