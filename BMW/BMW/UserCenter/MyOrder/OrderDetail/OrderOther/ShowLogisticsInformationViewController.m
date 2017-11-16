//
//  ShowLogisticsInformationViewController.m
//  BMW
//
//  Created by 白琴 on 16/3/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//
/**
 *  查看物流信息界面
 */
#import "ShowLogisticsInformationViewController.h"
#import "LogisticsCell/LogisticsCell.h"

@interface ShowLogisticsInformationViewController ()<UITableViewDataSource, UITableViewDelegate> {
    UITableView * _tableView;
    UILabel * _companyNameLabel;
    UILabel * _waybillNumberLabel;
    UILabel * _orderAddTimeLabel;
    UILabel * _orderSNLabel;
}
/**
 *  物流信息
 */
@property (nonatomic, strong)NSDictionary * dataSourceDic;
/**
 *  顶部的状态View
 */
@property (nonatomic, strong)UIView * stateView;
/**
 *  没有数据的界面
 */
@property (nonatomic, strong)UIView * notHaveDataSource;
/**
 *  没有物流流程的界面
 */
@property (nonatomic, strong)UIView * notHaveLogisticsInfo;

@end

@implementation ShowLogisticsInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    self.title = @"查看物流";
    
//    _dataSourceDic = [NSDictionary dictionary];
    
    [self getWayInfoRequest];
    [self navigation];
    [self initUserInterface];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_dataSourceDic) {
        [self.HUD show:YES];
    }
}
#pragma mark -- 界面
/**
 *  基本界面
 */
- (void)initUserInterface {
    [self.view addSubview:self.stateView];
    _tableView = [UITableView new];
    _tableView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - _stateView.viewBottomEdge - 10 - 64);
    [_tableView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _stateView.viewBottomEdge + 10)];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = COLOR_BACKGRONDCOLOR;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UITableView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[LogisticsCell class] forCellReuseIdentifier:@"baiqin123"];
    [self.view addSubview:_tableView];
    
    [self.view addSubview:self.notHaveDataSource];
    [self.view addSubview:self.notHaveLogisticsInfo];
    _notHaveDataSource.hidden = YES;
    _stateView.hidden = YES;
    _notHaveLogisticsInfo.hidden = YES;
}
/**
 *  无数据的情况
 */
- (UIView *)notHaveDataSource {
    if (!_notHaveDataSource) {
        _notHaveDataSource = [UIView new];
        _notHaveDataSource.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        [_notHaveDataSource align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
        _notHaveDataSource.backgroundColor = [UIColor whiteColor];
        
        UIImageView * iconImageView = [UIImageView new];
        iconImageView.viewSize = CGSizeMake(131 * W_ABCW, 115 * W_ABCW);
        [iconImageView align:ViewAlignmentTopCenter relativeToPoint:CGPointMake(SCREEN_WIDTH / 2, 70 * W_ABCW)];
        iconImageView.image = [UIImage imageNamed:@"icon_wuliu_ckwl"];
        [_notHaveDataSource addSubview:iconImageView];
        
        UILabel * alertLabel = [UILabel new];
        alertLabel.viewSize = CGSizeMake(SCREEN_WIDTH, 12);
        [alertLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, iconImageView.viewBottomEdge + 24 * W_ABCW)];
        alertLabel.font = fontForSize(12);
        alertLabel.textColor = [UIColor colorWithHex:0x878787];
        alertLabel.textAlignment = NSTextAlignmentCenter;
        alertLabel.text = @"没有物流信息";
        [_notHaveDataSource addSubview:alertLabel];
    }
    return _notHaveDataSource;
}

/**
 *  无物流流程的情况
 */
- (UIView *)notHaveLogisticsInfo {
    if (!_notHaveLogisticsInfo) {
        _notHaveLogisticsInfo = [UIView new];
        _notHaveLogisticsInfo.viewSize = _tableView.viewSize;
        [_notHaveLogisticsInfo align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _tableView.viewY)];
        _notHaveLogisticsInfo.backgroundColor = COLOR_BACKGRONDCOLOR;
        
        UIImageView * iconImageView = [UIImageView new];
        iconImageView.viewSize = CGSizeMake(13 * W_ABCW, 13 * W_ABCW);
        [iconImageView align:ViewAlignmentTopCenter relativeToPoint:CGPointMake(SCREEN_WIDTH / 2, 30 * W_ABCW)];
        iconImageView.image = [UIImage imageNamed:@"icon_tixing_ssjg"];
        [_notHaveLogisticsInfo addSubview:iconImageView];
        
        UILabel * alertLabel = [UILabel new];
        alertLabel.viewSize = CGSizeMake(SCREEN_WIDTH, 12);
        [alertLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, iconImageView.viewBottomEdge + 24 * W_ABCW)];
        alertLabel.font = fontForSize(12);
        alertLabel.textColor = [UIColor colorWithHex:0x878787];
        alertLabel.textAlignment = NSTextAlignmentCenter;
        alertLabel.text = @"暂未查询到物流信息";
        [_notHaveLogisticsInfo addSubview:alertLabel];
    }
    return _notHaveLogisticsInfo;
}
/**
 *  顶部的状态View
 */
- (UIView *)stateView {
    if (!_stateView) {
        _stateView = [UIView new];
        _stateView.viewSize = CGSizeMake(SCREEN_WIDTH, 104 * W_ABCW);
        [_stateView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
        _stateView.backgroundColor = [UIColor whiteColor];
        
        _companyNameLabel = [UILabel new];
        _companyNameLabel.viewSize = CGSizeMake(100, 20);
        _companyNameLabel.textColor = [UIColor colorWithHex:0x181818];
        _companyNameLabel.font = fontForSize(13);
        _companyNameLabel.text = [NSString stringWithFormat:@"物流公司:"];
        [_companyNameLabel sizeToFit];
        [_companyNameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 15 * W_ABCW)];
        [_stateView addSubview:_companyNameLabel];
        
        _waybillNumberLabel = [UILabel new];
        _waybillNumberLabel.viewSize = CGSizeMake(100, 20);
        _waybillNumberLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        _waybillNumberLabel.font = fontForSize(11);
        _waybillNumberLabel.text = [NSString stringWithFormat:@"运单号码:"];
        [_waybillNumberLabel sizeToFit];
        [_waybillNumberLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, _companyNameLabel.viewBottomEdge + 12 * W_ABCW)];
        [_stateView addSubview:_waybillNumberLabel];
        
        _orderSNLabel = [UILabel new];
        _orderSNLabel.viewSize = CGSizeMake(100, 20);
        _orderSNLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        _orderSNLabel.font = fontForSize(11);
        _orderSNLabel.text = [NSString stringWithFormat:@"订单编号:"];
        [_orderSNLabel sizeToFit];
        [_orderSNLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, _waybillNumberLabel.viewBottomEdge + 9 * W_ABCW)];
        [_stateView addSubview:_orderSNLabel];
        
        _orderAddTimeLabel = [UILabel new];
        _orderAddTimeLabel.viewSize = CGSizeMake(100, 20);
        _orderAddTimeLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        _orderAddTimeLabel.font = fontForSize(11);
        _orderAddTimeLabel.text = [NSString stringWithFormat:@"下单时间:"];
        [_orderAddTimeLabel sizeToFit];
        [_orderAddTimeLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, _orderSNLabel.viewBottomEdge + 9 * W_ABCW)];
        [_stateView addSubview:_orderAddTimeLabel];
        
        UIView * line = [UIView new];
        line.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [line align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _stateView.viewHeight)];
        line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_stateView addSubview:line];
    }
    return _stateView;
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)self.dataSourceDic[@"data"]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LogisticsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"baiqin123" forIndexPath:indexPath];
    cell.userInteractionEnabled = NO;
    cell.index = indexPath;
    cell.logisticsCellType = LogisticsCellLogistic;
    cell.dataDic = self.dataSourceDic[@"data"][indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray * array = self.dataSourceDic[@"data"];
    if (array && array.count > 0) {
        CGRect rect  = [TYTools boundingString:array[indexPath.row][@"content"] size:CGSizeMake(SCREEN_WIDTH - 27 - 56, 2000) fontSize:12];
        CGFloat cellNewHeight = rect.size.height + 53;
        return cellNewHeight;
    }
    else{
        return 50;
    }
}
#pragma mark -- 网络请求
- (void)getWayInfoRequest {
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"WayInfo" parameters:@{@"orderId":self.orderId} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result == RequestResultSuccess) {
            self.dataSourceDic = [NSDictionary dictionaryWithDictionary:object[@"data"]];
            if (((NSArray *)_dataSourceDic[@"data"]).count == 0) {
                _notHaveDataSource.hidden = YES;
                _tableView.hidden = YES;
                _stateView.hidden = NO;
                _notHaveLogisticsInfo.hidden = NO;
                [self updateStateView];
            }
            else {
                _notHaveDataSource.hidden = YES;
                _notHaveLogisticsInfo.hidden = YES;
                _stateView.hidden = NO;
                _tableView.hidden = NO;
                [self updateStateView];
                [_tableView reloadData];
            }
        }
        else {
            _tableView.hidden = YES;
            _stateView.hidden = YES;
            _notHaveLogisticsInfo.hidden = YES;
            _notHaveDataSource.hidden = NO;
        }
    }];
}
/**
 *  更新状态显示
 */
- (void)updateStateView {
    _companyNameLabel.text = [NSString stringWithFormat:@"物流公司:  %@", self.dataSourceDic[@"name"]];
    [_companyNameLabel sizeToFit];
    [_companyNameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 15 * W_ABCW)];
    
    _waybillNumberLabel.text = [NSString stringWithFormat:@"运单号码:  %@", self.dataSourceDic[@"order"]];
    [_waybillNumberLabel sizeToFit];
    [_waybillNumberLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, _companyNameLabel.viewBottomEdge + 12 * W_ABCW)];
    
    _orderSNLabel.text = [NSString stringWithFormat:@"订单编号:  %@", self.dataSourceDic[@"orderSn"]];
    [_orderSNLabel sizeToFit];
    [_orderSNLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, _waybillNumberLabel.viewBottomEdge + 9 * W_ABCW)];
    
    NSString * addtime = [((NSDictionary *)self.dataSourceDic) objectForKeyNotNull:@"addTime"];
    if (addtime != nil) {
        _orderAddTimeLabel.text = [NSString stringWithFormat:@"下单时间:  %@", [TYTools getTimeToShowWithTimestamp:addtime]];
    }
    [_orderAddTimeLabel sizeToFit];
    [_orderAddTimeLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, _orderSNLabel.viewBottomEdge + 9 * W_ABCW)];
}

#pragma mark -- 点击

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
