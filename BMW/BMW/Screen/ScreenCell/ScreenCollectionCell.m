//
//  ScreenCollectionCell.m
//  BMW
//
//  Created by gukai on 16/3/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ScreenCollectionCell.h"

@interface ScreenCollectionCell ()

@end
@implementation ScreenCollectionCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        [self initUserInterface];
    }
    return self;
}
-(void)initUserInterface
{
    _button = [[UIButton alloc]initWithFrame:self.bounds];
  
    _button.titleLabel.font = FONT_HEITI_SC(12);
    [_button setTitleColor:[UIColor colorWithHex:0x181818] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor colorWithHex:0xfd5487] forState:UIControlStateSelected];
    _button.layer.cornerRadius = _button.viewHeight/2;
    //加上会闪屏【离屏渲染】
//    _button.layer.masksToBounds = YES;  
    _button.layer.borderWidth = 1;
    _button.layer.borderColor = [UIColor colorWithHex:0xfd5487].CGColor;
    [_button addTarget:self action:@selector(buttonAtion:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_button];
    switch (self.index.section) {
        case 0:
             [_button setTitle:_dataDic[@"name"] forState:UIControlStateNormal];
            break;
        case 1:
            [_button setTitle:_dataDic[@"name"] forState:UIControlStateNormal];
            break;
        case 2:
            [_button setTitle:_dataDic[@"brand_name"] forState:UIControlStateNormal];
            break;
        case 3:
            [_button setTitle:_dataDic[@"gc_name"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
}
-(void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    [self initUserInterface];
    
}
-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    [self initUserInterface];
}
-(void)buttonAtion:(UIButton *)sender
{
    /*
    sender.selected = !sender.selected;
    if (sender.selected) {
        _button.layer.borderColor = [UIColor colorWithHex:0xfd5478].CGColor;
    }
    else{
       _button.layer.borderColor = [UIColor colorWithHex:0xe1e1e1].CGColor;
    }
     */
    if (self.index.section == 0) {
        if (sender == self.currentPriceBtn) {
            self.currentPriceBtn.selected = NO;
            if ([self.delegate respondsToSelector:@selector(screenCollectionCell:index:dataDic:button:)]) {
                [self.delegate screenCollectionCell:self index:self.index dataDic:self.dataDic button:sender];
            }
            return;
        }
        self.currentPriceBtn.selected = NO;
        sender.selected = !sender.selected;
        self.currentPriceBtn = sender;
        
        if ([self.delegate respondsToSelector:@selector(screenCollectionCell:index:dataDic:button:)]) {
            [self.delegate screenCollectionCell:self index:self.index dataDic:self.dataDic button:sender];
        }
    }
    else{
        if ([self.delegate respondsToSelector:@selector(screenCollectionCell:index:dataDic:button:)]) {
            [self.delegate screenCollectionCell:self index:self.index dataDic:self.dataDic button:sender];
        }
    }
    
    
}
@end
