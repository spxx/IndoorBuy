//
//  GoodsParameterView.h
//  BMW
//
//  Created by 白琴 on 16/3/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodParameterViewDelegate <NSObject>

@optional
-(void)endRefreshing;

@end
@interface GoodsParameterView : UIView
@property(nonatomic,copy)NSString * textPicUrl;
@property(nonatomic,copy)NSArray * paramArr;
@property(nonatomic,copy)NSString * serviceUrl;
@property(nonatomic,assign)id<GoodParameterViewDelegate> delegate;
@end
