//
//  ShoppingCarHeader.m
//  BMW
//
//  Created by LiuP on 2016/10/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ShoppingCarHeader.h"

#define ACTIVITY_H 40

@interface ShoppingCarHeader ()
@property (nonatomic, strong) UIView * backView;

@property (nonatomic, strong) UILabel * activity;       /**< 活动标签 */

@property (nonatomic, strong) UILabel * content;        /**< 活动描述 */

@property (nonatomic, strong) UIButton * arrowBtn;      /**< 箭头 */

@property (nonatomic, retain) GoodsListModel * model;
@end

@implementation ShoppingCarHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier model:(GoodsListModel *)model activity:(BOOL)activity
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = COLOR_BACKGRONDCOLOR;
        if (activity) {
            self.model = model;
            [self initActivityInterface];
        }
    }
    return self;
}

- (void)initActivityInterface
{
    _backView = [UIView new];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_backView];
    
    _activity = [UILabel new];
    _activity.viewSize = CGSizeMake(33, 17);
    _activity.backgroundColor = [UIColor colorWithHex:0xffd5d2];
    _activity.font = fontForSize(11);
    _activity.textColor = [UIColor colorWithHex:0xfd5478];
    _activity.text = self.model.actLabel;
    _activity.textAlignment = NSTextAlignmentCenter;
    [_activity sizeToFit];
    _activity.viewSize = CGSizeMake(_activity.viewWidth + 10, 17);
    [_backView addSubview:_activity];
    
    _arrowBtn = [UIButton new];
    _arrowBtn.viewSize = CGSizeMake(35, 20);
    _arrowBtn.titleLabel.font = fontForSize(11);
    [_arrowBtn setTitleColor:[UIColor colorWithHex:0xfd5478] forState:UIControlStateNormal];
    [_arrowBtn setImage:[UIImage imageNamed:@"icon_jiantou_fl.png"] forState:UIControlStateNormal];
    [_arrowBtn setTitle:@"更多" forState:UIControlStateNormal];
    _arrowBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 25, 0, -20);
    _arrowBtn.titleEdgeInsets = UIEdgeInsetsMake(0, - 8, 0, 8);
    [_backView addSubview:_arrowBtn];
    
    _content = [UILabel new];
    _content.font = fontForSize(11);
    _content.textColor = [UIColor colorWithHex:0x7f7f7f];
    _content.lineBreakMode = NSLineBreakByTruncatingTail;
//    _content.text = @"这是活动描述这是活动描述这是活动描述这是活动描述这是活动描述";
    _content.text = self.model.actContent;
    [_backView addSubview:_content];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    [btn addTarget:self action:@selector(activityAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:btn];
}

#pragma mark -- action
- (void)activityAction:(UIButton *)btn
{
    self.activityBlock(self.model);
}

#pragma mark -- private
- (void)layoutSubviews
{
    [super layoutSubviews];
    _backView.frame = CGRectMake(0, 10, self.contentView.viewWidth, ACTIVITY_H);
    _activity.center = CGPointMake(10 + _activity.viewWidth / 2, _backView.viewHeight / 2);
    _arrowBtn.center = CGPointMake(_backView.viewWidth - 14 - _arrowBtn.viewWidth / 2, _activity.center.y);
    _content.frame = CGRectMake(_activity.viewRightEdge + 4, _arrowBtn.viewY, _backView.viewWidth - _activity.viewRightEdge - 22 - _arrowBtn.viewWidth, 20);
    
}


@end
