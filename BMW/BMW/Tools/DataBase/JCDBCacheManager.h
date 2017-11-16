//
//  JCDBCache.h
//  AutoGang
//
//  Created by ian luo on 15/3/2.
//  Copyright (c) 2015年 com.qcb008.QiCheApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCDBCacheManager : NSObject

+ (JCDBCacheManager *)cacheForClass:(Class)clazz;

- (BOOL)deleteWithCondition:(NSString *)condition;
- (BOOL)insert:(NSArray *)objs;
- (NSArray *)query;
- (NSArray *)queryWithCondition:(NSString *)condition;
- (NSArray *)queryWithOrder:(NSString *)orderby;
- (NSArray *)queryWithCondition:(NSString *)condition orderBy:(NSString *)order;
- (BOOL)update:(NSArray *)objs withConditions:(NSArray *)conditions;

#pragma mark test private api
- (NSArray *)propertiesForClass:(Class)classObj level:(NSUInteger)level;

@end
