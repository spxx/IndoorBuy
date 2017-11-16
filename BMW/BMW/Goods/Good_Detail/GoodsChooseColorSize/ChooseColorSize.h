//
//  ChooseColorSize.h
//  BMW
//
//  Created by gukai on 16/3/11.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseColorSizeDelegate <NSObject>

@optional
-(void)ChooseColorSizeClickTheBtn;

@end
@interface ChooseColorSize : UIView
/**
 * 前面的文字
 */
@property(nonatomic,copy)NSString * text;
@property(nonatomic,assign)id<ChooseColorSizeDelegate> delegate;
@end
