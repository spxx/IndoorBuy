//
//  GoodsTopAlbum.m
//  BMW
//
//  Created by gukai on 16/3/8.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "GoodsTopAlbum.h"
#import "GoodsAlbumCell.h"
#import "XHImageViewer.h"
#import "GoodsInfoModle.h"
#import "WatchView.h"



@interface GoodsTopAlbum ()<UIScrollViewDelegate,GoodsAlbumCellDelegate,XHImageViewerDelegate>{
    //限时
    UIView *_pricegroundView;
    UIImageView *_originalImageView;
    UILabel *_originalPriceLabel;
    UILabel *_originalVipLabel;
    UILabel *_endLabel;
    
    //促销
    UIView *_promotionView;
    UILabel *_promotionLabel;
    UILabel *_promotionWayLabel;
    UILabel *_promotionContentLabel;
    
    WatchView *_watchV;
}
@property(nonatomic,strong)UILabel * goodsIntroLabel;
@property(nonatomic,strong)UILabel * goodsPriceLabel;
@property(nonatomic,strong)UILabel * vipPriceLabel;
@property(nonatomic,strong)UILabel * saleNumLabel;
@property(nonatomic,strong)UILabel * warehouseLabel;


@property(nonatomic,strong)UIImageView * nationImage;
@property(nonatomic,strong)UILabel * sendTypeLabel;
@property(nonatomic,strong)UILabel * nationLabel;

@property(nonatomic,copy)NSMutableArray * imageViews;
@property (nonatomic, strong) UILabel *countReminderLabel; // 照片数量提示
@property(nonatomic,strong)UIScrollView * scrollView;


@end

@implementation GoodsTopAlbum

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}
-(void)initUserInterface
{
    [self initScrollerView];
    [self initDetailView];
}
-(void)initScrollerView
{
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 319 * W_ABCW)];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
}
-(void)initDetailView
{
    //初始化 商品介绍 以及收藏按钮
    
    UIView * collectBackgroudView = [[UIView alloc]initWithFrame:CGRectMake(0, self.scrollView.viewBottomEdge, SCREEN_WIDTH, 55)];
    
    collectBackgroudView.backgroundColor = [UIColor whiteColor];
    [self addSubview:collectBackgroudView];
    
    UILabel * goodIntroLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 * W_ABCW, 0, SCREEN_WIDTH - 62 * W_ABCW - 10 * W_ABCW, collectBackgroudView.viewHeight)];
    goodIntroLabel.textAlignment = NSTextAlignmentLeft;
    goodIntroLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
    goodIntroLabel.font = fontForSize(13);
    goodIntroLabel.numberOfLines = 2;
    goodIntroLabel.text = @"";
    [collectBackgroudView addSubview:goodIntroLabel];
    self.goodsIntroLabel = goodIntroLabel;
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(collectBackgroudView.viewWidth - 62 * W_ABCW, 0, 62 * W_ABCW, collectBackgroudView.viewHeight)];
    //view.backgroundColor = [UIColor orangeColor];
    [collectBackgroudView addSubview:view];
    
    _collectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 16)];
    _collectBtn.center = CGPointMake(view.viewWidth / 2, view.viewHeight / 2);
    [_collectBtn setImage:[UIImage imageNamed:@"icon_shoucang_nor_spxq.png"] forState:UIControlStateNormal];
    [_collectBtn setImage:[UIImage imageNamed:@"icon_shoucang_cli_spxq.png"] forState:UIControlStateSelected];
    _collectBtn.userInteractionEnabled = NO;
    [view addSubview:_collectBtn];
    
    UIButton * button = [[UIButton alloc]initWithFrame:view.bounds];
    [button addTarget:self action:@selector(collectBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 31)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    line.center = CGPointMake(0, view.viewHeight / 2);
    [view addSubview:line];
    
    
    //初始化价格视图
    _pricegroundView = [[UIView alloc]initWithFrame:CGRectMake(0, collectBackgroudView.viewBottomEdge, SCREEN_WIDTH, 30 + 16)];
    _pricegroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pricegroundView];
    
    UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 4, 100, 20)];
    priceLabel.textColor = [UIColor colorWithHex:0xfd5487];
    priceLabel.font = fontForSize(17);
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.text = @"￥ 00.00";
    [priceLabel sizeToFit];
    [_pricegroundView addSubview:priceLabel];
    self.goodsPriceLabel = priceLabel;
    
    UILabel * vipLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.viewX + 3, priceLabel.viewBottomEdge + 9, 80, 15)];
    vipLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    vipLabel.textAlignment = NSTextAlignmentLeft;
    vipLabel.font = fontForSize(10);
    vipLabel.text = @"麦咖专享返现 ￥ 00.00";
    [vipLabel sizeToFit];
    [_pricegroundView addSubview:vipLabel];
    self.vipPriceLabel = vipLabel;
    
    _originalImageView = [UIImageView new];
    [_originalImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH, 0)];
    _originalImageView.viewSize = CGSizeMake(106, 46);
    _originalImageView.image = IMAGEWITHNAME(@"bj_shijiankuang_spxq.png");
    _originalImageView.hidden = YES;
    [_pricegroundView addSubview:_originalImageView];
    
    
    
    UIButton * beVIPButton = [[UIButton alloc]initWithFrame:CGRectMake(self.vipPriceLabel.viewRightEdge + 3, self.vipPriceLabel.viewY, 60, self.vipPriceLabel.bounds.size.height)];
    //beVIPButton.backgroundColor = [UIColor orangeColor];
    [beVIPButton setTitle:@"加入麦咖" forState:UIControlStateNormal];
    [beVIPButton setTitleColor:[UIColor colorWithHex:0xfd5487] forState:UIControlStateNormal];
    beVIPButton.titleLabel.font = fontForSize(10);
    [beVIPButton addTarget:self action:@selector(beVIPButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_pricegroundView addSubview:beVIPButton];
    self.beVIPBtn = beVIPButton;
    self.beVIPBtn.hidden = YES;

    
    UIView *saleView = [[UIView alloc] initWithFrame:CGRectMake(0, _pricegroundView.viewBottomEdge+10, SCREEN_WIDTH, 20)];
    saleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:saleView];
    
    _saleNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
    _saleNumLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    _saleNumLabel.font = fontForSize(10);
    [saleView addSubview:_saleNumLabel];
    
    
    UILabel * sendTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    sendTypeLabel.textColor = [UIColor colorWithHex:0x5e5e5e];
    sendTypeLabel.font = fontForSize(10);
    [saleView addSubview:sendTypeLabel];
    self.sendTypeLabel = sendTypeLabel;
    
    UILabel * nationLabel = [[UILabel alloc]initWithFrame:CGRectMake(saleView.viewWidth-10-100, 0, 100, 20)];
    nationLabel.textAlignment = NSTextAlignmentRight;
    nationLabel.textColor = [UIColor colorWithHex:0xc0c0c0];
    nationLabel.font = fontForSize(10);
    [saleView addSubview:nationLabel];
    self.nationLabel = nationLabel;
    
    
    UIImageView * nationImage = [[UIImageView alloc]initWithFrame:CGRectMake(nationLabel.viewX - 5 - 17,4, 17, 12)];
    [saleView addSubview:nationImage];
    nationImage.layer.borderWidth = 1;
    nationImage.layer.borderColor = [UIColor colorWithHex:0xdedede].CGColor;
    nationImage.hidden = YES;
    self.nationImage = nationImage;
    
    _promotionView = [[UIView alloc] initWithFrame:CGRectMake(0, saleView.viewBottomEdge, SCREEN_WIDTH, 35)];
    _promotionView.backgroundColor = [UIColor colorWithHex:0xfff7f6];
    _promotionView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoAcitiy)];
    [_promotionView addGestureRecognizer:tap];
    [self addSubview:_promotionView];
    
    _promotionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 35)];
    _promotionLabel.text = @"促销：";
    _promotionLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    _promotionLabel.font = fontForSize(10);
    [_promotionLabel sizeToFit];
    _promotionLabel.viewHeight = 35;
    [_promotionView addSubview:_promotionLabel];
    
    _promotionWayLabel = [[UILabel alloc] initWithFrame:CGRectMake(_promotionLabel.viewRightEdge+8, 0, 100, 17)];
    _promotionWayLabel.textColor = [UIColor colorWithHex:0xfd5487];
    _promotionWayLabel.layer.borderWidth = 0.5;
    _promotionWayLabel.layer.borderColor = [UIColor colorWithHex:0xfd5487].CGColor;
    _promotionWayLabel.text = @"";
    _promotionWayLabel.font = fontForSize(10);
    _promotionWayLabel.textAlignment = NSTextAlignmentCenter;
    [_promotionWayLabel align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(_promotionLabel.viewRightEdge+8, 35/2)];
    [_promotionView addSubview:_promotionWayLabel];
    
    _promotionContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_promotionWayLabel.viewRightEdge+4, 0, SCREEN_WIDTH-_promotionWayLabel.viewRightEdge-14, 35)];
    _promotionContentLabel.text = @"";
    _promotionContentLabel.textColor = [UIColor colorWithHex:0x181818];
    _promotionContentLabel.font = fontForSize(10);;
    _promotionContentLabel.numberOfLines = 2;
    [_promotionView addSubview:_promotionContentLabel];
    
    UIImageView *rightRow = [UIImageView new];
    rightRow.viewSize = CGSizeMake(6, 10);
    [rightRow align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-10, 35/2)];
    rightRow.image = IMAGEWITHNAME(@"icon_xiaojiantou_sy.png");
    [_promotionView addSubview:rightRow];

    
    
}
#pragma mark -- Action --
-(void)collectBtnAction
{
//    成功才收藏
//    self.collectBtn.selected = !self.collectBtn.selected;
    if ([self.delegate respondsToSelector:@selector(goodsTopAlbumClickCollectButton:)]) {
        [self.delegate goodsTopAlbumClickCollectButton:_collectBtn];
    }
}
-(void)tapAction:(UIGestureRecognizer *)sender
{
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.disableTouchDismiss = NO;
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:self.imageViews
                       selectedView:(UIImageView *)sender.view];
}
-(void)beVIPButtonAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(goodsTopAlbumClickBeVIPButton:)]) {
        [self.delegate goodsTopAlbumClickBeVIPButton:sender];
    }
}
#pragma mark -- set --

-(void)setInfoModele:(GoodsDetailModle *)infoModele{
    _infoModele = infoModele;
    GoodsInfoModle *goodsInfo = [_infoModele modleFormGoods_Info_Str];
    [self imageViewWithArray:[TYTools JSONObjectWithString:_infoModele.goods_image_mobile]];
    /**
     *销量
     */
    _saleNumLabel.text = [NSString stringWithFormat:@"销量 %@",goodsInfo.goods_salenum];
    /**
     * 商品介绍
     */
    self.goodsIntroLabel.text = goodsInfo.goods_name;
    /**
     * 商品价格
     */
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"￥ %@",goodsInfo.goods_price];
    [self.goodsPriceLabel sizeToFit];
    [self.goodsPriceLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(10, 4)];
    self.goodsPriceLabel.viewHeight = 20;
    
    /**
     * 会员价格
     */
    self.vipPriceLabel.text = [NSString stringWithFormat:@"麦咖专享返现 ￥ %.2f",[goodsInfo.goods_price floatValue]-[ goodsInfo.goods_vip_price floatValue]];
    [self.vipPriceLabel sizeToFit];
    self.vipPriceLabel.frame = CGRectMake(self.goodsPriceLabel.viewX + 3, self.goodsPriceLabel.viewBottomEdge, self.vipPriceLabel.viewWidth, 15);
    _pricegroundView.backgroundColor = [UIColor colorWithHex:0xffffff];
    self.goodsPriceLabel.textColor = [UIColor colorWithHex:0xfd5487];
    self.vipPriceLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    [_pricegroundView addSubview:self.goodsPriceLabel];
    [_pricegroundView addSubview:self.vipPriceLabel];
    self.goodsPriceLabel.hidden = NO;
    self.vipPriceLabel.hidden = NO;
    

    self.beVIPBtn.frame = CGRectMake(self.vipPriceLabel.viewRightEdge + 3, self.vipPriceLabel.viewY, self.beVIPBtn.bounds.size.width, self.vipPriceLabel.bounds.size.height);
    if ([[JCUserContext sharedManager].currentUserInfo.drp_recommend boolValue]) {
        //分销商点击事件
        self.beVIPBtn.hidden = YES;
    }else {
        switch ([[JCUserContext sharedManager].currentUserInfo.vip_level integerValue]) {
            case 0:{
                self.beVIPBtn.hidden = NO;
            }
                break;
            default:{
                self.beVIPBtn.hidden = YES;
            }
                break;
        }
    }
    [_pricegroundView addSubview:self.beVIPBtn];

    /**
     *限时抢购
     */
    if(goodsInfo.p_tejia){
        //限时特价
        self.goodsPriceLabel.textColor = [UIColor whiteColor];
        self.vipPriceLabel.textColor = [UIColor whiteColor];
        _pricegroundView.backgroundColor = [UIColor colorWithHex:0xf72b74];
        self.beVIPBtn.hidden = YES;
        if (goodsInfo.p_tejia[@"end_time"]) {
            UIImageView *xianImageV = [UIImageView new];
            xianImageV.viewSize = CGSizeMake(120, 46);
            xianImageV.image = IMAGEWITHNAME(@"bj_shijiankuang_spxq.png");
            [xianImageV align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH, 0)];
            [_pricegroundView addSubview:xianImageV];
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, xianImageV.viewWidth-20, 12)];
            timeLabel.text = [NSString stringWithFormat:@"距结束剩%d天",[goodsInfo.p_tejia[@"end_time"] intValue]/86400];
            timeLabel.textColor = [UIColor colorWithHex:0xffffff];
            timeLabel.font = fontForSize(12);
            timeLabel.textAlignment = NSTextAlignmentCenter;
            [xianImageV addSubview:timeLabel];
            
            _watchV = [[WatchView alloc] initWithFrame:CGRectMake(15, 24, 106, 16)];
            [_watchV countDownViewWithEndString:goodsInfo.p_tejia[@"end_time"]];//
            WEAK_SELF;
            __block UIView *promiView = _pricegroundView;
            _watchV.TimerStopComplete = ^{
                    if ([weakSelf.delegate respondsToSelector:@selector(goodsRefersh)]) {
                        timeLabel.text = @"已结束";
                        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"抢购已结束" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [xianImageV removeFromSuperview];
                            [promiView removeAllSubviews];
                            [weakSelf.delegate goodsRefersh];
                        }];
                        [alert addAction:action];
                        [ROOTVIEWCONTROLLER presentViewController:alert animated:YES completion:nil];
                    }
            };
            [xianImageV addSubview:_watchV];
        }
        //限时价格
        if (goodsInfo.p_tejia[@"normal_discount_price"]) {
            UILabel * originLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.goodsPriceLabel.viewY, 100, self.goodsPriceLabel.viewHeight)];
            originLabel.font = fontForSize(12);
            originLabel.textColor = [UIColor colorWithHex:0xffffff];
            originLabel.text = [NSString stringWithFormat:@"￥ %@",goodsInfo.p_tejia[@"normal_discount_price"]];
            [originLabel sizeToFit];
            originLabel.viewHeight = 15;
            [_pricegroundView addSubview:originLabel];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"(原价%@)",goodsInfo.goods_price]];
            [attributedString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [goodsInfo.goods_price length]+4)];
            [attributedString addAttributes:@{NSFontAttributeName:fontForSize(12),NSForegroundColorAttributeName:[UIColor colorWithHex:0xffc5dd]} range:NSMakeRange(0, [goodsInfo.goods_price length]+4)];

            self.goodsPriceLabel.viewX = originLabel.viewRightEdge +10;
            self.goodsPriceLabel.attributedText = attributedString;
            
            UILabel * ViporiginLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.vipPriceLabel.viewY, 100, self.vipPriceLabel.viewHeight)];
            ViporiginLabel.textColor = [UIColor colorWithHex:0xffffff];
            ViporiginLabel.font = fontForSize(12);
            float vipfan =([goodsInfo.p_tejia[@"normal_discount_price"] floatValue] - [goodsInfo.goods_vip_price floatValue]);
            ViporiginLabel.text = [NSString stringWithFormat:@"麦咖专享返现 ￥ %.2f",vipfan>0?vipfan:[@"0.00" floatValue]];
            [ViporiginLabel sizeToFit];
            ViporiginLabel.viewHeight = 15;
            [_pricegroundView addSubview:ViporiginLabel];
            
            NSMutableAttributedString *attributedStringVip = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"(原价%@)",goodsInfo.goods_vip_price]];
            [attributedStringVip addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [goodsInfo.goods_vip_price length]+4)];
            [attributedStringVip addAttributes:@{NSFontAttributeName:fontForSize(12),NSForegroundColorAttributeName:[UIColor colorWithHex:0xffc5dd]} range:NSMakeRange(0, [goodsInfo.goods_vip_price length]+4)];
            self.vipPriceLabel.viewX = ViporiginLabel.viewRightEdge+10;
            self.vipPriceLabel.text = @"";
//            self.vipPriceLabel.attributedText = attributedStringVip;
        }else if (goodsInfo.p_tejia[@"normal_price"]) {
            //限时折扣
            self.goodsPriceLabel.textColor = [UIColor colorWithHex:0xffffff];
            self.vipPriceLabel.hidden = YES;
            
            UILabel * originLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.goodsPriceLabel.viewY, 100, self.goodsPriceLabel.viewHeight)];
            originLabel.textColor = [UIColor colorWithHex:0xffffff];
            originLabel.text = [NSString stringWithFormat:@"￥ %@",goodsInfo.p_tejia[@"normal_price"]];
            [originLabel sizeToFit];
            originLabel.viewHeight = _pricegroundView.viewHeight;
            [_pricegroundView addSubview:originLabel];
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"(原价%@)",self.goodsPriceLabel.text]];
            [attributedString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [self.goodsPriceLabel.text length]+4)];
            [attributedString addAttributes:@{NSFontAttributeName:fontForSize(14),NSForegroundColorAttributeName:[UIColor colorWithHex:0xffc5dd]} range:NSMakeRange(0, [self.goodsPriceLabel.text length]+4)];
            self.goodsPriceLabel.viewX = originLabel.viewRightEdge +10;
            self.goodsPriceLabel.attributedText = attributedString;
            [self.goodsPriceLabel sizeToFit];
            self.goodsPriceLabel.viewHeight = _pricegroundView.viewHeight;
        }
        //促销界面
        _promotionView.hidden = NO;
        _promotionWayLabel.text = goodsInfo.p_tejia[@"tag_name"];
        [_promotionWayLabel sizeToFit];
        _promotionWayLabel.viewWidth = _promotionWayLabel.viewWidth+10;
        _promotionWayLabel.viewHeight = 17;
        _promotionContentLabel.text = goodsInfo.p_tejia[@"description"];
        _promotionContentLabel.viewWidth = SCREEN_WIDTH-_promotionWayLabel.viewRightEdge-14;
        [_promotionContentLabel sizeToFit];
        _promotionContentLabel.viewX = _promotionWayLabel.viewRightEdge+4;
        _promotionContentLabel.viewHeight = 35;
    }
    /**
     * 满赠满送
     */
    if (goodsInfo.p_mansong) {
        _promotionView.hidden = NO;
        _promotionWayLabel.text = goodsInfo.p_mansong[@"tag_name"];
        [_promotionWayLabel sizeToFit];
        _promotionWayLabel.viewWidth = _promotionWayLabel.viewWidth+10;
        _promotionWayLabel.viewHeight = 17;
        _promotionContentLabel.text = goodsInfo.p_mansong[@"description"];
        _promotionContentLabel.viewWidth = SCREEN_WIDTH-_promotionWayLabel.viewRightEdge-14;
        [_promotionContentLabel sizeToFit];
        _promotionContentLabel.viewX = _promotionWayLabel.viewRightEdge+4;
        _promotionContentLabel.viewHeight = 35;
    }
    
    /**
     * 收藏标志符
     */
    if (_infoModele.isCollection && _infoModele.isCollection.length > 0) {
        
        if ([_infoModele.isCollection integerValue]) {
            self.collectBtn.selected = YES;
        }
        else{
            self.collectBtn.selected = NO;
            
        }
    }
    else{
        self.collectBtn.selected = NO;
    }
    
    /**
     * 快递地区及发送方式
     */
    self.sendTypeLabel.text = goodsInfo.send_type;
    [self.sendTypeLabel sizeToFit];
    self.sendTypeLabel.viewHeight = 20;
    [self.sendTypeLabel align:ViewAlignmentTopCenter relativeToPoint:CGPointMake(SCREEN_WIDTH/2, 0)];
    /**
     * 产地国家图片的地址
     */
    self.nationLabel.text = goodsInfo.origin_name;
    [self.nationLabel sizeToFit];
    self.nationLabel.frame = CGRectMake(SCREEN_WIDTH - 10 - self.nationLabel.bounds.size.width, 0, self.nationLabel.bounds.size.width, self.sendTypeLabel.viewHeight);
    
    [self.nationImage sd_setImageWithURL:[NSURL URLWithString:goodsInfo.originImage] placeholderImage:nil];
    self.nationImage.frame = CGRectMake(self.nationLabel.viewX - 5 - 17,4, 17, 12);
    self.nationImage.hidden = NO;
}

-(void)gotoAcitiy{
    NSLog(@"活动跳转");
    if ([self.delegate respondsToSelector:@selector(gotoAcitiy:andID:)]) {
        GoodsInfoModle *goodsInfo = [_infoModele modleFormGoods_Info_Str];
        [self.delegate gotoAcitiy:[goodsInfo.p_tejia[@"tag_name"] length]>0?goodsInfo.p_tejia[@"tag_name"]:goodsInfo.p_mansong[@"tag_name"] andID:[goodsInfo.p_tejia[@"bind_label_id"] length]>0?goodsInfo.p_tejia[@"bind_label_id"]:goodsInfo.p_mansong[@"bind_label_id"]];
    }
}

-(void)xiaohui{
    
}



-(void)imageViewWithArray:(NSArray *)images{
    
    for (int i = 0; i < images.count; i ++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.scrollView.viewWidth * i, 0, self.scrollView.viewWidth, self.scrollView.viewHeight)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:images[i]] placeholderImage:nil];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        [self.scrollView addSubview:imageView];
        [self.imageViews addObject:imageView];
        [self.scrollView setContentSize:CGSizeMake(imageView.viewRightEdge, self.scrollView.viewHeight)];
    }
}

-(void)setXianshi:(BOOL)xianshi{
    if (xianshi) {
        _pricegroundView.backgroundColor = [UIColor colorWithHex:0xf72b74];
        _originalImageView.hidden = NO;
        self.goodsPriceLabel.textColor = [UIColor colorWithHex:0xffffff];
        self.vipPriceLabel.textColor = [UIColor colorWithHex:0xffffff];
    }
}



#pragma mark  -- GoodsAlbumCellDelegate --
-(void)GoodsAlbumCellClickImageTapgesture:(UIGestureRecognizer *)sender index:(NSIndexPath *)index
{
   
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.disableTouchDismiss = NO;
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:self.imageViews
                       selectedView:_imageViews[index.row]];
}
-(void)imageViewer:(XHImageViewer *)imageViewer didDismissWithSelectedView:(UIImageView *)selectedView
{
    for (UIImageView * imageView in self.imageViews) {
        [self sendSubviewToBack:imageView];
    }
}
- (void)imageViewer:(XHImageViewer *)imageViewer didShowImageView:(UIImageView *)selectedView {
    
    NSInteger index = [self.imageViews indexOfObject:selectedView];
    self.countReminderLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)index + 1, (long)self.imageViews.count];
    [self.scrollView setContentOffset:CGPointMake(index * self.scrollView.viewWidth, 0)];
}
- (UIView *)customBottomToolBarOfImageViewer:(XHImageViewer *)imageViewer {
    
    UIView *toolBar = [[UIView alloc] init];
    toolBar.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    toolBar.backgroundColor = [UIColor clearColor];
    
    [toolBar addSubview:self.countReminderLabel];
    return toolBar;
}


#pragma mark -- get --
- (NSMutableArray *)imageViews {
    
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}
- (UILabel *)countReminderLabel {
    
    if (!_countReminderLabel) {
        _countReminderLabel = [[UILabel alloc] init];
        _countReminderLabel.bounds = CGRectMake(0, 0, 100, 20);
        _countReminderLabel.center = CGPointMake(SCREEN_WIDTH / 2, 44/2);
        _countReminderLabel.textAlignment = 1;
        _countReminderLabel.textColor = [UIColor whiteColor];
        _countReminderLabel.font = [UIFont fontWithName:@"Menlo" size:13];
    }
    return _countReminderLabel;
}

@end
