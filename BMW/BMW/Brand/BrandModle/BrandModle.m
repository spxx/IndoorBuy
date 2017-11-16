//
//  BrandModle.m
//  BMW
//
//  Created by gukai on 16/2/24.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "BrandModle.h"

@implementation BrandModle
-(id)initWithJsonObject:(NSDictionary *)jsonObject;
{
    self = [super init];
    if (self) {
        self.brand_id = [jsonObject objectForKeyNotNull:@"brand_id"];
        self.brand_name = [jsonObject objectForKeyNotNull:@"brand_name"];
        self.brand_class = [jsonObject objectForKeyNotNull:@"brand_class"];
        self.class_id = [jsonObject objectForKeyNotNull:@"class_id"];
        self.brand_pic = [jsonObject objectForKeyNotNull:@"brand_pic"];
    }
    return self;
}
//-(NSString *)description
//{
//    return [NSString stringWithFormat:@"brand_id = %@,\nbrand_name = %@,\nbrand_class = %@,\nclass_id = %@,\nbrand_pic = %@",self.brand_id,self.brand_name,self.brand_class,self.class_id,self.brand_pic];
//}
@end
