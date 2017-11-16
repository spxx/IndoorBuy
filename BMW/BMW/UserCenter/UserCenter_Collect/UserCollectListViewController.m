//
//  UserCollectListViewController.m
//  BMW
//
//  Created by 白琴 on 16/3/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "UserCollectListViewController.h"
#import "UserCollectListTableViewCell.h"
#import "GoodsDetailViewController.h"


@interface UserCollectListViewController () <UITableViewDataSource, UITableViewDelegate, NoNetDelegate> {
    UITableView * _tableView;
     NSInteger _index;                   //请求数据条数的时候使用
    NSMutableArray * _dataSourceArray;   //数据源
    UIButton * _editButton;
    UIView * _bottomView;
    UIButton * _allChooseButton;
    UIButton * _deleteButton;
    NSMutableArray * _selectedArray;     //选择了那些
}

@property (nonatomic, strong)UIView * notHaveDataSourceView;

@end

@implementation UserCollectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    
    //配置导航栏的右侧按钮
    _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_editButton setTitle:@"完成" forState:UIControlStateSelected];
    _editButton.viewSize = CGSizeMake(50, 50);
    [_editButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH + 50, 0)];
    _editButton.titleLabel.font = fontForSize(15);
    [_editButton setTitleColor:COLOR_NAVIGATIONBAR_ITEM forState:UIControlStateNormal];
    [_editButton addTarget:self action:@selector(clickedEditButton:) forControlEvents:UIControlEventTouchUpInside];
    _editButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem * registBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_editButton];
    _editButton.hidden = YES;
    self.navigationItem.rightBarButtonItem = registBtnItem;
    
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBarHidden = NO;
    [self initData];
}

#pragma mark -- 界面

/**
 *  数据的初始化
 */
- (void)initData {
    _index = 1;
    _selectedArray = [NSMutableArray array];
    NSDictionary * dic = @{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"start":@"1", @"limit":@"8"};
    [self getCollectListRequestWithDic:dic isRefresh:YES];
}
/**
 *  初始化界面
 */
- (void)initUserInterface {
    _tableView = [UITableView new];
    _tableView.viewSize = CGSizeMake(SCREEN_WIDTH , SCREEN_HEIGHT - 65);
    [_tableView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UserCollectListTableViewCell class] forCellReuseIdentifier:@"baiqin123"];
    _tableView.tableFooterView = [[UITableView alloc] init];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self.view addSubview:_tableView];
    
    
    _bottomView = [UIView new];
    _bottomView.viewSize = CGSizeMake(SCREEN_WIDTH, 47 * W_ABCW);
    [_bottomView align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, SCREEN_HEIGHT - 64)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    _bottomView.hidden = YES;
    
    UIView * line = [UIView new];
    line.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5 * W_ABCW);
    [line align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [_bottomView addSubview:line];
    
    UIButton * allChooseBigButton = [UIButton new];
    allChooseBigButton.viewSize = CGSizeMake(100 * W_ABCW, 47 * W_ABCW);
    [allChooseBigButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, 0)];
    [allChooseBigButton addTarget:self action:@selector(clickedAllChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:allChooseBigButton];
    
    _allChooseButton = [UIButton new];
    _allChooseButton.viewSize = CGSizeMake(18 * W_ABCW, 18 * W_ABCW);
    [_allChooseButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, (_bottomView.viewHeight - _allChooseButton.viewHeight) / 2)];
    [_allChooseButton setBackgroundImage:[UIImage imageNamed:@"icon_gouxuan_nor_gwc"] forState:UIControlStateNormal];
    [_allChooseButton setBackgroundImage:[UIImage imageNamed:@"icon_gouxuan_cli_gwc"] forState:UIControlStateSelected];
    [_allChooseButton addTarget:self action:@selector(clickedAllChooseButton:) forControlEvents:UIControlEventTouchUpInside];
    [allChooseBigButton addSubview:_allChooseButton];
    
    UILabel * allChooseLabel = [UILabel new];
    allChooseLabel.viewSize = CGSizeMake(40, 47 * W_ABCW);
    allChooseLabel.font = fontForSize(16);
    allChooseLabel.textColor = [UIColor colorWithHex:0x181818];
    allChooseLabel.text = @"全选";
    [allChooseLabel sizeToFit];
    [allChooseLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_allChooseButton.viewRightEdge + 7 * W_ABCW, (_bottomView.viewHeight - allChooseLabel.viewHeight) / 2)];
    [allChooseBigButton addSubview:allChooseLabel];
    
    allChooseBigButton.viewWidth = allChooseLabel.viewRightEdge + 2;
    
    _deleteButton = [UIButton new];
    _deleteButton.viewSize = CGSizeMake(89 * W_ABCW, _bottomView.viewHeight);
    [_deleteButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH, 0)];
    _deleteButton.backgroundColor = [UIColor colorWithHex:0xfd5487];
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _deleteButton.titleLabel.font = fontForSize(13);
    [_deleteButton addTarget:self action:@selector(clickedDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_deleteButton];
    
}

- (UIView *)notHaveDataSourceView {
    if (!_notHaveDataSourceView) {
        _notHaveDataSourceView = [UIView new];
        _notHaveDataSourceView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 65);
        [_notHaveDataSourceView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
        _notHaveDataSourceView.backgroundColor = [UIColor whiteColor];
        
        UIImageView * iconImageView = [UIImageView new];
        iconImageView.viewSize = CGSizeMake(118 * W_ABCW, 118 * W_ABCW);
        [iconImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake((SCREEN_WIDTH - iconImageView.viewWidth) / 2, 70 * W_ABCW)];
        iconImageView.image = [UIImage imageNamed:@"icon_shoucang_wdsc"];
        [_notHaveDataSourceView addSubview:iconImageView];
        
        UILabel * alertLabel = [UILabel new];
        alertLabel.viewSize = CGSizeMake(SCREEN_WIDTH, 12 * W_ABCW);
        alertLabel.font = fontForSize(12);
        alertLabel.textColor = [UIColor colorWithHex:0x878787];
        alertLabel.textAlignment = NSTextAlignmentCenter;
        alertLabel.text = @"您还没有收藏过商品";
        [alertLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, iconImageView.viewBottomEdge + 24 * W_ABCW)];
        [_notHaveDataSourceView addSubview:alertLabel];
        
    }
    return _notHaveDataSourceView;
}


#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 99 * W_ABCW;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCollectListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"baiqin123"];
    if (_dataSourceArray.count>0) {
        cell.dataSourceDic = _dataSourceArray[indexPath.row];
        cell.isEdit = _editButton.selected;
        cell.isChooseAll = _allChooseButton.selected;
        //点击选择
        [cell setClickedChooseButton:^(BOOL isChoose) {
            if (isChoose) {
                //点击勾选
                [_selectedArray addObject:[NSString stringWithFormat:@"%ld", indexPath.row]];
            }
            else {
                //取消勾选
                for (NSString * row in _selectedArray) {
                    if ([row integerValue] == indexPath.row) {
                        [_selectedArray removeObject:row];
                        _allChooseButton.selected = NO;
                        break;
                    }
                }
            }
            //如果选中的和本身所有的数据个数一样  就将全选按钮勾上
            if (_selectedArray.count == _dataSourceArray.count) {
                _allChooseButton.selected = YES;
            }
            //如果选中的按钮个数为0   将全选按钮的勾取消
            if (_selectedArray.count == 0) {
                _allChooseButton.selected = NO;
            }
        }];
        //将选择了的勾选上
        if (_editButton.selected) {
            for (NSString * row in _selectedArray) {
                if ([row integerValue] == indexPath.row) {
                    cell.chooseButton.selected = YES;
                }
            }
        }
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataSourceArray.count>0) {
        NSDictionary * dic = _dataSourceArray[indexPath.row];
        NSString * soldOut = [dic objectForKeyNotNull:@"goods_state"];
        
        switch (soldOut.integerValue) {
            case 1:{
                GoodsDetailViewController * goodsDetailVC =[[GoodsDetailViewController alloc]init];
                goodsDetailVC.goodsId = dic[@"goods_id"];
                [self.navigationController pushViewController:goodsDetailVC animated:YES];
            }
                break;
                
            default:{
                SHOW_MSG(@"该商品已下架");
            }
                break;
        }
    }
    
   
}


#pragma mark -- 点击事件
/**
 *  编辑
 */
- (void)clickedEditButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _tableView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 65 - 47 * W_ABCW);
        _bottomView.hidden = NO;
    }
    else {
        _tableView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 65);
        _bottomView.hidden = YES;
    }
    [_tableView reloadData];
}
/**
 *  点击全选
 */
- (void)clickedAllChooseButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    _allChooseButton.selected = sender.selected;
    if (_allChooseButton.selected) {
        [_selectedArray removeAllObjects];
        for (int i = 0; i < _dataSourceArray.count; i ++) {
            [_selectedArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    else {
        [_selectedArray removeAllObjects];
    }
    
    [_tableView reloadData];
}

/**
 *  点击删除
 */
- (void)clickedDeleteButton:(UIButton *)sender {
    NSString * goodsID = @"";
    for (int i = 0; i < _selectedArray.count; i ++) {
        NSInteger index = [_selectedArray[i] integerValue];
        goodsID = [NSString stringWithFormat:@"%@,%@",goodsID, _dataSourceArray[index][@"goods_id"]];
    }
    if (_selectedArray.count != 0) {
        [self deleteCollectRequestWithGoodsId:[goodsID substringFromIndex:1]];
    }
    
}

#pragma mark -- 网络请求
/**
 *  请求收藏列表
 *
 *  @param dic 参数字典
 */
- (void)getCollectListRequestWithDic:(NSDictionary *)dic isRefresh:(BOOL)isRefresh {
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"Collist" parameters:dic callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        [_tableView.header endRefreshing];  //结束下拉刷新
        [_tableView.footer endRefreshing];
        if (isRefresh) {
            _dataSourceArray = [NSMutableArray array];
        }
        if (result == RequestResultSuccess) {
            [_dataSourceArray addObjectsFromArray:object[@"data"]];
            if (_dataSourceArray.count >= 8) {
                _editButton.userInteractionEnabled = YES;
                _editButton.hidden = NO;
                _tableView.hidden = NO;
                _tableView.footer.hidden = NO;
                _tableView.hidden = NO;
                [_notHaveDataSourceView removeFromSuperview];
                _notHaveDataSourceView = nil;
            }
            else if(_dataSourceArray.count == 0){
                _editButton.userInteractionEnabled = NO;
                _editButton.hidden = YES;
                _tableView.hidden = YES;
                _tableView.footer.hidden = YES;
                [self.view addSubview:self.notHaveDataSourceView];
            }
            else{
                _editButton.userInteractionEnabled = YES;
                _editButton.hidden = NO;
                _tableView.hidden = NO;
                _tableView.footer.hidden = YES;
                _tableView.hidden = NO;
                [_notHaveDataSourceView removeFromSuperview];
                _notHaveDataSourceView = nil;
            }
        }
        else if (result == RequestResultEmptyData) {
            if (_dataSourceArray.count == 0) {
                _editButton.userInteractionEnabled = NO;
                _editButton.hidden = YES;
                _tableView.hidden = YES;
                _tableView.footer.hidden = YES;
                [self.view addSubview:self.notHaveDataSourceView];
            }
            else {
                _editButton.userInteractionEnabled = YES;
                _editButton.hidden = NO;
                _tableView.hidden = NO;
                [_notHaveDataSourceView removeFromSuperview];
                _notHaveDataSourceView = nil;
            }
        }
        else {
            _dataSourceArray = [NSMutableArray array];
        }
        [_tableView reloadData];
    }];
}

- (void)deleteCollectRequestWithGoodsId:(NSString *)goodsId {
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"Coldel" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"goodsId":goodsId} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result == RequestResultSuccess) {
            SHOW_MSG(@"删除成功");
            //循环移除数据源里面被删除的数据
            for (int i = 0; i < _selectedArray.count; i ++) {
                NSInteger index = [_selectedArray[i] integerValue];
                [_dataSourceArray removeObjectAtIndex:index];
            }
            [_selectedArray removeAllObjects];
            if (_dataSourceArray.count == 0) {
                _editButton.userInteractionEnabled = NO;
                _editButton.hidden = YES;
                _tableView.hidden = YES;
                _tableView.footer.hidden = YES;
                [self.view addSubview:self.notHaveDataSourceView];
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
    [self getCollectListRequestWithDic:dic isRefresh:NO];
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
}

@end
