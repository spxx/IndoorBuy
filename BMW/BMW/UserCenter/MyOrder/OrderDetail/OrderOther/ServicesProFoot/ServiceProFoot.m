//
//  ServiceProFoot.m
//  BMW
//
//  Created by gukai on 16/3/23.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ServiceProFoot.h"

@interface ServiceProFoot ()
@property(nonatomic,strong)UILabel * label;
@property(nonatomic,strong)UIView * line;
@end
@implementation ServiceProFoot
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
    self.backgroundColor = [UIColor colorWithHex:0xfffaf3];
    //self.backgroundColor = [UIColor blueColor];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, self.viewHeight - 30)];
    label.textColor = [UIColor colorWithHex:0x3d3d3d];
    label.font = fontForSize(10);
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
//label.text = @"亲爱的客户您好，您申请的服务已经超过我的极限啦，这样非常不好，知道吗？";
//    [label sizeToFit];
//    label.center =  CGPointMake(self.viewWidth / 2, self.viewHeight / 2);
    [self addSubview:label];
    self.label = label;
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, self.viewHeight - 0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self addSubview:line];
    self.line = line;
}
-(void)setReply_message:(NSString *)reply_message
{
    _reply_message = reply_message;
    if (_reply_message && [_reply_message isKindOfClass:[NSString class]] && _reply_message.length > 0) {

        self.label.text = _reply_message;
        [self.label sizeToFit];
        self.label.frame = CGRectMake(15, 15, SCREEN_WIDTH - 30, self.label.bounds.size.height);
        [self setViewHeight:self.label.bounds.size.height + 30];
        
        self.line.frame = CGRectMake(0, self.viewHeight - 0.5, SCREEN_WIDTH, 0.5);
    }
    
}
@end
