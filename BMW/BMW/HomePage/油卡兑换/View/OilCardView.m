//
//  OilCardView.m
//  BMW
//
//  Created by LiuP on 2016/12/17.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OilCardView.h"

static NSString * protocolStr = @"已阅读并同意《油卡兑换服务协议》";

@interface OilCardView ()<UIScrollViewDelegate, UITextFieldDelegate, MoneyItemViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIImageView * adImageView;    /**< 顶部广告 */
@property (nonatomic, strong) UIView * CINumView;           /**< 输入CI卡号 */


@property (nonatomic, strong) UIView * contenView;          /**< 充值金额部分视图 */
@property (nonatomic, assign) CGFloat itemBottom;           /**< 金额的底部位置 */
@property (nonatomic, strong) MoneyItemView * selectedItem; /**< 当前选中的金额视图 */
@property (nonatomic, retain) NSArray * messages;           /**< 提示信息 */
@end

@implementation OilCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 0)];
    _adImageView.userInteractionEnabled = YES;
    [_scrollView addSubview:_adImageView];
    
    UITapGestureRecognizer * ADTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ADTapAction:)];
    [_adImageView addGestureRecognizer:ADTap];
    
    // CI卡号视图
    _CINumView = [[UIView alloc] initWithFrame:CGRectMake(0, _adImageView.viewBottomEdge, self.viewWidth, 69 * W_ABCW)];
    _CINumView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_CINumView];
    
    UIView * firstSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 5 * W_ABCW)];
    firstSpace.backgroundColor = COLOR_BACKGRONDCOLOR;
    [_CINumView addSubview:firstSpace];
    
    UIView * secondSpace = [[UIView alloc] initWithFrame:CGRectMake(0, _CINumView.viewHeight - firstSpace.viewHeight, self.viewWidth, 5 * W_ABCW)];
    secondSpace.backgroundColor = COLOR_BACKGRONDCOLOR;
    [_CINumView addSubview:secondSpace];
    
    UILabel * CILabel = [[UILabel alloc] initWithFrame:CGRectMake(12 * W_ABCW, firstSpace.viewBottomEdge, 50, 0)];
    CILabel.font = fontForSize(15 * W_ABCW);
    CILabel.text = @"IC卡号：";
    [CILabel sizeToFit];
    CILabel.viewSize = CGSizeMake(CILabel.viewWidth, _CINumView.viewHeight - firstSpace.viewHeight * 2);
    [_CINumView addSubview:CILabel];
    
    CGFloat origin_x = CILabel.viewRightEdge;
    CGFloat height = 33 * W_ABCW;
    CGFloat origin_y = (_CINumView.viewHeight - height) / 2;
    CGFloat width = _CINumView.viewWidth - origin_x - 12 * W_ABCW;
    _CINumField = [[UITextField alloc] initWithFrame:CGRectMake(origin_x, origin_y, width, height)];
    _CINumField.font = fontForSize(12 * W_ABCW);
    _CINumField.layer.cornerRadius = height / 2;
    _CINumField.layer.borderWidth = 1;
    _CINumField.layer.borderColor = [UIColor blackColor].CGColor;
    _CINumField.keyboardType = UIKeyboardTypeNumberPad;
    _CINumField.returnKeyType = UIReturnKeyDone;
    _CINumField.leftViewMode = UITextFieldViewModeAlways;
    _CINumField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [_CINumView addSubview:_CINumField];
    
    NSString * placeHolder = @"请输入中石化加油卡（主卡）";
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] initWithString:placeHolder];
    [attribute addAttribute:NSForegroundColorAttributeName
                      value:[UIColor colorWithHex:0x939393]
                      range:NSMakeRange(0, placeHolder.length)];
    _CINumField.attributedPlaceholder = attribute;
    
    [self initMoneyItemsView];
}

- (void)initMoneyItemsView
{
    _contenView = [[UIView alloc] initWithFrame:CGRectMake(0, self.CINumView.viewBottomEdge, self.viewWidth, 0)];
    _contenView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_contenView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEidting)];
    [_contenView addGestureRecognizer:tap];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
    label.font = fontForSize(15 * W_ABCW);
    label.text = @"选择充值金额";
    [label sizeToFit];
    label.center = CGPointMake(12 * W_ABCW + label.viewWidth / 2, 12 * W_ABCW + label.viewHeight / 2);
    [_contenView addSubview:label];
}

- (void)initNoticeView
{
    // 温馨提示
    UIImageView * remindImage = [[UIImageView alloc] initWithFrame:CGRectMake(12 * W_ABCW, self.itemBottom + 20 * W_ABCW, 17 * W_ABCW, 17 * W_ABCW)];
    remindImage.image = [UIImage imageNamed:@"icon_tishi_lqzx.png"]; // 17 * 17的图片
    [_contenView addSubview:remindImage];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
    label.font = fontForSize(15 * W_ABCW);
    label.text = @"温馨提示：";
    [label sizeToFit];
    label.center = CGPointMake(remindImage.viewRightEdge + 5 + label.viewWidth / 2, remindImage.center.y);
    [_contenView addSubview:label];
    
    CGFloat origin_y = label.viewBottomEdge + 7;
    CGFloat width = self.viewWidth - label.viewX - 12;
    CGFloat pointWitdh = 4.5;
    CGFloat viewBottomEdge = origin_y;
    for (int i = 0; i < self.messages.count; i ++) {
        UILabel * message = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
        message.numberOfLines = 0;
        message.font = fontForSize(11 * W_ABCW);
        message.text = self.messages[i];
        [message sizeToFit];
        message.frame = CGRectMake(label.viewX + pointWitdh + 4, viewBottomEdge + 5, message.viewWidth, message.viewHeight);
        [_contenView addSubview:message];
        
        viewBottomEdge = message.viewBottomEdge;
        if (i<self.messages.count-1) {
            UIView * point = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pointWitdh, pointWitdh)];
            point.backgroundColor = [UIColor blackColor];
            point.layer.cornerRadius = pointWitdh / 2;
            point.center = CGPointMake(label.viewX + pointWitdh / 2, message.center.y);
            [_contenView addSubview:point];            
        }
    }
    
    // 勾选协议
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(remindImage.viewX - 9.5, viewBottomEdge + 26 * W_ABCW, 30, 30);  // 11 * 11的图片
    [_selectBtn setImage:[UIImage imageNamed:@"icon_weigouxuan_ykdh_nor.png"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"icon_yigouxuan_ykdh_cli.png"] forState:UIControlStateSelected];
    [_selectBtn addTarget:self action:@selector(serviceProtocolAction:) forControlEvents:UIControlEventTouchUpInside];
    _selectBtn.selected = YES;
    [_contenView addSubview:_selectBtn];
    
    CGFloat originX = _selectBtn.viewRightEdge - 5;
    CGFloat protocolW = self.viewWidth - 15 * W_ABCW - originX;
    UILabel * protocol = [[UILabel alloc] initWithFrame:CGRectMake(originX, _selectBtn.viewY, protocolW, _selectBtn.viewHeight)];
    protocol.font = fontForSize(11 * W_ABCW);
    protocol.userInteractionEnabled = YES;
    [_contenView addSubview:protocol];
    
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] initWithString:protocolStr];
    [attribute addAttribute:NSForegroundColorAttributeName
                      value:[UIColor colorWithHex:0x666666]
                      range:NSMakeRange(0, protocolStr.length)];
    [attribute addAttribute:NSForegroundColorAttributeName
                      value:[UIColor colorWithHex:0x0b75f4]
                      range:NSMakeRange(6, protocolStr.length - 6)];
    protocol.attributedText = attribute;

    UITapGestureRecognizer * tapProtocol = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProtocolAction:)];
    [protocol addGestureRecognizer:tapProtocol];
    
    _contenView.viewSize = CGSizeMake(_contenView.viewWidth, protocol.viewBottomEdge + 10);
}

#pragma mark -- getter
- (NSArray *)messages
{
    if (!_messages) {
        _messages = @[@"不支持中石油油卡充值；",
                      @"请您仔细核对卡号，充错卡号不退M币；",
                      @"以下加油IC卡无法在线充值：",
                      @"中石化一副卡、挂失卡、增值税发票卡；"];
    }
    return _messages;
}

#pragma mark -- setter
- (void)setModels:(NSMutableArray *)models
{
    _models = models;
    CGFloat width = (self.viewWidth - 24 * W_ABCW - 26 * W_ABCW) / 3;
    CGFloat height = 50 * W_ABCW;
    CGFloat origin_x = 12 * W_ABCW;
    CGFloat origin_y = 40 * W_ABCW;
    CGFloat space = 13 * W_ABCW;
    for (int i = 0; i < _models.count; i ++) {
        NSInteger row = i / 3;         // 行
        NSInteger column = i % 3;      // 列
        CGFloat x = origin_x + (width + space) * column;
        CGFloat y = origin_y + (height + 11 * W_ABCW) * row;
        MoneyItemView * itemView = [[MoneyItemView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        itemView.delegate = self;
        itemView.model = _models[i];
        [_contenView addSubview:itemView];
        
        self.itemBottom = itemView.viewBottomEdge;
    }
    
    [self initNoticeView];
}

- (void)setAdModel:(OilCardModel *)adModel
{
    _adModel = adModel;
    if (adModel.show) {
        WEAK_SELF;
        [self.adImageView sd_setImageWithURL:[NSURL URLWithString:adModel.oilImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                CGFloat width = image.size.width;
                CGFloat height = image.size.height;
                weakSelf.adImageView.viewSize = CGSizeMake(weakSelf.adImageView.viewWidth, height * self.viewWidth / width);
                [weakSelf layoutSubviews];
            }
        }];
    }
}

#pragma mark -- private
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.CINumView.frame = CGRectMake(0, self.adImageView.viewBottomEdge, self.CINumView.viewWidth, self.CINumView.viewHeight);
    self.contenView.frame = CGRectMake(0, self.CINumView.viewBottomEdge, self.contenView.viewWidth, self.contenView.viewHeight);
    self.scrollView.contentSize = CGSizeMake(self.viewWidth, self.contenView.viewBottomEdge + 10);
}

#pragma mark -- actions
- (void)ADTapAction:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(oilCardView:clickedADWitModel:)]) {
        [self.delegate oilCardView:self clickedADWitModel:self.adModel];
    }
}

- (void)serviceProtocolAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

- (void)tapProtocolAction:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(didSelectedProtocol)]) {
        [self.delegate didSelectedProtocol];
    }
}

#pragma mark -- MoneyItemViewDelegate
- (void)moneyItemView:(MoneyItemView *)moneyItemView didSelectedItemWitModel:(OilCardModel *)model
{
    if (self.selectedItem) {
        self.selectedItem.model.selected = NO;
        [self.selectedItem changeStatus];
    }
    model.selected = YES;
    self.selectedItem = moneyItemView;
    [self.selectedItem changeStatus];
    if ([self.delegate respondsToSelector:@selector(oilCardView:selectedItemWitModel:)]) {
        [self.delegate oilCardView:self selectedItemWitModel:model];
    }
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self endEidting];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEidting];
    return YES;
}

#pragma mark -- other
- (void)endEidting
{
    [self.CINumField endEditing:YES];
}
@end
