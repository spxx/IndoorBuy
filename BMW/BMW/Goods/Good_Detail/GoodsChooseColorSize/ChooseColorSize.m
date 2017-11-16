//
//  ChooseColorSize.m
//  BMW
//
//  Created by gukai on 16/3/11.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ChooseColorSize.h"

@interface ChooseColorSize ()
{
    UIButton * _btn;
}
@property(nonatomic,strong)UILabel * textLabel;
@end
@implementation ChooseColorSize

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUserInterface];
    }
    return self;
}
-(void)initUserInterface
{
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 , 0, 150, self.frame.size.height)];
    _textLabel.textAlignment = NSTextAlignmentLeft;
    _textLabel.textColor = [UIColor colorWithHex:0x181818];
    _textLabel.font = fontForSize(13);
    [self addSubview:_textLabel];
    
    UIImageView * arrow = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 10 - 6, (self.frame.size.height - 10)/2 , 6, 10)];
    arrow.image = [UIImage imageNamed:@"icon_xiaojiantou_gwc.png"];
    [self addSubview:arrow];
    
//    _btn = [[UIButton alloc]initWithFrame:self.bounds];
//    [_btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//    _btn.layer.borderWidth  = 1;
//    [self addSubview:_btn];
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnAction)];
    [self addGestureRecognizer:tapG];
    
}
-(void)btnAction
{
    if ([self.delegate respondsToSelector:@selector(ChooseColorSizeClickTheBtn)]) {
        [self.delegate ChooseColorSizeClickTheBtn];
    }
}
#pragma mark -- set --
-(void)setText:(NSString *)text
{
    _text = text;
    _textLabel.text = _text;
}
@end
