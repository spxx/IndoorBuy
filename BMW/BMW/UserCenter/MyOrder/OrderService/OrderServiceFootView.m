//
//  OrderServiceFootView.m
//  BMW
//
//  Created by gukai on 16/3/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OrderServiceFootView.h"

@interface OrderServiceFootView ()
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UIButton * applyBtn;
@property(nonatomic,strong)UIButton * readProBtn;
@end
@implementation OrderServiceFootView
- (instancetype)initWithFrame:(CGRect)frame
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
    UIButton * applyBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 70, 9, 70, 26)];
    [applyBtn setTitle:@"查询进度" forState:UIControlStateNormal];
    [applyBtn setTitleColor:[UIColor colorWithHex:0x3d3d3d] forState:UIControlStateNormal];
    applyBtn.titleLabel.font = fontForSize(12);
    applyBtn.layer.borderWidth = 0.5;
    applyBtn.layer.borderColor = [UIColor colorWithHex:0x69696b].CGColor;
    applyBtn.layer.cornerRadius = 3;
    applyBtn.layer.masksToBounds = YES;
    [applyBtn addTarget:self action:@selector(applyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:applyBtn];
    self.applyBtn = applyBtn;
    
    /*
    UIButton * readProBtn = [[UIButton alloc]initWithFrame:CGRectMake(applyBtn.viewX - applyBtn.viewWidth - 4 , applyBtn.viewY, applyBtn.viewWidth, applyBtn.viewHeight)];
    [readProBtn setTitle:@"查询进度" forState:UIControlStateNormal];
    [readProBtn setTitleColor:[UIColor colorWithHex:0x3d3d3d] forState:UIControlStateNormal];
    readProBtn.titleLabel.font = fontForSize(12);
    readProBtn.layer.borderWidth = 0.5;
    readProBtn.layer.borderColor = [UIColor colorWithHex:0x69696b].CGColor;
    readProBtn.layer.cornerRadius = 3;
    readProBtn.layer.masksToBounds = YES;
    readProBtn.hidden = YES;
    [applyBtn addTarget:self action:@selector(readProBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:readProBtn];
    self.readProBtn = readProBtn;
     */
    
    UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 15  - 10 - 70 - 15 , 44)];
    timeLabel.text = @"申请时间：2016-03-15 15:54:30";
    timeLabel.font =fontForSize(12);
    timeLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    
    UIView * spaceView = [[UIView alloc]initWithFrame:CGRectMake(0, self.viewHeight - 10, SCREEN_WIDTH, 10)];
    spaceView.backgroundColor = [UIColor colorWithHex:0xf1f1ed];
    [self addSubview:spaceView];
}
#pragma mark -- set --
-(void)setAdd_time:(NSString *)add_time
{
    _add_time = add_time;
    self.timeLabel.text = [NSString stringWithFormat:@"申请时间：%@",[TYTools getTimeToShowWithTimestamp:add_time]];
}
-(void)setState:(NSInteger)state
{
    _state = state;
    switch (_state) {
        case 0:
            self.applyBtn.hidden = NO;
            [self.applyBtn setTitle:@"取消申请" forState:UIControlStateNormal];
            [self.applyBtn setTitleColor:[UIColor colorWithHex:0x3d3d3d] forState:UIControlStateNormal];
            self.applyBtn.layer.borderColor = [UIColor colorWithHex:0x69696b].CGColor;
            //self.readProBtn.hidden= NO;
            break;
            
        case 10:
            self.applyBtn.hidden = NO;
            [self.applyBtn setTitle:@"进度查询" forState:UIControlStateNormal];
            [self.applyBtn setTitleColor:[UIColor colorWithHex:0x3d3d3d] forState:UIControlStateNormal];
            self.applyBtn.layer.borderColor = [UIColor colorWithHex:0x69696b].CGColor;
            //self.readProBtn.hidden= YES;
             break;
            
        case 20:
            self.applyBtn.hidden = YES;
            [self.applyBtn setTitle:@"已取消" forState:UIControlStateNormal];
            [self.applyBtn setTitleColor:[UIColor colorWithHex:0xfd5487] forState:UIControlStateNormal];
            self.applyBtn.layer.borderColor = [UIColor colorWithHex:0xfd5487].CGColor;
            //self.readProBtn.hidden= YES;
            break;
            
    }
}
-(void)setSection:(NSInteger)section
{
    _section = section;
}
#pragma mark -- Action --
-(void)applyBtnAction:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"取消申请"]) {
        if ([self.delegate respondsToSelector:@selector(OrderServiceFootViewDidClickCancelApply:section:)]) {
            [self.delegate OrderServiceFootViewDidClickCancelApply:sender section:self.section];
        }
    }
    else if ([sender.titleLabel.text isEqualToString:@"已取消"]){
//        if ([self.delegate respondsToSelector:@selector(OrderServiceFootViewDidClickDeleteServiceBtn:section:)]) {
//            [self.delegate OrderServiceFootViewDidClickDeleteServiceBtn:sender section:self.section];
//        }
        if ([self.delegate respondsToSelector:@selector(OrderServiceFootViewDidClickCancelApplyFollowUpProgress:section:)]) {
            [self.delegate OrderServiceFootViewDidClickCancelApplyFollowUpProgress:sender section:self.section];
        }
    }
    else{
        if ([self.delegate respondsToSelector:@selector(OrderServiceFootViewDidClickCancelApplyFollowUpProgress:section:)]) {
            [self.delegate OrderServiceFootViewDidClickCancelApplyFollowUpProgress:sender section:self.section];
        }
        
    }
}
/*
-(void)readProBtnAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(OrderServiceFootViewDidClickCancelApplyFollowUpProgress:section:)]) {
        [self.delegate OrderServiceFootViewDidClickCancelApplyFollowUpProgress:sender section:self.section];
    }
}
 */
@end
