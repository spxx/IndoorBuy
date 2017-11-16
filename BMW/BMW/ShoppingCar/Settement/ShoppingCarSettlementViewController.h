//
//  ShoppingCarSettlementViewController.h
//  BMW
//
//  Created by 白琴 on 16/3/10.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BaseVC.h"

@interface ShoppingCarSettlementViewController : BaseVC

/**
 *  商品总数量
 */
@property (nonatomic, strong)NSString * goodsNumString;
/**
 *  购物车ID  用,分隔     //购物车结算
 */
@property (nonatomic, strong)NSString * cartId;
/**
 *  商品ID        //立即购买
 */
@property (nonatomic, strong)NSString * goodsId;
/**
 *  是否是从购物车进入
 */
@property (nonatomic, assign)BOOL isCar;

/**
 *  是否保税区商品
 */
@property (nonatomic, assign)BOOL isHaveA;

@end
