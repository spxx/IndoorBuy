//
//  FindPasswordViewController.h
//  BMW
//
//  Created by 白琴 on 16/3/2.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BaseVC.h"

@protocol SetPayPasswordDelegate <NSObject>

@optional

/**
 设置交易密码成功后的回调
 */
- (void)setPayPasswordSuccess;

@end

@interface FindPasswordViewController : BaseVC

@property (nonatomic, assign) id<SetPayPasswordDelegate> delegate;

/**
 *  是否为修改或设置支付密码
 */
@property (nonatomic, assign)BOOL isPayPassword;
/**
 *  是否从支付页面进入
 */
@property (nonatomic, assign)BOOL isPayVC;
/**
 *  是否购物车过来的
 */
@property (nonatomic, assign)BOOL isPrsent;


@end
