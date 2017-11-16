//
//  GoodsAddCarView.h
//  BMW
//
//  Created by 白琴 on 16/3/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsAddCarView : UIView

@property(nonatomic, strong)NSString *catID;
@property(nonatomic, assign)BOOL fixShopCar;
/**
 *  点击了立即购买
 */
@property (nonatomic, copy)void(^clickedBuy)(NSString * goodsId, NSString * num);
/**
 *  点击了加入购物车
 */
@property (nonatomic, copy)void(^clickedAddCar)(NSString * goodsId, NSString * num);
/**
 *
 */
@property (nonatomic, copy)void(^changeCar)(NSString*carID, NSString * goodsId, NSString * num);




/**
 *  购物车规格界面初始化
 *
 *  @param frame               位置大小
 *  @param goodsId             商品ID
 *  @param goodsCommonid       商品commonid
 *  @param goodsPrice          商品价格
 *  @param goodsStorage        商品库存
 *  @param goodsSpecDic        商品当前规格字典
 *  @param specNameDic         商品所有规格的名称
 *  @param specValueDic        商品所有规格所对应的值
 *  @param specListMobileDic   商品规格值对应字典
 *  @param goodsDetailOrAddCar 一个按钮还是2个按钮 1个：addCar  2个:goodsDetail
 */
- (instancetype)initWithFrame:(CGRect)frame GoodsId:(NSString *)goodsId goodsCommonid:(NSString *)goodsCommonid goodsPrice:(NSString *)goodsPrice goodsStorage:(NSString *)goodsStorage goodsSpec:(NSDictionary *)goodsSpecDic specName:(NSDictionary *)specNameDic specValue:(NSDictionary *)specValueDic specListMobile:(NSDictionary *)specListMobileDic GoodsDetailOrAddCar:(NSString *)goodsDetailOrAddCar;




@end
