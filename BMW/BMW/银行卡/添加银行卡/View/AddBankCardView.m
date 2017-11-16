//
//  AddBankCardView.m
//  DP
//
//  Created by LiuP on 16/8/2.
//  Copyright © 2016年 sp. All rights reserved.
//

#import "AddBankCardView.h"
#import "addBank.h"

@interface AddBankCardView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIView * centerView;
@property (nonatomic, strong) UIView * headView;
@property (nonatomic, strong) UIView * footView;
@property (nonatomic, copy) NSArray * titles;
@property (nonatomic, copy) NSArray * placeHolders;

@property (nonatomic, strong) UITextField * bankField; //开户银行Label
@property (nonatomic, strong) UITextField * nameField; //开户人姓名
@property (nonatomic, strong) UITextField * bankCardNumberField; //银行卡号

@property (nonatomic, strong) UIButton * bindBtn;     /**< 绑定按钮 */
@property (nonatomic, strong) UIButton * agreeBtn;   /**< 同意用户协议 */
@property (nonatomic, assign) CGFloat moveH;         /**< 移动高度 */
@end

@implementation AddBankCardView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_BACKGRONDCOLOR;
        
        _titles = @[@"持卡人", @"银行卡号", @"开户银行"];
        _placeHolders = @[@"请输入真实姓名", @"请输入银行卡号", @"请输入开户银行名称"];
        
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface
{
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.headView];
    [self.scrollView addSubview:self.centerView];
    [self.scrollView addSubview:self.footView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -- getter --
-(UIScrollView *)scrollView
{
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    return _scrollView;
}
-(UIView *)headView
{
    if (_headView) {
        return _headView;
    }
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, 44 * W_ABCW)];
    _headView.backgroundColor = COLOR_BACKGRONDCOLOR;
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15 * W_ABCW, 10 * W_ABCW, 16 * W_ABCW, 16 * W_ABCW)];
    imageView.image = [UIImage imageNamed:@"icon_zhuyi_gmlj.png"];
    [_headView addSubview:imageView];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(imageView.viewRightEdge + 5 * W_ABCW, imageView.viewY, 200, 16 * W_ABCW)];
    label.font = FONT_HEITI_SC(12 * W_ABCW);
    label.text = @"该卡仅限于您本人实名制银行卡";
    label.textColor = [UIColor colorWithHex:0xa3a2a2];
    [label sizeToFit];
    label.center = CGPointMake(imageView.viewRightEdge + 5 * W_ABCW + label.viewWidth / 2, imageView.center.y);
    [_headView addSubview:label];
    
    _headView.viewSize = CGSizeMake(_headView.viewWidth, label.viewBottomEdge + 10 * W_ABCW);
    return _headView;
}

-(UIView *)centerView
{
    if (_centerView) {
        return _centerView;
    }
    CGFloat itemHeight = 45 * W_ABCW;
    _centerView = [[UIView alloc]initWithFrame:CGRectMake(0, _headView.viewBottomEdge, self.viewWidth, itemHeight * _titles.count)];
    for (int i = 0; i < _titles.count; i ++) {
        UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, itemHeight * i, _centerView.viewWidth, itemHeight)];
        backView.backgroundColor = [UIColor whiteColor];
        [_centerView addSubview:backView];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15 * W_ABCW, 0, 80, backView.viewHeight)];
        label.text = _titles[i];
        label.textColor =  [UIColor grayColor];
        label.font = FONT_HEITI_SC(13 * W_ABCW);
        [backView addSubview:label];
        
        CGFloat width = backView.viewRightEdge - 20 - 19 - label.viewRightEdge;
        UITextField * TF = [[UITextField alloc]initWithFrame:CGRectMake(label.viewRightEdge + 9, label.viewY, width, label.viewHeight)];
        TF.textAlignment = NSTextAlignmentRight;
        TF.font = FONT_HEITI_SC(13 * W_ABCW);
        TF.placeholder = _placeHolders[i];
        TF.delegate = self;
        [backView addSubview:TF];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, backView.viewBottomEdge - 0.5, backView.viewWidth, 0.5)];
        line.backgroundColor = COLOR_BACKGRONDCOLOR;
        [_centerView addSubview:line];

        switch (i) {
            case 0:
                self.nameField = TF;
                self.nameField.returnKeyType = UIReturnKeyNext;
                break;
                
            case 1:
                self.bankCardNumberField = TF;
                self.bankCardNumberField.returnKeyType =  UIReturnKeyNext;
                self.bankCardNumberField.keyboardType = UIKeyboardTypeNumberPad;
                break;
            case 2:
                self.bankField = TF;
                self.bankField.returnKeyType = UIReturnKeyDone;
                break;
                
            default:break;
        }
    }
    return _centerView;
}

-(UIView *)footView
{
    if (_footView) {
        return _footView;
    }
    _footView = [[UIView alloc]initWithFrame:CGRectMake(0, _centerView.viewBottomEdge, self.viewWidth, 0)];
    
    _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _agreeBtn.frame = CGRectMake(15 * W_ABCW, 10 * W_ABCW, 15 * W_ABCW, 15 * W_ABCW);
    _agreeBtn.selected= YES;
    [_agreeBtn setBackgroundImage:IMAGEWITHNAME(@"icon_gouxuan_nor_gwc.png") forState:UIControlStateNormal];
    [_agreeBtn setBackgroundImage:IMAGEWITHNAME(@"icon_gouxuan_cli_gwc.png") forState:UIControlStateSelected];
    [_agreeBtn addTarget:self action:@selector(agreeProtocolAction:) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:_agreeBtn];

    UILabel * protocol = [UILabel new];
    protocol.userInteractionEnabled = YES;
    protocol.frame = CGRectMake(_agreeBtn.viewRightEdge + W_ABCW * 5, _agreeBtn.viewY, 250, _agreeBtn.viewHeight);
    protocol.font = [UIFont systemFontOfSize:11 * W_ABCW];
    protocol.text = @"同意《帮麦绑卡用户协议》";
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:protocol.text];
    [attributeStr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHex:0xa3a2a2]
                         range:NSMakeRange(0, attributeStr.length)];
    [attributeStr addAttribute:NSForegroundColorAttributeName
                         value:COLOR_NAVIGATIONBAR_BARTINT
                         range:NSMakeRange(2, protocol.text.length - 2)];
    protocol.attributedText = attributeStr;
    [_footView addSubview:protocol];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userProtocolAction:)];
    [protocol addGestureRecognizer:tap];
    
    _bindBtn = [[UIButton alloc]initWithFrame:CGRectMake(_agreeBtn.viewX, _agreeBtn.viewBottomEdge + 15 * W_ABCW, self.viewWidth - 30 * W_ABCW, 44 * W_ABCH)];
    _bindBtn.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
    [_bindBtn setTitle:@"绑定银行卡" forState:UIControlStateNormal];
    _bindBtn.layer.cornerRadius = 3;
    [_bindBtn addTarget:self action:@selector(bindBankCardAction:) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:_bindBtn];
    
    UILabel * notice = [[UILabel alloc]initWithFrame:CGRectMake(_agreeBtn.viewX, _bindBtn.viewBottomEdge + 15 * W_ABCH, 60, 15)];
    notice.text = @"温馨提示：";
    notice.textColor = COLOR_NAVIGATIONBAR_BARTINT;
    notice.font = FONT_HEITI_SC(12 * W_ABCW);
    notice.textAlignment = NSTextAlignmentLeft;
    [notice sizeToFit];
    notice.center = CGPointMake(_agreeBtn.viewX + notice.viewWidth / 2, _bindBtn.viewBottomEdge + 10 * W_ABCW + notice.viewHeight / 2);
    [_footView addSubview:notice];
    
    UILabel * contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(notice.viewRightEdge + 3 * W_ABCW, notice.viewY, 200, 15)];
    contentLabel.text = @"请填写真实信息，仅支持储蓄卡！";
    contentLabel.textColor = [UIColor colorWithHex:0x7d7d7d];
    contentLabel.font = FONT_HEITI_SC(12 * W_ABCW);
    contentLabel.textAlignment = NSTextAlignmentLeft;
    [contentLabel sizeToFit];
    contentLabel.center = CGPointMake(notice.viewRightEdge + 3 * W_ABCW + contentLabel.viewWidth / 2, notice.center.y);
    [_footView addSubview:contentLabel];
    
    [_footView setViewSize:CGSizeMake(self.viewWidth, contentLabel.viewBottomEdge + 15)];
    return _footView;
}

#pragma mark -- notifications
- (void)keyboardShowNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat viewY = self.footView.viewX + _bindBtn.viewBottomEdge;
    
    
    [UIView animateWithDuration:duration animations:^{
        if (keyboardF.origin.y < viewY) {
            _moveH = viewY - keyboardF.origin.y;
            self.scrollView.center = CGPointMake(self.scrollView.center.x, self.scrollView.center.y - _moveH);
        }
    }];
}

- (void)keyboardHideNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        if (_moveH > 0) {
            self.scrollView.center = CGPointMake(self.scrollView.center.x, self.scrollView.center.y + _moveH);
        }
    }];

}

#pragma mark -- UITextField --
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.bankCardNumberField]) {
        
        // 银行卡号输入 自动格式化
        NSString *text = [textField text];
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        
        if (newString.length >= 25) {
            return NO;  
        }
        [textField setText:newString];  
        
        return NO;
    }
    return YES;
    
/**
 过滤中文

 @return BOOL
 
 NSString *searchText = string;
 NSError *error = NULL;
 NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\u4e00-\u9fa5]" options:NSRegularExpressionCaseInsensitive error:&error];
 NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
 if(result.length>0){
 return YES;
 }
 return NO;

 */
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameField) {
        [self.nameField resignFirstResponder];
        [self.bankCardNumberField becomeFirstResponder];
        return YES;
    }
    if (textField == self.bankCardNumberField) {
        [self.bankCardNumberField resignFirstResponder];
        [self.bankField becomeFirstResponder];
        return YES;
    }

    if (textField == self.bankField) {
        [self.bankField endEditing:YES];
        return YES;
    }
    return YES;
}

#pragma mark -- actions
- (void)agreeProtocolAction:(UIButton *)sender
{
    NSLog(@"同意用户协议");
    sender.selected = !sender.selected;
}

- (void)bindBankCardAction:(UIButton *)sender
{
    NSLog(@"绑定银行卡");
    [self endEditing:YES];
    if (_agreeBtn.selected) {
        
        if ([self.nameField.text isEqualToString:@""]) {
            [MBProgressHUD show:@"请输入持卡人姓名" toView:self];
            return;
        }
        if ([self.bankCardNumberField.text isEqualToString:@""]) {
            [MBProgressHUD show:@"请输入银行卡号" toView:self];
            return;
        }
//        if (![TYTools validateCardNo:self.bankCardNumberField.text]) {
//            [MBProgressHUD show:@"银行卡号不合法，请检查" toView:self];
//            return;
//        }
//        if ([self.bankField.text isEqualToString:@""]) {
//            [MBProgressHUD show:@"请选择开户银行" toView:self];
//            return;
//        }
        if (self.bankCardNumberField.text.length < 8) {
            [MBProgressHUD show:@"银行卡号不合法，请检查" toView:self];
            return;
        }
        if ([self.delegate respondsToSelector:@selector(addCardView:clickedBindBtn:name:cardNum:bankName:)]) {
            NSString * bankCardNum = [self.bankCardNumberField.text stringByReplacingOccurrencesOfString:@" "
                                                                                              withString:@""]; // 去掉空格
            [self.delegate addCardView:self
                        clickedBindBtn:sender
                                  name:self.nameField.text
                               cardNum:bankCardNum
                              bankName:self.bankField.text];
        }
    }else {
        [MBProgressHUD show:@"请先阅读用户协议" toView:self];
    }
}

- (void)userProtocolAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"用户协议");
    if ([self.delegate respondsToSelector:@selector(addCardViewCheckUserProtocolAction)]) {
        [self.delegate addCardViewCheckUserProtocolAction];
    }
}

#pragma mark -- others
- (void)clearText
{
    self.nameField.text = @"";
    self.bankCardNumberField.text = @"";
    self.bankField.text = @"";
    [self endEditing:YES];
}
@end
