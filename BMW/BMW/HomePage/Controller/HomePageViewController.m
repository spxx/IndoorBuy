//
//  HomePageViewController.m
//  BMW
//
//  Created by gukai on 16/2/17.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "HomePageViewController.h"
#import "LoginViewController.h"
#import "RootTabBarVC.h"
#import "HomeCell.h"
#import "homePageModel.h"
#import "HomeSearchViewController.h"
#import "SYQRCodeViewController.h"
#import "BargainViewController.h"//特惠上新
#import "HomePageMoreViewController.h"//更多
#import "GoodsDetailViewController.h"

#import "HomePageFlowLayout.h"
#import "ClassificationViewController.h"//分类
#import "NewsCenterViewController.h"

#import "GoodsDetailViewController.h"

#import "SHCGuideViewController.h"

#import "CustomerserviceViewController.h"
#import "ApplyRIntroductionsViewController.h"

#import "NoticeMessageModle.h"

@interface HomePageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UICollectionView *_collectionView;
    UIView *_headerView;
    NSArray * _bannerD;
    UIPageControl *_pageC;
    UIButton * _newsButton;
    
    NSMutableArray *_imageArray;
    NSMutableArray *_titleArray;
    
    UIView *_sectinView;
    UILabel *_scrollLabel;
    
    NSArray *_sectionArray;
    NSArray *_sectionImageArray;
    NSArray *_adverImageArray;
    //号外
    UILabel *_extraLabel;
    UIView  *_whiteView;
    UIImageView *_extraImageV;
    UIImageView *_rightRow;
    UIView *_hearSectionView;
    
    NSArray *_messageArray;
    UIView *_pageBar;
    UIView *_titleView;
}
@end

@implementation HomePageViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUserInterface];
    [self customNavigationBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsButtonChange) name:@"newsChange" object:nil];
    
    //将当前版本号存下来，如果有判断是否最新YES走广告NO走本地
    NSString * userGuideKey = [@"hello" stringByAppendingString:@"1.0"];
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:userGuideKey]) {
        SHCGuideViewController *guidVC = [SHCGuideViewController new];
        [guidVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:guidVC animated:YES completion:^{
        }];
    }else{
        NSString *indexBanben = [[NSUserDefaults standardUserDefaults]objectForKey:userGuideKey];
        if ([indexBanben isEqualToString:@"1.0"]) {
            //进入显示广告
//            SHCGuideViewController *guidVC = [SHCGuideViewController new];
//            guidVC.VersionUpdate = YES;
//            [guidVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//            [self presentViewController:guidVC animated:YES completion:^{
//                [[NSUserDefaults standardUserDefaults]setObject:@"1.0" forKey:userGuideKey];
//                [[NSUserDefaults standardUserDefaults]synchronize];
//            }];
        }else{
            //显示本地
            SHCGuideViewController *guidVC = [SHCGuideViewController new];
            [guidVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:guidVC animated:YES completion:^{
                [[NSUserDefaults standardUserDefaults]setObject:@"1.0" forKey:userGuideKey];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }];
        }
    }
}


-(void)initData{
    
    _messageArray = [NSArray array];
    _imageArray = [NSMutableArray array];
    _titleArray = [NSMutableArray array];
    _sectionImageArray = @[@"icon_muyingyongpin_1_sy.png",@"icon_shenghuojiaju_1_sy.png",@"icon_gehumeizhuang_1_sy.png",@"icon_quanqiumeishi_1_sy.png",@"icon_yingyongbaojian_1_sy.png",@"icon_fushixiangbao_1_sy.png"];
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GcFirstClass" parameters:@{} callBack:^(RequestResult result, id object) {
        [_titleArray removeAllObjects];
        [_imageArray removeAllObjects];
        if (result ==RequestResultSuccess) {
            NSArray *array  = object[@"data"];
            for (NSDictionary *dataDic in array) {
                [_titleArray addObject:dataDic[@"gc_name"]];
                [_imageArray addObject:dataDic[@"image"]];
            }
            [_titleArray addObject:@"特惠上新"];
            [_titleArray addObject:@"全部分类"];
            [_imageArray addObject:@"icon_tehuishangxin_sy.png"];
            [_imageArray addObject:@"icon_quanbufenlei_sy.png"];
            [[NSUserDefaults standardUserDefaults]setObject:_titleArray forKey:@"titleArray"];
            [[NSUserDefaults standardUserDefaults]setObject:_imageArray forKey:@"imageArray"];
            if (_bannerD.count >0) {
                [self upDateHeaderView];
            }
        }else{
            [_titleArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"titleArray"]];
            [_imageArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"imageArray"]];
            if (_bannerD.count >0) {
                [self upDateHeaderView];
            }
        }
    }];

    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"BannerList" parameters:@{@"class":@"2"} callBack:^(RequestResult result, id object) {
        NSLog(@"%@",object);
        if (result == RequestResultSuccess) {
            _adverImageArray = object[@"data"];
            NSData * advData = [NSKeyedArchiver archivedDataWithRootObject:_adverImageArray];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"adverImageArray"];
            [[NSUserDefaults standardUserDefaults] setObject:advData forKey:@"adverImageArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            for (int i = 0; i < _adverImageArray.count; i ++) {
                UIImageView * imageView =[[UIImageView alloc]init];
                [imageView sd_setImageWithURL:[NSURL URLWithString:_adverImageArray[i][@"image"]] placeholderImage:nil];
            }
            [self upDateCollectionV];
        }else if(result == RequestResultEmptyData){
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"adverImageArray"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            _adverImageArray = nil;
            [self upDateCollectionV];
        }else{
            NSData * advData = [[NSUserDefaults standardUserDefaults] objectForKey:@"adverImageArray"];
            _adverImageArray = [NSKeyedUnarchiver unarchiveObjectWithData:advData];
            [self upDateCollectionV];
        
        }
    }];
    
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"BannerList" parameters:@{@"class":@"1"} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            _bannerD = object[@"data"];
            NSData * bannerData = [NSKeyedArchiver archivedDataWithRootObject:_bannerD];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"bannerD"];
            [[NSUserDefaults standardUserDefaults] setObject:bannerData forKey:@"bannerD"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            for (int i = 0; i < _bannerD.count; i ++) {
                UIImageView * imageView =[[UIImageView alloc]init];
                [imageView sd_setImageWithURL:[NSURL URLWithString:_bannerD[i][@"image"]] placeholderImage:nil];
            }
            if (_titleArray.count >0) {
                [self upDateHeaderView];
            }
        }
        else{
            NSData * bannerData = [[NSUserDefaults standardUserDefaults] objectForKey:@"bannerD"];
            _bannerD = [NSKeyedUnarchiver unarchiveObjectWithData:bannerData];
            if (_titleArray.count>0) {
                [self upDateHeaderView];
            }else{
                [_titleArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"titleArray"]];
                [_imageArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"imageArray"]];
                [self upDateHeaderView];
            }
        }
    }];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"HomePage" parameters:nil callBack:^(RequestResult result, id object) {
        [_collectionView.header endRefreshing];
        if (result == RequestResultSuccess) {
            JCDBCacheManager *cac = [JCDBCacheManager cacheForClass:homePageModel.class];
            NSArray *testArray = [cac queryWithCondition:nil];
            _sectionArray = object[@"data"];
            BOOL result;
            NSMutableArray * goodsList = [NSMutableArray array];
            for (NSDictionary *dic in _sectionArray) {
                homePageModel *homeModel = [[homePageModel alloc] initWithJsonObject:dic];
                [goodsList addObject:homeModel];
            }
            if (testArray.count==0) {
                result = [cac insert:goodsList];
                if (result) {
                    NSLog(@"写入成功");
                }
            }else{
                result = [cac update:goodsList withConditions:testArray];
                if (result) {
                    NSLog(@"更新成功");
                }
            }
        }else{
            JCDBCacheManager *cac = [JCDBCacheManager cacheForClass:homePageModel.class];
            NSArray *testArray = [cac queryWithCondition:nil];
            NSMutableArray *cachArray = [NSMutableArray array];
            for (homePageModel *homeM in testArray) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                NSArray *goods = [TYTools JSONObjectWithString:homeM.goods_array];
                [dic setValue:homeM.gc_id forKey:@"gc_id"];
                [dic setValue:homeM.gc_name forKey:@"gc_name"];
                [dic setValue:goods forKey:@"goods"];
                [cachArray addObject:dic];
            }
            _sectionArray = cachArray;
        }
        [self.HUD hide:YES];
        [_collectionView reloadData];
    }];
    
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"MessageTit" parameters:@{} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSArray *array = object[@"data"];
            NSMutableArray *messArray = [NSMutableArray array];
            for (int i = 0; i < array.count; i ++) {
                NSMutableDictionary * messDic = [NSMutableDictionary dictionaryWithDictionary:array[i]];
                if (messDic[@"message_url"] == [NSNull null]) {
                    [messDic setObject:@" " forKey:@"message_url"];
                }
                [messArray addObject:messDic];
            }
            _messageArray = messArray;
            
            [[NSUserDefaults standardUserDefaults]setObject:_messageArray forKey:@"message"];
            [self refreshHaowai];
        }else if(result == RequestResultEmptyData){
            _messageArray = @[];
            [self refreshHaowai];
        }else{
            _messageArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"message"];
            [self refreshHaowai];
        }
    }];

}

-(void)newsButtonChange{
    _newsButton.selected = YES;
    
}


-(void)initHeaderView{
    if (_headerView) {
        [_headerView removeFromSuperview];
        _headerView = nil;
    }
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 211.5 + 185 * W_ABCW)];
    _headerView.backgroundColor = [UIColor whiteColor];
    UIScrollView *barScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 185 * W_ABCW)];
    barScrollView.pagingEnabled = YES;
    barScrollView.userInteractionEnabled =YES;
    barScrollView.delegate = self;
    barScrollView.showsHorizontalScrollIndicator = NO;
    barScrollView.showsVerticalScrollIndicator =NO;
    barScrollView.tag = 444;
    barScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*_bannerD.count,121);
    barScrollView.contentOffset = CGPointMake(0, 0);
    for (int i=0; i<_bannerD.count; i++) {
        UIImageView *imageV =[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, 185 * W_ABCW)];
        imageV.tag = 777+i;
        imageV.backgroundColor = [UIColor whiteColor];
        imageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *taoImageV = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoDetail:)];
        [imageV addGestureRecognizer:taoImageV];
        imageV.contentMode = UIViewContentModeScaleToFill;
        UIImageView *centerImage = [UIImageView new];
        centerImage.viewSize = CGSizeMake(102, 24);
        [centerImage align:ViewAlignmentCenter relativeToPoint:CGPointMake(imageV.viewWidth/2,imageV.viewHeight/2)];
        centerImage.image = IMAGEWITHNAME(@"logo_sy.png");
        [imageV addSubview:centerImage];
        
        [imageV sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@",_bannerD[i][@"image"]]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [centerImage removeFromSuperview];
        }];
        [barScrollView addSubview:imageV];
    }
    
    [_headerView addSubview:barScrollView];
    _pageC = [UIPageControl new];
    _pageC.viewSize = CGSizeMake(SCREEN_WIDTH, 10);
    [_pageC align:ViewAlignmentBottomCenter relativeToPoint:CGPointMake(SCREEN_WIDTH/2, barScrollView.viewHeight-10)];
    _pageC.currentPage = 0;
    _pageC.numberOfPages = _bannerD.count;
    _pageC.pageIndicatorTintColor = [UIColor colorWithHex:0xfd5478];
    _pageC.currentPageIndicatorTintColor = [UIColor whiteColor];
    [_headerView addSubview:_pageC];
    
    UIView *barBview = [[UIView alloc] initWithFrame:CGRectMake(0, barScrollView.viewBottomEdge, SCREEN_WIDTH, 41)];
    barBview.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:barBview];
    
    UIButton *firstB = [UIButton new];
    firstB.viewSize = CGSizeMake(73, 24);
    [firstB align:ViewAlignmentCenter relativeToPoint:CGPointMake(SCREEN_WIDTH/3/2,barBview.viewHeight/2)];
    [firstB setImage:IMAGEWITHNAME(@"icon_ziyingzhengpin_sy.png") forState:UIControlStateNormal];
    [barBview addSubview:firstB];
    
    UIButton *twoB = [UIButton new];
    twoB.viewSize = CGSizeMake(84, 24);
    [twoB align:ViewAlignmentCenter relativeToPoint:CGPointMake(SCREEN_WIDTH/2, barBview.viewHeight/2)];
    [twoB setImage:IMAGEWITHNAME(@"icon_yizhanshihaitao_sy.png") forState:UIControlStateNormal];
    [barBview addSubview:twoB];
    
    
    UIButton *lastB = [UIButton new];
    lastB.viewSize = CGSizeMake(72, 24);
    [lastB align:ViewAlignmentCenter relativeToPoint:CGPointMake(SCREEN_WIDTH/3*2+SCREEN_WIDTH/6, barBview.viewHeight/2)];
    [lastB setImage:IMAGEWITHNAME(@"icon_xianhuosufa_sy.png") forState:UIControlStateNormal];
    [barBview addSubview:lastB];
    
    UIView *barLine = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, 12, 0.5, 17)];
    barLine.backgroundColor = [UIColor colorWithHex:0xf77171];
    [barBview addSubview:barLine];
    UIView *Line = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 12, 0.5, 17)];
    Line.backgroundColor = [UIColor colorWithHex:0xf77171];
    [barBview addSubview:Line];
    
    UIView *intervalView = [[UIView alloc] initWithFrame:CGRectMake(0, barBview.viewBottomEdge, SCREEN_WIDTH, 10)];
    intervalView.backgroundColor = [UIColor colorWithHex:0xf1f1ed];
    [_headerView addSubview:intervalView];
    
    
    CGFloat itesWith = SCREEN_WIDTH/4;
    for (int i = 0; i<8; i++) {
        int x = i%4;
        int y = i/4;
        
        UIView *placeView = [[UIView alloc] initWithFrame:CGRectMake(x*itesWith, intervalView.viewBottomEdge+12+y*75, itesWith, 61)];
        [_headerView addSubview:placeView];
        
        UIButton * classifitionButton = [UIButton new];
        classifitionButton.tag = i+100;
        classifitionButton.viewSize = CGSizeMake(40, 41);
        [classifitionButton align:ViewAlignmentTopCenter relativeToPoint:CGPointMake(placeView.viewWidth/2,0)];
        
        if (_imageArray && _imageArray.count > 0) {
            if ([_imageArray[i] hasPrefix:@"http"]) {
                [classifitionButton sd_setImageWithURL:[NSURL URLWithString:_imageArray[i]] forState:UIControlStateNormal placeholderImage:IMAGEWITHNAME(@"logo_bangmaiwang_splb") options:SDWebImageRefreshCached];
            }else{
                [classifitionButton setBackgroundImage:IMAGEWITHNAME(_imageArray[i]) forState:UIControlStateNormal];
            }
        }


//        [self dealWithSameImageUrlWithBaseView:classifitionButton index:i];
        
        
        [_headerView addSubview:placeView];
        
        [classifitionButton addTarget:self action:@selector(gotoClassitition:) forControlEvents:UIControlEventTouchUpInside];
        [placeView addSubview:classifitionButton];
        
        UILabel *classifiLabel = [UILabel new];
        classifiLabel.viewSize = CGSizeMake(placeView.viewWidth, 11);
        [classifiLabel align:ViewAlignmentTopCenter relativeToPoint:CGPointMake(placeView.viewWidth/2, classifitionButton.viewBottomEdge+9)];
        
        if (_titleArray && _titleArray.count > 0) {
             classifiLabel.text = _titleArray[i];
        }
       
        classifiLabel.font = fontForSize(11);
        classifiLabel.textColor = [UIColor blackColor];
        classifiLabel.textAlignment = NSTextAlignmentCenter;
        [placeView addSubview:classifiLabel];
    }
    
    UIView *interLine = [[UIView alloc] initWithFrame:CGRectMake(0, intervalView.viewBottomEdge+160, SCREEN_WIDTH, 0.5)];
    interLine.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [_headerView addSubview:interLine];
    
    _extraImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, interLine.viewBottomEdge+11, 16, 13)];
    _extraImageV.image = IMAGEWITHNAME(@"icon_haowai_sy.png");
    _extraImageV.hidden = YES;
    [_headerView addSubview:_extraImageV];
    
    _extraLabel = [[UILabel alloc] initWithFrame:CGRectMake(_extraImageV.viewRightEdge+4, interLine.viewBottomEdge, 36, 35)];
    _extraLabel.text = @"号外：";
    _extraLabel.textColor = [UIColor colorWithHex:0x181818];
    _extraLabel.font = fontForSize(12);
    _extraLabel.hidden = YES;
    [_extraLabel sizeToFit];
    _extraLabel.viewSize = CGSizeMake(_extraLabel.viewWidth, 35);
    [_headerView addSubview:_extraLabel];
    [self scrollLabel:_extraLabel.viewRightEdge andY:interLine.viewBottomEdge];
    
    _rightRow = [UIImageView new];
    _rightRow.viewSize = CGSizeMake(6, 10);
    [_rightRow align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-10, interLine.viewBottomEdge+35/2)];
    _rightRow.image = IMAGEWITHNAME(@"icon_xiaojiantou_sy.png");
    _rightRow.hidden = YES;
    [_headerView addSubview:_rightRow];
    
    _hearSectionView = [UIView new];
    _hearSectionView.viewSize = CGSizeMake(SCREEN_WIDTH, 10);
    [_hearSectionView align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(0, _extraLabel.viewBottomEdge)];
    _hearSectionView.backgroundColor = COLOR_BACKGRONDCOLOR;
//    [_headerView addSubview:_hearSectionView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self getOrderMessageNetWorkNum];
    [self getInformMessageNumNetWork];
    
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"MessageTit" parameters:@{} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSArray *array = object[@"data"];
            NSMutableArray *messArray = [NSMutableArray array];
            for (int i = 0; i < array.count; i ++) {
                NSMutableDictionary * messDic = [NSMutableDictionary dictionaryWithDictionary:array[i]];
                if (messDic[@"message_url"] == [NSNull null]) {
                    [messDic setObject:@" " forKey:@"message_url"];
                }
                [messArray addObject:messDic];
            }
            _messageArray = messArray;
//            _messageArray =  object[@"data"];
            [[NSUserDefaults standardUserDefaults]setObject:_messageArray forKey:@"message"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self refreshHaowai];
        }else if(result == RequestResultEmptyData){
            _messageArray = @[];
            [self refreshHaowai];
        }else{
            _messageArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"message"];
            [self refreshHaowai];
        }
    }];
    
}

-(void)refreshHaowai{
    if (_messageArray.count==0) {
        NSLog(@"123900");
        if (!_headerView) {
            [self initHeaderView];
        }
        _whiteView.hidden = YES;
        _extraImageV.hidden = YES;
        _scrollLabel.hidden = YES;
        _extraLabel.hidden = YES;
        _rightRow.hidden = YES;
        [_hearSectionView align:ViewAlignmentBottomCenter relativeToPoint:CGPointMake(SCREEN_WIDTH/2, _headerView.viewBottomEdge)];
    }else{
        NSLog(@"123800");
        if (_headerView) {
            NSLog(@"123801");
            if (_headerView.viewHeight<211.5+185*W_ABCW+35) {
                NSLog(@"123802");
                _headerView.viewSize = CGSizeMake(_headerView.viewWidth, _headerView.viewHeight+35);
            }
            [self scrollLabel:66 andY:185*W_ABCW+211.5];
        }else{
            NSLog(@"123803");
            if(_titleArray.count >0){
                NSLog(@"123804");
                [self initHeaderView];
                if (_headerView.viewHeight<211.5+185*W_ABCW+35) {
                    NSLog(@"123805");
                    _headerView.viewSize = CGSizeMake(_headerView.viewWidth, _headerView.viewHeight+35);
                }
            }
        }
    }
    _whiteView.hidden = NO;
    _extraImageV.hidden = NO;
    _scrollLabel.hidden = NO;
    _extraLabel.hidden = NO;
    _rightRow.hidden = NO;

//    [_collectionView reloadData];
    
}




-(void)scrollLabel:(CGFloat)currentX andY:(CGFloat)currentY{
    if (_whiteView) {
        NSLog(@"123700");
        [_whiteView removeFromSuperview];
        _whiteView = nil;
        _whiteView = [UIView new];
        _whiteView.viewSize = CGSizeMake(SCREEN_WIDTH - 86, 35);
        [_whiteView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(currentX, currentY)];
        _whiteView.clipsToBounds = YES;
        _whiteView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:_whiteView];
        NSDictionary *dataDic = [_messageArray firstObject];
        _scrollLabel.text = dataDic[@"title"];
        [_scrollLabel sizeToFit];
        _scrollLabel.viewSize = CGSizeMake(_scrollLabel.viewWidth, 35);
        [_scrollLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(3, 0)];
        _scrollLabel.textAlignment = NSTextAlignmentCenter;
        [_whiteView addSubview:_scrollLabel];
        
        UIButton *touchButton = [[UIButton alloc] initWithFrame:_whiteView.frame];
        [touchButton addTarget:self action:@selector(gotomessageDetail) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:touchButton];
        
    }else{
        NSLog(@"123600");
        _whiteView = [UIView new];
        _whiteView.viewSize = CGSizeMake(SCREEN_WIDTH - 86, 35);
        [_whiteView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(currentX, currentY)];
        _whiteView.clipsToBounds = YES;
        _whiteView.hidden = YES;
        _whiteView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:_whiteView];
        
        _scrollLabel = [UILabel new];
        _scrollLabel.viewSize = CGSizeMake(SCREEN_WIDTH - 92, 35);
        [_scrollLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(3, 0)];
        _scrollLabel.textAlignment = NSTextAlignmentCenter;
        [_whiteView addSubview:_scrollLabel];
        
        _scrollLabel.text = @"没有号外";
        _scrollLabel.hidden = YES;
        _scrollLabel.textColor = [UIColor colorWithHex:0x181818];
        _scrollLabel.font = fontForSize(12);
        [_scrollLabel sizeToFit];
        _scrollLabel.viewSize = CGSizeMake(_scrollLabel.viewWidth, 35);
    }
    
    //判断文字的长度有没有超过背景长度，超过就开启跑马灯效果【-5是因为给5个像素的缓冲】
    if (_scrollLabel.viewWidth > _whiteView.viewWidth - 5) {
        [UIView beginAnimations:@"Animation" context:NULL];
        [UIView setAnimationDuration:10];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationRepeatCount:999999999];
        
        CGRect frame = _scrollLabel.frame;
        frame.origin.x = - frame.size.width;
        _scrollLabel.frame = frame;
        
        [UIView commitAnimations];
    }
}

-(void)gotomessageDetail{
    NSDictionary *dataDic = [_messageArray firstObject];
    if (dataDic.allKeys.count==0) {
        
    }else{
        [BaseRequset sendPOSTRequestWithBMWApi2Method:@"MessageCon" parameters:@{@"messageId":dataDic[@"message_id"]} callBack:^(RequestResult result, id object) {
            if (result == RequestResultSuccess) {
                NSString * body = [object[@"data"] objectForKeyNotNull:@"body"];
                CustomerserviceViewController *Message = [[CustomerserviceViewController alloc] init];
                Message.title = object[@"data"][@"title"];
                Message.htmlString = body;
                Message.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:Message animated:YES];
            }
        }];
    }
}


-(void)gotoDetail:(UITapGestureRecognizer *)sender{
    UIImageView *suprImageV = (UIImageView *)sender.view;
    NSDictionary *dic = _bannerD[suprImageV.tag-777];
    switch ([dic[@"type"] integerValue]) {
        case 1:{
            //商品
            GoodsDetailViewController *goodsVC = [[GoodsDetailViewController alloc] init];
            goodsVC.goodsId = dic[@"link"];
            goodsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goodsVC animated:YES];
        }
            break;
        case 2:
            //分类
        {
            NSDictionary *dataSource = @{@"gc_id":dic[@"link"],@"gc_name":dic[@"className"]};
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
            homePageMoreVC.brandName = dic[@"brand_name"];
            homePageMoreVC.ID = dic[@"link"];
            homePageMoreVC.brandClassId = dic[@"class_id"];
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
            htmlVC.htmlUrl = dic[@"link"];
            htmlVC.hidesBottomBarWhenPushed = YES;
            if([dic[@"link"] length]>0){
                [self.navigationController pushViewController:htmlVC animated:YES];
            }
        }
            break;
        case 6:{
            HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
            homePageMoreVC.homePageMoreVCType = HomePageMoreVCShopCar;
            homePageMoreVC.brandName = dic[@"platName"];
            homePageMoreVC.goods_platform_only = dic[@"link"];
            homePageMoreVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:homePageMoreVC animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)initSectionView:(NSDictionary *)dic andSec:(NSInteger)index{
    _sectinView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 52)];
    _sectinView.backgroundColor = [UIColor whiteColor];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    topView.backgroundColor = COLOR_BACKGRONDCOLOR;
    [_sectinView addSubview:topView];
    
    CGSize size = [UIImage imageNamed:_sectionImageArray[index]].size;

    UIView *clearView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 16, 42)];
    [_sectinView addSubview:clearView];
    
    UIImageView *classifitionImage = [UIImageView new];
    classifitionImage.viewSize = size;
    [classifitionImage align:ViewAlignmentCenter relativeToPoint:CGPointMake(clearView.viewWidth/2, clearView.viewHeight/2)];
    classifitionImage.image = IMAGEWITHNAME(_sectionImageArray[index]);
    [clearView addSubview:classifitionImage];
    
    UILabel *classifitionLabel = [[UILabel alloc] initWithFrame:CGRectMake(clearView.viewRightEdge+3, 10, SCREEN_WIDTH-150, 42)];
    classifitionLabel.text = [NSString stringWithFormat:@"%@",dic[@"gc_name"]];
    classifitionLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    classifitionLabel.font = fontForSize(14);
    [_sectinView addSubview:classifitionLabel];
    
    UIImageView *rightRow = [UIImageView new];
    rightRow.viewSize = CGSizeMake(6, 10);
    rightRow.image = IMAGEWITHNAME(@"icon_xiaojiantou_sy.png");
    [rightRow align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-10, 31)];
    [_sectinView addSubview:rightRow];
    
    UILabel *moreLabel = [UILabel new];
    moreLabel.viewSize = CGSizeMake(24, 42);
    moreLabel.text = @"更多";
    [moreLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(rightRow.viewX-8, 10)];
    moreLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    moreLabel.font = fontForSize(12);
    [moreLabel sizeToFit];
    moreLabel.viewHeight = 42;
    [_sectinView addSubview:moreLabel];
    
    UIButton * gotoMore = [[UIButton alloc] initWithFrame:CGRectMake(moreLabel.viewX, 0, 40, 52)];
    gotoMore.tag = index+900;
    [gotoMore addTarget:self action:@selector(gotoMore:) forControlEvents:UIControlEventTouchUpInside];
    [_sectinView addSubview:gotoMore];
}

-(void)gotoMore:(UIButton *)sender{
    HomePageMoreViewController *homePgeMVC = [[HomePageMoreViewController alloc] init];
    homePgeMVC.dataDIc = _sectionArray[sender.tag-900];
    homePgeMVC.hidesBottomBarWhenPushed = YES;
    homePgeMVC.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:homePgeMVC animated:YES];
}


-(void)customNavigationBar{
//    //去掉默认线
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    _pageBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    _pageBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_pageBar];
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    _titleView.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
    _titleView.alpha = 0.0;
    [_pageBar addSubview:_titleView];
    
    
    UIButton *erweima = [[UIButton alloc] initWithFrame:CGRectMake(10*W_ABCW, 33, 21, 21)];
    [erweima setImage:IMAGEWITHNAME(@"icon_saoyisao_sy.png") forState:UIControlStateNormal];
    [erweima addTarget:self action:@selector(erweima) forControlEvents:UIControlEventTouchUpInside];
    [_pageBar addSubview:erweima];
    
    _newsButton = [UIButton new];
    _newsButton.viewSize = CGSizeMake(19, 22);
    _newsButton.selected = NO;
    [_newsButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(SCREEN_WIDTH - 13 * W_ABCW - 19, 33)];
    [_newsButton setImage:IMAGEWITHNAME(@"icon_xiaoxi_sy.png") forState:UIControlStateNormal];
    [_newsButton setImage:IMAGEWITHNAME(@"icon_xiaoxtixingi_sy") forState:UIControlStateSelected];
    [_newsButton addTarget:self action:@selector(gotoNewsC) forControlEvents:UIControlEventTouchUpInside];
    [_pageBar addSubview:_newsButton];

    
    CGFloat searchWidth = SCREEN_WIDTH - erweima.viewWidth - _newsButton.viewWidth - 25 * W_ABCW - 24 * W_ABCW;

    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(erweima.viewRightEdge + 11 * W_ABCW, 25, searchWidth, 34)];
    searchView.backgroundColor = [UIColor colorWithHex:0xffffff];
    searchView.layer.cornerRadius = 4;
    searchView.alpha = 0.3;
    searchView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gotoSearch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoSearch)];
    [searchView addGestureRecognizer:gotoSearch];
    [_pageBar addSubview:searchView];
    
    UIImageView * searchImage = [UIImageView new];
    searchImage.frame = CGRectMake(searchView.viewX + 11, searchView.viewY + 11, 12, 12);
    searchImage.image = IMAGEWITHNAME(@"icon_Search_sy.png");
    [_pageBar addSubview:searchImage];

    UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(searchView.viewX + 30, searchView.viewY, 110, 34)];
    searchLabel.text = @"搜索商品名称和品牌";
    searchLabel.textColor = [UIColor whiteColor];
    searchLabel.font = fontForSize(12);
    [searchLabel sizeToFit];
    searchLabel.viewSize = CGSizeMake(searchLabel.viewWidth, 34);
    [_pageBar addSubview:searchLabel];
    
}

-(void)gotoNewsC{
    _newsButton.selected = NO;
    
    NewsCenterViewController *newsVC = [[NewsCenterViewController alloc] init];
    //newsVC.whereFrom = NO;
    if ([JCUserContext sharedManager].isUserLogedIn) {
        newsVC.newsCenterType = NewsCenterDefault;
    }
    else{
         newsVC.newsCenterType = NewsCenterVisitor;
    }
    newsVC.noticeDataSource = _messageArray;
    newsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newsVC animated:YES];
}

-(void)gotoSearch{
    NSLog(@"gotosearch");
    HomeSearchViewController *homeSearch = [[HomeSearchViewController alloc] init];
    homeSearch.navigationItem.hidesBackButton = YES;
    homeSearch.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeSearch animated:YES];
}

-(void)erweima{
    NSLog(@"扫描二维码");
    SYQRCodeViewController * QRCodeVC = [[SYQRCodeViewController alloc]init];
    
    __block HomePageViewController * weakSelf = self;
    [QRCodeVC setSYQRCodeSuncessBlock:^(SYQRCodeViewController * QRVC, NSString * drqCodeString) {
        if ([drqCodeString hasPrefix:@"http://m.indoorbuy.com/"]) {
            
            NSCharacterSet *setToRemove = [[ NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet ]; NSString *newString = [[drqCodeString componentsSeparatedByCharactersInSet:setToRemove] componentsJoinedByString:@""];
            NSLog(@"%@", newString);
            
            NSDictionary * dic = @{@"code":newString,@"vc":QRVC};
            [weakSelf performSelector:@selector(dismissVCWith:) withObject:dic afterDelay:0.3];
        }
        else if ([drqCodeString hasPrefix:@"http://www.indoorbuy.com"] || [drqCodeString hasPrefix:@"www.indoorbuy.com"]){
            
            NSDictionary * dic = @{@"code":@"http://www.indoorbuy.com",@"vc":QRVC};
            [weakSelf performSelector:@selector(dismissVCWith:) withObject:dic afterDelay:0.3];
        }
        else{
            
            NSDictionary * dic = @{@"code":@"未找到该商品",@"vc":QRVC};
            [weakSelf performSelector:@selector(dismissVCWith:) withObject:dic afterDelay:0.3];
            
        }        
    }];
    QRCodeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:QRCodeVC animated:YES];
}

-(void)dismissVCWith:(NSDictionary *)sender
{
    //NSString * dropCodeStr = sender[@"code"];
    UIViewController * vc = sender[@"vc"];
    [vc.navigationController popViewControllerAnimated:YES];

    NSString * string = sender[@"code"];
    if ([string isEqualToString:@"未找到该商品"]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([string isEqualToString:@"http://www.indoorbuy.com"] || [string isEqualToString:@"www.indoorbuy.com"] ){
        CustomerserviceViewController * webViewVC = [[CustomerserviceViewController alloc]init];
        webViewVC.htmlUrl = string;
        webViewVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewVC animated:YES];
    }
    else{
        GoodsDetailViewController *goodsVC = [[GoodsDetailViewController alloc] init];
        goodsVC.goodsId = sender[@"code"];
        goodsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodsVC animated:YES];
    }
}

-(void)initUserInterface{
    UIView *placeV = [[UIView alloc] init];
    [self.view addSubview:placeV];
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    HomePageFlowLayout *layout = [[HomePageFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44) collectionViewLayout:layout];
    _collectionView.backgroundColor = COLOR_BACKGRONDCOLOR;
    [_collectionView registerClass:[HomeCell class] forCellWithReuseIdentifier:@"pageCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"otherView"];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate= self;
    [_collectionView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
//    _collectionView.headerPullToRefreshText = @"下拉刷新";
    [self.view addSubview:_collectionView];
    
}

-(void)refreshView {
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GcFirstClass" parameters:@{} callBack:^(RequestResult result, id object) {
        [_titleArray removeAllObjects];
        [_imageArray removeAllObjects];
        if (result ==RequestResultSuccess) {
            NSArray *array  = object[@"data"];
            for (NSDictionary *dataDic in array) {
                [_titleArray addObject:dataDic[@"gc_name"]];
                [_imageArray addObject:dataDic[@"image"]];
            }
            [_titleArray addObject:@"特惠上新"];
            [_titleArray addObject:@"全部分类"];
            [_imageArray addObject:@"icon_tehuishangxin_sy.png"];
            [_imageArray addObject:@"icon_quanbufenlei_sy.png"];
            [[NSUserDefaults standardUserDefaults]setObject:_titleArray forKey:@"titleArray"];
            [[NSUserDefaults standardUserDefaults]setObject:_imageArray forKey:@"imageArray"];
            if (_bannerD.count >0) {
                [self upDateHeaderView];
            }
        }else{
            [_titleArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"titleArray"]];
            [_imageArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"imageArray"]];
            if (_bannerD.count >0) {
                [self upDateHeaderView];
            }
        }
    }];

    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"BannerList" parameters:@{@"class":@"1"} callBack:^(RequestResult result, id object) {
        [_collectionView.header endRefreshing];
        if (result == RequestResultSuccess) {
            _bannerD = object[@"data"];
        }
        [self upDateCollectionV];
    }];
    
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"BannerList" parameters:@{@"class":@"2"} callBack:^(RequestResult result, id object) {
        [_collectionView.header endRefreshing];
        if (result == RequestResultSuccess) {
            _adverImageArray = object[@"data"];
        }
        [self upDateHeaderView];
    }];
    
    
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"HomePage" parameters:nil callBack:^(RequestResult result, id object) {
        [_collectionView.header endRefreshing];
        if (result == RequestResultSuccess) {
            JCDBCacheManager *cac = [JCDBCacheManager cacheForClass:homePageModel.class];
            NSArray *testArray = [cac queryWithCondition:nil];
            _sectionArray = object[@"data"];
            BOOL result;
            NSMutableArray * goodsList = [NSMutableArray array];
            for (NSDictionary *dic in _sectionArray) {
                homePageModel *homeModel = [[homePageModel alloc] initWithJsonObject:dic];
                [goodsList addObject:homeModel];
            }
            if (testArray.count==0) {
                result = [cac insert:goodsList];
                if (result) {
                    NSLog(@"写入成功");
                }
            }else{
                result = [cac update:goodsList withConditions:testArray];
                if (result) {
                    NSLog(@"更新成功");
                }
            }
        }else{
            JCDBCacheManager *cac = [JCDBCacheManager cacheForClass:homePageModel.class];
            NSArray *testArray = [cac queryWithCondition:nil];
            NSMutableArray *cachArray = [NSMutableArray array];
            for (homePageModel *homeM in testArray) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                NSArray *goods = [TYTools JSONObjectWithString:homeM.goods_array];
                [dic setValue:homeM.gc_id forKey:@"gc_id"];
                [dic setValue:homeM.gc_name forKey:@"gc_name"];
                [dic setValue:goods forKey:@"goods"];
                [cachArray addObject:dic];
            }
            _sectionArray = cachArray;
        }
        [self.HUD hide:YES];
        [_collectionView reloadData];
    }];
    
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"MessageTit" parameters:@{} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSArray *array = object[@"data"];
            NSMutableArray *messArray = [NSMutableArray array];
            for (int i = 0; i < array.count; i ++) {
                NSMutableDictionary * messDic = [NSMutableDictionary dictionaryWithDictionary:array[i]];
                if (messDic[@"message_url"] == [NSNull null]) {
                    [messDic setObject:@" " forKey:@"message_url"];
                }
                [messArray addObject:messDic];
            }
            _messageArray = messArray;
            
            [[NSUserDefaults standardUserDefaults]setObject:_messageArray forKey:@"message"];
            [self refreshHaowai];
        }else if(result == RequestResultEmptyData){
            _messageArray = @[];
            [self refreshHaowai];
        }else{
            _messageArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"message"];
            [self refreshHaowai];
        }
    }];

}

-(void)upDateHeaderView{
    [self initHeaderView];
    [self refreshHaowai];
    [_collectionView reloadData];
}


-(void)upDateCollectionV{
    [_collectionView reloadData];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2+_sectionArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section==0){
        return 0;
    }else if(section==1){
        return _adverImageArray.count;
    }else{
        NSDictionary *sectionDic = _sectionArray[section-2];
        return [sectionDic[@"goods"] count];
    }
}

-(UICollectionViewCell *)
collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pageCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.section==1) {
        cell.adverDic = _adverImageArray[indexPath.row];
    }else{
        NSDictionary *sectionDic = _sectionArray[indexPath.section-2];
        cell.dataDic = sectionDic[@"goods"][indexPath.row];
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size ;
    if (indexPath.section==1) {
        NSURL * url = [NSURL URLWithString:_adverImageArray[indexPath.row][@"image"]];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        BOOL existBool = [manager diskImageExistsForURL:url];//判断是否有缓存
        UIImage * imageCache;
        if (existBool) {
            imageCache = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
            CGFloat bilie = SCREEN_WIDTH/imageCache.size.width;
            size = CGSizeMake(SCREEN_WIDTH, imageCache.size.height*bilie);
        }else{
            UIImageView  *sd_imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            [sd_imageV sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!error) {
                    [_collectionView reloadData];
                }
            }];
            [self.view addSubview:sd_imageV];
        }
    }else{
        size = CGSizeMake((SCREEN_WIDTH - 12*W_ABCW)/2, 223);
    }
    return size;
}
//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section==1) {
        return 0*W_ABCW;
    }else{
        return 4*W_ABCW;
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 3*W_ABCW;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section==1) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        return UIEdgeInsetsMake(0,4*W_ABCW,4*W_ABCW,4*W_ABCW);
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size;
    if (section==0) {
        NSLog(@"%f",_headerView.frame.size.height);
        size = CGSizeMake(SCREEN_WIDTH, _headerView.frame.size.height);
    }else if(section==1){
        size = CGSizeZero;
    }
    else{
        size = CGSizeMake(SCREEN_WIDTH, 52);
    }
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        [header addSubview:_headerView];
        return header;
    }else{
        UICollectionReusableView * reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"otherView" forIndexPath:indexPath];
        for (UIView *view in reuseableView.subviews) {
            [view removeFromSuperview];
        }
        [self initSectionView:_sectionArray[indexPath.section-2] andSec:indexPath.section-2];
        [reuseableView addSubview:_sectinView];
        return reuseableView;
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section>1) {
        NSDictionary *sectionDic = _sectionArray[indexPath.section-2];
        NSArray *data = sectionDic[@"goods"];
        NSDictionary * dic = data[indexPath.row];
        NSString * goodId = [NSString stringWithFormat:@"%@",dic[@"goods_id"]];
        GoodsDetailViewController * goodsDetailVC =[[GoodsDetailViewController alloc]init];
        goodsDetailVC.goodsId = goodId;
        goodsDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:goodsDetailVC animated:YES];
    }else if(indexPath.section==1){
        NSDictionary *dataDic = _adverImageArray[indexPath.row];
        NSLog(@"跳转内容");
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
                htmlVC.htmlUrl = [dataDic objectForKeyNotNull:@"link"];
                htmlVC.hidesBottomBarWhenPushed = YES;
                if ([[dataDic objectForKeyNotNull:@"link"] length] > 0) {
                    [self.navigationController pushViewController:htmlVC animated:YES];
                }
            }
                break;
            case 6:{
                HomePageMoreViewController *homePageMoreVC = [[HomePageMoreViewController alloc] init];
                homePageMoreVC.homePageMoreVCType = HomePageMoreVCShopCar;
                homePageMoreVC.brandName = dataDic[@"platName"];
                homePageMoreVC.goods_platform_only = dataDic[@"link"];
                homePageMoreVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:homePageMoreVC animated:YES];
            }
            default:
                break;
        }
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag==444) {
        _pageC.currentPage = scrollView.contentOffset.x/SCREEN_WIDTH;
    }
    CGFloat offset_y = _collectionView.contentOffset.y;
    if (offset_y >= 0 && offset_y <= 44) {
        _pageBar.alpha = 1.0;
        _titleView.alpha = offset_y / 44;
    }
    if (offset_y > 44) {
        _titleView.alpha = 1;
    }
    if (offset_y < 0) {
        [UIView animateWithDuration:0.2 animations:^{
            _pageBar.alpha = 0;
        }];
    }

}

-(void)gotoClassitition:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    if (index == 6) {
        BargainViewController * bargainVC = [[BargainViewController alloc]init];
        bargainVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bargainVC animated:YES];
    }
    else if(index==7){
        RootTabBarVC * rootVC = ROOTVIEWCONTROLLER;
        rootVC.selectedIndex = 1;
    }else{
        HomePageMoreViewController *homePgeMVC = [[HomePageMoreViewController alloc] init];
        homePgeMVC.dataDIc = _sectionArray[index];
        homePgeMVC.hidesBottomBarWhenPushed = YES;
        homePgeMVC.navigationItem.hidesBackButton = YES;
        [self.navigationController pushViewController:homePgeMVC animated:YES];
    }
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
                   _newsButton.selected = YES;
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
    
}
-(void)getInformMessageNumNetWork
{
    if ([JCUserContext sharedManager].isUserLogedIn) {
        [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetMessageNum" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"type":@"2"} callBack:^(RequestResult result, id object) {
            if (result == RequestResultSuccess) {
                NSInteger newsCount = [object[@"data"] integerValue];
                if (newsCount > 0) {
                    _newsButton.selected = YES;
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
    
}

#pragma mark -- 处理同一个URL情况【8个按钮菜单】
- (void)dealWithSameImageUrlWithBaseView:(UIButton *)baseButton index:(NSInteger)index {
    NSData * imageData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"menuImage%ld",index]];
    if (imageData != nil) {
        //先加载上次的图片
        [baseButton setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
    }
    else {
        [baseButton setBackgroundImage:IMAGEWITHNAME(@"logo_bangmaiwang_splb") forState:UIControlStateNormal];
    }
    
    
    if (_imageArray && _imageArray.count > 0) {
        
        if ([_imageArray[index] hasPrefix:@"http"]) {
            //将图片存储
            NSString * string = [NSString stringWithFormat:@"menuImage%ld",index];
            //_imageArray[index]
            UIImage * newImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imageArray[index]]]];
            if (newImage != nil) {
                NSData * data = UIImagePNGRepresentation(newImage);
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:string];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            if (imageData != nil) {
                //该方法用于处理用一个url的情况
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    // 处理耗时操作的代码块...
                    //通知主线程刷新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //回调或者说是通知主线程刷新，
                        if (newImage) {
                            [baseButton setBackgroundImage:newImage forState:UIControlStateNormal];
                        }
                        else{
                            NSData * imageData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"menuImage%ld",index]];
                            if (imageData != nil) {
                                [baseButton setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
                            }
                            else {
                                [baseButton setImage:IMAGEWITHNAME(@"logo_bangmaiwang_splb") forState:UIControlStateNormal];
                            }
                        }
                    });
                    
                });
            }
            else {
                [baseButton setBackgroundImage:newImage forState:UIControlStateNormal];
            }
        }else{
            [baseButton setBackgroundImage:IMAGEWITHNAME(_imageArray[index]) forState:UIControlStateNormal];
        }
    }
}


@end
