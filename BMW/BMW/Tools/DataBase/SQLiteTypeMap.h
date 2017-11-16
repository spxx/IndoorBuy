//
//  SQLiteTypeMap.h
//  AutoGang
//
//  Created by ian luo on 15/3/2.
//  Copyright (c) 2015年 com.qcb008.QiCheApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface SQLiteTypeMap : NSObject

- (NSDictionary *)objMap;

- (NSString *)mappedTypeForClass:(Class)clazz;

- (NSString *)sqliteTypeForProperty:(objc_property_t)property;

NSString *clazzForProperty(objc_property_t property);

@end
