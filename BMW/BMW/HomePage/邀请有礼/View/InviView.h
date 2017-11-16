//
//  InviView.h
//  BMW
//
//  Created by rr on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InviViewDelegate <NSObject>

-(void)InviTion;

@end

@interface InviView : UIView

@property(nonatomic, assign)id <InviViewDelegate> delegate;

-(void)updateImageV:(NSString *)url;

@end
