//
//  UserCollectTableViewCell.h
//  BMW
//
//  Created by 白琴 on 16/3/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCollectListTableViewCell : UITableViewCell

/**
 *  是否为编辑状态
 */
@property (nonatomic, assign)BOOL isEdit;
/**
 *  是否为全选
 */
@property (nonatomic, assign)BOOL isChooseAll;
/**
 *  数据源
 */
@property (nonatomic, strong)NSDictionary * dataSourceDic;
/**
 *  点击选择按钮
 */
@property (nonatomic, copy)void(^clickedChooseButton)(BOOL isChoose);

@property (nonatomic, strong)UIButton * chooseButton;

@end
