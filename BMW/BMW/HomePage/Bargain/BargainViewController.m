//
//  BargainViewController.m
//  BMW
//
//  Created by gukai on 16/3/5.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BargainViewController.h"
#import "BargainMenu.h"
#import "HomeCell.h"
#import "GoodsDetailViewController.h"
#import "HomePageMoreViewController.h"
#import "CustomerserviceViewController.h"


@interface BargainViewController ()<UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,BargainMenuDelegate,NoNetDelegate>
{
    UICollectionView *_collectionView;
    NSMutableArray *_dataSource;
    UIView *_headerView;
    UIPageControl *_pageC;
    NSArray *_adverImageArray;
    
    
    NSInteger _index;
    
    NSInteger _tag;

    UIView *_resultView;
    UILabel *_sorroyLabel;
}
@property(nonatomic,strong)BargainMenu * bargainMenu;
@property(nonatomic,strong)UICollectionView * collectionView;
@end

@implementation BargainViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}
-(void)initUserInterface
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"特惠上新";
    [self initBargainMenuView];
    [self initBagainMainView];
    [self resultV];
    [self initData];
    [self initLeftItem];
    
    [self checkConnection:^(ConnectionType type) {
        if (type == ConnectionTypeNone ) {
            NSLog(@"无网");
            [self showNoNetOnView:self.view frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) type:NoNetDefault delegate:self];
        }
        else if (type == ConnectionTypeWifi){
            NSLog(@"wifi");
            
        }
        else if (type == ConnectionTypeData){
            NSLog(@"2g/3g");
        }
    }];
    
}
-(void)initData{
    _index = 1;
    _tag = 0;
    _dataSource = [NSMutableArray array];
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"BannerList" parameters:@{@"class":@"3"} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            _adverImageArray = object[@"data"];
            NSData * advData = [NSKeyedArchiver archivedDataWithRootObject:_adverImageArray];
            [[NSUserDefaults standardUserDefaults] setObject:advData forKey:@"bargainArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            for (int i = 0; i < _adverImageArray.count; i ++) {
                UIImageView * imageView =[[UIImageView alloc]init];
                [imageView sd_setImageWithURL:[NSURL URLWithString:_adverImageArray[i][@"image"]] placeholderImage:nil];
            }
            [self upDateHeaderView];
        }
    }];

    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"DiscountList" parameters:@{@"discount":@"0",@"new":@"1",@"hot":@"0",@"start":NSNumber(_index),@"limit":@"20"} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result == RequestResultSuccess) {
            [_dataSource addObjectsFromArray:object[@"data"]];
            if (_dataSource.count>=20) {
                _collectionView.legendFooter.hidden = NO;
            }else{
                _collectionView.legendFooter.hidden = YES;
            }
        }else if (result==RequestResultEmptyData){
            [self changeColorWithText];
        }
        [_collectionView reloadData];
    }];
}
-(void)bannerListNetWork
{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"BannerList" parameters:@{@"class":@"3"} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            _adverImageArray = object[@"data"];
            NSData * advData = [NSKeyedArchiver archivedDataWithRootObject:_adverImageArray];
            [[NSUserDefaults standardUserDefaults] setObject:advData forKey:@"bargainArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            for (int i = 0; i < _adverImageArray.count; i ++) {
                UIImageView * imageView =[[UIImageView alloc]init];
                [imageView sd_setImageWithURL:[NSURL URLWithString:_adverImageArray[i][@"image"]] placeholderImage:nil];
            }
            [self upDateHeaderView];
        }
    }];
}

-(void)changeColorWithText{
    _sorroyLabel.attributedText = [self attributed];
    [_sorroyLabel sizeToFit];
    _sorroyLabel.viewSize = CGSizeMake(_sorroyLabel.viewWidth, 29*W_ABCH);
    _sorroyLabel.textAlignment = NSTextAlignmentCenter;
    _sorroyLabel.attributedText = [self otherAtt];
}

-(void)upDateHeaderView{
    [self initHeaderView];
    [_collectionView reloadData];
}

-(void)resultV{
    _resultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
    _resultView.backgroundColor = COLOR_BACKGRONDCOLOR;
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(64*W_ABCW, 53*W_ABCH, 13, 13)];
    imageV.image = IMAGEWITHNAME(@"icon_tixing_ssjg.png");
    [_resultView addSubview:imageV];
    
    
    _sorroyLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageV.viewRightEdge+5*W_ABCW, imageV.viewY, SCREEN_WIDTH-150, 29)];
    _sorroyLabel.textAlignment = NSTextAlignmentCenter;
    _sorroyLabel.font = fontForSize(12);
    _sorroyLabel.textColor = [UIColor colorWithHex:0x878787];
    _sorroyLabel.numberOfLines = 2;
    [_resultView addSubview:_sorroyLabel];
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
-(void)leftItemAction:(UIButton *)sender
{
   [self.navigationController popViewControllerAnimated:YES];
}
/**
 * 初始化头部的特惠菜单
 */
-(void)initBargainMenuView
{
    BargainMenu * bargainMenu = [[BargainMenu alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38) muneData:@[@"新品上市",@"热卖好物",@"清仓处理"]];
    bargainMenu.backgroundColor = [UIColor whiteColor];
    bargainMenu.delegate = self;
    [self.view addSubview:bargainMenu];
}

-(void)bargainMenuClickMuneButton:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"新品上市"]) {
        _tag = 0;
        [_collectionView.legendHeader beginRefreshing];
    }else if ([sender.titleLabel.text isEqualToString:@"热卖好物"]){
        _tag =1;
        [_collectionView.legendHeader beginRefreshing];
    }else{
        _tag = 2;
        [_collectionView.legendHeader beginRefreshing];
    }

    
}


-(void)initHeaderView{
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 125)];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *barScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 121)];
    barScrollView.pagingEnabled = YES;
    barScrollView.userInteractionEnabled =YES;
    barScrollView.delegate = self;
    barScrollView.showsHorizontalScrollIndicator = NO;
    barScrollView.showsVerticalScrollIndicator =NO;
    barScrollView.tag = 444;
    barScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*_adverImageArray.count,121);
    barScrollView.contentOffset = CGPointMake(0, 0);
    for (int i=0; i<_adverImageArray.count; i++) {
        UIImageView *imageV =[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, 121)];
        imageV.userInteractionEnabled = YES;
        imageV.contentMode = UIViewContentModeScaleToFill;
        imageV.tag = 9999+i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoDetail:)];
        [imageV addGestureRecognizer:tap];
        [imageV sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@",_adverImageArray[i][@"image"]]] placeholderImage:nil];
        [barScrollView addSubview:imageV];
    }
    
    [_headerView addSubview:barScrollView];
    _pageC = [UIPageControl new];
    _pageC.viewSize = CGSizeMake(SCREEN_WIDTH, 10);
    [_pageC align:ViewAlignmentBottomCenter relativeToPoint:CGPointMake(SCREEN_WIDTH/2, barScrollView.viewHeight-10)];
    _pageC.currentPage = 0;
    _pageC.numberOfPages = _adverImageArray.count;
    _pageC.pageIndicatorTintColor = [UIColor whiteColor];
    _pageC.currentPageIndicatorTintColor = [UIColor colorWithHex:0xfd5478];
    [_headerView addSubview:_pageC];
    
    UIView *intervalView = [[UIView alloc] initWithFrame:CGRectMake(0, barScrollView.viewBottomEdge, SCREEN_WIDTH, 4)];
    intervalView.backgroundColor = COLOR_BACKGRONDCOLOR;
    [_headerView addSubview:intervalView];
    
}

-(void)gotoDetail:(UITapGestureRecognizer *)sender{
    if (_adverImageArray.count>0) {
        NSDictionary *dataDic = _adverImageArray[sender.view.tag-9999];
        switch ([dataDic[@"type"] integerValue]) {
            case 1:{
                //商品
                GoodsDetailViewController *goodsVC = [[GoodsDetailViewController alloc] init];
                goodsVC.goodsId = dataDic[@"link"];
                goodsVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:goodsVC animated:YES];
            }
                break;
            case 2:
                //分类
            {
                NSDictionary *dataSource = @{@"gc_id":dataDic[@"link"],@"gc_name":dataDic[@"className"]};
                HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
                homePageMoreVC.dataDIc = dataSource;
                homePageMoreVC.noThirdClass = YES;
                homePageMoreVC.navigationItem.hidesBackButton = YES;
                homePageMoreVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:homePageMoreVC animated:YES];
            }
                break;
            case 3:
                //品牌
            {
                HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
                homePageMoreVC.homePageMoreVCType = HomePageMoreVCMoreBrand;
                homePageMoreVC.brandName = dataDic[@"brand_name"];
                homePageMoreVC.ID = dataDic[@"link"];
                homePageMoreVC.brandClassId = dataDic[@"class_id"];
                homePageMoreVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:homePageMoreVC animated:YES];
            }
                break;
            case 4:
                //优惠券
                break;
            case 5:
                //HTML
            {
                CustomerserviceViewController *htmlVC = [[CustomerserviceViewController alloc] init];
                htmlVC.htmlUrl = dataDic[@"link"];
                htmlVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:htmlVC animated:YES];
            }
                break;
            case 6:{
                HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
                homePageMoreVC.homePageMoreVCType = HomePageMoreVCShopCar;
                homePageMoreVC.brandName = dataDic[@"platName"];
                homePageMoreVC.goods_platform_only = dataDic[@"link"];
                homePageMoreVC.ID = homePageMoreVC.goods_platform_only;
                homePageMoreVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:homePageMoreVC animated:YES];
            }
            default:
                break;
        }
    }
}


-(void)initBagainMainView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 38, SCREEN_WIDTH, SCREEN_HEIGHT-64-38) collectionViewLayout:layout];
    _collectionView.backgroundColor = COLOR_BACKGRONDCOLOR;
    [_collectionView registerClass:[HomeCell class] forCellWithReuseIdentifier:@"pageCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView"];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate= self;
    [_collectionView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
    [_collectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreList)];
    _collectionView.legendFooter.hidden = YES;
    [self.view addSubview:_collectionView];
}


- (void)refreshAndLoadMoreRequestWithDic:(NSDictionary *)dic isRefresh:(BOOL)isRefresh {
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"DiscountList" parameters:dic callBack:^(RequestResult result, id object) {
        [_collectionView.header endRefreshing];
        [_collectionView.footer endRefreshing];
        //判断是否是刷新
        if (isRefresh) {
            [_dataSource removeAllObjects];
            if (result == RequestResultSuccess) {
                [_dataSource addObjectsFromArray:object[@"data"]];
                if (_dataSource.count>=20) {
                    _collectionView.legendFooter.hidden = NO;
                }else{
                    _collectionView.legendFooter.hidden = YES;
                }
            }else if (result == RequestResultEmptyData){
                _collectionView.legendFooter.hidden = YES;
                [self changeColorWithText];
            }else{
                _resultView.hidden = YES;
                _collectionView.legendFooter.hidden = YES;
                [self showNoNetOnView:self.view frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) type:NoNetDefault delegate:self];
            }
            
        }
        else {
            if (result == RequestResultSuccess) {
                [_dataSource addObjectsFromArray:object[@"data"]];
                if (_dataSource.count>=20) {
                    _collectionView.legendFooter.hidden = NO;
                }else{
                    _collectionView.legendFooter.hidden = YES;
                }
            }else if (result == RequestResultEmptyData){
                _collectionView.legendFooter.hidden = YES;
            }
        }
        
        [_collectionView reloadData];
    }];
}

-(void)refreshView{
    _index = 1;
    switch (_tag) {
        case 0:{
            [self refreshAndLoadMoreRequestWithDic:@{@"discount":@"0",
                                                     @"new":@"1",
                                                     @"hot":@"0",
                                                     @"start":@"1",
                                                     @"limit":@"20"}
                                         isRefresh:YES];
        }
            
            break;
        case 1:{
            [self refreshAndLoadMoreRequestWithDic:@{@"discount":@"0",
                                                     @"new":@"0",
                                                     @"hot":@"1",
                                                     @"start":@"1",
                                                     @"limit":@"20"}
                                         isRefresh:YES];
        }
            break;
        case 2:{
            [self refreshAndLoadMoreRequestWithDic:@{@"discount":@"1",
                                                     @"new":@"0",
                                                     @"hot":@"0",
                                                     @"start":@"1",
                                                     @"limit":@"20"}
                                         isRefresh:YES];
        }
            break;
        default:
            break;
    }
    
}

-(void)loadMoreList{
    _index+=20;
    switch (_tag) {
        case 0:{
            [self refreshAndLoadMoreRequestWithDic:@{@"discount":@"0",
                                                     @"new":@"1",
                                                     @"hot":@"0",
                                                     @"start":NSNumber(_index),
                                                     @"limit":@"20"}
                                         isRefresh:NO];
        }
            break;
        case 1:{
            [self refreshAndLoadMoreRequestWithDic:@{@"discount":@"0",
                                                     @"new":@"0",
                                                     @"hot":@"1",
                                                     @"start":NSNumber(_index),
                                                     @"limit":@"20"}
                                         isRefresh:NO];
        }
            break;
        case 2:{
            [self refreshAndLoadMoreRequestWithDic:@{@"discount":@"1",
                                                     @"new":@"0",
                                                     @"hot":@"0",
                                                     @"start":NSNumber(_index),
                                                     @"limit":@"20"}
                                         isRefresh:NO];
        }
            break;
        default:
            break;
    }
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSource.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pageCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.dataDic = _dataSource[indexPath.row];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size ;
    size = CGSizeMake((SCREEN_WIDTH-12*W_ABCW)/2, 223);
    return size;
}
//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4*W_ABCW;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 3*W_ABCW;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,4*W_ABCW,4*W_ABCW,4*W_ABCW);
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 125);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (_dataSource.count>0) {
        return CGSizeZero;
    }
    return CGSizeMake(SCREEN_WIDTH, 160);
}



-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView" forIndexPath:indexPath];
        for (UIView *view in footer.subviews) {
            [view removeFromSuperview];
        }
        [footer addSubview:_resultView];
        return footer;

    }else{
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        for (UIView *view in header.subviews) {
            [view removeFromSuperview];
        }
        [header addSubview:_headerView];
        return header;
    }
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *sectionDic = _dataSource[indexPath.row];
    GoodsDetailViewController * goodsDetailVC =[[GoodsDetailViewController alloc]init];
    goodsDetailVC.goodsId = sectionDic[@"goods_id"];
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag==444) {
        _pageC.currentPage = scrollView.contentOffset.x/SCREEN_WIDTH;
    }
    
}

-(NSMutableAttributedString *)attributed{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 5;
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle};
    NSString *redString = @"";
    switch (_tag) {
        case 0:
            redString = @"新品上市";
            break;
        case 1:
            redString = @"热卖好物";
            break;
        case 2:
            redString = @"清仓处理";
            break;
        default:
            break;
    }
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"抱歉！没有找到“%@”相关商品，\n换个搜索词再试试吧！",redString]];
    [att setAttributes:attributes range:NSMakeRange(0, [[NSString stringWithFormat:@"抱歉！没有找到“%@”相关商品，\n换个搜索词再试试吧！",redString] length])];
    return att;
}
-(NSMutableAttributedString *)otherAtt{
    NSDictionary *diction = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHex:0xfd5487]};
    NSString *redString = @"";
    switch (_tag) {
        case 0:
            redString = @"新品上市";
            break;
        case 1:
            redString = @"热卖好物";
            break;
        case 2:
            redString = @"清仓处理";
            break;
        default:
            break;
    }
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"抱歉！没有找到“%@”相关商品，\n换个搜索词再试试吧！",redString]];
    [att setAttributes:diction range:NSMakeRange(7, redString.length+2)];
    return att;
}
#pragma mark -- NoNetDelegate --
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
            [self bannerListNetWork];
            [_collectionView.legendHeader beginRefreshing];
            
        }
        else if (type == ConnectionTypeData){
            NSLog(@"2g/3g");
            [self hideNoNet];
            [self bannerListNetWork];
            [_collectionView.legendHeader beginRefreshing];
        }
    }];
    
}


@end

