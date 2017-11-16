//
//  SecondView.m
//  BMW
//
//  Created by LiuP on 2016/12/6.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "SecondView.h"
#import "LPTableViewManager.h"
#import "SliderMenu.h"
#import "IndicatorView.h"


@interface SecondView ()<UITableViewDelegate, SliderMenuDelegate>
@property (nonatomic, strong) SliderMenu * sliderMenu;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, retain) LPTableViewManager * manager;
@property (nonatomic, strong) IndicatorView * indicator;
@end

@implementation SecondView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface
{
    _sliderMenu = [[SliderMenu alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 38)];
    _sliderMenu.delegate = self;
    [self addSubview:_sliderMenu];
    
    NSString * cellID = NSStringFromClass(BrandCell.class);
    _manager = [[LPTableViewManager alloc]initWithIdentifier:cellID cellBack:^(id cell, id model) {
        BrandCell * item = cell;
        item.model = model;
    }];
    _manager.type = CellTypeSection;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _sliderMenu.viewBottomEdge, self.viewWidth, self.viewHeight - _sliderMenu.viewHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = _manager;
    _tableView.rowHeight = 32;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = [UIColor blackColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:_tableView];
    
    [_tableView registerClass:[BrandCell class] forCellReuseIdentifier:cellID];
}
#pragma mark -- getter
- (IndicatorView *)indicator
{
    if (!_indicator) {
        _indicator = [[IndicatorView alloc] initWithFrame:self.tableView.bounds];
        [self.tableView addSubview:_indicator];
    }
    return _indicator;
}
#pragma mark -- setter
- (void)setClassModels:(NSMutableArray *)classModels
{
    _classModels = classModels;
    self.sliderMenu.classModels = classModels;
}
- (void)setModels:(NSMutableArray *)models
{
    _models = models;
    _manager.indexs = self.indexs;
    _manager.models = models;
    [self.tableView reloadData];
}

- (void)setIndexs:(NSMutableArray *)indexs
{
    _indexs = indexs;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(secondView:didSelectedBrandWithModel:)]) {
        [self.delegate secondView:self didSelectedBrandWithModel:self.models[indexPath.section][indexPath.row]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

#pragma mark -- SliderMenuDelegate
- (void)sliderMenu:(SliderMenu *)sliderMenu didSelectedClassWithModel:(ClassModel *)model
{
    if ([self.delegate respondsToSelector:@selector(secondView:didSelectedClassWithModel:)]) {
        [self.delegate secondView:self didSelectedClassWithModel:model];
    }
}

- (void)sliderMenu:(SliderMenu *)sliderMenu didSelectedDownBtnWithBtn:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(secondView:didSelectedDownBtn:)]) {
        [self.delegate secondView:self didSelectedDownBtn:btn];
    }
}
#pragma mark -- other
- (void)reloadBrandClassMenu
{
    [self.sliderMenu reloadBrandClass];
}

- (void)indicatorShow:(BOOL)show
{
    if (show) {
        [self.indicator.indicator startAnimating];
    }else {
        [self.indicator.indicator stopAnimating];
        [self.indicator removeFromSuperview];
        _indicator = nil;
    }
}
@end
