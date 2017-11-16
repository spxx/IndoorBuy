//
//  ADScrollView.m
//  Custom
//
//  Created by LiuP on 16/6/7.
//  Copyright © 2016年 LiuP. All rights reserved.
//

#import "ADScrollView.h"

#define PAGES 20  // 最多显示点

@interface ADScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, strong) NSMutableArray * imageViews;  /**< 存放轮播的图片对象 */
@end

@implementation ADScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self initScrollView];
    }
    return self;
}

#pragma mark -- init 
- (void)initScrollView
{
    self.scrollView = [UIScrollView new];
    self.scrollView.frame = self.bounds;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    [self addSubview:self.scrollView];
    
    self.pageControl = [UIPageControl new];
    self.pageControl.frame = CGRectMake(0, 0, 100, 20);
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetHeight(self.bounds) - 15);
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithHex:0xfc4e40];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];

    [self addSubview:self.pageControl];
    
    self.imageViews = [NSMutableArray array];
    // 轮播图的大小
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    for (int i = 0; i < 3; i ++) {
        UIImageView * imageView = [UIImageView new];
        imageView.frame = CGRectMake(width * i, 0, width, height);
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.userInteractionEnabled = YES;
        [self.scrollView addSubview:imageView];
        [self.imageViews addObject:imageView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adScrollViewClickedAction)];
        [imageView addGestureRecognizer:tap];
    }
}

#pragma mark -- setter
- (void)setAdModels:(NSMutableArray *)adModels
{
    if (_adModels != adModels) {
        _adModels = [NSMutableArray arrayWithArray:adModels];
        
        // 最多显示多少个点....
        if (self.adModels.count >= PAGES) {
            self.pageControl.numberOfPages = PAGES;
        }else {
            self.pageControl.numberOfPages = self.adModels.count;
            if (self.adModels.count < 3) {
                [self.scrollView setContentOffset:CGPointMake(0, 0)];
            }else {

                [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width, 0)];
            }
        }
        // 将最后一个图片移到第一个
        if (self.adModels.count >= 3) {
            id lastObject = [self.adModels objectAtIndex:self.adModels.count - 1];
            [self.adModels removeLastObject];
            [self.adModels insertObject:lastObject atIndex:0];            
        }
        self.pageControl.currentPage = 0;
        [self updateView];
    }
}

#pragma mark -- others
/**
 *  更新视图
 */
- (void)updateView
{
    if (self.adModels.count >= 3) {  // 3张或以上图片才使用无限轮播效果。
        self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * 3,
                                                 self.scrollView.bounds.size.height);
        for (int i = 0; i < self.imageViews.count; i ++) {
            ADModel * model = self.adModels[i];
            UIImageView * image = self.imageViews[i];
            [image sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]
                     placeholderImage:IMAGEWITHNAME(@"logo_sy.png")];
        }
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width, 0)];
    }else {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * self.adModels.count,
                                                 self.scrollView.bounds.size.height);
        for (int i = 0; i < self.adModels.count; i ++) {
            ADModel * model = self.adModels[i];
            UIImageView * image = self.imageViews[i];
            [image setShowActivityIndicatorView:YES];
            [image sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]
                     placeholderImage:IMAGEWITHNAME(@"logo_sy.png")];
        }
    }
}

/**
 *  点击事件
 */
- (void)adScrollViewClickedAction
{
    ADModel * model;
    if (self.adModels.count >= 3) {
        model = self.adModels[1];
    }else {
        model = self.adModels[self.pageControl.currentPage];
    }
    if ([self.delegate respondsToSelector:@selector(adScrollView:didClickedWithADModel:)]) {
        [self.delegate adScrollView:self didClickedWithADModel:model];
    }
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.adModels.count >= 3) {
        if (scrollView.contentOffset.x <= 0) {
            // 往右滑动
            self.pageControl.currentPage = self.pageControl.currentPage == 0 ? self.pageControl.numberOfPages - 1 : -- self.pageControl.currentPage;
            id lastObject = [self.adModels objectAtIndex:self.adModels.count - 1];
            [self.adModels removeLastObject];
            [self.adModels insertObject:lastObject atIndex:0];
            [self updateView];
        }
        if (scrollView.contentOffset.x >= scrollView.bounds.size.width * 2) {
            // 往左滑动
            self.pageControl.currentPage = self.pageControl.currentPage == self.pageControl.numberOfPages - 1 ? 0 : ++ self.pageControl.currentPage;
            id firstObject = [self.adModels objectAtIndex:0];
            [self.adModels removeObjectAtIndex:0];
            [self.adModels addObject:firstObject];
            [self updateView];
        }
    }else {
        
        if (scrollView.contentOffset.x == 0) {
            self.pageControl.currentPage = 0;
        }
        if (scrollView.contentOffset.x == scrollView.bounds.size.width) {
            self.pageControl.currentPage = 1;
        }
    }
}
@end
