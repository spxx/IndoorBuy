//
//  AddressListTableViewCell.h
//  BMW
//
//  Created by 白琴 on 16/3/2.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressListTableViewCell : UITableViewCell

/**
 *  姓名
 */
@property (nonatomic, strong)UILabel * nameLabel;
/**
 *  电话号码
 */
@property (nonatomic, strong)UILabel * phoneLabel;

/**
 *  身份证号码
 */
@property (nonatomic, strong)UILabel * IDCardLabel;
/**
 *  省市区
 */
@property (nonatomic, strong)UILabel * areaAndCityLabel;
/**
 *  地址详情
 */
@property (nonatomic, strong)UILabel * addressInfoLabel;
/**
 *  设为默认 【1为是  0为否】
 */
@property (nonatomic, strong)UIButton * setDefaultButton;
/**
 *  返回的地址信息
 */
@property (nonatomic, strong)NSDictionary * dataSource;

@property (nonatomic, copy) void (^clickedDeleteButton)();

@property (nonatomic, copy) void (^clickedEditButton)();

@property (nonatomic, copy) void (^clickedSetDefaultButton)();

@property (nonatomic, copy)void (^btnBlock)();
@end
