//
//  ChooseShopView.h
//  BMW
//
//  Created by rr on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseShopVC.h"
#import "chooseShopModel.h"

@protocol ChooseShopViewDelegate <NSObject>

-(void)gotoPay:(NSString *)phone;

-(void)bangmaitiyan;

-(void)ending;

@end


@interface ChooseShopView : UIView

@property(nonatomic, assign) ChoosePorS choosePorS;

@property(nonatomic, strong) chooseShopModel *model;

@property(nonatomic, assign) id <ChooseShopViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame andWithChoose:(ChoosePorS)choose;





@end
