//
//  JoinBangMaiViewController.m
//  BMW
//
//  Created by rr on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "JoinBangMaiViewController.h"
#import "ZhaoHangViewController.h"
#import "ApplyRIntroductionsViewController.h"

@interface JoinBangMaiViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    UIScrollView *_scrollView;
    UITextField *_moneyTextField;
    NSInteger _index;
    
    UIButton *_seletedBtn;
}

@property(nonatomic, strong)UIView *headerView;
@property(nonatomic, strong)UIView *choosePayWayView;

@end

@implementation JoinBangMaiViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self navigation];
    [self initData];
    [self initUserInterface];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPayResult:) name:@"AliPayResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payResult:) name:@"WXPayResult" object:nil];
}

#pragma mark -- notification
- (void)aliPayResult:(NSNotification *)notification
{
    if ([notification.object[@"code"] isEqualToString:@"9000"]) {
        [self gotoSuccess];
    }
}

-(void)payResult:(NSNotification *)sender{
    NSLog(@"%@",sender);
    if ([sender.object[@"code"] isEqualToString:@"0"]) {
        [self gotoSuccess];
    }
}

-(void)gotoSuccess{
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetUserInfo" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result == RequestResultSuccess) {
            NSDictionary * data = object[@"data"];
            Userentity *user = [[Userentity alloc] initWithJSONObject:data];
            [[JCUserContext sharedManager] updateUserInfo:user];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}


-(void)initData{
    _index = 0;
}

- (void)initUserInterface {
    
    _scrollView = [UIScrollView new];
    _scrollView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 65);
    [_scrollView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
    _scrollView.backgroundColor = [UIColor colorWithHex:0xf1f1ed];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    [_scrollView addSubview:self.headerView];
    [_scrollView addSubview:self.choosePayWayView];
    
    _seletedBtn = [[UIButton alloc] initWithFrame:CGRectMake(15*W_ABCW, self.choosePayWayView.viewBottomEdge+9*W_ABCH, 11, 11)];
    [_seletedBtn setBackgroundImage:IMAGEWITHNAME(@"icon_yigouxuan_jrbmd_cli.png") forState:UIControlStateSelected];
    [_seletedBtn setBackgroundImage:IMAGEWITHNAME(@"icon_weigouxuan_jrbmd_nor.png") forState:UIControlStateNormal];
    _seletedBtn.selected = YES;
    [_scrollView addSubview:_seletedBtn];
    UIButton *bigBtn = [[UIButton alloc] initWithFrame:CGRectMake(_seletedBtn.viewX, _seletedBtn.viewY, 30, 30)];
    [bigBtn addTarget:self action:@selector(seleBtn) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:bigBtn];
    
    UILabel *proLabel = [[UILabel alloc] initWithFrame:CGRectMake(_seletedBtn.viewRightEdge+6*W_ABCW, _seletedBtn.viewY, 100, 11)];
    proLabel.font = fontForSize(11);
    proLabel.text = @"已同意并阅读";
    proLabel.textColor = [UIColor colorWithHex:0x666666];
    [proLabel sizeToFit];
    proLabel.viewSize = CGSizeMake(proLabel.viewWidth, 11);
    [_scrollView addSubview:proLabel];
    
    UILabel *StorePro = [[UILabel alloc] initWithFrame:CGRectMake(proLabel.viewRightEdge, proLabel.viewY, 100, 11)];
    StorePro.textColor = [UIColor colorWithHex:0x0b75f4];
    StorePro.text = @"《麦咖服务协议》";
    StorePro.font = fontForSize(11);
    [StorePro sizeToFit];
    StorePro.viewSize = CGSizeMake(StorePro.viewWidth, 11);
    StorePro.userInteractionEnabled = YES;
    [_scrollView addSubview:StorePro];
    
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(proTag)];
    [StorePro addGestureRecognizer:tapG];
    
    
    UIButton * rechargeButton = [UIButton new];
    rechargeButton.viewSize = CGSizeMake(SCREEN_WIDTH, 45 * W_ABCH);
    [rechargeButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake( W_ABCH, SCREEN_HEIGHT - 64 -45*W_ABCH)];
    rechargeButton.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
    [rechargeButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    [rechargeButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [rechargeButton addTarget:self action:@selector(clickedRechargeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rechargeButton];
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, rechargeButton.viewBottomEdge + 15 * W_ABCH);
}

-(void)seleBtn{
    _seletedBtn.selected = !_seletedBtn.selected;
}

/**
 *  当前账号和年费
 */
- (UIView *)headerView
{
    if (!_headerView) {
        NSArray * nameArray = @[@"当前账号：", @"麦咖费用："];
        _headerView = [UIView new];
        _headerView.viewSize = CGSizeMake(SCREEN_WIDTH, 35 * nameArray.count * W_ABCH);
        [_headerView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        for (int i = 0; i < nameArray.count; i ++) {
            UILabel * nameLabel = [UILabel new];
            nameLabel.viewSize = CGSizeMake(78 * W_ABCH, 35 * W_ABCH);
            nameLabel.font = fontForSize(13);
            nameLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
            nameLabel.text = nameArray[i];
            [nameLabel sizeToFit];
            nameLabel.viewHeight = 35*W_ABCH;
            [nameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, i * nameLabel.viewHeight)];
            [_headerView addSubview:nameLabel];
            
            UITextField * textField = [UITextField new];
            textField.viewSize = CGSizeMake(SCREEN_WIDTH - 93 * W_ABCH, 35 * W_ABCH);
            [textField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(nameLabel.viewRightEdge, i * textField.viewHeight)];
            textField.font = fontForSize(13);
            textField.textColor = COLOR_NAVIGATIONBAR_BARTINT;
            textField.userInteractionEnabled = NO;
            if (i == 0) {
                textField.text = [JCUserContext sharedManager].currentUserInfo.memberName;
            }
            if (i == 1) {
                textField.placeholder = @"支付金额：";
                textField.text = _price;
                _moneyTextField = textField;
            }
            [_headerView addSubview:textField];
            
            UIView * lineView = [UIView new];
            lineView.viewSize = CGSizeMake(SCREEN_WIDTH - 30 * W_ABCH, 0.5 * W_ABCH);
            [lineView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, textField.viewBottomEdge - lineView.viewHeight)];
            lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
            [_headerView addSubview:lineView];
        }
    }
    return _headerView;
}
/**
 *  支付方式
 */
- (UIView *)choosePayWayView {
    if (!_choosePayWayView) {
        CGFloat height  = 35 * W_ABCH;
        NSArray *payWayArray = @[@"支付宝",@"微信",@"一网通银行卡支付"];
        _choosePayWayView = [UIView new];
        _choosePayWayView.viewSize = CGSizeMake(SCREEN_WIDTH, height * (payWayArray.count+1));
        [_choosePayWayView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _headerView.viewBottomEdge+5*W_ABCH)];
        _choosePayWayView.backgroundColor = [UIColor whiteColor];
        
        UILabel * titleLabel = [UILabel new];
        titleLabel.viewSize = CGSizeMake(100, height);
        [titleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, 0)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = fontForSize(13);
        titleLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        titleLabel.text = @"选择支付方式";
        [_choosePayWayView addSubview:titleLabel];
        NSArray *payWayImageArray = @[@"icon_zhifubao_jrbmd.png",@"icon_weixin_jrbmd.png",@"icon_yiwnagtong_jrbmd.png"];
        for (int i = 0; i < payWayArray.count; i ++) {
            UIView * line = [UIView new];
            line.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5*W_ABCH);
            [line align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, height  + height * i)];
            line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
            [_choosePayWayView addSubview:line];
            
            UIButton * chooseButton = [UIButton new];
            chooseButton.viewSize = CGSizeMake(12 * W_ABCH, 12 * W_ABCH);
            [chooseButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15*W_ABCW, line.viewBottomEdge + (height - chooseButton.viewHeight) / 2)];
            [chooseButton setBackgroundImage:[UIImage imageNamed:@"icon_weixuanze_jrbmd_nor.png"] forState:UIControlStateNormal];
            [chooseButton setBackgroundImage:[UIImage imageNamed:@"icon_yixuanze_jrbmd_cli.png"] forState:UIControlStateSelected];
            chooseButton.tag = 19000 + i;
            if (i==0) {
                chooseButton.selected = YES;
            }
            [chooseButton addTarget:self action:@selector(clickedPayWayChooseButton:) forControlEvents:UIControlEventTouchUpInside];
            [_choosePayWayView addSubview:chooseButton];
            
            UIButton * bigButton = [UIButton new];
            bigButton.viewSize = CGSizeMake(SCREEN_WIDTH - 30 * W_ABCH, height );
            [bigButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, line.viewBottomEdge)];
            bigButton.tag = chooseButton.tag + 100;
            [bigButton addTarget:self action:@selector(clickedPayWayChooseButton:) forControlEvents:UIControlEventTouchUpInside];
            [_choosePayWayView addSubview:bigButton];
            
            UIImageView * iconImageView = [UIImageView new];
            iconImageView.image = [UIImage imageNamed:payWayImageArray[i]];
            iconImageView.viewSize = iconImageView.image.size;
            [iconImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(chooseButton.viewRightEdge+7*W_ABCW, line.viewBottomEdge + (height - iconImageView.viewHeight) / 2)];
            [_choosePayWayView addSubview:iconImageView];
            
            UILabel * titleLabel = [UILabel new];
            titleLabel.viewSize = CGSizeMake(100, height);
            [titleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(iconImageView.viewRightEdge + 10*W_ABCW, line.viewBottomEdge)];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.font = fontForSize(13);
            titleLabel.textColor = [UIColor colorWithHex:0x181818];
            titleLabel.text = payWayArray[i];
            [titleLabel sizeToFit];
            titleLabel.viewHeight = height;
            [_choosePayWayView addSubview:titleLabel];
        }
        UIView * line = [UIView new];
        line.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5*W_ABCH);
        [line align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, _choosePayWayView.viewHeight)];
        line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_choosePayWayView addSubview:line];
    }
    return _choosePayWayView;
}

-(void)clickedRechargeButton{
    if (!_seletedBtn.selected) {
        SHOW_MSG(@"请先同意麦咖协议");
        return;
    }
    NSLog(@"立即支付");
    switch (_index) {
        case 0:
            //支付宝支付
            [TYTools paymentWithGoodsDetail:@{@"order_sn":_pay_sn, @"price":_price} isAlipay:YES NotifyURLType:PayNotifyURLOpenStore];
            break;
        case 1:
            //微信支付
        {
            [self.HUD show:YES];
            [BaseRequset sendPOSTRequestWithBMWApi2Method:@"BmVipGet" parameters:@{@"price":[NSString stringWithFormat:@"%.0f", [_price floatValue] * 100], @"orderSn":_pay_sn} callBack:^(RequestResult result, id object) {
                [self.HUD hide:YES];
                if (result == RequestResultSuccess) {
                    [TYTools paymentWithGoodsDetail:object[@"data"] isAlipay:NO NotifyURLType:PayNotifyURLOpenStore];
                }
            }];
        }
            break;
        case 2:{
            [self getZhaohang:_pay_sn];
        }
            break;
        default:
            break;
    }
}

-(void)clickedPayWayChooseButton:(UIButton *)sender{
    for (int i = 0; i < 4; i ++) {
        UIButton * button = [self.view viewWithTag:19000 + i];
        button.selected = NO;
    }
    NSInteger index;
    if (sender.tag>=19100) {
        index  = sender.tag -19100;
    }else{
        index = sender.tag - 19000;
    }
    UIButton * button = [self.view viewWithTag:19000 + index];
    button.selected = YES;
    _index = index;
}

-(void)getZhaohang:(NSString *)orderSN{
    NSDate *data = [NSDate date];
    NSDateFormatter *df1 = [[NSDateFormatter alloc]init];//格式化
    
    [df1 setDateFormat:@"yyyyMMddHHmmss"];
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc]init];//格式化
    
    [df2 setDateFormat:@"yyyyMMdd"];
    
    
    NSString* s1 = [df1 stringFromDate:data];
    NSString* s2 = [df2 stringFromDate:data];
    
    NSDictionary *dataDic = @{@"agrNo":@"12345",
                              @"amount":[NSString stringWithFormat:@"%.2f",[_price floatValue]],
                              @"branchNo":@"0028",
                              @"cardType":@"",
                              @"clientIP":@"",
                              @"date":s2,
                              @"dateTime":s1,
                              @"expireTimeSpan":@"30",
                              @"lat":@"",
                              @"lon":@"",
                              @"merchantNo":YiwangtongNo,//,024906
                              @"merchantSerialNo":@"",
                              @"mobile":@"",
                              @"orderNo":orderSN,
                              @"payNoticePara":@"",
                              @"payNoticeUrl":YiwangtongStoreURL,
                              @"returnUrl":@"http://CMBNPRM-POP",
                              @"riskLevel":@"",
                              @"signNoticePara":@"",
                              @"signNoticeUrl":YiwangtongSign,
                              @"userID":[JCUserContext sharedManager].currentUserInfo.memberID};
    NSString *json = [TYTools dataJsonWithDic:dataDic];
    json = [TYTools JSONDataStringTranslation:json];
    
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"BmvipSign" parameters:@{@"signdata":json} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            [self loadWebView:object[@"data"] andTimeDate:s2 andTime:s1];
            NSLog(@"%@",object);
        }else{
            SHOW_EEROR_MSG(object);
            NSLog(@"%@",object);
        }
    }];
}


-(void)loadWebView:(NSDictionary *)member andTimeDate:(NSString *)timedate andTime:(NSString *)time{
    NSDictionary *requdata =   @{@"agrNo":member[@"agrNo"],
                                 @"amount":[NSString stringWithFormat:@"%.2f",[_moneyTextField.text floatValue]],
                                 @"branchNo":@"0028",
                                 @"cardType":@"",
                                 @"clientIP":@"",
                                 @"date":timedate,
                                 @"dateTime":time,
                                 @"expireTimeSpan":@"30",
                                 @"lat":@"",
                                 @"lon":@"",
                                 @"merchantNo":YiwangtongNo,//024906,
                                 @"merchantSerialNo":member[@"merchantSerialNo"],
                                 @"mobile":@"",
                                 @"orderNo":member[@"orderNo"],
                                 @"payNoticePara":@"",
                                 @"payNoticeUrl":YiwangtongStoreURL,
                                 @"returnUrl":@"http://CMBNPRM-POP",
                                 @"riskLevel":@"",
                                 @"signNoticePara":@"",
                                 @"signNoticeUrl":YiwangtongSign,
                                 @"userID":[JCUserContext sharedManager].currentUserInfo.memberID};
    NSDictionary *dataDic =@{@"version":@"1.0",@"charset":@"UTF-8",@"sign":member[@"sign"],@"signType":@"SHA-256",@"reqData":requdata};
    ZhaoHangViewController *zhaoHanVC = [[ZhaoHangViewController alloc] init];
    zhaoHanVC.orderPaySn = _pay_sn;
    zhaoHanVC.dataDic = dataDic;
    [self.navigationController pushViewController:zhaoHanVC animated:YES];
}

//点击协议
-(void)proTag{
    ApplyRIntroductionsViewController * applyRVC = [[ApplyRIntroductionsViewController alloc] init];
    applyRVC.title = @"麦咖服务协议";
    NSError *error = nil;
     NSString *txtPath=[[NSBundle mainBundle]pathForResource:@"join" ofType:@"txt"];
    NSString * textFileContents = [[NSString alloc] initWithContentsOfFile:txtPath usedEncoding:nil error:&error];
    if (error) {
        textFileContents = @"";
    }
    applyRVC.contentString = textFileContents;
    [self.navigationController pushViewController:applyRVC animated:YES];
}




@end

