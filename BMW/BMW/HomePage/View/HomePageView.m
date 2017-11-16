//
//  HomePageView.m
//  BMW
//
//  Created by rr on 2016/12/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "HomePageView.h"
#import "HomePageFlowLayout.h"
#import "HomeCell.h"
#import "HomePageBar.h"
#import "HomePageTopView.h"


@interface HomePageView ()<UICollectionViewDelegate,UICollectionViewDataSource,HomePageTopViewDelegate,HomePageBarDelegate>
{
    NSArray *_sectionImageArray;
    UIView  *_sectinView;
}
@property (nonatomic, strong) HomePageBar * homePageBar; /**< 顶部工具 */

@property (nonatomic, strong) HomePageTopView * homePageTopView; /**< 店铺上半部分视图 */



@end


@implementation HomePageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_BACKGRONDCOLOR;
        
        _sectionImageArray = @[@"icon_muyingyongpin_1_sy.png",@"icon_shenghuojiaju_1_sy.png",@"icon_gehumeizhuang_1_sy.png",@"icon_quanqiumeishi_1_sy.png",@"icon_yingyongbaojian_1_sy.png",@"icon_fushixiangbao_1_sy.png"];

        [self initUserInterface];
        

    }
    return self;
}

-(void)initUserInterface{
    
    // 高度内部自行调整
    _homePageTopView = [[HomePageTopView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, 0)];
    _homePageTopView.delegate = self;

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
    [self addSubview:_collectionView];
    
    // 顶部工具 初始化扫描、搜索、消息
    _homePageBar = [[HomePageBar alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 64)];
    _homePageBar.delegate = self;
    [self addSubview:_homePageBar];

    
}

#pragma mark -- setter
-(void)setADModels:(NSMutableArray *)ADModels{
    _ADModels = ADModels;
    _homePageTopView.ADModels = _ADModels;
}

-(void)setRollModels:(NSMutableArray *)rollModels
{
    _rollModels = rollModels;
    _homePageTopView.rollModels = rollModels;
}


-(void)setModels:(HomePageM *)models{
    _models = models;
    [_collectionView reloadData];
}

- (void)setShowRedPoint:(BOOL)showRedPoint
{
    _showRedPoint = showRedPoint;
    self.homePageBar.showRedPoint = showRedPoint;
}

- (void)setLogoModel:(HomePageM *)logoModel
{
    _logoModel = logoModel;
    self.homePageBar.logoModel = logoModel;
}

#pragma mark -- other
- (void)startAnimation
{
    [self.homePageTopView startAnimation];
}

- (void)pauseAnimation
{
    [self.homePageTopView pauseAnimation];
}

#pragma mark -- UICollectionViewDelegate,UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2+self.models.goodsModels.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section==0){
        return 0;
    }else if(section==1){
        return self.models.adverImageArray.count;
    }else{
        NSDictionary *sectionDic = self.models.goodsModels[section - 2];

        return [sectionDic[@"goods"] count];
    }
}

-(UICollectionViewCell *)
collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pageCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.section==1) {
        cell.adverDic = self.models.adverImageArray[indexPath.row];
    }else{
        NSDictionary *sectionDic = self.models.goodsModels[indexPath.section - 2];
        cell.dataDic = sectionDic[@"goods"][indexPath.row];
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size ;
    if (indexPath.section==1) {
        NSURL * url = [NSURL URLWithString:self.models.adverImageArray[indexPath.row][@"image"]];
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
            [self addSubview:sd_imageV];
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
        size = CGSizeMake(SCREEN_WIDTH, self.homePageTopView.frame.size.height);
    }else if(section==1){
        size = CGSizeZero;
    }
    else{
        size = CGSizeMake(SCREEN_WIDTH, 52);;
    }
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        [header addSubview:self.homePageTopView];
        return header;
    }else{
        UICollectionReusableView * reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"otherView" forIndexPath:indexPath];
        for (UIView *view in reuseableView.subviews) {
            [view removeFromSuperview];
        }
        [self initSectionView:self.models.goodsModels[indexPath.section-2] andSec:indexPath.section-2];
        [reuseableView addSubview:_sectinView];
        
        return reuseableView;
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


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= 2){
        if ([self.delegate respondsToSelector:@selector(homePageView:didSelectedItemWithGoodsModel:)]) {
            NSDictionary *sectionDic = self.models.goodsModels[indexPath.section - 2];
            [self.delegate homePageView:self didSelectedItemWithGoodsModel:sectionDic[@"goods"][indexPath.item]];
        }
    }else if (indexPath.section == 1){
        if ([self.delegate respondsToSelector:@selector(homePageView:didSelectedItemWithBanner:)]) {
            [self.delegate homePageView:self didSelectedItemWithBanner:self.models.adverImageArray[indexPath.item]];
        }
    }
}

-(void)gotoMore:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(homePageView:clickedMoreWithClassModel:)]) {
        [self.delegate homePageView:self clickedMoreWithClassModel:self.models.goodsModels[sender.tag - 900]];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset_y = self.collectionView.contentOffset.y;
    if (offset_y >= 0 && offset_y <= 44) {
        self.homePageBar.alpha = 1.0;
        self.homePageBar.alphaView.alpha = offset_y / 44;
    }
    if (offset_y > 44) {
        self.homePageBar.alphaView.alpha = 0.7;
    }
    if (offset_y < 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.homePageBar.alpha = 0;
        }];
    }
}








-(void)endRefresh{
    [_collectionView.header endRefreshing];
    [_collectionView.footer endRefreshing];
}
-(void)refreshView{
    if ([self.delegate respondsToSelector:@selector(homePageViewRefreshAction)]) {
        [self.delegate homePageViewRefreshAction];
    }
    
}

#pragma mark HomePageTopViewDelegate  HomePageBarDelegate

- (void)homePageTopView:(HomePageTopView *)homePageTopView clickedOtherClassWithTag:(NSInteger)tag
{
    if ([self.delegate respondsToSelector:@selector(homePageView:clickedClassWithTag:)]) {
        [self.delegate homePageView:self clickedClassWithTag:tag];
    }
}
// 轮播图
- (void)homePageTopView:(HomePageTopView *)homePageTopView clickedADPicWithADModel:(ADModel *)adModel
{
    if ([self.delegate respondsToSelector:@selector(homePageView:clickedADPicWithADModel:)]) {
        [self.delegate homePageView:self clickedADPicWithADModel:adModel];
    }
}
// 快报
- (void)homePageTopView:(HomePageTopView *)homePageTopView clickedRollADWithADModel:(ADModel *)adModel
{
    if ([self.delegate respondsToSelector:@selector(homePageView:clickedADRollWithADModel:)]) {
        [self.delegate homePageView:self clickedADRollWithADModel:adModel];
    }
}

-(void)homePageBarClickedScanCodeAction{
    if([self.delegate respondsToSelector:@selector(clickMyShop)]){
        [self.delegate clickMyShop];
    }
}

-(void)homePageBarClickedShareAction{
    if ([self.delegate respondsToSelector:@selector(clickShare)]) {
        [self.delegate clickShare];
    }
}

-(void)homePageBarClickedSearchAction{
    if ([self.delegate respondsToSelector:@selector(homePageViewClickedSearchAction)]) {
        [self.delegate homePageViewClickedSearchAction];
    }
    
}

-(void)homePageBarClickedMessageAction{
    if ([self.delegate respondsToSelector:@selector(homePageViewClickedMessageAction)]) {
        [self.delegate homePageViewClickedMessageAction];
    }
}

@end
