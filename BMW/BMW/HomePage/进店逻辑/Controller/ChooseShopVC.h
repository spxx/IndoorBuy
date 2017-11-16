//
//  ChooseShopVC.h
//  BMW
//
//  Created by rr on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BaseVC.h"

typedef enum {
    ChoosePreson,/**< 个人中心 */
    ChooseShopping,/**<  我要购物*/
}ChoosePorS;



@interface ChooseShopVC : BaseVC


@property(nonatomic, assign) ChoosePorS choosePorS;

@property(nonatomic, strong) NSString * price; /**< 开店金额 */


@end
