//
//  SliderMune.m
//  BMW
//
//  Created by gukai on 16/3/3.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "SliderMenu.h"


@interface SliderMenu ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) SliderCell * selectedCell;
@property (nonatomic, strong) UIButton * downListBtn;

@property (nonatomic, strong) UIImageView * arrow;
@end
@implementation SliderMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        
        [self initUserInterface];

    }
    return self;
}

-(void)initUserInterface
{
    UICollectionViewFlowLayout *  flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
   
    NSString * cellID = NSStringFromClass(SliderCell.class);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth - 40, self.viewHeight)
                                        collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[SliderCell class] forCellWithReuseIdentifier:cellID];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self addSubview:_collectionView];
    
    // 右侧下拉按钮
    _downListBtn = [[UIButton alloc]initWithFrame:CGRectMake(_collectionView.viewRightEdge, _collectionView.viewY, 40, self.viewHeight)];
    _downListBtn.backgroundColor = [UIColor whiteColor];
    [_downListBtn addTarget:self action:@selector(downListAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_downListBtn];
    
    _arrow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 6)];
    _arrow.image = [UIImage imageNamed:@"icon_xialajiantou_js.png"];
    _arrow.userInteractionEnabled = YES;
    _arrow.center = CGPointMake(_downListBtn.viewWidth / 2, _downListBtn.viewHeight / 2);
    [_downListBtn addSubview:_arrow];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, self.viewHeight - 0.5, self.viewWidth , 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xdedede];
    [self addSubview:line];
}

#pragma mark -- setter
- (void)setClassModels:(NSMutableArray *)classModels
{
    _classModels = classModels;
    [self.collectionView reloadData];
}

#pragma mark -- Action --
-(void)downListAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(sliderMenu:didSelectedDownBtnWithBtn:)]) {
        [self.delegate sliderMenu:self didSelectedDownBtnWithBtn:sender];
    }
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
    NSString * cellID = NSStringFromClass(SliderCell.class);
    SliderCell * cell =  [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    ClassModel * classModel = self.classModels[indexPath.item];
    cell.model = classModel;
    if (classModel.selected) {
        self.selectedCell = cell;
        [collectionView scrollToItemAtIndexPath:indexPath
                               atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                       animated:YES];
    }
    return cell;
}

#pragma mark -- UICollectioViewDelegate --
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel * label = [[UILabel alloc]init];
    ClassModel * model = self.classModels[indexPath.item];
    label.text = model.gcName;
    [label sizeToFit];
    return CGSizeMake(label.bounds.size.width, 36);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCell.model.selected = NO;
    ClassModel * classModel = self.classModels[indexPath.item];
    classModel.selected = YES;
    [collectionView reloadData];
    if ([self.delegate respondsToSelector:@selector(sliderMenu:didSelectedClassWithModel:)]) {
        [self.delegate sliderMenu:self didSelectedClassWithModel:classModel];
    }
}

#pragma mark -- other
- (void)reloadBrandClass
{
    NSInteger selectedIndex = 0;
    for (ClassModel * model in self.classModels) {
        if (model.selected) {
            selectedIndex = [self.classModels indexOfObject:model];
            break;
        }
    }
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:selectedIndex inSection:0];
    self.selectedCell = (SliderCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:YES];
    [self.collectionView reloadData];
}


@end
