//
//  LPTableVIewManager.m
//  Custom
//
//  Created by LiuP on 16/9/8.
//  Copyright © 2016年 LiuP. All rights reserved.
//

#import "LPTableViewManager.h"


@interface LPTableViewManager ()

@property (nonatomic, assign) NSInteger sections;       /**< section 数 */
@property (nonatomic, assign) NSInteger rows;           /**< row 数 */

@property (nonatomic, copy) CellCallBack callBack;
@end

@implementation LPTableViewManager

- (instancetype)initWithIdentifier:(NSString *)identifier
                          cellBack:(CellCallBack)cellBack
{
    self = [super init];
    if (self) {
        _sections   = 1;
        _identifier = identifier;
        _callBack   = cellBack;
    }
    return self;
}

#pragma mark -- setter
// 设置当前tableview的类型
- (void)setType:(CellType)type
{
    _type = type;
}

// 设置tableview的数据源
- (void)setModels:(NSArray *)models
{
    _models = models;
    if (self.type == CellTypeDefault) {
        self.sections = 1;
        self.rows = models.count;
    }else {
        self.sections = models.count;
    }
}

// 设置tableView右侧的索引字母
- (void)setIndexs:(NSArray *)indexs
{
    _indexs = [NSArray arrayWithArray:indexs];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == CellTypeDefault) {
        return self.rows;
    }else {
        NSArray * sections = self.models[section];
        return sections.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:self.identifier];
    if (cell == nil) {
        cell = [[NSClassFromString(self.identifier) alloc] initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:self.identifier];
    }
    id model;
    if (self.type == CellTypeDefault) {
        model = self.models[indexPath.row];
    }else {
        NSArray * sections = self.models[indexPath.section];
        model = sections[indexPath.row];
    }
    self.callBack(cell, model);
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_indexs && _indexs.count > 0) {
        return _indexs[section];
    }
    return nil;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (_indexs && _indexs.count > 0) {
        return _indexs;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                     atScrollPosition:UITableViewScrollPositionTop
                             animated:YES];
    [MBProgressHUD show:title toView:tableView.superview];
    return index;
}
@end
