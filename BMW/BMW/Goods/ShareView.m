//
//  shareView.m
//  BMW
//
//  Created by rr on 16/3/8.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ShareView.h"
#import "WXApi.h"
#import "WXApiObject.h"

@interface ShareView ()

@property (nonatomic, strong) UIView * backView;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, assign) BOOL QRCode; /**< 是否生成二维码 */
@property (nonatomic, copy) NSString * mutableStr;      /**< 标题可变的字符,主题颜色 */
@end

@implementation ShareView

//分享页面
-(instancetype)initWithTitle:(NSString *)title QRCode:(BOOL)QRCode
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.mutableStr = title;
        self.QRCode = QRCode;
        [self initUserInterface];
    }
    return self;
}

#pragma mark -- UI
-(void)initUserInterface
{
    
    _backView = [UIView new];
    _backView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [_backView align:ViewAlignmentTopLeft
     relativeToPoint:CGPointMake(0, 0)];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0;
    [self addSubview:_backView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideShareViewAction:)];
    [_backView addGestureRecognizer:tap];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewHeight, self.viewWidth, 218 * W_ABCW)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    
    NSString * title = [NSString stringWithFormat:@"您即将分享%@到", self.mutableStr];
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] initWithString:title];
    [attribute addAttribute:NSForegroundColorAttributeName
                      value:COLOR_NAVIGATIONBAR_BARTINT
                      range:NSMakeRange(5, self.mutableStr.length)];

    _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
    _title.attributedText = attribute;
    _title.font = fontForSize(12 * W_ABCW);
    [_title sizeToFit];
    _title.center = CGPointMake(_contentView.viewWidth / 2, 9 * W_ABCW + _title.viewHeight / 2);
    [_contentView addSubview:_title];
    
    CGFloat width = (_contentView.viewWidth - _title.viewWidth - 30 * W_ABCW - 18 * W_ABCW) / 2;
    UIImageView * leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 4 * W_ABCW)];
    leftImage.image = IMAGEWITHNAME(@"jpg_zuobianxian_sy.png");
    leftImage.center = CGPointMake(15 * W_ABCW + width / 2, _title.center.y);
    [_contentView addSubview:leftImage];

    UIImageView * rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 4 * W_ABCW)];
    rightImage.image = IMAGEWITHNAME(@"jpg_youbianxian_sy.png");
    rightImage.center = CGPointMake(_contentView.viewRightEdge - 15 * W_ABCW - width / 2, leftImage.center.y);
    [_contentView addSubview:rightImage];

    
    NSMutableArray * images = [NSMutableArray arrayWithArray:@[@"icon_weixin_sy.png",
                                                               @"icon_pengyouquan_sy.png",
                                                               @"icon_xinlangweibo_sy.png",
                                                               @"icon_qq_sy.png",
                                                               @"icon_qqkongjian_sy.png",
                                                               @"icon_erweima_sy.png"]];
    NSMutableArray * titles = [NSMutableArray arrayWithArray:@[@"微信好友", @"朋友圈", @"新浪微博", @"QQ", @"QQ空间", @"生成二维码"]];
    NSMutableArray * tags = [NSMutableArray arrayWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5"]];
    if (![TencentOAuth iphoneQQInstalled]) {
        [images removeObjectsInRange:NSMakeRange(3, 2)];
        [titles removeObjectsInRange:NSMakeRange(3, 2)];
        [tags removeObjectsInRange:NSMakeRange(3, 2)];
    }
    if (![WXApi isWXAppInstalled]) {
        [images removeObjectsInRange:NSMakeRange(0, 2)];
        [titles removeObjectsInRange:NSMakeRange(0, 2)];
        [tags removeObjectsInRange:NSMakeRange(0, 2)];
    }
    
    const CGFloat itemWidth = 42 * W_ABCW;
    NSInteger count = titles.count - 1;
    if (self.QRCode) {
        count = titles.count;
    }
    CGFloat totalWidth = self.viewWidth / 4;
    CGFloat totalHeight = 0;
    for (int i = 0; i < count; i ++) {
        NSInteger row = i / 4;         // 行
        NSInteger column = i % 4;      // 列

        NSString * imageName = images[i];
        NSString * titleStr = titles[i];
        NSString * tag = tags[i];
        
        CGFloat centerY = _title.viewBottomEdge + 9 * W_ABCW + itemWidth / 2 + (9 * W_ABCW + totalHeight) * row;
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0 , 0, itemWidth, itemWidth);
        btn.center = CGPointMake(totalWidth / 2 + totalWidth * column, centerY);
        btn.tag = tag.integerValue + 100;
        [btn setBackgroundImage:IMAGEWITHNAME(imageName) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(shareItemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:btn];
        
        UILabel * label = [UILabel new];
        label.frame = CGRectMake(btn.viewX, btn.viewBottomEdge + 5 * W_ABCW, 40, 0);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = fontForSize(10 * W_ABCW);
        label.textColor = [UIColor colorWithHex:0x666666];
        label.text = titleStr;
        [label sizeToFit];
        label.center = CGPointMake(btn.center.x, label.center.y);
        [_contentView addSubview:label];
        
        totalHeight = label.viewBottomEdge - btn.viewY;
    }
    
    if (images.count <= 4) {
        _contentView.frame = CGRectMake(_contentView.viewX, _contentView.viewY, _contentView.viewWidth, _contentView.viewHeight - totalHeight);
    }
    
    UIButton * cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _contentView.viewHeight - 49 * W_ABCW, SCREEN_WIDTH, 49 * W_ABCW)];
    [cancelBtn addTarget:self action:@selector(hideWithAnimation) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = fontForSize(17);
    [_contentView addSubview:cancelBtn];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, cancelBtn.viewY - 1, _contentView.viewWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
    [_contentView addSubview:line];
    
    [self showWithAnimation];
}

#pragma mark -- Actions
- (void)hideShareViewAction:(UITapGestureRecognizer *)tap
{
    [self hideWithAnimation];
}

-(void)shareItemBtnAction:(UIButton *)sender
{
    /**
     * 0:微信好友 1:微信朋友圈 2:新浪微博 3:QQ 4:QQ空间 5:生成二维码
     */
    Share3RDParty destination;
    switch (sender.tag) {
        case 100: destination = ShareWXSession;
            break;
        case 101: destination = ShareWXFriend;
            break;
        case 102: destination = ShareSina;
            break;
        case 103: destination = ShareQQ;
            break;
        case 104: destination = ShareQQZone;
            break;
        case 105: destination = ShareCreatCode;
            break;
        default: destination = ShareNone;
            break;
    }
    if ([self.delegate respondsToSelector:@selector(shareView:chooseItemWithDestination:)]) {
        [self.delegate shareView:self chooseItemWithDestination:destination];
    }
    [self hideWithAnimation];
}
#pragma mark -- private
- (void)hideWithAnimation
{
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha = 0;
        _contentView.center = CGPointMake(_contentView.center.x, self.viewHeight + _contentView.viewHeight / 2);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showWithAnimation
{
    [UIView animateWithDuration:0.3 animations:^{
        _backView.alpha = 0.4;
        _contentView.center = CGPointMake(_contentView.center.x, self.viewHeight - _contentView.viewHeight / 2);
    }];
}


@end
