//
//  WithDrawApplyView.m
//  DP
//
//  Created by rr on 16/8/1.
//  Copyright © 2016年 sp. All rights reserved.
//

#import "WithdrawView.h"


@interface WithdrawView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton * clearBtn;  /**< 清空按钮 */

@end

@implementation WithdrawView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor = COLOR_BACKGRONDCOLOR;
        [self initUserInterface];
    }
    return self;
}


-(void)initUserInterface
{
    UIView * totalCashView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 154*W_ABCH)];
    totalCashView.backgroundColor = [UIColor whiteColor];
    [self addSubview:totalCashView];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 41*W_ABCH, SCREEN_WIDTH - 30, 13*W_ABCH)];
    label.font = [UIFont systemFontOfSize:13*W_ABCH];
    
    label.textColor = [UIColor colorWithHex:0x181818];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"可提现金额（元）";
    [totalCashView addSubview:label];
    
    _totalCash = [[UILabel alloc]initWithFrame:CGRectMake(15, 63*W_ABCH, SCREEN_WIDTH - 30, 50*W_ABCH)];
    _totalCash.font = fontBoldForSize(50*W_ABCH);
    _totalCash.textAlignment = NSTextAlignmentCenter;
    _totalCash.textColor = COLOR_NAVIGATIONBAR_BARTINT;
    [totalCashView addSubview:_totalCash];
    
    //选择银行
    UIView * chooseBankBackView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(totalCashView.frame) + 13, SCREEN_WIDTH, 45*W_ABCH)];
    chooseBankBackView.backgroundColor = [UIColor whiteColor];
    [self addSubview:chooseBankBackView];
    
    UILabel * bankLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 65, chooseBankBackView.viewHeight)];
    bankLabel.text = @"开户银行";
    bankLabel.textColor = [UIColor colorWithHex:0x000000];
    bankLabel.font = fontForSize(13*W_ABCH);
    [bankLabel sizeToFit];
    bankLabel.viewSize = CGSizeMake(bankLabel.viewWidth, 45*W_ABCH);
    [chooseBankBackView addSubview:bankLabel];
    
    UIImageView * arrow = [UIImageView new];
    arrow.viewSize = CGSizeMake(6, 10);
    [arrow align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15, 45*W_ABCH/2)];
    arrow.image = [UIImage imageNamed:@"icon_xiaojiantou_sy.png"];
    [chooseBankBackView addSubview:arrow];
    
    _userBankLabel = [UILabel new];
    _userBankLabel.viewSize = CGSizeMake(150, 45*W_ABCH);
    [_userBankLabel align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(arrow.viewX, 0)];
    _userBankLabel.font = fontForSize(13*W_ABCH);
    _userBankLabel.text = @"选择银行卡";
    _userBankLabel.textAlignment = NSTextAlignmentRight;
    _userBankLabel.viewSize = CGSizeMake(_userBankLabel.viewWidth, 45*W_ABCH);
    [_userBankLabel align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(arrow.viewX-9*W_ABCW, 45*W_ABCH/2)];
    _userBankLabel.textColor = [UIColor colorWithHex:0x181818];
    _userBankLabel.textAlignment = NSTextAlignmentRight;
    [chooseBankBackView addSubview:_userBankLabel];
    
    UIButton * button = [[UIButton alloc]initWithFrame:chooseBankBackView.bounds];
    [button addTarget:self action:@selector(chooseBankAction:) forControlEvents:UIControlEventTouchUpInside];
    [chooseBankBackView addSubview:button];
    
    //分割线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, chooseBankBackView.viewBottomEdge, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self addSubview:line];
    
    //提现金额
    UIView * textFieldView = [[UIView alloc]initWithFrame:CGRectMake(0, line.viewBottomEdge, SCREEN_WIDTH, 45*W_ABCH)];
    textFieldView.backgroundColor = [UIColor whiteColor];
    [self addSubview:textFieldView];
    
    UILabel * apply = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 65, textFieldView.viewHeight)];
    apply.textColor = [UIColor colorWithHex:0x000000];
    apply.text = @"提现金额";
    apply.font = fontForSize(13*W_ABCH);
    [textFieldView addSubview:apply];
    
    _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearBtn.viewSize = CGSizeMake(30, 30);
    _clearBtn.hidden = YES;
    _clearBtn.center = CGPointMake(textFieldView.viewWidth - 8 - _clearBtn.viewWidth / 2, textFieldView.viewHeight / 2);
    [_clearBtn setImage:IMAGEWITHNAME(@"icon_quxiao_yetx.png") forState:UIControlStateNormal];
    [_clearBtn addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];
    [textFieldView addSubview:_clearBtn];
    
    CGFloat origin_x = CGRectGetMaxX(apply.frame);
    _outputCash = [[UITextField alloc]initWithFrame:CGRectMake(origin_x, 0, _clearBtn.viewX - origin_x - 2, textFieldView.viewHeight)];
    _outputCash.textAlignment = NSTextAlignmentRight;
    _outputCash.font = [UIFont systemFontOfSize:13*W_ABCH];
    _outputCash.placeholder = @"请输入提现金额";
    _outputCash.keyboardType = UIKeyboardTypeDecimalPad;
    _outputCash.delegate = self;
    [textFieldView addSubview:_outputCash];
    
    // 警告
    UIImageView *zhuyiImage = [[UIImageView alloc] initWithFrame:CGRectMake(15,textFieldView.viewBottomEdge+7*W_ABCH, 16, 16)];
    zhuyiImage.image = IMAGEWITHNAME(@"icon_zhuyi_yetx.png");
    [self addSubview:zhuyiImage];
    
    CGFloat originX = zhuyiImage.viewRightEdge+5*W_ABCW;
    UILabel *zhuyiLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, zhuyiImage.viewY, SCREEN_WIDTH - originX - 10, 0)];
    zhuyiLabel.numberOfLines = 0;
    zhuyiLabel.font = fontForSize(11*W_ABCH);
    zhuyiLabel.text = @"提现金额需大于等于100元方可提现，且限于仅限于本人实名制银行卡";
    zhuyiLabel.textColor = [UIColor colorWithHex:0xa3a2a2];
    [zhuyiLabel sizeToFit];
    zhuyiLabel.viewSize = CGSizeMake(zhuyiLabel.viewWidth, zhuyiLabel.viewHeight);
    [self addSubview:zhuyiLabel];

    
    
    CGFloat btn_w = 290 * W_ABCW;
    CGFloat btn_h = 45 * W_ABCW;
    UIButton * applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    applyBtn.frame = CGRectMake((SCREEN_WIDTH - btn_w) / 2, zhuyiLabel.viewBottomEdge + 10*W_ABCH, btn_w, btn_h);
    applyBtn.layer.cornerRadius = btn_h / 2;
    applyBtn.clipsToBounds = YES;
    applyBtn.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
    [applyBtn setTitle:@"申请提现" forState:UIControlStateNormal];
    [applyBtn addTarget:self action:@selector(applyAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:applyBtn];
    
    UILabel *shenqLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, applyBtn.viewBottomEdge+15*W_ABCH, self.viewWidth - 30, 11*W_ABCH)];
    shenqLabel.textColor = COLOR_NAVIGATIONBAR_BARTINT; //[UIColor colorWithHex:0xfc4e40];
    shenqLabel.text = @"预计7-10个工作日内到账，请静心等待!";
    shenqLabel.font = fontForSize(11*W_ABCH);
    [shenqLabel sizeToFit];
    shenqLabel.viewSize = CGSizeMake(shenqLabel.viewWidth, 11*W_ABCH);
    [self addSubview:shenqLabel];

}

#pragma mark -- actions
- (void)clearAction:(UIButton *)sender
{
    self.outputCash.text = @"";
}
//选择银行卡
-(void)chooseBankAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(withdrawView:clickedBankWithBtn:)]) {
        [self.delegate withdrawView:self clickedBankWithBtn:sender];
    }
}
//申请提现
-(void)applyAction:(UIButton *)sender
{
    [self.outputCash endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(withdrawView:clickedWithdrawWithCash:)]) {
        [self.delegate withdrawView:self clickedWithdrawWithCash:self.outputCash];
    }
}

#pragma mark -- events
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

#pragma mark -- UITextFieldDelegate --
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _outputCash) {
        [self endEditing:YES];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.clearBtn.hidden = NO;
}

/**
 *
 *
 *  @param textField 输入之前的值
 *  @param range     输入的位置
 *  @param string    输入的字符
 *
 *  @return
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([textField.text rangeOfString:@"."].location!=NSNotFound) {
        if ([string isEqualToString:@"."]) {        /**< 只能输入一个点 */
            return NO;
        }else {                                     /**< 只能输入两位小数 */
            NSMutableString * text = [NSMutableString stringWithString:textField.text];
            [text insertString:string atIndex:range.location];
            NSArray * strs = [text componentsSeparatedByString:@"."];
            NSString * suffix = strs.lastObject;
            if (suffix.length > 2 ) {
                return NO;
            }else {
                return YES;
            }
        }
    }
    
    NSCharacterSet * cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    
    NSString * filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    BOOL basicTest = [string isEqualToString:filtered];
    if (basicTest) {
        return YES;
    }else {
        return NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.clearBtn.hidden = YES;
    if ([textField.text isEqualToString:@"."]) {
        textField.text = @"0";
    }
    textField.text = [NSString stringWithFormat:@"%.2f", textField.text.doubleValue];
}



@end
