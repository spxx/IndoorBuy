//
//  HelpCenterViewController.m
//  BMW
//
//  Created by 白琴 on 16/3/23.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "HelpCenterViewController.h"
#import "HelpCenterTableViewCell.h"
#import "HelpDetailViewController.h"

@interface HelpCenterViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView * _tableView;
    NSMutableArray * _dataSoureceArray;
    NSString * _type;
    NSInteger _index;
    UIButton * _lastButton;
}

@property (nonatomic, strong)UIView * topBottonView;

@end

@implementation HelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"帮助中心";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self navigation];
    [self initUserInterface];
    [self initData];
}

- (void)initData {
    _index = 1;
    _dataSoureceArray = [NSMutableArray array];
    if (_tableView) {
        [_tableView reloadData];
    }
    [self getArticleWithType:_type isRefresh:YES];
}

- (void)initUserInterface {
    [self.view addSubview:self.topBottonView];
    _tableView = [UITableView new];
    _tableView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64 - _topBottonView.viewBottomEdge);
    [_tableView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _topBottonView.viewBottomEdge + 0.5 * W_ABCW)];
    _tableView.tableFooterView = [[UITableView alloc] init];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.backgroundColor = COLOR_BACKGRONDCOLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[HelpCenterTableViewCell class] forCellReuseIdentifier:@"baiqin123"];
    [self.view addSubview:_tableView];
    
    _type = @"1";
}

- (UIView *)topBottonView {
    if (!_topBottonView) {
        _topBottonView = [UIView new];
        _topBottonView.viewSize = CGSizeMake(SCREEN_WIDTH, 39 * W_ABCW);
        [_topBottonView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
        _topBottonView.backgroundColor = [UIColor whiteColor];
        NSArray * buttonTitleArray = @[@"购买咨询", @"配送查询", @"付款及退款", @"售后问题"];
        for (int i = 0; i < buttonTitleArray.count; i ++) {
            UIButton * button = [UIButton new];
            button.viewSize = CGSizeMake(SCREEN_WIDTH / buttonTitleArray.count, _topBottonView.viewHeight);
            [button align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0 + i * button.viewWidth, 0)];
            button.tag = 17000 + i;
            [button setTitle:buttonTitleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHex:0x181818] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHex:0xfd5487] forState:UIControlStateSelected];
            button.titleLabel.font = fontForSize(14);
            [button addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
            [_topBottonView addSubview:button];
            if (i == 0) {
                button.selected = YES;
                _lastButton = button;
            }
        }
        UIView * lineView = [UIView new];
        lineView.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [lineView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _topBottonView.viewBottomEdge)];
        lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_topBottonView addSubview:lineView];
    }
    return _topBottonView;
}
#pragma mark -- UITableViewDelegate  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSoureceArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HelpCenterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"baiqin123" forIndexPath:indexPath];
    cell.contentString = _dataSoureceArray[indexPath.row][@"title"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel * label = [UILabel new];
    label.viewSize = CGSizeMake(SCREEN_WIDTH - 14.5 * W_ABCW, 30 * W_ABCW);
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13], NSParagraphStyleAttributeName:paragraphStyle};
    label.attributedText =[[NSAttributedString alloc] initWithString:_dataSoureceArray[indexPath.row][@"title"] attributes:attributes];
    label.numberOfLines = 0;
    [label sizeToFit];
    
    CGFloat rowHeight = label.viewHeight + 12 * W_ABCW;
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_dataSoureceArray.count != 0) {
        HelpDetailViewController * helpDetail = [HelpDetailViewController new];
        helpDetail.articleID = _dataSoureceArray[indexPath.row][@"id"];
        helpDetail.articleType = _dataSoureceArray[indexPath.row][@"type"];
        [self.navigationController pushViewController:helpDetail animated:YES];
    }
    
}


#pragma mark -- 点击
/**
 *  点击问题类型按钮
 */
- (void)changeType:(UIButton *)sender {
    _lastButton.selected = NO;
    sender.selected = !sender.selected;
    _lastButton = sender;
    switch (sender.tag) {
        case 17000: {
            _type = @"1";
            [self initData];
        }
            break;
        case 17001: {
            _type = @"2";
            [self initData];
        }
            break;
        case 17002: {
            _type = @"3";
            [self initData];
        }
            break;
        case 17003: {
            _type = @"4";
            [self initData];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- 网络请求
- (void)getArticleWithType:(NSString *)type isRefresh:(BOOL)isRefresh {
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"Article" parameters:@{@"type":type} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        [_tableView.header endRefreshing];  //结束下拉刷新
        [_tableView.footer endRefreshing];
        if (isRefresh) {
            _dataSoureceArray = [NSMutableArray array];
        }
        if (result == RequestResultSuccess) {
            [_dataSoureceArray addObjectsFromArray:object[@"data"]];
            if (_dataSoureceArray.count >= 8) {
                _tableView.hidden = NO;
                _tableView.footer.hidden = NO;
            }
            else if(_dataSoureceArray.count == 0){
                _tableView.hidden = YES;
                _tableView.footer.hidden = YES;
            }
            else{
                _tableView.hidden = NO;
                _tableView.footer.hidden = YES;
            }
            [_tableView reloadData];
        }
        else if (result == RequestResultEmptyData) {
            NSLog(@"数据列表为空");
        }
    }];
}
#pragma mark -- 上拉加载和下拉刷新
//集成刷新
- (void)setupRefresh
{
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
}
/**
 *  刷新
 */
- (void)refreshView {
    [self initData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
