//
//  MystoreModel.h
//  BMW
//
//  Created by rr on 2016/12/22.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MystoreModel : NSObject

@property(nonatomic, strong) NSString *store_name; /**< 店铺名字 */

@property(nonatomic, strong) NSString *desc; /**< 店铺描述 */

@property(nonatomic, strong) NSString *store_qq; /**<  qq*/

@property(nonatomic, strong) NSString *store_wx; /**<  wx*/

@property(nonatomic, strong) NSString *store_tel; /**<  电话*/

@property(nonatomic, strong) NSString *member_avatar; /**<  店铺头像*/

+(void)requestMystoreInfoComplete:(void(^)(BOOL successs,MystoreModel * model,NSString * message))complete;

@end
