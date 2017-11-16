//
//  GoodsInfoView.h
//  BMW
//
//  Created by gukai on 16/3/8.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsInfoViewDelegate <NSObject>

@optional
-(void)GoodsInfoViewClickButton:(CGFloat)height;

@end



@interface GoodsInfoView : UIView

@property(nonatomic,strong)NSString * imageUrl;
@property(nonatomic,copy)NSString * goodsIntro;
@property(nonatomic,copy)NSString * expressday;

@property(nonatomic,assign)id<GoodsInfoViewDelegate> delegate;


@end
