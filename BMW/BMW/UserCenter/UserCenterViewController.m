//
//  UserCenterViewController.m
//  BMW
//
//  Created by gukai on 16/2/17.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "UserCenterViewController.h"
#import "AddressListViewController.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
#import "UserCollectListViewController.h"
#import "UserInfoViewController.h"
#import "UserCenterTableViewCell.h"
#import "MyOrder/MyOrderViewController.h"
#import "OrderDetailViewController.h"
#import "UserCouponViewController.h"
#import "HelpAndFeedbackViewController.h"
#import "SettingPageViewController.h"

#define kTEL_NUMBER @"400-100-3923"

@interface UserCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate> {
    
    NSArray *_imageArray;
    NSArray *_titleArray;
    
    NSDictionary *_dataDic;
    
    UITableView *_tableView;
    UIImageView *_touxiangImage;
    UIImageView *_vipImageV;
    UILabel *_userName;
    UIButton *_loginButton;
    UIButton *_regisButton;
}

@property (nonatomic, strong)UIView *headerView;

@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self initData];
    [self initUserInterFace];
    //[self getUserInfoRequest];
    
    
    //去掉默认线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //self.navigationController.navigationBarHidden = YES;
    if ([JCUserContext sharedManager].isUserLogedIn) {
        [self getUserInfoRequest];
        [self updateHeadView];
        
    }else{
        [self LoginView];
    }
}
/**
 *  登录成功的视图
 */
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 290*W_ABCW)];
        _headerView.backgroundColor = COLOR_BACKGRONDCOLOR;
        UIImageView *backGroundImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170*W_ABCW)];
        backGroundImageV.userInteractionEnabled = YES;
        backGroundImageV.image = IMAGEWITHNAME(@"bj_wd.png");
        [_headerView addSubview:backGroundImageV];
        
        _touxiangImage = [UIImageView new];
        _touxiangImage.viewSize = CGSizeMake(60 * W_ABCW, 61 * W_ABCW);
        [_touxiangImage align:ViewAlignmentTopCenter relativeToPoint:CGPointMake(SCREEN_WIDTH/2, 44*W_ABCW)];
        
        if ([JCUserContext sharedManager].isUserLogedIn && [JCUserContext sharedManager].currentUserInfo.memberID && [JCUserContext sharedManager].currentUserInfo.memberID.length > 0) {
            
            NSData * imageData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"image%@",[JCUserContext sharedManager].currentUserInfo.memberID]];
            if (imageData != nil) {
                _touxiangImage.image = [UIImage imageWithData:imageData];
            }
            else{
                _touxiangImage.image = [UIImage imageNamed:@"jpg_morentouxiang_wd.png"];
            }
            
        }
        else{
            _touxiangImage.image = IMAGEWITHNAME(@"jpg_morentouxiang_wd.png");
        }
       
        
        _touxiangImage.layer.cornerRadius = _touxiangImage.viewHeight / 2;
        _touxiangImage.layer.masksToBounds = YES;
        
        [backGroundImageV addSubview:_touxiangImage];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedUserInfo)];
        [_touxiangImage addGestureRecognizer:tap];
        
        UIButton * setButton = [UIButton new];
        setButton.viewSize = CGSizeMake(50, 40);
        [setButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 10, 35)];
        setButton.titleLabel.font = fontForSize(15);
        [setButton setTitle:@"设置" forState:UIControlStateNormal];
        [setButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [setButton addTarget:self action:@selector(processSetButton) forControlEvents:UIControlEventTouchUpInside];
        [backGroundImageV addSubview:setButton];
        
        _vipImageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+28.5*W_ABCW, 103/2*W_ABCW, 21, 8)];
        _vipImageV.image = IMAGEWITHNAME(@"icon_vip_wd.png");
        [backGroundImageV addSubview:_vipImageV];
        
        _userName = [[UILabel alloc] initWithFrame:CGRectMake(0, _touxiangImage.viewBottomEdge+8*W_ABCW, SCREEN_WIDTH, 14)];
        _userName.textAlignment = NSTextAlignmentCenter;
//        _userName.text = @"蒲公英的小啦啦";
        _userName.textColor = [UIColor colorWithHex:0x661c12];
        _userName.font = fontForSize(14);
        [backGroundImageV addSubview:_userName];
        
        _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(100*W_ABCW, _userName.viewBottomEdge+8*W_ABCW, 55*W_ABCW, 23)];
        [_loginButton setBackgroundImage:IMAGEWITHNAME(@"icon_denglu_wd.png") forState:UIControlStateNormal];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
        _loginButton.titleLabel.font = fontForSize(12);
        [_loginButton addTarget:self action:@selector(loginButtonPress) forControlEvents:UIControlEventTouchUpInside];
        [backGroundImageV addSubview:_loginButton];
        
        _regisButton = [[UIButton alloc] initWithFrame:CGRectMake(_loginButton.viewRightEdge+14*W_ABCW, _loginButton.viewY, 55*W_ABCW, 23)];
        [_regisButton setBackgroundImage:IMAGEWITHNAME(@"icon_denglu_wd.png") forState:UIControlStateNormal];
        [_regisButton setTitle:@"注册" forState:UIControlStateNormal];
        [_regisButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
        _regisButton.titleLabel.font = fontForSize(12);
        [_regisButton addTarget:self action:@selector(regisButtonPress) forControlEvents:UIControlEventTouchUpInside];
        [backGroundImageV addSubview:_regisButton];
        
        UIView *myOrderV = [[UIView alloc] initWithFrame:CGRectMake(0, backGroundImageV.viewBottomEdge, SCREEN_WIDTH, 100*W_ABCW)];
        myOrderV.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:myOrderV];
        
        UIImageView *orderImage = [[UIImageView alloc] initWithFrame:CGRectMake(15*W_ABCW, 11.5*W_ABCW, 22*W_ABCW, 22* W_ABCW)];
        orderImage.image = IMAGEWITHNAME(@"icon_wodedingdan_wd.png");
        [myOrderV addSubview:orderImage];
        
        UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(orderImage.viewRightEdge+10*W_ABCW, 0, 60, 45*W_ABCW)];
        orderLabel.text = @"我的订单";
        orderLabel.textColor = [UIColor colorWithHex:0x181818];
        orderLabel.font = fontForSize(13);
        [myOrderV addSubview:orderLabel];
        
        UIImageView *rightRow = [UIImageView new];
        rightRow.viewSize = CGSizeMake(6, 10);
        rightRow.image = IMAGEWITHNAME(@"icon_xiaojiantou_sy.png");
        [rightRow align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15*W_ABCW, 45*W_ABCW/2)];
        [myOrderV addSubview:rightRow];
        
        UILabel *allOrderLabel = [UILabel new];
        allOrderLabel.viewSize = CGSizeMake(60, 45*W_ABCW);
        [allOrderLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(rightRow.viewX-8*W_ABCW, 0)];
        allOrderLabel.text = @"全部订单";
        allOrderLabel.textAlignment = NSTextAlignmentRight;
        allOrderLabel.font = fontForSize(13);
        allOrderLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        [myOrderV addSubview:allOrderLabel];
        
        UIButton *myOrderB = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45*W_ABCW)];
        [myOrderB addTarget:self action:@selector(gotoMyorder) forControlEvents:UIControlEventTouchUpInside];
        [myOrderV addSubview:myOrderB];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 45*W_ABCW, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = COLOR_BACKGRONDCOLOR;
        [myOrderV addSubview:line];
        
        CGFloat item = SCREEN_WIDTH/5;
        
        for (int i=0; i<5; i++) {
            UIImageView *imageV = [UIImageView new];
            imageV.viewSize = CGSizeMake(20*W_ABCW, 20*W_ABCW);
            [imageV align:ViewAlignmentTopCenter relativeToPoint:CGPointMake(item*i+item/2, line.viewBottomEdge + 10*W_ABCW)];
            imageV.image = IMAGEWITHNAME(_imageArray[i]);
            [myOrderV addSubview:imageV];
            
            UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(item*i, imageV.viewBottomEdge+5*W_ABCW, item, 12)];
            stateLabel.textAlignment = NSTextAlignmentCenter;
            stateLabel.text = _titleArray[i];
            stateLabel.textColor = [UIColor colorWithHex:0x5f646e];
            stateLabel.font = fontForSize(12);
            [myOrderV addSubview:stateLabel];
            
            UIButton *orderStateB = [[UIButton alloc] initWithFrame:CGRectMake(item*i, line.viewBottomEdge, item, 55*W_ABCW)];
            orderStateB.tag = 666+i;
            [orderStateB addTarget:self action:@selector(gotoStateB:) forControlEvents:UIControlEventTouchUpInside];
            [myOrderV addSubview:orderStateB];
        }

        _headerView.viewSize = CGSizeMake(SCREEN_WIDTH, myOrderV.viewY+myOrderV.viewHeight+10*W_ABCW+0.5*W_ABCW);
        UIView *linebottom = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.viewHeight-0.5*W_ABCW, SCREEN_WIDTH, 0.5)];
        linebottom.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_headerView addSubview:linebottom];
    }
    return _headerView;
}
/**
 *  显示登录视图
 */
-(void)LoginView{
    _vipImageV.hidden = YES;
    _userName.hidden = YES;
    _regisButton.hidden = NO;
    _loginButton.hidden = NO;
    _touxiangImage.image = IMAGEWITHNAME(@"jpg_morentouxiang_wd.png");
    [_touxiangImage align:ViewAlignmentTopCenter relativeToPoint:CGPointMake(SCREEN_WIDTH/2, 44*W_ABCH)];
    [_loginButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(98*W_ABCW, _touxiangImage.viewBottomEdge+15*W_ABCH)];
    [_regisButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH-98*W_ABCW, _touxiangImage.viewBottomEdge+15*W_ABCH)];
}
/**
 *  更新顶部视图
 */
-(void)updateHeadView{
    _vipImageV.hidden = NO;
    _userName.hidden = NO;
    _touxiangImage.userInteractionEnabled = YES;
    if ([JCUserContext sharedManager].isUserLogedIn && [JCUserContext sharedManager].currentUserInfo.memberAvatar && [JCUserContext sharedManager].currentUserInfo.memberAvatar.length > 0) {
        [self checkConnection:^(ConnectionType type) {
            
            if (type == ConnectionTypeNone ) {
                NSLog(@"无网");
                NSData * imageData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"image%@",[JCUserContext sharedManager].currentUserInfo.memberID]];
                if (imageData != nil) {
                    _touxiangImage.image = [UIImage imageWithData:imageData];
                }
                else{
                    _touxiangImage.image = [UIImage imageNamed:@"jpg_morentouxiang_wd.png"];
                }
                
            }
            else {
                //该方法用于处理用一个url的情况
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    // 处理耗时操作的代码块...
                    UIImage * newImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[JCUserContext sharedManager].currentUserInfo.memberAvatar]]];
                    //通知主线程刷新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //回调或者说是通知主线程刷新，
                        if (newImage) {
                            _touxiangImage.image = newImage;
                            NSString * string = [NSString stringWithFormat:@"image%@",[JCUserContext sharedManager].currentUserInfo.memberID];
                            NSData *data = UIImagePNGRepresentation(newImage);
                            [[NSUserDefaults standardUserDefaults] setObject:data forKey:string];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                        }
                        else{
                            
                            NSData * imageData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"image%@",[JCUserContext sharedManager].currentUserInfo.memberID]];
                            if (imageData != nil) {
                                _touxiangImage.image = [UIImage imageWithData:imageData];
                            }
                            else{
                                _touxiangImage.image = [UIImage imageNamed:@"jpg_morentouxiang_wd.png"];
                            }
                        
                        }
                    });
                    
                });
            }
        }];
    }
    else {
        _touxiangImage.image = [UIImage imageNamed:@"jpg_morentouxiang_wd.png"];
    }
    [_touxiangImage align:ViewAlignmentTopCenter relativeToPoint:CGPointMake(SCREEN_WIDTH/2, 55*W_ABCH)];
    //判断是否显示vip
    if ([[JCUserContext sharedManager].currentUserInfo.status integerValue] == 40 || [[JCUserContext sharedManager].currentUserInfo.status integerValue] == 10) {
        _vipImageV.hidden = NO;
    }
    else {
        _vipImageV.hidden = YES;
    }
    
    [_vipImageV align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(SCREEN_WIDTH/2+28.5*W_ABCW, _touxiangImage.viewY+15/2*W_ABCH)];
    [_userName align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _touxiangImage.viewBottomEdge+15*W_ABCH)];
    if ([JCUserContext sharedManager].currentUserInfo.memberTrueName && [JCUserContext sharedManager].currentUserInfo.memberTrueName.length != 0) {
        _userName.text = [JCUserContext sharedManager].currentUserInfo.memberTrueName;
    }
    else {
        _userName.text = [NSString stringWithFormat:@"BM%@",[JCUserContext sharedManager].currentUserInfo.memberID];
    }
    
    _loginButton.hidden = YES;
    _regisButton.hidden = YES;
}

-(void)initData{
    _imageArray = @[@"icon_daifukuan_wd.png",@"icon_daifahuo_wd.png",@"icon_daishouhuo_wd.png",@"icon_daipingjia_wd.png",@"icon_tuikuan_wd.png"];
    _titleArray = @[@"待付款",@"待发货",@"待收货",@"待评价",@"退款/退货"];
    
    _dataDic = @{@"imageA":@[@"icon_wodeyouhuiquan_wd.png",@"icon_shouhuodizhi_wd.png",@"icon_wodeshoucang_wd.png",@"icon_bangzhufankui_wd.png",@"icon_kefu_wd.png"],@"titleA":@[@"我的优惠券",@"收货地址设置",@"我的收藏",@"帮助反馈",@"客服热线"]};
}
-(void)initUserInterFace{
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT- 49 + 20)];
    _tableView.backgroundColor = COLOR_BACKGRONDCOLOR;
    [_tableView registerClass:[UserCenterTableViewCell class] forCellReuseIdentifier:@"userCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = self.headerView;
    UIView *linebottom = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.viewHeight-0.5*W_ABCW, SCREEN_WIDTH, 0.5)];
    linebottom.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    _tableView.tableFooterView = linebottom;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    
}

#pragma mark -- UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataDic[@"imageA"] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45*W_ABCW;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.imageV.image = IMAGEWITHNAME(_dataDic[@"imageA"][indexPath.row]);
    cell.titleLabel.text = _dataDic[@"titleA"][indexPath.row];
    if (indexPath.row==4) {
        cell.detailLabel.text = kTEL_NUMBER;
    }else{
        cell.detailLabel.text = @"";
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            NSLog(@"优惠券列表");
            if ([JCUserContext sharedManager].currentUserInfo.memberID) {
                UserCouponViewController * userCouponVC = [[UserCouponViewController alloc] init];
                userCouponVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:userCouponVC animated:YES];
            }
            else {
                LoginViewController * loginVC = [[LoginViewController alloc] init];
                loginVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            break;
        case 1:{
            NSLog(@"收货地址");
            if ([JCUserContext sharedManager].currentUserInfo.memberID) {
                AddressListViewController * addressVC = [[AddressListViewController alloc] init];
                addressVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:addressVC animated:YES];
            }
            else {
                LoginViewController * loginVC = [[LoginViewController alloc] init];
                loginVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        }
            break;
        case 2:{
            NSLog(@"收藏");
            if ([JCUserContext sharedManager].currentUserInfo.memberID) {
                UserCollectListViewController * userCollectListVC = [[UserCollectListViewController alloc] init];
                userCollectListVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:userCollectListVC animated:YES];
            }
            else {
                LoginViewController * loginVC = [[LoginViewController alloc] init];
                loginVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        }
            break;
        case 3:{
            NSLog(@"帮助");
            HelpAndFeedbackViewController * helpAndFeedbackVC = [[HelpAndFeedbackViewController alloc] init];
            helpAndFeedbackVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:helpAndFeedbackVC animated:YES];
        }
            break;
        case 4:{
            NSLog(@"客服");
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"拨号" message:kTEL_NUMBER delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [alertV show];
        }
            break;
            
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", kTEL_NUMBER]]];
    }
}

#pragma mark -- 点击事件
- (void)processSetButton {
    NSLog(@"点击设置");
    SettingPageViewController *settingVC = [[SettingPageViewController alloc] init];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

-(void)gotoStateB:(UIButton *)sender{
    if ([JCUserContext sharedManager].currentUserInfo.memberID) {
        MyOrderViewController *myoderVC = [[MyOrderViewController alloc] init];
        myoderVC.orderState = [NSString stringWithFormat:@"%ld",sender.tag-665];
        myoderVC.navigationItem.hidesBackButton = YES;
        myoderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myoderVC animated:YES];
    }
    else {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

-(void)gotoMyorder{
    if ([JCUserContext sharedManager].currentUserInfo.memberID) {
        MyOrderViewController *myoderVC = [[MyOrderViewController alloc] init];
        myoderVC.orderState = @"0";
        myoderVC.navigationItem.hidesBackButton = YES;
        myoderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myoderVC animated:YES];
    }
    else {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

-(void)loginButtonPress{
    NSLog(@"登陆按钮");
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}

-(void)regisButtonPress{
    NSLog(@"注册按钮");
    RegistViewController * registVC = [[RegistViewController alloc] init];
    registVC.hidesBottomBarWhenPushed = YES;
    registVC.isLoginPush = NO;
    [self.navigationController pushViewController:registVC animated:YES];
}

- (void)clickedUserInfo {
    NSLog(@"点击头像跳转个人信息");
    if ([JCUserContext sharedManager].currentUserInfo.memberID) {
        UserInfoViewController * userInfoVC = [[UserInfoViewController alloc] init];
        userInfoVC.headerImage = _touxiangImage.image;
        userInfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }
    else {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

#pragma mark -- 网络请求
- (void)getUserInfoRequest {
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetUserInfo" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            Userentity *user = [[Userentity alloc] initWithJSONObject:object[@"data"]];
            [[JCUserContext sharedManager] updateUserInfo:user];
            [self updateHeadView];
        }
    }];
}


@end
