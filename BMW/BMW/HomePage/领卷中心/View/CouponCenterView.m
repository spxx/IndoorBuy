//
//  CouponCenterView.m
//  BMW
//
//  Created by LiuP on 2016/12/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "CouponCenterView.h"
#import "LPTableViewManager.h"

@interface CouponCenterView ()

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, retain) LPTableViewManager * manager;

@end

@implementation CouponCenterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface
{
    NSString * cellID = NSStringFromClass(CouponViewCell.class);
    WEAK_SELF;
    _manager = [[LPTableViewManager alloc] initWithIdentifier:cellID cellBack:^(id cell, id model) {
        CouponViewCell * item = (CouponViewCell *)cell;
        item.model = model;
        [item setGetCouponBlock:^(CouponModel *model) {
            if ([weakSelf.delegate respondsToSelector:@selector(couponView:didSelectedGetBtnWithModel:)]) {
                [weakSelf.delegate couponView:weakSelf didSelectedGetBtnWithModel:model];
            }
        }];
    }];
    _manager.type = CellTypeDefault;
    
    _tableView = [[UITableView alloc] initWithFrame:self.bounds];
    [_tableView registerClass:[CouponViewCell class] forCellReuseIdentifier:cellID];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = _manager;
    _tableView.rowHeight = (65 + 7) * W_ABCW;
    [self addSubview:_tableView];
}

#pragma mark -- setter
- (void)setModels:(NSMutableArray *)models
{
    _models = models;
    _manager.models = models;
    
    [self.tableView reloadData];
}
@end
