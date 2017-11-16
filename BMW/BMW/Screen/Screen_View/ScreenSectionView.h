//
//  ScreenSectionView.h
//  BMW
//
//  Created by gukai on 16/3/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScreenSectionDelegate <NSObject>

@optional
-(void)ScreenSectionClickButton:(UIButton *)sender;
@end
@interface ScreenSectionView : UIView
@property(nonatomic,strong)UIView * bottomLine;
@property(nonatomic,strong)UILabel * textLabel;
@property(nonatomic,strong)UIImageView * arrows;
@property(nonatomic,strong)UILabel * detailLabel;
@property(nonatomic,strong)UIButton * button;
@property(nonatomic,assign)id<ScreenSectionDelegate> delegate;
-(void)arrowRotationDownAnimation;
-(void)arrowRotationUpAnimation;
-(void)arrowDownState;
-(void)arrowUpState;
@end
