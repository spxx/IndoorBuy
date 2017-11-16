//
//  OilRecordView.m
//  BMW
//
//  Created by LiuP on 2016/12/17.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OilRecordView.h"
#import "LPTableViewManager.h"


@interface OilRecordView ()

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, retain) LPTableViewManager * manager;

@end

@implementation OilRecordView

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
    NSString * cellID = NSStringFromClass(OilRecordCell.class);
    _manager = [[LPTableViewManager alloc]initWithIdentifier:cellID cellBack:^(id cell, id model) {
        OilRecordCell * item = cell;
        item.model = model;

    }];
    _manager.type = CellTypeDefault;

    _tableView = [[UITableView alloc]initWithFrame:self.bounds];
    [_tableView registerClass:[OilRecordCell class] forCellReuseIdentifier:cellID];
    _tableView.rowHeight = 51 * W_ABCW;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = _manager;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:_tableView];
    
    // 分割线顶头
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }

}
#pragma mark -- setter
- (void)setModels:(NSMutableArray *)models
{
    _models = models;
    _manager.models = models;
    [self.tableView reloadData];
}

@end
