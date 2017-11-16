//
//  GoinV.h
//  BMW
//
//  Created by rr on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoinVdelegate <NSObject>

-(void)gotoShop;

-(void)wantToShop;

@end

@interface GoinV : UIView


@property(nonatomic, assign) id <GoinVdelegate> delegate;

@end
