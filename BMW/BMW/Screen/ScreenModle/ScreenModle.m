//
//  ScreenModle.m
//  BMW
//
//  Created by gukai on 16/3/2.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ScreenModle.h"

@implementation ScreenModle
-(NSMutableArray *)productPlaces
{
    if (!_productPlaces) {
        _productPlaces = [NSMutableArray array];
    }
    return _productPlaces;
}
-(NSMutableArray *)brands
{
    if (!_brands) {
        _brands = [NSMutableArray array];
    }
    return _brands;
}
-(NSMutableArray *)classifies
{
    if (!_classifies) {
        _classifies = [NSMutableArray array];
    }
    return _classifies;
}
-(NSMutableDictionary *)productPlaceDic
{
    if (!_productPlaceDic) {
        _productPlaceDic = [NSMutableDictionary dictionary];
    }
    return _productPlaceDic;
}
-(NSMutableDictionary *)brandDic
{
    if (!_brandDic) {
        _brandDic = [NSMutableDictionary dictionary];
    }
    return _brandDic;
}
-(NSMutableDictionary *)classifyDic
{
    if (!_classifyDic) {
        _classifyDic = [NSMutableDictionary dictionary];
    }
    return _classifyDic;
}
-(NSMutableArray *)priceRangeArr
{
    if (!_priceRangeArr) {
        _priceRangeArr = [NSMutableArray array];
    }
    return _priceRangeArr;
}
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        [_dataSource addObject:@[@{@"name":@"0-100"},@{@"name":@"101-200"},@{@"name":@"201-500"},@{@"name":@"501-800"},@{@"name":@"801-1200"},@{@"name":@"1201-2000"},@{@"name":@"2000以上"}]];
        [_dataSource addObject:@[]];
        [_dataSource addObject:@[]];
        [_dataSource addObject:@[]];
    }
    return _dataSource;
}
-(NSMutableArray *)cellRowCountArr
{
    if (!_cellRowCountArr) {
       _cellRowCountArr = [NSMutableArray arrayWithArray:@[@0,@0,@0,@0]];
    }
    return _cellRowCountArr;
}
@end
