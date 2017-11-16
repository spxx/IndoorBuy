//
//  VIPChoosePayView.h
//  BMW
//
//  Created by 白琴 on 16/5/9.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIPChoosePayView : UIView

/**
 *index 0:支付宝 1:微信
 */
@property(nonatomic, strong) void(^buttonPress)(NSInteger index);
@property(nonatomic, strong) void(^removeF)(UIView * choosePayView);

@end
