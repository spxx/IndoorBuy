//
//  ClassTitleView.h
//  BMW
//
//  Created by LiuP on 2016/12/8.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassTitleView;

typedef enum{
    ClassStatusClass,
    ClassStatusBrand,
}ClassStatus;

@protocol ClassTitleViewDelegate <NSObject>

@optional

/**
 选择按钮

 @param classTitleView
 @param status
 */
- (void)classTitleView:(ClassTitleView *)classTitleView didSelectedBtnWithStatus:(ClassStatus)status;

@end

@interface ClassTitleView : UIView

@property (nonatomic, assign) id<ClassTitleViewDelegate> delegate;

/**
 交换按钮状态移动线条
 */
- (void)exchangeBtnStatus:(ClassStatus)status;
@end
