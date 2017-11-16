//
//  RechargeRecordViewController.m
//  BMW
//
//  Created by 白琴 on 16/5/26.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "RechargeRecordViewController.h"
#import "RechargeRcordTableViewCell.h"
#import "RechargeDetailViewController.h"

@interface RechargeRecordViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView * _tableView;
    NSInteger _index;
    NSMutableArray * _dataSourceArray;
}

@property (nonatomic, strong)UIView * notHaveDataSource;

@end

@implementation RechargeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isRecharge) {
        self.title = @"充值记录";
    }
    else {
        self.title = @"资金记录";
    }
    
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    
    [self initData];
    [self navigation];
    [self initUserInterface];
    [self setupRefresh];
}

#pragma mark -- 界面 --
- (void)initUserInterface {
    _tableView = [UITableView new];
    _tableView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 65);
    [_tableView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 45 * W_ABCH;
    _tableView.tableFooterView = [[UITableView alloc] init];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView registerClass:[RechargeRcordTableViewCell class] forCellReuseIdentifier:@"baiqin123"];
    _tableView.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self.view addSubview:_tableView];
    [self.view addSubview:self.notHaveDataSource];
    _notHaveDataSource.hidden = YES;
}
/**
 *  无数据的情况
 */
- (UIView *)notHaveDataSource {
    if (!_notHaveDataSource) {
        _notHaveDataSource = [UIView new];
        _notHaveDataSource.viewSize = _tableView.viewSize;
        [_notHaveDataSource align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _tableView.viewY)];
        _notHaveDataSource.backgroundColor = [UIColor whiteColor];
        
        UILabel * alertLabel = [UILabel new];
        alertLabel.viewSize = CGSizeMake(SCREEN_WIDTH, 12);
        alertLabel.font = fontForSize(12);
        alertLabel.textColor = [UIColor colorWithHex:0x878787];
        alertLabel.textAlignment = NSTextAlignmentCenter;
        if (self.isRecharge) {
            alertLabel.text = @"抱歉！您还没相关充值记录";
        }
        else {
            alertLabel.text = @"抱歉！您还没有相关资金记录";
        }
        [alertLabel sizeToFit];
        [alertLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake((SCREEN_WIDTH - alertLabel.viewWidth) / 2 + 10 * W_ABCH, 124 * W_ABCH)];
        [_notHaveDataSource addSubview:alertLabel];
        
        UIImageView * iconImageView = [UIImageView new];
        iconImageView.viewSize = CGSizeMake(13 * W_ABCW, 13 * W_ABCW);
        [iconImageView align:ViewAlignmentTopCenter relativeToPoint:CGPointMake((SCREEN_WIDTH - alertLabel.viewWidth) / 2 - 10 * W_ABCH, 124 * W_ABCW)];
        iconImageView.image = [UIImage imageNamed:@"icon_tixing_ssjg"];
        [_notHaveDataSource addSubview:iconImageView];
        
        
    }
    return _notHaveDataSource;
}
/**
 *  数据的初始化
 */
- (void)initData {
    _index = 1;
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"start":@"1", @"limit":@"20"}];
    if (self.isRecharge) {
        //充值记录
        [dic setObject:@"recharge" forKey:@"type"];
    }
    else {
        //消费记录
        [dic setObject:@"order_pay" forKey:@"type"];
    }
    [self rechargeRecordListWithParameters:dic isRefresh:YES];
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RechargeRcordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"baiqin123" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.dataSourceDic = _dataSourceArray[indexPath.row];
    cell.isRecharge = self.isRecharge;
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RechargeDetailViewController * detailVC = [[RechargeDetailViewController alloc] init];
    detailVC.isRecharge = self.isRecharge;
    detailVC.recordId = _dataSourceArray[indexPath.row][@"lg_id"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark -- 网络请求 --
- (void)rechargeRecordListWithParameters:(NSDictionary *)parameters isRefresh:(BOOL)isRefresh {
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetRechargeList" parameters:parameters callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        [_tableView.header endRefreshing];  //结束下拉刷新
        [_tableView.footer endRefreshing];
        if (isRefresh) {
            _dataSourceArray = [NSMutableArray array];
        }
        if (result == RequestResultSuccess) {
            [_dataSourceArray addObjectsFromArray:object[@"data"]];
            if (_dataSourceArray.count >= 20) {
                _tableView.hidden = NO;
                _tableView.footer.hidden = NO;
                _notHaveDataSource.hidden = YES;
            }
            else if(_dataSourceArray.count == 0){
                _tableView.hidden = YES;
                _tableView.footer.hidden = YES;
                _notHaveDataSource.hidden = NO;
            }
            else{
                _tableView.hidden = NO;
                _tableView.footer.hidden = YES;
                _notHaveDataSource.hidden = YES;
            }
        }
        else if (result == RequestResultEmptyData) {
            if (_dataSourceArray.count == 0) {
                _notHaveDataSource.hidden = NO;
            }
            else {
                _notHaveDataSource.hidden = YES;
                
            }
        }
        else {
            _dataSourceArray = [NSMutableArray array];
        }
        [_tableView reloadData];
    }];
}
#pragma mark -- 上拉加载和下拉刷新
//集成刷新
- (void)setupRefresh
{
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreList)];
    _tableView.legendFooter.hidden = YES;
}
/**
 *  刷新
 */
- (void)refreshView {
    [self initData];
}

/**
 *  上拉加载
 */
- (void)loadMoreList
{
    _index += 20;
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"start":NSNumber(_index), @"limit":@"8"}];
    if (self.isRecharge) {
        //充值记录
        [dic setObject:@"recharge" forKey:@"type"];
    }
    else {
        //消费记录
        [dic setObject:@"order_pay" forKey:@"type"];
    }
    [self rechargeRecordListWithParameters:dic isRefresh:NO];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
