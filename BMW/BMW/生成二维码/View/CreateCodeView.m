//
//  CreateCodeView.m
//  DP
//
//  Created by LiuP on 16/7/28.
//  Copyright © 2016年 sp. All rights reserved.
//

#import "CreateCodeView.h"


static NSString * messageStr = @"小提示：扫描该二维码可以打开您准备分享商品的购买链接，您也可以点击右上角的保存，将二维码保存到手机";

@interface CreateCodeView ()

@property (nonatomic, strong) UIImageView * codeImage;  /**< 二维码 */

@property (nonatomic, strong) UILabel * title; /**< 名称 */

@property (nonatomic, strong) UILabel * origin; /**< 来源 */

@property (nonatomic, strong) UIImageView * image;  /**< 叹号 */

@property (nonatomic, strong) UILabel * message;    /**< 提示信息 */

@end

@implementation CreateCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self initUserInterface];
        
    }
    return self;
}

- (void)initUserInterface
{
    CGFloat width = 192 * W_ABCW;
    _codeImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
    _codeImage.center = CGPointMake(self.center.x, 69 * W_ABCH + width / 2);
    _codeImage.userInteractionEnabled = YES;
    [self addSubview:_codeImage];
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressCodeAction:)];
    [_codeImage addGestureRecognizer:longPress];
    
    _title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth - 40 * W_ABCW, 0)];
    _title.font = [UIFont boldSystemFontOfSize:14 * W_ABCW];
    _title.textColor = COLOR_NAVIGATIONBAR_BARTINT;
    _title.textAlignment = NSTextAlignmentCenter;
    _title.numberOfLines = 0;
    [self addSubview:_title];
    
    _origin = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _title.viewWidth, 0)];
    _origin.font = [UIFont systemFontOfSize:11 * W_ABCW];
    _origin.textColor = [UIColor colorWithHex:0x7f7f7f];
    _origin.textAlignment = NSTextAlignmentCenter;
    _origin.numberOfLines = 0;
    [self addSubview:_origin];
    
    _image = [[UIImageView alloc]initWithFrame:CGRectMake(20 * W_ABCW, _origin.viewBottomEdge + 103 * W_ABCH, 16 * W_ABCW, 16 * W_ABCW)];
    _image.image = IMAGEWITHNAME(@"icon_zhuyi_gmlj.png");
    [self addSubview:_image];
    
    CGFloat messageWidth = self.viewWidth - (_image.viewRightEdge + 26 * W_ABCW);
    _message = [[UILabel alloc]initWithFrame:CGRectMake(_image.viewRightEdge + 6 * W_ABCW, _image.viewY, messageWidth, 0)];
    _message.font = [UIFont systemFontOfSize:11 * W_ABCW];
    _message.textColor = [UIColor colorWithHex:0xb0b0b0];
    _message.text = messageStr;
    _message.numberOfLines = 0;
    [_message sizeToFit];
    [self addSubview:_message];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _title.center = CGPointMake(self.center.x, _codeImage.viewBottomEdge + 32 * W_ABCH + _title.viewHeight / 2);
    _origin.center = CGPointMake(self.center.x, _title.viewBottomEdge + 19 * W_ABCH + _origin.viewHeight / 2);
    _message.frame = CGRectMake(_image.viewRightEdge + 6 * W_ABCW, self.viewHeight - 15 * W_ABCW - _message.viewHeight, _message.viewWidth, _message.viewHeight);
    _image.frame = CGRectMake(_image.viewX, _message.viewY, _image.viewWidth, _image.viewHeight);
}

#pragma mark -- getter
- (UIImage *)QRImage
{
    if (!_QRImage) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.viewWidth, _origin.viewBottomEdge - 20 * W_ABCH),
                                               NO,
                                               [UIScreen mainScreen].scale);
        [self drawViewHierarchyInRect:CGRectMake(self.viewX, self.viewY - 49 * W_ABCH,
                                                 self.viewWidth, self.viewHeight)
                   afterScreenUpdates:YES];
        _QRImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _QRImage;
}

#pragma mark -- setter
- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    [self.codeImage sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:nil options:SDWebImageRefreshCached];
    
    NSString * headImage = _imageUrl;
    // 先移除该头像地址的缓存
    WEAK_SELF;
    [[SDImageCache sharedImageCache] removeImageForKey:headImage withCompletion:^{
        
        UIImageView * tempImage = [[UIImageView alloc] init];
        [weakSelf addSubview:tempImage];
        [tempImage sd_setImageWithURL:[NSURL URLWithString:headImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                weakSelf.codeImage.image = image;
            } else {
                SHOW_EEROR_MSG(@"网络故障，请重新生成");
            }
            [tempImage removeFromSuperview];
        }];
    }];
    
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    
    _title.text = _titleStr;
    [_title sizeToFit];
    
    _origin.text = [NSString stringWithFormat:@"帮麦微店 · 分享来自\n%@****%@",[[JCUserContext sharedManager].currentUserInfo.memberName substringToIndex:3],[[JCUserContext sharedManager].currentUserInfo.memberName substringFromIndex:7]];
    [_origin sizeToFit];
}

#pragma mark -- longPressCodeAction
- (void)longPressCodeAction:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(codeView:longPressedWithCodeImage:)]) {
            [self.delegate codeView:self longPressedWithCodeImage:self.QRImage];
        }
    }
}

@end
