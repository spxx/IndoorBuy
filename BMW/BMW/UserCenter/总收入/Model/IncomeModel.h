//
//  IncomeModel.h
//  BMW
//
//  Created by LiuP on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    MemberNone,       /**< 普通用户 */
    MemberMK,         /**< 麦咖 */
    MemberService,    /**< 服务商 */
    MemberPartner,    /**< 合伙人 */
}MemberType;

@interface IncomeModel : NSObject
@property (nonatomic, strong) NSArray * percents;       /**< 各项收入所占百分比 */
@property (nonatomic, strong) NSArray * allIncomes;     /**< 所有收入的金额 */
@property (nonatomic, strong) NSArray * totalIncomes;   /**< 所有统计的金额 红色部分 */
@property (nonatomic, copy) NSString * needNum;         /**< 还差多少人升级 */
@property (nonatomic, copy) NSString * award;           /**< 邀请奖励金额 */
@property (nonatomic, assign) CGFloat totalIncome;      /**< 总共收入 */

/**
 获取收入相关信息

 @param complete 
 */
+ (void)requestForIncomeWithMember:(MemberType)member
                          Complete:(void(^)(BOOL isSuccess, IncomeModel * model, NSString * message))complete;
@end
