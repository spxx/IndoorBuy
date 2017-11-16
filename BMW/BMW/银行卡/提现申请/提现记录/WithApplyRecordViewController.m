//
//  WithApplyRecordViewController.m
//  DP
//
//  Created by rr on 16/8/1.
//  Copyright © 2016年 sp. All rights reserved.
//

#import "WithApplyRecordViewController.h"
#import "ApplyRecordCell.h"
#import "WithdrawModel.h"

@interface WithApplyRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UISegmentedControl * _segmentedControl;
}

@property (nonatomic, strong) NSMutableArray * models;

@end

@implementation WithApplyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTitleView];
    [self initUserInterface];
    [self requestForRecordsWithState:@"0"];
}

-(void)initTitleView
{
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-110*W_ABCW)/2, 0,SCREEN_WIDTH-110*W_ABCW, 31)];
    titleView.layer.cornerRadius = 4;
    titleView.clipsToBounds = YES;
    
    _segmentedControl = [[UISegmentedControl alloc ] initWithItems:nil];
    _segmentedControl.viewSize = CGSizeMake(titleView.viewWidth, 30);
    [_segmentedControl insertSegmentWithTitle:@"申请中" atIndex:0 animated:NO];
    [_segmentedControl insertSegmentWithTitle:@"已提现" atIndex:1 animated:NO];
    [_segmentedControl insertSegmentWithTitle:@"拒绝" atIndex:2 animated:NO];
    _segmentedControl.tintColor = [UIColor whiteColor];
    [_segmentedControl align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
    [_segmentedControl addTarget:self action:@selector(processSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.selectedSegmentIndex = 0;
    [titleView addSubview:_segmentedControl];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, fontForSize(14),NSFontAttributeName,nil];
    [_segmentedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    NSDictionary *diction = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName, fontForSize(14),NSFontAttributeName,nil];
    [_segmentedControl setTitleTextAttributes:diction forState:UIControlStateSelected];

    self.navigationItem.titleView = titleView;
}


- (void)initUserInterface
{
    [self navigation];
    
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"ApplyRecordCell" bundle:nil] forCellReuseIdentifier:@"recordCell"];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    // 分割线顶头
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
//    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreList)];
//    [_tableView.legendFooter setTitle:@"上拉加载更多列表" forState:MJRefreshFooterStateIdle];
//    [_tableView.legendFooter setTitle:@"正在加载中..." forState:MJRefreshFooterStateRefreshing];
//    _tableView.legendFooter.hidden = YES;
}

#pragma mark -- setter
- (void)setModels:(NSMutableArray *)models
{
    _models = models;
    [_tableView reloadData];
}

#pragma mark -- 获取数据
- (void)requestForRecordsWithState:(NSString *)state
{
    [WithdrawModel requestForWithdrawRecordWithState:state complete:^(NSMutableArray *models, NSString *message, NSInteger code) {
        if (code == 100) {
            self.models = models;
        }else if (code == 902){
            self.models = nil;
            SHOW_MSG(message);
        }else {
            self.models = nil;
            SHOW_EEROR_MSG(message);
        }
    }];
}

#pragma mark -- actions
- (void)processSegmentedControl:(UISegmentedControl *)sender {
    NSInteger index = sender.selectedSegmentIndex;
    NSString * state = [NSString stringWithFormat:@"%ld", (long)index];
    [self requestForRecordsWithState:state];
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplyRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"recordCell"];
    
    WithdrawModel * model = self.models[indexPath.row];
    
    cell.cashLabel.text = [NSString stringWithFormat:@"￥%@", model.amount];
    cell.timeLabel.text = model.time;

    NSString * bankCardNum;
    if (model.bankCardNum.length > 4) {
        bankCardNum = [model.bankCardNum substringFromIndex:model.bankCardNum.length - 4];
    }else {
        bankCardNum = @"";
    }
    cell.bankNameAndNumLabel.text = [NSString stringWithFormat:@"%@（%@）", model.bankName, bankCardNum];
    NSString * statusString = @"";
    if ([model.state isEqualToString:@"0"]) {
        statusString = @"申请中";
        cell.statusLabel.textColor = [UIColor colorWithHex:0x2eadef];

    }
    else if ([model.state isEqualToString:@"1"]) {
        statusString = @"已取现";
        cell.statusLabel.textColor = [UIColor colorWithHex:0xf84e40];
    }
    else if ([model.state isEqualToString:@"2"]) {
        statusString = @"拒绝";
        cell.statusLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    }
    
    cell.statusLabel.text = statusString;
    cell.reasonLabel.text = model.remark;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}


@end

