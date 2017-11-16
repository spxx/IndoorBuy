//
//  WithdrawBankCardView.m
//  DP
//
//  Created by LiuP on 16/8/2.
//  Copyright © 2016年 sp. All rights reserved.
//

#import "WithdrawBankCardView.h"

@interface WithdrawBankCardView ()

@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, retain) BankCardModel * selectModel;

@property (nonatomic, strong) UIButton * selectBtn;

@property (nonatomic, assign) NSUInteger selectIndex; // 100~10*

@property (nonatomic, strong) NSMutableArray * btns;  // 存放按钮

@end

@implementation WithdrawBankCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        NSDictionary * newCard = @{@"id":@"-1", @"bank":@"使用新卡提现"};
        _models = [NSMutableArray arrayWithObject:[[BankCardModel alloc] initWithDic:newCard]];
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface
{
    UIView * alphaView = [[UIView alloc] initWithFrame:self.bounds];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0.3;
    [self addSubview:alphaView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideBankCardListAction:)];
    [alphaView addGestureRecognizer:tap];
    
    [self initBankCardList];
}

- (void)initBankCardList
{
    if (_contentView) {
        [_contentView removeFromSuperview];
    }
    
    _btns = [NSMutableArray array];
    
    _contentView = [UIView new];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 5;
    [self addSubview:_contentView];

    CGFloat height = 42 * W_ABCW;
    CGFloat width  = 270 * W_ABCW;
   
    _contentView.viewSize = CGSizeMake(width, height * (self.models.count + 1));
    _contentView.center = CGPointMake(self.center.x, self.center.y - 10);
    
    UILabel * title = [UILabel new];
    title.frame = CGRectMake(5, 0, width - 10, height);
    title.text = @"请选择银行卡";
    title.font = [UIFont systemFontOfSize:17 * W_ABCW];
    title.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:title];
    for (int i = 0; i < self.models.count; i ++) {
        BankCardModel * model = self.models[i];

        UIView * line = [UIView new];
        line.frame = CGRectMake(0, height + height * i, width, 1);
        line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_contentView addSubview:line];
        
        UILabel * cardInfo = [UILabel new];
        cardInfo.frame = CGRectMake(15 * W_ABCW, line.viewBottomEdge, width - 30 * W_ABCW, height);
        if (model.bankCardNum.length > 0) {
            cardInfo.text = [NSString stringWithFormat:@"%@（%@）", model.bank, model.bankCardNum];
        }else {
            cardInfo.text = [NSString stringWithFormat:@"%@", model.bank];
        }
        cardInfo.font = [UIFont systemFontOfSize:13 * W_ABCW];
        [_contentView addSubview:cardInfo];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = cardInfo.frame;
        btn.tag = 100 + i;
        [btn setImage:IMAGEWITHNAME(@"icon_weixuanze_jrbmd_nor.png") forState:UIControlStateNormal];
        [btn setImage:IMAGEWITHNAME(@"icon_yixuanze_jrbmd_cli.png") forState:UIControlStateSelected];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, btn.viewWidth - btn.currentImage.size.width, 0, 0);
        [btn addTarget:self action:@selector(chooseBankCardAction:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:btn];
        
        [_btns addObject:btn];
    }
    
    // 勾选上次选择的银行卡
    if (self.selectIndex > 0) {
        self.selectModel = self.models[self.selectIndex - 100];
        self.selectBtn = _btns[self.selectIndex - 100];
        self.selectBtn.selected = YES;
    }else {
        self.selectModel = self.models[0];
        self.selectBtn = _btns[0];
        self.selectBtn.selected = YES;
    }
}

#pragma mark -- setter
- (void)setModels:(NSMutableArray *)models
{
    BankCardModel * lastModel = [_models objectAtIndex:_models.count - 1];   /**< 最后一个为使用新卡 */
    [_models removeAllObjects];
    _models = models;
    [_models addObject:lastModel];
    [self initBankCardList];
}

#pragma mark -- actions
- (void)hideBankCardListAction:(UITapGestureRecognizer *)tap
{
    self.hidden = YES;
}

- (void)chooseBankCardAction:(UIButton *)sender
{
    self.selectBtn.selected = NO;
    sender.selected = YES;
    self.selectBtn = sender;
    self.selectModel = self.models[self.selectBtn.tag - 100];
    self.selectIndex = sender.tag;
    
    if ([self.delegate respondsToSelector:@selector(cardView:chooseBankCardWithModel:)]) {
        [self.delegate cardView:self chooseBankCardWithModel:self.selectModel];
    }
}

@end
