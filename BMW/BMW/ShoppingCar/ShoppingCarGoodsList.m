//
//  ShoppingCarGoodsList.m
//  BMW
//
//  Created by rr on 16/3/11.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ShoppingCarGoodsList.h"
#import "ShoppingCarTableViewCell.h"

@interface ShoppingCarGoodsList ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}


@end

@implementation ShoppingCarGoodsList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品列表";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    
    [self navigation];
    [self initUserInterFace];
    
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    [_tableView reloadData];
}


-(void)initUserInterFace{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10*W_ABCH, SCREEN_WIDTH, SCREEN_HEIGHT-64-10*W_ABCH)];
    [_tableView registerClass:[ShoppingCarTableViewCell class] forCellReuseIdentifier:@"goodsCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * goods = [_dataDic objectForKey:@"goods"] ? [_dataDic objectForKey:@"goods"] : [_dataDic objectForKey:@"value"];
    return [goods count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShoppingCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHex:0xffffff];
    cell.currenttState = NO;
    cell.hideChooseB = YES;
    NSArray * goods = [_dataDic objectForKey:@"goods"] ? [_dataDic objectForKey:@"goods"] : [_dataDic objectForKey:@"value"];
    cell.goodsDic = goods[indexPath.row];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44*W_ABCH;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString * text = [_dataDic objectForKey:@"tag_name"] ? [_dataDic objectForKey:@"tag_name"] : [_dataDic objectForKey:@"title"];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 44*W_ABCH)];
    addressLabel.text = [NSString stringWithFormat:@"%@",text];
    addressLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
    addressLabel.font = fontForSize(12);
    [headerView addSubview:addressLabel];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5*W_ABCH, SCREEN_WIDTH, 0.5*W_ABCH)];
    line.backgroundColor = COLOR_BACKGRONDCOLOR;
    [headerView addSubview:line];
    return headerView;
}







@end


