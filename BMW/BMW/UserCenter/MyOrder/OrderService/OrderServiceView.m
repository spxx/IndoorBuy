//
//  OrderServiceView.m
//  BMW
//
//  Created by gukai on 16/3/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OrderServiceView.h"
#import "OrderServiceCell.h"
#import "OrderServiceHeadView.h"
#import "OrderServiceFootView.h"


@interface OrderServiceView ()<UITableViewDataSource,UITableViewDelegate,OrderServiceFootViewDelegate,UIAlertViewDelegate>
@property(nonatomic,copy)NSMutableArray * dataSource;
@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,assign)NSInteger start;

@property(nonatomic,assign)NSInteger cancelSection;
@property(nonatomic,assign)NSInteger delSection;

@property(nonatomic,strong)UIView *noOrderView;
@end
@implementation OrderServiceView


- (instancetype)initWithFrame:(CGRect)frame withOrderId:(NSString *)orderId orderServiceType:(OrderServiceType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.orderId = orderId;
        self.orderServiceType = OrderServiceInOrder;
        [self initData];
        [self initUserInterface];
        [self GetOrderServicenNetWork];
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initUserInterface];
        [self netWork];
    }
    return self;
}
-(void)initData
{
    _start = 1;
    _dataSource = [NSMutableArray array];
}
-(void)initUserInterface
{
    [self initTableView];
    [self initBottomCustomerServices];
  
}
-(void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight - 49) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 100;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHex:0xf1f1ed];
    if (self.orderServiceType == OrderServiceInOrder) {
        
    }
    else if (self.orderServiceType == OrderServiceDefault){
        [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        _tableView.footer.hidden = YES;
    }
   [self addSubview:_tableView];
    
}
-(void)initBottomCustomerServices
{
    UIButton * linkKefu = [[UIButton alloc]initWithFrame:CGRectMake(0, self.viewHeight - 49, SCREEN_WIDTH, 49)];
    linkKefu.backgroundColor = [UIColor colorWithHex:0xfd5487];
    [linkKefu setTitle:@"咨询客服" forState:UIControlStateNormal];
    linkKefu.titleLabel.font = fontForSize(16);
    [linkKefu setTintColor:[UIColor whiteColor]];
    [linkKefu addTarget:self action:@selector(linkKefuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:linkKefu];
}
#pragma mark -- UITableViewDataSource --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataSource && _dataSource.count > 0) {
        NSArray * arr = (NSArray *)_dataSource[section][@"goods"];
        return arr.count;

    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"OrderServiceCell";
    OrderServiceCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[OrderServiceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (_dataSource && _dataSource.count > 0) {
        NSArray * goods = (NSArray *)_dataSource[indexPath.section][@"goods"];
        cell.imageUrl = goods[indexPath.row][@"goods_image"];
        cell.infoText = goods[indexPath.row][@"goods_name"];
        cell.goodsNum = [goods[indexPath.row][@"goods_num"] integerValue];
        NSDictionary * dic = goods[indexPath.row][@"goods_spec"];
        cell.spe_dic = dic;
    }
   
    return cell;
}
#pragma mark -- UITableViewDelegate --
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString * headerID = @"header";
    UITableViewHeaderFooterView * headview = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (!headview) {
        
       headview = [[UITableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    }
    for (UIView * view in headview.subviews) {
        [view removeFromSuperview];
        
    }
    if (_dataSource && _dataSource.count > 0) {
        OrderServiceHeadView * header = [[OrderServiceHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        header.service_num = [NSString stringWithFormat:@"%@",_dataSource[section][@"service_num"]];
        header.order_sn = [NSString stringWithFormat:@"%@",_dataSource[section][@"order_sn"]];
        header.state = [_dataSource[section][@"status"] integerValue];
        UIButton * btn = [[UIButton alloc]initWithFrame:header.bounds];
        [btn addTarget:self action:@selector(serviceHeadAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = section;
        [header addSubview:btn];
        [headview addSubview:header];
    }
    
    
    return headview;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    static NSString * footerID = @"footer";
    UITableViewHeaderFooterView * footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerID];
    if (!footView) {
        
        footView = [[UITableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54)];
    }
    for (UIView * view in footView.subviews) {
        [view removeFromSuperview];
        
    }
    if (_dataSource && _dataSource.count > 0) {
        OrderServiceFootView * footer = [[OrderServiceFootView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54)];
        footer.section = section;
        footer.delegate = self;
        footer.add_time = [NSString stringWithFormat:@"%@",_dataSource[section][@"add_time"]];
        footer.state = [_dataSource[section][@"status"] integerValue];
        [footView addSubview:footer];
    }
   
    return footView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 64;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 54;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(OrderServiceViewDidClickServiceOrderCell:)]) {
        [self.delegate OrderServiceViewDidClickServiceOrderCell:_dataSource[indexPath.section]];
    }
    
}
#pragma mark -- Action --
-(void)linkKefuAction:(UIButton *)sender
{
    NSLog(@"咨询客服");
    if ([self.delegate respondsToSelector:@selector(CustomerSerVice)]) {
        [self.delegate CustomerSerVice];
    }
}
-(void)serviceHeadAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(OrderServiceViewDidClickServiceOrderCell:)]) {
        [self.delegate OrderServiceViewDidClickServiceOrderCell:_dataSource[sender.tag]];
    }
}
/*
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView) {
        
        UITableView *tableview = (UITableView *)scrollView;
        CGFloat sectionHeaderHeight = 30;
        CGFloat sectionFooterHeight = 30;
        CGFloat offsetY = tableview.contentOffset.y;
        if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
        {
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
        }else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight)
        {
            tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
        }else if (offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height)
        {
            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
        }
    }
}
 */
#pragma mark -- 上拉刷新，下拉加载更多 --
-(void)refresh
{
    _start = 1;
    [_dataSource removeAllObjects];
    [self netWork];
    
}
-(void)loadMore
{
    _start = _start + 20;
    [self netWork];
}
#pragma mark -- 网络请求 --
-(void)GetOrderServicenNetWork
{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetOrderService" parameters:@{@"orderId":self.orderId} callBack:^(RequestResult result, id object) {
        NSLog(@"%@",object);
        if (result == RequestResultSuccess) {
            [_dataSource addObjectsFromArray:object[@"data"]];
            [_tableView reloadData];
        }
        else if (result == RequestResultEmptyData){
        }
        else if (result == RequestResultException){
        }
        else if (result == RequestResultFailed){
        }
    }];
}
-(void)netWork
{
   [BaseRequset sendPOSTRequestWithBMWApi2Method:@"ServiceList" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID/*@"25"*/,@"state":@"0",@"start":@(_start),@"limit":@"20"} callBack:^(RequestResult result, id object) {
        [_tableView.header endRefreshing];
        [_tableView.footer endRefreshing];
        NSLog(@"%@",object);
       if ([self.delegate respondsToSelector:@selector(orderServiceNetWorkSuccess)]) {
           [self.delegate orderServiceNetWorkSuccess];
       }
        
        if (result == RequestResultSuccess) {
            [self.noOrderView removeFromSuperview];
            self.noOrderView = nil;
            
            [_dataSource addObjectsFromArray:object[@"data"]];
            NSArray * arr = object[@"data"];
            if (arr.count < 20) {
                _tableView.footer.hidden = YES;
            }
            else{
                _tableView.footer.hidden = NO;
            }
            [_tableView reloadData];
        }
        else if (result == RequestResultEmptyData){
            if (_dataSource.count == 0 ) {
                _tableView.footer.hidden = YES;
                [self.noOrderView removeFromSuperview];
                self.noOrderView = nil;
                [_tableView addSubview:self.noOrderView];
                
            }
            
        }
        
        else if (result == RequestResultException){
        }
        
        else if (result == RequestResultFailed){
            if ([self.delegate respondsToSelector:@selector(orderServiceNetWorkFailed)]) {
                [self.delegate orderServiceNetWorkFailed];
            }
        
        }
        
    }];
}
#pragma mark -- OrderServiceFootViewDelegate --
/**
 * 取消订单
 */
-(void)OrderServiceFootViewDidClickCancelApply:(UIButton *)sender section:(NSInteger)section
{
    self.cancelSection = section;
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"取消订单" message:@"确定要取消此订单吗？" delegate:self cancelButtonTitle:@"暂不取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1000;
    [alertView show];
}
/**
 * 进度查询
 */
-(void)OrderServiceFootViewDidClickCancelApplyFollowUpProgress:(UIButton *)sender section:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(OrderServiceViewDidClickServiceOrderCell:)]) {
        [self.delegate OrderServiceViewDidClickServiceOrderCell:_dataSource[section]];
    }

    
}
/**
 * 删除订单
 */
-(void)OrderServiceFootViewDidClickDeleteServiceBtn:(UIButton *)sender section:(NSInteger)section
{
    self.delSection = section;
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"删除订单" message:@"确定要删除此订单吗？" delegate:self cancelButtonTitle:@"暂不取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1001;
    [alertView show];
}
#pragma mark -- UIAlertViewDelegate --
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        if (buttonIndex == 0) {
            
        }
        else{
            [MBProgressHUD showHUDAddedTo:self animated:YES];
            NSString * serviceId = _dataSource[self.cancelSection][@"id"];
            [BaseRequset sendPOSTRequestWithBMWApi2Method:@"ServiceCancel" parameters:@{@"serviceId":serviceId} callBack:^(RequestResult result, id object) {
                [MBProgressHUD hideHUDForView:self animated:YES];
                NSLog(@"%@",object);
                if (result == RequestResultSuccess) {
                    /*
                     [_dataSource removeObjectAtIndex:self.cancelSection];
                     [_tableView deleteSections:[NSIndexSet indexSetWithIndex:self.cancelSection] withRowAnimation:UITableViewRowAnimationFade];
                     */
                    [_dataSource removeAllObjects];
                    
                    if (self.orderServiceType == OrderServiceDefault) {
                        [self netWork];
                    }
                    else if (self.orderServiceType == OrderServiceInOrder){
                        [self GetOrderServicenNetWork];
                    }
                    
                }
                else{
                    SHOW_MSG(@"取消失败,稍后再试");
                }
                
            }];
            
        }
    }
    else{
        
        if (buttonIndex == 0) {
            
        }
        else{
            [MBProgressHUD showHUDAddedTo:self animated:YES];
            NSString * serviceId = _dataSource[self.delSection][@"id"];
            [BaseRequset sendPOSTRequestWithBMWApi2Method:@"ServiceDel" parameters:@{@"serviceId":serviceId} callBack:^(RequestResult result, id object) {
                [MBProgressHUD hideHUDForView:self animated:YES];
                NSLog(@"%@",object);
                if (result == RequestResultSuccess) {
                    
                     [_dataSource removeObjectAtIndex:self.delSection];
                     [_tableView deleteSections:[NSIndexSet indexSetWithIndex:self.delSection] withRowAnimation:UITableViewRowAnimationFade];
                    [_tableView reloadData];
                    if (_dataSource.count == 0) {
                        [_tableView addSubview:self.noOrderView];
                    }
                    
                }
                else{
                    SHOW_MSG(@"删除失败,稍后再试");
                }
                
            }];
            
        }
    
    }
    
}
-(UIView *)noOrderView{
    if (!_noOrderView) {
        _noOrderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 64)];
        _noOrderView.backgroundColor = [UIColor whiteColor];
        _noOrderView.hidden = NO;
        
        UIImageView *imageV = [UIImageView new];
        imageV.viewSize = CGSizeMake(100, 117);
        [imageV align:ViewAlignmentTopCenter relativeToPoint:CGPointMake(SCREEN_WIDTH/2, 70*W_ABCH)];
        imageV.image = IMAGEWITHNAME(@"icon_dingdan_wddd.png");
        [_noOrderView addSubview:imageV];
        
        
        UILabel *sorroyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 212*W_ABCH, SCREEN_WIDTH, 12)];
        sorroyLabel.textAlignment = NSTextAlignmentCenter;
        sorroyLabel.font = fontForSize(12);
        sorroyLabel.textColor = [UIColor colorWithHex:0x878787];
        sorroyLabel.text = @"没有订单";
        [_noOrderView addSubview:sorroyLabel];
        
    }
    return _noOrderView;
}

@end
