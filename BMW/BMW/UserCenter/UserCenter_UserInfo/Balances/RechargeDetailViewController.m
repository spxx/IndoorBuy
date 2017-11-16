//
//  RechargeDetailViewController.m
//  BMW
//
//  Created by 白琴 on 16/5/26.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "RechargeDetailViewController.h"

@interface RechargeDetailViewController ()<UITableViewDelegate, UITableViewDataSource> {
    UITableView * _tableView;
    NSDictionary * _dataSourceDic;
    NSArray * _titleArray;
    NSArray * _valueArray;
}

@end

@implementation RechargeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isRecharge) {
        self.title = @"充值详情";
    }
    else {
        self.title = @"消费详情";
    }
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self navigation];
    [self initUserInterface];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
}

#pragma mark -- 界面 --
- (void)initData {
    _dataSourceDic = [NSDictionary dictionary];
//    if (self.isRecharge) {
//        _titleArray = @[@"流水号：", @"类型：", @"支出：", @"支付方式：", @"时间：", @"余额：", @"备注："];
//    }
//    else {
//        _titleArray = @[@"流水号：", @"类型：", @"消费：", @"支付方式：", @"时间：", @"余额：", @"备注："];
//    }
    _titleArray = @[@"流水号：", @"类型：", @"支出：", @"支付方式：", @"时间：", @"余额：", @"备注："];
    _valueArray = @[@"", @"", @"", @"", @"", @"", @""];
    [self rechargeRecordDetailWithParameters:@{@"id":self.recordId}];
}

- (void)initUserInterface {
    _tableView = [UITableView new];
    _tableView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 65);
    [_tableView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 40 * W_ABCH;
    _tableView.tableFooterView = [[UITableView alloc] init];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self.view addSubview:_tableView];
}
#pragma mark -- UITableViewDelegate, UITableViewDataSource --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"baiqin123";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.userInteractionEnabled = NO;
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_titleArray[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",_valueArray[indexPath.row]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = [UIColor colorWithHex:0x181818];
    
    return cell;
}
/**
 *  让cell线左对齐
 */
-(void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark -- 网络请求 --
- (void)rechargeRecordDetailWithParameters:(NSDictionary *)parameters {
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetRechargeDetail" parameters:parameters callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result == RequestResultSuccess) {
            _valueArray = @[object[@"data"][@"lg_sn"], object[@"data"][@"lg_type"], [NSString stringWithFormat:@"%@元", object[@"data"][@"lg_av_amount"]], object[@"data"][@"lg_pay_way"], [TYTools getTimeToShowWithTimestamp:object[@"data"][@"lg_add_time"]], object[@"data"][@"totalFee"], object[@"data"][@"lg_desc"]];
            if (_tableView) {
                [_tableView reloadData];
            }
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
