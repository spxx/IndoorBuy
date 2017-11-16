//
//  FeedbackViewController.m
//  BMW
//
//  Created by 白琴 on 16/3/23.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController () <UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>{
    UIScrollView * _scrollView;
    UIButton * _lastButton;
    
    UITextView * _textView;
    UILabel * _placeholderLabel;
    UITextField * _contactTextField;        //联系方式
    UIButton * _submitButton;               //提交按钮
    UITextField * _inputTextField;
    NSString * _type;
}

@property (nonatomic, strong)UIView * feedbackTypeView;             //反馈类型
@property (nonatomic, strong)UIView * feedbackContentView;          //反馈内容
@property (nonatomic, strong)UIView * feedbackEndView;             //剩下部分

@end

@implementation FeedbackViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    
    [self navigation];
    [self registerKeyboardStateNotification];
    [self initUserInterface];
}
#pragma mark -- 界面
- (void)initUserInterface {
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView = [UIScrollView new];
    _scrollView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 11 * W_ABCW);
    [_scrollView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 11 * W_ABCW)];
    _scrollView.backgroundColor = COLOR_BACKGRONDCOLOR;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    [_scrollView addSubview:self.feedbackTypeView];
    [_scrollView addSubview:self.feedbackContentView];
    [_scrollView addSubview:self.feedbackEndView];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _feedbackEndView.viewBottomEdge);
}

- (UIView *)feedbackTypeView {
    if (!_feedbackTypeView) {
        _feedbackTypeView = [UIView new];
        _feedbackTypeView.viewSize = CGSizeMake(SCREEN_WIDTH, 125 * W_ABCW);
        [_feedbackTypeView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        _feedbackTypeView.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeybord)];
        [_feedbackTypeView addGestureRecognizer:tap];
        
        UILabel * alertLabel = [UILabel new];
        alertLabel.viewSize = CGSizeMake(SCREEN_WIDTH - 30, 30 * W_ABCW);
        alertLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        alertLabel.font = fontForSize(13);
        alertLabel.text = @"反馈类型";
        [alertLabel sizeToFit];
        [alertLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, 15 * W_ABCW)];
        [_feedbackTypeView addSubview:alertLabel];
        
        NSArray * buttonTitleArray = @[@"商品问题", @"物流问题", @"退换货问题", @"软件问题", @"其他问题"];
        NSInteger buttonNum = 0;
        for (int i = 0; i < 2; i ++) {
            _lastButton = [[UIButton alloc] initWithFrame:CGRectMake(9 * W_ABCW, 0, 0, 0)];
            for (int j = 0; j < 4; j ++) {
                UIButton * button = [UIButton new];
                button.viewSize = CGSizeMake(50, 30);
                button.titleLabel.font = fontForSize(12);
                [button setTitle:buttonTitleArray[buttonNum] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithHex:0x6f6f6f] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithHex:0xfd5487] forState:UIControlStateSelected];
                button.layer.borderWidth = 0.5 * W_ABCW;
                button.layer.borderColor = [UIColor colorWithHex:0xe1e1e1].CGColor;
                button.layer.cornerRadius = 6;
                button.layer.masksToBounds = YES;
                button.tag = 18000 + buttonNum;
                [button.titleLabel sizeToFit];
                button.viewSize = CGSizeMake(button.titleLabel.viewWidth + 18 * W_ABCW, button.titleLabel.viewHeight + 18 * W_ABCW);
                [button align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_lastButton.viewRightEdge + 6 * W_ABCW, alertLabel.viewBottomEdge + 15 * W_ABCW + i * button.viewHeight + i * 10 * W_ABCW)];
                [_feedbackTypeView addSubview:button];
                [button addTarget:self action:@selector(clickedFeedbackTypeButton:) forControlEvents:UIControlEventTouchUpInside];
                _lastButton = button;
                buttonNum ++;
                if (buttonNum == buttonTitleArray.count) {
                    break;
                }
            }
            if (buttonNum == buttonTitleArray.count) {
                break;
            }
        }
        _lastButton = nil;
        
        //分割线
        UIView * lineView = [UIView new];
        lineView.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5 * W_ABCW);
        [lineView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _feedbackTypeView.viewHeight)];
        lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_feedbackTypeView addSubview:lineView];
        
    }
    return _feedbackTypeView;
}

- (UIView *)feedbackContentView {
    if (!_feedbackContentView) {
        _feedbackContentView = [UIView new];
        _feedbackContentView.viewSize = CGSizeMake(SCREEN_WIDTH, 157 * W_ABCW);
        [_feedbackContentView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _feedbackTypeView.viewBottomEdge + 10 * W_ABCW)];
        _feedbackContentView.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeybord)];
        [_feedbackContentView addGestureRecognizer:tap];
        
        UILabel * alertLabel = [UILabel new];
        alertLabel.viewSize = CGSizeMake(SCREEN_WIDTH - 30, 30 * W_ABCW);
        alertLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        alertLabel.font = fontForSize(13);
        alertLabel.text = @"反馈内容";
        [alertLabel sizeToFit];
        [alertLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, 15 * W_ABCW)];
        [_feedbackContentView addSubview:alertLabel];
        
        UIView * textLayerView = [UIView new];
        textLayerView.viewSize = CGSizeMake(SCREEN_WIDTH - 30 * W_ABCW, 100 * W_ABCW);
        [textLayerView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, alertLabel.viewBottomEdge + 15 * W_ABCW)];
        textLayerView.layer.borderWidth = 0.5 * W_ABCW;
        textLayerView.layer.borderColor = [UIColor colorWithHex:0xe1e1e1].CGColor;
        textLayerView.layer.cornerRadius = 6;
        textLayerView.layer.masksToBounds = YES;
        [_feedbackContentView addSubview:textLayerView];
        
        _textView = [UITextView new];
        _textView.viewSize = CGSizeMake(textLayerView.viewWidth - 10 * W_ABCW, textLayerView.viewHeight - 30 * W_ABCW);
        [_textView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(10 * W_ABCW, 15 * W_ABCW)];
        _textView.font = fontForSize(12);
        _textView.textColor = [UIColor colorWithHex:0x181818];
        _textView.delegate = self;
//        _textView.returnKeyType = UIReturnKeyDone;
        [textLayerView addSubview:_textView];
        
        _placeholderLabel = [UILabel new];
        _placeholderLabel.viewSize = CGSizeMake(100, 30);
        _placeholderLabel.font = fontForSize(12);
        _placeholderLabel.textColor = [UIColor colorWithHex:0xc8c8ce];
        _placeholderLabel.text = @"很高兴能聆听您的建议！";
        [_placeholderLabel sizeToFit];
        [_placeholderLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        [_textView addSubview:_placeholderLabel];
        
        //分割线
        UIView * lineView = [UIView new];
        lineView.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5 * W_ABCW);
        [lineView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _feedbackContentView.viewHeight)];
        lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_feedbackContentView addSubview:lineView];
        
    }
    return _feedbackContentView;
}

- (UIView *)feedbackEndView {
    if (!_feedbackEndView) {
        _feedbackEndView = [UIView new];
        _feedbackEndView.viewSize = CGSizeMake(SCREEN_WIDTH, 157 * W_ABCW);
        [_feedbackEndView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _feedbackContentView.viewBottomEdge + 10 * W_ABCW)];
        _feedbackEndView.backgroundColor = COLOR_BACKGRONDCOLOR;
        //详细地址输入框
        _contactTextField = [UITextField new];
        _contactTextField.viewSize = CGSizeMake(SCREEN_WIDTH, 45 * W_ABCW);
        _contactTextField.backgroundColor = [UIColor whiteColor];
        [_contactTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        _contactTextField.placeholder = @"手机号码/邮箱(选填)";
        _contactTextField.text = [JCUserContext sharedManager].currentUserInfo.memberName;
        _contactTextField.font = fontForSize(13);
        _contactTextField.delegate = self;
        _contactTextField.returnKeyType = UIReturnKeyDone;
        _contactTextField.textColor = [UIColor colorWithHex:0x181818];
        //创建一个左侧视图
        _contactTextField.leftViewMode = UITextFieldViewModeAlways;
        UIView * addressLeftView = [UIView new];
        addressLeftView.viewSize = CGSizeMake(93 * W_ABCW, _contactTextField.viewHeight);
        [addressLeftView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        //在左侧视图上面添加一个视图
        UILabel * addressLabel = [UILabel new];
        addressLabel.viewSize = CGSizeMake(80 * W_ABCW, addressLeftView.viewHeight);
        [addressLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, 0)];
        addressLabel.font = fontForSize(13);
        addressLabel.text = @"联系方式:";
        addressLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        [addressLeftView addSubview:addressLabel];
        //将左侧视图添加到TextField上
        _contactTextField.leftView = addressLeftView;
        [_feedbackEndView addSubview:_contactTextField];
        
        //分割线
        UIView * lineView = [UIView new];
        lineView.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5 * W_ABCW);
        [lineView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _contactTextField.viewBottomEdge)];
        lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_feedbackEndView addSubview:lineView];
        
        _submitButton = [UIButton new];
        _submitButton.viewSize = CGSizeMake(SCREEN_WIDTH - 30 * W_ABCW, 45 * W_ABCW);
        [_submitButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, lineView.viewBottomEdge + 20 * W_ABCW)];
        [_submitButton setBackgroundColor:[UIColor colorWithHex:0xfd5478]];
        [_submitButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(clickedsubmitButton) forControlEvents:UIControlEventTouchUpInside];
        [_feedbackEndView addSubview:_submitButton];
        
        _feedbackEndView.viewSize = CGSizeMake(SCREEN_WIDTH, _submitButton.viewBottomEdge + 20 * W_ABCW);
    }
    return _feedbackEndView;
}

#pragma mark -- UITextViewDelegate 
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _placeholderLabel.hidden = YES;
    //随意定义的textFiled  无视就好【用于键盘】
    _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, _feedbackContentView.viewBottomEdge - 30 , SCREEN_WIDTH, 30)];
    return YES;
}
//
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
//    [self.view endEditing:YES];
//    return YES;
//}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.view endEditing:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView == _textView) {
        if (textView.text.length == 0) {
            if ([text isEqualToString:@""]) {
                _placeholderLabel.hidden = NO;
                [self.view endEditing:YES];
            }
            else {
                _placeholderLabel.hidden = YES;
            }
        }
        else {
            _placeholderLabel.hidden = YES;
        }
//        if ([text isEqualToString:@"\n"]) {
//            [self.view endEditing:YES];
//            return NO;
//        }
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _inputTextField = textField;
    return YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark -- 点击
/**
 *  点击选择反馈类型
 */
- (void)clickedFeedbackTypeButton:(UIButton *)sender {
    [self.view endEditing:YES];
    if (_textView.text.length == 0) {
        _placeholderLabel.hidden = NO;
    }
    _lastButton.selected = NO;
    _lastButton.layer.borderColor = [UIColor colorWithHex:0x6f6f6f].CGColor;
    sender.selected = !sender.selected;
    _lastButton = sender;
    if (sender.selected) {
        sender.layer.borderColor = [UIColor colorWithHex:0xfd5478].CGColor;
    }
    switch (sender.tag) {
        case 18000:
            _type = @"10";
            break;
        case 18001:
            _type = @"20";
            break;
        case 18002:
            _type = @"30";
            break;
        case 18003:
            _type = @"40";
            break;
        case 18004:
            _type = @"50";
            break;
            
        default:
            break;
    }
}
/**
 *  点击提交按钮
 */
- (void)clickedsubmitButton {
    [self.view endEditing:YES];
    if (!_lastButton) {
        SHOW_MSG(@"请选择反馈的类型");
        return;
    }
    if (_textView.text.length == 0) {
        SHOW_MSG(@"请输入您的意见");
        return;
    }
    if (_contactTextField.text.length == 0) {
        SHOW_MSG(@"请输入您的联系方式");
        return;
    }
    if (!([TYTools isValidateEmail:_contactTextField.text] || [TYTools isMobileNumber:_contactTextField.text])) {
        SHOW_MSG(@"联系方式为邮箱或手机号");
        return;
    }
    
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"FeedBack" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"type":_type, @"content":_textView.text, @"phone":_contactTextField.text, @"name":[JCUserContext sharedManager].currentUserInfo.memberName} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            SHOW_MSG(@"提交成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            SHOW_MSG(@"提交失败");
        }
    }];
}

- (void)hiddenKeybord {
    [self.view endEditing:YES];
    if (_textView.text.length == 0) {
        _placeholderLabel.hidden = NO;
    }
}

- (void)back {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 键盘
/**
 *  注册键盘状态通知
 */
- (void)registerKeyboardStateNotification {
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

//键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat textFieldBottonEdge = 0;
    if (_scrollView.contentOffset.y > 0) {
        textFieldBottonEdge = _inputTextField.viewBottomEdge + _inputTextField.superview.viewY - _scrollView.contentOffset.y;
    }
    else {
        textFieldBottonEdge = _inputTextField.viewBottomEdge + _inputTextField.superview.viewY;
    }
    
    CGFloat offset = textFieldBottonEdge - (SCREEN_HEIGHT - kbHeight - 40);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset >= 0) {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    }
    else {
        [UIView animateWithDuration:duration animations:^{
            self.view.frame = CGRectMake(0.0f, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
