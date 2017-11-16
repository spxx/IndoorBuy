//
//  FirstView.m
//  BMW
//
//  Created by LiuP on 2016/12/6.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "FirstView.h"
#import "LPTableViewManager.h"
#import "IndicatorView.h"


@interface FirstView ()<UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, retain) LPTableViewManager * manager;
@property (nonatomic, strong) ClassCell * selectedCell;

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) IndicatorView * indicator;
@end

@implementation FirstView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initUserInterFace];
    }
    return self;
}

- (void)initUserInterFace
{
    NSString * cellID = NSStringFromClass(ClassCell.class);
    _manager = [[LPTableViewManager alloc]initWithIdentifier:cellID cellBack:^(id cell, id model) {
        ClassCell * item = cell;
        item.model = model;
        if (item.model.selected) {
            self.selectedCell = item;
        }
    }];
    _manager.type = CellTypeDefault;
    
    // 左侧菜单
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, 75 * W_ABCW, self.viewHeight - 10)];
    [_tableView registerClass:[ClassCell class] forCellReuseIdentifier:cellID];
    _tableView.rowHeight = 60;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = _manager;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:_tableView];
    
    // 分割线顶头
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    // 右侧列表
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 14;
    layout.minimumInteritemSpacing = 30 * W_ABCW;
    layout.sectionInset = UIEdgeInsetsMake(7, 0, 15, 0);
    
    NSString * itemID = NSStringFromClass(ClassItemCell.class);
    NSString * headerID = NSStringFromClass(ClassHeaderView.class);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_tableView.viewRightEdge + 10, 10, self.viewWidth - _tableView.viewWidth - 20, self.viewHeight - 10) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    [_collectionView registerClass:[ClassItemCell class]
        forCellWithReuseIdentifier:itemID];
    [_collectionView registerClass:[ClassHeaderView class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:headerID];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self addSubview:_collectionView];
}

#pragma mark -- getter

- (IndicatorView *)indicator
{
    if (!_indicator) {
        _indicator = [[IndicatorView alloc] initWithFrame:self.collectionView.bounds];
        [self.collectionView addSubview:_indicator];
    }
    return _indicator;
}

#pragma mark -- setter
// 左侧数据
- (void)setClassModels:(NSMutableArray *)classModels
{
    _classModels = classModels;
    
    if (!self.tableView.tableHeaderView) {
        UIView * line = [UIView new];
        line.viewSize = CGSizeMake(_tableView.viewWidth, 0.5);
        line.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
        self.tableView.tableHeaderView = line;
    }
    _manager.models = classModels;
    
    [self.tableView reloadData];
}

// 右侧数据
- (void)setItemModels:(NSMutableArray *)itemModels
{
    _itemModels = itemModels;
    [self.collectionView reloadData];
}

- (void)setBannerModel:(ClassModel *)bannerModel
{
    _bannerModel = bannerModel;
    [self.collectionView reloadData];
}

#pragma mark -- other
- (void)itemIndicatorShow:(BOOL)show
{
    if (show) {
        [self.indicator.indicator startAnimating];
    }else {
        [self.indicator.indicator stopAnimating];
        [self.indicator removeFromSuperview];
        _indicator = nil;
    }
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCell.model.selected = NO;
    ClassModel * classModel = self.classModels[indexPath.row];
    classModel.selected = YES;
    [tableView reloadData];
    if ([self.delegate respondsToSelector:@selector(firstView:didSelectedFirstClass:)]) {
        [self.delegate firstView:self didSelectedFirstClass:classModel];
    }
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassModel * sectionModel = self.itemModels[indexPath.section];
    ClassModel * thirdModel = sectionModel.thirdModels[indexPath.item];
    if ([self.delegate respondsToSelector:@selector(firstView:didSelectedThirdClass:)]) {
        [self.delegate firstView:self didSelectedThirdClass:thirdModel];
    }
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.itemModels.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    ClassModel * sectionModel = self.itemModels[section];
    return sectionModel.thirdModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(ClassItemCell.class)
                                                                     forIndexPath:indexPath];
    ClassModel * sectionModel = self.itemModels[indexPath.section];
    cell.model = sectionModel.thirdModels[indexPath.item];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ClassHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                      withReuseIdentifier:NSStringFromClass(ClassHeaderView.class)
                                                                             forIndexPath:indexPath];
    ClassModel * sectionModel = self.itemModels[indexPath.section];
    headerView.model = sectionModel;
    headerView.bannerModel = nil;
    if (indexPath.section == 0) {
        headerView.bannerModel = self.bannerModel;
    }
    WEAK_SELF;
    headerView.allAction = ^(ClassModel * model) {
        if ([weakSelf.delegate respondsToSelector:@selector(firstView:didSelectedSecondClass:)]) {
            [weakSelf.delegate firstView:self didSelectedSecondClass:model];
        }
    };
    headerView.bannerAction = ^(ClassModel * bannerModel) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(firstView:didSelectedBanner:)]) {
            [weakSelf.delegate firstView:self didSelectedBanner:bannerModel];
        }
    };
    return headerView;
}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassModel * sectionModel = self.itemModels[indexPath.section];
    ClassModel * itemModel = sectionModel.thirdModels[indexPath.item];
    return CGSizeMake(55 * W_ABCW, 62 * W_ABCW + 10 * W_ABCW * itemModel.lines);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0 && self.bannerModel) {
        return CGSizeMake(self.viewWidth - _tableView.viewWidth, 30 + 85 * W_ABCW);
    }else {
        return CGSizeMake(self.viewWidth - _tableView.viewWidth, 30);
    }
}
@end
