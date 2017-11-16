//
//  ClassifyVIew.m
//  BMW
//
//  Created by LiuP on 2016/12/5.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ClassifyView.h"

@interface ClassifyView ()<UIScrollViewDelegate, FirstViewDelegate, SecondViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) FirstView * firstView;
@property (nonatomic, strong) SecondView * secondView;

@end

@implementation ClassifyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.contentSize = CGSizeMake(self.viewWidth * 2, self.viewHeight);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
    
    _firstView = [[FirstView alloc] initWithFrame:self.bounds];
    _firstView.delegate = self;
    [_scrollView addSubview:_firstView];
    
    _secondView = [[SecondView alloc] initWithFrame:CGRectMake(self.viewWidth, 0, self.viewWidth, self.viewHeight)];
    _secondView.delegate = self;
    [_scrollView addSubview:_secondView];
}

#pragma mark -- setter
/************第一页相关数据*************/
- (void)setClassModels:(NSMutableArray *)classModels
{
    _classModels = classModels;
    self.firstView.classModels = classModels;
}

- (void)setItemModels:(NSMutableArray *)itemModels
{
    _itemModels = itemModels;
    self.firstView.itemModels = itemModels;
}

- (void)setBannerModel:(ClassModel *)bannerModel
{
    _bannerModel = bannerModel;
    self.firstView.bannerModel = bannerModel;
}
/************第二页相关数据*************/
- (void)setBrandClassModels:(NSMutableArray *)brandClassModels
{
    _brandClassModels = brandClassModels;
    self.secondView.classModels = brandClassModels;
}
- (void)setBrandModels:(NSMutableArray *)brandModels
{
    _brandModels = brandModels;
    self.secondView.models = brandModels;
}

- (void)setIndexs:(NSMutableArray *)indexs
{
    _indexs = indexs;
    self.secondView.indexs = indexs;
}


#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    Status status;
    if (scrollView.contentOffset.x >= scrollView.viewWidth) {
        status = StatusBrand;
    }else {
        status = StatusClass;
    }
    if ([self.delegate respondsToSelector:@selector(classView:pageTurnWithStatus:)]) {
        [self.delegate classView:self pageTurnWithStatus:status];
    }
}

#pragma mark -- FirstViewDelegate
- (void)firstView:(FirstView *)firstView didSelectedFirstClass:(ClassModel *)model
{
    if ([self.delegate respondsToSelector:@selector(classView:didSelectedFirstClass:)]) {
        [self.delegate classView:self didSelectedFirstClass:model];
    }
}

- (void)firstView:(FirstView *)firstView didSelectedSecondClass:(ClassModel *)model
{
    if ([self.delegate respondsToSelector:@selector(classView:didSelectedSecondClass:)]) {
        [self.delegate classView:self didSelectedSecondClass:model];
    }
}

- (void)firstView:(FirstView *)firstView didSelectedThirdClass:(ClassModel *)model
{
    if ([self.delegate respondsToSelector:@selector(classView:didSelectedThirdClass:)]) {
        [self.delegate classView:self didSelectedThirdClass:model];
    }
}

- (void)firstView:(FirstView *)firstView didSelectedBanner:(ClassModel *)bannerModel
{
    if ([self.delegate respondsToSelector:@selector(classView:didSelectedBanner:)]) {
        [self.delegate classView:self didSelectedBanner:bannerModel];
    }
}

#pragma mark -- SecondViewDelegate
- (void)secondView:(SecondView *)secondView didSelectedBrandWithModel:(BrandModel *)model
{
    if ([self.delegate respondsToSelector:@selector(classView:didSelectedBrand:)]) {
        [self.delegate classView:self didSelectedBrand:model];
    }
}

- (void)secondView:(SecondView *)secondView didSelectedClassWithModel:(ClassModel *)model
{
    if ([self.delegate respondsToSelector:@selector(classView:didSelectedBrandClassWithClass:)]) {
        [self.delegate classView:self didSelectedBrandClassWithClass:model];
    }
}

- (void)secondView:(SecondView *)secondView didSelectedDownBtn:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(classView:didSelectedDownBtn:)]) {
        [self.delegate classView:self didSelectedDownBtn:btn];
    }
}
#pragma mark -- other
- (void)pageTurnWithStatus:(Status)status;
{
    if (status == StatusClass) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.viewWidth, 0) animated:YES];
    }
}

- (void)reloadBrandClass
{
    [self.secondView reloadBrandClassMenu];
}

- (void)firstPageIndicatorShow:(BOOL)show
{
    [self.firstView itemIndicatorShow:show];
}

- (void)secondPageIndicatorShow:(BOOL)show
{
    [self.secondView indicatorShow:show];
}
@end
