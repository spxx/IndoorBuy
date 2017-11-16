//
//  BankCardModel.h
//  DP
//
//  Created by LiuP on 16/7/18.
//  Copyright © 2016年 sp. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BankCardModel;

typedef void(^Complete)(NSMutableArray * models, NSString * message, NSInteger code);

@interface BankCardModel : NSObject

@property (nonatomic, copy) NSString * bank;                /**< 银行名字 */
@property (nonatomic, copy) NSString * bankCardNum;         /**< 银行卡号 显示后4位 */
@property (nonatomic, copy) NSString * bankCardOriginNum;   /**< 完整的银行卡号 */
@property (nonatomic, copy) NSString * bankCardID;          /**< 银行卡ID */

/**
 *  获取银行卡列表
 *
 *  @param complete
 */
+ (void)requestForBankCardListWithComplete:(Complete)complete;

/**
 *  删除银行卡
 *
 *  @param complete 
 */
+ (void)deleteBankCardWithModel:(BankCardModel *)model Complete:(Complete)complete;
/**
 *  绑定银行卡
 *
 *  @param name
 *  @param cardNum
 *  @param bankName
 *  @param complete 
 */
+ (void)addBankCardWithName:(NSString *)name
                    cardNum:(NSString *)cardNum
                   bankName:(NSString *)bankName
                   Complete:(Complete)complete;


- (instancetype)initWithDic:(NSDictionary *)dic;

@end
