//
//  OrderServiceHeadView.m
//  BMW
//
//  Created by gukai on 16/3/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OrderServiceHeadView.h"

@interface OrderServiceHeadView ()
@property(nonatomic,strong)UILabel * serviceNumLable;
@property(nonatomic,strong)UILabel * orderNumLable;
@property(nonatomic,strong)UILabel * stateLable;
@end
@implementation OrderServiceHeadView

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
    _stateLable = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 80 - 15, 15, 80, 13)];
    _stateLable.font = fontForSize(13);
    _stateLable.text = @"正在退款";
    _stateLable.textAlignment = NSTextAlignmentCenter;
    _stateLable.textColor = [UIColor colorWithHex:0x3d3d3d];
    [self addSubview:_stateLable];
    
    _serviceNumLable = [[UILabel alloc]initWithFrame:CGRectMake(15 * W_ABCW, 15, SCREEN_WIDTH - 15 * W_ABCW * 2 - 80 - 15, 12)];
    _serviceNumLable.text = @"服务订单：1254123456789765434";
    _serviceNumLable.textAlignment = NSTextAlignmentLeft;
    _serviceNumLable.textColor = [UIColor colorWithHex:0x7f7f7f];
    _serviceNumLable.font = fontForSize(12);
    [self addSubview:_serviceNumLable];
    
    _orderNumLable = [[UILabel alloc]initWithFrame:CGRectMake(_serviceNumLable.viewX, _serviceNumLable.viewBottomEdge + 10, _serviceNumLable.viewWidth, _serviceNumLable.viewHeight)];
    _orderNumLable.textColor = [UIColor colorWithHex:0x7f7f7f];
    _orderNumLable.font = fontForSize(12);
    _orderNumLable.text = @"订单编号：123456756";
    [self addSubview:_orderNumLable];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, self.viewHeight - 1, self.viewWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self addSubview:line];
    
}
#pragma mark -- set --
-(void)setService_num:(NSString *)service_num
{
    _service_num = service_num;
    _serviceNumLable.text = [NSString stringWithFormat:@"服务订单：%@",_service_num];
}
-(void)setOrder_sn:(NSString *)order_sn
{
    _order_sn = order_sn;
    _orderNumLable.text = [NSString stringWithFormat:@"订单编号：%@",_order_sn];
}
-(void)setState:(NSInteger)state
{
    _state = state;
    switch (_state) {
        case 0:
            _stateLable.text = @"处理中";
            break;
        case 10:
            _stateLable.text = @"已处理";
            break;
        case 20:
            _stateLable.text = @"已取消";
            break;
        default:
            break;
    }
}
@end
