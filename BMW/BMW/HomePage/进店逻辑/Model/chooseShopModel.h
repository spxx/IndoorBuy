//
//  chooseShopModel.h
//  BMW
//
//  Created by rr on 2016/12/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chooseShopModel : NSObject

@property(nonatomic, strong) NSString *backImageV;
@property(nonatomic, strong) NSString *title;


+(void)requestImageandPrice:(void(^)(BOOL,chooseShopModel*,NSString *))finish;

+(void)OpenStoreCheck:(NSString *)phone complete:(void (^)(BOOL,NSDictionary *,NSString *))complete;

+(void)BindingStoreWithPhone:(NSString *)phone andFinish:(void(^)(BOOL,NSString *))finish;

@end
