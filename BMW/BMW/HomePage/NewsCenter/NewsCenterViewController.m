//
//  NewsCenterViewController.m
//  BMW
//
//  Created by rr on 16/3/22.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "NewsCenterViewController.h"
#import "NewsCell.h"
#import "OrderDetailViewController.h"
//#import "ReadServiceOrderVC.h"
#import "ShowLogisticsInformationViewController.h"
#import "ApplyRIntroductionsViewController.h"
#import "ServicesProgressVC.h"
#import "CustomerserviceViewController.h"

@interface NewsCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property(nonatomic,copy)NSMutableArray * orderMessageArray;
@property(nonatomic,copy)NSMutableArray * informMessageArray;
@property(nonatomic,assign)NSInteger orderUnreadCount;
@property(nonatomic,assign)NSInteger informUnreadCount;
@end

@implementation NewsCenterViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.newsCenterType == NewsCenterDefault) {
        [self getOrderMessageNetWorkNum];
        [self getInformMessageNumNetWork];
    }
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    switch (self.newsCenterType) {
        case NewsCenterDefault:
            self.title = @"消息";
            //[self getOrderMessageNetWorkNum];
            //[self getInformMessageNumNetWork];
            [self getOrderMessage];
            [self getInformMessageArrayData];
             [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewsData) name:@"newsChange" object:nil];
            break;
        case NewsCenterVisitor:
            self.title = @"消息";
             [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewsData) name:@"newsChange" object:nil];
            break;
        case NewsCenterOrder:
            self.title = @"订单";
            [self initRightItem];
            [self getOrderMessage];
            break;
        case NewsCenterNotice:
            self.title = @"公告";
            [self initRightItem];
            break;
        case NewsCenterInform:
            self.title = @"通知";
            [self initRightItem];
            [self getInformMessageArrayData];
            break;
        default:
            break;
    }

    [self initLeftItem];
    [self initline];
    [self initUserInterFace];

    
}
-(void)initline
{
    UIView * lineView = [UIView new];
    lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
    lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self.view addSubview:lineView];
    [self.view bringSubviewToFront:lineView];
}
-(void)initLeftItem
{
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"icon_fanhui_gdtj.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(15, 0, 10, 18);
    UIBarButtonItem * backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backBtnItem;
    
}
-(void)initRightItem
{
    /*
    UIButton * clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setTitle:@"清空" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor colorWithHex:0x181818] forState:UIControlStateNormal];
    clearButton.titleLabel.font = fontForSize(13);
    clearButton.frame = CGRectMake(0, 0, 26, 18);
    UIBarButtonItem * clearBtnItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    //    [clearButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = clearBtnItem;
     */
}
-(void)initUserInterFace{
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH, SCREEN_HEIGHT - 64.5)];
    [_tableView registerClass:[NewsCell class] forCellReuseIdentifier:@"newsCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.scrollEnabled = NO;
    _tableView.backgroundColor = COLOR_BACKGRONDCOLOR;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark -- Action --
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- set ---
-(void)setWhereFrom:(BOOL)whereFrom{
    //YES就是订单NO就是消息
    _whereFrom = whereFrom;
}

-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [_tableView reloadData];
}
-(void)setNewsCenterType:(NewsCenterVCType)newsCenterType
{
    _newsCenterType = newsCenterType;
}

#pragma mark -- UITableViewDataSource --
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    switch (self.newsCenterType) {
        case NewsCenterDefault:return  3 ;break;
        case NewsCenterVisitor:return  1 ;break;
        case NewsCenterOrder:return _dataArray.count;break;
        case NewsCenterNotice:return _dataArray.count;break;
        case NewsCenterInform:return _dataArray.count;break;
        default:break;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66*W_ABCH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
    switch (self.newsCenterType) {
            
        case NewsCenterDefault:{
            
            if (indexPath.section == 0) {
                if (_orderMessageArray.count > 0) {
                    
                    NSDictionary * dic = (NSDictionary *)_orderMessageArray[0];
                    cell.titleLabel.text = @"订单";
                    [cell.titleLabel sizeToFit];
                    cell.titleLabel.viewHeight = 13*W_ABCW;
                    cell.detailLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKeyNotNull:@"title"] ];
                    cell.timeStr = [NSString stringWithFormat:@"%@",[dic objectForKeyNotNull:@"add_time"]];
                    if (self.orderUnreadCount) {
                        cell.numImage.hidden = NO;
                        cell.count = self.orderUnreadCount;
                    }else{
                        cell.numImage.hidden = YES;
                    }
                    cell.row.hidden = NO;
                }
                else{
                    cell.titleLabel.text = @"订单";
                    [cell.titleLabel sizeToFit];
                    cell.titleLabel.viewHeight = 13*W_ABCW;
                    cell.detailLabel.text = @"暂无消息";
                    cell.timeStr = @"";
                    cell.hideOrShow = NO;
                    cell.numImage.hidden = YES;
                    cell.row.hidden = YES;
                }
               
            }else if (indexPath.section == 1){
                if (self.noticeDataSource.count > 0) {
                     NSDictionary * dic = (NSDictionary *)self.noticeDataSource[0];
                    
                    cell.titleLabel.text = @"公告";
                    [cell.titleLabel sizeToFit];
                    cell.titleLabel.viewHeight = 13*W_ABCW;
                    cell.detailLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKeyNotNull:@"title"]];
                    cell.timeStr = [NSString stringWithFormat:@"%@",[dic objectForKeyNotNull:@"add_time"]];
                    if (self.noticeDataSource.count>0) {
                        cell.count = self.noticeDataSource.count;
                        cell.numImage.hidden = NO;
                    }else{
                        cell.numImage.hidden = YES;
                    }
                    cell.row.hidden = NO;
                }
                else{
                    cell.titleLabel.text = @"公告";
                    [cell.titleLabel sizeToFit];
                    cell.titleLabel.viewHeight = 13*W_ABCW;
                    cell.detailLabel.text = @"暂无公告";
                    cell.timeStr = @"";
                    cell.numImage.hidden = YES;
                    cell.row.hidden = YES;
                }
                
                
            }
            
            else if (indexPath.section == 2){
                
                if (self.informMessageArray.count >0) {
                    NSDictionary * dic = (NSDictionary *)self.informMessageArray[0];
                    
                    cell.titleLabel.text = @"通知";
                    [cell.titleLabel sizeToFit];
                    cell.titleLabel.viewHeight = 13*W_ABCW;
                    cell.detailLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKeyNotNull:@"title"]];
                    cell.timeStr = [NSString stringWithFormat:@"%@",[dic objectForKeyNotNull:@"add_time"]];
                    if (self.informUnreadCount) {
                        cell.numImage.hidden = NO;
                        cell.count = self.informUnreadCount;
                    }else{
                        cell.numImage.hidden = YES;
                    }
                    cell.row.hidden = NO;
                }
                else{
                    cell.titleLabel.text = @"通知";
                    [cell.titleLabel sizeToFit];
                    cell.titleLabel.viewHeight = 13*W_ABCW;
                    cell.detailLabel.text = @"暂无通知";
                    cell.timeStr = @"";
                    cell.hideOrShow = NO;
                    cell.numImage.hidden = YES;
                    cell.row.hidden = YES;
                }
                
            }
            
            
        };
        break;
        case NewsCenterVisitor:{
            if (self.noticeDataSource.count >0) {
                NSDictionary * dic = (NSDictionary *)self.noticeDataSource[0];
                
                cell.titleLabel.text = @"公告";
                [cell.titleLabel sizeToFit];
                cell.titleLabel.viewHeight = 13*W_ABCW;
                cell.detailLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKeyNotNull:@"title"]];
                cell.timeStr = [NSString stringWithFormat:@"%@",[dic objectForKeyNotNull:@"add_time"]];
                if (self.noticeDataSource.count>0) {
                    cell.numImage.hidden = NO;
                    cell.row.hidden = NO;
                    cell.count = self.noticeDataSource.count;
                }else{
                    cell.numImage.hidden = YES;
                    cell.row.hidden = YES;
                }
            }
            else{
                cell.titleLabel.text = @"公告";
                [cell.titleLabel sizeToFit];
                cell.titleLabel.viewHeight = 13*W_ABCW;
                cell.detailLabel.text = @"暂无公告";
                cell.timeStr = @"";
                cell.hideOrShow = YES;
                cell.row.hidden = YES;
            }
            
        };
            break;
            
            
        case NewsCenterOrder:{
            if (_dataArray.count > 0) {
                
                NSDictionary * dic = (NSDictionary *)_dataArray[indexPath.section];
                cell.titleLabel.text = @"订单";
                [cell.titleLabel sizeToFit];
                cell.titleLabel.viewHeight = 13*W_ABCW;
                cell.detailLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKeyNotNull:@"title"] ];
                cell.isread = [dic[@"is_read"] boolValue];
                cell.timeStr = [NSString stringWithFormat:@"%@",[dic objectForKeyNotNull:@"add_time"]];
                cell.row.hidden = NO;
            }
            cell.hideOrShow = YES;
            
        };
        break;
            
            
        case NewsCenterNotice:{
            if (_dataArray && _dataArray.count > 0) {
                cell.hideOrShow = YES;
                cell.titleLabel.text = @"公告";
                [cell.titleLabel sizeToFit];
                cell.titleLabel.viewHeight = 13*W_ABCW;
                cell.detailLabel.text = _dataArray[indexPath.section][@"title"];
                cell.row.hidden = NO;
            }
            else{
                cell.hideOrShow = YES;
                cell.titleLabel.text = @"公告";
                [cell.titleLabel sizeToFit];
                cell.titleLabel.viewHeight = 13*W_ABCW;
                cell.detailLabel.text = @"暂无公告";
                cell.row.hidden = YES;
            }
           
        };
        break;
            
            
        case NewsCenterInform:{
            cell.titleLabel.text = @"通知";
            [cell.titleLabel sizeToFit];
            cell.titleLabel.viewHeight = 13*W_ABCW;
            cell.detailLabel.text = _dataArray[indexPath.section][@"title"];
            cell.isread = [_dataArray[indexPath.section][@"is_read"] boolValue];
            NSInteger type = [_dataArray[indexPath.section][@"message_type"] integerValue];
            cell.numImage.hidden = YES;
            if (type == 2) {
                cell.row.hidden = NO;
            }
            else{
                cell.row.hidden = NO;
            }
        };
        break;
        default:break;
    }
    
    return cell;
}
#pragma mark -- UITableViewDelegate --
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    switch (self.newsCenterType) {
        case NewsCenterDefault:return 10*W_ABCH;break;
        case NewsCenterVisitor:return 10*W_ABCH;break;
        case NewsCenterOrder:return 35*W_ABCH ;break;
        case NewsCenterNotice:return 35*W_ABCH;break;
        case NewsCenterInform:return 35*W_ABCH;break;
        default:break;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerV = nil;
    
    if (self.newsCenterType == NewsCenterDefault) {
        headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10*W_ABCH)];
    }
    else if (self.newsCenterType == NewsCenterVisitor){
        headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10*W_ABCH)];
    }
    else{
        headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35*W_ABCH)];
    }
    
    headerV.backgroundColor = COLOR_BACKGRONDCOLOR;
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, headerV.viewHeight)];
    //timeLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.font = fontForSize(11);
    timeLabel.textAlignment = NSTextAlignmentCenter;
        switch (self.newsCenterType) {
        case NewsCenterDefault:;break;
        case NewsCenterVisitor:;break;
        case NewsCenterOrder:{
            
            if (_dataArray.count > 0) {
                
                 timeLabel.text = [NSString stringWithFormat:@"%@",[TYTools getTimeToShowWithTimestamp:_dataArray[section][@"add_time"]]];
            }
            [headerV addSubview:timeLabel];
            break;
        }
            case NewsCenterNotice:{
                
                if (_dataArray.count > 0) {
                    timeLabel.text = [NSString stringWithFormat:@"%@",[TYTools getTimeToShowWithTimestamp:_dataArray[section][@"add_time"]]];
                }
//                [headerV addSubview:timeLabel];
                break;
            }
           
            case NewsCenterInform:{
                if (_dataArray.count > 0) {
                timeLabel.text = [NSString stringWithFormat:@"%@",[TYTools getTimeToShowWithTimestamp:_dataArray[section][@"add_time"]]];
            }
                [headerV addSubview:timeLabel];;
                
                break;
            }
        default:break;
    }
    return headerV;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    switch (self.newsCenterType) {
        case NewsCenterDefault:{
            if (indexPath.section == 0) {
                
                if (self.orderMessageArray.count > 0) {
                    NewsCenterViewController *newsVC = [[NewsCenterViewController alloc] init];
                    newsVC.newsCenterType = NewsCenterOrder;
                    //newsVC.dataArray = self.orderMessageArray;
                    [self.navigationController pushViewController:newsVC animated:YES];
                }
               
            }
            else if (indexPath.section == 1){
                if (self.noticeDataSource.count > 0) {
                    NewsCenterViewController *newsVC = [[NewsCenterViewController alloc] init];
                    newsVC.newsCenterType = NewsCenterNotice;
                    newsVC.dataArray = [NSMutableArray arrayWithArray:self.noticeDataSource];
                    [self.navigationController pushViewController:newsVC animated:YES];
                }
                
            }
            else if (indexPath.section == 2){
                if (self.informMessageArray.count > 0) {
                    NewsCenterViewController *newsVC = [[NewsCenterViewController alloc] init];
                    newsVC.newsCenterType = NewsCenterInform;
                    //newsVC.dataArray = self.informMessageArray;
                    [self.navigationController pushViewController:newsVC animated:YES];
                }
               
            }
        }
            break;
        case NewsCenterVisitor:{
            if (indexPath.section == 0) {
                if (self.noticeDataSource.count > 0) {
                    NewsCenterViewController *newsVC = [[NewsCenterViewController alloc] init];
                    newsVC.newsCenterType = NewsCenterNotice;
                    newsVC.dataArray = [NSMutableArray arrayWithArray:self.noticeDataSource];
                    [self.navigationController pushViewController:newsVC animated:YES];
                }
              
            }
        }
            break;
        case NewsCenterOrder:{
            if (_dataArray.count > 0) {
                NSDictionary * dic = _dataArray[indexPath.section];
                NSInteger message_type = [dic[@"message_type"] integerValue];
                switch (message_type) {
                    case 1:{
                        OrderDetailViewController * orderDetailVC =[[OrderDetailViewController alloc]init];
                        orderDetailVC.orderId = dic[@"to_sn"];
                        [self isreadMessageWithId:dic[@"id"] type:@""];
                        [self.navigationController pushViewController:orderDetailVC animated:YES];
                    }
                    break;
                    case 3:{
                        ShowLogisticsInformationViewController * logisticsVC =[[ShowLogisticsInformationViewController alloc]init];
                        logisticsVC.orderId = dic[@"to_sn"];
                         [self isreadMessageWithId:dic[@"id"] type:@""];
                        [self.navigationController pushViewController:logisticsVC animated:YES];
                        
                    }
                        break;
                        
                    default:
                        break;
                }
            }
        
        }
            break;
        case NewsCenterNotice:{
            [BaseRequset sendPOSTRequestWithBMWApi2Method:@"MessageCon" parameters:@{@"messageId":_dataArray[indexPath.section][@"message_id"]} callBack:^(RequestResult result, id object) {
                if (result == RequestResultSuccess) {
                    CustomerserviceViewController *Message = [[CustomerserviceViewController alloc] init];
                    Message.title = @"公告";
                    Message.htmlString = [object[@"data"] objectForKeyNotNull:@"body"];
                    Message.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:Message animated:YES];

                }
            }];
            
        }
            break;
        case NewsCenterInform:{
            
            if (_dataArray.count > 0) {
                NSDictionary * dic = _dataArray[indexPath.section];
                NSInteger message_type = [dic[@"message_type"] integerValue];
                switch (message_type) {
                    case 2:{
                        ServicesProgressVC * servicesProgressVC = [[ServicesProgressVC alloc]init];
                        servicesProgressVC.serviceId = dic[@"to_sn"];
                        [self isreadMessageWithId:dic[@"id"] type:@""];
                        [self.navigationController pushViewController:servicesProgressVC animated:YES];
                    }
                        break;
                    case 4:{
                        [self isreadMessageWithId:dic[@"id"] type:@""];
                        [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetMessage" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"id":dic[@"id"],@"type":@"2"} callBack:^(RequestResult result, id object) {
                            NSLog(@"%@",object);
                            if (result == RequestResultSuccess) {
                                ApplyRIntroductionsViewController *applyIntro = [[ApplyRIntroductionsViewController alloc] init];
                                applyIntro.title = object[@"data"][@"title"];
                                applyIntro.contentString = object[@"data"][@"body"];
                                applyIntro.hidesBottomBarWhenPushed = YES;
                                [self.navigationController pushViewController:applyIntro animated:YES];
                                
                            }
                            else if (result == RequestResultEmptyData){
                                
                            }
                            else if (result == RequestResultException){
                                
                            }
                            else if (result == RequestResultFailed){
                                
                            }
                        }];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            
        }
            break;
        
            
        default:
            break;
    }
   
}

#pragma mark -- UIScrollerView --
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 35*W_ABCH;
   
    if (self.newsCenterType == NewsCenterDefault || self.newsCenterType == NewsCenterVisitor) {
        sectionHeaderHeight = 10*W_ABCH;
    }
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
#pragma mark -- 网络请求 --
//回传id 设置已读
-(void)isreadMessageWithId:(NSString *)ID type:(NSString *)type
{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetMessage" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"id":ID,@"type":type} callBack:^(RequestResult result, id object) {
        
        NSLog(@"%@",object);
        
        if (result == RequestResultSuccess) {
            if (self.newsCenterType == NewsCenterOrder) {
                [self getOrderMessage];
            }
            else if (self.newsCenterType == NewsCenterInform){
                [self getInformMessageArrayData];
            }
            
        }
        else if (result == RequestResultEmptyData){
            
        }
        else if (result == RequestResultException){
            
        }
        else if (result == RequestResultFailed){
            
        }
        
    }];
}

-(void)getOrderMessage
{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetMessage" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"id":@"",@"type":@"1"} callBack:^(RequestResult result, id object) {
        
        NSLog(@"%@",object);
        
        if (result == RequestResultSuccess) {
           
            if (self.newsCenterType == NewsCenterDefault) {
                 _orderMessageArray = object[@"data"];
            }
            else{
                _dataArray = object[@"data"];
            }
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
-(void)getInformMessageArrayData
{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetMessage" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"id":@"",@"type":@"2"} callBack:^(RequestResult result, id object) {
        
        NSLog(@"%@",object);
        
        if (result == RequestResultSuccess) {
            if (self.newsCenterType == NewsCenterDefault) {
                _informMessageArray = object[@"data"];
            }
            else{
                _dataArray = object[@"data"];
            }
            
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
#pragma mark -- 获取消息未读数量 --
-(void)getOrderMessageNetWorkNum
{
    if ([JCUserContext sharedManager].isUserLogedIn) {
        [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetMessageNum" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"type":@"1"} callBack:^(RequestResult result, id object) {
            NSLog(@"%@",object);
            if (result == RequestResultSuccess) {
                NSInteger newsCount = [object[@"data"] integerValue];
                if (newsCount > 0) {
                   
                    self.orderUnreadCount = newsCount;
                    
                }
                
            }
            else if (result == RequestResultEmptyData){
                self.orderUnreadCount = 0;
                
            }
            else if (result == RequestResultException){
            }
            
            else if (result == RequestResultFailed){
                
            }
            [_tableView reloadData];
        }];
    }
    
}
-(void)getInformMessageNumNetWork
{
    if ([JCUserContext sharedManager].isUserLogedIn) {
        [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetMessageNum" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"type":@"2"} callBack:^(RequestResult result, id object) {
            NSLog(@"%@",object);
            if (result == RequestResultSuccess) {
                NSInteger newsCount = [object[@"data"] integerValue];
                if (newsCount > 0) {
                    
                    self.informUnreadCount = newsCount;
                }
                
            }
            else if (result == RequestResultEmptyData){
                self.informUnreadCount = 0;
            }
            else if (result == RequestResultException){
            }
            
            else if (result == RequestResultFailed){
            }
            
            [_tableView reloadData];
        }];
    }
    
}
-(void)refreshNewsData
{
    if (self.newsCenterType == NewsCenterDefault) {
        [self getOrderMessageNetWorkNum];
        [self getInformMessageNumNetWork];
        [self getOrderMessage];
        [self getInformMessageArrayData];
    }
    else if (self.newsCenterType == NewsCenterOrder){
         [self getOrderMessage];
    }
    else if (self.newsCenterType == NewsCenterInform){
        [self getInformMessageArrayData];
    }
    
}

@end


