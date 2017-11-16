//
//  ServicesProgressVC.m
//  BMW
//
//  Created by gukai on 16/3/23.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ServicesProgressVC.h"
#import "ServicesProCell.h"
#import "ServiceProHead.h"
#import "ServiceProFoot.h"
#import "LogisticsCell.h"

@interface ServicesProgressVC ()<UITableViewDataSource,UITableViewDelegate>
{
     NSArray * _wuliuArray;
}
@property(nonatomic,copy)NSArray * goodsArray;
@property(nonatomic,copy)NSMutableArray * recordArray;
@property(nonatomic,copy)NSDictionary * dataDic;
@property(nonatomic,strong)UITableView * tableView;
@end
@implementation ServicesProgressVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initLine];
    [self initUserInterface];
    [self netWork];
}
-(void)initData
{
     //_recordArray = @[@{@"description":@"正在准备退款", @"add_time":@"2015-11-13 21:09:09"}, @{@"description":@"初审已通过", @"add_time":@"2015-11-13 21:09:09"}, @{@"description":@"你的服务单已成功提交", @"add_time":@"2015-11-13 21:09:09"}];
}
-(void)initLine
{
    //导航栏分割线
    UIView * lineView = [UIView new];
    lineView.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
    [lineView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
    lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self.view addSubview:lineView];
    [self.view bringSubviewToFront:lineView];
}
-(void)initUserInterface
{
    self.title = @"申请详情";
    [self initLeftItem];
    [self initTableView];
}
-(void)initLeftItem
{
    //配置导航栏的左侧返回按钮
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"icon_fanhui_gdtj.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(15, 0, 10, 18);
    UIBarButtonItem * backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backBtnItem;
}
-(void)initTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 0.5)];
    _tableView.backgroundColor = [UIColor colorWithHex:0xf1f1ed];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
#pragma mark -- UITableViewDataSource --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (!_goodsArray || _goodsArray.count == 0) {
            return 0;
        }
        return _goodsArray.count;
    }
    else if (section == 1){
        if (!_recordArray || _recordArray.count == 0) {
            return 0;
        }
        
        return _recordArray.count;
    }
    return 0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * goodsCellID = @"goodsCell";
    static NSString * logisticsCellID = @"logisticsCell";
    if (indexPath.section == 0) {
        ServicesProCell * cell = [tableView dequeueReusableCellWithIdentifier:goodsCellID];
        if (!cell) {
            cell = [[ServicesProCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:goodsCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (_goodsArray.count > 0) {
            cell.dataDic = _goodsArray[indexPath.row];
        }
        
        return cell;
    }else {
        LogisticsCell * cell = [tableView dequeueReusableCellWithIdentifier:logisticsCellID];
        if (!cell) {
            cell = [[LogisticsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:logisticsCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (_recordArray && _recordArray.count > 0) {
            cell.index =indexPath;
            cell.dataDic = _recordArray[indexPath.row];
            if (indexPath.row == _recordArray.count - 1) {
                cell.lastBottomLine.hidden = NO;
                
            }
            else{
                cell.lastBottomLine.hidden = YES;
            }

        }
        return cell;
    }
}
#pragma mark -- UITableViewDelegate --
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_goodsArray && _goodsArray.count > 0) {
            CGRect rect  = [TYTools boundingString:_goodsArray[indexPath.row][@"goods_name"] size:CGSizeMake(SCREEN_WIDTH - 30, 2000) fontSize:12];
            CGFloat cellNewHeight = rect.size.height + 38;
            return cellNewHeight;
        }
        else
        {
            return 50;
        }
      
    }
    else if (indexPath.section == 1){
        if (_recordArray && _recordArray.count > 0) {
            CGRect rect  = [TYTools boundingString:_recordArray[indexPath.row][@"description"] size:CGSizeMake(SCREEN_WIDTH - 27 - 56, 2000) fontSize:12];
            CGFloat cellNewHeight = rect.size.height + 53;
            return cellNewHeight;
        }
        else{
            return 50;
        }
       
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    if (section == 0) {
       
        if (_dataDic && _dataDic.allKeys.count > 0) {
            ServiceProHead * head = [[ServiceProHead alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
            head.service_num = [NSString stringWithFormat:@"%@",_dataDic[@"service_num"]];
            head.state = [_dataDic[@"status"] integerValue];
            return head;
            
        }
        return nil;
    }else
    {
        UIView * speace = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        speace.backgroundColor = [UIColor colorWithHex:0xf1f1ed];
        
        return speace;
        
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
//        static NSString * footerID = @"footer";
//        UITableViewHeaderFooterView * footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerID];
//        if (!footView) {
//            
//            footView = [[UITableViewHeaderFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56)];
//        }
//        for (UIView * view in footView.subviews) {
//            [view removeFromSuperview];
//            
//        }
        NSString * reply_message = [_dataDic objectForKeyNotNull:@"reply_message"];
        
        if (reply_message && reply_message.length >0) {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 56)];
            label.font = fontForSize(10);
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
            label.text = [_dataDic objectForKeyNotNull:@"reply_message"];
            [label sizeToFit];
            ServiceProFoot * foot = [[ServiceProFoot alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, label.bounds.size.height + 30)];
            foot.reply_message = reply_message;
            return foot;
        }
        else{
            return nil;
        }
        
        
       

        
       
        //[footView addSubview:foot];
       
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
         return 36;
    }
    else
    {
        return 10;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        NSString * reply_message = [_dataDic objectForKeyNotNull:@"reply_message"];
        
        if (reply_message && reply_message.length >0) {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 56)];
            label.font = fontForSize(10);
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
            label.text = [_dataDic objectForKeyNotNull:@"reply_message"];
            [label sizeToFit];
            return label.bounds.size.height + 30;
            
        }
        else{
            return 0;
        }
    }
    return 0;
    
}

#pragma mark -- Action --
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 网络请求 --
-(void)netWork
{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"ServiceDetail" parameters:@{@"serviceId":self.serviceId} callBack:^(RequestResult result, id object) {
        NSLog(@"%@",object);
        if (result == RequestResultSuccess) {
            _dataDic = object[@"data"];
            [self getGoodsAndLogisticsRecordFromDataDic:_dataDic];
            
        }
        else if (result == RequestResultEmptyData){
            
        }
        else if (result == RequestResultException){
            
        }
        else if (result == RequestResultFailed){
            
        }
        
        
    }];
}
-(void)getGoodsAndLogisticsRecordFromDataDic:(NSDictionary *)dataDic
{
    _goodsArray = [NSArray arrayWithArray:dataDic[@"goods"]];
    NSArray * arr = [NSArray arrayWithArray:dataDic[@"record"]];
    _recordArray = [NSMutableArray arrayWithArray:arr];
    /*
    for (NSInteger i = arr.count - 1; i > -1; i--) {
        [_recordArray addObject:arr[i]];
    }
     */
    
    [_tableView reloadData];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 36;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
@end
