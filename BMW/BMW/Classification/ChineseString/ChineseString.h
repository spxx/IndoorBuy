//
//  ChineseString.h
//  成长轨迹
//
//  Created by gukai on 15/9/28.
//  Copyright (c) 2015年 Leo Tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pinyin.h"

@interface ChineseString : NSObject
@property(retain,nonatomic)NSString *string;
@property(retain,nonatomic)NSString *pinYin;

//-----  返回tableview右方indexArray
+(NSMutableArray*)IndexArray:(NSArray*)stringArr;

//-----  返回联系人
+(NSMutableArray*)LetterSortArray:(NSArray*)stringArr;
@end
