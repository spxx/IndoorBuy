//
//  MyorderTableViewCell.m
//  BMW
//
//  Created by rr on 16/3/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "MyorderTableViewCell.h"
#import "MZTimerLabel.h"

@interface MyorderTableViewCell () <MZTimerLabelDelegate>  {
    UILabel * _timer_show;
    MZTimerLabel * _timerCutDown;
}

@property(nonatomic, strong)UIImageView *goodsImage;

@property(nonatomic, strong)UILabel *goodsPrice;

@property(nonatomic, strong)UILabel *goods_VipPrice;

@property(nonatomic, strong)UILabel *goodsLabel;

@property(nonatomic, strong)UILabel *goodsS;

@property(nonatomic, strong)UILabel *goodsNum;
@end

@implementation MyorderTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)loadViews{
    self.viewHeight = 100;
    _goodsImage = [[UIImageView alloc] initWithFrame:CGRectMake(27, 10, 79, 79)];
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_goodsDic[@"goods_image"]]] placeholderImage:nil];
    [self.contentView addSubview:_goodsImage];
    
    _goodsLabel = [[UILabel alloc] initWithFrame:CGRectMake(_goodsImage.viewRightEdge+12, 10, SCREEN_WIDTH-150, 12)];
    _goodsLabel.text = [NSString stringWithFormat:@"%@",_goodsDic[@"goods_name"]];
    _goodsLabel.numberOfLines = 2;
    _goodsLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
    _goodsLabel.font = fontForSize(12);
    [_goodsLabel sizeToFit];
    _goodsLabel.viewSize = CGSizeMake(SCREEN_WIDTH-150, _goodsLabel.viewHeight);
    [self.contentView addSubview:_goodsLabel];
    
    _goodsS = [UILabel new];
    _goodsS.viewSize = CGSizeMake(_goodsLabel.viewWidth, 10);
    [_goodsS align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(_goodsImage.viewRightEdge+12, _goodsImage.viewY+_goodsImage.viewHeight/2)];
    _goodsS.textColor = [UIColor colorWithHex:0x7f7f7f];
    _goodsS.font = fontForSize(10);
    [self.contentView addSubview:_goodsS];
    
    _goodsPrice = [[UILabel alloc] initWithFrame:CGRectMake(_goodsImage.viewRightEdge+12, self.viewHeight-22, 100, 12)];
    _goodsPrice.textColor = [UIColor colorWithHex:0xfd5487];
    _goodsPrice.font = fontBoldForSize(12);
    [self.contentView addSubview:_goodsPrice];
    
    _goods_VipPrice = [UILabel new];
    _goods_VipPrice.viewSize = CGSizeMake(100, 9);
    [_goods_VipPrice align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(_goodsPrice.viewRightEdge+5, _goodsPrice.viewY+_goodsPrice.viewHeight/2)];
    _goods_VipPrice.textColor = [UIColor colorWithHex:0x7f7f7f];
    _goods_VipPrice.font = fontForSize(9);
    [self.contentView addSubview:_goods_VipPrice];
    
    _goodsNum = [UILabel new];
    _goodsNum.viewSize = CGSizeMake(50, 12);
    _goodsNum.textColor = [UIColor colorWithHex:0x3d3d3d];
    _goodsNum.font = fontForSize(12);
    [_goodsNum align:ViewAlignmentBottomRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15, 85)];
    [self.contentView addSubview:_goodsNum];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewHeight-0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self.contentView addSubview:line];
}


-(void)setGoodsDic:(NSDictionary *)goodsDic{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    _goodsDic = goodsDic;
    [self loadViews];
    if ([_goodsDic[@"goods_spec"] isKindOfClass:[NSDictionary class]]) {
        NSMutableString *goodsguige = [NSMutableString string];
        NSArray *allkeys =[_goodsDic[@"goods_spec"] allKeys];
        if (allkeys.count==1) {
            _goodsS.text = [[_goodsDic[@"goods_spec"] allValues] firstObject];
        }else{
            [allkeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx==allkeys.count-1) {
                    [goodsguige insertString:[NSString stringWithFormat:@"%@,",_goodsDic[@"goods_spec"][obj]] atIndex:0];
                }else{
                    [goodsguige insertString:[NSString stringWithFormat:@"%@",_goodsDic[@"goods_spec"][obj]] atIndex:0];
                }
            }];
            _goodsS.text = [NSString stringWithFormat:@"%@",goodsguige];
        }
    }else{
        if ([[_goodsDic objectForKeyNotNull:@"goods_spec"] isEqualToString:@"(null)"]||![_goodsDic objectForKeyNotNull:@"goods_spec"]) {
            _goodsS.text =@"";
        }else{
            _goodsS.text = [NSString stringWithFormat:@"%@",[_goodsDic objectForKeyNotNull:@"goods_spec"]];
        }
    }
    _goodsPrice.text = [NSString stringWithFormat:@"￥ %@",_goodsDic[@"goods_price"]];
    [_goodsPrice sizeToFit];
    _goodsPrice.viewSize = CGSizeMake(_goodsPrice.viewWidth, 12);
    _goods_VipPrice.text = [NSString stringWithFormat:@"麦咖专享返现￥ %.2f",[_goodsDic[@"back_total"] floatValue]];//([_goodsDic[@"goods_price"] floatValue] - [_goodsDic[@"goods_vip_price"] floatValue])
    [_goods_VipPrice sizeToFit];
    _goods_VipPrice.viewSize = CGSizeMake(_goods_VipPrice.viewWidth, 9);
    [_goods_VipPrice align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(_goodsPrice.viewRightEdge+5, _goodsPrice.viewY+_goodsPrice.viewHeight/2)];
    _goodsNum.text = [NSString stringWithFormat:@"x%@",_goodsDic[@"goods_num"]];
    [_goodsNum sizeToFit];
    _goodsNum.viewSize = CGSizeMake(_goodsNum.viewWidth, 12);
    [_goodsNum align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15, self.viewHeight-22)];
    
    // 赠品判断
    NSString * goods_type = [_goodsDic objectForKeyNotNull:@"goods_type"];
    if (goods_type.integerValue == 5) {
        _goodsPrice.text = @"￥ 0.00";
        [_goodsPrice sizeToFit];
        _goodsPrice.viewSize = CGSizeMake(_goodsPrice.viewWidth, 12);
        _goods_VipPrice.text = @"￥ 0.00";
        [_goods_VipPrice sizeToFit];
        _goods_VipPrice.viewSize = CGSizeMake(_goods_VipPrice.viewWidth, 9);
    }
}

-(void)setType:(NSString *)type{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    _type = type;
}

-(void)setLastDic:(NSDictionary *)lastDic{
    UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 60, 44)];
    payLabel.text = @"应付金额：";
    payLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
    payLabel.font = fontForSize(12);
    [payLabel sizeToFit];
    payLabel.viewHeight = 44;
    [self.contentView addSubview:payLabel];
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(payLabel.viewRightEdge+5, 0, 200, 44)];
    countLabel.text = [NSString stringWithFormat:@"￥%@",lastDic[@"order_amount"]];
    countLabel.textColor = [UIColor colorWithHex:0xfd5487];
    countLabel.font = fontForSize(13);
    [countLabel sizeToFit];
    countLabel.viewSize = CGSizeMake(countLabel.viewWidth, 44);
    [self.contentView addSubview:countLabel];
    
    switch ([_type integerValue]) {
        case 0:{
            
            UIButton * BuyAgain = [UIButton new];
            BuyAgain.viewSize = CGSizeMake(70, 26);
            BuyAgain.layer.borderWidth = 0.5;
            BuyAgain.layer.cornerRadius =3;
            BuyAgain.layer.masksToBounds = YES;
            BuyAgain.tag = 99;
            BuyAgain.layer.borderColor = [UIColor colorWithHex:0xfd5487].CGColor;
            [BuyAgain align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15, 22)];
            [BuyAgain setTitle:@"重新购买" forState:UIControlStateNormal];
            [BuyAgain addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
            [BuyAgain setTitleColor:[UIColor colorWithHex:0xfd5487] forState:UIControlStateNormal];
            BuyAgain.titleLabel.font = fontForSize(12);
            [self.contentView addSubview:BuyAgain];
            
            UIButton *deletB = [UIButton new];
            deletB.viewSize = CGSizeMake(70, 26);
            deletB.layer.borderWidth = 0.5;
            deletB.layer.cornerRadius=3;
            deletB.layer.masksToBounds = YES;
            deletB.tag = 98;
            deletB.layer.borderColor = [UIColor colorWithHex:0x69696b].CGColor;
            [deletB align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(BuyAgain.viewX-5, 22)];
            [deletB setTitle:@"删除订单" forState:UIControlStateNormal];
            [deletB addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
            [deletB setTitleColor:[UIColor colorWithHex:0x3d3d3d] forState:UIControlStateNormal];
            deletB.titleLabel.font = fontForSize(12);
            [self.contentView addSubview:deletB];
        }
            break;
        case 10:{
            UIButton * BuyAgain = [UIButton new];
            BuyAgain.tag = 36;
            BuyAgain.viewSize = CGSizeMake(100, 26);
            BuyAgain.layer.borderWidth = 0.5;
            BuyAgain.layer.cornerRadius = 6;
            BuyAgain.layer.masksToBounds = YES;
            BuyAgain.layer.borderColor = [UIColor colorWithHex:0xfd5487].CGColor;
            [BuyAgain align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15, 22)];
            [BuyAgain addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
            //如果是待付款
            NSInteger time = [lastDic[@"ServerTime"] integerValue] - [lastDic[@"add_time"] integerValue];
            //24小时 == 86400秒
            if (time < 86400) {
                [BuyAgain setTitle:nil forState:UIControlStateNormal];
                
                //UILabel设置成和UIButton一样的尺寸和位置
                _timer_show = [UILabel new];
                _timer_show.viewSize = CGSizeMake(100, 26);
                _timer_show.text = @"支付(00:00:00)";
                _timer_show.font = fontForSize(12);
                [_timer_show sizeToFit];
                _timer_show.viewSize = CGSizeMake(_timer_show.viewWidth + 18 * W_ABCW, 26);
                [_timer_show align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
                _timer_show.text = nil;
                BuyAgain.viewSize = _timer_show.viewSize;
                //把timer_show添加到按钮上
                [BuyAgain addSubview:_timer_show];
               
                //创建MZTimerLabel类的对象_timerCutDown
                _timerCutDown = [[MZTimerLabel alloc] initWithLabel:_timer_show andTimerType:MZTimerLabelTypeTimer];
                //倒计时时间60s
                [_timerCutDown setCountDownTime:86400 - time];
                //倒计时格式,也可以是@"HH:mm:ss"
                _timerCutDown.timeFormat = @"支付(HH:mm:ss)";
                _timerCutDown.timeLabel.backgroundColor = [UIColor colorWithHex:0xfd5478];
                _timerCutDown.layer.cornerRadius = 6;
                _timerCutDown.layer.masksToBounds = YES;
                _timerCutDown.timeLabel.layer.cornerRadius = 6;
                _timerCutDown.timeLabel.layer.masksToBounds = YES;
                _timerCutDown.timeLabel.textColor = [UIColor whiteColor];//倒计时字体颜色
                _timerCutDown.timeLabel.font = [UIFont systemFontOfSize:12];//倒计时字体大小
                _timerCutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//居中
                //设置代理，以便后面倒计时结束时调用代理
                _timerCutDown.delegate = self;
                //开始计时
                [_timerCutDown start];
                
            }
            BuyAgain.titleLabel.font = fontForSize(12);
            [self.contentView addSubview:BuyAgain];
            
            UIButton *deletB = [UIButton new];
            deletB.tag =11;
            deletB.viewSize = CGSizeMake(35, 26);
            deletB.layer.borderWidth = 0.5;
            deletB.layer.cornerRadius =3;
            deletB.layer.masksToBounds = YES;
            deletB.layer.borderColor = [UIColor colorWithHex:0x69696b].CGColor;
            [deletB align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(BuyAgain.viewX-5, 22)];
            [deletB setTitle:@"取消" forState:UIControlStateNormal];
            [deletB setTitleColor:[UIColor colorWithHex:0x3d3d3d] forState:UIControlStateNormal];
            deletB.titleLabel.font = fontForSize(12);
            deletB.viewHeight = 26;
            [deletB addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:deletB];
        }
            break;
        case 20:{
            UIButton * BuyAgain = [UIButton new];
            BuyAgain.tag =21;
            BuyAgain.viewSize = CGSizeMake(70, 26);
            BuyAgain.layer.borderWidth = 0.5;
            BuyAgain.layer.cornerRadius =3;
            BuyAgain.layer.masksToBounds = YES;
            BuyAgain.layer.borderColor = [UIColor colorWithHex:0xfd5487].CGColor;
            [BuyAgain align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15, 22)];
            [BuyAgain setTitle:@"提醒发货" forState:UIControlStateNormal];
            [BuyAgain setTitleColor:[UIColor colorWithHex:0xfd5487] forState:UIControlStateNormal];
            [BuyAgain addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
            BuyAgain.titleLabel.font = fontForSize(12);
            [self.contentView addSubview:BuyAgain];
            
            UIButton *deletB = [UIButton new];
            deletB.tag = 20;
            deletB.viewSize = CGSizeMake(70, 26);
            deletB.layer.borderWidth = 0.5;
            deletB.layer.cornerRadius =3;
            deletB.layer.masksToBounds = YES;
            deletB.layer.borderColor = [UIColor colorWithHex:0x69696b].CGColor;
            [deletB align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(BuyAgain.viewX-5, 22)];
            [deletB setTitle:@"申请退款" forState:UIControlStateNormal];
            [deletB setTitleColor:[UIColor colorWithHex:0x3d3d3d] forState:UIControlStateNormal];
            [deletB addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
            deletB.titleLabel.font = fontForSize(12);
            [self.contentView addSubview:deletB];
        }
            break;
        case 30:{
            UIButton * BuyAgain = [UIButton new];
            BuyAgain.tag = 30;
            BuyAgain.viewSize = CGSizeMake(70, 26);
            BuyAgain.layer.borderWidth = 0.5;
            BuyAgain.layer.cornerRadius =3;
            BuyAgain.layer.masksToBounds = YES;
            BuyAgain.layer.borderColor = [UIColor colorWithHex:0xfd5487].CGColor;
            [BuyAgain align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15, 22)];
            [BuyAgain setTitle:@"确认收货" forState:UIControlStateNormal];
            [BuyAgain addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
            [BuyAgain setTitleColor:[UIColor colorWithHex:0xfd5487] forState:UIControlStateNormal];
            BuyAgain.titleLabel.font = fontForSize(12);
            [self.contentView addSubview:BuyAgain];
            
            UIButton *deletB = [UIButton new];
            deletB.tag = 35;
            deletB.viewSize = CGSizeMake(70, 26);
            deletB.layer.borderWidth = 0.5;
            deletB.layer.cornerRadius =3;
            deletB.layer.masksToBounds = YES;
            deletB.layer.borderColor = [UIColor colorWithHex:0x69696b].CGColor;
            [deletB align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(BuyAgain.viewX-5, 22)];
            [deletB setTitle:@"查看物流" forState:UIControlStateNormal];
            [deletB addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
            [deletB setTitleColor:[UIColor colorWithHex:0x3d3d3d] forState:UIControlStateNormal];
            deletB.titleLabel.font = fontForSize(12);
            [self.contentView addSubview:deletB];
        }
            break;
        case 40:{
            UIButton * BuyAgain = [UIButton new];
            BuyAgain.viewSize = CGSizeMake(70, 26);
            BuyAgain.layer.borderWidth = 0.5;
            BuyAgain.layer.cornerRadius =3;
            BuyAgain.layer.masksToBounds = YES;
            BuyAgain.tag = 40;
            BuyAgain.layer.borderColor = [UIColor colorWithHex:0xfd5487].CGColor;
            [BuyAgain align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15, 22)];
            [BuyAgain setTitle:@"再次购买" forState:UIControlStateNormal];
            [BuyAgain setTitleColor:[UIColor colorWithHex:0xfd5487] forState:UIControlStateNormal];
            [BuyAgain addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
            BuyAgain.titleLabel.font = fontForSize(12);
            [self.contentView addSubview:BuyAgain];
            
            UIButton *deletB = [UIButton new];
            deletB.viewSize = CGSizeMake(70, 26);
            deletB.layer.borderWidth = 0.5;
            deletB.layer.cornerRadius =3;
            deletB.layer.masksToBounds = YES;
            deletB.layer.borderColor = [UIColor colorWithHex:0x69696b].CGColor;
            [deletB align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(BuyAgain.viewX-5, 22)];
            [deletB setTitleColor:[UIColor colorWithHex:0x3d3d3d] forState:UIControlStateNormal];
            deletB.titleLabel.font = fontForSize(12);
            [deletB addTarget:self action:@selector(deleBAction:) forControlEvents:UIControlEventTouchUpInside];
            [deletB setTitle:@"评价" forState:UIControlStateNormal];
            deletB.userInteractionEnabled = YES;
            if ([lastDic[@"evaluation_state"] boolValue]) {
                [deletB setTitle:@"已评价" forState:UIControlStateNormal];
                deletB.userInteractionEnabled = NO;
            }else{
                [self.contentView addSubview:deletB];
            }
        }
            break;
        default:
            break;
    }
    
    UIView *bottomV  = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 10)];
    bottomV.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self.contentView addSubview:bottomV];
}

-(void)buttonPress:(UIButton *)sender{
    
    switch (sender.tag) {
        case 99:{
            //重新购买
            self.repeatBuy();
        }
            break;
        case 98:{
            //删除订单
            self.deleteOrder();
        }
            break;
//        case 10:{
//            
//        }
//            break;
        case 11:{
            self.cancleOrder();
        }
            break;
        case 20:{
           self.crectaServiceO();
        }
            break;
        case 21:{
            self.remindSend();
        }
            break;
        case 30:{
            self.Confirm();
        }
            break;
        case 35:{
            //物流信息
            self.wayInfo();
        }
            break;
        case 36:{
            //支付跳转
            self.paymentButton();
        }
            break;
        case 40:{
            //再次购买
            self.repeatBuy();
        }
            break;
        default:
            break;
    }
     
}

#pragma mark -- Action --
-(void)deleBAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(MyorderTableViewCellDidClickEvaluateBtn:index:dataDic:)]) {
        [self.delegate MyorderTableViewCellDidClickEvaluateBtn:sender index:self.index dataDic:self.goodsDic];
    }
    
}
#pragma mark -- MZTimerLabelDelegate
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    [_timerCutDown pause];              //暂停倒计时
    [_timer_show removeFromSuperview];//移除倒计时模块
    self.countdownOver();
    
}

@end
