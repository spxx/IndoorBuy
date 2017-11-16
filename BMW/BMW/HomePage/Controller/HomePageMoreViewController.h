//
//  HomePageMoreViewController.h
//  BMW
//
//  Created by rr on 16/3/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BaseVC.h"

typedef enum {
    HomePageMoreVCDefault,
    HomePageMoreVCMoreBrand,
    HomePageMoreVCShopCar,
}HomePageMoreVCType;
@interface HomePageMoreViewController : BaseVC

@property(nonatomic,strong) NSDictionary *dataDIc;
@property(nonatomic,copy)NSString * ID;
@property(nonatomic,copy)NSString * brandName;
@property(nonatomic,assign)HomePageMoreVCType homePageMoreVCType;
/**
 * 从品牌传进来 把品牌的一级分类ID 传进来
 */
@property(nonatomic,copy)NSString * brandClassId;

/**
 * 标签选项ID
 */
@property(nonatomic,copy)NSString * goods_platform_only;

//从分类中的 点击三级分类进来的 (判断筛选条件是否显示品类)
@property(nonatomic,assign)BOOL noThirdClass;
@end
