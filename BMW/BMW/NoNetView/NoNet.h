//
//  NoNet.h
//  BMW
//
//  Created by gukai on 16/3/22.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NoNetDefault,
}NoNetType;


@protocol NoNetDelegate <NSObject>

@optional
-(void)NoNetDidClickRelaod:(UIButton *)sender;

@end
@interface NoNet : UIView
@property(nonatomic,assign)NoNetType noNetType;
@property(nonatomic,assign)id<NoNetDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame type:(NoNetType)type;
-(instancetype)initWithFrame:(CGRect)frame type:(NoNetType)type delegate:(id)delegate;
@end
