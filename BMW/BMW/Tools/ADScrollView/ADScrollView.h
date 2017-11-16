//
//  ADScrollView.h
//  Custom
//
//  Created by LiuP on 16/6/7.
//  Copyright © 2016年 LiuP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADModel.h"
@class ADScrollView;

@protocol ADScrollViewDelegate <NSObject>

@optional
- (void)adScrollView:(ADScrollView *)adScrollView didClickedWithADModel:(ADModel *)adModel;

@end

@interface ADScrollView : UIView

@property (nonatomic, assign) id<ADScrollViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray<ADModel *> * adModels; /**< 需要显示的数据*/

@end
