//
//  OrderStateView.m
//  BMW
//
//  Created by 白琴 on 16/3/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OrderStateView.h"

@implementation OrderStateView

- (instancetype)initWithFrame:(CGRect)frame dataSourceDic:(NSDictionary *)dataSourceDic{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        //状态
        UILabel * stateTitleLabel = [UILabel new];
        stateTitleLabel.viewSize = CGSizeMake(100, 20);
        stateTitleLabel.textColor = [UIColor colorWithHex:0x181818];
        stateTitleLabel.font = fontForSize(13);
        stateTitleLabel.text = @"订单状态:";
        [stateTitleLabel sizeToFit];
        [stateTitleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 15)];
        [self addSubview:stateTitleLabel];
        
        UILabel * stateLabel = [UILabel new];
        stateLabel.viewSize = CGSizeMake(100, 20);
        stateLabel.font = fontForSize(13);
        stateLabel.textColor = [UIColor colorWithHex:0xfd5487];
        if ([dataSourceDic[@"order_state"] isEqualToString:@"0"]) {
            stateLabel.text = @"已取消";
        }
        else if ([dataSourceDic[@"order_state"] isEqualToString:@"10"]) {
            stateLabel.text = @"待付款";
        }
        else if ([dataSourceDic[@"order_state"] isEqualToString:@"20"]) {
            stateLabel.text = @"待发货";
        }
        else if ([dataSourceDic[@"order_state"] isEqualToString:@"30"]) {
            stateLabel.text = @"待收货";
        }
        else if ([dataSourceDic[@"order_state"] isEqualToString:@"40"]) {
            if ([dataSourceDic[@"evaluation_state"] isEqualToString:@"1"]) {
                stateLabel.text = @"已评价";
            }
            else {
                stateLabel.text = @"待评价";
            }
        }
        [stateLabel sizeToFit];
        [stateLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(stateTitleLabel.viewRightEdge + 10, 15)];
        [self addSubview:stateLabel];
        
        
        UILabel * orderSNLabel = [UILabel new];
        orderSNLabel.viewSize = CGSizeMake(100, 20);
        orderSNLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        orderSNLabel.font = fontForSize(11);
//        if ([dataSourceDic[@"order_state"] isEqualToString:@"10"]) {
//            //待付款显示【pay_sn】
//            orderSNLabel.text = [NSString stringWithFormat:@"订单编号:  %@", dataSourceDic[@"pay_sn"]];
//        }
//        else {
//            //其他的都显示【order_sn】
//        }
        orderSNLabel.text = [NSString stringWithFormat:@"订单编号:  %@", dataSourceDic[@"order_sn"]];
        [orderSNLabel sizeToFit];
        [orderSNLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, stateTitleLabel.viewBottomEdge + 12)];
        [self addSubview:orderSNLabel];
        
        UILabel * orderAddTimeLabel = [UILabel new];
        orderAddTimeLabel.viewSize = CGSizeMake(100, 20);
        orderAddTimeLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        orderAddTimeLabel.font = fontForSize(11);
        orderAddTimeLabel.text = [NSString stringWithFormat:@"下单时间:  %@", [TYTools getTimeToShowWithTimestamp:dataSourceDic[@"add_time"]]];
        [orderAddTimeLabel sizeToFit];
        [orderAddTimeLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, orderSNLabel.viewBottomEdge + 9)];
        [self addSubview:orderAddTimeLabel];
        
        UIView * line = [UIView new];
        line.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [line align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, orderAddTimeLabel.viewBottomEdge + 15)];
        line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [self addSubview:line];
        
        //收货地址
        UILabel * consigneeLabel = [UILabel new];
        consigneeLabel.viewSize = CGSizeMake(100, 20);
        consigneeLabel.textColor = [UIColor colorWithHex:0x181818];
        consigneeLabel.font = fontForSize(13);
        consigneeLabel.text = [NSString stringWithFormat:@"收货人:  %@", dataSourceDic[@"reciver_name"]];
        [consigneeLabel sizeToFit];
        [consigneeLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, line.viewBottomEdge + 15)];
        [self addSubview:consigneeLabel];
        
        UILabel * consigneeTelLabel = [UILabel new];
        consigneeTelLabel.viewSize = CGSizeMake(100, 20);
        consigneeTelLabel.textColor = [UIColor colorWithHex:0x181818];
        consigneeTelLabel.font = fontForSize(13);
        consigneeTelLabel.text = dataSourceDic[@"address"][@"phone"];
        [consigneeTelLabel sizeToFit];
        [consigneeTelLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(consigneeLabel.viewRightEdge + 34, consigneeLabel.viewY)];
        [self addSubview:consigneeTelLabel];
        
        UILabel * addressLabel = [UILabel new];
        addressLabel.viewSize = CGSizeMake(SCREEN_WIDTH - 30, 20);
        addressLabel.textColor = [UIColor colorWithHex:0x181818];
        NSString * addressString = [dataSourceDic[@"address"][@"address"] stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        addressLabel.text = addressString;
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle};
        addressLabel.attributedText =[[NSAttributedString alloc] initWithString:addressLabel.text attributes:attributes];
        addressLabel.numberOfLines = 0;
        [addressLabel sizeToFit];
        [addressLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, consigneeLabel.viewBottomEdge + 12)];
        [self addSubview:addressLabel];
        
        UIView * line1 = [UIView new];
        line1.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [line1 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, addressLabel.viewBottomEdge + 15)];
        line1.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [self addSubview:line1];
        
        //物流信息
        if (![dataSourceDic[@"wayinfo"] isKindOfClass:[NSNull class]]) {
            UIButton * logisticsInformationButton = [UIButton new];
            logisticsInformationButton.viewSize = CGSizeMake(SCREEN_WIDTH, 40);
            [logisticsInformationButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, line1.viewBottomEdge)];
            [logisticsInformationButton addTarget:self action:@selector(processLogisticsInformationButton) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:logisticsInformationButton];
            
            UIImageView * iconImageView = [UIImageView new];
            iconImageView.viewSize = CGSizeMake(14, 15);
            [iconImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 15)];
            iconImageView.image = [UIImage imageNamed:@"icon_qipao_wdddxq"];
            [logisticsInformationButton addSubview:iconImageView];
            
            UILabel * loginsticsLabel = [UILabel new];
            /**
             *  iconImageView.viewRightEdge 圈圈的右边界
             *  10                          label距离圈圈的距离
             *  6                           右箭头的宽度
             *  15                          箭头右边距
             *  10                          label距离箭头的距离
             */
            loginsticsLabel.viewSize = CGSizeMake(SCREEN_WIDTH - iconImageView.viewRightEdge - 10 - 6 - 15 - 10, 30);
            loginsticsLabel.textColor = [UIColor colorWithHex:0x29b062];
            if (((NSArray *)dataSourceDic[@"wayinfo"][@"data"]).count != 0) {
                loginsticsLabel.text = dataSourceDic[@"wayinfo"][@"data"][0][@"content"];
            }
            else {
                loginsticsLabel.text = @"暂未查询到物流信息";
            }
            
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle};
            loginsticsLabel.attributedText =[[NSAttributedString alloc] initWithString:loginsticsLabel.text attributes:attributes];
            loginsticsLabel.numberOfLines = 0;
            [loginsticsLabel sizeToFit];
            [loginsticsLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(iconImageView.viewRightEdge + 10, 16)];
            [logisticsInformationButton addSubview:loginsticsLabel];
            
            UILabel * timeLabel = [UILabel new];
            timeLabel.viewSize = CGSizeMake(200, 30);
            timeLabel.textColor = [UIColor colorWithHex:0x29b062];
            if (((NSArray *)dataSourceDic[@"wayinfo"][@"data"]).count != 0) {
                timeLabel.text = dataSourceDic[@"wayinfo"][@"data"][0][@"time"];
            }
            else {
                timeLabel.text = dataSourceDic[@"wayinfo"][@"updateTime"];
            }
            
            timeLabel.font = fontForSize(10);
            [timeLabel sizeToFit];
            [timeLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(iconImageView.viewRightEdge + 10, loginsticsLabel.viewBottomEdge + 13)];
            [logisticsInformationButton addSubview:timeLabel];
            
            logisticsInformationButton.viewSize = CGSizeMake(SCREEN_WIDTH, timeLabel.viewBottomEdge + 15);
            
            UIImageView * jianTouImageView = [UIImageView new];
            jianTouImageView.viewSize = CGSizeMake(6, 10);
            [jianTouImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, (logisticsInformationButton.viewHeight - jianTouImageView.viewHeight) / 2)];
            jianTouImageView.image = [UIImage imageNamed:@"icon_xiaojiantou_gwc"];
            [logisticsInformationButton addSubview:jianTouImageView];
            
            //竖着的线
            UIView * line = [UIView new];
            line.viewSize = CGSizeMake(1, (logisticsInformationButton.viewHeight - iconImageView.viewBottomEdge));
            [line align:ViewAlignmentTopCenter relativeToPoint:CGPointMake(15 + iconImageView.viewWidth / 2, iconImageView.viewBottomEdge)];
            line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
            [logisticsInformationButton addSubview:line];
            
            //横着的线
            UIView * line1 = [UIView new];
            line1.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
            [line1 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, logisticsInformationButton.viewHeight)];
            line1.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
            [logisticsInformationButton addSubview:line1];
            
            self.viewSize = CGSizeMake(SCREEN_WIDTH, logisticsInformationButton.viewBottomEdge);
        }
        else {
            self.viewSize = CGSizeMake(SCREEN_WIDTH, line1.viewBottomEdge);
        }
        
    }
    return self;
}

/**
 *  点击查看物流信息
 */
- (void)processLogisticsInformationButton {
    NSLog(@"点击查看物流信息");
    self.showLogisticsInformation();
}

@end
