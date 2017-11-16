//
//  NotFoundView.h
//  BMW
//
//  Created by gukai on 16/3/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotFoundView : UIView
@property(nonatomic,strong)UIImageView * imageV;
@property(nonatomic,strong)UILabel * sorryLabel;

-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title;
/**
 * 改变某些字段的颜色
 */
-(void)changeStringColorWithRange:(NSRange)range;
@end
