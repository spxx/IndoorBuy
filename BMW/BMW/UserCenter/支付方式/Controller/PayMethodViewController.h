//
//  PayMethodViewController.h
//  BMW
//
//  Created by LiuP on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BaseVC.h"

@interface PayMethodViewController : BaseVC
@property (nonatomic, copy) NSString * personCash;     /**< 账户可用余额 */
@property (nonatomic, copy) NSString * orderID;        /**< 订单ID */
@property (nonatomic, copy) NSString * totalCash;     /**< 支付总金额 */
@property (nonatomic, copy) NSString * orderTime;     /**< 下单时间 */
@property (nonatomic, copy) NSString * orderNum;      /**< 订单编号 */
@property (nonatomic, copy) NSString * orderPaySn;    /**< 支付使用 */

@property (nonatomic, assign) BOOL isPopRoot;       /**< 是否跳转到root，购物车跳转到root */
@property (nonatomic, assign) BOOL isAPay;          /**< 海外商品，只能使用通联支付 */

@end
