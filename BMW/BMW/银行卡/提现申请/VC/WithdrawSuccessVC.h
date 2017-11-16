//
//  WithdrawSuccessVC.h
//  BMW
//
//  Created by LiuP on 2016/12/23.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BaseVC.h"

@protocol WithdrawSuccessDelegate <NSObject>

@optional
- (void)withdrawSuccessFinshedAction;
- (void)withdrawSuccessHomePageAction;

@end

@interface WithdrawSuccessVC : BaseVC

@property (nonatomic, assign) id<WithdrawSuccessDelegate> delegate;

@end
