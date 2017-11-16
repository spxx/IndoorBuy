//
//  ClassifyMenu.m
//  BMW
//
//  Created by gukai on 16/3/4.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ClassifyMenu.h"


@interface ClassifyMenu ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView * collectionView;
@property(nonatomic,strong)UIScrollView *  scrollView;
@property(nonatomic,strong)UIView * backgroundView;
@end
@implementation ClassifyMenu

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        [self initUserInterface];
    }
    return self;
}
-(void)initUserInterface
{
    self.backgroundColor = [UIColor clearColor];
    UIView *viewPlace = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 38)];
    viewPlace.backgroundColor = [UIColor whiteColor];
    
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, viewPlace.viewHeight)];
    label.text = @"选择分类";
    label.font = fontForSize(13);
    label.textColor = [UIColor colorWithHex:0x7f7f7f];
    label.textAlignment = NSTextAlignmentLeft;
    [viewPlace addSubview:label];
    
    UIView * backgroundView = [[UIView alloc]initWithFrame:self.bounds];
    backgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:backgroundView];
    self.backgroundView = backgroundView;
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(viewPlace.viewWidth - 40, 0, 40, 38)];
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(closeMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewPlace addSubview:btn];
    [self addSubview:viewPlace];
    
    UIImageView * arrow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 6)];
    arrow.image = [UIImage imageNamed:@"icon_shanglajiantou_js.png"];
    arrow.userInteractionEnabled = YES;
    arrow.center = CGPointMake(btn.viewWidth / 2, btn.viewHeight / 2);
    [btn addSubview:arrow];
    
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, viewPlace.viewHeight - 1, viewPlace.viewWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [viewPlace addSubview:line];

    
    
    UICollectionViewFlowLayout *  flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    CGFloat itemWidth = (SCREEN_WIDTH - 10 * 3 - 15 * 2)/4;
    CGFloat itemHeight = 30;
    flowLayout.itemSize = CGSizeMake(itemWidth,itemHeight);
    flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, viewPlace.viewBottomEdge, self.viewWidth, 0) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[ClassifyCollectionCell class] forCellWithReuseIdentifier:@"ClassifyMenuCell"];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self addSubview:_collectionView];
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [backgroundView addGestureRecognizer:tap];
   
}

#pragma mark -- actions
-(void)tapAction:(UIGestureRecognizer *)sender
{
    [self hideClassifyMenu];
}

#pragma mark -- setter
- (void)setClassModels:(NSMutableArray *)classModels
{
    _classModels = classModels;
    [self.collectionView reloadData];
}

#pragma mark -- Public --
-(void)showClassifyMenu
{
    self.hidden = NO;
    NSInteger count = self.classModels.count / 4;
    NSInteger lines = 0;
    
    //判断要生成几行
    if (count > 0) {
        if (self.classModels.count % 4 > 0) {
            lines = count + 1;
        }
        else{
            lines = count;
        }
    }
    else{
        lines = 1;
    }
    
    //判断collection的高度是否超过了父视图的底部
    CGFloat height =  38 * lines + 15 + _collectionView.viewY;
    if (height > self.viewBottomEdge) {
        height = self.viewHeight - 38;
    }
    else{
        height = 38 * lines + 20;
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.backgroundColor = [UIColor blackColor];
        self.backgroundView.alpha = 0.5;
        _collectionView.frame = CGRectMake(_collectionView.viewX, _collectionView.viewY, _collectionView.viewWidth, height) ;
        
    } completion:^(BOOL finished) {
        
    }];
}
-(void)hideClassifyMenu
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundView.alpha = 1;
        _collectionView.frame = CGRectMake(_collectionView.viewX, _collectionView.viewY, _collectionView.viewWidth, 0) ;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
#pragma mark -- UICollectionViewDataSource --
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.classModels.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ClassifyMenuCell";
    ClassifyCollectionCell * cell =  [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    cell.model = self.classModels[indexPath.item];
    
    return cell;
}
#pragma mark -- UICollectionViewDelegate --
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassModel * model = self.classModels[indexPath.item];
    if ([self.delegate respondsToSelector:@selector(classifyMenu:didSelectedClassWithModel:)]) {
        [self.delegate classifyMenu:self didSelectedClassWithModel:model];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *sectionFooter = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    UIView * view = [[UIView alloc]initWithFrame:CGRectZero];
    [sectionFooter addSubview:view];
    return sectionFooter;
}
#pragma mark -- Action --
-(void)closeMenuAction:(UIButton *)sender
{
    [self hideClassifyMenu];
}
@end
