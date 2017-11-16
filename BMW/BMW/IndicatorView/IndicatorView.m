//
//  IndicatorView.m
//  BMW
//
//  Created by gukai on 16/4/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "IndicatorView.h"

@implementation IndicatorView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}
-(void)initUserInterface
{
    /*
    UIView * view = [[UIView alloc]initWithFrame:self.bounds];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [self addSubview:view];
     */
    
    _indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _indicator.center = CGPointMake(self.viewWidth / 2, self.viewHeight / 2);
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self addSubview:_indicator];
}
@end
