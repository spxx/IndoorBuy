//
//  SettementGoodsInfoView.h
//  BMW
//
//  Created by 白琴 on 16/3/12.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettementGoodsInfoView : UIView

@property (nonatomic, copy)void (^showGoodsListButton)(NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame dataSourece:(NSArray *)dataSourceArray;

@end
