
//
//  BalancesViewController.m
//  BMW
//
//  Created by 白琴 on 16/5/25.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BalancesViewController.h"
#import "RechargeViewController.h"          //充值
#import "RechargeRecordViewController.h"    //充值记录
#import "UserInfoViewController.h"

@interface BalancesViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView * _tableView;
    NSArray * _dataSourceArray;
    NSArray * _imageDataArray;
    UILabel * _titleLabel;
    UILabel * _moneyLabel;
    NSString * _userMoney;
}

@property (nonatomic, strong)UIView * headerView;

@end

@implementation BalancesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"余额";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    //导航栏
    [self navigation];
    [self initUserInterface];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self getMemberMoney];
}

#pragma mark -- 界面 --
- (void)initUserInterface {
    _dataSourceArray = @[@"充值", @"充值记录", @"资金记录"];
    _imageDataArray = @[@"icon_chongzhi_ye", @"icon_chongzhijilu_ye", @"icon_wodeshoucang_wd1"];
    
    _tableView = [UITableView new];
    _tableView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 65);
    [_tableView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 45 * W_ABCH;
    _tableView.tableFooterView = [[UITableView alloc] init];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.backgroundColor = COLOR_BACKGRONDCOLOR;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.viewSize = CGSizeMake(SCREEN_WIDTH, 145 * W_ABCH);
        [_headerView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
        _headerView.backgroundColor = [UIColor whiteColor];
        //红色圆圈
        UIView * redRound = [UIView new];
        redRound.viewSize = CGSizeMake(8 * W_ABCH, 8 * W_ABCH);
        [redRound align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(20 * W_ABCH, 22 * W_ABCH)];
        redRound.layer.cornerRadius = redRound.viewHeight / 2;
        redRound.layer.masksToBounds = YES;
        redRound.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
        [_headerView addSubview:redRound];
        //标题
        _titleLabel = [UILabel new];
        _titleLabel.viewSize = CGSizeMake(200, 10);
        _titleLabel.textColor = [UIColor colorWithHex:0x181818];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.text = @"账户余额（元）";
        [_titleLabel sizeToFit];
        [_titleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(redRound.viewRightEdge + 10 * W_ABCH, 20 * W_ABCH)];
        [_headerView addSubview:_titleLabel];
        //余额
        _moneyLabel = [UILabel new];
        _moneyLabel.viewSize = CGSizeMake(200, 10);
        _moneyLabel.textColor = COLOR_NAVIGATIONBAR_BARTINT;
        _moneyLabel.font = [UIFont systemFontOfSize:40];
        _moneyLabel.text = _userMoney;
        [_moneyLabel sizeToFit];
        [_moneyLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(20 * W_ABCH, _titleLabel.viewBottomEdge + 37 * W_ABCH)];
        [_headerView addSubview:_moneyLabel];
    }
    return _headerView;
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"baiqin123";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.textLabel.text = _dataSourceArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor colorWithHex:0x181818];
    cell.imageView.image = [UIImage imageNamed:_imageDataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 155 * W_ABCH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString * headerID = @"header";
    UITableViewHeaderFooterView * headview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (!headview) {
        headview = [[UITableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 145 * W_ABCH)];
    }
    for (UIView * view in headview.subviews) {
        [view removeFromSuperview];
    }
    [headview addSubview:self.headerView];
    return headview;
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
    switch (indexPath.row) {
        case 0:{
            //充值
            RechargeViewController * rechargeVC = [[RechargeViewController alloc] init];
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }
            break;
        case 1:{
            //充值记录
            RechargeRecordViewController * rechargeRecordVC = [[RechargeRecordViewController alloc] init];
            rechargeRecordVC.isRecharge = YES;
            [self.navigationController pushViewController:rechargeRecordVC animated:YES];
        }
            break;
        case 2:{
            //资金记录
            RechargeRecordViewController * rechargeRecordVC = [[RechargeRecordViewController alloc] init];
            rechargeRecordVC.isRecharge = NO;
            [self.navigationController pushViewController:rechargeRecordVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- 网络请求
/**
 *  获取用户余额
 */
- (void)getMemberMoney {
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetMemberMoney" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            double userMoney = 0;
            if ([object[@"data"][@"userMoney"] isKindOfClass:[NSNull class]]) {
                userMoney= 0.00;
            }
            else {
                userMoney = [object[@"data"][@"userMoney"] doubleValue];
            }
            
            _moneyLabel.text = [NSString stringWithFormat:@"%.2f", userMoney];
            [_moneyLabel sizeToFit];
            [_moneyLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(20 * W_ABCH, _titleLabel.viewBottomEdge + 37 * W_ABCH)];
        }
        else {
            
        }
    }];
}

- (void)back {
    if ([self.navigationController.viewControllers[1] isKindOfClass:[UserInfoViewController class]]) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
