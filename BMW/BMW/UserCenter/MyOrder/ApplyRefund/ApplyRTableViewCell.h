//
//  ApplyRTableViewCell.h
//  BMW
//
//  Created by rr on 16/3/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyRTableViewCell : UITableViewCell

@property(nonatomic, strong)UIButton *chooseButton;

@property(nonatomic, strong)NSDictionary *dataDic;

@property(nonatomic, strong)void (^clickButton)(BOOL);
@property(nonatomic, strong)void (^numaddOrduce)(NSString *);
@end
