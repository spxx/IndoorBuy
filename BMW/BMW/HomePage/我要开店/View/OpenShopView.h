//
//  OpenShopView.h
//  BMW
//
//  Created by rr on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenShopModel.h"

@protocol OpenShopDelegate <NSObject>

-(void)NewShop:(OpenShopModel *)openModel;

@end

@interface OpenShopView : UIView


@property(nonatomic,strong) OpenShopModel *model;

@property(nonatomic, assign) id <OpenShopDelegate> delegate;

@property(nonatomic, strong) UIButton *openBtn;

@end
