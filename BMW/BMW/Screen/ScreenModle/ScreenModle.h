//
//  ScreenModle.h
//  BMW
//
//  Created by gukai on 16/3/2.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "MTLModel.h"

@interface ScreenModle : MTLModel
/**
 * 筛选： 记录选择价格区间
 */
@property(nonatomic,copy)NSString * priceRange;
@property(nonatomic,copy)NSMutableArray * priceRangeArr;;

/**
 * 筛选：记录选择产品产地
 */
@property(nonatomic,copy)NSMutableArray * productPlaces;
@property(nonatomic,copy)NSMutableDictionary * productPlaceDic;
/**
 * 筛选：记录选择品牌
 */
@property(nonatomic,copy)NSMutableArray * brands;
@property(nonatomic,copy)NSMutableDictionary * brandDic;
/**
 * 筛选：记录选择品类
 */
@property(nonatomic,copy)NSMutableArray * classifies;
@property(nonatomic,copy)NSMutableDictionary * classifyDic;

/**
 * 记录筛选cell 的高度
 */
@property(nonatomic,copy)NSMutableArray * cellRowCountArr;
/**
 * 筛选的数据源
 */
@property(nonatomic,copy)NSMutableArray * dataSource;

@property(nonatomic,assign)BOOL spreadPrice;
@property(nonatomic,assign)BOOL spreadPlace;
@property(nonatomic,assign)BOOL spreadBrand;
@property(nonatomic,assign)BOOL spreadClass;
@end
