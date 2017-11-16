//
//  CreateCodeVC.m
//  DP
//
//  Created by LiuP on 16/7/28.
//  Copyright © 2016年 sp. All rights reserved.
//

#import "CreateCodeVC.h"
#import "CreateCodeView.h"

@interface CreateCodeVC ()<CreateCodeViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) CreateCodeView * createCodeView;

@end

@implementation CreateCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"二维码";

    [self navigation];
    
    [self initUserInterface];
    [self initRightItem];
    [self creatQrcodeImageAction];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -- UI

- (void)initRightItem
{
    UIButton * downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downloadBtn.frame = CGRectMake(0, 0, 19, 19);
    [downloadBtn setBackgroundImage:IMAGEWITHNAME(@"icon_xiazai_gmlj.png") forState:UIControlStateNormal];
    [downloadBtn addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * downloadItem = [[UIBarButtonItem alloc]initWithCustomView:downloadBtn];
    self.navigationItem.rightBarButtonItem = downloadItem;

}

- (void)initUserInterface
{
    _createCodeView = [[CreateCodeView alloc]initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight - 64)];
    _createCodeView.titleStr = self.titleStr;
    _createCodeView.delegate = self;
    [self.view addSubview:_createCodeView];
}

#pragma mark -- 生成二维码图片
- (void)creatQrcodeImageAction
{
    NSAssert(self.shareUrl, @"用于生成二维码的链接必须存在");
    [self.HUD show:YES];
    [CodeModel requestForCreateCodeWithShareUrl:self.shareUrl complete:^(NSString *imageUrl, NSString *message, NSInteger code) {
        [self.HUD hide:YES];
        if (code == 100) {
            self.createCodeView.imageUrl = imageUrl;
        }else {
            SHOW_EEROR_MSG(message);
        }
    }];
}
#pragma mark -- private
- (void)showActionSheet
{
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机", nil];
    [sheet showInView:self.view];
}

#pragma mark -- actions
- (void)downloadAction:(UIButton *)sender
{
    [self showActionSheet];
}

#pragma mark -- CreateCodeViewDelegate
- (void)codeView:(CreateCodeView *)codeView longPressedWithCodeImage:(UIImage *)codeImage
{
    [self showActionSheet];
}

#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        NSLog(@"保存到手机");
        UIImageWriteToSavedPhotosAlbum(self.createCodeView.QRImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

// 保存结果回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil) {
        if ([self.shareUrl rangeOfString:@"drp_code"].location != NSNotFound) {
            SHOW_SUCCESS_MSG(@"保存到相册！限一次性支付");
        }else {
            SHOW_SUCCESS_MSG(@"已保存至相册");
        }
    }else {
        SHOW_EEROR_MSG(error.localizedDescription);
    }
}
@end
