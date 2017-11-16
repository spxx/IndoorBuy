//
//  UserCenterUserInfoViewController.m
//  BMW
//
//  Created by 白琴 on 16/3/15.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "UserInfoViewController.h"
#import "EditUserInfoViewController.h"
#import "PasswordViewController.h"
#import "VIPIntroductionsViewController.h"
#import "VIPMyInfoVC.h"
#import "JoinVIPViewController.h"           //加入麦咖
#import "BalancesViewController.h"          //用户余额


@interface UserInfoViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    UIImageView * _iconImageView;
    UILabel * _nameLabel;
    UILabel * _VIPLabel;
    UIImagePickerController * _imagePickerController;           //图片拾取器
    NSDictionary * _VIPInfoDic;                                 //会员的状态信息
    UIButton * _VIPButton;
    UIButton * _remapaymentButton;
    UILabel * _remapaymentLabel;
    UILabel * _drpMoneyLabel;
}

@property(nonatomic,strong)UIActivityIndicatorView * actIndicator;

@end

@implementation UserInfoViewController
- (void)dealloc {
    //删除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    

    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo:) name:@"updateInfo" object:nil];
    
    [self navigation];
    [self initUserInterface];
    
//    [self getVIPInfoRequest];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self getMemberMoney];
}


-(void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark -- 界面
- (void)initUserInterface {
    //头像
    UIButton * iconButton = [UIButton new];
    iconButton.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
    [iconButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 10)];
    iconButton.backgroundColor = [UIColor whiteColor];
    [iconButton addTarget:self action:@selector(processIconButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:iconButton];
    UILabel * iconTitleLabel = [UILabel new];
    iconTitleLabel.viewSize = CGSizeMake(100, iconButton.viewHeight);
    [iconTitleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
    iconTitleLabel.text = @"头像";
    iconTitleLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    iconTitleLabel.font = fontForSize(13);
    [iconButton addSubview:iconTitleLabel];
    UIImageView * iconJianTouImageView = [UIImageView new];
    iconJianTouImageView.viewSize = CGSizeMake(6, 10);
    [iconJianTouImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, (iconButton.viewHeight - iconJianTouImageView.viewHeight) / 2)];
    iconJianTouImageView.image = [UIImage imageNamed:@"icon_xiaojiantou_gwc"];
    [iconButton addSubview:iconJianTouImageView];
    _iconImageView = [UIImageView new];
    _iconImageView.viewSize = CGSizeMake(31, 31);
    [_iconImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(iconJianTouImageView.viewX - 8, (iconButton.viewHeight - _iconImageView.viewHeight) / 2)];
    _iconImageView.layer.cornerRadius = _iconImageView.viewHeight / 2;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.image = self.headerImage;
    [iconButton addSubview:_iconImageView];
    //昵称
    UIButton * nameButton = [UIButton new];
    nameButton.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
    [nameButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, iconButton.viewBottomEdge)];
    nameButton.backgroundColor = [UIColor whiteColor];
    [nameButton addTarget:self action:@selector(processNameButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nameButton];
    UILabel * nameTitleLabel = [UILabel new];
    nameTitleLabel.viewSize = CGSizeMake(100, nameButton.viewHeight);
    [nameTitleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
    nameTitleLabel.text = @"昵称";
    nameTitleLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    nameTitleLabel.font = fontForSize(13);
    [nameButton addSubview:nameTitleLabel];
    UIImageView * nameJianTouImageView = [UIImageView new];
    nameJianTouImageView.viewSize = CGSizeMake(6, 10);
    [nameJianTouImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, (nameButton.viewHeight - nameJianTouImageView.viewHeight) / 2)];
    nameJianTouImageView.image = [UIImage imageNamed:@"icon_xiaojiantou_gwc"];
    [nameButton addSubview:nameJianTouImageView];
    _nameLabel = [UILabel new];
    _nameLabel.viewSize = CGSizeMake(200, 45);
    _nameLabel.textAlignment = NSTextAlignmentRight;
    _nameLabel.font = fontForSize(13);
    _nameLabel.textColor = [UIColor colorWithHex:0x181818];
    if ([JCUserContext sharedManager].currentUserInfo.memberTrueName) {
        _nameLabel.text = [JCUserContext sharedManager].currentUserInfo.memberTrueName;
    }
    else {
        _nameLabel.text = [NSString stringWithFormat:@"BM%@",[JCUserContext sharedManager].currentUserInfo.memberID];
    }
    [_nameLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(nameJianTouImageView.viewX - 8, (nameButton.viewHeight - _nameLabel.viewHeight) / 2)];
    [nameButton addSubview:_nameLabel];
    
    //绑定手机
    UIButton * phoneButton = [UIButton new];
    phoneButton.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
    [phoneButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, nameButton.viewBottomEdge)];
    phoneButton.backgroundColor = [UIColor whiteColor];
//    [phoneButton addTarget:self action:@selector(processNameButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneButton];
    UILabel * phoneTitleLabel = [UILabel new];
    phoneTitleLabel.viewSize = CGSizeMake(100, nameButton.viewHeight);
    [phoneTitleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
    phoneTitleLabel.text = @"绑定手机";
    phoneTitleLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    phoneTitleLabel.font = fontForSize(13);
    [phoneButton addSubview:phoneTitleLabel];
    UILabel *phoneLabel = [UILabel new];
    phoneLabel.viewSize = CGSizeMake(200, 45);
    phoneLabel.textAlignment = NSTextAlignmentRight;
    phoneLabel.font = fontForSize(13);
    phoneLabel.textColor = [UIColor colorWithHex:0x181818];
    phoneLabel.text = [NSString stringWithFormat:@"%@****%@",[[JCUserContext sharedManager].currentUserInfo.memberName substringToIndex:3],[[JCUserContext sharedManager].currentUserInfo.memberName substringFromIndex:7]];
    [phoneLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15 - 8, (phoneButton.viewHeight - phoneLabel.viewHeight) / 2)];
    [phoneButton addSubview:phoneLabel];
    
    
    
    
//    //余额
//    for (int i = 0; i < 2; i ++) {
//        _remapaymentButton = [UIButton new];
//        _remapaymentButton.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
//        [_remapaymentButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, nameButton.viewBottomEdge + i * 45)];
//        _remapaymentButton.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:_remapaymentButton];
//        UILabel * remapaymentTitleLabel = [UILabel new];
//        remapaymentTitleLabel.viewSize = CGSizeMake(100, nameButton.viewHeight);
//        [remapaymentTitleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
//        remapaymentTitleLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
//        remapaymentTitleLabel.font = fontForSize(13);
//        [_remapaymentButton addSubview:remapaymentTitleLabel];
//        UILabel * moneyLabel = [UILabel new];
//        moneyLabel.viewSize = CGSizeMake(200, 45);
//        moneyLabel.textAlignment = NSTextAlignmentRight;
//        moneyLabel.font = fontForSize(13);
//        moneyLabel.textColor = [UIColor colorWithHex:0x181818];
//        [moneyLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(nameJianTouImageView.viewX - 8, (_remapaymentButton.viewHeight - moneyLabel.viewHeight) / 2)];
//        [_remapaymentButton addSubview:moneyLabel];
//        
//        if (i == 0) {
//            remapaymentTitleLabel.text = @"分销余额";
//            _drpMoneyLabel = moneyLabel;
//        }
//        else {
//            [_remapaymentButton addTarget:self action:@selector(processRemapaymentButton:) forControlEvents:UIControlEventTouchUpInside];
//            remapaymentTitleLabel.text = @"麦咖余额";
//            _remapaymentLabel = moneyLabel;
//            
//            UIImageView * remapaymentJianTouImageView = [UIImageView new];
//            remapaymentJianTouImageView.viewSize = CGSizeMake(6, 10);
//            [remapaymentJianTouImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, (_remapaymentButton.viewHeight - remapaymentJianTouImageView.viewHeight) / 2)];
//            remapaymentJianTouImageView.image = [UIImage imageNamed:@"icon_xiaojiantou_gwc"];
//            [_remapaymentButton addSubview:remapaymentJianTouImageView];
//        }
//    }
    
    for (int i = 0; i < 2; i ++) {
        UIView * line = [UIView new];
        line.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [line align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 55 + i * 45)];
        line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [self.view addSubview:line];
    }
    
    //密码修改
    UIButton * passwordButton = [UIButton new];
    passwordButton.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
    [passwordButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, phoneButton.viewBottomEdge + 11)];
    passwordButton.backgroundColor = [UIColor whiteColor];
    [passwordButton addTarget:self action:@selector(processPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:passwordButton];
    UILabel * passwordTitleLabel = [UILabel new];
    passwordTitleLabel.viewSize = CGSizeMake(100, passwordButton.viewHeight);
    [passwordTitleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
    passwordTitleLabel.text = @"密码修改";
    passwordTitleLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    passwordTitleLabel.font = fontForSize(13);
    [passwordButton addSubview:passwordTitleLabel];
    UIImageView * passwordJianTouImageView = [UIImageView new];
    passwordJianTouImageView.viewSize = CGSizeMake(6, 10);
    [passwordJianTouImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, (passwordButton.viewHeight - passwordJianTouImageView.viewHeight) / 2)];
    passwordJianTouImageView.image = [UIImage imageNamed:@"icon_xiaojiantou_gwc"];
    [passwordButton addSubview:passwordJianTouImageView];
    UIView * line = [UIView new];
    line.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
    [line align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, passwordButton.viewBottomEdge)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self.view addSubview:line];
    
    if ([[JCUserContext sharedManager].currentUserInfo.drp_recommend boolValue]) {
        _remapaymentButton = [UIButton new];
        _remapaymentButton.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_remapaymentButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, passwordButton.viewBottomEdge+5)];
        _remapaymentButton.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_remapaymentButton];
        UILabel * remapaymentTitleLabel = [UILabel new];
        remapaymentTitleLabel.viewSize = CGSizeMake(100, nameButton.viewHeight);
        [remapaymentTitleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
        remapaymentTitleLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        remapaymentTitleLabel.font = fontForSize(13);
        remapaymentTitleLabel.text = @"我的分销余额";
        [_remapaymentButton addSubview:remapaymentTitleLabel];
        UILabel * moneyLabel = [UILabel new];
        moneyLabel.viewSize = CGSizeMake(200, 45);
        moneyLabel.textAlignment = NSTextAlignmentRight;
        moneyLabel.font = fontForSize(13);
        moneyLabel.textColor = [UIColor colorWithHex:0x181818];
        [moneyLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(nameJianTouImageView.viewX - 8, (_remapaymentButton.viewHeight - moneyLabel.viewHeight) / 2)];
        _drpMoneyLabel = moneyLabel;

        [_remapaymentButton addSubview:moneyLabel];
    }
    
//    //付费会员
//    _VIPButton = [UIButton new];
//    _VIPButton.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
//    [_VIPButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, passwordButton.viewBottomEdge + 11)];
//    _VIPButton.backgroundColor = [UIColor whiteColor];
//    [_VIPButton addTarget:self action:@selector(processVIPButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_VIPButton];
//    UILabel * VIPTitleLabel = [UILabel new];
//    VIPTitleLabel.viewSize = CGSizeMake(100, _VIPButton.viewHeight);
//    [VIPTitleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
//    VIPTitleLabel.text = @"付费会员";
//    VIPTitleLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
//    VIPTitleLabel.font = fontForSize(13);
//    [_VIPButton addSubview:VIPTitleLabel];
//    UIImageView * VIPJianTouImageView = [UIImageView new];
//    VIPJianTouImageView.viewSize = CGSizeMake(6, 10);
//    [VIPJianTouImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, (_VIPButton.viewHeight - VIPJianTouImageView.viewHeight) / 2)];
//    VIPJianTouImageView.image = [UIImage imageNamed:@"icon_xiaojiantou_gwc"];
//    [_VIPButton addSubview:VIPJianTouImageView];
//    _VIPLabel = [UILabel new];
//    _VIPLabel.viewSize = CGSizeMake(200, 45);
//    _VIPLabel.textAlignment = NSTextAlignmentRight;
//    _VIPLabel.font = fontForSize(13);
//    _VIPLabel.textColor = [UIColor colorWithHex:0x181818];
//    [_VIPLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(VIPJianTouImageView.viewX - 8, (_VIPButton.viewHeight - _VIPLabel.viewHeight) / 2)];
//    [_VIPButton addSubview:_VIPLabel];
//    UIView * line1 = [UIView new];
//    line1.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
//    [line1 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _VIPButton.viewBottomEdge)];
//    line1.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
//    [self.view addSubview:line1];
//    
//    _actIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
//    _actIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    _actIndicator.center = CGPointMake(_VIPLabel.viewWidth - 8 - 15, _VIPLabel.viewHeight / 2);
//    [_VIPLabel addSubview:_actIndicator];

}


#pragma mark -- 点击事件
/**
 *  点击修改头像
 */
- (void)processIconButton:(UIButton *)sender {
    NSLog(@"点击头像");
    //配置上弹菜单
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"选取照片", nil];
    [actionSheet showInView:self.view];
}
/**
 *  修改昵称
 */
- (void)processNameButton:(UIButton *)sender {
    NSLog(@"修改昵称");
    EditUserInfoViewController * editUserInfoVC = [[EditUserInfoViewController alloc] init];
    editUserInfoVC.title = @"昵称";
    [self.navigationController pushViewController:editUserInfoVC animated:YES];
}
/**
 *  余额
 */
- (void)processRemapaymentButton:(UIButton *)sender {
    BalancesViewController * balancesVC = [[BalancesViewController alloc] init];
    [self.navigationController pushViewController:balancesVC animated:YES];
}

/**
 *  修改密码
 */
- (void)processPasswordButton:(UIButton *)sender {
    NSLog(@"修改密码");
    PasswordViewController * passwordVC = [[PasswordViewController alloc] init];
    [self.navigationController pushViewController:passwordVC animated:YES];
}
/**
 *  付费会员
 */
- (void)processVIPButton:(UIButton *)sender {
    NSLog(@"付费会员");
    
    if ([_VIPInfoDic[@"status"] isKindOfClass:[NSNull class]]) {
        //不是会员
        VIPIntroductionsViewController * vipIntroductionsVC = [[VIPIntroductionsViewController alloc] init];
        vipIntroductionsVC.isProtocol = NO;
        [self.navigationController pushViewController:vipIntroductionsVC animated:YES];
    }
    else {
        switch ([_VIPInfoDic[@"status"] integerValue]) {
            case 0:{
                VIPIntroductionsViewController * vipIntroductionsVC = [[VIPIntroductionsViewController alloc] init];
                vipIntroductionsVC.isProtocol = NO;
                [self.navigationController pushViewController:vipIntroductionsVC animated:YES];
            }
                break;
            case 10:{
                //正式会员
                VIPMyInfoVC * vipMyInfoVC = [[VIPMyInfoVC alloc] init];
                vipMyInfoVC.dataSourceDic = _VIPInfoDic;
                [self.navigationController pushViewController:vipMyInfoVC animated:YES];
            }
                break;
            case 20:{
                //申请中
                VIPIntroductionsViewController * vipIntroductionsVC = [[VIPIntroductionsViewController alloc] init];
                vipIntroductionsVC.isProtocol = NO;
                [self.navigationController pushViewController:vipIntroductionsVC animated:YES];
            }
                break;
            case 30:{
                //绑卡失败
                [self VIPActivation];
            }
                break;
            case 40:{
                //过期
                VIPMyInfoVC * vipMyInfoVC = [[VIPMyInfoVC alloc] init];
                vipMyInfoVC.dataSourceDic = _VIPInfoDic;
                [self.navigationController pushViewController:vipMyInfoVC animated:YES];
            }
                break;
            case 50:{
                //申请失败，重新申请
                VIPIntroductionsViewController * vipIntroductionsVC = [[VIPIntroductionsViewController alloc] init];
                vipIntroductionsVC.isProtocol = NO;
                [self.navigationController pushViewController:vipIntroductionsVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark -- 通知事件
- (void)updateUserInfo:(NSNotification *)notification {
    [[JCUserContext sharedManager] upDateObject:[notification valueForKey:@"object"] forKey:@"member_truename"];
    _nameLabel.text = [notification valueForKey:@"object"];
    _nameLabel.textColor = [UIColor colorWithHex:0x181818];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    switch (buttonIndex) {
            //拍照
        case 0:
            [self ChooseImageInCamera];
            break;
            //从相册中选取
        case 1:
            [self ChooseImageInPhotoAlbum];
            break;
            
        default:
            break;
    }
}
#pragma mark - 头像
//从相册选取照片
- (void)ChooseImageInPhotoAlbum {
    //获取某种sourceType支持的媒体格式
    NSArray * mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    //souceType 是打开相册还是摄像头
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //显示的媒体格式有哪些
        _imagePickerController.mediaTypes = @[mediaTypes[0],mediaTypes[1]];
        [self presentViewController:_imagePickerController animated:YES completion:nil];
        //是否允许编辑
        _imagePickerController.allowsEditing = YES;
    }
}

//拍照
- (void)ChooseImageInCamera {
    NSArray * mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePickerController.mediaTypes = @[mediaTypes[0]];
        //设置相机模式为拍照
        _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        //设置前置后置摄像头
        _imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;//后置
        //闪光
        _imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        //是否允许编辑
        _imagePickerController.allowsEditing = YES;

        [self presentViewController:_imagePickerController animated:YES completion:nil];
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前设备不支持" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - 图片拾取器的代理
//当用户完成某个图片或视频的选取
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    UIImage * image = info[UIImagePickerControllerOriginalImage];
    UIImage * edited = info[UIImagePickerControllerEditedImage];
    UIImage * newImage = [self imageCompressForWidth:edited targetWidth:300];
    [self dismissViewControllerAnimated:YES completion:^{
        _iconImageView.image = newImage;
        [self.HUD show:YES];
        [BaseRequset upLoadImageWithUrl:INDOORBUY_UPLOAD_URL parmas:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} withImage:newImage RequestSuccess:^(id result) {
            NSLog(@"result === %@", result);
            
            if ([result[@"code"] integerValue] == 100) {
                [self updateIconRequestWithDic:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"avatar":result[@"data"]}];

                /**
                 *  如果之前有头像，就不用走第二步上传
                 */
//                if (![JCUserContext sharedManager].currentUserInfo.memberAvatar || ([JCUserContext sharedManager].currentUserInfo.memberAvatar).length == 0) {
//                    [self updateIconRequestWithDic:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"avatar":result[@"data"]}];
//                }
//                else {
//                    [self.HUD hide:YES];
//                    SHOW_MSG(@"上传成功");
//                }
                
            }
            else if ([result[@"code"] integerValue] == 999) {
                [self.HUD hide:YES];
                _iconImageView.image = self.headerImage;
                SHOW_MSG(result[@"message"]);
            }
            else {
                [self.HUD hide:YES];
            }
            
        } failBlcok:^(id result) {
            [self.HUD hide:YES];
            NSLog(@"%@",[result localizedDescription]);
        }];
    }];
    [_imagePickerController removeFromParentViewController];
    _imagePickerController = nil;
    
}

#pragma mark -- 网络请求
/**
 *  获取用户余额
 */
- (void)getMemberMoney {
    _remapaymentButton.userInteractionEnabled = NO;
    [self.actIndicator startAnimating];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetUserInfo" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            _drpMoneyLabel.text = [NSString stringWithFormat:@"¥ %.2f", [object[@"data"][@"drp_money"] floatValue]];
        }
    }];

//    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetMemberMoney" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
//        [self.actIndicator stopAnimating];
//        _remapaymentButton.userInteractionEnabled = YES;
//        if (result == RequestResultSuccess) {
//            double drpMoney = 0;
//            double userMoney = 0;
//            if ([object[@"data"][@"drpMoney"] isKindOfClass:[NSNull class]]) {
//                drpMoney= 0.00;
//            }
//            else {
//                drpMoney = [object[@"data"][@"drpMoney"] doubleValue];
//            }
//            if ([object[@"data"][@"userMoney"] isKindOfClass:[NSNull class]]) {
//                userMoney= 0.00;
//            }
//            else {
//                userMoney = [object[@"data"][@"userMoney"] doubleValue];
//            }
//            _remapaymentLabel.text = [NSString stringWithFormat:@"¥ %.2f", userMoney];
//            _drpMoneyLabel.text = [NSString stringWithFormat:@"¥ %.2f", drpMoney];
//        }
//        else {
//            
//        }
//    }];
}

/**
 *  会员直接激活【在界面显示激活的时候点击调用】
 */
- (void)VIPActivation {
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"ReActivate" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result == RequestResultSuccess) {
            SHOW_MSG(@"激活成功");
        }
        else {
            if (((NSString *)object[@"data"]).length != 0){
                SHOW_MSG(object[@"data"]);
            }
            else {
                SHOW_MSG(object[@"message"]);
            }
        }
    }];
}

//第二步头像上传
- (void)updateIconRequestWithDic:(NSDictionary *)dic {
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"changeAvatar" parameters:dic callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result == RequestResultSuccess) {
            SHOW_MSG(@"上传成功");
        }
        else {
            SHOW_MSG(object[@"message"]);
        }
    }];
}
/**
 *  获取用户VIP信息
 */
- (void)getVIPInfoRequest {
    _VIPButton.userInteractionEnabled = NO;
    [self.actIndicator startAnimating];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"VipInfo" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
        _VIPButton.userInteractionEnabled = YES;
        [self.actIndicator stopAnimating];
        if (result == RequestResultSuccess) {
            _VIPInfoDic = [NSDictionary dictionaryWithDictionary:object[@"data"]];
            //更新保存下来的状态值
            if (![_VIPInfoDic[@"status"] isKindOfClass:[NSNull class]]) {
                [[JCUserContext sharedManager] upDateObject:_VIPInfoDic[@"status"] forKey:@"status"];
            }
            else {
                [[JCUserContext sharedManager] upDateObject:@"0" forKey:@"status"];
            }
            if ([_VIPInfoDic[@"status"] isKindOfClass:[NSNull class]] || [_VIPInfoDic[@"status"] integerValue] == 0) {
                _VIPLabel.text = @"加入会员";
                _VIPLabel.textColor = [UIColor colorWithHex:0xc8c8ce];
            }
            else if ([_VIPInfoDic[@"status"] integerValue] == 10) {
                _VIPLabel.text = [NSString stringWithFormat:@"%@到期", _VIPInfoDic[@"validitydate"]];
                _VIPLabel.textColor = [UIColor colorWithHex:0x181818];
            }
            else if ([_VIPInfoDic[@"status"] integerValue] == 20) {
                _VIPLabel.text = @"申请中";
                _VIPLabel.textColor = [UIColor colorWithHex:0x181818];
            }
            else if ([_VIPInfoDic[@"status"] integerValue] == 30) {
                _VIPLabel.text = @"激活";
                _VIPLabel.textColor = [UIColor colorWithHex:0x181818];
            }
            else if ([_VIPInfoDic[@"status"] integerValue] == 40) {
                _VIPLabel.text = @"已过期";
            }
            else if ([_VIPInfoDic[@"status"] integerValue] == 50) {
                _VIPLabel.text = @"申请失败，请重新申请";
            }
        }
        else {
            
        }
    }];
}


#pragma mark -- 其他
//指定宽度按比例缩放
- (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
