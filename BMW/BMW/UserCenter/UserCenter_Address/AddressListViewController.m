//
//  AddressListViewController.m
//  BMW
//
//  Created by 白琴 on 16/3/2.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressListTableViewCell.h"
#import "AddAddressViewController.h"
#import "LoginViewController.h"

@interface AddressListViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, NoNetDelegate> {
    UITableView * _tableView;
    NSMutableArray * _addressListArray;
    
    NSIndexPath * _selectIndexPath;
    NSInteger _index;                   //请求数据条数的时候使用
    
    AddressListTableViewCell * _seletedCell;
    
    BOOL _login;
}

@property (nonatomic, strong)UIView * notHaveDataSource;

@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    //配置导航栏的右侧按钮
    UIButton * addAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addAddressButton setTitle:@"添加" forState:UIControlStateNormal];
    addAddressButton.viewSize = CGSizeMake(50, 50);
    [addAddressButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH + 50, 0)];
    addAddressButton.titleLabel.font = fontForSize(15);
    [addAddressButton setTitleColor:COLOR_NAVIGATIONBAR_ITEM forState:UIControlStateNormal];
    
    UIBarButtonItem * addAddressBtnItem = [[UIBarButtonItem alloc] initWithCustomView:addAddressButton];
    [addAddressButton addTarget:self action:@selector(clickedAddAddressButton) forControlEvents:UIControlEventTouchUpInside];
    addAddressButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = addAddressBtnItem;
   
    [self navigation];
    [self initUserInterface];
    [self setupRefresh];
    
    [self checkConnection:^(ConnectionType type) {
        if (type == ConnectionTypeNone) {
            [self showNoNetOnView:self.view frame:_tableView.frame type:NoNetDefault delegate:self];
        }
        else{
        
        }
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- 界面

/**
 *  数据的初始化
 */
- (void)initData {
    _index = 1;
    NSDictionary * dic = @{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"start":@"1", @"limit":@"8"};
    [self getAddressListRequest:dic isRefresh:YES];
}
/**
 *  界面的初始化
 */
- (void)initUserInterface {
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [UITableView new];
    _tableView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 65);
    [_tableView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UITableView alloc] init];
    [_tableView registerClass:[AddressListTableViewCell class] forCellReuseIdentifier:@"baiqin123"];
    
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
        
        UIImageView * iconImageView = [UIImageView new];
        iconImageView.viewSize = CGSizeMake(84 * W_ABCW, 118 * W_ABCW);
        [iconImageView align:ViewAlignmentTopCenter relativeToPoint:CGPointMake(SCREEN_WIDTH / 2, 70 * W_ABCW)];
        iconImageView.image = [UIImage imageNamed:@"icon_dizhi_shdz"];
        [_notHaveDataSource addSubview:iconImageView];
        
        UILabel * alertLabel = [UILabel new];
        alertLabel.viewSize = CGSizeMake(SCREEN_WIDTH, 12);
        [alertLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, iconImageView.viewBottomEdge + 24 * W_ABCW)];
        alertLabel.font = fontForSize(12);
        alertLabel.textColor = [UIColor colorWithHex:0x878787];
        alertLabel.textAlignment = NSTextAlignmentCenter;
        alertLabel.text = @"您还没有收货地址";
        [_notHaveDataSource addSubview:alertLabel];
    }
    return _notHaveDataSource;
}


#pragma mark -- 网络请求
/**
 *  获取地址列表
 */
- (void)getAddressListRequest:(NSDictionary *)dic isRefresh:(BOOL)isRefresh {
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"AddressList" parameters:dic callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        [_tableView.header endRefreshing];  //结束下拉刷新
        [_tableView.footer endRefreshing];
        if (isRefresh) {
            _addressListArray = [NSMutableArray array];
        }
        if (result == RequestResultSuccess) {
            [_addressListArray addObjectsFromArray:object[@"data"]];
            if (_addressListArray.count >= 8) {
                _tableView.hidden = NO;
                _tableView.footer.hidden = NO;
                _notHaveDataSource.hidden = YES;
            }
            else if(_addressListArray.count == 0){
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
            NSLog(@"数据列表为空");
            if (_addressListArray.count == 0) {
                _notHaveDataSource.hidden = NO;
            }
            else {
                _notHaveDataSource.hidden = YES;

            }
        }
        else {
            _addressListArray = [NSMutableArray array];
        }
        [_tableView reloadData];
    }];
}

- (void)deleteAddressRequestWithAddressId:(NSString *)addressID {
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"AddressDel" parameters:@{@"addressId":addressID} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result == RequestResultSuccess) {
            SHOW_MSG(@"删除成功");
            [_addressListArray removeObject:_addressListArray[_selectIndexPath.section]];
            if (_addressListArray.count == 0) {
                _notHaveDataSource.hidden = NO;
            }
            else {
                [_tableView reloadData];
            }
        }
        
        else {
            SHOW_MSG(@"删除失败");
        }
    }];
}

#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self deleteAddressRequestWithAddressId:_addressListArray[_selectIndexPath.section][@"address_id"]];
    }
}


#pragma mark -- UITableViewDelegate  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _addressListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    else {
       return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 153;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"baiqin123" forIndexPath:indexPath];
    cell.dataSource = _addressListArray[indexPath.section];
    if ([_addressListArray[indexPath.section][@"is_default"] isEqualToString:@"1"]) {
        _seletedCell = cell;
    }
    //点击删除
    [cell setClickedDeleteButton:^{
        _selectIndexPath = indexPath;
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
    //点击编辑
    [cell setClickedEditButton:^{
        AddAddressViewController * addVC = [[AddAddressViewController alloc] init];
        addVC.addressDataSourceDic = _addressListArray[indexPath.section];
        [self.navigationController pushViewController:addVC animated:YES];
    }];
    //设置默认
    [cell setBtnBlock:^{
//        _seletedCell.setDefaultButton.selected = NO;
        [self initData];
        
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.chooseAddress) {
        self.chooeseAddressBlock(_addressListArray[indexPath.section]);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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

#pragma mark -- 点击事件
- (void)clickedAddAddressButton {
    AddAddressViewController * addVC = [[AddAddressViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
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
    _index += 8;
    NSDictionary * dic = @{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"start":NSNumber(_index), @"limit":@"8"};
    [self getAddressListRequest:dic isRefresh:NO];
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
            [self initData];
        
        }
        
    }];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
