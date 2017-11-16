//
//  PercentView.h
//  BMW
//
//  Created by LiuP on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PercentView : UIView

@property (nonatomic, copy) NSArray * dataSource;         /**< 存放百分比，和为1 */

@property (nonatomic, copy) NSMutableArray * colors;      /**< 对应的颜色 */


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;
@end
