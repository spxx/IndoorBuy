//
//  HomePageMoreViewController.m
//  BMW
//
//  Created by rr on 16/3/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "HomePageMoreViewController.h"
#import "HomeCell.h"
#import "ScreenView.h"
#import "ScreenModle.h"
#import "GoodsDetailViewController.h"
#import "ShareView.h"
#import "CreateCodeVC.h"

typedef enum {
    ScreenConditionNone,
    ScreenConditionExist,
}ScreenConditionType;

@interface HomePageMoreViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ScreenViewDelegate,NoNetDelegate,ShareVeiwDelegate>
{
    UICollectionView *_collectionView;
    UILabel *_salesLabel;
    UIButton *_salesButton;
    UILabel *_priceLabel;
    UIImageView *_priceImage;
    UIButton *_priceButton;
    UILabel *_screenLabel;
    UIButton *_screenBtn;

    
    
    NSInteger _index;
    NSMutableArray *_dataSource;
}
@property(nonatomic,strong)ScreenModle * screenModle;
@property(nonatomic,assign)ScreenConditionType screenCondition;
@property(nonatomic,strong)ScreenView * screenView;
@property(nonatomic,copy)NSMutableDictionary * paramDic;

//记录筛选条件的 id 字符串
@property(nonatomic,copy)NSString * priceRangeStr;
@property(nonatomic,copy)NSString * productPlaceStr;
@property(nonatomic,copy)NSString * brandsStr;
@property(nonatomic,copy)NSString * classifyStr;
@end

@implementation HomePageMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUserInterFace];
    [self initLeftItem];
    [self initShareBtn];
    
    
    [self checkConnection:^(ConnectionType type) {
        if (type == ConnectionTypeNone ) {
            NSLog(@"无网");
            [self showNoNetOnView:self.view frame:_collectionView.frame type:NoNetDefault delegate:self];
        }
        else if (type == ConnectionTypeWifi){
            NSLog(@"wifi");
            
        }
        else if (type == ConnectionTypeData){
            NSLog(@"2g/3g");
        }
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)initLeftItem
{
    //配置导航栏的左侧返回按钮
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"icon_fanhui_gdtj.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(15, 0, 10, 18);
    UIBarButtonItem * backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(leftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backBtnItem;
}

-(void)initShareBtn{
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 43, 36);
    [rightBtn setBackgroundImage:IMAGEWITHNAME(@"icon_yijianfenxiang_ejym.png") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(shareGoodsAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem animated:YES];;
}

-(void)shareGoodsAction{
    //分享
    if (![JCUserContext sharedManager].isUserLogedIn) {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        loginVC.isRegistPush = NO;
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    ShareView * shareView = [[ShareView alloc] initWithTitle:self.title QRCode:YES];
    shareView.delegate = self;
    [self.view.window addSubview:shareView];

}

#pragma mark -- ShareViewDelegate --
- (void)shareView:(ShareView *)shareView chooseItemWithDestination:(Share3RDParty)destination
{
    UIImage * shareImage = IMAGEWITHNAME(@"classify.jpg");
    NSString * shareUrl = nil;
    if ([[JCUserContext sharedManager].currentUserInfo.drp_recommend boolValue]) {
        if (self.goods_platform_only) {
            shareUrl = SHAREURL_MEMBER(PLAT, [JCUserContext sharedManager].currentUserInfo.drp_recommend, self.ID);
        }else{
            shareUrl = SHAREURL_DRP(CLASS, [JCUserContext sharedManager].currentUserInfo.drp_recommend, self.ID);
        }
    }else{
        if (self.goods_platform_only) {
            shareUrl = SHAREURL_MEMBER(PLAT, [JCUserContext sharedManager].currentUserInfo.memberID, self.ID);
        }else{
            shareUrl = SHAREURL_MEMBER(CLASS, [JCUserContext sharedManager].currentUserInfo.memberID, self.ID);
        }
    }
    NSString * goodsName = self.title;
    switch (destination) {
        case ShareWXSession:
            NSLog(@"微信好友");
            [ShareTools respondsShareWeiXin:@0
                                      image:shareImage
                                      title:BMW_TITLE
                                description:goodsName
                                 webpageUrl:shareUrl];
            break;
        case ShareWXFriend:
            NSLog(@"微信朋友圈");
            [ShareTools respondsShareWeiXin:@1
                                      image:shareImage
                                      title:BMW_TITLE
                                description:goodsName
                                 webpageUrl:shareUrl];
            break;
            
        case ShareSina:
            NSLog(@"新浪");
            [ShareTools respondsShareWeiboWithRedirectUrl:@"https://www.indoorbuy.com"
                                                    scope:@"all"
                                                     text:[NSString stringWithFormat:@"%@。%@。%@",BMW_TITLE, goodsName, shareUrl]
                                                 objectID:@""
                                               shareImage:shareImage];
            break;
        case ShareQQ:
            NSLog(@"QQ");
            [ShareTools respondsShareQQWithShareTitle:BMW_TITLE
                                             shareUrl:shareUrl
                                     shareDescription:goodsName
                                           shareImage:shareImage];
            break;
        case ShareQQZone:
            NSLog(@"QQ空间");
            [ShareTools respondsShareQQZoneWithShareTitle:BMW_TITLE
                                                 shareUrl:shareUrl
                                         shareDescription:goodsName
                                               shareImage:shareImage];
            break;
        case ShareCreatCode:{
            NSLog(@"生成二维码");
            CreateCodeVC * codeVC = [[CreateCodeVC alloc] init];
            codeVC.titleStr = goodsName;
            codeVC.shareUrl = shareUrl;
            [self.navigationController pushViewController:codeVC animated:YES];
        }
            break;
        default:
            break;
    }
}



-(void)screenItemAction:(UIButton *)sender
{
    _salesLabel.textColor = [UIColor colorWithHex:0x181818];
    _priceLabel.textColor = [UIColor colorWithHex:0x181818];
    _screenLabel.textColor = [UIColor colorWithHex:0xfd5487];
    ScreenView * screenView = nil;
    
    if (self.homePageMoreVCType == HomePageMoreVCDefault) {
        if (self.noThirdClass == YES) {
            
            screenView = [[ScreenView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) classId:_dataDIc[@"gc_id"]screenModle:self.screenModle andScreenType:ScreenViewNoThirdClass];
        }
        else{
            
            screenView = [[ScreenView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) classId:_dataDIc[@"gc_id"] screenModle:self.screenModle andScreenType:ScreenViewDefault];
        }

        
    }
    else if(self.homePageMoreVCType == HomePageMoreVCMoreBrand){
        
        
         screenView = [[ScreenView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) classId:self.brandClassId screenModle:self.screenModle andScreenType:ScreenViewNoBrand];
    }else{
        screenView = [[ScreenView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) goods_platform_only:self.goods_platform_only screenModle:self.screenModle andScreenType:ScreenViewDefault];
    }
    
    
    screenView.delegate = self;
    self.screenView = screenView;
    RootTabBarVC * rootVC = ROOTVIEWCONTROLLER;
    [screenView showScreenViewOnSuperView:rootVC.view];
    
}
-(void)leftItemAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initData{
    _dataSource = [NSMutableArray array];
    _index = 1;
    NSLog(@"%@",_dataDIc);
    if (self.homePageMoreVCType == HomePageMoreVCDefault) {
        self.title = _dataDIc[@"gc_name"];
        self.ID = _dataDIc[@"gc_id"];
        [self updateWithClassId:self.ID];

    }
    else if (self.homePageMoreVCType == HomePageMoreVCMoreBrand){
        self.title = self.brandName;
        [self updateWithClassId:self.ID];
    }
    else{
        self.title = self.brandName;
        self.ID = self.goods_platform_only;
        [self updateWithClassId:self.ID];
    }
}

-(void)initUserInterFace{
    
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    _salesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 38)];
    _salesLabel.text = @"销量";
    _salesLabel.textAlignment = NSTextAlignmentCenter;
    _salesLabel.textColor = [UIColor colorWithHex:0xfd5487];
    _salesLabel.font = fontForSize(14);
    [self.view addSubview:_salesLabel];
    
    _salesButton = [[UIButton alloc] initWithFrame:_salesLabel.frame];
    _salesButton.selected = YES;
    [_salesButton addTarget:self action:@selector(chooseSale) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_salesButton];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 38)];
    _priceLabel.text = @"价格";
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.textColor = [UIColor colorWithHex:0x181818];
    _priceLabel.font = fontForSize(14);
    [self.view addSubview:_priceLabel];
    
    _priceImage = [[UIImageView alloc] initWithFrame:CGRectMake(_priceLabel.viewWidth/2+20, 13, 9, 11)];
    _priceImage.image = IMAGEWITHNAME(@"icon_jiantoupaixu_nor_ssjg.png");
    [_priceLabel addSubview:_priceImage];
    
    _priceButton = [[UIButton alloc] initWithFrame:_priceLabel.frame];
    [_priceButton addTarget:self action:@selector(priceChoose) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_priceButton];
    
    
    _screenLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, 38)];
    _screenLabel.text = @"筛选";
    _screenLabel.textAlignment = NSTextAlignmentCenter;
    _screenLabel.textColor = [UIColor colorWithHex:0x181818];
    _screenLabel.font = fontForSize(14);
    [self.view addSubview:_screenLabel];
    
    _screenBtn = [[UIButton alloc] initWithFrame:_screenLabel.frame];
    [_screenBtn addTarget:self action:@selector(screenItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_screenBtn];
    
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, topView.viewBottomEdge, SCREEN_WIDTH, 0.5*W_ABCH)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self.view addSubview:line];

    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(4*W_ABCW, line.viewBottomEdge, SCREEN_WIDTH-8*W_ABCW, SCREEN_HEIGHT-64-42) collectionViewLayout:layout];
    _collectionView.backgroundColor = COLOR_BACKGRONDCOLOR;
    [_collectionView registerClass:[HomeCell class] forCellWithReuseIdentifier:@"pageCell"];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate= self;
    [_collectionView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
    [_collectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreList)];
    _collectionView.footer.hidden = YES;
    [self.view addSubview:_collectionView];
}

-(void)refreshView{
    _index = 1;
    [_dataSource removeAllObjects];
    if (self.screenCondition == ScreenConditionNone){
        if (_salesButton.selected) {
            [self updateWithClassId:self.ID];
        }else{
            if (_priceButton.selected) {
                [self updateWithclassId:self.ID andPrice:@"1"];
            }else{
                [self updateWithclassId:self.ID andPrice:@"0"];
            }
        }
    }
    else{
       
        if (_salesButton.selected) {
            if ([_paramDic.allKeys containsObject:@"price"]) {
                [_paramDic removeObjectForKey:@"price"];
            }
            [_paramDic setObject:@"0" forKey:@"salenum"];
            
        }
        else{
            if ([_paramDic.allKeys containsObject:@"salenum"]) {
                [_paramDic removeObjectForKey:@"salenum"];
            }
            if (_priceButton.selected) {
                [_paramDic setObject:@"1" forKey:@"price"];
            }
            else{
               [_paramDic setObject:@"0" forKey:@"price"];
            }
        }
        [_paramDic setObject:NSNumber(_index) forKey:@"start"];
        [_paramDic setObject:@"20" forKey:@"limit"];
        [self updateWithScreenParamDic:_paramDic];

    }
    
}

-(void)loadMoreList{
    _index+=20;
    if (self.screenCondition == ScreenConditionNone) {
        if (_salesButton.selected) {
            //[self updateWithClassId:_dataDIc[@"gc_id"]];
            [self updateWithClassId:self.ID];
        }else{
            if (_priceButton.selected) {
                //[self updateWithclassId:_dataDIc[@"gc_id"] andPrice:@"1"];
                [self updateWithclassId:self.ID andPrice:@"1"];
            }else{
                //[self updateWithclassId:_dataDIc[@"gc_id"] andPrice:@"0"];
                [self updateWithclassId:self.ID andPrice:@"0"];
            }
        }
    }
    else{
        
        if (_salesButton.selected) {
            
            [_paramDic setObject:@"0" forKey:@"salenum"];
            
        }
        else{
            if (_priceButton.selected) {
                [_paramDic setObject:@"1" forKey:@"price"];
            }
            else{
                [_paramDic setObject:@"0" forKey:@"price"];
            }
        }
        [_paramDic setObject:NSNumber(_index) forKey:@"start"];
        [_paramDic setObject:@"20" forKey:@"limit"];
        [self updateWithScreenParamDic:_paramDic];
    
    }
    
}

-(void)chooseSale{
    _index = 1;
    [_dataSource removeAllObjects];
    _salesButton.selected = YES;
    _salesLabel.textColor = [UIColor colorWithHex:0xfd5487];
    _priceLabel.textColor = [UIColor colorWithHex:0x181818];
    _screenLabel.textColor = [UIColor colorWithHex:0x181818];
    _priceImage.image = IMAGEWITHNAME(@"icon_jiantoupaixu_nor_ssjg.png");
    _priceButton.selected = NO;
    if (self.screenCondition == ScreenConditionNone) {
        [self updateWithClassId:self.ID];
    }
    else{
        if ([_paramDic.allKeys containsObject:@"price"]) {
            [_paramDic removeObjectForKey:@"price"];
        }
        [_paramDic setObject:@"1" forKey:@"salenum"];
        [self updateWithScreenParamDic:_paramDic];
    }
    
}

-(void)priceChoose{
    [_dataSource removeAllObjects];
    _index = 1;
    _salesButton.selected = NO;
    _priceLabel.textColor = [UIColor colorWithHex:0xfd5487];
    _salesLabel.textColor = [UIColor colorWithHex:0x181818];
    _screenLabel.textColor = [UIColor colorWithHex:0x181818];
    if (_priceButton.selected) {
        _priceButton.selected = NO;
        _priceImage.image = IMAGEWITHNAME(@"icon_jiangejiantou2_gdtj.png");
        if (self.screenCondition == ScreenConditionNone) {
            [self updateWithclassId:self.ID andPrice:@"0"];
        }
        else{
            if ([_paramDic.allKeys containsObject:@"salenum"]) {
                [_paramDic removeObjectForKey:@"salenum"];
            }
            [_paramDic setObject:@"0" forKey:@"price"];
            [self updateWithScreenParamDic:_paramDic];
        }
        
    }else{
        _priceButton.selected = YES;
        if (self.screenCondition == ScreenConditionNone) {
            [self updateWithclassId:self.ID andPrice:@"1"];
        }
        else{
            if ([_paramDic.allKeys containsObject:@"salenum"]) {
                [_paramDic removeObjectForKey:@"salenum"];
            }
            
            [_paramDic setObject:@"1" forKey:@"price"];
            [self updateWithScreenParamDic:_paramDic];
        }
        
        _priceImage.image = IMAGEWITHNAME(@"icon_jiangejiantou1_gdtj.png");
    }
}

-(void)updateWithClassId:(NSString *)classId{
   
    NSDictionary * paramDic = nil;
    if (self.homePageMoreVCType == HomePageMoreVCDefault) {
        
        paramDic = @{@"classId":classId,@"salenum":@"0",@"start":NSNumber(_index),@"limit":@"20"};
    }
    else if (self.homePageMoreVCType == HomePageMoreVCMoreBrand){
       
        paramDic = @{@"brand":classId,@"salenum":@"0",@"start":NSNumber(_index),@"limit":@"20",@"classId":self.brandClassId};
    }else{
        paramDic = @{@"goods_platform_only":self.goods_platform_only,@"salenum":@"0",@"start":NSNumber(_index),@"limit":@"20"};
    }
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GoodsList" parameters:paramDic callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        [self hideNoNet];
        [_collectionView.header endRefreshing];
        [_collectionView.footer endRefreshing];
        if (result == RequestResultSuccess) {
            [self hideNotFound];
            [_dataSource addObjectsFromArray:object[@"data"]];
            if (_dataSource.count>=20) {
                _collectionView.hidden = NO;
                _collectionView.footer.hidden = NO;
            }else if(_dataSource.count == 0){
                _collectionView.hidden = YES;
                [_collectionView.footer setState:MJRefreshFooterStateNoMoreData];
            }else{
                _collectionView.hidden = NO;
                [_collectionView.footer setState:MJRefreshFooterStateNoMoreData];
            }
            [_collectionView reloadData];
        }
        else if (result == RequestResultEmptyData){
            [_collectionView.footer setState:MJRefreshFooterStateNoMoreData];
            if (_dataSource.count == 0) {
                [self showNotFoundOnView:self.view frame:CGRectMake(4*W_ABCW, 39, SCREEN_WIDTH-8*W_ABCW, SCREEN_HEIGHT-64-42) title:@"符合条件"];
            }
        }
        else {
            [self showNoNetOnView:self.view frame:_collectionView.frame type:NoNetDefault delegate:self];
        }

    }];
}


-(void)updateWithclassId:(NSString *)classID andPrice:(NSString *)loworHight{
    
    NSDictionary * paramDic = nil;
    if (self.homePageMoreVCType == HomePageMoreVCDefault) {
        
        paramDic = @{@"classId":classID,@"price":loworHight,@"start":NSNumber(_index),@"limit":@"20"};
    }
    else if (self.homePageMoreVCType == HomePageMoreVCMoreBrand){
       
         paramDic = @{@"brand":classID,@"price":loworHight,@"start":NSNumber(_index),@"limit":@"20",@"classId":self.brandClassId};
    }else{
        paramDic = @{@"goods_platform_only":self.goods_platform_only,@"price":loworHight,@"start":NSNumber(_index),@"limit":@"20"};
    }
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GoodsList" parameters:paramDic callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        [self hideNoNet];
        [_collectionView.header endRefreshing];
        [_collectionView.footer endRefreshing];
        if (result == RequestResultSuccess) {
            [self hideNotFound];
            [_dataSource addObjectsFromArray:object[@"data"]];
            if (_dataSource.count>=20) {
                _collectionView.footer.hidden = NO;
            }else{
                [_collectionView.footer setState:MJRefreshFooterStateNoMoreData];
            }
            [_collectionView reloadData];
        }
        else if (result == RequestResultEmptyData){
            [_collectionView.footer setState:MJRefreshFooterStateNoMoreData];
            if (_dataSource.count == 0) {
                 [self showNotFoundOnView:self.view frame:CGRectMake(4*W_ABCW, 39, SCREEN_WIDTH-8*W_ABCW, SCREEN_HEIGHT-64-42) title:@"符合条件"];
            }
           
        }
        else{
            [self showNoNetOnView:self.view frame:_collectionView.frame type:NoNetDefault delegate:self];
        }
    }];
}
-(void)updateWithScreenParamDic:(NSMutableDictionary *)paramDic
{
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GoodsList" parameters:paramDic callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        [self hideNoNet];
        [_collectionView.header endRefreshing];
        [_collectionView.footer endRefreshing];
        if (result == RequestResultSuccess) {
            [self hideNotFound];
            [_dataSource addObjectsFromArray:object[@"data"]];
            if (_dataSource.count>=20) {
                _collectionView.footer.hidden = NO;
            }else{
                [_collectionView.footer setState:MJRefreshFooterStateNoMoreData];
            }
            [_collectionView reloadData];
        }
        else if (result == RequestResultEmptyData){
            [_collectionView.footer setState:MJRefreshFooterStateNoMoreData];
            [_collectionView reloadData];
            if (_dataSource.count == 0) {
                [self showNotFoundOnView:self.view frame:CGRectMake(4*W_ABCW, 39, SCREEN_WIDTH-8*W_ABCW, SCREEN_HEIGHT-64-42) title:@"符合条件"];
            }
            
          //[MBProgressHUD show:@"没有找到相关信息的商品" toView:self.view];
        }
        else{
             [self showNoNetOnView:self.view frame:_collectionView.frame type:NoNetDefault delegate:self];
        }
    }];
}

#pragma mark UICollection


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSource.count;
}


-(UICollectionViewCell *)
collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pageCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if(_dataSource.count>0){
        cell.dataDic = _dataSource[indexPath.row];
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size ;
    size = CGSizeMake((_collectionView.viewWidth-4*W_ABCW)/2, 223);
    return size;
}
//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4*W_ABCW;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 4*W_ABCW;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
//    return UIEdgeInsetsMake(4*W_ABCW,4*W_ABCW,4*W_ABCW,4*W_ABCW);
    return UIEdgeInsetsMake(4*W_ABCW,0*W_ABCW,4*W_ABCW,0*W_ABCW);

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *sectionDic = _dataSource[indexPath.row];
    GoodsDetailViewController * goodsDetailVC =[[GoodsDetailViewController alloc]init];
    goodsDetailVC.goodsId = sectionDic[@"goods_id"];
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
    
}


#pragma mark -- ScreenViewDelegate --
-(void)screenView:(ScreenView *)view touchSwipeGesture:(UIGestureRecognizer *)gesture
{
    [view hiddenScreenView];
    view = nil;
}
-(void)screenView:(ScreenView *)view touchTapGesture:(UIGestureRecognizer *)gesture
{
    [view hiddenScreenView];
    view = nil;
    
}
-(void)screenView:(ScreenView *)view clickSureBtn:(UIButton *)sender
{
    NSString * priceRange = [self.screenModle.priceRange stringByReplacingOccurrencesOfString:@"-" withString:@","];
    priceRange = [priceRange stringByReplacingOccurrencesOfString:@"以上" withString:@",0"];
    self.priceRangeStr = priceRange;
    
    
    NSString * productStr = [self fromProductPlacesArray:self.screenModle.productPlaces];
    self.productPlaceStr = productStr;
    
    
    
    NSString * brandsStr = [self fromBrandsArray:self.screenModle.brands];
    self.brandsStr = brandsStr;
    
    
    NSString * classifyStr = [self fromClassifyArray:self.screenModle.classifies];
    self.classifyStr = classifyStr;
    
    
    if (self.priceRangeStr.length == 0 && self.productPlaceStr.length == 0 && self.brandsStr.length == 0 && self.classifyStr.length == 0) {
        self.screenCondition = ScreenConditionNone;
    }
    else{
        _paramDic = [NSMutableDictionary dictionary];
        if (self.priceRangeStr.length > 0) {
            [_paramDic setObject:self.priceRangeStr forKey:@"priceSec"];
        }
        if (self.productPlaceStr.length > 0) {
            [_paramDic setObject:self.productPlaceStr forKey:@"originId"];
        }
        if (self.brandsStr.length > 0) {
            [_paramDic setObject:self.brandsStr forKey:@"brand"];
        }
        
        if (self.classifyStr.length > 0) {
            [_paramDic setObject:self.classifyStr forKey:@"classId"];
            if (self.homePageMoreVCType == HomePageMoreVCShopCar) {
                [_paramDic setObject:self.goods_platform_only forKey:@"goods_platform_only"];
            }
        }else{
            if (self.homePageMoreVCType == HomePageMoreVCDefault) {
                [_paramDic setObject:_dataDIc[@"gc_id"] forKey:@"classId"];
            }else if (self.homePageMoreVCType == HomePageMoreVCMoreBrand){
                [_paramDic setObject:self.brandClassId forKey:@"classId"];
            }else{
                [_paramDic setObject:self.goods_platform_only forKey:@"goods_platform_only"];
            }
            
        }
        
        //如果是品牌点击进来的
        if (self.homePageMoreVCType == HomePageMoreVCMoreBrand) {
            [_paramDic setObject:self.ID forKey:@"brand"];
        }

        
        self.screenCondition = ScreenConditionExist;
    }
    [self.screenView hiddenScreenView];
    self.screenView = nil;
    [self refreshView];
    
   
}
#pragma mark -- get --
-(ScreenModle *)screenModle
{
    if (!_screenModle) {
        _screenModle = [[ScreenModle alloc]init];
    }
    return _screenModle;
}
#pragma mark -- private --
-(NSString *)fromProductPlacesArray:(NSMutableArray *)array
{
    if (array.count > 0) {
        NSMutableString * string = [NSMutableString string];
        for (int i = 0; i < array.count ; i ++) {
            [string appendFormat:@"%@,",array[i][@"id"]];
        }
        
        return [string substringWithRange:NSMakeRange(0, string.length - 1)];
    }
    return @"";
    
    
}
-(NSString *)fromBrandsArray:(NSMutableArray *)array
{
    if (array.count>0) {
        NSMutableString * string = [NSMutableString string];
        for (int i = 0; i < array.count ; i ++) {
            [string appendFormat:@"%@,",array[i][@"brand_id"]];
        }
        
        return [string substringWithRange:NSMakeRange(0, string.length - 1)];
    }
    return @"";
   
    
    
}
-(NSString *)fromClassifyArray:(NSMutableArray *)array
{
    if (array.count > 0) {
        NSMutableString * string = [NSMutableString string];
        for (int i = 0; i < array.count ; i ++) {
            [string appendFormat:@"%@,",array[i][@"gc_id"]];
        }
        
        return [string substringWithRange:NSMakeRange(0, string.length - 1)];
    }
    return @"";
   
}
#pragma mark  --- NoNetDelegate --
-(void)NoNetDidClickRelaod:(UIButton *)sender
{
    [self checkConnection:^(ConnectionType type) {
        if (type == ConnectionTypeNone ) {
            NSLog(@"无网");
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前网络不可用，请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if (type == ConnectionTypeWifi){
            NSLog(@"wifi");
            [self hideNoNet];
            [self refreshView];
            
        }
        else if (type == ConnectionTypeData){
            NSLog(@"2g/3g");
            [self hideNoNet];
            [self refreshView];
           
        }
    }];
}

@end
