//
//  RemindLoginView.h
//  DP
//
//  Created by LiuP on 15/11/27.
//  Copyright © 2015年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^LoginBlock)();
typedef enum {
    RemindTypeNoUser,
    RemindTypeNoConnection,
    RemindTypeNoOrder,
    RemindTypeNoCollection,
    RemindTypeNoBackCard,
    RemindTypeNoSearch,
    RemindTypeNoCollectionGoods,
    RemindTypeNoCollectionBrand,
}RemindType;

@interface RemindLoginView : UIView

@property (nonatomic, copy)LoginBlock loginBlock;


- (instancetype)initWithFrame:(CGRect)frame type:(RemindType)type;
@end
