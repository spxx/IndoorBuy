//
//  HomePageBar.h
//  DP
//
//  Created by LiuP on 16/7/25.
//  Copyright © 2016年 sp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageM.h"

@protocol HomePageBarDelegate <NSObject>

@optional
- (void)homePageBarClickedScanCodeAction;
- (void)homePageBarClickedSearchAction;
- (void)homePageBarClickedMessageAction;
- (void)homePageBarTapTopAction;
- (void)homePageBarClickedShareAction;

@end

@interface HomePageBar : UIView

@property (nonatomic, strong) UIImageView * alphaView;

@property (nonatomic, assign) id<HomePageBarDelegate> delegate;

@property (nonatomic, assign, getter=isShowRedPoint) BOOL showRedPoint;

@property (nonatomic, retain) HomePageM * logoModel;    /**< logo相关 */

@end
