//
//  StoreDetailViewController.m
//  BMW
//
//  Created by LiuP on 2016/12/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "StoreDetailViewController.h"
#import "StoreDetailView.h"

@interface StoreDetailViewController ()<StoreViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) StoreDetailView * storeView;
@property (nonatomic, strong) UIWebView * webView;  /**< 用于打电话 */

@property (nonatomic, copy) NSString * pasteStr;     /**< 需要拷贝的信息 */
@property (nonatomic, strong) UIImageView * QRImage;   /**< 需要保存的二维码 */

@end

@implementation StoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUserInterface];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- UI
- (void)initUserInterface
{
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    self.title = @"店铺详情";
    [self navigation];
    
    StoreType store;
    BOOL BMW;
    if (self.storeType == 1) {
        store = StoreBMW;
        BMW = YES;
    }else {
        store = StorePerson;
        BMW = NO;
    }
    _storeView = [[StoreDetailView alloc] initWithFrame:self.view.bounds storeType:store];
    _storeView.delegate = self;
    [self.view addSubview:_storeView];
    
    [self.HUD show:YES];
    [StoreModel requestForStoreInfoWithStoreID:self.storeID
                                           BMW:BMW
                                      complete:^(BOOL isSuccess, StoreModel *model, NSString *message) {
        [self.HUD hide:YES];
        if (isSuccess) {
            self.storeView.model = model;
        }else {
            SHOW_EEROR_MSG(message);
        }
    }];
}

#pragma mark -- getter
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}

#pragma mark -- StoreViewDelegate
// 长按帮麦店信息
- (void)storeView:(StoreDetailView *)storeView longPressInfo:(NSString *)info
{
    if (info.length > 0) {
        self.pasteStr = info;
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拷贝", nil];
        sheet.tag = 100;
        [sheet showInView:self.view];
    }
}

// 单击客服热线
- (void)storeView:(StoreDetailView *)storeView tapServicePhone:(NSString *)phone
{
    if (phone.length > 0) {
        NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@", phone];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    }
}

//长按二维码
- (void)storeView:(StoreDetailView *)storeView longPressQRImage:(UIImageView *)QRImage
{
    self.QRImage = QRImage;
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机", nil];
    sheet.tag = 101;
    [sheet showInView:self.view];
}

#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        if (actionSheet.tag == 100) {  // 拷贝信息
            UIPasteboard * pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.pasteStr;
        }
        if (actionSheet.tag == 101) {  // 保存二维码
            UIImageWriteToSavedPhotosAlbum(self.QRImage.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

        }
    }
}

// 保存图片结果回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil) {
        SHOW_SUCCESS_MSG(@"已保存至相册");
    }else {
        SHOW_EEROR_MSG(error.localizedDescription);
    }
}
@end
