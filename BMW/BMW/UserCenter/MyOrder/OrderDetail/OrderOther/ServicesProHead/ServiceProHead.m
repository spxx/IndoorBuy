//
//  ServiceProHead.m
//  BMW
//
//  Created by gukai on 16/3/23.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ServiceProHead.h"

@interface ServiceProHead ()
@property(nonatomic,strong)UILabel * serviceNumLabel;
@property(nonatomic,strong)UILabel * stateLabel;
@end
@implementation ServiceProHead
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
    self.backgroundColor = [UIColor whiteColor];
    UILabel * stateLable = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 80 - 15, 0, 80, self.viewHeight)];
    stateLable.font = fontForSize(13);
    stateLable.text = @"正在退款";
    stateLable.textAlignment = NSTextAlignmentRight;
    stateLable.textColor = [UIColor colorWithHex:0x3d3d3d];
    [self addSubview:stateLable];
    self.stateLabel = stateLable;
    
    UILabel * serviceNumlabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, stateLable.viewX - 15, self.viewHeight)];
    serviceNumlabel.font = fontForSize(12);
    serviceNumlabel.textColor = [UIColor colorWithHex:0x3d3d3d];
    serviceNumlabel.textAlignment = NSTextAlignmentLeft;
    serviceNumlabel.text = @"服务单号：1234567894567";
    [self addSubview:serviceNumlabel];
    self.serviceNumLabel = serviceNumlabel;
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, self.viewHeight - 0.5, self.viewWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self addSubview:line];
    
}
-(void)setService_num:(NSString *)service_num
{
    _service_num = service_num;
    _serviceNumLabel.text = [NSString stringWithFormat:@"服务单号：%@",_service_num];
    
}
-(void)setState:(NSInteger)state
{
    _state = state;
    switch (_state) {
        case 0:
            self.stateLabel.text = @"处理中";
            break;
        case 10:
            self.stateLabel.text = @"已处理";
            break;
        case 20:
            self.stateLabel.text = @"已取消";
            break;
        default:
            break;
    }
}
@end
