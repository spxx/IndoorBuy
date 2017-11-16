//
//  NSDictionary+HandelNull.m
//  AutoGang
//
//  Created by ian luo on 14/10/23.
//  Copyright (c) 2014年 com.qcb008.QiCheApp. All rights reserved.
//

#import "NSDictionary+HandelNull.h"

@implementation NSDictionary(HandelNsNull)

- (id)objectForKeyNotNull:(id)key
{
    id object = [self objectForKey:key];
    if (object == [NSNull null])
        return @"";
    
    if ([object isKindOfClass:[NSNumber class]])
    {
        return [object stringValue];
    }
    
    return object;
}

@end
