//
//  MyOrderViewController.m
//  BMW
//
//  Created by rr on 16/3/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyorderTableViewCell.h"
#import "OrderDetailViewController.h"
#import "OrderEvaluateViewController.h"
#import "OrderServiceView.h"
#import "ServicesProgressVC.h"

#import "ApplyRefund/ApplyRefundViewController.h"
#import "ShowLogisticsInformationViewController.h"      //查看物流信息
#import "CustomerserviceViewController.h"

//#import "ChoosePayWayViewController.h"                  //支付选择
#import "PayMethodViewController.h"                       // 新的支付界面


@interface MyOrderViewController ()<UITableViewDataSource,UITableViewDelegate,MyorderTableViewCellDelegate,OrderServiceViewDelegate,UIAlertViewDelegate,NoNetDelegate>
{
    NSArray *_stateArray;
    UITableView *_tableView;
    
    UIButton *_goodsOrderB;
    UIButton *_serviceOrderB;
    
    NSInteger _count;
    NSMutableArray *_dataArray;
    
    NSDictionary * _deleteOrderDic;
    
}
@property(nonatomic,strong)OrderServiceView * orderService;
@property(nonatomic,strong)UIView * firstView;
@property(nonatomic,strong)UIView *noOrderView;

@property(nonatomic,strong)NSDictionary *confirmDic;

@property(nonatomic,strong)UIButton * selectedBtn;

@property(nonatomic,assign)BOOL noNetWork;

@property (nonatomic, strong) UIView * line; /**< 导航栏 */

@end

@implementation MyOrderViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self customNavigationBar];
    [self initData];
    [self initUserInterface];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetWorkingState) name:kReachabilityChangedNotification object:nil];
    
    [self checkConnection:^(ConnectionType type) {
        if (type == ConnectionTypeNone ) {
            NSLog(@"无网");
            self.noNetWork = YES;
            [self showNoNetOnView:self.view frame:_tableView.frame type:NoNetDefault delegate:self];
            [self.view bringSubviewToFront:self.noNet];
        }
        else if (type == ConnectionTypeWifi){
            NSLog(@"wifi");
            self.noNetWork = NO;
            
        }
        else if (type == ConnectionTypeData){
            NSLog(@"2g/3g");
            self.noNetWork = NO;
        }
    }];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshList];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- notification
- (void)checkNetWorkingState
{
    [self checkConnection:^(ConnectionType type) {
        if (type == ConnectionTypeNone ) {
            NSLog(@"无网");
            self.noNetWork = YES;
            [self showNoNetOnView:self.view frame:_tableView.frame type:NoNetDefault delegate:self];
            [self.view bringSubviewToFront:self.noNet];
        }
        else if (type == ConnectionTypeWifi){
            NSLog(@"wifi");
            self.noNetWork = NO;
            
        }
        else if (type == ConnectionTypeData){
            NSLog(@"2g/3g");
            self.noNetWork = NO;
        }
    }];
}

#pragma mark -- actions
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 界面
/**
 *  自定义导航栏
 */
- (void)customNavigationBar {
    //导航栏分割线
    UIView * lineView = [UIView new];
    lineView.viewSize = CGSizeMake(SCREEN_WIDTH, 1);
    [lineView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
    lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self.view addSubview:lineView];
    [self.view bringSubviewToFront:lineView];
    
    // titleView
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    self.navigationItem.titleView = titleView;
    //配置导航栏的左侧返回按钮
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"icon_fanhui_gdtj.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(9, 13, 10, 18);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:backButton];
    UIButton *bigButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    [bigButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:bigButton];
    
    _goodsOrderB = [[UIButton alloc] initWithFrame:CGRectMake(titleView.viewWidth/2-80, 0, 68, 44)];
    [_goodsOrderB setTitle:@"商品订单" forState:UIControlStateNormal];
    _goodsOrderB.selected = YES;
    [_goodsOrderB setTitleColor:COLOR_NAVIGATIONBAR_ITEM forState:UIControlStateSelected];
    _goodsOrderB.titleLabel.font = fontForSize(17);
    [_goodsOrderB sizeToFit];
    _goodsOrderB.viewHeight = 44;
    [_goodsOrderB addTarget:self action:@selector(goodsOrder) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:_goodsOrderB];
    self.selectedBtn = _goodsOrderB;
    
    _serviceOrderB = [[UIButton alloc] initWithFrame:CGRectMake(titleView.viewWidth/2+13, 0, 68, 44)];
    [_serviceOrderB setTitle:@"服务订单" forState:UIControlStateNormal];
    [_serviceOrderB setTitleColor:COLOR_NAVIGATIONBAR_ITEM forState:UIControlStateSelected];
    _serviceOrderB.titleLabel.font = fontForSize(17);
    [_serviceOrderB sizeToFit];
    _serviceOrderB.viewHeight = 44;
    [_serviceOrderB addTarget:self action:@selector(serviceOrder) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:_serviceOrderB];

    _line = [[UIView alloc] initWithFrame:CGRectMake(_goodsOrderB.viewX, _goodsOrderB.viewBottomEdge - 6, _goodsOrderB.viewWidth, 1.5)];
    _line.backgroundColor = [UIColor whiteColor];
    [titleView addSubview:_line];
}
/**
 *  数据初始化
 */
-(void)initData{
    _stateArray = @[@"全部",@"待付款",@"待发货",@"待收货",@"待评价"];
    _count = 1;
    _dataArray = [NSMutableArray array];
    _confirmDic = [NSDictionary dictionary];
}

-(void)noOrder{
    _tableView.hidden = YES;
    _noOrderView.hidden = NO;
}
/**
 *  界面初始化
 */
-(void)initUserInterface{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    view.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self.view addSubview:view];
    self.firstView = view;
    [self.view addSubview:self.noOrderView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 38*W_ABCH)];
    topView.backgroundColor = [UIColor colorWithHex:0xfffaf3];
    [view addSubview:topView];
    CGFloat item = SCREEN_WIDTH/5;
    for (int i = 0; i<5; i++) {
        UIButton *stateButton = [[UIButton alloc] initWithFrame:CGRectMake(item*i, 1, item, 38*W_ABCH)];
        if (i==0) {
            stateButton.selected = YES;
        }
        stateButton.tag = 100+i;
        [stateButton setTitle:_stateArray[i] forState:UIControlStateNormal];
        [stateButton setTitleColor:[UIColor colorWithHex:0xfd5487] forState:UIControlStateSelected];
        [stateButton setTitleColor:[UIColor colorWithHex:0x181818] forState:UIControlStateNormal];
        stateButton.titleLabel.font = fontForSize(14);
        [stateButton addTarget:self action:@selector(chooseState:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:stateButton];
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, topView.viewBottomEdge, SCREEN_WIDTH, 0.5*W_ABCH)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [view addSubview:line];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, line.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT-64-38*W_ABCH)];
    _tableView.backgroundColor = COLOR_BACKGRONDCOLOR;
    [_tableView registerClass:[MyorderTableViewCell class] forCellReuseIdentifier:@"orderCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshList)];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    _tableView.legendFooter.hidden = YES;
    [view addSubview:_tableView];
    
}

/**
 *  没有订单的视图
 */
-(UIView *)noOrderView{
    if (!_noOrderView) {
        _noOrderView = [[UIView alloc] initWithFrame:CGRectMake(0, 38*W_ABCH, SCREEN_WIDTH, SCREEN_HEIGHT-38*W_ABCH)];
        _noOrderView.backgroundColor = [UIColor whiteColor];
        _noOrderView.hidden = YES;
        
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

-(void)setOrderState:(NSString *)orderState{
    _orderState = orderState;
    for (int i = 100; i<105; i++) {
        UIButton *stateB = [self.view viewWithTag:i];
        stateB.selected = NO;
    }
    UIButton *stateB = [self.view viewWithTag:[orderState integerValue]+100];
    stateB.selected = YES;
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"OrderList" parameters:@{@"state":_orderState,@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"start":@"1",@"limit":@"20"} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        [self hideNoNet];
        self.noNetWork = NO;
        [_dataArray removeAllObjects];
        if (result == RequestResultSuccess) {
            [_dataArray addObjectsFromArray:object[@"data"]];
            _tableView.hidden = NO;
            _noOrderView.hidden = YES;
            if (_dataArray.count < 4 ) {
                _tableView.footer.hidden = YES;
            }
            else{
                _tableView.footer.hidden = NO;
            }
        }else if (result == RequestResultEmptyData){
            if (_dataArray.count == 0) {
                _tableView.footer.hidden = YES;
                [self noOrder];
            }
        }
        else if (result == RequestResultFailed){
            self.noNetWork = YES;
            [self showNoNetOnView:self.view frame:_tableView.frame type:NoNetDefault delegate:self];
            [self.view bringSubviewToFront:self.noNet];
        }
        [_tableView reloadData];
    }];
    
    if ([_orderState integerValue] == 5) {
        UIButton *stateB = [self.view viewWithTag:100];
        stateB.selected = YES;
        _goodsOrderB.selected = NO;
        _serviceOrderB.selected = YES;
        [self.view bringSubviewToFront:self.orderService];
        self.selectedBtn = _serviceOrderB;
        if (self.noNetWork) {
            [self.view bringSubviewToFront:self.noNet];
        }
        
        
    }
}

#pragma mark -- 点击事件 --
- (void)animationOfLine
{
    [UIView animateWithDuration:0.3 animations:^{
        self.line.frame = CGRectMake(self.selectedBtn.viewX, self.line.viewY, self.line.viewWidth, self.line.viewHeight);
    }];
}
/**
 *  点击商品订单
 */
-(void)goodsOrder{
    _goodsOrderB.selected = YES;
    _serviceOrderB.selected= NO;
    [self.view bringSubviewToFront:self.firstView];
    [self.orderService removeFromSuperview];
    self.orderService = nil;
    [self.view bringSubviewToFront:self.noOrderView];
    self.selectedBtn = _goodsOrderB;
    
    if (self.noNetWork) {
        self.noNet.frame = _tableView.frame;
        [self.view bringSubviewToFront:self.noNet];
    }
    [self animationOfLine];
}

/**
 *  点击服务订单
 */
-(void)serviceOrder{
    _goodsOrderB.selected = NO;
    _serviceOrderB.selected = YES;
    [self.view bringSubviewToFront:self.noOrderView];
    [self.view bringSubviewToFront:self.orderService];
    self.selectedBtn = _serviceOrderB;
    if (self.noNetWork) {
        self.noNet.frame = self.orderService.frame;
        [self.view bringSubviewToFront:self.noNet];
    }
    [self animationOfLine];
}
/**
 *  切换类目
 */
-(void)chooseState:(UIButton *)sender{
    for (int i = 100; i<105; i++) {
        UIButton *stateB = [self.view viewWithTag:i];
        stateB.selected = NO;
    }
    sender.selected = YES;
    _orderState = [NSString stringWithFormat:@"%ld",sender.tag-100];
    NSLog(@"切换类目");
    [_dataArray removeAllObjects];
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"OrderList" parameters:@{@"state":_orderState,@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"start":@"1",@"limit":@"20"} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        [self hideNoNet];
        self.noNetWork = NO;
        if (result == RequestResultSuccess) {
            [_dataArray addObjectsFromArray:object[@"data"]];
            _tableView.hidden = NO;
            _noOrderView.hidden = YES;
            if (_dataArray.count < 4 ) {
                _tableView.footer.hidden = YES;
            }
            else{
                _tableView.footer.hidden = NO;
            }
            
        }
        else if (result == RequestResultEmptyData){
            if (_dataArray.count == 0) {
                _tableView.footer.hidden = YES;
                [self noOrder];
            }
            
        }
        else if (result == RequestResultFailed){
            self.noNetWork = YES;
            [self showNoNetOnView:self.view frame:_tableView.frame type:NoNetDefault delegate:self];
            [self.view bringSubviewToFront:self.noNet];
        }
        [_tableView reloadData];
    }];
    
}

#pragma mark -- UITableViewDataSource,UITableViewDelegate --
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_dataArray && _dataArray.count > 0) {
        return _dataArray.count;
    }
    return 0;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArray && _dataArray.count > 0) {
        return [_dataArray[section][@"goods"] count] + 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataArray && _dataArray.count > 0) {
        if(indexPath.row == [_dataArray[indexPath.section][@"goods"] count]) {
            return 54;
        }
    }
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyorderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.index = indexPath;
    cell.backgroundColor = [UIColor whiteColor];
    if (_dataArray.count>0) {
        NSArray *goodsArray = _dataArray[indexPath.section][@"goods"];
        if(indexPath.row == [_dataArray[indexPath.section][@"goods"] count]){
            cell.backgroundColor = [UIColor whiteColor];
            cell.type = _dataArray[indexPath.section][@"order_state"];
            cell.lastDic = _dataArray[indexPath.section];
        }else{
            cell.goodsDic = goodsArray[indexPath.row];
        }
        
        WEAK_SELF;
        __block NSMutableArray * dataArray = _dataArray;
        //准备服务订单
        [cell setCrectaServiceO:^{
            [weakSelf.HUD show:YES];
            [BaseRequset sendPOSTRequestWithBMWApi2Method:@"ServiceReady" parameters:@{@"orderId":dataArray[indexPath.section][@"order_id"]} callBack:^(RequestResult result, id object) {
                [weakSelf.HUD hide:YES];
                if (result == RequestResultSuccess) {
                    ApplyRefundViewController *applyVC = [[ApplyRefundViewController alloc] init];
                    applyVC.dataDic = dataArray[indexPath.section];
                    applyVC.dataArray = object[@"data"];
                    [weakSelf.navigationController pushViewController:applyVC animated:YES];
                }else if(result == RequestResultEmptyData){
                    SHOW_EEROR_MSG(@"服务订单已经生成");
                }
            }];
            
        }];
        //提醒发货
        [cell setRemindSend:^{
            [BaseRequset sendPOSTRequestWithBMWApi2Method:@"RemindSend" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"orderId":dataArray[indexPath.section][@"order_id"]} callBack:^(RequestResult result, id object) {
                if (result==RequestResultSuccess) {
                    SHOW_MSG(@"提醒成功");
                }
            }];
        }];
        //取消订单
        [cell setCancleOrder:^{
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"取消订单" message:@"确定取消此订单吗？" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:@"暂不取消", nil];
            alterView.tag = 101;
            weakSelf.confirmDic = dataArray[indexPath.section];
            [alterView show];
        }];
        //删除订单
        [cell setDeleteOrder:^{
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"删除订单" message:@"确定删除此订单吗？" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alterView.tag = 111;
            weakSelf.confirmDic = dataArray[indexPath.section];
//            _deleteOrderDic = [NSDictionary dictionaryWithDictionary:dataArray[indexPath.section]];
            [alterView show];
        }];
        //倒计时结束
        [cell setCountdownOver:^{
            NSLog(@"倒计时结束了，快去刷新界面");
            [weakSelf refreshList];
        }];
        //确认收货
        [cell setConfirm:^{
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"确认收货" message:@"确认已经收到此商品吗" delegate:weakSelf cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
            alterView.tag = 110;
            weakSelf.confirmDic = dataArray[indexPath.section];
            [alterView show];
        }];
        //查看物流
        [cell setWayInfo:^{
            ShowLogisticsInformationViewController * wayInfoVC = [[ShowLogisticsInformationViewController alloc] init];
            wayInfoVC.orderId = dataArray[indexPath.section][@"order_id"];
            [weakSelf.navigationController pushViewController:wayInfoVC animated:YES];
        }];
        //支付跳转
        [cell setPaymentButton:^{
            NSDictionary * dataDic = dataArray[indexPath.section];
            PayMethodViewController * payMethodVC = [[PayMethodViewController alloc] init];
            payMethodVC.isPopRoot = NO;
            payMethodVC.totalCash = dataDic[@"order_amount"];
            payMethodVC.orderTime = dataDic[@"add_time"];
            payMethodVC.orderNum  = dataDic[@"order_sn"];
            payMethodVC.orderPaySn = dataDic[@"pay_sn"];
            payMethodVC.orderID   = dataDic[@"order_id"];
//            ChoosePayWayViewController * choosePayWayVC = [[ChoosePayWayViewController alloc] init];
//            choosePayWayVC.dataSourceDic = [NSMutableDictionary dictionaryWithDictionary:dataArray[indexPath.section]];
//            choosePayWayVC.isPopRootVC = NO;
            NSArray *test =  dataArray[indexPath.section][@"goods"];
            if ([test[0][@"send_code"] isKindOfClass:[NSNull class]] || ((NSString *)test[0][@"send_code"]).length == 0) {
                //不是海外
//                choosePayWayVC.isOnePayWay = NO;
                payMethodVC.isAPay = NO;
            }
            else if ([test[0][@"send_code"] isEqualToString:@"G"]||[test[0][@"send_code"] isEqualToString:@"g"]){
                //海外
//                choosePayWayVC.isOnePayWay = YES;
                payMethodVC.isAPay = YES;
            }
            else {
//                choosePayWayVC.isOnePayWay = NO;
                payMethodVC.isAPay = NO;
            }
            
            [weakSelf.navigationController pushViewController:payMethodVC animated:YES];
        }];
        //重复购买
        [cell setRepeatBuy:^{
            NSArray *test =  dataArray[indexPath.section][@"goods"];
            NSMutableArray *jsonArray = [NSMutableArray array];
            for (NSDictionary *dic in test) {
                NSDictionary *creatDic = @{@"goodsId":dic[@"goods_id"],@"num":dic[@"goods_num"]};
                [jsonArray addObject:creatDic];
            }
            NSString *json = [TYTools dataJsonWithDic:jsonArray];
            json = [TYTools JSONDataStringTranslation:json];

            [BaseRequset sendPOSTRequestWithBMWApi2Method:@"CartAddAll" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"goodsInfo":json} callBack:^(RequestResult result, id object) {
                if (result == RequestResultSuccess) {
                    [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                    RootTabBarVC *tabbar = ROOTVIEWCONTROLLER;
                    tabbar.selectedIndex = 2;
                }else{
                    SHOW_MSG(@"暂无库存");
                }
            }];
        }];
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* Hview = [[UIView alloc] init];
    Hview.backgroundColor = [UIColor whiteColor];
    if (_dataArray && _dataArray.count >0) {
        NSDictionary *dic = _dataArray[section];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 36)];
        timeLabel.text = [NSString stringWithFormat:@"下单时间：%@",[self gotoChangeTime:dic[@"add_time"]]];
        timeLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
        timeLabel.font = fontForSize(12);
        [Hview addSubview:timeLabel];
        
        UILabel *stateL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-55, 0, 40, 36)];
        switch ([dic[@"order_state"] integerValue]) {
            case 0:
                stateL.text = @"已取消";
                break;
            case 10:
                stateL.text = @"待付款";
                break;
            case 20:
                stateL.text = @"待发货";
                break;
            case 30:
                stateL.text = @"待收货";
                break;
            case 40:{
                stateL.text = @"待评价";
                if ([dic[@"evaluation_state"] boolValue]) {
                    stateL.text = @"已评价";
                }

            }
                break;
            default:
                break;
        }
        stateL.textColor = [UIColor colorWithHex:0x3d3d3d];
        stateL.font = fontForSize(13);
        [Hview addSubview:stateL];
    }
    
   
    return Hview;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_dataArray.count>0){
        NSDictionary * dataDic = _dataArray[indexPath.section];
        NSString * orderID = dataDic[@"order_id"];
        NSString * backType = dataDic[@"back_type"];
        OrderDetailViewController * orderDetailVC = [[OrderDetailViewController alloc] init];
        orderDetailVC.orderId = [NSString stringWithFormat:@"%@", orderID];
        orderDetailVC.backType = [NSString stringWithFormat:@"%@", backType];
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }
}
#pragma mark -- UIAlertViewDelegate --
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        if (alertView.tag==110) {
            //确认收货
            [self orderConfirmFunc];
        }
        if(alertView.tag==101){
            //取消订单
            [self cancelOrderFunc];
        }
    }
    else if (buttonIndex==1) {
        if (alertView.tag == 111) {
            //删除订单
            [self deleteOrderFunc];
        }
    }
}

/**
 *  确认收货
 */
- (void)orderConfirmFunc{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"OrderConfirm" parameters:@{@"orderId":_confirmDic[@"order_id"]} callBack:^(RequestResult result, id object) {
        if (result==RequestResultSuccess) {
            if ([_orderState integerValue]==0) {
                [_dataArray removeAllObjects];
                [self.HUD show:YES];
                [BaseRequset sendPOSTRequestWithBMWApi2Method:@"OrderList" parameters:@{@"state":_orderState,@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"start":@"1",@"limit":@"20"} callBack:^(RequestResult result, id object) {
                    [self.HUD hide:YES];
                    if (result == RequestResultSuccess) {
                        [_dataArray addObjectsFromArray:object[@"data"]];
                        _tableView.hidden = NO;
                        _noOrderView.hidden = YES;
                        if (_dataArray.count < 4 ) {
                            _tableView.footer.hidden = YES;
                        }
                        else{
                            _tableView.footer.hidden = NO;
                        }
                        
                    }
                    else if (result == RequestResultEmptyData){
                        if (_dataArray.count == 0) {
                            _tableView.footer.hidden = YES;
                            [self noOrder];
                        }
                        
                    }
                    [_tableView reloadData];
                }];
            }else{
                [_dataArray removeObject:_confirmDic];
                if(_dataArray.count==0){
                    _tableView.footer.hidden = YES;
                    [self noOrderView];
                    [self noOrder];
                }else{
                    [_tableView reloadData];
                }
            }
        }
    }];
}

/**
 *  取消订单
 */
- (void)cancelOrderFunc{
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"DelOrder" parameters:@{@"pay_sn":_confirmDic[@"pay_sn"]} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (RequestResultSuccess==result) {
            [_dataArray removeObject:_confirmDic];
            if (_dataArray.count==0) {
                _tableView.footer.hidden = YES;
                [self noOrderView];
                [self noOrder];
            }else{
                if(![_orderState boolValue]){
                    [self refreshList];
                }else{
                    [_tableView reloadData];
                }
            }
        }
    }];
}
/**
 *  删除订单
 */
- (void)deleteOrderFunc{
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"logicDelOrder" parameters:@{@"order_id":_confirmDic[@"order_id"]} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (RequestResultSuccess==result) {
            [_dataArray removeObject:_confirmDic];
            if (_dataArray.count==0) {
                _tableView.footer.hidden = YES;
                [self noOrderView];
                [self noOrder];
            }else{
                if(![_orderState boolValue]){
                    [self refreshList];
                }else{
                    [_tableView reloadData];
                }
            }
        }
        else {
            
        }
    }];
}


#pragma mark -- 其他 --
/**
 *  时间戳转换
 */
-(NSString *)gotoChangeTime:(NSString *)sender{
    NSString *publishString = sender;
    double publishLong = [sender doubleValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:publishLong];
    
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    publishDate = [publishDate  dateByAddingTimeInterval: interval];
    
    publishString = [formatter stringFromDate:publishDate];
    return publishString;
}
#pragma mark -- 加载刷新 --
-(void)refreshList {
    _count = 1;
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"OrderList" parameters:@{@"state":_orderState,@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"start":@"1",@"limit":@"20"} callBack:^(RequestResult result, id object) {
        [_dataArray removeAllObjects];
        [_tableView.header endRefreshing];
        if (result == RequestResultSuccess) {
            [_dataArray addObjectsFromArray:object[@"data"]];
        }
        if (_dataArray.count==0) {
            _tableView.footer.hidden = YES;
            [self noOrderView];
            [self noOrder];
        }else{
            _tableView.hidden = NO;
            _noOrderView.hidden = YES;
        }
        [_tableView reloadData];
    }];
}
/**
 *  加载更多
 */
-(void)loadMore{
    _count+=20;
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"OrderList" parameters:@{@"state":_orderState,@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"start":NSNumber(_count),@"limit":@"20"} callBack:^(RequestResult result, id object) {
        [_tableView.footer endRefreshing];
        if (result == RequestResultSuccess) {
            [_dataArray addObjectsFromArray:object[@"data"]];
        }else if (result == RequestResultEmptyData){
            _tableView.footer.hidden = YES;
        }
        [_tableView reloadData];
    }];
}
#pragma mark -- 让 tableView 的 section 不悬浮 --
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 36;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
#pragma mark -- MyOrderTableViewCellDelegate --
-(void)MyorderTableViewCellDidClickEvaluateBtn:(UIButton *)sender index:(NSIndexPath *)index dataDic:(NSDictionary *)dataDic
{
    OrderEvaluateViewController * orderEvaluateVC = [[OrderEvaluateViewController alloc]init];
    NSDictionary *orderDic = _dataArray[index.section];
    orderEvaluateVC.orderDic = orderDic;
//    orderEvaluateVC.refresh = ^{
//        [self refreshList];
//    };
    [self.navigationController pushViewController:orderEvaluateVC animated:YES];
    
}
#pragma mark -- get --
-(OrderServiceView *)orderService
{
    if (!_orderService) {
        _orderService = [[OrderServiceView alloc]initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 0.5)];
        _orderService.delegate = self;
        [self.view addSubview:_orderService];
    }
    return _orderService;
}
#pragma mark -- OrderServiceViewDelegate --
-(void)OrderServiceViewDidClickServiceOrderCell:(NSDictionary *)dataDic
{
    ServicesProgressVC * servicesProVC = [[ServicesProgressVC alloc]init];
    servicesProVC.serviceId = dataDic[@"id"];
    [self.navigationController pushViewController:servicesProVC animated:YES];
}

-(void)CustomerSerVice{
    CustomerserviceViewController *custommerVC = [[CustomerserviceViewController alloc] init];
    custommerVC.htmlUrl = SERVICE_URL;
    [self.navigationController pushViewController:custommerVC animated:YES];
}

-(void)orderServiceNetWorkSuccess
{
    [self hideNoNet];
}
-(void)orderServiceNetWorkFailed
{
    [self showNoNetOnView:self.view frame:self.orderService.frame type:NoNetDefault delegate:self];
}

#pragma mark -- NoNetDelegate --
-(void)NoNetDidClickRelaod:(UIButton *)sender
{
    [self checkConnection:^(ConnectionType type) {
        if (type == ConnectionTypeNone ) {
            NSLog(@"无网");
            self.noNetWork = YES;
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前网络不可用，请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if (type == ConnectionTypeWifi){
            NSLog(@"wifi");
            self.noNetWork = NO;
            [self hideNoNet];
            self.orderService = nil;
            self.orderState = _orderState;
            
            if (_goodsOrderB.selected == NO && _serviceOrderB.selected == YES) {
                [self.view bringSubviewToFront:self.noOrderView];
                [self.view bringSubviewToFront:self.orderService];
            }
           
            
        }
        else if (type == ConnectionTypeData){
            NSLog(@"2g/3g");
             self.noNetWork = NO;
            [self hideNoNet];
            self.orderService = nil;
            self.orderState = _orderState;
            
            if (_goodsOrderB.selected == NO && _serviceOrderB.selected == YES) {
                [self.view bringSubviewToFront:self.noOrderView];
                [self.view bringSubviewToFront:self.orderService];
            }

           
        }
    }];
    
}
#pragma mark -- 网络监控重写父类 --
-(void)netWorkConnectNone:(ConnectionType)type
{
    self.noNetWork = YES;
}
-(void)netWorkConnect:(ConnectionType)type
{
    self.noNetWork = NO;
}

@end

