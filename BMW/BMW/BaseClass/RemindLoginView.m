//
//  RemindLoginView.m
//  DP
//
//  Created by LiuP on 15/11/27.
//  Copyright © 2015年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "RemindLoginView.h"

@interface RemindLoginView ()

@end

@implementation RemindLoginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame type:(RemindType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = COLOR_BACKGRONDCOLOR;
        
        if (type == RemindTypeNoUser) {
            UIImageView * headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 93 * W_ABCW, 93 * W_ABCW)];
            headView.center = CGPointMake(self.center.x, 108 * W_ABCH + 46 * W_ABCW);
            headView.image = [UIImage imageNamed:@"icon_tishi.png"];
            [self addSubview:headView];
            
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame) + 24 * W_ABCH, SCREEN_WIDTH, 17)];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor colorWithHex:0x8c8c8c];
            label.text = @"您还未登录帮麦分销";
            [self addSubview:label];
            
            CGFloat btn_w = 106 * W_ABCW;
            UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            loginBtn.frame = CGRectMake((SCREEN_WIDTH - btn_w) / 2, CGRectGetMaxY(label.frame) + 14 * W_ABCH, btn_w, 33 * W_ABCW);
            [loginBtn setBackgroundImage:[UIImage imageNamed:@"icon_denglu_nor.png"] forState:UIControlStateNormal];
            [loginBtn setBackgroundImage:[UIImage imageNamed:@"icon_denglu_cli.png"] forState:UIControlStateHighlighted];
            [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:loginBtn];
        }else if(type != RemindTypeNoCollectionGoods && type != RemindTypeNoCollectionBrand){
            CGFloat image_w = 0;
            CGFloat image_h = 0;
            NSString * labelText;
            NSString * imageName;

            if (type == RemindTypeNoConnection) {
                image_w = 129 * W_ABCW;
                image_h = 92 * W_ABCW;
                labelText = @"网络未连接";
                imageName = @"icon_wuwangluo.png";
            }else if (type == RemindTypeNoBackCard) {
                image_w = 88 * W_ABCW;
                image_h = 54 * W_ABCW;
                labelText = @"您还没有绑定银行卡哦";
                imageName = @"icon_wubangdingyinhangka.png";
            }else if (type == RemindTypeNoOrder) {
                image_w = 95 * W_ABCW;
                image_h = 91 * W_ABCW;
                labelText = @"近期无订单记录";
                imageName = @"icon_wudingdan.png";
            }else if (type == RemindTypeNoSearch) {
                image_w = 56 * W_ABCW;
                image_h = 56 * W_ABCW;
                labelText = @"您的搜索记录为空哦";
                imageName = @"icon_search.png";
            }else if (type == RemindTypeNoCollection) {
                image_w = 94 * W_ABCW;
                image_h = 92 * W_ABCW;
                labelText = @"您还没有收藏任何品牌和商品";
                imageName = @"icon_wushoucangshangpin.png";
            }
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image_w, image_h)];
            imageView.center = CGPointMake(self.center.x, 108 * W_ABCH + image_h / 2);
            imageView.image = [UIImage imageNamed:imageName];
            [self addSubview:imageView];
            
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 24 * W_ABCH, SCREEN_WIDTH, 18)];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor colorWithHex:0xc4c4c4];
            label.text = labelText;
            [self addSubview:label];
        }else {
            NSString * labelText;
            CGFloat image_w = 28 * W_ABCW;
            CGFloat image_h = 28 * W_ABCW;
            if (type == RemindTypeNoCollectionBrand) {
                labelText = @"您还没有收藏任何品牌";
            }else if (type == RemindTypeNoCollectionGoods) {
                labelText = @"您还没有收藏任何商品";
            }
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - (170 + 40 * W_ABCW)) / 2, CGRectGetHeight(self.frame)/ 2 - image_h / 2 , image_w, image_h)];
            imageView.image = [UIImage imageNamed:@"icon_tixing_wdsc.png"];
            [self addSubview:imageView];
            
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 12 * W_ABCW, CGRectGetMidX(self.frame), 170, 18)];
            label.center = CGPointMake(label.center.x, CGRectGetMidY(imageView.frame));
            label.textColor = [UIColor colorWithHex:0xc4c4c4];
            label.text = labelText;
            [self addSubview:label];
        }
    }
    return self;
}

- (void)loginBtnAction
{
    self.loginBlock();
}

@end
