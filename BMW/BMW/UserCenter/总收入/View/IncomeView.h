//
//  IncomeView.h
//  BMW
//
//  Created by LiuP on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IncomeModel.h"

@protocol IncomeViewDelegate <NSObject>

@optional

@end

@interface IncomeView : UIView

@property (nonatomic, assign) id<IncomeViewDelegate> delegate;

@property (nonatomic, retain) IncomeModel * model;

/**
 初始化

 @param frame
 @param member
 @return
 */
- (instancetype)initWithFrame:(CGRect)frame member:(MemberType)member;
@end
