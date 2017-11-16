//
//  shareView.h
//  BMW
//
//  Created by rr on 16/3/8.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShareView;

typedef enum {
    ShareNone,
    ShareWXSession,     /**< 微信 */
    ShareWXFriend,      /**< 微信朋友圈 */
    ShareSina,          /**< 新浪微博 */
    ShareQQ,            /**< QQ好友 */
    ShareQQZone,        /**< QQ空间 */
    ShareCreatCode,     /**< 生成二维码 */
}Share3RDParty;

@protocol ShareVeiwDelegate <NSObject>

@optional

/**
 点击了第三方品台

 @param shareView
 @param destination
 */
- (void)shareView:(ShareView *)shareView chooseItemWithDestination:(Share3RDParty)destination;
@end
@interface ShareView : UIView

@property(nonatomic,assign)id<ShareVeiwDelegate> delegate;

/**
 初始化

 @param title 红色部分的title
 @param QRCode 是否有生成二维码
 @return 
 */
-(instancetype)initWithTitle:(NSString *)title QRCode:(BOOL)QRCode;
@end
