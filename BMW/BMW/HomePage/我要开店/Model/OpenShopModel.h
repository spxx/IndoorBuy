//
//  OpenShopModel.h
//  BMW
//
//  Created by rr on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenShopModel : NSObject

@property(nonatomic, strong) NSString *backImageV;
@property(nonatomic, strong) NSString *price;
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, assign) BOOL recommend;

+(void)requestImageandPrice:(void(^)(BOOL,OpenShopModel *,NSString *))finish;


@end
