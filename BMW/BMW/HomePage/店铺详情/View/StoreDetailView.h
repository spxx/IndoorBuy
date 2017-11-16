//
//  StoreDetailView.h
//  BMW
//
//  Created by LiuP on 2016/12/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreModel.h"
@class StoreDetailView;

typedef enum{
    StoreBMW,       /**< 帮麦店 */
    StorePerson,    /**< 个人店 */
}StoreType;

@protocol StoreViewDelegate <NSObject>

@optional

/**
 帮麦店长按信息

 @param storeView
 @param info
 */
- (void)storeView:(StoreDetailView *)storeView longPressInfo:(NSString *)info;

/**
 单击客服热线

 @param storeView
 @param phone
 */
- (void)storeView:(StoreDetailView *)storeView tapServicePhone:(NSString *)phone;

/**
 长按二维码

 @param storeView
 @param QRImage 
 */
- (void)storeView:(StoreDetailView *)storeView longPressQRImage:(UIImageView *)QRImage;
@end

@interface StoreDetailView : UIView

@property (nonatomic, retain) StoreModel * model;
@property (nonatomic, assign) id<StoreViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame storeType:(StoreType)storeType;

@end
