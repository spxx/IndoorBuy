//
//  NoNet.m
//  BMW
//
//  Created by gukai on 16/3/22.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "NoNet.h"

@implementation NoNet

-(instancetype)initWithFrame:(CGRect)frame type:(NoNetType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _noNetType = type;
        [self initUserInterface];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame type:(NoNetType)type delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _noNetType = type;
        _delegate = delegate;
        [self initUserInterface];
    }
    return self;
}
-(void)initUserInterface
{
    self.backgroundColor = [UIColor whiteColor];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 70, 150, 118)];
    imageView.image = [UIImage imageNamed:@"icon_wangluo_fl.png"];
    imageView.center = CGPointMake(self.viewWidth/2, imageView.viewY + imageView.viewHeight / 2);
    [self addSubview:imageView];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.viewBottomEdge + 24, self.viewWidth, 12)];
    label.text = @"网络加载失败";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHex:0x878787];
    label.font = fontForSize(12);
    [self addSubview:label];
    
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, label.viewBottomEdge + 20, 100, 26)];
    btn.center = CGPointMake(SCREEN_WIDTH / 2, btn.viewY + btn.viewHeight / 2);
    [btn setTitle:@"点击重新加载" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHex:0x3d3d3d] forState:UIControlStateNormal];
    btn.titleLabel.font = fontForSize(13);
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor colorWithHex:0x69696b].CGColor;
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
}
-(void)btnAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(NoNetDidClickRelaod:)]) {
        [self.delegate NoNetDidClickRelaod:sender];
    }
}
@end
