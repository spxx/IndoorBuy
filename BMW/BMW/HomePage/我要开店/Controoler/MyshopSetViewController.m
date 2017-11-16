//
//  MyshopSetViewController.m
//  BMW
//
//  Created by rr on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "MyshopSetViewController.h"
#import "MystoreModel.h"


@interface MyshopSetViewController ()<UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITextField *_nickNameText;
    UIImageView *_iconImageView;
    UITextView  *_myshopTextView;
    UILabel *_placeholderLabel;
    UIImagePickerController * _imagePickerController;           //图片拾取器
    MystoreModel *_myModel;
    CGFloat  _currentY;
}

@property(nonatomic, strong)UIView *headView;

@property(nonatomic, strong)UIView *presonView;


@end

@implementation MyshopSetViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self navigation];
    [self initData];
    [self initUserInterface];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (_currentY>kbRect.origin.y) {
        self.view.viewY = 64+(kbRect.origin.y - _currentY);
    }
}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    self.view.viewY = 64;
}

-(void)initData{
    [MystoreModel requestMystoreInfoComplete:^(BOOL successs, MystoreModel *model, NSString *message) {
        if (successs) {
            _myModel = model;
            [self updateView];
        }else{
            SHOW_MSG(message);
        }
    }];
}

-(void)initUserInterface{
    self.title = @"店铺设置";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self.view addSubview:self.headView];
    [self.view addSubview:self.presonView];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*W_ABCW, self.presonView.viewBottomEdge+10*W_ABCH, SCREEN_WIDTH - 30*W_ABCW, 20)];
    textLabel.text = @"注：店铺设置的所有信息将在首页LOGO详情全部显示，以便用户与您联系，方便推广";
    textLabel.font = fontForSize(11);
    textLabel.textColor = [UIColor colorWithHex:0x666666];
    textLabel.numberOfLines = 0;
    [textLabel sizeToFit];
    [self.view addSubview:textLabel];
    
    UIButton *finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-45*W_ABCH, SCREEN_WIDTH, 45*W_ABCH)];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    finishBtn.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
    finishBtn.titleLabel.font = fontForSize(15);
    [finishBtn addTarget:self action:@selector(finishBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishBtn];
    
}

-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 161*W_ABCH)];
        _headView.backgroundColor = [UIColor whiteColor];
        //昵称
        UILabel * nameTitleLabel = [UILabel new];
        nameTitleLabel.viewSize = CGSizeMake(100, 35*W_ABCH);
        [nameTitleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15*W_ABCW, 0)];
        nameTitleLabel.text = @"店铺名称：";
        nameTitleLabel.textColor = [UIColor colorWithHex:0x000000];
        nameTitleLabel.font = fontForSize(12);
        [nameTitleLabel sizeToFit];
        nameTitleLabel.viewSize = CGSizeMake(nameTitleLabel.viewWidth, 35*W_ABCH);
        [_headView addSubview:nameTitleLabel];
        _nickNameText = [[UITextField alloc] initWithFrame:CGRectMake(nameTitleLabel.viewRightEdge+6*W_ABCW, 0, SCREEN_WIDTH-nameTitleLabel.viewWidth-30*W_ABCW, 35*W_ABCH)];
        _nickNameText.textColor = [UIColor colorWithHex:0xbfbfbf];
        _nickNameText.font = fontForSize(12);
        _nickNameText.delegate = self;
        _nickNameText.placeholder = @"来取一个名字吧";
        _nickNameText.returnKeyType = UIReturnKeyDone;
        [_headView addSubview:_nickNameText];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, nameTitleLabel.viewBottomEdge, SCREEN_WIDTH, 0.5*W_ABCH)];
        line.backgroundColor = COLOR_BACKGRONDCOLOR;
        [_headView addSubview:line];
        //头像
        UIButton * iconButton = [UIButton new];
        iconButton.viewSize = CGSizeMake(SCREEN_WIDTH, 35*W_ABCH);
        [iconButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, line.viewBottomEdge)];
        iconButton.backgroundColor = [UIColor whiteColor];
        [iconButton addTarget:self action:@selector(processIconButton:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:iconButton];
        UILabel * iconTitleLabel = [UILabel new];
        iconTitleLabel.viewSize = CGSizeMake(100, iconButton.viewHeight);
        [iconTitleLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15*W_ABCW, 0)];
        iconTitleLabel.text = @"店铺头像：";
        iconTitleLabel.textColor = [UIColor colorWithHex:0x000000];
        iconTitleLabel.font = fontForSize(12);
        [iconButton addSubview:iconTitleLabel];
        UIImageView * iconJianTouImageView = [UIImageView new];
        iconJianTouImageView.viewSize = CGSizeMake(6, 10);
        [iconJianTouImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15*W_ABCW, (iconButton.viewHeight - iconJianTouImageView.viewHeight) / 2)];
        iconJianTouImageView.image = [UIImage imageNamed:@"icon_xiaojiantou_gwc"];
        [iconButton addSubview:iconJianTouImageView];
        _iconImageView = [UIImageView new];
        _iconImageView.viewSize = CGSizeMake(31, 31);
        [_iconImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(iconJianTouImageView.viewX - 8, (iconButton.viewHeight - _iconImageView.viewHeight) / 2)];
        _iconImageView.layer.cornerRadius = _iconImageView.viewHeight / 2;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.image = self.store_iamge;
        [iconButton addSubview:_iconImageView];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, iconButton.viewBottomEdge, SCREEN_WIDTH, 0.5*W_ABCH)];
        line1.backgroundColor = COLOR_BACKGRONDCOLOR;
        [_headView addSubview:line1];
        
        UILabel *shoptext = [[UILabel alloc] initWithFrame:CGRectMake(15*W_ABCW, line1.viewBottomEdge+20*W_ABCH, 100, 12)];
        shoptext.textColor = [UIColor colorWithHex:0x000000];
        shoptext.font = fontForSize(12);
        shoptext.text = @"店铺描述：";
        [shoptext sizeToFit];
        shoptext.viewSize = CGSizeMake(shoptext.viewWidth, 12);
        [_headView addSubview:shoptext];
        
        _myshopTextView = [[UITextView alloc] initWithFrame:CGRectMake(shoptext.viewRightEdge, shoptext.viewY, SCREEN_WIDTH-shoptext.viewWidth-30*W_ABCW, 70*W_ABCH)];
        _myshopTextView.delegate = self;
        [_headView addSubview:_myshopTextView];
        
        _placeholderLabel = [UILabel new];
        _placeholderLabel.viewSize = CGSizeMake(100, 30);
        _placeholderLabel.font = fontForSize(12);
        _placeholderLabel.textColor = [UIColor colorWithHex:0xc8c8ce];
        _placeholderLabel.text = @"来介绍一下您的店铺吧（选填）";
        [_placeholderLabel sizeToFit];
        [_placeholderLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        [_myshopTextView addSubview:_placeholderLabel];
        
    }
    return _headView;
}

-(UIView *)presonView{
    if (!_presonView) {
        _presonView = [[UIView alloc] initWithFrame:CGRectMake(0, _headView.viewBottomEdge+5*W_ABCH, SCREEN_WIDTH, 35*3*W_ABCH+1.5*W_ABCH)];
        _presonView.backgroundColor = [UIColor whiteColor];
        NSArray * nameArray = @[@"手机号：", @"微信号：",@"QQ号："];
        for (int i = 0; i < nameArray.count; i ++) {
            UILabel * nameLabel = [UILabel new];
            nameLabel.viewSize = CGSizeMake(78 * W_ABCH, 35 * W_ABCH);
            nameLabel.font = fontForSize(12);
            nameLabel.textColor = [UIColor colorWithHex:0x000000];
            nameLabel.text = nameArray[i];
            [nameLabel sizeToFit];
            nameLabel.viewSize = CGSizeMake(nameLabel.viewWidth, 35*W_ABCH);
            [nameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, i * nameLabel.viewHeight)];
            [_presonView addSubview:nameLabel];
            
            UITextField * textField = [UITextField new];
            textField.viewSize = CGSizeMake(SCREEN_WIDTH - nameLabel.viewWidth - 30*W_ABCW, 35 * W_ABCH);
            [textField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(nameLabel.viewRightEdge, i * textField.viewHeight)];
            textField.font = fontForSize(12);
            textField.textColor = [UIColor colorWithHex:0xbfbfbf];
            textField.delegate = self;
            textField.tag = 99+i;
            [_presonView addSubview:textField];
            
            UIView * lineView = [UIView new];
            lineView.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5 * W_ABCH);
            [lineView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, textField.viewBottomEdge)];
            lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
            [_presonView addSubview:lineView];
        }

    }
    return _presonView;
}

- (void)updateView{
    _nickNameText.text = _myModel.store_name;
    _placeholderLabel.text = _myModel.description;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_myModel.member_avatar] placeholderImage:nil options:SDWebImageRefreshCached];
    UITextField *qqtextFiled = [_presonView viewWithTag:99];
    qqtextFiled.text = _myModel.store_qq;
    UITextField *wxtextFiled = [_presonView viewWithTag:100];
    wxtextFiled.text = _myModel.store_wx;
    UITextField *teltextFiled = [_presonView viewWithTag:101];
    teltextFiled.text = _myModel.store_tel;
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
    UIImage * image = info[UIImagePickerControllerEditedImage];
    
    UIImage * newImage = [TYTools imageCompressForWidth:image targetWidth:300];
    [self dismissViewControllerAnimated:YES completion:^{
        _iconImageView.image = newImage;
        [self.HUD show:YES];
        [BaseRequset upLoadImageWithUrl:INDOORBUY_UPLOAD_URL parmas:nil withImage:newImage RequestSuccess:^(id result) {
            NSLog(@"result === %@", result);
            
            if ([result[@"code"] integerValue] == 100) {
                [self updateIconRequestWithDic:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"avatar":result[@"data"]}];
            }
            else if ([result[@"code"] integerValue] == 999) {
                [self.HUD hide:YES];
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_myshopTextView.text.length>0) {
        _placeholderLabel.hidden = YES;
    }else{
        _placeholderLabel.hidden = NO;
    }
    [self.view endEditing:YES];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.superview==_presonView) {
        _currentY = _presonView.viewY +textField.viewBottomEdge;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    _placeholderLabel.hidden = YES;
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView == _myshopTextView) {
        if (textView.text.length == 0) {
            _placeholderLabel.hidden = NO;
        }else {
            _placeholderLabel.hidden = YES;
        }
    }
    [self.view endEditing:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView == _myshopTextView) {
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
    }
    return YES;
}

-(void)finishBtn{
    if ([_nickNameText.text length]==0) {
        SHOW_MSG(@"请填写店铺名字");
        return;
    }
    UITextField *qq = [_presonView viewWithTag:99];
    UITextField *wx = [_presonView viewWithTag:100];
    UITextField *tel = [_presonView viewWithTag:101];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"SetStore" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"storeName":_nickNameText.text,@"description":_myshopTextView.text,@"qq":qq.text,@"wx":wx.text,@"tel":tel.text} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            SHOW_MSG(@"修改成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
    
    
}






@end
