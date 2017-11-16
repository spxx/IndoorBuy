//
//  ApplyRefundViewController.m
//  BMW
//
//  Created by rr on 16/3/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ApplyRefundViewController.h"
#import "ApplyRTableViewCell.h"
#import "XHImageViewer.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ApplyRIntroductionsViewController.h"           //退款说明



@interface ApplyRefundViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,XHImageViewerDelegate,QBImagePickerControllerDelegate>
{
    UITableView *_tableView;
    UIButton * _submitOrderButton;                      //提交订单按钮
    UITextView *_applyRTextView;
    UIScrollView *_scrollV;
    UIImagePickerController *_imagePickerController;
    
    NSMutableArray *_seleteArray;
    NSMutableArray *_numArray;
}
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIView *footerView;

// XHImage
@property (nonatomic, assign) NSInteger currentImgIndex; // 当前图片下标
@property (nonatomic, retain) NSMutableArray *imageViews; // 当前选中图片组
@property (nonatomic, weak) XHImageViewer *imageViewer;

@property (nonatomic, strong) UILabel *countReminderLabel; // 照片数量提示
@property (nonatomic, strong) UIButton *deleteButton; // 照片删除按钮

@property(nonatomic,assign)BOOL delete; //是否删除
@property (nonatomic, retain) NSMutableString *imageString; // img参数

@end

@implementation ApplyRefundViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申请退款";
    
    UIButton * shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"icon_tuikuanshuoming_sqtk.png"] forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(0, 0, 22, 22);
    UIBarButtonItem * shareBtnItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    [shareButton addTarget:self action:@selector(careSomething) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = shareBtnItem;
    
    [self navigation];
    [self initData];
    [self initUserInterFace];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notif {
    NSDictionary *userInfo = notif.userInfo;
    //键盘高度
    CGRect keyboardF = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat MaxY = _applyRTextView.viewY+_applyRTextView.viewHeight - _tableView.contentOffset.y+_tableView.contentSize.height-_footerView.viewHeight-_headerView.viewHeight;
    CGFloat diffrent = MaxY - keyboardF.origin.y;
    
    if (diffrent>0) {
        self.view.frame = CGRectMake(0, -(diffrent+20), SCREEN_WIDTH, SCREEN_HEIGHT);
    }
}


- (void)keyboardWillHide:(NSNotification *)notif {
    self.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
}

#pragma mark - setter & getter

- (NSMutableString *)imageString {
    
    if (!_imageString) {
        _imageString = [NSMutableString string];
    }
    return _imageString;
}

- (NSMutableArray *)imageViews {
    
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}

- (UILabel *)countReminderLabel {
    
    if (!_countReminderLabel) {
        _countReminderLabel = [[UILabel alloc] init];
        _countReminderLabel.bounds = CGRectMake(0, 0, 100, 20);
        _countReminderLabel.center = CGPointMake(SCREEN_WIDTH / 2, 22);
        _countReminderLabel.textAlignment = 1;
        _countReminderLabel.textColor = [UIColor whiteColor];
        _countReminderLabel.font = [UIFont fontWithName:@"Menlo" size:13];
    }
    return _countReminderLabel;
}

- (UIButton *)deleteButton {
    
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.bounds = CGRectMake(0, 0, 20, 20);
        _deleteButton.center = CGPointMake(SCREEN_WIDTH - _deleteButton.bounds.size.width / 2 - 20, 22);
        [_deleteButton setImage:IMAGEWITHNAME(@"deleteButton_CZGJ.png") forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

-(void)initData{
    _seleteArray = [NSMutableArray array];
    _currentImgIndex = 0;
}

-(void)careSomething{
    ApplyRIntroductionsViewController * applyRVC = [[ApplyRIntroductionsViewController alloc] init];
    applyRVC.title = @"退款说明";
    applyRVC.contentString = @"1、如果您还未收到商品，请您点击“未收货”填写退款申请单；\n2、如您已签收商品，请您点击“已收货”填写退货申请单；\n3、由于跨境商品的特殊性，商品一经发出无法办理退款，如商品出现之类问题请签收后提交退货申请；\n4、由于跨境商品的特殊性，部分商品不支持无理由退货，如商品出现质量问题，请于收货日起7天内提交退货申请；\n5、如商品需办理售后退货申请，请提交申请时务必上传商品问题图片，以便客服审核；\n6、退货申请提交后，我们将于2个工作日内进行审核；\n7、帮麦收到退货商品审核无误后，将在3-5个工作日为您办理退款，退款后7个工作日内到账，请注意查收。";
    [self.navigationController pushViewController:applyRVC animated:YES];
}

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _headerView.backgroundColor = [UIColor whiteColor];
        UIButton *allbutton = [[UIButton alloc] initWithFrame:CGRectMake(15, 13, 18, 18)];
        allbutton.tag = 999;
        [allbutton addTarget:self action:@selector(addSeleted:) forControlEvents:UIControlEventTouchUpInside];
        [allbutton setBackgroundImage:IMAGEWITHNAME(@"icon_gouxuan_nor_gwc.png") forState:UIControlStateNormal];
        [allbutton setBackgroundImage:IMAGEWITHNAME(@"icon_gouxuan_cli_gwc.png") forState:UIControlStateSelected];
        [_headerView addSubview:allbutton];
        
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(allbutton.viewRightEdge+12, 0, 200, 43)];
        addressLabel.text = [NSString stringWithFormat:@"全选"];
        addressLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
        addressLabel.font = fontForSize(12);
        [_headerView addSubview:addressLabel];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = COLOR_BACKGRONDCOLOR;
        [_headerView addSubview:line];

    }
    return _headerView;
}


-(UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        _footerView.backgroundColor = [UIColor whiteColor];
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        topView.backgroundColor = COLOR_BACKGRONDCOLOR;
        [_footerView addSubview:topView];
        
        UILabel *applyWayL = [[UILabel alloc] initWithFrame:CGRectMake(15, topView.viewBottomEdge+15, SCREEN_WIDTH-30, 13)];
        applyWayL.text = @"退款方式";
        applyWayL.textColor = [UIColor colorWithHex:0x7f7f7f];
        applyWayL.font = fontForSize(13);
        [_footerView addSubview:applyWayL];
        
        UILabel *wayL = [[UILabel alloc] initWithFrame:CGRectMake(15, applyWayL.viewBottomEdge+15, 80, 20)];
        wayL.layer.borderWidth = 0.5;
        wayL.layer.borderColor = [UIColor colorWithHex:0xfd5478].CGColor;
        wayL.layer.cornerRadius = 3;
        wayL.layer.masksToBounds = YES;
        wayL.text = @"原支付返回";
        wayL.textColor = [UIColor colorWithHex:0x181818];
        wayL.textAlignment = NSTextAlignmentCenter;
        wayL.font = fontForSize(13);
        [_footerView addSubview:wayL];
        
        UIView *lineO = [[UIView alloc] initWithFrame:CGRectMake(0, wayL.viewBottomEdge+15, SCREEN_WIDTH, 0.5)];
        lineO.backgroundColor = COLOR_BACKGRONDCOLOR;
        [_footerView addSubview:lineO];
        
        UILabel *applyRL = [[UILabel alloc] initWithFrame:CGRectMake(15, lineO.viewBottomEdge+15, SCREEN_WIDTH-30, 13)];
        applyRL.text = @"申请原因";
        applyRL.textColor = [UIColor colorWithHex:0x7f7f7f];
        applyRL.font = fontForSize(13);
        [_footerView addSubview:applyRL];
        
        _applyRTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, applyRL.viewBottomEdge+15, SCREEN_WIDTH-30, 100)];
        _applyRTextView.layer.borderWidth = 0.5;
        _applyRTextView.layer.borderColor = COLOR_BACKGRONDCOLOR.CGColor;
        _applyRTextView.delegate = self;
        [_footerView addSubview:_applyRTextView];
        
        UIView*lineT = [[UIView alloc] initWithFrame:CGRectMake(0, _applyRTextView.viewBottomEdge+15, SCREEN_WIDTH, 0.5)];
        lineT.backgroundColor = COLOR_BACKGRONDCOLOR;
        [_footerView addSubview:lineT];
        
        UILabel *upImageL = [[UILabel alloc] initWithFrame:CGRectMake(15, lineT.viewBottomEdge+15, SCREEN_WIDTH, 13)];
        upImageL.text = @"上传图片";
        upImageL.textColor = [UIColor colorWithHex:0x7f7f7f];
        upImageL.font = fontForSize(13);
        [_footerView addSubview:upImageL];
        
        _scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(15, upImageL.viewBottomEdge+15, SCREEN_WIDTH-30, 68)];
        UIButton *addB = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 68, 68)];
        addB.tag = 909;
        [addB setBackgroundImage:IMAGEWITHNAME(@"icon_tianjiatupian_sqtk.png") forState:UIControlStateNormal];
        [addB addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
        [_scrollV addSubview:addB];
        [_footerView addSubview:_scrollV];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _scrollV.viewBottomEdge+15, SCREEN_WIDTH, 40)];
        bottomView.backgroundColor = COLOR_BACKGRONDCOLOR;
        [_footerView addSubview:bottomView];
        
        UILabel *indruceL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 23)];
        indruceL.text = @"因物流原因需退货，需上传商品图片，每张图片不超过5M，支持JPG、PNG格式";
        indruceL.textColor = [UIColor colorWithHex:0x7f7f7f];
        indruceL.font = fontForSize(10);
        indruceL.numberOfLines = 2;
        [indruceL sizeToFit];
        indruceL.viewSize = CGSizeMake(SCREEN_WIDTH-30, indruceL.viewHeight);
        [bottomView addSubview:indruceL];
        _footerView.viewSize = CGSizeMake(SCREEN_WIDTH, bottomView.viewY+bottomView.viewHeight);
        
    }
    return _footerView;
}

-(void)initUserInterFace{
    UIView *placeView = [[UIView alloc] init];
    [self.view addSubview:placeView];
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    [_tableView registerClass:[ApplyRTableViewCell class] forCellReuseIdentifier:@"applyCell"];
    if (_dataArray.count>0) {
        _tableView.tableFooterView  = self.footerView;
        _tableView.tableHeaderView  = self.headerView;
    }
    _tableView.backgroundColor = COLOR_BACKGRONDCOLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _submitOrderButton = [UIButton new];
    _submitOrderButton.viewSize = CGSizeMake(SCREEN_WIDTH, 49);
    [_submitOrderButton align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0,SCREEN_HEIGHT-64)];
    _submitOrderButton.titleLabel.font = fontForSize(16);
    [_submitOrderButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [_submitOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitOrderButton.backgroundColor = [UIColor colorWithHex:0xfd5487];
    [_submitOrderButton addTarget:self action:@selector(clickedSumbmiyOrderButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitOrderButton];

}
//提交订单（退款退货）
-(void)clickedSumbmiyOrderButton{
    NSMutableArray *jsonArray = [NSMutableArray array];
    NSString *json = @"";
    for (NSIndexPath *indexPath in _seleteArray) {
        NSDictionary *goodsInfodic = _dataArray[indexPath.row];
        NSDictionary *creatDic = @{@"goodsId":goodsInfodic[@"goods_id"],@"num":_numArray[indexPath.row]};
        [jsonArray addObject:creatDic];
    }
    if (jsonArray.count>0) {
        json = [TYTools dataJsonWithDic:jsonArray];
        json = [TYTools JSONDataStringTranslation:json];
    }
    if ([json isEqualToString:@""]) {
        SHOW_EEROR_MSG(@"尚未选择要退款商品");
        return;
    }
    if (_applyRTextView.text.length<=0) {
        SHOW_EEROR_MSG(@"请填写退款原因");
        return;
    }
    if (self.imageViews.count>0) {
        [self requestUploadMultipleImgs:json];
    }else{
        _submitOrderButton.userInteractionEnabled = NO;
        _submitOrderButton.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [BaseRequset sendPOSTRequestWithBMWApi2Method:@"ServiceAdd" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"refund":@"0",@"orderSn":_dataDic[@"order_sn"],@"goodsInfo":json,@"reason":_applyRTextView.text} callBack:^(RequestResult result, id object) {
            _submitOrderButton.userInteractionEnabled = YES;
            _submitOrderButton.backgroundColor = [UIColor colorWithHex:0xfd5487];
            if (RequestResultSuccess == result) {
                
                SHOW_SUCCESS_MSG(@"服务订单已经生成");
                [self.navigationController popViewControllerAnimated:YES];
                
                if (self.submitServiceOrderSuccess) {
                    self.submitServiceOrderSuccess();
                }
                
            }else{
                if([object isKindOfClass:[NSDictionary class]]){
                    NSString * code = object[@"code"];
                    if ([code integerValue] == 999) {
                        NSString * string = [((NSDictionary *)object) objectForKeyNotNull:@"data"];
                        if (string.length > 0) {
                            SHOW_MSG(string);
                        }
                    }
                    else{
                        SHOW_EEROR_MSG(@"提交失败,请稍后再试");
                    }
                }else{
                    SHOW_EEROR_MSG(@"提交失败,请稍后再试");
                }
                
            }
        }];
    }
}

- (void)requestUploadMultipleImgs:(NSString *)sender {
    
    self.HUD.labelText = [NSString stringWithFormat:@"上传第%ld张图片", (long)_currentImgIndex + 1];
    [self.HUD show:YES];
    UIImageView *imageView = self.imageViews[_currentImgIndex];
    UIImage *image = imageView.image;
    
    [BaseRequset upLoadImagewithGoodsImage:SERVICE_IMAGE_URL parmas:nil  withImage:image RequestSuccess:^(id result) {
        [self.imageString appendString:[NSString stringWithFormat:@"%@,",result[@"data"]]];
        // 判断是否有其他图片待传
        if (_currentImgIndex + 1 < self.imageViews.count) {
            _currentImgIndex++;
            [self requestUploadMultipleImgs:sender];
        } else {
            [self.HUD hide:YES];
            
            [_imageString deleteCharactersInRange:NSMakeRange(_imageString.length - 1, 1)];
            NSLog(@"finished img url - %@", _imageString);
            // 图片上传完成请求添加记录
            [self SendMessage:sender];
        }
    } failBlcok:^(id result) {
        
    }];
}

-(void)SendMessage:(NSString *)sender{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"ServiceAdd" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"refund":@"0",@"orderSn":_dataDic[@"order_sn"],@"goodsInfo":sender,@"reason":_applyRTextView.text,@"image":_imageString} callBack:^(RequestResult result, id object) {
        if (RequestResultSuccess == result) {
            SHOW_SUCCESS_MSG(@"服务订单已经生成");
            [self.navigationController popViewControllerAnimated:YES];
        }else if(RequestResultException == result){
            if ([object[@"code"] integerValue]==999) {
                SHOW_EEROR_MSG(@"已经存在服务单了");
            }
        }
    }];
}


-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    _numArray = [NSMutableArray array];
    for (int i =0; i<_dataArray.count; i++) {
        [_numArray addObject:_dataArray[i][@"goods_num"]];
    }
    if (_tableView) {
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        [_tableView reloadData];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ApplyRTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"applyCell" forIndexPath:indexPath];
    cell.chooseButton.selected = NO;
    if ([_seleteArray containsObject:indexPath]) {
        cell.chooseButton.selected = YES;
    }
    cell.dataDic = _dataArray[indexPath.row];
    [cell setClickButton:^(BOOL addOrReduce) {
        if (addOrReduce) {
            [_seleteArray addObject:indexPath];
            if (_seleteArray.count==_dataArray.count) {
                UIButton *button = [self.view viewWithTag:999];
                button.selected = YES;
            }else{
                UIButton *button = [self.view viewWithTag:999];
                button.selected = NO;
            }
        }else{
            [_seleteArray removeObject:indexPath];
            UIButton *button = [self.view viewWithTag:999];
            button.selected = NO;
        }
    }];
    
    [cell setNumaddOrduce:^(NSString * num) {
        _numArray[indexPath.row] = num;
    }];
    
    return cell;
}

//调用系统相机
-(void)addImage{
    [self.view endEditing:YES];
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"选取照片", nil];
    [actionSheet showInView:self.view];
    
}
//全选
-(void)addSeleted:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_seleteArray removeAllObjects];
        for (int i = 0; i<_dataArray.count; i++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
            [_seleteArray addObject:path];
        }
    }else{
        [_seleteArray removeAllObjects];
    }
    
    [_tableView reloadData];

}

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
            [self selectImagesFromImagePicker];
            break;
        default:
            break;
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
//        //设置前置后置摄像头
//        _imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;//后置
//        //闪光
//        _imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        if (IOS8) {
            _imagePickerController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
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
    UIImage * image = info[UIImagePickerControllerOriginalImage];
//    UIImage *imageV =   [TYTools originalImage:image scaleToSize:CGSizeMake(image.size.width, image.size.height)];
    UIImageView * phoneImageV = [[UIImageView alloc] initWithImage:image];
    [self.imageViews addObject:phoneImageV];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self updateScrollV];
    }];
    [_imagePickerController removeFromParentViewController];
    _imagePickerController = nil;
    
}

- (void)tapHandle:(UITapGestureRecognizer *)tap {
    
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    imageViewer.disableTouchDismiss = NO;
    [imageViewer showWithImageViews:self.imageViews
                       selectedView:(UIImageView *)tap.view];
    self.imageViewer = imageViewer;
}


- (void)selectImagesFromImagePicker {
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.mediaType = QBImagePickerMediaTypeImage;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    imagePickerController.maximumNumberOfSelection = 9;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

#pragma mark - QBImagePickerControllerDelegate
/**
 *  处理从图片选择器选中的图像
 *
 *  @param assets 包含ALAsset对象的数组
 */

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets
{
    if(IOS8){
        // 添加图片
        for (PHAsset *asset in assets) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            WEAK_SELF;
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:[UIScreen mainScreen].bounds.size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
                //设置图片
                [weakSelf.imageViews addObject:[[UIImageView alloc] initWithImage:result]];
                if (assets.count==weakSelf.imageViews.count) {
                    [weakSelf updateScrollV];
                }
            }];
        }
    }else{
        // 添加图片
        for (ALAsset *asset in assets) {
            UIImage *image = nil;
            if ([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                [self.imageViews addObject:[[UIImageView alloc] initWithImage:image]];
            }
        }
        [self updateScrollV];
        
    }
    // 刷新视图
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"Canceled.");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}



-(void)updateScrollV{
    UIButton *addB = [_scrollV viewWithTag:909];
    for (UIView *subsView in _scrollV.subviews) {
        [subsView removeFromSuperview];
    }
    _scrollV.contentSize = CGSizeMake(74*(self.imageViews.count+1), 68);
    if (74*(self.imageViews.count+1)+30>SCREEN_WIDTH) {
        _scrollV.contentOffset = CGPointMake(_scrollV.contentSize.width-SCREEN_WIDTH+10, 0);
    }
    for (int i = 0 ; i < self.imageViews.count; i++) {
        UIImageView *scrollImage = self.imageViews[i];
        scrollImage.frame = CGRectMake(74*i, 0, 68, 68);
        // 添加事件
        scrollImage.userInteractionEnabled = YES;
        // 添加手势
        UITapGestureRecognizer *gesture =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(tapHandle:)];
        [scrollImage addGestureRecognizer:gesture];
        [_scrollV addSubview:scrollImage];
    }
    addB.frame = CGRectMake(74*self.imageViews.count, 0, 68, 68);
    [_scrollV addSubview:addB];
    
}

- (void)deleteButtonPressed:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    
    [self.imageViewer disMissWithSelectedView];
    self.delete = YES;
}

#pragma mark - XHImageViewerDelegate

- (void)imageViewer:(XHImageViewer *)imageViewer didDismissWithSelectedView:(UIImageView *)selectedView {
    
    if (self.delete) {
        _currentImgIndex=0;
        [selectedView removeFromSuperview];
        [_imageViews removeObject:selectedView];
        [self updateScrollV];
        
        self.deleteButton.userInteractionEnabled = YES;
        self.delete = NO;
    }
}

- (void)imageViewer:(XHImageViewer *)imageViewer didShowImageView:(UIImageView *)selectedView {
    
    NSInteger index = [_imageViews indexOfObject:selectedView];
    self.countReminderLabel.text = [NSString stringWithFormat:@"%ld/%ld", index + 1, _imageViews.count];
}

- (UIView *)customBottomToolBarOfImageViewer:(XHImageViewer *)imageViewer {
    
    UIView *toolBar = [[UIView alloc] init];
    toolBar.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    toolBar.backgroundColor = [UIColor clearColor];
    
    [toolBar addSubview:self.countReminderLabel];
    [toolBar addSubview:self.deleteButton];
    [toolBar bringSubviewToFront:self.deleteButton];
    [toolBar bringSubviewToFront:self.countReminderLabel];
    
    return toolBar;
}




#pragma mark -- 网络请求
- (void)updateIconRequestWithDic:(NSDictionary *)dic {
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"changeAvatar" parameters:dic callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            SHOW_MSG(@"上传成功");
        }
        else {
            SHOW_MSG(@"上传失败");
        }
    }];
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


@end

