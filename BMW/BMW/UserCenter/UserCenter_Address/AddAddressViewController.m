//
//  AddressViewController.m
//  BMW
//
//  Created by 白琴 on 16/2/22.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "AddAddressViewController.h"

#define FirstComponent 0
#define SubComponent 1
#define ThirdComponent 2

@interface AddAddressViewController () <UIPickerViewDataSource,UIPickerViewDelegate, UITextFieldDelegate, UIScrollViewDelegate> {
    UIScrollView * _scrollView;
    UIButton * _setDefalutButton;           //设为默认
    UITextField * _nameTextField;           //收货人
    UITextField * _phoneTextField;          //电话
    UITextField * _areaAndCityTextFiled;    //地址
    UITextField * _addressTextField;        //详细地址
    UITextField * _cardTextField;           //身份证号
    UIButton * _areaAndCityButton;
    UITextField * _inputTextField;
    
    NSArray * _addressArray;                //整个地址数组
    NSMutableArray * _subPickerArray;       //第二级
    NSMutableArray * _thirdPickerArray;     //第三级
    NSMutableArray * _selectArray;          //选中的
    UIPickerView * _pickerView;
    UIView * _pickerViewBackgroundView;
    UIView * _buttonView;
    
    NSString * _isDefault;                        //是否设置为默认
    CGFloat _alertViewY;                    //提示的距离
    UIButton * _sureButton;
    UIButton * _saveButton;
}
/**
 *  基本信息视图
 */
@property (nonatomic, strong)UIView * baseInfoView;
/**
 *  温馨提示视图
 */
@property (nonatomic, strong)UIView * alertView;

@end

@implementation AddAddressViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增收货地址";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    
    [self navigation];
    [self initUserInterface];
    [self initAddressDataSource];
    [self registerKeyboardStateNotification];
    
    //配置导航栏的右侧按钮
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
    _saveButton.viewSize = CGSizeMake(50, 50);
    [_saveButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH + 50, 0)];
    _saveButton.titleLabel.font = fontForSize(15);
    [_saveButton setTitleColor:COLOR_NAVIGATIONBAR_ITEM forState:UIControlStateNormal];
    _saveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem * saveBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_saveButton];
    self.navigationItem.rightBarButtonItem = saveBtnItem;
    //如果是编辑页面
    if (self.addressDataSourceDic) {
        [_saveButton addTarget:self action:@selector(clickedSaveEditButton) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [_saveButton addTarget:self action:@selector(clickedSaveAddButton) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark -- 界面和初始化数据
/**
 *  初始化界面
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
    
    _isDefault = @"0";
    [_scrollView addSubview:self.baseInfoView];
    _alertView = 0;
    //如果是编辑页面
    if (self.addressDataSourceDic) {
        UIButton * deleteButton = [UIButton new];
        deleteButton.viewSize = CGSizeMake(SCREEN_WIDTH - 30, 45);
        [deleteButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, _baseInfoView.viewBottomEdge + 20)];
        deleteButton.titleLabel.font = fontForSize(16);
        [deleteButton setTitle:@"删除收货地址" forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        deleteButton.backgroundColor = [UIColor colorWithHex:0xfd5478];
        [deleteButton addTarget:self action:@selector(clickedDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:deleteButton];
        
        _alertViewY = deleteButton.viewBottomEdge + 25;
    }
    else {
        UIButton * setDefalutButton = [UIButton new];
        setDefalutButton.viewSize = CGSizeMake(18, 18);
        [setDefalutButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, _baseInfoView.viewBottomEdge + 10)];
        [setDefalutButton setBackgroundImage:[UIImage imageNamed:@"icon_gouxuan_cli_gwc"] forState:UIControlStateSelected];
        [setDefalutButton setBackgroundImage:[UIImage imageNamed:@"icon_gouxuan_nor_pj"] forState:UIControlStateNormal];
        [setDefalutButton addTarget:self action:@selector(setDefaulyButton:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:setDefalutButton];
        
        UILabel * alertLabel = [UILabel new];
        alertLabel.viewSize = CGSizeMake(100, 30);
        alertLabel.font = fontForSize(11);
        alertLabel.textColor = [UIColor colorWithHex:0x6f6f6f];
        alertLabel.text = @"设为默认地址";
        [alertLabel sizeToFit];
        [alertLabel align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(setDefalutButton.viewRightEdge + 8, setDefalutButton.viewBottomEdge)];
        [_scrollView addSubview:alertLabel];
        
        _alertViewY = _baseInfoView.viewBottomEdge + 39;
    }
    
    [_scrollView addSubview:self.alertView];
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _alertView.viewBottomEdge + 15);
    
}
/**
 *  基本信息视图
 */
- (UIView *)baseInfoView {
    if (!_baseInfoView) {
        _baseInfoView = [UIView new];
        _baseInfoView.viewSize = CGSizeMake(SCREEN_WIDTH, 45 * 5);
        [_baseInfoView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
        _baseInfoView.backgroundColor = [UIColor whiteColor];
        
        //姓名输入框
        _nameTextField = [UITextField new];
        _nameTextField.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_nameTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        _nameTextField.placeholder = @"请输入收货人姓名";
        _nameTextField.font = fontForSize(13);
        _nameTextField.delegate = self;
        _nameTextField.returnKeyType = UIReturnKeyDone;
        _nameTextField.textColor = [UIColor colorWithHex:0x181818];
        //创建一个左侧视图
        _nameTextField.leftViewMode = UITextFieldViewModeAlways;
        UIView * nameLeftView = [UIView new];
        nameLeftView.viewSize = CGSizeMake(93, _nameTextField.viewHeight);
        [nameLeftView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        //在左侧视图上面添加一个视图
        UILabel * nameLabel = [UILabel new];
        nameLabel.viewSize = CGSizeMake(80, nameLeftView.viewHeight);
        nameLabel.font = fontForSize(13);
        nameLabel.text = @"收货人:";
        nameLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        [nameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
        [nameLeftView addSubview:nameLabel];
        //将左侧视图添加到TextField上
        _nameTextField.leftView = nameLeftView;
        [_baseInfoView addSubview:_nameTextField];
        
        //分割线
        UIView * lineView1 = [UIView new];
        lineView1.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [lineView1 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _nameTextField.viewBottomEdge)];
        lineView1.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_baseInfoView addSubview:lineView1];
        //联系电话输入框
        _phoneTextField = [UITextField new];
        _phoneTextField.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_phoneTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, lineView1.viewBottomEdge)];
        _phoneTextField.placeholder = @"请输入收货人电话";
        _phoneTextField.font = fontForSize(13);
        _phoneTextField.delegate = self;
        _phoneTextField.returnKeyType = UIReturnKeyDone;
        _phoneTextField.textColor = [UIColor colorWithHex:0x181818];
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        //创建一个左侧视图
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
        UIView * phoneLeftView = [UIView new];
        phoneLeftView.viewSize = CGSizeMake(93, _phoneTextField.viewHeight);
        [phoneLeftView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        //在左侧视图上面添加一个视图
        UILabel * phoneLabel = [UILabel new];
        phoneLabel.viewSize = CGSizeMake(80, phoneLeftView.viewHeight);
        [phoneLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
        phoneLabel.font = fontForSize(13);
        phoneLabel.text = @"联系电话:";
        phoneLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        [phoneLeftView addSubview:phoneLabel];
        //将左侧视图添加到TextField上
        _phoneTextField.leftView = phoneLeftView;
        [_baseInfoView addSubview:_phoneTextField];
        
        
        //分割线
        UIView * lineView2 = [UIView new];
        lineView2.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [lineView2 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _phoneTextField.viewBottomEdge)];
        lineView2.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_baseInfoView addSubview:lineView2];
        //省市区输入框
        _areaAndCityTextFiled = [UITextField new];
        _areaAndCityTextFiled.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_areaAndCityTextFiled align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, lineView2.viewBottomEdge)];
        _areaAndCityTextFiled.placeholder = @"请选择省/市/区";
        _areaAndCityTextFiled.font = fontForSize(13);
        _areaAndCityTextFiled.textColor = [UIColor colorWithHex:0x181818];
        _areaAndCityTextFiled.userInteractionEnabled = NO;
        _areaAndCityTextFiled.leftViewMode = UITextFieldViewModeAlways;
        _areaAndCityTextFiled.rightViewMode = UITextFieldViewModeAlways;
        UIView * areaAndCityLeftView = [UIView new];
        areaAndCityLeftView.viewSize = CGSizeMake(93, _areaAndCityTextFiled.viewHeight);
        [areaAndCityLeftView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        UILabel * areaAndCityLabel = [UILabel new];
        areaAndCityLabel.viewSize = CGSizeMake(80, areaAndCityLeftView.viewHeight);
        [areaAndCityLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
        areaAndCityLabel.font = fontForSize(13);
        areaAndCityLabel.text = @"收货地址:";
        areaAndCityLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        [areaAndCityLeftView addSubview:areaAndCityLabel];
        _areaAndCityTextFiled.leftView = areaAndCityLeftView;
        [_baseInfoView addSubview:_areaAndCityTextFiled];
        //配置右侧箭头按钮
        UIView * areaAndCityRightView = [UIView new];
        areaAndCityRightView.viewSize = CGSizeMake(40, _areaAndCityTextFiled.viewHeight);
        [areaAndCityRightView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        UIButton * clickedButton = [UIButton new];
        clickedButton.viewSize = CGSizeMake(6, 10);
        [clickedButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(areaAndCityRightView.viewWidth - 15, (areaAndCityRightView.viewHeight - clickedButton.viewHeight) / 2)];
        [clickedButton setBackgroundImage:[UIImage imageNamed:@"icon_xiaojiantou_gwc"] forState:UIControlStateNormal];
        [areaAndCityRightView addSubview:clickedButton];
        _areaAndCityTextFiled.rightView = areaAndCityRightView;
        //覆盖一个大的View
        _areaAndCityButton = [UIButton new];
        _areaAndCityButton.viewSize = CGSizeMake(SCREEN_WIDTH - 93, _areaAndCityTextFiled.viewHeight);
        [_areaAndCityButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(93, _areaAndCityTextFiled.viewY)];
        _areaAndCityButton.backgroundColor = [UIColor clearColor];
        [_areaAndCityButton addTarget:self action:@selector(showPickerView:) forControlEvents:UIControlEventTouchUpInside];
        [_baseInfoView addSubview:_areaAndCityButton];
        
        //分割线
        UIView * lineView3 = [UIView new];
        lineView3.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [lineView3 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _areaAndCityTextFiled.viewBottomEdge)];
        lineView3.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_baseInfoView addSubview:lineView3];
        //详细地址输入框
        _addressTextField = [UITextField new];
        _addressTextField.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_addressTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, lineView3.viewBottomEdge)];
        _addressTextField.returnKeyType = UIReturnKeyDone;
        _addressTextField.delegate = self;
        _addressTextField.placeholder = @"请输入详细地址";
        _addressTextField.font = fontForSize(13);
        _addressTextField.textColor = [UIColor colorWithHex:0x181818];
        //创建一个左侧视图
        _addressTextField.leftViewMode = UITextFieldViewModeAlways;
        UIView * addressLeftView = [UIView new];
        addressLeftView.viewSize = CGSizeMake(93, _addressTextField.viewHeight);
        [addressLeftView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        //在左侧视图上面添加一个视图
        UILabel * addressLabel = [UILabel new];
        addressLabel.viewSize = CGSizeMake(80, addressLeftView.viewHeight);
        [addressLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
        addressLabel.font = fontForSize(13);
        addressLabel.text = @"详细地址:";
        addressLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        [addressLeftView addSubview:addressLabel];
        //将左侧视图添加到TextField上
        _addressTextField.leftView = addressLeftView;
        [_baseInfoView addSubview:_addressTextField];
        
        
        //分割线
        UIView * lineView4 = [UIView new];
        lineView4.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [lineView4 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _addressTextField.viewBottomEdge)];
        lineView4.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_baseInfoView addSubview:lineView4];
        //身份证号输入框
        _cardTextField = [UITextField new];
        _cardTextField.viewSize = CGSizeMake(SCREEN_WIDTH, 45);
        [_cardTextField align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, lineView4.viewBottomEdge)];
        _cardTextField.placeholder = @"请输入正确身份证号码";
        _cardTextField.font = fontForSize(13);
        _cardTextField.textColor = [UIColor colorWithHex:0x181818];
        _cardTextField.returnKeyType = UIReturnKeyDone;
        _cardTextField.delegate = self;
        //创建一个左侧视图
        _cardTextField.leftViewMode = UITextFieldViewModeAlways;
        UIView * cardLeftView = [UIView new];
        cardLeftView.viewSize = CGSizeMake(93, _cardTextField.viewHeight);
        [cardLeftView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        //在左侧视图上面添加一个视图
        UILabel * cardLabel = [UILabel new];
        cardLabel.viewSize = CGSizeMake(80, cardLeftView.viewHeight);
        [cardLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
        cardLabel.font = fontForSize(13);
        cardLabel.text = @"身份证号:";
        cardLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        [cardLeftView addSubview:cardLabel];
        //将左侧视图添加到TextField上
        _cardTextField.leftView = cardLeftView;
        [_baseInfoView addSubview:_cardTextField];
        
        //重新计算白色背景视图的高度
        _baseInfoView.viewSize = CGSizeMake(SCREEN_WIDTH, _cardTextField.viewBottomEdge);
        //分割线
        UIView * lineView5 = [UIView new];
        lineView5.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
        [lineView5 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _baseInfoView.viewHeight)];
        lineView5.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_baseInfoView addSubview:lineView5];
        
        //如果是编辑页面
        if (self.addressDataSourceDic) {
            self.title = @"编辑收货地址";
            _nameTextField.text = self.addressDataSourceDic[@"true_name"];
            _phoneTextField.text = self.addressDataSourceDic[@"mob_phone"];
            _areaAndCityTextFiled.text = self.addressDataSourceDic[@"area_info"];
            _addressTextField.text = self.addressDataSourceDic[@"address"];
            _cardTextField.text = self.addressDataSourceDic[@"idcard"];
        }
        
    }
    return _baseInfoView;
}

- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [UIView new];
        _alertView.viewSize = CGSizeMake(SCREEN_WIDTH, 50);
        [_alertView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _alertViewY)];
        _alertView.backgroundColor = COLOR_BACKGRONDCOLOR;
        
        UIImageView * lineImageView = [UIImageView new];
        lineImageView.viewSize = CGSizeMake(SCREEN_WIDTH - 30, 12);
        [lineImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
        lineImageView.image = [UIImage imageNamed:@"jpg_wenxintishi_shdztj"];
        [_alertView addSubview:lineImageView];
        
        UILabel * alert1Label = [UILabel new];
        alert1Label.viewSize = CGSizeMake(SCREEN_WIDTH - 30, 40);
        alert1Label.textColor = [UIColor colorWithHex:0x7f7f7f];
        alert1Label.text = @"1、国家海关需要对海外购物查验身份信息，请注意收货人与身份证一致，错误信息可能导致无法正常通关；";
        [self sizeToFitLabel:alert1Label];
        [alert1Label align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, lineImageView.viewBottomEdge + 15)];
        [_alertView addSubview:alert1Label];
        
        UILabel * alert2Label = [UILabel new];
        alert2Label.viewSize = CGSizeMake(SCREEN_WIDTH - 30, 40);
        alert2Label.textColor = [UIColor colorWithHex:0x7f7f7f];
        alert2Label.text = @"2、身份证信息将加密报关，帮麦将保证您的信息安全。";
        [self sizeToFitLabel:alert2Label];
        [alert2Label align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, alert1Label.viewBottomEdge + 17)];
        [_alertView addSubview:alert2Label];
        
        _alertView.viewSize = CGSizeMake(SCREEN_WIDTH, alert2Label.viewBottomEdge);
    }
    return _alertView;
}

- (void)sizeToFitLabel:(UILabel *)lable {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10], NSParagraphStyleAttributeName:paragraphStyle};
    lable.attributedText =[[NSAttributedString alloc] initWithString:lable.text attributes:attributes];
    lable.numberOfLines = 0;
    [lable sizeToFit];
}

/**
 *  初始化地址数据
 */
- (void)initAddressDataSource {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"newAddress" ofType:@"plist"];
    NSLog(@"path = %@",path);
    _addressArray = [NSArray arrayWithContentsOfFile:path];
    
    _selectArray = [NSMutableArray arrayWithArray:_addressArray[0][@"secondStage"]];
    if (_selectArray.count > 0) {
        _subPickerArray = [NSMutableArray arrayWithArray:_addressArray[0][@"secondStage"]];
    }
    if (_subPickerArray.count > 0) {
        _thirdPickerArray = [NSMutableArray arrayWithArray:_subPickerArray[0][@"thirdStage"]];
    }
}
#pragma mark -- 网络请求
/**
 *  添加收货地址
 */
- (void)addAddressRequest {
    if (![self improveTheJudgmentInformation]) {
        _saveButton.userInteractionEnabled = YES;
        return;
    }
    NSInteger second = [_pickerView selectedRowInComponent:1];
    NSInteger third = [_pickerView selectedRowInComponent:2];
    NSString * _areaID;
    if (_thirdPickerArray) {
        _areaID = _thirdPickerArray[third][@"area_id"];
    }
    else {
        _areaID = _subPickerArray[second][@"area_id"];
    }
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"AddressAdd" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID, @"true_name":_nameTextField.text, @"area_id":_areaID, @"city_id":_subPickerArray[second][@"area_id"], @"area_info":_areaAndCityTextFiled.text, @"address":_addressTextField.text, @"mob_phone":_phoneTextField.text, @"idcard":_cardTextField.text, @"is_default":_isDefault} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result==RequestResultSuccess) {
            NSLog(@"添加成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            _saveButton.userInteractionEnabled = YES;
            NSLog(@"添加失败");
        }
    }];
}
/**
 *  编辑收货地址
 */
- (void)editAddressRequest {
    if (![self improveTheJudgmentInformation]) {
        _saveButton.userInteractionEnabled = YES;
        return;
    }
    NSInteger second = [_pickerView selectedRowInComponent:1];
    NSInteger third = [_pickerView selectedRowInComponent:2];
    NSString * _areaID;
    if (_thirdPickerArray) {
        _areaID = _thirdPickerArray[third][@"area_id"];
    }
    else {
        _areaID = _subPickerArray[second][@"area_id"];
    }
    NSDictionary * dic;
    if (second && third) {
        dic = @{@"addressId":self.addressDataSourceDic[@"address_id"], @"true_name":_nameTextField.text,  @"area_id":_areaID, @"city_id":_subPickerArray[second][@"area_id"], @"area_info":_areaAndCityTextFiled.text, @"address":_addressTextField.text, @"mob_phone":_phoneTextField.text, @"idcard":_cardTextField.text, @"is_default":_isDefault};
    }
    else {
        dic = @{@"addressId":self.addressDataSourceDic[@"address_id"], @"true_name":_nameTextField.text,  @"area_id":self.addressDataSourceDic[@"area_id"], @"city_id":self.addressDataSourceDic[@"city_id"], @"area_info":_areaAndCityTextFiled.text, @"address":_addressTextField.text, @"mob_phone":_phoneTextField.text, @"idcard":_cardTextField.text, @"is_default":self.addressDataSourceDic[@"is_default"]};
    }
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"AddressEdit" parameters:dic callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result==RequestResultSuccess) {
            SHOW_MSG(@"修改成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            _saveButton.userInteractionEnabled = YES;
            SHOW_MSG(@"修改失败");
        }
    }];
}

/**
 *  删除收货地址的网络请求
 */
- (void)deleteAddressRequest {
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"AddressDel" parameters:@{@"addressId":self.addressDataSourceDic[@"address_id"]} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (result==RequestResultSuccess) {
            SHOW_MSG(@"删除成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            SHOW_MSG(@"删除失败");
        }
    }];
}


#pragma mark -- 点击事件
/**
 *  点击选择省市区按钮
 */
- (void)showPickerView:(UIButton *)sender {
    NSLog(@"点击省市区按钮");
    [self.view endEditing:YES];
    sender.userInteractionEnabled = NO;

    _selectArray = _addressArray[0][@"secondStage"];
    if (_selectArray.count > 0) {
        _subPickerArray = _addressArray[0][@"secondStage"];
    }
    if (_subPickerArray.count > 0) {
        _thirdPickerArray = _subPickerArray[0][@"thirdStage"];
    }
    
    _pickerViewBackgroundView = [UIView new];
    _pickerViewBackgroundView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [_pickerViewBackgroundView align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, SCREEN_HEIGHT)];
    _pickerViewBackgroundView.backgroundColor = [UIColor clearColor];
    _pickerViewBackgroundView.alpha = 0.0;
    [self.view addSubview:_pickerViewBackgroundView];
    
    _buttonView = [UIView new];
    _buttonView.viewSize = CGSizeMake(SCREEN_WIDTH, 248);
    [_buttonView align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, SCREEN_HEIGHT + 100)];
    _buttonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_buttonView];
    
    _sureButton = [UIButton new];
    _sureButton.viewSize = CGSizeMake(50, 38);
    [_sureButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, 0)];
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [_sureButton setTitleColor:[UIColor colorWithHex:0x3d3d3d] forState:UIControlStateNormal];
    _sureButton.titleLabel.font = fontForSize(13);
    [_sureButton addTarget:self action:@selector(clickedCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:_sureButton];
    
    _pickerView = [UIPickerView new];
    _pickerView.viewSize = CGSizeMake(SCREEN_WIDTH, 210);
    [_pickerView align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, _buttonView.viewHeight)];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.backgroundColor = [UIColor whiteColor];
    
    [_buttonView addSubview:_pickerView];
    
    [self pickerView:_pickerView didSelectRow:0 inComponent:0];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        _pickerViewBackgroundView.alpha = 1.0;
       [_buttonView align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, SCREEN_HEIGHT - 64)];
    } completion:^(BOOL finished) {
        
    }];
}
/**
 *  点击地址选择的确定按钮
 */
- (void)clickedCancelButton {
    
    [self cancleAnimation];
}
/**
 *  选择了之后 改变textfield的值
 */
- (void)clickedSureButton {
    NSInteger first = [_pickerView selectedRowInComponent:0];
    NSInteger second = [_pickerView selectedRowInComponent:1];
    NSInteger third = [_pickerView selectedRowInComponent:2];
    if (_thirdPickerArray) {
        _areaAndCityTextFiled.text = [NSString stringWithFormat:@"%@%@%@", _addressArray[first][@"area_name"], _subPickerArray[second][@"area_name"], _thirdPickerArray[third][@"area_name"]];
    }
    else {
       _areaAndCityTextFiled.text = [NSString stringWithFormat:@"%@%@", _addressArray[first][@"area_name"], _subPickerArray[second][@"area_name"]];
    }
}
/**
 *  地址选择器的消失动画
 */
- (void)cancleAnimation {
    [UIView animateWithDuration:0.5 animations:^{
        [_buttonView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, SCREEN_HEIGHT + 100)];
    } completion:^(BOOL finished) {
        _pickerViewBackgroundView.alpha = 0;
       [_pickerView removeFromSuperview];
        [_buttonView removeFromSuperview];
        [_pickerViewBackgroundView removeFromSuperview];
    }];
    _areaAndCityButton.userInteractionEnabled = YES;
}

/**
 *  点击设为默认按钮
 */
- (void)setDefaulyButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _isDefault = @"1";
    }
    else {
        _isDefault = @"0";
    }
}
/**
 *  添加界面点击保存
 */
- (void)clickedSaveAddButton {
    [self.view endEditing:YES];
    _saveButton.userInteractionEnabled = NO;
    [self addAddressRequest];
}
/**
 *  编辑界面点击保存
 */
- (void)clickedSaveEditButton {
    [self.view endEditing:YES];
    _saveButton.userInteractionEnabled = NO;
    [self editAddressRequest];
}
/**
 *  删除收货地址
 */
- (void)clickedDeleteButton:(UIButton *)sender {
    [self deleteAddressRequest];
}
#pragma mark -- 其他
/**
 *  判断信息的完善
 */
- (BOOL)improveTheJudgmentInformation {
    if (_nameTextField.text.length == 0) {
        SHOW_MSG(@"姓名为空");
        return NO;
    }
    if (_phoneTextField.text.length == 0) {
        SHOW_MSG(@"手机号为空");
        return NO;
    }
    if (_areaAndCityTextFiled.text.length == 0) {
        SHOW_MSG(@"省市区信息为空");
        return NO;
    }
    if (_addressTextField.text.length == 0) {
        SHOW_MSG(@"地址为空");
        return NO;
    }
    if (_cardTextField.text.length == 0) {
        SHOW_MSG(@"身份号为空");
        return NO;
    }
    if (![TYTools isMobileNumber:_phoneTextField.text]) {
        SHOW_MSG(@"手机号码不存在");
        return NO;
    }
    if (![TYTools isIdCard:_cardTextField.text]) {
        SHOW_MSG(@"身份证号不存在");
        return NO;
    }
    return YES;
}


#pragma mark - - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == FirstComponent) {
        return _addressArray.count;
    }
    if (component == SubComponent) {
        return _subPickerArray.count;
    }
    if (component == ThirdComponent) {
        return _thirdPickerArray.count;
    }
    return 0;
}

#pragma mark - - UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == FirstComponent) {
        return _addressArray[row][@"area_name"];
    }
    if (component == SubComponent) {
        return _subPickerArray[row][@"area_name"];
    }
    if (component == ThirdComponent) {
        return _thirdPickerArray[row][@"area_name"];
    }
    return nil;
}

/**
 *  调整pickerView的字体大小
 */
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *myView = (UILabel*)view;
    if (!myView) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.font = [UIFont systemFontOfSize:13];         //用label来设置字体大小
        myView.backgroundColor = [UIColor clearColor];
    }
    
    if (component == FirstComponent) {
        myView.text = _addressArray[row][@"area_name"];
    }
    if (component == SubComponent) {
        myView.text = _subPickerArray[row][@"area_name"];
    }
    if (component == ThirdComponent) {
        myView.text = _thirdPickerArray[row][@"area_name"];
    }
    return myView;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    if (component == 0) {
        _selectArray = _addressArray[row][@"secondStage"];
        if (_selectArray.count > 0) {
            _subPickerArray = _addressArray[row][@"secondStage"];
        }
        else {
            _subPickerArray = nil;
        }
        if (_subPickerArray.count > 0) {
            _thirdPickerArray = _subPickerArray[0][@"thirdStage"];
        }
        else {
            _thirdPickerArray = nil;
        }
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:NO];
        [pickerView selectRow:0 inComponent:2 animated:NO];
        
    }
    if (component == 1) {
        if (_selectArray.count > 0 && _subPickerArray.count > 0) {
            _thirdPickerArray = _selectArray[row][@"thirdStage"];
        }else{
            _thirdPickerArray = nil;
        }
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    [self clickedSureButton];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //手机号
    if (textField == _phoneTextField) {
        if (textField.text.length >10) {
            if([string isEqualToString:@""])
            {
                return YES;
            }
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _inputTextField = textField;
    if (textField != _areaAndCityTextFiled) {
        [self cancleAnimation];
    }
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
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
