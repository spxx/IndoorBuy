//
//  JCUserContext.h
//  WorkByOther
//
//  Created by rr on 15/6/13.
//  Copyright (c) 2015年 wy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Userentity.h"


@interface JCUserContext : NSObject

@property(nonatomic,strong)Userentity *currentUserInfo;

/**
 *  用于验证码倒计时的记录
 */
@property (nonatomic, strong)NSString * pushKey;        //pushKey
@property (nonatomic, assign)NSInteger registCount;     //注册倒计时
@property (nonatomic, strong)NSString * registPhone;    //注册手机号
@property (nonatomic, strong)NSTimer * registTimer;     //注册的timer

@property (nonatomic, assign)NSInteger otherCount;     //其他倒计时
@property (nonatomic, strong)NSString * otherPhone;    //其他手机号
@property (nonatomic, strong)NSTimer * otherTimer;     //其他的timer

@property (nonatomic, assign)NSInteger payPasswordCount;     //交易密码倒计时
@property (nonatomic, strong)NSTimer * payPasswordTimer;     //交易密码的timer




+ (JCUserContext*)sharedManager;

- (void)initUserState;

- (BOOL)isUserLogedIn;

- (void)removeCurrentUser;

- (void)updateUserInfo:(Userentity *)userInfo;

- (void)clearSavedUserInfo;

- (NSString *)titleBouns;

- (void)titleSize:(NSString *)size;
/**
 *  修改某一个字段值
 *
 *  @param object 值
 *  @param key    key
 */
- (void)upDateObject:(id)object forKey:(id)key;

@end
