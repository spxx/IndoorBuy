//
//  HomePageTopView.m
//  DP
//
//  Created by LiuP on 16/7/22.
//  Copyright © 2016年 sp. All rights reserved.
//

#import "HomePageTopView.h"
#import "ADView.h"
#import "ADModel.h"

@interface HomePageTopView ()<ADScrollViewDelegate, ADViewDelegate>



@property (nonatomic, strong) ADScrollView * adScrollView; /**< 广告轮播图 */
@property (nonatomic, strong) ADView *adView;

@property (nonatomic, copy) NSArray * images;  /**< 分类的名字 */
@property (nonatomic, copy) NSArray * titles;  /**< 分类的图标 */
@property (nonatomic, retain) NSMutableArray * classBtns;   /**< 分类按钮 */
@property (nonatomic, retain) NSMutableArray * classLabels; /**< 分类标签 */
@end

@implementation HomePageTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_BACKGRONDCOLOR;

        _images = @[@"icom_yaoqingyouli_sy.png",
                    @"icon_lingquanzhongxin_sy.png",
                    @"icon_youkaduihuan_sy.png",
                    @"icon_tehuishangxin_sy.png"];
        _titles = @[@"邀请有礼",@"领券中心",@"油卡兑换",@"特惠上新"];
        
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface
{
    [self initADScrollView];
    [self initClassView];
}

/**
 *  初始化轮播图
 */
- (void)initADScrollView
{
    _adScrollView = [[ADScrollView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, 185 * W_ABCW)];
    _adScrollView.delegate = self;
    [self addSubview:_adScrollView];
}
/**
 *  初始化分类
 */
- (void)initClassView
{
    UIView *backView= [[UIView alloc] initWithFrame:CGRectMake(0, _adScrollView.viewBottomEdge, SCREEN_WIDTH, 68 + 30*W_ABCW)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    
    _classBtns = [NSMutableArray array];
    _classLabels = [NSMutableArray array];
    CGFloat itemsWidth = SCREEN_WIDTH/4;
    for (int i = 0; i<_images.count; i++) {
        UIView *placeView = [[UIView alloc] initWithFrame:CGRectMake(i * itemsWidth, 0, itemsWidth, 68)];
        [backView addSubview:placeView];
        
        UIButton * classButton = [UIButton new];
        classButton.viewSize = CGSizeMake(40, 40);
        [classButton align:ViewAlignmentTopCenter
                  relativeToPoint:CGPointMake(placeView.viewWidth/2,0)];
        [classButton setImage:IMAGEWITHNAME(_images[i])
             forState:UIControlStateNormal];
        [placeView addSubview:classButton];
        
        UILabel *classLabel = [UILabel new];
        classLabel.viewSize = CGSizeMake(placeView.viewWidth, 12);
        [classLabel align:ViewAlignmentTopCenter
             relativeToPoint:CGPointMake(placeView.viewWidth/2, classButton.viewBottomEdge+9)];
        classLabel.font = fontForSize(12);
        classLabel.text = _titles[i];
        classLabel.textColor = [UIColor blackColor];
        classLabel.textAlignment = NSTextAlignmentCenter;
        [placeView addSubview:classLabel];
        
        [_classBtns addObject:classButton];
        [_classLabels addObject: classLabel];
        
        UIButton *bigBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemsWidth, placeView.viewHeight)];
        bigBtn.tag = i+100;
        [bigBtn addTarget:self action:@selector(gotoClassitition:) forControlEvents:UIControlEventTouchUpInside];
        [placeView addSubview:bigBtn];
        
        
    }
    _adView = [[ADView alloc] initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, 30*W_ABCW)];
    _adView.delegate = self;
    [backView addSubview:_adView];
    
    //更新自己的高度
    self.frame = CGRectMake(self.viewX, self.viewY, self.viewWidth, backView.viewBottomEdge);
}

#pragma mark -- setter
- (void)setADModels:(NSMutableArray<ADModel *> *)ADModels
{
    _ADModels = ADModels;
    self.adScrollView.adModels = _ADModels;
}

-(void)setRollModels:(NSMutableArray *)rollModels
{
    _rollModels = rollModels;
    self.adView.models = rollModels;
}

#pragma mark -- other
- (void)startAnimation
{
    [self.adView startAnimation];
}

- (void)pauseAnimation
{
    [self.adView pauseAnimation];
}

#pragma mark -- actions
- (void)gotoClassitition:(UIButton *)sender
{
    [self.delegate homePageTopView:self clickedOtherClassWithTag:sender.tag - 100];
}

#pragma mark -- ADScrollViewDelegate
- (void)adScrollView:(ADScrollView *)adScrollView didClickedWithADModel:(ADModel *)adModel
{
    if ([self.delegate respondsToSelector:@selector(homePageTopView:clickedADPicWithADModel:)]) {
        [self.delegate homePageTopView:self clickedADPicWithADModel:adModel];
    }
}

#pragma mark -- ADViewDelegate
- (void)ADView:(ADView *)adView didSelectedADWithModel:(ADModel *)model
{
    if ([self.delegate respondsToSelector:@selector(homePageTopView:clickedRollADWithADModel:)]) {
        [self.delegate homePageTopView:self clickedRollADWithADModel:model];
    }
}




@end
