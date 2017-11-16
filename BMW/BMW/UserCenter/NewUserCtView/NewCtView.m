//
//  NewCTView.m
//  BMW
//
//  Created by rr on 2016/12/6.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "NewCTView.h"
#import "UIImageView+AFNetworking.h"


@interface NewCTView ()
{
    NSArray *_imageArray;
    NSArray *_titleArray;
    NSDictionary *_dataDic;
    
    UIView *_headerView;
    
    UIButton *_loginButton;
    
    UIButton *_xiaoxiBtn;
    UIButton *_shezhiBtn;
    
    UIImageView *_adverImage;
    UIView *_monthView;
    UIView *_redPoint;
    
    UIImageView *_icon_bangmai;

    UIView *_mystoreView;
    UILabel *_storeLabel;
}

@end

@implementation NewCTView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imageArray = @[@"icon_daifukuan_wd.png",@"icon_daifahuo_wd.png",@"icon_daishouhuo_wd.png",@"icon_daipingjia_wd.png",@"icon_tuikuan_wd.png"];
        _titleArray = @[@"待付款",@"待发货",@"待收货",@"待评价",@"退款/退货"];
        
        _dataDic = @{@"imageA":@[@"icon_shouhuodizhi_wd.png",@"icon_wodeshoucang_wd.png",@"icon_zaixiankefu_grzx.png",@"icon_bangzhufankui_wd.png"],@"titleA":@[@"收货地址",@"我的收藏",@"在线客服",@"帮助反馈"]};
        [self initUserinterface];
        
    }
    return self;
}

-(void)initUserinterface{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.backgroundColor = COLOR_BACKGRONDCOLOR;
    [_scrollView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
    [self addSubview:_scrollView];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400*W_ABCH)];
    _headerView.backgroundColor = COLOR_BACKGRONDCOLOR;
    [_scrollView addSubview:_headerView];
    
    _backGroundImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 205*W_ABCH)];
    _backGroundImageV.userInteractionEnabled = YES;
    [_backGroundImageV sd_setImageWithURL:nil placeholderImage:IMAGEWITHNAME(@"jpg_beijing_wd.png") options:SDWebImageRefreshCached];
    [_headerView addSubview:_backGroundImageV];
    
    _xiaoxiBtn = [UIButton new];
    _xiaoxiBtn.viewSize = CGSizeMake(20, 20);
    [_xiaoxiBtn setImage:IMAGEWITHNAME(@"icon_xiaoxi_wd.png") forState:UIControlStateNormal];
    [_xiaoxiBtn align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH-16*W_ABCW, 23*W_ABCH)];
    [_xiaoxiBtn addTarget:self action:@selector(xiaoxi) forControlEvents:UIControlEventTouchUpInside];
    [_backGroundImageV addSubview:_xiaoxiBtn];
    UIButton *xiaoxiBig = [UIButton new];
    xiaoxiBig.viewSize = CGSizeMake(35, 35);
    xiaoxiBig.center = _xiaoxiBtn.center;
    [xiaoxiBig addTarget:self action:@selector(xiaoxi) forControlEvents:UIControlEventTouchUpInside];
    [_backGroundImageV addSubview:xiaoxiBig];
    
    _redPoint = [UIView new];
    _redPoint.hidden = YES;
    _redPoint.viewSize = CGSizeMake(10, 10);
    _redPoint.backgroundColor = [UIColor colorWithHex:0xfd5487];
    _redPoint.layer.cornerRadius = _redPoint.viewWidth / 2;
    _redPoint.layer.borderWidth = 0.5;
    _redPoint.layer.borderColor = [UIColor whiteColor].CGColor;
    _redPoint.center = CGPointMake(_xiaoxiBtn.viewWidth - 1, 1);
    [_xiaoxiBtn addSubview:_redPoint];
    
    
    _shezhiBtn = [UIButton new];
    _shezhiBtn.viewSize = CGSizeMake(20, 20);
    [_shezhiBtn setImage:IMAGEWITHNAME(@"icon_shezhi_wd.png") forState:UIControlStateNormal];
    [_shezhiBtn align:ViewAlignmentTopRight relativeToPoint:CGPointMake(_xiaoxiBtn.viewX-15*W_ABCW, _xiaoxiBtn.viewY)];
    [_shezhiBtn addTarget:self action:@selector(shezhiBtn) forControlEvents:UIControlEventTouchUpInside];
    [_backGroundImageV addSubview:_shezhiBtn];

    UIButton *bigSheBtn = [UIButton new];
    bigSheBtn.center = _shezhiBtn.center;
    bigSheBtn.viewSize = CGSizeMake(35, 35);
    [bigSheBtn addTarget:self action:@selector(shezhiBtn) forControlEvents:UIControlEventTouchUpInside];
    [_backGroundImageV addSubview:bigSheBtn];
    
    
    _touxiangImage = [UIImageView new];
    _touxiangImage.viewSize = CGSizeMake(70 * W_ABCW, 70 * W_ABCW);
    [_touxiangImage align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(25*W_ABCW, 57*W_ABCH)];
    _touxiangImage.userInteractionEnabled = YES;
    [_touxiangImage sd_setImageWithURL:[NSURL URLWithString:[JCUserContext sharedManager].currentUserInfo.memberAvatar] placeholderImage:IMAGEWITHNAME(@"jpg_morentouxiang_wd.png") options:SDWebImageRefreshCached];
    _touxiangImage.layer.cornerRadius = _touxiangImage.viewHeight / 2;
    _touxiangImage.layer.masksToBounds = YES;
    [_backGroundImageV addSubview:_touxiangImage];
    
    _icon_bangmai = [[UIImageView alloc] initWithFrame:CGRectMake(_touxiangImage.viewRightEdge-20*W_ABCW, _touxiangImage.viewBottomEdge - 10*W_ABCH, 18, 18)];
    [_backGroundImageV addSubview:_icon_bangmai];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedUserInfo)];
    [_touxiangImage addGestureRecognizer:tap];
    
    _userName = [[UILabel alloc] initWithFrame:CGRectMake(_touxiangImage.viewRightEdge+18*W_ABCW, _touxiangImage.viewY+16*W_ABCH, SCREEN_WIDTH, 13)];
    _userName.textColor = [UIColor colorWithHex:0xffffff];
    _userName.font = fontForSize(13);
    [_backGroundImageV addSubview:_userName];
    
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(_userName.viewX, _userName.viewBottomEdge+10*W_ABCH, 60*W_ABCW, 18*W_ABCH)];
    _loginButton.userInteractionEnabled = NO;
    [_loginButton setTitle:@"普通用户" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    _loginButton.titleLabel.font = fontForSize(10);
    [_loginButton setBackgroundColor:[UIColor colorWithHex:0xfd5487]];
    _loginButton.layer.masksToBounds = YES;
    _loginButton.layer.cornerRadius = 9;
    [_loginButton sizeToFit];
    _loginButton.viewSize = CGSizeMake(_loginButton.viewWidth+20*W_ABCW, 18*W_ABCH);
    [_loginButton addTarget:self action:@selector(loginButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [_backGroundImageV addSubview:_loginButton];
    
    [self initMonthView];
    
    
    UIView *myOrderV = [[UIView alloc] initWithFrame:CGRectMake(0, _backGroundImageV.viewBottomEdge, SCREEN_WIDTH, 106*W_ABCH)];
    myOrderV.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:myOrderV];
    
    UIImageView *orderImage = [[UIImageView alloc] initWithFrame:CGRectMake(15*W_ABCW, 11.5*W_ABCW, 14, 15)];
    [orderImage align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(15*W_ABCW, 45*W_ABCH/2)];
    orderImage.image = IMAGEWITHNAME(@"icon_wodedingdan_wd.png");
    [myOrderV addSubview:orderImage];
    
    UILabel *orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(orderImage.viewRightEdge+12*W_ABCW, 0, 60, 45*W_ABCH)];
    orderLabel.text = @"我的订单";
    orderLabel.textColor = [UIColor colorWithHex:0x000000];
    orderLabel.font = fontForSize(12*W_ABCH);
    [orderLabel sizeToFit];
    orderLabel.viewHeight = 45*W_ABCH;
    [myOrderV addSubview:orderLabel];
    
    UIImageView *rightRow = [UIImageView new];
    rightRow.viewSize = CGSizeMake(6, 13);
    rightRow.image = IMAGEWITHNAME(@"icon_jiantou_wd.png");
    [rightRow align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15*W_ABCW, 45*W_ABCH/2)];
    [myOrderV addSubview:rightRow];
    
    UILabel *allOrderLabel = [UILabel new];
    allOrderLabel.viewSize = CGSizeMake(60, 45*W_ABCH);
    [allOrderLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(rightRow.viewX-6*W_ABCW, 0)];
    allOrderLabel.text = @"全部订单";
    allOrderLabel.textAlignment = NSTextAlignmentRight;
    allOrderLabel.font = fontForSize(12*W_ABCH);
    allOrderLabel.textColor = [UIColor colorWithHex:0x666666];
    [allOrderLabel sizeToFit];
    allOrderLabel.viewHeight = 45*W_ABCH;
    [myOrderV addSubview:allOrderLabel];
    
    UIButton *myOrderB = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45*W_ABCH)];
    [myOrderB addTarget:self action:@selector(gotoMyorder) forControlEvents:UIControlEventTouchUpInside];
    [myOrderV addSubview:myOrderB];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 45*W_ABCH, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = COLOR_BACKGRONDCOLOR;
    [myOrderV addSubview:line];
    
    CGFloat item = SCREEN_WIDTH/5;
    
    for (int i=0; i<5; i++) {
        UIImageView *imageV = [UIImageView new];
        imageV.viewSize = CGSizeMake(20*W_ABCW, 20*W_ABCW);
        [imageV align:ViewAlignmentTopCenter relativeToPoint:CGPointMake(item*i+item/2, line.viewBottomEdge + 10*W_ABCW)];
        imageV.image = IMAGEWITHNAME(_imageArray[i]);
        [myOrderV addSubview:imageV];
        
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageV.viewRightEdge-4*W_ABCW, line.viewBottomEdge+4*W_ABCH, 0, 0)];
        numLabel.tag = 10001+i;
        numLabel.textColor = [UIColor colorWithHex:0xffffff];
        numLabel.backgroundColor = [UIColor colorWithHex:0xfd5487];
        [myOrderV addSubview:numLabel];
        
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(item*i, imageV.viewBottomEdge+5*W_ABCW, item, 12*W_ABCH)];
        stateLabel.textAlignment = NSTextAlignmentCenter;
        stateLabel.text = _titleArray[i];
        stateLabel.textColor = [UIColor colorWithHex:0x5f646e];
        stateLabel.font = fontForSize(12*W_ABCH);
        [myOrderV addSubview:stateLabel];
        
        UIButton *orderStateB = [[UIButton alloc] initWithFrame:CGRectMake(item*i, line.viewBottomEdge, item, 55*W_ABCW)];
        orderStateB.tag = 666+i;
        [orderStateB addTarget:self action:@selector(gotoStateB:) forControlEvents:UIControlEventTouchUpInside];
        [myOrderV addSubview:orderStateB];
    }
    
    for (int i = 0; i<4; i++) {
        UIView *placeV = [[UIView alloc] initWithFrame:CGRectMake(i*((SCREEN_WIDTH-6*W_ABCW)/4+2*W_ABCW), myOrderV.viewBottomEdge+7*W_ABCH, (SCREEN_WIDTH-6*W_ABCW)/4, 78*W_ABCH)];
        placeV.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:placeV];
        
        UIImageView *pImageV = [UIImageView new];
        pImageV.viewSize = CGSizeMake(25, 25);
        pImageV.image = IMAGEWITHNAME(_dataDic[@"imageA"][i]);
        [pImageV align:ViewAlignmentTopCenter relativeToPoint:CGPointMake(placeV.viewWidth/2, 20*W_ABCH)];
        [placeV addSubview:pImageV];
        
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, pImageV.viewBottomEdge+12*W_ABCH, placeV.viewWidth, 12*W_ABCH)];
        nameL.textAlignment = NSTextAlignmentCenter;
        nameL.text = _dataDic[@"titleA"][i];
        nameL.textColor = [UIColor colorWithHex:0x000000];
        nameL.font = fontForSize(12*W_ABCH);
        [placeV addSubview:nameL];
        
        UIButton * tagButton = [[UIButton alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH/4, myOrderV.viewBottomEdge+7*W_ABCH, SCREEN_WIDTH/4, 78*W_ABCH)];
        tagButton.tag = i+909;
        [tagButton addTarget:self action:@selector(chooseButton:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:tagButton];
    }
    
    _adverImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, myOrderV.viewBottomEdge+92*W_ABCH, SCREEN_WIDTH, 1)];
    _adverImage.userInteractionEnabled = YES;
    [_headerView addSubview:_adverImage];
    UITapGestureRecognizer * advertap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedAdver)];
    [_adverImage addGestureRecognizer:advertap];
    [self myshopView];
    
    _headerView.viewHeight = _adverImage.viewBottomEdge+7*W_ABCH;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _headerView.viewBottomEdge);
}

/**
 *  初始化数据
 */
- (void)initMonthView
{
    _monthView = [[UIView alloc] initWithFrame:CGRectMake(0, _backGroundImageV.viewBottomEdge-44*W_ABCH, self.viewWidth, 44 * W_ABCH)];
    _monthView.alpha= 0.2;
    _monthView.backgroundColor = [UIColor blackColor];
    [_backGroundImageV addSubview:_monthView];
    //, @"银行卡"
    NSArray * items = @[@"M币", @"优惠券",@"银行卡"];
    CGFloat width = self.viewWidth / items.count;
    for (int i = 0; i < items.count; i ++) {
        UILabel * top = [[UILabel alloc]initWithFrame:CGRectMake(width * i, _monthView.viewY + 2 * W_ABCW, width, 22 * W_ABCH)];
        top.font = [UIFont boldSystemFontOfSize:13];
        top.textAlignment = NSTextAlignmentCenter;
        top.textColor = [UIColor colorWithHex:0xffffff];
        top.text = @"0";
        [_backGroundImageV addSubview:top];
        
        UILabel * bottom = [[UILabel alloc]initWithFrame:CGRectMake(top.viewX, top.viewBottomEdge, width, 13 * W_ABCH)];
        bottom.font = [UIFont systemFontOfSize:12];
        bottom.textAlignment = NSTextAlignmentCenter;
        bottom.textColor = [UIColor colorWithHex:0xffffff];
        bottom.text = items[i];
        [_backGroundImageV addSubview:bottom];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(top.viewX, _monthView.viewY, width, _monthView.viewHeight);
        btn.tag = 200 + i;
        [btn addTarget:self action:@selector(monthViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [_backGroundImageV addSubview:btn];
        switch (i) {
            case 0: {
                self.moneyCount = top;
                self.moneyCount.text = [NSString stringWithFormat:@"%.2f",[top.text floatValue]];
            }
                break;
            case 1: {
                self.coupCount = top;
                UIView * line = [[UIView alloc]initWithFrame:CGRectMake(width * i, _monthView.viewY + 12 * W_ABCW, 1, 17 * W_ABCH)];
                line.backgroundColor = [UIColor colorWithHex:0xdedede];
                [_backGroundImageV addSubview:line];
            }
                break;
            case 2: {
                self.bankCount = top;
                UIView * line = [[UIView alloc]initWithFrame:CGRectMake(width * i, _monthView.viewY + 12 * W_ABCW, 1, 17 * W_ABCH)];
                line.backgroundColor = [UIColor colorWithHex:0xdedede];
                [_backGroundImageV addSubview:line];
            }
                break;
            default:
                break;
        }
    }
}

-(void)myshopView{
    _mystoreView = [[UIView alloc] initWithFrame:CGRectMake(0, _adverImage.viewY, SCREEN_WIDTH, 92*W_ABCH)];
    _mystoreView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_mystoreView];
    
    UIImageView  *storeImgaeV = [[UIImageView alloc] initWithFrame:CGRectMake(15*W_ABCW, 0, 17, 15)];
    [storeImgaeV align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(15*W_ABCW, 40*W_ABCH/2)];
    storeImgaeV.image = IMAGEWITHNAME(@"icon_maikazhuanxiang_grzx.png");
    [_mystoreView addSubview:storeImgaeV];
    
    _storeLabel = [[UILabel alloc] initWithFrame:CGRectMake(storeImgaeV.viewRightEdge+12*W_ABCW, 0, SCREEN_WIDTH, 40*W_ABCH)];
    _storeLabel.textColor = [UIColor colorWithHex:0x000000];
    _storeLabel.font = fontForSize(12*W_ABCH);
    _storeLabel.text = [NSString stringWithFormat:@"%@",@"麦咖专享"];
    [_storeLabel sizeToFit];
    _storeLabel.viewHeight = 40*W_ABCH;
    [_mystoreView addSubview:_storeLabel];
    
    UIImageView *rightRow = [UIImageView new];
    rightRow.viewSize = CGSizeMake(6, 13);
    rightRow.image = IMAGEWITHNAME(@"icon_jiantou_wd.png");
    [rightRow align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15*W_ABCW, 40*W_ABCH/2)];
//    [_mystoreView addSubview:rightRow];
    
    UIButton *storeBtn = [UIButton new];
    storeBtn.viewSize = CGSizeMake(62, 45*W_ABCH);
    [storeBtn align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(rightRow.viewX-6*W_ABCW, 45*W_ABCH/2)];
    [storeBtn setTitle:@"管理店铺" forState:UIControlStateNormal];
    [storeBtn setTitleColor:COLOR_NAVIGATIONBAR_BARTINT forState:UIControlStateNormal];
    storeBtn.titleLabel.font = fontForSize(12);
    [storeBtn addTarget:self action:@selector(mangerStore) forControlEvents:UIControlEventTouchUpInside];
//    [_mystoreView addSubview:storeBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _storeLabel.viewBottomEdge, SCREEN_WIDTH, 1*W_ABCH)];
    line.backgroundColor = COLOR_BACKGRONDCOLOR;
    [_mystoreView addSubview:line];
//    ,@"团队人数"
    NSArray *titleA = @[@"我的收入",@"直属麦咖"];
    CGFloat with = SCREEN_WIDTH/titleA.count;
    for (int i = 0; i<titleA.count; i++) {
        UILabel *NumLabel = [[UILabel alloc] initWithFrame:CGRectMake(with*i,line.viewBottomEdge+9*W_ABCH, with,15)];
        NumLabel.textColor = COLOR_NAVIGATIONBAR_BARTINT;
        NumLabel.textAlignment = NSTextAlignmentCenter;
        NumLabel.font = fontForSize(15*W_ABCH);
        NumLabel.tag = 777+i;
        [_mystoreView addSubview:NumLabel];
        
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(NumLabel.viewX, NumLabel.viewBottomEdge+9*W_ABCH, with, 12*W_ABCH)];
        titleL.text = titleA[i];
        titleL.textColor = [UIColor colorWithHex:0x000000];
        titleL.font = fontForSize(12*W_ABCH);
        titleL.textAlignment = NSTextAlignmentCenter;
        [_mystoreView addSubview:titleL];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(with*(i+1),line.viewBottomEdge+10*W_ABCH, 1, 32*W_ABCH)];
        line1.backgroundColor = COLOR_BACKGRONDCOLOR;
        [_mystoreView addSubview:line1];
        
        UIButton *tagButton = [[UIButton alloc] initWithFrame:CGRectMake(with*i, line.viewBottomEdge, with, _mystoreView.viewHeight)];
        tagButton.tag = 888+i;
        [tagButton addTarget:self action:@selector(tagBtnProess:) forControlEvents:UIControlEventTouchUpInside];
        [_mystoreView addSubview:tagButton];
    }
}

-(void)updateMystore:(NSDictionary *)dic{
    for (int i = 0; i < 3; i++) {
        UILabel *NumB = [_mystoreView viewWithTag:777+i];
        if (i==0) {
            NumB.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKeyNotNull:@"available_income"] floatValue]];
        }else if (i==1){
            NumB.text = [NSString stringWithFormat:@"%@",[dic objectForKeyNotNull:@"store"]];
        }else{
            NumB.text = [NSString stringWithFormat:@"%@",[dic objectForKeyNotNull:@"recommend"]];
        }
    }
    
    
}



-(void)tagBtnProess:(UIButton *)sender{
    if (sender.tag==888) {
        if ([self.delegate respondsToSelector:@selector(BtnProess)]) {
            [self.delegate BtnProess];
        }
    }
}



-(void)isloginView{
    [_scrollView.legendHeader endRefreshing];
    if (([[JCUserContext sharedManager].currentUserInfo.vip_level integerValue]>0)) {
        _mystoreView.hidden = NO;
        _adverImage.viewY = _mystoreView.viewBottomEdge +7*W_ABCH;
    }
    else {
        if (_mystoreView) {
            _mystoreView.hidden = YES;
            _adverImage.viewY = _mystoreView.viewY;
        }
    }

    _headerView.viewHeight = _adverImage.viewBottomEdge+7*W_ABCH;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _headerView.viewBottomEdge);
    
    
    _loginButton.userInteractionEnabled = YES;
    _userName.hidden = NO;
    _icon_bangmai.hidden = NO;
    
    if ([[JCUserContext sharedManager].currentUserInfo.drp_recommend boolValue]) {
        _icon_bangmai.image = IMAGEWITHNAME(@"icon_fenxiao_sy.png");
    }else {
        switch ([[JCUserContext sharedManager].currentUserInfo.vip_level integerValue]) {
            case 0:{
                //成为麦咖
                _icon_bangmai.image = nil;
            }
                break;
            default:{
                _icon_bangmai.image = IMAGEWITHNAME(@"icon_mai_grzx.png");
            }
                break;
        }
    }

    
    NSString * headImage = [JCUserContext sharedManager].currentUserInfo.memberAvatar;
    // 先移除该头像地址的缓存
    WEAK_SELF;
    [[SDImageCache sharedImageCache] removeImageForKey:headImage withCompletion:^{
        
        UIImageView * tempImage = [[UIImageView alloc] init];
        [weakSelf addSubview:tempImage];
        [tempImage sd_setImageWithURL:[NSURL URLWithString:headImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                _touxiangImage.image = image;
            } else {
                _touxiangImage.image = IMAGEWITHNAME(@"jpg_morentouxiang_wd.png");
            }
            [tempImage removeFromSuperview];
        }];
    }];
    
    //判断是否显示vip
    if ([[JCUserContext sharedManager].currentUserInfo.drp_recommend boolValue]) {
        [_loginButton setTitle:@"分销商" forState:UIControlStateNormal];
    }
    else {
        switch ([[JCUserContext sharedManager].currentUserInfo.vip_level integerValue]) {
            case 0:
                [_loginButton setTitle:@"成为麦咖" forState:UIControlStateNormal];
                break;
            case 1:
                [_loginButton setTitle:@"麦咖" forState:UIControlStateNormal];
                break;
            case 2:
                [_loginButton setTitle:@"服务商" forState:UIControlStateNormal];
                break;
            case 3:
                [_loginButton setTitle:@"合伙人" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    [_loginButton sizeToFit];
    _loginButton.viewSize = CGSizeMake(_loginButton.viewWidth+20*W_ABCW, 18*W_ABCH);
    [_loginButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_userName.viewX, _userName.viewBottomEdge+10*W_ABCH)];
    if ([JCUserContext sharedManager].currentUserInfo.memberTrueName && [JCUserContext sharedManager].currentUserInfo.memberTrueName.length != 0) {
        _userName.text = [JCUserContext sharedManager].currentUserInfo.memberTrueName;
    }
    else {
        _userName.text = [NSString stringWithFormat:@"BM%@",[JCUserContext sharedManager].currentUserInfo.memberID];
    }

}

-(void)notLoginView{
    [_scrollView.legendHeader endRefreshing];
    if (_mystoreView) {
        _mystoreView.hidden = YES;
        _adverImage.viewY = _mystoreView.viewY;
    }
    _headerView.viewHeight = _adverImage.viewBottomEdge+7*W_ABCH;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _headerView.viewBottomEdge);
    _userName.hidden = YES;
    _loginButton.userInteractionEnabled = YES;
    _touxiangImage.image = IMAGEWITHNAME(@"jpg_morentouxiang_wd.png");
    _icon_bangmai.image = IMAGEWITHNAME(@"");
    [_loginButton setTitle:@"登录/注册" forState:UIControlStateNormal];
    [_loginButton sizeToFit];
    _loginButton.viewSize = CGSizeMake(_loginButton.viewWidth+20*W_ABCW, 18*W_ABCH);
    [_loginButton align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(_touxiangImage.viewRightEdge+18*W_ABCW, _touxiangImage.center.y)];
    self.moneyCount.text = @"0.00";
    self.coupCount.text = @"0";
    self.bankCount.text = @"0";
    [self updateNumOrder:nil];
}

-(void)updateBackGround:(NSString *)url{
    NSURL * backUrl = [NSURL URLWithString:url];
    [_backGroundImageV sd_setImageWithURL:backUrl placeholderImage:IMAGEWITHNAME(@"jpg_beijing_wd.png") options:SDWebImageRefreshCached];
}


-(void)updateAdverHeight:(NSString *)adverUrl{
    //广告更新限宽不限高
    if (adverUrl.length>0) {
        NSURL * url = [NSURL URLWithString:adverUrl];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        BOOL existBool = [manager diskImageExistsForURL:url];//判断是否有缓存
        UIImage * imageCache;
        if (existBool) {
            imageCache = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
            CGFloat bilie = SCREEN_WIDTH/imageCache.size.width;
            _adverImage.viewSize = CGSizeMake(SCREEN_WIDTH, imageCache.size.height*bilie);
            _adverImage.image = imageCache;
            _headerView.viewHeight = _adverImage.viewBottomEdge+7*W_ABCH;
            _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _headerView.viewBottomEdge);
        }else{
            UIImageView  *sd_imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            [sd_imageV sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!error) {
                    CGFloat bilie = SCREEN_WIDTH/image.size.width;
                    _adverImage.image = image;
                    _adverImage.viewSize = CGSizeMake(SCREEN_WIDTH, image.size.height*bilie);
                    _headerView.viewHeight = _adverImage.viewBottomEdge+7*W_ABCH;
                    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _headerView.viewBottomEdge);
                }
            }];
            [self addSubview:sd_imageV];
        }
    }else{
        _adverImage.viewSize = CGSizeZero;
        _headerView.viewHeight = _adverImage.viewBottomEdge+7*W_ABCH;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _headerView.viewBottomEdge);
    }
    
}

-(void)updateNumOrder:(NSDictionary *)orderDic{
    for (int i = 0; i<5; i++) {
        UILabel *label = [_headerView viewWithTag:10001+i];
        switch (i) {
            case 0:
                label.text = [NSString stringWithFormat:@"%@",orderDic[@"payment"]];
                break;
            case 1:
                label.text = [NSString stringWithFormat:@"%@",orderDic[@"delivery"]];
                break;
            case 2:
                label.text = [NSString stringWithFormat:@"%@",orderDic[@"deliverygoods"]];
                break;
            case 3:
                label.text = [NSString stringWithFormat:@"%@",orderDic[@"evaluation"]];
                break;
            case 4:
                label.text = [NSString stringWithFormat:@"%@",orderDic[@"service"]];
                break;
            default:
                break;
        }
        if (![label.text boolValue]) {
            label.hidden = YES;
        }else{
            label.hidden = NO;
            if ([label.text integerValue]>99) {
                label.text = @"99";
            }
            label.font = fontForSize(10);
            [label sizeToFit];
            if (label.viewWidth>15) {
                label.viewSize = CGSizeMake(label.viewWidth, label.viewWidth);
                label.layer.cornerRadius = label.frame.size.width/2;
            }else{
                label.viewSize = CGSizeMake(15, 15);
                label.layer.cornerRadius = 15/2;
            }
            label.textAlignment = NSTextAlignmentCenter;
            label.clipsToBounds = YES;
        }
    }
    
    
}

-(void)newsArray:(BOOL)array{
    _redPoint.hidden = array;
}

-(void)refreshView{
    if ([self.delegate respondsToSelector:@selector(ViewRf)]) {
        [self.delegate ViewRf];
    }
}

-(void)clickedUserInfo{
    if([self.delegate respondsToSelector:@selector(clickImageGoto)]){
        [self.delegate clickImageGoto];
    }
}

-(void)processSetButton{
    if ([self.delegate respondsToSelector:@selector(gotoProcess)]) {
        [self.delegate gotoProcess];
    }
}

-(void)loginButtonPress{
    if ([self.delegate respondsToSelector:@selector(loginBtn)]) {
        [self.delegate loginBtn];
    }
}

-(void)regisButtonPress{
    if ([self.delegate respondsToSelector:@selector(regisBtn)]) {
        [self.delegate regisBtn];
    }
}
-(void)gotoMyorder{
    if ([self.delegate respondsToSelector:@selector(myorder)]) {
        [self.delegate myorder];
    }
}

-(void)gotoStateB:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(stateB:)]){
        [self.delegate stateB:[NSString stringWithFormat:@"%ld",sender.tag-665]];
    }
}
- (void)monthViewAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(clickedMonthVewWithTag:)]) {
        [self.delegate clickedMonthVewWithTag:sender.tag - 200];
    }
}

-(void)chooseButton:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(didseletedTag:)]) {
        [self.delegate didseletedTag:sender.tag-909];
    }
}
-(void)xiaoxi{
    if ([self.delegate respondsToSelector:@selector(gotoXiaoxi)]) {
        [self.delegate gotoXiaoxi];
    }
}

-(void)shezhiBtn{
    if ([self.delegate respondsToSelector:@selector(processSetButton)]) {
        [self.delegate processSetButton];
    }
}

-(void)clickedAdver{
    if ([self.delegate respondsToSelector:@selector(adverProcess)]) {
        [self.delegate adverProcess];
    }
}

-(void)mangerStore{
    if ([self.delegate respondsToSelector:@selector(gotoMyStore)]) {
        [self.delegate gotoMyStore];
    }
}

@end


