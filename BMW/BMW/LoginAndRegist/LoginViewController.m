//
//  LoginViewController.m
//  BMW
//
//  Created by 白琴 on 16/1/29.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "FindPasswordViewController.h"
//#import <TencentOpenAPI/TencentOAuth.h>
//#import "QQTools.h"
//#import "WXApi.h"
//#import "WeiboSDK.h"
#import "UITabBar+BadgeColor.h"
#import "GoinShopViewController.h"

@interface LoginViewController () <UITextFieldDelegate>{
//    TencentOAuth * _tencentOAuth;
    UITextField * _mobileTextField;
    UITextField * _passwordTextField;
    UITextField * _codeTextField;
    UIButton * _getCodeButton;
    UIButton * _loginButton;
    NSInteger _loginCount;              //登录次数【超过3次出现验证码】
    UIButton * _showPasswordButton;
    
    NSInteger _count;
    NSTimer * _timer;
}

@property (nonatomic, strong)UIView * whiteView;
@property (nonatomic, strong)UIView * endView;
@property (nonatomic, strong)UIView * codeView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    //配置导航栏的右侧按钮
    UIButton * registButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registButton setTitle:@"注册" forState:UIControlStateNormal];
    registButton.viewSize = CGSizeMake(50, 50);
    [registButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH + 50, 0)];
    registButton.titleLabel.font = fontForSize(15);
    [registButton setTitleColor:COLOR_NAVIGATIONBAR_ITEM forState:UIControlStateNormal];
    [registButton addTarget:self action:@selector(clickedRegistButton) forControlEvents:UIControlEventTouchUpInside];
    registButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem * registBtnItem = [[UIBarButtonItem alloc] initWithCustomView:registButton];
    self.navigationItem.rightBarButtonItem = registBtnItem;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = COLOR_NAVIGATIONBAR_BARTINT;
    
    
    [self navigation];
    [self initUserInterface];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - - 界面
/**
 *  初始化界面【界面布局】
 */
- (void)initUserInterface {
    
    _loginCount = 0;
    
    [self.view addSubview:self.whiteView];
    [self.view addSubview:self.endView];
}

- (UIView *)whiteView {
    if (!_whiteView) {
        //白色的背景View
        _whiteView = [UIView new];
        _whiteView.viewSize = CGSizeMake(SCREEN_WIDTH, 100);
        [_whiteView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 10)];
        _whiteView.backgroundColor = [UIColor whiteColor];
        
        //手机号码输入框
        _mobileTextField = [UITextField new];
        _mobileTextField.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_mobileTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        _mobileTextField.placeholder = @"请输入手机号码";
        _mobileTextField.font = fontForSize(13);
        _mobileTextField.delegate = self;
        _mobileTextField.textColor = [UIColor colorWithHex:0x181818];
        _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
        //创建一个左侧视图
        _mobileTextField.leftViewMode = UITextFieldViewModeAlways;
        UIView * mobileLeftView = [UIView new];
        mobileLeftView.viewSize = CGSizeMake(42, _mobileTextField.viewHeight);
        [mobileLeftView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        //在左侧视图上面添加一个图片视图
        UIImageView * mobileImageView = [UIImageView new];
        mobileImageView.viewSize = CGSizeMake(15, 22);
        [mobileImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, (mobileLeftView.viewHeight - mobileImageView.viewHeight) / 2)];
        [mobileImageView setImage:[UIImage imageNamed:@"icon_shouji_dl"]];
        [mobileLeftView addSubview:mobileImageView];
        //将左侧视图添加到TextField上
        _mobileTextField.leftView = mobileLeftView;
        [_whiteView addSubview:_mobileTextField];
        //分割线
        UIView * lineView = [UIView new];
        lineView.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [lineView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 40)];
        lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_whiteView addSubview:lineView];
        //密码输入框
        _passwordTextField = [UITextField new];
        _passwordTextField.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_passwordTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, lineView.viewBottomEdge)];
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.font = fontForSize(13);
        _passwordTextField.textColor = [UIColor colorWithHex:0x181818];
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.delegate = self;
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        _passwordTextField.rightViewMode = UITextFieldViewModeAlways;
        UIView * passwordLeftView = [UIView new];
        passwordLeftView.viewSize = CGSizeMake(42, _passwordTextField.viewHeight);
        [passwordLeftView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
        UIImageView * passwordImageView = [UIImageView new];
        passwordImageView.viewSize = CGSizeMake(14, 18);
        [passwordImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, (passwordLeftView.viewHeight - passwordImageView.viewHeight) / 2)];
        [passwordImageView setImage:[UIImage imageNamed:@"icon_mima_dl"]];
        [passwordLeftView addSubview:passwordImageView];
        _passwordTextField.leftView = passwordLeftView;
        [_whiteView addSubview:_passwordTextField];
        //配置右侧显示密码按钮
        UIButton * passwordRightView = [UIButton new];
        passwordRightView.viewSize = CGSizeMake(40, _passwordTextField.viewHeight);
        [passwordRightView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        _showPasswordButton = [UIButton new];
        _showPasswordButton.viewSize = CGSizeMake(16, 12);
        [_showPasswordButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(passwordRightView.viewRightEdge - 15, (passwordRightView.viewHeight - _showPasswordButton.viewHeight) / 2)];
        [_showPasswordButton setBackgroundImage:[UIImage imageNamed:@"icon_xianshimima_nor"] forState:UIControlStateNormal];
        [_showPasswordButton setBackgroundImage:[UIImage imageNamed:@"icon_xianshimima_cli"] forState:UIControlStateSelected];
        [_showPasswordButton addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
        [passwordRightView addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
        [passwordRightView addSubview:_showPasswordButton];
        _passwordTextField.rightView = passwordRightView;
        
        //分割线
        UIView * lineView1 = [UIView new];
        lineView1.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [lineView1 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _passwordTextField.viewBottomEdge)];
        lineView1.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_whiteView addSubview:lineView1];
        
        //重新计算白色背景视图的高度
        _whiteView.viewSize = CGSizeMake(SCREEN_WIDTH, lineView1.viewBottomEdge);
    }
    return _whiteView;
}

- (UIView *)endView {
    if (!_endView) {
        _endView = [UIView new];
        _endView.viewSize = CGSizeMake(SCREEN_WIDTH, 100);
        [_endView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _whiteView.viewBottomEdge + 12)];
        
        //忘记密码按钮
        UILabel * findPasswordLabel = [UILabel new];
        findPasswordLabel.viewSize = CGSizeMake(100, 30);
        findPasswordLabel.font = fontForSize(12);
        findPasswordLabel.textColor = [UIColor colorWithHex:0x6f6f6f];
        findPasswordLabel.text = @"忘记密码?";
        [findPasswordLabel sizeToFit];
        [findPasswordLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, 0)];
        [_endView addSubview:findPasswordLabel];
        
        UIButton * findPasswordButton = [UIButton new];
        findPasswordButton.viewSize = CGSizeMake(100, 40);
        [findPasswordButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 5, 0)];
        [findPasswordButton addTarget:self action:@selector(findPasswordButton) forControlEvents:UIControlEventTouchUpInside];
        [findPasswordButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_endView addSubview:findPasswordButton];
        
        
        //登录按钮
        _loginButton = [UIButton new];
        _loginButton.viewSize = CGSizeMake(SCREEN_WIDTH - 30, 45);
        [_loginButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, findPasswordLabel.viewBottomEdge + 20)];
        [_loginButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xcccccc] andSize:_loginButton.viewSize] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xfd5478] andSize:_loginButton.viewSize] forState:UIControlStateSelected];
        [_loginButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(clickedLoginButton) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.userInteractionEnabled = NO;
        [_endView addSubview:_loginButton];
        
        _endView.viewSize = CGSizeMake(SCREEN_WIDTH, _loginButton.viewBottomEdge);
    }
    return _endView;
}

- (UIView *)codeView {
    if (!_codeView) {
        _codeView = [UIView new];
        _codeView.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        _codeView.backgroundColor = [UIColor whiteColor];
        [_codeView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _whiteView.viewBottomEdge)];
        //密码输入框
        _codeTextField = [UITextField new];
        _codeTextField.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_codeTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.font = fontForSize(13);
        _codeTextField.textColor = [UIColor colorWithHex:0x181818];
        _codeTextField.delegate = self;
        _codeTextField.leftViewMode = UITextFieldViewModeAlways;
        _codeTextField.rightViewMode = UITextFieldViewModeAlways;
        UIView * codeLeftView = [UIView new];
        codeLeftView.viewSize = CGSizeMake(42, _codeTextField.viewHeight);
        [codeLeftView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
        UIImageView * codeImageView = [UIImageView new];
        codeImageView.viewSize = CGSizeMake(14, 16);
        [codeImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, (codeLeftView.viewHeight - codeImageView.viewHeight) / 2)];
        [codeImageView setImage:[UIImage imageNamed:@"icon_yanzhengma_zc"]];
        [codeLeftView addSubview:codeImageView];
        _codeTextField.leftView = codeLeftView;
        [_codeView addSubview:_codeTextField];
        //配置右侧显示密码按钮
        UIView * codeRightView = [UIView new];
        codeRightView.viewSize = CGSizeMake(119, _codeTextField.viewHeight);
        [codeRightView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        _getCodeButton = [UIButton new];
        _getCodeButton.viewSize = CGSizeMake(84, 31);
        [_getCodeButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(codeRightView.viewRightEdge - 15, (codeRightView.viewHeight - _getCodeButton.viewHeight) / 2)];
        [_getCodeButton setBackgroundImage:[UIImage imageNamed:@"icon_yanzhengkuang_zc"] forState:UIControlStateNormal];
        [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getCodeButton setTitleColor:[UIColor colorWithHex:0x181818] forState:UIControlStateSelected];
        [_getCodeButton addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
        [_getCodeButton setTitleColor:[UIColor colorWithHex:0xc8c8ce] forState:UIControlStateNormal];
        _getCodeButton.titleLabel.font = fontForSize(13);
        [codeRightView addSubview:_getCodeButton];
        _codeTextField.rightView = codeRightView;
        //分割线
        UIView * lineView1 = [UIView new];
        lineView1.viewSize = CGSizeMake(SCREEN_WIDTH, 1);
        [lineView1 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _codeTextField.viewBottomEdge)];
        lineView1.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_codeView addSubview:lineView1];
    }
    return _codeView;
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //手机号
    if (textField == _mobileTextField) {
        if ((textField.text.length == 10&&![string isEqualToString:@""]) || string.length == 11) {
            if (_passwordTextField.text.length > 5) {
                _loginButton.selected = YES;
                _loginButton.userInteractionEnabled = YES;
            }
        }
        else if (textField.text.length >10)
        {
            if([string isEqualToString:@""])
            {
                _loginButton.selected = NO;
                _loginButton.userInteractionEnabled = YES;
                return YES;
            }
            _loginButton.userInteractionEnabled = _loginButton.selected;
            return NO;
        }
    }
    //密码
    if (textField == _passwordTextField) {
        if (textField.text.length > 11) {
            if ([string isEqualToString:@""]) {
                _loginButton.userInteractionEnabled = _loginButton.selected;
                return YES;
            }
            _loginButton.userInteractionEnabled = _loginButton.selected;
            return NO;
        }
        else if ((textField.text.length-6==0||textField.text.length-5==0)&&[string isEqualToString:@""]){
            _loginButton.selected = NO;
        }
        else if (textField.text.length > 4)
        {
            if (_mobileTextField.text.length == 11) {
                _loginButton.selected = YES;
                _loginButton.userInteractionEnabled = YES;
            }
        }
        else
        {
            _loginButton.selected = NO;
        }
    }
    _loginButton.userInteractionEnabled = _loginButton.selected;
    
    return YES;
}

#pragma mark -- 网络请求

/**
 *  获取验证码
 */
- (void)getCodeRequest {
    [self.view endEditing:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"RegisterVerifyCode" parameters:@{@"mobile":_mobileTextField.text} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSLog(@"获取成功");
            _getCodeButton.userInteractionEnabled = NO;
            _count = 60;
            _getCodeButton.selected = NO;
            [_getCodeButton setTitle:[NSString stringWithFormat:@"%ld秒",(long)_count] forState:UIControlStateNormal];
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduce:) userInfo:nil repeats:YES];
            [_timer fire];
        }
        else if (result == RequestResultEmptyData) {
            NSLog(@"%@", object);
        }
        else if (result == RequestResultFailed){
            NSLog(@"%@", object);
        }
        else if ([object[@"code"] integerValue] == 906) {
            [MBProgressHUD show:@"手机号码格式错误" toView:self.view];
        }
    }];
}
#pragma mark - - 点击事件
/**
 *  点击登录按钮
 */
- (void)clickedLoginButton {
    [self.HUD show:YES];
    [self.view endEditing:YES];
    NSDictionary * dic;
    if ([JCUserContext sharedManager].pushKey) {
        dic = @{@"mobile":_mobileTextField.text, @"password":_passwordTextField.text, @"pushkey":[JCUserContext sharedManager].pushKey};
    }
    else {
        dic = @{@"mobile":_mobileTextField.text, @"password":_passwordTextField.text};
    }
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"Login" parameters:dic callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result == RequestResultSuccess) {
            Userentity *user = [[Userentity alloc] initWithJSONObject:object[@"data"]];
            [[JCUserContext sharedManager] updateUserInfo:user];
            [BaseRequset sendPOSTRequestWithBMWApi2Method:@"CartNum" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
                RootTabBarVC *tabbar = ROOTVIEWCONTROLLER;
                UINavigationController *shoppNAVC = tabbar.viewControllers[2];
                if (result==RequestResultSuccess) {
                    if([[NSString stringWithFormat:@"%@",object[@"data"]] isEqualToString:@""]){
                        [shoppNAVC.tabBarController.tabBar hideBadgeOnItemIndex];
                    }else{
                        [shoppNAVC.tabBarController.tabBar showBadgeOnItemIndex:[object[@"data"] intValue]];
                    }
                }else if (result==RequestResultEmptyData){
                    [shoppNAVC.tabBarController.tabBar hideBadgeOnItemIndex];
                }
            }];
            //登陆成功之后走绑定店铺
            if (![[JCUserContext sharedManager].currentUserInfo.drp_recommend boolValue]) {
                if ([[JCUserContext sharedManager].currentUserInfo.vip_level integerValue]==0) {
                    if(![[JCUserContext sharedManager].currentUserInfo.store_id boolValue]){
                        GoinShopViewController *goinVC = [[GoinShopViewController alloc] init];
                        goinVC.hidesBottomBarWhenPushed = YES;
                        goinVC.navigationController.navigationItem.hidesBackButton = YES;
                        [self.navigationController pushViewController:goinVC animated:YES];
                    }else{
                        if (_isPresent) {
                            [self dismissViewControllerAnimated:YES completion:^{
                                RootTabBarVC *tabbarVC =  ROOTVIEWCONTROLLER;
                                tabbarVC.selectedIndex = 2;
                            }];
                        }else{
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }
                }else{
                    if (_isPresent) {
                        [self dismissViewControllerAnimated:YES completion:^{
                            RootTabBarVC *tabbarVC =  ROOTVIEWCONTROLLER;
                            tabbarVC.selectedIndex = 2;
                        }];
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            }else{
                if (_isPresent) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        RootTabBarVC *tabbarVC =  ROOTVIEWCONTROLLER;
                        tabbarVC.selectedIndex = 2;
                    }];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
        else if (result == RequestResultEmptyData) {
            NSLog(@"%@", object);
        }else if (result == RequestResultFailed){
            [MBProgressHUD show:object toView:self.view];
            _loginCount ++;
        }

    }];
}
/**
 *  点击注册按钮
 */
- (void)clickedRegistButton {
    RegistViewController * registVC = [[RegistViewController alloc] init];
    if (_isPresent) {
        registVC.isPrsent = _isPresent;
    }
    [self.navigationController pushViewController:registVC animated:YES];
}
/**
 *  点击忘记密码按钮
 */
- (void)findPasswordButton {
    FindPasswordViewController * findPasswordVC = [[FindPasswordViewController alloc] init];
    if (_isPresent) {
        findPasswordVC.isPrsent = _isPresent;
    }
    findPasswordVC.isPayPassword = NO;
    findPasswordVC.isPayVC = NO;
    [self.navigationController pushViewController:findPasswordVC animated:YES];
}
/**
 *  显示密码
 */
- (void)showPassword:(UIButton *)sender {
    sender.selected = !sender.selected;
    _showPasswordButton.selected = sender.selected;
    if (sender.selected) {
        _passwordTextField.secureTextEntry = NO;
    }
    else {
        _passwordTextField.secureTextEntry = YES;
    }
    
}
/**
 *  获取验证码
 */
- (void)getCode:(UIButton *)sender {
    [self getCodeRequest];
}
/**
 *  返回
 */
- (void)back {
    if (self.isRegistPush) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        if (_isPresent) {
            [self dismissViewControllerAnimated:YES completion:^{
//                RootTabBarVC *tabbarVC =  ROOTVIEWCONTROLLER;
//                tabbarVC.selectedIndex = 2;
                
            }];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma mark - - 其他
/**
 *  倒计时
 *
 *  @param time <#time description#>
 */
- (void)reduce:(NSTimer *)time
{
    if (_count == 0) {
        _getCodeButton.selected = YES;
        _getCodeButton.userInteractionEnabled = YES;
        [_getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [time invalidate];
        time = nil;
        return;
    }
    _count--;
    [_getCodeButton setTitle:[NSString stringWithFormat:@"%ld秒",(long)_count] forState:UIControlStateNormal];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}



#pragma mark - - 第三方登录
////QQ登录
//- (void)QQLogin {
//    QQTools * tools = [[QQTools alloc] init];
//    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APPKEY andDelegate:tools];
//    tools.tencentQAuth = _tencentOAuth;
//    NSArray * permissions= [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_USER_INFO,
//                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
//                            kOPEN_PERMISSION_ADD_ALBUM,
//                            kOPEN_PERMISSION_ADD_ONE_BLOG,
//                            kOPEN_PERMISSION_ADD_SHARE,
//                            kOPEN_PERMISSION_ADD_TOPIC,
//                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
//                            kOPEN_PERMISSION_GET_INFO,
//                            kOPEN_PERMISSION_GET_OTHER_INFO,
//                            kOPEN_PERMISSION_LIST_ALBUM,
//                            kOPEN_PERMISSION_UPLOAD_PIC,
//                            kOPEN_PERMISSION_GET_VIP_INFO,
//                            kOPEN_PERMISSION_GET_VIP_RICH_INFO, nil];
//    [_tencentOAuth authorize:permissions];
//}
////新浪登录
//- (void)SinaLogin {
//    [WeiboSDK enableDebugMode:YES];
//    [WeiboSDK registerApp:Sina_Key];
//    WBAuthorizeRequest * request = [[WBAuthorizeRequest alloc] init];
//    request.redirectURI = @"www.sina.com";
//    request.scope = @"all";
//    request.userInfo = @{};
//    [WeiboSDK sendRequest:request];
//}
//微信登录
//- (void)WeChatLogin {
//    [WXApi registerApp:WX_Key];
//    SendAuthReq* req =[[SendAuthReq alloc ] init];
//    req.scope = @"snsapi_userinfo,snsapi_base";
//    req.state = @"bmw" ;
//    [WXApi sendReq:req];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
