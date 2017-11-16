//
//  BargainMenu.h
//  BMW
//
//  Created by gukai on 16/3/5.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BargainMenuDelegate <NSObject>

@optional
-(void)bargainMenuClickMuneButton:(UIButton *)sender;
@end

@interface BargainMenu : UIView
@property(nonatomic,copy)NSArray * menuData;
@property(nonatomic,assign)id<BargainMenuDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame muneData:(NSArray *)muneData;
@end
