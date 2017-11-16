//
//  ChooseShopView.m
//  BMW
//
//  Created by rr on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ChooseShopView.h"

@interface ChooseShopView ()<UITextFieldDelegate>
{
    UIImageView *_topImageV;
    UILabel *_priceLabel;
    UITextField *_inviPhoneText;
}
@end

@implementation ChooseShopView

-(instancetype)initWithFrame:(CGRect)frame andWithChoose:(ChoosePorS)choose{
    if (self = [super initWithFrame:frame]) {
        _choosePorS = choose;
        [self initUserInterface];
    }
    return self;
}

-(void)initUserInterface{
    _topImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 294*W_ABCH)];
    [_topImageV sd_setImageWithURL:nil placeholderImage:IMAGEWITHNAME(@"")];
    [self addSubview:_topImageV];
    
    UILabel *invuText = [[UILabel alloc] initWithFrame:CGRectMake(0, _topImageV.viewBottomEdge+18*W_ABCH, SCREEN_WIDTH, 12)];
    invuText.textAlignment = NSTextAlignmentCenter;
    invuText.text = @"请选择邀请人，双方将获得";
    invuText.font = fontForSize(12);
    invuText.textColor = [UIColor colorWithHex:0x000000];
    [self addSubview:invuText];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, invuText.viewBottomEdge+9*W_ABCH, SCREEN_WIDTH, 15)];
    _priceLabel.textColor = COLOR_NAVIGATIONBAR_BARTINT;
    _priceLabel.font = fontForSize(15);
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_priceLabel];
    
    UIView *inviPhoneView = [[UIView alloc] initWithFrame:CGRectMake(21*W_ABCW, _priceLabel.viewBottomEdge+14*W_ABCW, SCREEN_WIDTH-42*W_ABCW, 34*W_ABCH)];
    inviPhoneView.layer.borderWidth = 1;
    inviPhoneView.layer.borderColor = COLOR_NAVIGATIONBAR_BARTINT.CGColor;
    inviPhoneView.layer.cornerRadius = inviPhoneView.viewHeight/2;
    [self addSubview:inviPhoneView];

    _inviPhoneText = [[UITextField alloc] initWithFrame:CGRectMake(10*W_ABCW, 0, inviPhoneView.viewWidth - 71*W_ABCW, 34*W_ABCH)];
    _inviPhoneText.font = fontForSize(15);
    _inviPhoneText.textColor = [UIColor colorWithHex:0x000000];
    _inviPhoneText.placeholder = @"请输入邀请人手机号";
    _inviPhoneText.textAlignment = NSTextAlignmentCenter;
    _inviPhoneText.returnKeyType = UIReturnKeyDone;
    _inviPhoneText.delegate = self;
    [inviPhoneView addSubview:_inviPhoneText];
    
    UIButton *inviButton = [UIButton new];
    inviButton.viewSize = CGSizeMake(71*W_ABCW, 29*W_ABCH);
    [inviButton align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(inviPhoneView.viewWidth - 2*W_ABCW, inviPhoneView.viewHeight/2)];
    inviButton.layer.cornerRadius = inviButton.viewHeight/2;
    inviButton.layer.masksToBounds = YES;
    [inviButton setBackgroundColor:COLOR_NAVIGATIONBAR_BARTINT];
    [inviButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    inviButton.titleLabel.font = fontForSize(17);
    [inviButton addTarget:self action:@selector(inviBtn) forControlEvents:UIControlEventTouchUpInside];
    [inviPhoneView addSubview:inviButton];
    
    UIButton *noBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, inviPhoneView.viewBottomEdge+9*W_ABCH, SCREEN_WIDTH, 12)];
    [noBtn setTitleColor:COLOR_NAVIGATIONBAR_BARTINT forState:UIControlStateNormal];
    noBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    noBtn.titleLabel.font = fontForSize(12);
    [noBtn addTarget:self action:@selector(gotoShop) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:noBtn];
    if (_choosePorS == ChoosePreson) {
        [inviButton setTitle:@"成为麦咖" forState:UIControlStateNormal];
        [noBtn setTitle:@"没有邀请人，直接成为麦咖>>" forState:UIControlStateNormal];
    }else{
        [inviButton setTitle:@"进店拿礼" forState:UIControlStateNormal];
        [noBtn setTitle:@"没有邀请人，直接进店>>" forState:UIControlStateNormal];
    }
    
    UILabel *sizeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
    sizeL.font = fontForSize(12);
    sizeL.text = @"没有邀请人，直接成为麦咖>>";
    [sizeL sizeToFit];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, noBtn.viewBottomEdge, sizeL.viewWidth, 1*W_ABCH)];
    [line align:ViewAlignmentTopCenter relativeToPoint:CGPointMake(SCREEN_WIDTH/2, noBtn.viewBottomEdge)];
    line.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
    [self addSubview:line];
}

-(void)setModel:(chooseShopModel *)model{
    _priceLabel.text = model.title;
    [_topImageV sd_setImageWithURL:[NSURL URLWithString:model.backImageV] placeholderImage:nil options:SDWebImageRefreshCached];

}
-(void)inviBtn{
    if ([_inviPhoneText.text length]==0) {
        SHOW_MSG(@"请填写邀请人手机号");
    }else{
        if ([self.delegate respondsToSelector:@selector(gotoPay:)]) {
            [self.delegate gotoPay:_inviPhoneText.text];
        }
    }
}

-(void)gotoShop{
    if ([self.delegate respondsToSelector:@selector(bangmaitiyan)]) {
        [self.delegate bangmaitiyan];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.delegate ending];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //手机号
    if (textField == _inviPhoneText) {
        if (textField.text.length >10)
        {
            if([string isEqualToString:@""])
            {
                return YES;
            }
            return NO;
        }
    }
    return YES;
}


@end
