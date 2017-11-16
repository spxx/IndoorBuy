//
//  ClassHeaderView.h
//  BMW
//
//  Created by LiuP on 2016/12/6.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassModel.h"

typedef void(^BtnAction)(ClassModel * model);

@interface ClassHeaderView : UICollectionReusableView

@property (nonatomic, retain) ClassModel * model;

@property (nonatomic, retain) ClassModel * bannerModel;

@property (nonatomic, copy) BtnAction allAction;       /**< 全部按钮事件 */

@property (nonatomic, copy) BtnAction bannerAction;    /**< banner事件 */
@end
