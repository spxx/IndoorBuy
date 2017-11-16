//
//  InvitationModel.h
//  BMW
//
//  Created by rr on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvitationModel : NSObject

+(void)requestImage:(void(^)(BOOL,NSDictionary *,NSString *))finish;

@end
