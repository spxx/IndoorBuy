//
//  homePageModel.m
//  BMW
//
//  Created by rr on 16/3/4.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "homePageModel.h"

@implementation homePageModel
-(id)initWithJsonObject:(NSDictionary *)jsonObject{
    if (self = [super init]) {
        self.gc_id = [jsonObject objectForKeyNotNull:@"gc_id"];
        self.gc_name = [jsonObject objectForKeyNotNull:@"gc_name"];
        self.goods_array = [TYTools dataJsonWithDic:[jsonObject objectForKeyNotNull:@"goods"]];
    }
    return self;
}
@end
