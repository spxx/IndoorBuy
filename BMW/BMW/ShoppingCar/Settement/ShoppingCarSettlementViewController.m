//
//  ShoppingCarSettlementViewController.m
//  BMW
//
//  Created by 白琴 on 16/3/10.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ShoppingCarSettlementViewController.h"
#import "ShoppingCarGoodsList.h"
#import "SettementAddressView.h"
#import "SettementGoodsInfoView.h"
#import "AddressListViewController.h"
//#import "ChoosePayWayViewController.h"
#import "PayMethodViewController.h"

@interface ShoppingCarSettlementViewController ()<AddressChooseDelegate,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate> {
    UIScrollView * _scrollView;                             //滚动视图
    
    //优惠券
    UILabel * _couponsLabel;                                //优惠券显示
    UIButton * _lastCouponsButton;                          //上一次选择的优惠券
    UIButton * _couponsJiantouButton;                       //优惠券的上拉啦按钮
    UIView * _couponsBottomLine;                            //优惠券的下标线
    NSMutableArray * _couponsArray;                         //优惠券内容
    
    
    //买家留言
    UIView * _BBSViewLine;                                  //金额的下标线
    UITextField * _BBSTextField;                            //留言输入框
    UIButton * _BBSJiantouButton;                           //留言的上拉啦按钮
    UITextField * _inputTextField;
    
    //金额
    UITableView * _amountTableView;                         //价格显示的tableView
    UILabel * _amountLabel;                                 //金额显示
    UILabel * _freightLabel;                                //运费
    UIView * _amountBottomLine;                             //金额的下标线
    NSMutableArray * _amountTitleArray;                     //金额内容
    
    
    UIButton * _submitOrderButton;                          //提交订单按钮
    
    BOOL _isHaveAddress;                                    //判断有木有选择收货信息
    
    NSString * _couponsID;                                  //优惠券ID
    
    NSDictionary * _orderInfoDataSourceDic;                 //订单信息的所有数据
}

@property (nonatomic, strong)NSDictionary *addressInfoDic;                         //收货信息字典

@property (nonatomic, strong)NSArray * dataSourceArray;

/**
 *  收货地址信息
 */
@property (nonatomic, strong)SettementAddressView * addressView;
/**
 *  商品信息
 */
@property (nonatomic, strong)SettementGoodsInfoView * goodsInfoView;
/**
 *  优惠券
 */
@property (nonatomic, strong)UIView * couponsView;
/**
 *  支付金额
 */
@property (nonatomic, strong)UIView * amountView;
/**
 *  买家留言
 */
@property (nonatomic, strong)UIView * BBSView;


@end

@implementation ShoppingCarSettlementViewController
- (void)dealloc{
    NSLog(@"...........");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    self.title = @"结算";
    [self navigation];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerKeyboardStateNotification];
}

-(void)viewWillDisappear:(BOOL)animated{
    _scrollView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initData {
    _isHaveAddress = NO;
    _amountTitleArray = [NSMutableArray array];
    [self prepareOrderRequestWithVoucher:nil];
}

#pragma mark -- 界面
- (void)initUserInterface {
    _scrollView = [UIScrollView new];
    _scrollView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49);
    [_scrollView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
    _scrollView.backgroundColor = COLOR_BACKGRONDCOLOR;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    [_scrollView addSubview:self.addressView];
    [_scrollView addSubview:self.goodsInfoView];
    [_scrollView addSubview:self.couponsView];
    [_scrollView addSubview:self.BBSView];
    [_scrollView addSubview:self.amountView];
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _amountView.viewBottomEdge + 10);
    
    _submitOrderButton = [UIButton new];
    _submitOrderButton.viewSize = CGSizeMake(SCREEN_WIDTH, 49);
    [_submitOrderButton align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, SCREEN_HEIGHT - 64)];
    _submitOrderButton.titleLabel.font = fontForSize(16);
    [_submitOrderButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [_submitOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitOrderButton.backgroundColor = [UIColor colorWithHex:0xfd5487];
    [_submitOrderButton addTarget:self action:@selector(clickedSumbmiyOrderButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitOrderButton];
}
/**
 *  收货地址
 */
- (UIView *)addressView {
    if (!_addressView) {
        _addressView = [[SettementAddressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 88)];
        _addressView.delegate = self;
        //如果有默认地址
        if (((NSArray *)_orderInfoDataSourceDic[@"default_address"]).count > 0) {
            _addressInfoDic = [NSDictionary dictionaryWithDictionary:_orderInfoDataSourceDic[@"default_address"][0]];
            _addressView.addressDic = _orderInfoDataSourceDic[@"default_address"][0];
            _isHaveAddress = YES;
        }
    }
    return _addressView;
}

-(void)chooseAddressBtn{
    AddressListViewController * listVC = [[AddressListViewController alloc] init];
    listVC.chooseAddress = YES;
    WEAK_SELF;
    [listVC setChooeseAddressBlock:^(NSDictionary * addressDic) {
        _isHaveAddress = YES;
        //给收货信息字典赋值
        weakSelf.addressInfoDic = [NSDictionary dictionaryWithDictionary:addressDic];
        
        weakSelf.addressView.addressDic = [NSDictionary dictionaryWithDictionary:addressDic];
        [weakSelf.goodsInfoView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _addressView.viewBottomEdge + 10)];
        [weakSelf.couponsView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _goodsInfoView.viewBottomEdge + 10)];
        [weakSelf.BBSView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _couponsView.viewBottomEdge + 10)];
        [weakSelf.amountView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _BBSView.viewBottomEdge + 10)];
    }];
    [self.navigationController pushViewController:listVC animated:YES];
}



/**
 *  商品展示
 */
- (UIView *)goodsInfoView {
    if (!_goodsInfoView) {
        NSInteger count = self.dataSourceArray.count;
        _goodsInfoView = [[SettementGoodsInfoView alloc] initWithFrame:CGRectMake(0, _addressView.viewBottomEdge + 10, SCREEN_WIDTH, 119 * count + count - 1) dataSourece:self.dataSourceArray];
        WEAK_SELF;
        [_goodsInfoView setShowGoodsListButton:^(NSInteger index) {
            [weakSelf.view endEditing:YES];
            ShoppingCarGoodsList *goodsList = [[ShoppingCarGoodsList alloc] init];
            goodsList.dataDic = weakSelf.dataSourceArray[index];
            [weakSelf.navigationController pushViewController:goodsList animated:YES];
        }];
    }
    return _goodsInfoView;
}
/**
 *  优惠券
 */
- (UIView *)couponsView {
    if (!_couponsView) {
        _couponsView = [UIView new];
        _couponsView.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_couponsView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _goodsInfoView.viewBottomEdge + 10)];
        _couponsView.backgroundColor = [UIColor whiteColor];
        
        UILabel * titleLabel = [UILabel new];
        titleLabel.viewSize = CGSizeMake(100, 45);
        [titleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
        titleLabel.text = @"优惠券";
        titleLabel.font = fontForSize(13);
        titleLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        [_couponsView addSubview:titleLabel];
        
        _couponsJiantouButton = [UIButton new];
        _couponsJiantouButton.viewSize = CGSizeMake(10, 6);
        [_couponsJiantouButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, (45 - _couponsJiantouButton.viewHeight) / 2)];
        [_couponsJiantouButton setBackgroundImage:[UIImage imageNamed:@"icon_xialajiantou_js"] forState:UIControlStateNormal];
        [_couponsJiantouButton setBackgroundImage:[UIImage imageNamed:@"icon_shanglajiantou_js"] forState:UIControlStateSelected];
        
        [_couponsView addSubview:_couponsJiantouButton];
        
        _couponsLabel = [UILabel new];
        _couponsLabel.viewSize = CGSizeMake(200, 45);
        [_couponsLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(_couponsJiantouButton.viewX - 5, 0)];
        _couponsLabel.textAlignment = NSTextAlignmentRight;
        _couponsLabel.font = fontForSize(13);
        _couponsLabel.textColor = [UIColor colorWithHex:0x181818];
        _couponsLabel.text = @"未选择";
        [_couponsView addSubview:_couponsLabel];
        
        _couponsArray = [NSMutableArray array];
        id object = [_orderInfoDataSourceDic objectForKeyNotNull:@"voucher_list"];
        if ([object isKindOfClass:[NSArray class]]) {
            for (NSDictionary * dic in object) {
                [_couponsArray addObject:dic];
            }
        }
        
        //下拉展开的情况
        for (int i = 0; i < _couponsArray.count; i ++) {
            UIView * line = [UIView new];
            line.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
            [line align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 45 + i * 45)];
            line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
            [_couponsView addSubview:line];
            
            UIButton * chooseButton = [UIButton new];
            chooseButton.viewSize = CGSizeMake(18, 18);
            [chooseButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, line.viewBottomEdge + (45 - chooseButton.viewHeight) / 2)];
            [chooseButton setBackgroundImage:[UIImage imageNamed:@"icon_gouxuan_nor_gwc"] forState:UIControlStateNormal];
            [chooseButton setBackgroundImage:[UIImage imageNamed:@"icon_gouxuan_cli_gwc"] forState:UIControlStateSelected];
            chooseButton.tag = 15000 + i;
            [chooseButton addTarget:self action:@selector(clickedCouponsChooseButton:) forControlEvents:UIControlEventTouchUpInside];
            [_couponsView addSubview:chooseButton];
            if (chooseButton.tag == _lastCouponsButton.tag) {
                chooseButton.selected = YES;
                _couponsLabel.text = [NSString stringWithFormat:@"%@¥%@", _couponsArray[i][@"voucher_title"], _couponsArray[i][@"voucher_price"]];
            }
            
            UILabel * titleLabel = [UILabel new];
            titleLabel.viewSize = CGSizeMake(SCREEN_WIDTH - 26 - chooseButton.viewRightEdge, 45);
            [titleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(chooseButton.viewRightEdge + 13, line.viewBottomEdge)];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = fontForSize(13);
            titleLabel.textColor = [UIColor colorWithHex:0x181818];
            titleLabel.text = [NSString stringWithFormat:@"%@¥%@", _couponsArray[i][@"voucher_title"], _couponsArray[i][@"voucher_price"]];
            [_couponsView addSubview:titleLabel];
            
            UIButton * bigButton = [UIButton new];
            bigButton.viewSize = CGSizeMake(SCREEN_WIDTH - 30, 45);
            [bigButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, chooseButton.viewY)];
            bigButton.tag = chooseButton.tag + 100;
            [bigButton addTarget:self action:@selector(clickedCouponsChooseButton:) forControlEvents:UIControlEventTouchUpInside];
            [_couponsView addSubview:bigButton];
            
            line.hidden = YES;
            chooseButton.hidden = YES;
            titleLabel.hidden = YES;
        }
        
        //按钮覆盖
        UIButton * payWayButton = [UIButton new];
        payWayButton.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [payWayButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        [payWayButton addTarget:self action:@selector(clickedCoupounsButton:) forControlEvents:UIControlEventTouchUpInside];
        [_couponsView addSubview:payWayButton];
        
        if (_couponsArray.count == 0) {
            payWayButton.userInteractionEnabled = NO;
            _couponsLabel.text = @"无可用优惠券";
            _couponsJiantouButton.hidden = YES;
            [_couponsLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, (45 - _couponsLabel.viewHeight) / 2)];
        }
        
        _couponsBottomLine = [UIView new];
        _couponsBottomLine.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [_couponsBottomLine align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _couponsView.viewHeight)];
        _couponsBottomLine.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_couponsView addSubview:_couponsBottomLine];
    }
    return _couponsView;
}
/**
 *  金额明细
 */
- (UIView *)amountView {
    if (!_amountView) {
        _amountView = [UIView new];
        _amountView.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_amountView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _BBSView.viewBottomEdge + 10)];
//        [_amountView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _couponsView.viewBottomEdge + 10)];
        _amountView.backgroundColor = [UIColor whiteColor];
        
        _amountTableView = [UITableView new];
        _amountTableView.viewSize = CGSizeMake(SCREEN_WIDTH, _amountTitleArray.count * 45);
        [_amountTableView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 45)];
        _amountTableView.showsVerticalScrollIndicator = NO;
        _amountTableView.showsHorizontalScrollIndicator = NO;
        _amountTableView.dataSource = self;
        _amountTableView.delegate = self;
        _amountTableView.backgroundColor = [UIColor clearColor];
//        [_amountTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"baiqin123"];
        [_amountView addSubview:_amountTableView];
        
        UILabel * titleLabel = [UILabel new];
        titleLabel.viewSize = CGSizeMake(100, 45);
        titleLabel.text = @"应付总额";
        titleLabel.font = fontForSize(13);
        titleLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        [titleLabel sizeToFit];
        [titleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, (45 - titleLabel.viewHeight) / 2)];
        [_amountView addSubview:titleLabel];
        
        UIView * lineView = [UIView new];
        lineView.viewSize = CGSizeMake(SCREEN_WIDTH - 30, 0.5);
        [lineView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 45)];
        lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_amountView addSubview:lineView];
        
        _amountLabel = [UILabel new];
        _amountLabel.viewSize = CGSizeMake(100, 45);
        _amountLabel.font = fontForSize(13);
        _amountLabel.textColor = [UIColor colorWithHex:0xfd5487];
        _amountLabel.text = [NSString stringWithFormat:@"¥%@", _orderInfoDataSourceDic[@"additional"][@"payprice"][@"value"]];
        [_amountLabel sizeToFit];
        [_amountLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, (45 - _amountLabel.viewHeight) / 2)];
        [_amountView addSubview:_amountLabel];
        
        _freightLabel = [UILabel new];
        _freightLabel.viewSize = CGSizeMake(100, 45);
        _freightLabel.font = fontForSize(11);
        _freightLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        [_freightLabel align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(_amountLabel.viewRightEdge + 10, _amountLabel.viewBottomEdge)];
        
        //判断是否显示运费
        [self reloadAmountTableView];
        
        _amountView.viewSize = CGSizeMake(SCREEN_WIDTH, _amountTableView.viewBottomEdge - _amountTitleArray.count);
        
        _amountBottomLine = [UIView new];
        _amountBottomLine.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [_amountBottomLine align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _amountView.viewHeight)];
        _amountBottomLine.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_amountView addSubview:_amountBottomLine];
    }
    return _amountView;
}
/**
 *  买家留言
 */
- (UIView *)BBSView {
    if (!_BBSView) {
        _BBSView = [UIView new];
        _BBSView.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_BBSView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _couponsView.viewBottomEdge + 10)];
        _BBSView.backgroundColor = [UIColor whiteColor];
        
        UILabel * titleLabel = [UILabel new];
        titleLabel.viewSize = CGSizeMake(100, 45);
        titleLabel.text = @"买家留言";
        titleLabel.font = fontForSize(13);
        titleLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        [titleLabel sizeToFit];
        [titleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, (45 - titleLabel.viewHeight) / 2)];
        [_BBSView addSubview:titleLabel];
        
        
        _BBSJiantouButton = [UIButton new];
        _BBSJiantouButton.viewSize = CGSizeMake(10, 6);
        [_BBSJiantouButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, (45 - _BBSJiantouButton.viewHeight) / 2)];
        [_BBSJiantouButton setBackgroundImage:[UIImage imageNamed:@"icon_xialajiantou_js"] forState:UIControlStateNormal];
        [_BBSJiantouButton setBackgroundImage:[UIImage imageNamed:@"icon_shanglajiantou_js"] forState:UIControlStateSelected];
        [_BBSView addSubview:_BBSJiantouButton];
        
        
        _BBSTextField = [UITextField new];
        _BBSTextField.viewSize = CGSizeMake(SCREEN_WIDTH - 30, 45);
        [_BBSTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 45)];
        _BBSTextField.placeholder = @"给卖家留言";
        _BBSTextField.font = [UIFont systemFontOfSize:13];
        _BBSTextField.textColor = [UIColor colorWithHex:0x181818];
        _BBSTextField.returnKeyType = UIReturnKeyDone;
        _BBSTextField.delegate = self;
        [_BBSView addSubview:_BBSTextField];
    
        _BBSTextField.hidden = YES;
        
        UIButton * bigButton = [UIButton new];
        bigButton.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [bigButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        [bigButton addTarget:self action:@selector(clickedBBSButton:) forControlEvents:UIControlEventTouchUpInside];
        [_BBSView addSubview:bigButton];
        
        UIView * line = [UIView new];
        line.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [line align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 45)];
        line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_couponsView addSubview:line];
        
        
        _BBSViewLine = [UIView new];
        _BBSViewLine.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [_BBSViewLine align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _BBSView.viewHeight)];
        _BBSViewLine.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_BBSView addSubview:_BBSViewLine];
    }
    return _BBSView;
}
#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _inputTextField = textField;
    return YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}


#pragma mark -- UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _amountTitleArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"baiqin123"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:@"baiqin123"];
    }
    //设置cell的自带的线条的位置
    cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    cell.textLabel.text = ((NSDictionary *)_amountTitleArray[indexPath.row]).allKeys[0];
    cell.textLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    cell.textLabel.font = fontForSize(13);
    cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f", [((NSDictionary *)_amountTitleArray[indexPath.row]).allValues[0] floatValue]];
    cell.detailTextLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    cell.detailTextLabel.font = fontForSize(13);
    cell.userInteractionEnabled = NO;
    return cell;
}


#pragma mark -- 点击事件
/**
 *  留言
 */
- (void)clickedBBSButton:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
    _BBSJiantouButton.selected = sender.selected;
    if (sender.selected) {
        _BBSView.viewSize = CGSizeMake(SCREEN_WIDTH, 90);
    }
    else {
        _BBSView.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
    }
    [self hideViewWithSuperView:_BBSView hide:!sender.selected];
    [_amountView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _BBSView.viewBottomEdge + 10)];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _amountView.viewBottomEdge);
}

/**
 *  选择优惠券
 */
- (void)clickedCouponsChooseButton:(UIButton *)sender {
    [self.view endEditing:YES];
    UIButton * button;
    if (sender.tag >= 15100) {
        button = [self.view viewWithTag:sender.tag - 100];
    }else{
        button = sender;
    }
    
    
    if (_lastCouponsButton == button) {
        NSLog(@"一样的");
        _lastCouponsButton = button;
        button.selected = !button.selected;
        if (button.selected) {
            NSInteger index = button.tag - 15000;
            _couponsLabel.text = [NSString stringWithFormat:@"¥%@", _couponsArray[index][@"voucher_price"]];
            _couponsID = _couponsArray[index][@"voucher_id"];
        }
        else {
            _couponsLabel.text = @"未选择";
            _couponsID = nil;
        }
    }
    else {
        NSLog(@"不一样");
        _lastCouponsButton.selected = NO;
        _lastCouponsButton = button;
        button.selected = !button.selected;
        NSInteger index = button.tag - 15000;
        _couponsLabel.text = [NSString stringWithFormat:@"¥%@", _couponsArray[index][@"voucher_price"]];
        _couponsID = _couponsArray[index][@"voucher_id"];
    }
    [self prepareOrderRequestWithVoucher:_couponsID];
}
/**
 *  根据优惠券的选择改变价格
 */
- (void)reloadAmountTableView {
    [self calculationAmountWithOtherAmount:_orderInfoDataSourceDic[@"additional"]];
    NSString * amountString = _orderInfoDataSourceDic[@"additional"][@"payprice"][@"value"];
    _amountLabel.text = [NSString stringWithFormat:@"¥%@", amountString];
    [_amountLabel sizeToFit];
    [_amountLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, (45 - _amountLabel.viewHeight) / 2)];
    
    //判断存不存在运费的情况
    NSDictionary * freightDic = [NSDictionary dictionaryWithDictionary:_orderInfoDataSourceDic[@"additional"][@"freight"]];
    if ([freightDic[@"value"] integerValue] != 0) {
        _freightLabel.text = [NSString stringWithFormat:@"(含运费¥%@)", _orderInfoDataSourceDic[@"additional"][@"freight"][@"value"]];
        [_freightLabel sizeToFit];
        [_freightLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, (45 - _amountLabel.viewHeight) / 2)];
        [_amountView addSubview:_freightLabel];
        [_amountLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(_freightLabel.viewX - 10, (45 - _amountLabel.viewHeight) / 2)];
    }
    if (_amountTableView) {
        [_amountTableView reloadData];
    }
}

/**
 *  点击展开或收拢优惠券
 */
- (void)clickedCoupounsButton:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
    _couponsJiantouButton.selected = sender.selected;
    if (sender.selected) {
        NSInteger count = _couponsArray.count;
        _couponsView.viewSize = CGSizeMake(SCREEN_WIDTH, 45 * (count + 1) + count);
        [self hideViewWithSuperView:_couponsView hide:NO];
    }
    else {
        _couponsView.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [self hideViewWithSuperView:_couponsView hide:YES];
    }
    [_couponsBottomLine align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _couponsView.viewHeight)];
    
    [_BBSView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _couponsView.viewBottomEdge + 10)];
    
    [_amountView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _BBSView.viewBottomEdge + 10)];
//    [_amountView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _couponsView.viewBottomEdge + 10)];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _amountView.viewBottomEdge);
}
/**
 *  点击提交订单
 */
- (void)clickedSumbmiyOrderButton {
    [self.view endEditing:YES];
    if (!_isHaveAddress) {
        SHOW_MSG(@"请选择收货地址");
        return;
    }
    NSMutableDictionary * dic;
    if (self.isCar) {
        dic = [NSMutableDictionary dictionaryWithDictionary:@{@"iscart":@"1",@"addrId":_addressInfoDic[@"address_id"],@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"cartId":self.cartId,@"num":self.goodsNumString,@"payName":@"online"}];
    }
    else {
        dic = [NSMutableDictionary dictionaryWithDictionary:@{@"iscart":@"0",@"addrId":_addressInfoDic[@"address_id"],@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"goodsId":self.goodsId,@"num":self.goodsNumString,@"payName":@"online"}];
    }
    
    if (_couponsID) {
        [dic setObject:_couponsID forKey:@"voucher"];
    }
    
    if (_BBSTextField.text.length != 0) {
        [dic setObject:_BBSTextField.text forKey:@"pay_message"];
    }
    
    [self submitOrderRequestWithDic:dic];
}
#pragma mark -- 其他
/**
 *  隐藏或显示超出视图高度的部分视图
 */
- (void)hideViewWithSuperView:(UIView *)superView hide:(BOOL)hide {
    for (UIView * view in superView.subviews) {
        if (hide) {
            if (view.viewBottomEdge > superView.viewHeight) {
                view.hidden = YES;
            }
        }
        else {
            view.hidden = NO;
        }
    }
}
/**
 *  计算金额
 */
- (void)calculationAmountWithOtherAmount:(NSDictionary *)otherAmount {
    [_amountTitleArray removeAllObjects];
    NSMutableArray * keyArray = [NSMutableArray arrayWithObjects:otherAmount[@"goods_total"], otherAmount[@"activity"], otherAmount[@"tariff"], otherAmount[@"freight"], otherAmount[@"payprice"],otherAmount[@"back_total"], nil];
    for (int i = 0; i < keyArray.count; i ++) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        if (((NSString *)keyArray[i][@"value"]).length == 0) {
            [dic setObject:@"0.00" forKey:keyArray[i][@"title"]];
        }
        else {
            [dic setObject:keyArray[i][@"value"] forKey:keyArray[i][@"title"]];
        }
        [_amountTitleArray addObject:dic];
    }
}

- (void)removeAllSubviews {
    for (UIView * view in self.view.subviews) {
        [view removeFromSuperview];
    }
}

#pragma mark -- 网络请求
/**
 *  准备订单
 *  voucher：优惠券ID   【未选择优惠券，该参数不传】
 */
- (void)prepareOrderRequestWithVoucher:(NSString *)voucher {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"num":self.goodsNumString}];
    //判断是否从购物车进
    if (self.isCar) {
        [dic setObject:@"1" forKey:@"iscart"];
        [dic setObject:self.cartId forKey:@"cartId"];
    }
    else {
        [dic setObject:@"0" forKey:@"iscart"];
        [dic setObject:self.goodsId forKey:@"goodsId"];
    }
    //判断是否有选择优惠券
    if (voucher != nil) {
        [dic setObject:voucher forKey:@"voucher"];
    }
    /**
     *  关闭用户交互是为了防止在网络请求还没有完成的情况下，用户多次点击优惠券
     */
    [self.HUD show:YES];
    self.view.userInteractionEnabled = NO;
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"OrderInfo" parameters:dic callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        self.view.userInteractionEnabled = YES;
        if (result == RequestResultSuccess) {
            _orderInfoDataSourceDic = [NSDictionary dictionaryWithDictionary:object[@"data"]];
            if (voucher == nil) {
                self.dataSourceArray = [NSArray arrayWithArray:object[@"data"][@"goods_list"]];
                [self calculationAmountWithOtherAmount:_orderInfoDataSourceDic[@"additional"]];
                [self removeAllSubviews];
                [self initUserInterface];
            }
            [self reloadAmountTableView];
        }
        else if (result == RequestResultFailed) {
            SHOW_MSG(object);
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

/**
 *  下订单的网络请求
 */
- (void)submitOrderRequestWithDic:(NSDictionary *)dic {
    _submitOrderButton.userInteractionEnabled = NO;
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"CreateOrder" parameters:dic callBack:^(RequestResult result, id object) {
        _submitOrderButton.userInteractionEnabled = YES;
        [self.HUD hide:YES];
        if (result == RequestResultSuccess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppcarNum" object:nil];
            NSDictionary *dataSourceDic = [NSMutableDictionary dictionaryWithDictionary:object[@"data"]];
            PayMethodViewController *payMethodVC = [[PayMethodViewController alloc] init];
            payMethodVC.isPopRoot = YES;
            payMethodVC.isAPay = _isHaveA;
            payMethodVC.personCash = dataSourceDic[@"available"];
            payMethodVC.orderID = dataSourceDic[@"order_id"];
            payMethodVC.orderNum = dataSourceDic[@"order_sn"];
            payMethodVC.orderTime = dataSourceDic[@"add_time"];
            payMethodVC.totalCash = dataSourceDic[@"order_amount"];
            payMethodVC.orderPaySn = dataSourceDic[@"pay_sn"];
            
//            ChoosePayWayViewController * payVC = [[ChoosePayWayViewController alloc] init];
//            payVC.dataSourceDic = [NSMutableDictionary dictionaryWithDictionary:object[@"data"]];
//            [payVC.dataSourceDic setObject:self.dataSourceArray forKey:@"goods_list"];
//            payVC.isPopRootVC = YES;
//            payVC.isOnePayWay = _isHaveA;
            [self.navigationController pushViewController:payMethodVC animated:YES];
        }else if (result == RequestResultFailed) {
            SHOW_EEROR_MSG(object);
        }else if ([object[@"code"] integerValue] == 999) {
            if (((NSString *)object[@"data"]).length == 0) {
                SHOW_EEROR_MSG(object[@"message"]);
            }
            else {
                SHOW_EEROR_MSG(object[@"data"]);
            }
        }
        else {
            
        }
    }];
}

#pragma mark - 键盘
/**
 *  注册键盘状态通知
 */
- (void)registerKeyboardStateNotification {
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

//键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat textFieldBottonEdge = 0;
    if (_scrollView.contentOffset.y > 0) {
        textFieldBottonEdge = _inputTextField.viewBottomEdge + _inputTextField.superview.viewY - _scrollView.contentOffset.y;
    }
    else {
        textFieldBottonEdge = _inputTextField.viewBottomEdge + _inputTextField.superview.viewY;
    }
    
    CGFloat offset = textFieldBottonEdge - (SCREEN_HEIGHT - kbHeight - 40);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    WEAK_SELF;
    if(offset >= 0) {
        [UIView animateWithDuration:duration animations:^{
            weakSelf.view.frame = CGRectMake(0.0f, -offset, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    }
    else {
        [UIView animateWithDuration:duration animations:^{
            weakSelf.view.frame = CGRectMake(0.0f, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //视图下沉恢复原状
    WEAK_SELF;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
