//
//  NewsCell.h
//  BMW
//
//  Created by rr on 16/3/22.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell

@property(nonatomic, copy) UILabel *titleLabel;

@property(nonatomic, copy) UIImageView *numImage;

@property(nonatomic, copy) UILabel *detailLabel;

@property(nonatomic, copy) UILabel *timeLabel;

@property(nonatomic, copy) UIImageView *row;

@property(nonatomic,copy) NSString * timeStr;

@property(nonatomic, assign) BOOL hideOrShow;

@property(nonatomic, assign) NSInteger count;

@property(nonatomic, assign) BOOL isread;;

@property(nonatomic,strong)UILabel * num;


@end
