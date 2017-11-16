//
//  ClassifyMenu.h
//  BMW
//
//  Created by gukai on 16/3/4.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassifyCollectionCell.h"

@class ClassifyMenu;

@protocol ClassifyMenuDelegate <NSObject>

@optional

/**
 选择了展开的分类

 @param classifyMenu
 @param model 
 */
- (void)classifyMenu:(ClassifyMenu *)classifyMenu didSelectedClassWithModel:(ClassModel *)model;

@end

@interface ClassifyMenu : UIView

@property(nonatomic,strong)id<ClassifyMenuDelegate> delegate;

@property (nonatomic, strong) NSMutableArray * classModels;


-(void)showClassifyMenu;

-(void)hideClassifyMenu;

@end
