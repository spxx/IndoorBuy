//
//  VIPActivationViewController.m
//  BMW
//
//  Created by 白琴 on 16/3/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//
/**
 *  会员激活
 */

#import "VIPActivationViewController.h"
#import "VIPIntroductionsViewController.h"
#import "GotoVipViewController.h"
#import "WaitApplyViewController.h"
#import "SYQRCodeViewController.h"

@interface VIPActivationViewController () <UITextFieldDelegate, UIScrollViewDelegate> {
    UIScrollView * _scrollView;
    UITextField * _textField;
    UIButton * _nextStepButton;
    UITextField * _inputTextField;
    UITextField * _memberCardNumTextField;          //会员卡号
    UITextField * _memberNameTextField;             //姓名
//    UITextField * _IDCardNumTextField;              //身份证号
    UITextField * _drpNameTextField;                //分销商名称
    UITextField * _drpCodeTextField;                //分销商编号
    UIButton * _agreeProtocolButton;                //查看协议按钮
    
}

@end

@implementation VIPActivationViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员激活";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self navigation];
    [self registerKeyboardStateNotification];
    [self initUserInterface];
    [self initdata];
}

-(void)initdata{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"ActivateShow" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSLog(@"%@",object);
            if([[object[@"data"] objectForKeyNotNull:@"drp_recommend"] length]>0){
                _drpCodeTextField.text = [object[@"data"] objectForKeyNotNull:@"drp_recommend"];
                _drpCodeTextField.userInteractionEnabled = NO;
            }
            if([[object[@"data"] objectForKeyNotNull:@"drp_origin_name"] length]>0){
                _drpNameTextField.text = [object[@"data"] objectForKeyNotNull:@"drp_origin_name"];
                _drpNameTextField.userInteractionEnabled = NO;
            }
        }
    }];
}

#pragma mark -- 界面
/**
 *  基本界面
 */
- (void)initUserInterface {
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView = [UIScrollView new];
    _scrollView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 65 * W_ABCW );
    [_scrollView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
    _scrollView.backgroundColor = COLOR_BACKGRONDCOLOR;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    
    UIView * textFieldView = [UIView new];
    textFieldView.viewSize = CGSizeMake(SCREEN_WIDTH, 45 * W_ABCW * 6 * W_ABCW);
    [textFieldView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 10 * W_ABCW)];
    textFieldView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:textFieldView];
    //会员卡号
    [self textFieldWithLeftPoint:CGPointMake(0, 0) nameText:@"会员卡号:" placeText:@"请输入卡号(选填)" tag:16000 rightView:NO loadView:textFieldView];
    //姓名
    [self textFieldWithLeftPoint:CGPointMake(0, 45.5 * W_ABCW) nameText:@"姓名:" placeText:@"请输入真实姓名(必填)" tag:16001 rightView:NO loadView:textFieldView];
//    身份证号
//    [self textFieldWithLeftPoint:CGPointMake(0, 91 * W_ABCW) nameText:@"身份证号:" placeText:@"请输入正确的身份号(必填)" tag:16002 rightView:NO loadView:textFieldView];
    //分销商名称
    [self textFieldWithLeftPoint:CGPointMake(0, 91 * W_ABCW) nameText:@"分销商名称:" placeText:@"请输入分销商名称(必填)" tag:16003 rightView:NO loadView:textFieldView];
    //分销商编号
    [self textFieldWithLeftPoint:CGPointMake(0, 136.5 * W_ABCW) nameText:@"分销商编号:" placeText:@"请输入分销商编号(必填)" tag:16004 rightView:NO loadView:textFieldView];
    _memberCardNumTextField = ((UITextField *)[self.view viewWithTag:16000]);
    _memberNameTextField = ((UITextField *)[self.view viewWithTag:16001]);
//    _IDCardNumTextField = ((UITextField *)[self.view viewWithTag:16002]);
    _drpNameTextField = ((UITextField *)[self.view viewWithTag:16003]);
    _drpCodeTextField = ((UITextField *)[self.view viewWithTag:16004]);
    textFieldView.viewSize = CGSizeMake(SCREEN_WIDTH, _drpCodeTextField.viewBottomEdge);
    
    //二维码
    _drpCodeTextField.rightViewMode = UITextFieldViewModeAlways;
    _drpCodeTextField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35 * W_ABCW, _drpCodeTextField.viewHeight)];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickedErWeiMa)];
    [_drpCodeTextField.rightView addGestureRecognizer:tap];
    UIImageView * erWeiMaImageView = [UIImageView new];
    erWeiMaImageView.viewSize = CGSizeMake(18.5 * W_ABCW, 17.5 * W_ABCW);
    [erWeiMaImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15 * W_ABCW, (_drpCodeTextField.viewHeight - erWeiMaImageView.viewHeight) / 2)];
    erWeiMaImageView.image = [UIImage imageNamed:@"icon_erweima_grzc"];
    erWeiMaImageView.userInteractionEnabled = YES;
    [_drpCodeTextField addSubview:erWeiMaImageView];
    UIButton * erWeiMaButton = [UIButton new];
    erWeiMaButton.viewSize = CGSizeMake(50 * W_ABCW, _drpCodeTextField.viewHeight);
    [erWeiMaButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH, 0)];
    erWeiMaButton.backgroundColor = [UIColor clearColor];
    [erWeiMaButton addTarget:self action:@selector(ClickedErWeiMa) forControlEvents:UIControlEventTouchUpInside];
    [_drpCodeTextField addSubview:erWeiMaButton];
    
    
    //查看协议按钮
    
    _agreeProtocolButton = [UIButton new];
    _agreeProtocolButton.viewSize = CGSizeMake(17 * W_ABCW, 17 * W_ABCW);
    [_agreeProtocolButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, textFieldView.viewBottomEdge + 12 * W_ABCW)];
    [_agreeProtocolButton setBackgroundImage:[UIImage imageNamed:@"icon_gouxuan_nor_zc"] forState:UIControlStateNormal];
    [_agreeProtocolButton setBackgroundImage:[UIImage imageNamed:@"icon_gouxuan_cli_zc"] forState:UIControlStateSelected];
    [_agreeProtocolButton addTarget:self action:@selector(processVIPButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_agreeProtocolButton];
    _agreeProtocolButton.selected = YES;
    
    UILabel * alertLabel1 = [UILabel new];
    alertLabel1.viewSize = CGSizeMake(100, 30);
    alertLabel1.text = @"已阅读并同意帮麦会员协议";
    alertLabel1.font = fontForSize(11);
    alertLabel1.textColor = [UIColor colorWithHex:0x6f6f6f];
    [alertLabel1 sizeToFit];
    [alertLabel1 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_agreeProtocolButton.viewRightEdge + 8 * W_ABCW, textFieldView.viewBottomEdge + 15 * W_ABCW)];
    [_scrollView addSubview:alertLabel1];
    //协议按钮
    UIButton * protocolButton = [UIButton new];
    protocolButton.viewSize = CGSizeMake(140, 30);
    [protocolButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_agreeProtocolButton.viewRightEdge, textFieldView.viewBottomEdge + 5 * W_ABCW)];
    [protocolButton addTarget:self action:@selector(processVIPButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:protocolButton];
    
    
    _nextStepButton = [UIButton new];
    _nextStepButton.viewSize = CGSizeMake(SCREEN_WIDTH - 30 * W_ABCW, 45 * W_ABCW);
    [_nextStepButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, alertLabel1.viewBottomEdge + 20 * W_ABCW)];
    [_nextStepButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xcccccc] andSize:_nextStepButton.viewSize] forState:UIControlStateNormal];
    [_nextStepButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xfd5478] andSize:_nextStepButton.viewSize] forState:UIControlStateSelected];
    [_nextStepButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    [_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextStepButton addTarget:self action:@selector(clickedNextStepButton) forControlEvents:UIControlEventTouchUpInside];
    _nextStepButton.userInteractionEnabled = NO;
    [_scrollView addSubview:_nextStepButton];
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _nextStepButton.viewBottomEdge + 12 * W_ABCW);
}
/**
 *  特定格式的输入框
 *
 *  @param leftPoint   距离左上角的点
 *  @param nameString  标题
 *  @param placeString 提示文字
 *  @param tag         tag值
 *  @param rightView   右视图
 *  @param loadView    加载在哪一个视图
 */
- (void)textFieldWithLeftPoint:(CGPoint)leftPoint nameText:(NSString *)nameString placeText:(NSString *)placeString tag:(NSInteger)tag rightView:(BOOL)rightView loadView:(UIView *)loadView{
    _textField = [UITextField new];
    _textField.viewSize = CGSizeMake(SCREEN_WIDTH, 45 * W_ABCW);
    [_textField align:ViewAlignmentTopLeft relativeToPoint:leftPoint];
    _textField.placeholder = placeString;
    _textField.font = fontForSize(13);
    _textField.textColor = [UIColor colorWithHex:0x181818];
    _textField.delegate = self;
    _textField.tag = tag;
    [loadView addSubview:_textField];
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    UIView * addressLeftView = [UIView new];
    addressLeftView.viewSize = CGSizeMake(93 * W_ABCW, _textField.viewHeight);
    [addressLeftView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
    //在左侧视图上面添加一个视图
    UILabel * addressLabel = [UILabel new];
    addressLabel.viewSize = CGSizeMake(80 * W_ABCW, addressLeftView.viewHeight);
    [addressLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, 0)];
    addressLabel.font = fontForSize(13);
    addressLabel.text = nameString;
    addressLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    [addressLeftView addSubview:addressLabel];
    //将左侧视图添加到TextField上
    _textField.leftView = addressLeftView;
    if (rightView) {
        //配置右侧显示密码按钮
        _textField.secureTextEntry = YES;
        _textField.rightViewMode = UITextFieldViewModeAlways;
        UIView * passwordRightView = [UIView new];
        passwordRightView.viewSize = CGSizeMake(40 * W_ABCW, _textField.viewHeight);
        [passwordRightView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        UIButton * showPasswordButton = [UIButton new];
        showPasswordButton.viewSize = CGSizeMake(16 * W_ABCW, 12 * W_ABCW);
        [showPasswordButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(passwordRightView.viewRightEdge - 15 * W_ABCW, (passwordRightView.viewHeight - showPasswordButton.viewHeight) / 2)];
        [showPasswordButton setBackgroundImage:[UIImage imageNamed:@"icon_xianshimima_nor"] forState:UIControlStateNormal];
        [showPasswordButton setBackgroundImage:[UIImage imageNamed:@"icon_xianshimima_cli"] forState:UIControlStateSelected];
        [showPasswordButton addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
        [passwordRightView addSubview:showPasswordButton];
        _textField.rightView = passwordRightView;
    }
    //分割线
    UIView * lineView1 = [UIView new];
    lineView1.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5 * W_ABCW);
    [lineView1 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _textField.viewBottomEdge)];
    lineView1.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [loadView addSubview:lineView1];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //姓名
    if (textField.tag == 16001) {
        if (![string isEqualToString:@""]) {
            //_IDCardNumTextField.text.length > 0 &&
            if (_agreeProtocolButton.selected == YES && _drpCodeTextField.text.length > 0 && _drpNameTextField.text.length > 0) {
                _nextStepButton.selected = YES;
            }
        }
        else if (textField.text.length - 1 == 0) {
            _nextStepButton.selected = NO;
        }
    }
//    //身份证号
//    if (textField.tag == 16002) {
//        if (![string isEqualToString:@""]) {
//            if (_memberNameTextField.text.length > 0 && _drpNameTextField.text.length > 0 && _drpCodeTextField.text.length > 0 && _agreeProtocolButton.selected == YES) {
//                _nextStepButton.selected = YES;
//            }
//        }
//        else if (textField.text.length - 1 == 0) {
//            _nextStepButton.selected = NO;
//        }
//    }
    //分销商名称
    if (textField.tag == 16003) {
        if (![string isEqualToString:@""]) {
            //_IDCardNumTextField.text.length > 0 &&
            if (_memberNameTextField.text.length > 0 && _drpCodeTextField.text.length > 0 && _agreeProtocolButton.selected == YES) {
                _nextStepButton.selected = YES;
            }
        }
    }
    //分销商编号
    if (textField.tag == 16004) {
        if (![string isEqualToString:@""]) {
            //_IDCardNumTextField.text.length > 0 &&
            if (_memberNameTextField.text.length > 0 && _drpNameTextField.text.length > 0 && _agreeProtocolButton.selected == YES) {
                _nextStepButton.selected = YES;
            }
        }
    }
    _nextStepButton.userInteractionEnabled = _nextStepButton.selected;
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
 * 点击协议
 */
- (void)processVIPButton:(UIButton *)sender {
    NSLog(@"点击协议");
    VIPIntroductionsViewController * vip = [[VIPIntroductionsViewController alloc] init];
    vip.isProtocol = YES;
    [self.navigationController pushViewController:vip animated:YES];
}
/**
 *  显示密码
 */
- (void)showPassword:(UIButton *)sender {
    sender.selected = !sender.selected;
}
/**
 *  点击下一步
 */
- (void)clickedNextStepButton {
    NSLog(@"点击下一步");
    [self.view endEditing:YES];
    if (_memberNameTextField.text.length == 0 || _drpCodeTextField.text.length == 0 || _drpNameTextField.text.length == 0) {
        SHOW_MSG(@"请填写完整资料");
        return;
    }
    //调用判断会员卡号是否为必填
    if(_drpCodeTextField.userInteractionEnabled){
        [self judgeIDNumberIsRequired];
    }else{
        [self VIPActivationRequest];
    }
}

- (void)ClickedErWeiMa {
    [self.view endEditing:YES];
    NSLog(@"点击获取分销商编号的二维码");
    SYQRCodeViewController * QRCodeVC = [[SYQRCodeViewController alloc]init];
    
    WEAK_SELF;
    [QRCodeVC setSYQRCodeSuncessBlock:^(SYQRCodeViewController * QRVC, NSString * drqCodeString) {
        NSString *recommid = [TYTools AES128Decrypt:drqCodeString];
        recommid = [recommid stringByReplacingOccurrencesOfString:@"\0" withString:@""];
        NSDictionary * dic = @{@"code":recommid,@"vc":QRVC};
        [weakSelf performSelector:@selector(dismissVCWith:) withObject:dic afterDelay:0.3];
    }];
    QRCodeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:QRCodeVC animated:YES];
}
-(void)dismissVCWith:(NSDictionary *)sender
{
    UIViewController * vc = sender[@"vc"];
    [vc.navigationController popViewControllerAnimated:YES];
    
    NSString * code = sender[@"code"];
    if (code == nil || code.length == 0) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未找到该分销商" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
         _drpCodeTextField.text = code;
        //_IDCardNumTextField.text.length > 0 &&
        if (_drpNameTextField.text.length > 0 && _memberNameTextField.text.length > 0 && _agreeProtocolButton.selected == YES) {
            _nextStepButton.selected = YES;
            _nextStepButton.userInteractionEnabled = YES;
        }
    }
   
}

#pragma mark -- 网络请求
/**
 *  判断会员卡号是否为必填
 */
- (void)judgeIDNumberIsRequired {
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithDPMethod:nil parameters:@{@"drp_code":_drpCodeTextField.text} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            if ([object[@"data"] integerValue] == 1 && _memberCardNumTextField.text.length == 0) {
                [self.HUD hide:YES];
                SHOW_MSG(@"该分销商下的会员卡号必填");
            }
            else {
                [self VIPActivationRequest];
            }
        }else if(result == RequestResultException){
            [self.HUD hide:YES];
            SHOW_EEROR_MSG(object);
        }
        else {
            [self.HUD hide:YES];
            NSLog(@"操作失败 == %@", object[@"msg"]);
        }
    }];
}

/**
 *  会员激活
 */
- (void)VIPActivationRequest {
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"phone":[JCUserContext sharedManager].currentUserInfo.memberName, @"name":_memberNameTextField.text, @"drpName":_drpNameTextField.text, @"drpCode":_drpCodeTextField.text}];
    if (_memberCardNumTextField.text.length != 0) {
        [dic setObject:_memberCardNumTextField.text forKey:@"cardNum"];
    }
    
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"ActivateCard" parameters:dic callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result == RequestResultSuccess) {
            GotoVipViewController * gotoVC = [[GotoVipViewController alloc] init];
            gotoVC.joinOrRegis = YES;
            gotoVC.isVIP = NO;
            gotoVC.orderInfoDic = object[@"data"];
            [self.navigationController pushViewController:gotoVC animated:YES];
        }
        else if (result == RequestResultFailed) {
            NSLog(@"彻底失败了，原因=== %@", object);
        }
        else if([object[@"code"] integerValue] == 901) {
            if (((NSString *)object[@"data"]).length == 0) {
                SHOW_EEROR_MSG(object[@"message"]);
            }
            else {
                SHOW_EEROR_MSG(object[@"data"]);
            }
            
        }
    }];
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
    
    CGFloat offset = textFieldBottonEdge - (SCREEN_HEIGHT - kbHeight - 64);
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
