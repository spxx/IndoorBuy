//
//  SliderButton.h
//  BMW
//
//  Created by 白琴 on 16/3/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SlideButtonDelegate <NSObject>

@optional

- (void)sledeMenu:(UIButton *)button didSelectAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface SliderButton : UIScrollView

@property (nonatomic, assign)id<SlideButtonDelegate> slideButtonDelegate;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
- (void)slideMenuButtonPressed:(UIButton *)sender;

@end
