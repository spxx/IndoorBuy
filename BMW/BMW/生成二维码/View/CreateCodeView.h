//
//  CreateCodeView.h
//  DP
//
//  Created by LiuP on 16/7/28.
//  Copyright © 2016年 sp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CodeModel.h"
@class CreateCodeView;

@protocol CreateCodeViewDelegate <NSObject>

@optional
- (void)codeView:(CreateCodeView *)codeView longPressedWithCodeImage:(UIImage *)codeImage;

@end

@interface CreateCodeView : UIView

@property (nonatomic, strong) UIImage * QRImage;

@property (nonatomic, copy) NSString * titleStr;

@property (nonatomic, assign) id<CreateCodeViewDelegate> delegate;

@property (nonatomic, copy) NSString * imageUrl;

@end
