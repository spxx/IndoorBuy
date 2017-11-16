//
//  UserCouponViewController.m
//  BMW
//
//  Created by 白琴 on 16/3/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "UserCouponViewController.h"
#import "UserCouponsTableViewCell.h"
#import "SliderButton.h"


@interface UserCouponViewController () <SlideButtonDelegate, UITableViewDataSource, UITableViewDelegate,NoNetDelegate> {
    UITableView * _tableView;
    NSMutableArray * _dataSourceArray;
    NSInteger _index;                   //请求数据条数的时候使用
    NSString * _state;
}

@property (nonatomic, strong)UIView * notHaveDataSource;

@end

@implementation UserCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的优惠券";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    
    [self navigation];
    [self initData];
    [self initUserInterface];
    [self setupRefresh];
    
    [self checkConnection:^(ConnectionType type) {
        if (type == ConnectionTypeNone) {
            [self showNoNetOnView:self.view frame:_tableView.frame type:NoNetDefault delegate:self];
        }
        else if (type == ConnectionTypeWifi){
        
        }
        else if (type == ConnectionTypeData){
        
        }
        
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- 界面
/**
 *  数据初始化
 */
- (void)initData {
    _state = @"1";
    _index = 1;
    [self.HUD show:YES];
    [self userCouponsRequestWithDic:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"state":_state, @"start":@"1", @"limit":@"20"} isRefresh:YES];
}

/**
 *  基本界面
 */
- (void)initUserInterface {
    SliderButton * sliderButton = [[SliderButton alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 38 * W_ABCW) titles:@[@"可使用", @"已使用", @"已失效"]];
    sliderButton.slideButtonDelegate = self;
    [self.view addSubview:sliderButton];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0,sliderButton.viewBottomEdge , SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self.view addSubview:line];
    
    
    _tableView = [UITableView new];
    _tableView.viewSize = CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT - sliderButton.viewBottomEdge - 64 - 0.5);
    [_tableView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, sliderButton.viewBottomEdge + 0.5)];
    _tableView.backgroundColor = COLOR_BACKGRONDCOLOR;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.viewWidth, 15 * W_ABCW)];
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UserCouponsTableViewCell class] forCellReuseIdentifier:@"baiqin123"];
    [self.view addSubview:_tableView];
    
    [self.view addSubview:self.notHaveDataSource];
    [self.view bringSubviewToFront:_tableView];
    _notHaveDataSource.hidden = YES;
    
}
/**
 *  无数据的情况
 */
- (UIView *)notHaveDataSource {
    if (!_notHaveDataSource) {
        _notHaveDataSource = [UIView new];
        _notHaveDataSource.viewSize = CGSizeMake(SCREEN_WIDTH, _tableView.viewHeight);
        [_notHaveDataSource align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _tableView.viewY)];
        _notHaveDataSource.backgroundColor = [UIColor whiteColor];
        
        UIImageView * iconImageView = [UIImageView new];
        iconImageView.viewSize = CGSizeMake(168 * W_ABCW, 118 * W_ABCW);
        [iconImageView align:ViewAlignmentTopCenter relativeToPoint:CGPointMake(SCREEN_WIDTH / 2, 70 * W_ABCW)];
        iconImageView.image = [UIImage imageNamed:@"icon_youhuiquan_wdyhj"];
        [_notHaveDataSource addSubview:iconImageView];
        
        UILabel * alertLabel = [UILabel new];
        alertLabel.viewSize = CGSizeMake(SCREEN_WIDTH, 12);
        [alertLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, iconImageView.viewBottomEdge + 24 * W_ABCW)];
        alertLabel.font = fontForSize(12);
        alertLabel.textColor = [UIColor colorWithHex:0x878787];
        alertLabel.textAlignment = NSTextAlignmentCenter;
        alertLabel.text = @"暂无优惠券";
        [_notHaveDataSource addSubview:alertLabel];
    }
    return _notHaveDataSource;
}
#pragma mark -- SlideButtonDelegate
- (void)sledeMenu:(UIButton *)button didSelectAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            //可使用
            _dataSourceArray = [NSMutableArray array];
            _state = @"1";
        }
            break;
        case 1:
            //已使用
            _dataSourceArray = [NSMutableArray array];
            _state = @"2";
            break;
        case 2:
            //已失效
            _dataSourceArray = [NSMutableArray array];
            _state = @"3";
            break;
        default:
            break;
    }
    [_tableView reloadData];
    [self.HUD show:YES];
    [self userCouponsRequestWithDic:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"state":_state, @"start":@"1", @"limit":@"20"} isRefresh:YES];
}
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArray.count;;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCouponsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"baiqin123" forIndexPath:indexPath];
    cell.backgroundColor = COLOR_BACKGRONDCOLOR;
    if (_dataSourceArray.count>0) {
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:_dataSourceArray[indexPath.row][@"voucher_t_customimg"]] placeholderImage:nil];
        NSString * startString = [[TYTools getTimeToShowWithTimestamp:_dataSourceArray[indexPath.row][@"voucher_start_date"]] substringToIndex:10];
        NSString * endString = [[TYTools getTimeToShowWithTimestamp:_dataSourceArray[indexPath.row][@"voucher_end_date"]] substringToIndex:10];
        cell.timeLabel.text = [NSString stringWithFormat:@"有效期:%@ 至 %@", startString, endString];        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 126 * W_ABCW;
}
/**
 *  通过监听滑动来改变contentInset的值来取消悬停效果
 *
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y <= sectionHeaderHeight&&scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - 让cell的线从左边开始
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

#pragma mark -- 网络请求
- (void)userCouponsRequestWithDic:(NSDictionary *)dic isRefresh:(BOOL)isRefresh {
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"VoucherList" parameters:dic callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        [_tableView.header endRefreshing];
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
            [_tableView reloadData];
        }
        else if (result == RequestResultEmptyData) {
            if (_dataSourceArray.count == 0) {
                //显示没有数据的情况
                _tableView.hidden = YES;
                _notHaveDataSource.hidden = NO;
            }
            else {
                _tableView.hidden = NO;
                _tableView.footer.hidden = YES;
                _notHaveDataSource.hidden = YES;
            }
        }else{
            _tableView.hidden = YES;
            _notHaveDataSource.hidden = NO;
            SHOW_EEROR_MSG(object);
        }
    }];
}
#pragma mark -- 上拉加载下拉刷新
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
    [self userCouponsRequestWithDic:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"state":_state, @"start":@"1", @"limit":@"20"} isRefresh:YES];
}

/**
 *  上拉加载
 */
- (void)loadMoreList
{
    _index += 20;
    NSDictionary * dic = @{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"state":_state, @"start":NSNumber(_index), @"limit":@"20"};
    [self userCouponsRequestWithDic:dic isRefresh:NO];
}
#pragma mark -- NoNetDelegate --
-(void)NoNetDidClickRelaod:(UIButton *)sender
{
    [self checkConnection:^(ConnectionType type) {
        if (type == ConnectionTypeNone) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前网络不可用，请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            [self hideNoNet];
            [self refreshView];
        
        }
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
