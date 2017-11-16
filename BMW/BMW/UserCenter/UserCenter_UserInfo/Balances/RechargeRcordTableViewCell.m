//
//  RechargeRcordTableViewCell.m
//  BMW
//
//  Created by 白琴 on 16/5/26.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "RechargeRcordTableViewCell.h"

@interface RechargeRcordTableViewCell () {
    NSDictionary * _dataSource;
    UILabel * _operationTypeLabel;          //操作类型【如：充值】
    UILabel * _rechargeTypeLabel;           //支付方式【如：支付宝】
    UILabel * _rechargeTimeLabel;           //操作时间
    UILabel * _rechargeAmountLabel;         //充值金额
}

@end

@implementation RechargeRcordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadViews];
    }
    return self;
}

- (void)loadViews {
    _operationTypeLabel = [UILabel new];
    _operationTypeLabel.viewSize = CGSizeMake(100 * W_ABCH, 30 * W_ABCH);
    _operationTypeLabel.font = [UIFont systemFontOfSize:13];
    _operationTypeLabel.textColor = [UIColor colorWithHex:0x18181818];
    _operationTypeLabel.text = @"充值";
    [_operationTypeLabel sizeToFit];
    [_operationTypeLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, 10 * W_ABCH)];
    [self addSubview:_operationTypeLabel];
    
    _rechargeTypeLabel = [UILabel new];
    _rechargeTypeLabel.viewSize = CGSizeMake(100 * W_ABCH, 30 * W_ABCH);
    _rechargeTypeLabel.font = [UIFont systemFontOfSize:11];
    _rechargeTypeLabel.textColor = [UIColor colorWithHex:0x18181818];
    _rechargeTypeLabel.text = @"支付宝";
    [_rechargeTypeLabel sizeToFit];
    [_rechargeTypeLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, _operationTypeLabel.viewBottomEdge + 5 * W_ABCH)];
    [self addSubview:_rechargeTypeLabel];
    
    _rechargeTimeLabel = [UILabel new];
    _rechargeTimeLabel.viewSize = CGSizeMake(100 * W_ABCH, 30 * W_ABCH);
    _rechargeTimeLabel.font = [UIFont systemFontOfSize:10];
    _rechargeTimeLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    _rechargeTimeLabel.text = @"2016-05-24";
    [_rechargeTimeLabel sizeToFit];
    [_rechargeTimeLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15 * W_ABCH, 10 * W_ABCH)];
    [self addSubview:_rechargeTimeLabel];
    
    _rechargeAmountLabel = [UILabel new];
    _rechargeAmountLabel.viewSize = CGSizeMake(100 * W_ABCH, 30 * W_ABCH);
    _rechargeAmountLabel.font = [UIFont systemFontOfSize:14];
    _rechargeAmountLabel.textColor = [UIColor colorWithHex:0x181818];
    _rechargeAmountLabel.text = @"-200.00";
    [_rechargeAmountLabel sizeToFit];
    [_rechargeAmountLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15 * W_ABCH, _rechargeTimeLabel.viewBottomEdge + 5 * W_ABCH)];
    [self addSubview:_rechargeAmountLabel];
}

- (void)setDataSourceDic:(NSDictionary *)dataSourceDic {
    _dataSource = dataSourceDic;
    _operationTypeLabel.text = [dataSourceDic objectForKeyNotNull:@"lg_type"];
    [_operationTypeLabel sizeToFit];
    [_operationTypeLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, 10 * W_ABCH)];
    
    _rechargeTypeLabel.text = [dataSourceDic objectForKeyNotNull:@"lg_pay_way"];
    [_rechargeTypeLabel sizeToFit];
    [_rechargeTypeLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, _operationTypeLabel.viewBottomEdge + 5 * W_ABCH)];
    
    _rechargeTimeLabel.text = [[TYTools getTimeToShowWithTimestamp:[dataSourceDic objectForKeyNotNull:@"lg_add_time"]] substringToIndex:10];
    [_rechargeTimeLabel sizeToFit];
    [_rechargeTimeLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15 * W_ABCH, 10 * W_ABCH)];
    
    _rechargeAmountLabel.text = [NSString stringWithFormat:@"-%@", [dataSourceDic objectForKeyNotNull:@"lg_av_amount"]];
    [_rechargeAmountLabel sizeToFit];
    [_rechargeAmountLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15 * W_ABCH, _rechargeTimeLabel.viewBottomEdge + 5 * W_ABCH)];
}

- (void)setIsRecharge:(BOOL)isRecharge {
    if (isRecharge) {
        //充值记录
//        _operationTypeLabel.text = @"充值";
        _rechargeAmountLabel.text = [NSString stringWithFormat:@"+%@", [_dataSource objectForKeyNotNull:@"lg_av_amount"]];
    }
    else{
        //资金记录
//        _operationTypeLabel.text = @"消费";
        _rechargeAmountLabel.text = [NSString stringWithFormat:@"-%@", [_dataSource objectForKeyNotNull:@"lg_av_amount"]];
    }
//    [_operationTypeLabel sizeToFit];
//    [_operationTypeLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, 10 * W_ABCH)];
//    [_rechargeTypeLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, _operationTypeLabel.viewBottomEdge + 5 * W_ABCH)];
    
    [_rechargeAmountLabel sizeToFit];
    [_rechargeAmountLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15 * W_ABCH, _rechargeTimeLabel.viewBottomEdge + 5 * W_ABCH)];
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
