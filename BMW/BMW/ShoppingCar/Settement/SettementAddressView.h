//
//  SettementGoodsInfoView.h
//  BMW
//
//  Created by 白琴 on 16/3/12.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddressChooseDelegate <NSObject>

- (void)chooseAddressBtn;

@end


@interface SettementAddressView : UIView

@property(nonatomic, weak) id <AddressChooseDelegate> delegate;

@property (nonatomic, strong)NSDictionary * addressDic;

@end
