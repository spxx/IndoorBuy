//
//  RootTabBarVC.h
//  BMW
//
//  Created by rr on 16/2/17.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTabBarVC : UITabBarController

@property(nonatomic, strong)MBProgressHUD *HUD;

- (void)root_goToDetail:(NSDictionary *)info;






@end
