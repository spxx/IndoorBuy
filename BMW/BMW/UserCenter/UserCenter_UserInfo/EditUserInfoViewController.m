//
//  EditUserInfoViewController.m
//  BMW
//
//  Created by 白琴 on 16/3/15.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "EditUserInfoViewController.h"

@interface EditUserInfoViewController () {
    UITextField * _textField;
}

@end

@implementation EditUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    
    //配置导航栏的右侧按钮
    UIButton * addAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addAddressButton setTitle:@"保存" forState:UIControlStateNormal];
    addAddressButton.frame = CGRectMake(0, 0, 50, 50);
    addAddressButton.titleLabel.font = fontForSize(15);
    [addAddressButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    UIBarButtonItem * addAddressBtnItem = [[UIBarButtonItem alloc] initWithCustomView:addAddressButton];
    [addAddressButton addTarget:self action:@selector(clickedSaveButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = addAddressBtnItem;
    
    [self navigation];
    [self initUserInterface];
}

#pragma mark -- 界面
/**
 *  基本界面
 */
- (void)initUserInterface {
    _textField = [UITextField new];
    _textField.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
    [_textField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 10)];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.placeholder = @"昵称";
    _textField.font = fontForSize(13);
    if ([JCUserContext sharedManager].currentUserInfo.memberTrueName && ![[JCUserContext sharedManager].currentUserInfo.memberTrueName isEqualToString:@"还没有昵称哟"]) {
        _textField.text = [JCUserContext sharedManager].currentUserInfo.memberTrueName;
    }
    
    _textField.textColor = [UIColor colorWithHex:0x181818];
    [self.view addSubview:_textField];
    //创建一个左侧视图
    _textField.leftViewMode = UITextFieldViewModeAlways;
    UIView * mobileLeftView = [UIView new];
    mobileLeftView.viewSize = CGSizeMake(15, _textField.viewHeight);
    [mobileLeftView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
    //将左侧视图添加到TextField上
    _textField.leftView = mobileLeftView;
    //分割线
    UIView * lineView = [UIView new];
    lineView.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
    [lineView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _textField.viewBottomEdge)];
    lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self.view addSubview:lineView];
    
}

#pragma mark -- 点击事件
/**
 *  保存
 */
- (void)clickedSaveButton {
    NSLog(@"保存");
    if(!(_textField.text.length>0)){
        SHOW_EEROR_MSG(@"请输入昵称");
        return;
    }
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"changeAvatar" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"name":_textField.text} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            SHOW_MSG(@"修改成功");
            //通知传值
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateInfo" object:_textField.text];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            SHOW_MSG(@"修改失败");
        }
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
