//
//  AccountModel.h
//  BMW
//
//  Created by LiuP on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AccountModel;

typedef void(^Complete)(BOOL isSuccess, AccountModel * model, NSString * message);

@interface AccountModel : NSObject
/**********M币************/
@property (nonatomic, copy) NSString * mCash;
@property (nonatomic, copy) NSString * freezeM;


/**
 获取M币账户
 
 @param complete
 */
+ (void)requestForMCashWithUserID:(NSString *)userID Complete:(void(^)(BOOL isSuccess, AccountModel * model, NSString * message))complete;
@end
