//
//  StoreDetailView.m
//  BMW
//
//  Created by LiuP on 2016/12/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "StoreDetailView.h"

static NSString * QRMessage = @"保存二维码图片到手机相册，用微信扫一扫选\n择二维码图片即可访问店铺";

@interface StoreDetailView ()

@property (nonatomic, assign) StoreType storeType;
@property (nonatomic, strong) UIScrollView * scrollView;    /**< 大背景 */
@property (nonatomic, strong) UIView * topView;             /**< 顶部视图，背景和头像、店名 */
@property (nonatomic, strong) UIImageView * backgroundImage;/**< 背景图 */
@property (nonatomic, strong) UIImageView * headImage;      /**< 头像 */
@property (nonatomic, strong) UILabel * storeName;          /**< 店名 */
@property (nonatomic, strong) UIView * middleView;          /**< 中间视图，店铺信息，联系方式 */
@property (nonatomic, strong) UIView * descriptionBack;     /**< 描述背景 */
@property (nonatomic, strong) UILabel * storeDescription;   /**< 店铺描述 */
@property (nonatomic, strong) NSMutableArray * items;       /**< 店铺信息控件 */
@property (nonatomic, strong) UIView * bottomView;          /**< 底部视图，二维码，提示信息 */
@property (nonatomic, strong) UIImageView * QRCodeImage;    /**< 底部二维码 */

@end

@implementation StoreDetailView

- (instancetype)initWithFrame:(CGRect)frame storeType:(StoreType)storeType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.storeType = storeType;
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    // 顶部视图相关
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, 160 * W_ABCW)];
    _topView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_topView];
    
    _backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 114 * W_ABCW)];
    _backgroundImage.image = [UIImage imageNamed:@"bj_tupian_dpxq.png"];
    [_topView addSubview:_backgroundImage];
    
    _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 62 * W_ABCW, 62 * W_ABCW)];
    _headImage.center = CGPointMake(_topView.viewWidth / 2, 67 * W_ABCW + _headImage.viewHeight / 2);
    _headImage.layer.cornerRadius = _headImage.viewWidth / 2;
    _headImage.clipsToBounds = YES;
    [_topView addSubview:_headImage];
    
    CGFloat origin_y = _headImage.viewBottomEdge;
    _storeName = [[UILabel alloc]initWithFrame:CGRectMake(10, origin_y, _topView.viewWidth - 20, _topView.viewHeight - origin_y)];
    _storeName.font = fontForSize(15 * W_ABCW);
    _storeName.textAlignment = NSTextAlignmentCenter;
    _storeName.textColor = COLOR_NAVIGATIONBAR_BARTINT;
    [_topView addSubview:_storeName];
    
    // 中间视图
    _middleView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topView.viewBottomEdge + 7 * W_ABCW, self.viewWidth, 105 * W_ABCW + 1.5)];
    _middleView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_middleView];

    NSArray * items;
    if (self.storeType == StorePerson) {
        items = @[@"手机号：", @"微信号：", @"QQ号："];
    }else if (self.storeType == StoreBMW) {
        items = @[@"微信公众号：", @"微信号：", @"客服热线："];
    }
    [self initStoreInfoViewWithItems:items];
    
    // 底部二维码视图
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _middleView.viewBottomEdge + 15 * W_ABCW, self.viewWidth, 0)];
    [_scrollView addSubview:_bottomView];
    
    CGFloat width = 120 * W_ABCW;
    _QRCodeImage = [[UIImageView alloc] initWithFrame:CGRectMake((_bottomView.viewWidth - width) / 2, 0, width, width)];
    _QRCodeImage.userInteractionEnabled = YES;
    _QRCodeImage.image = [UIImage imageNamed:@"jpg_erweima_dpxq.png"];
    [_bottomView addSubview:_QRCodeImage];
    
    UILabel * message = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _bottomView.viewWidth, 0)];
    message.font = fontForSize(11 * W_ABCW);
    message.textColor = [UIColor colorWithHex:0x666666];
    message.text = QRMessage;
    message.numberOfLines = 0;
    message.textAlignment = NSTextAlignmentCenter;
    [message sizeToFit];
    message.center = CGPointMake(_bottomView.viewWidth / 2, _QRCodeImage.viewBottomEdge + 7 * W_ABCW + message.viewHeight / 2);
    [_bottomView addSubview:message];
    
    _bottomView.viewSize = CGSizeMake(_bottomView.viewWidth, message.viewBottomEdge + 7 * W_ABCW);
    self.scrollView.contentSize = CGSizeMake(self.viewWidth, self.bottomView.viewBottomEdge);
}

- (void)initStoreInfoViewWithItems:(NSArray *)items
{
    _items = [NSMutableArray array];
    for (int i = 0; i < items.count; i ++) {
        NSString * item = items[i];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 35 * W_ABCW * i, _middleView.viewWidth, 0.5)];
        line.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
        [_middleView addSubview:line];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15 * W_ABCW, line.viewBottomEdge, 100, 0)];
        label.font = fontForSize(11 * W_ABCW);
        label.text = item;
        [label sizeToFit];
        label.viewSize = CGSizeMake(label.viewWidth, 35 * W_ABCW);
        [_middleView addSubview:label];
        
        CGFloat origin_x = label.viewRightEdge + 10;
        UILabel * content = [[UILabel alloc] initWithFrame:CGRectMake(origin_x, label.viewY, _middleView.viewWidth - 30 * W_ABCW - origin_x, label.viewHeight)];
        content.textColor = [UIColor colorWithHex:0x0b75f4];
        content.font = fontForSize(12 * W_ABCW);
        content.userInteractionEnabled = YES;
        [_middleView addSubview:content];
        [self.items addObject:content];
        
        if (self.storeType == StoreBMW) {
            if (i < items.count - 1) {  // 帮麦店前两个添加长按手势
                UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressSotreInfoAction:)];
                [content addGestureRecognizer:longPress];
            }else { // 最后一个添加单击手势
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStoreInfoAction:)];
                [content addGestureRecognizer:tap];
            }
        }
    }
}

#pragma mark -- getter
- (UILabel *)storeDescription
{
    if (!_storeDescription) {
        _descriptionBack = [[UIView alloc] initWithFrame:CGRectMake(0, self.topView.viewBottomEdge + 8 * W_ABCW, self.viewWidth, 0)];
        _descriptionBack.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:_descriptionBack];
        
        _storeDescription = [[UILabel alloc] initWithFrame:CGRectMake(15 * W_ABCW, 15 * W_ABCW, _descriptionBack.viewWidth - 30 * W_ABCW, 0)];
        _storeDescription.numberOfLines = 0;
        _storeDescription.font = fontForSize(12 * W_ABCW);
        [_descriptionBack addSubview:_storeDescription];
    }
    return _storeDescription;
}

#pragma mark -- setter
- (void)setModel:(StoreModel *)model
{
    _model = model;
    self.storeName.text = model.storeName;
    [self.QRCodeImage sd_setImageWithURL:[NSURL URLWithString:model.codeImage] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 网络图片，再加载完成之后再添加长按手势
        if (error) {
            return ;
        }
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressCodeAction:)];
        [_QRCodeImage addGestureRecognizer:longPress];
    }];
    if (model.storeDescription.length > 0) {
        self.storeDescription.text = model.storeDescription;
        [self.storeDescription sizeToFit];
        self.descriptionBack.viewSize = CGSizeMake(self.viewWidth, self.storeDescription.viewHeight + 30 * W_ABCW);
    }else {
        self.descriptionBack.viewSize = CGSizeMake(self.viewWidth, 0);
    }
    NSArray * info;
    if (model.isBMWStore) {
        info = @[model.publicWeChat, model.weChat, model.servicePhone];
        if ([model.headImage.lowercaseString hasPrefix:@"http"]) {
            [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.headImage]
                              placeholderImage:nil
                                       options:SDWebImageRefreshCached];
        }else {
            self.headImage.image = IMAGEWITHNAME(model.headImage);
        }
    }else {
        info = @[model.phone, model.weChat, model.QQ];
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.headImage]
                          placeholderImage:nil
                                   options:SDWebImageRefreshCached];
    }
    [self updateViewWithStoreInfo:info];
}

#pragma mark -- actions
// 帮麦店长按手势
- (void)longPressSotreInfoAction:(UILongPressGestureRecognizer *)longPress
{
    UILabel * content = (UILabel *)longPress.view;
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(storeView:longPressInfo:)]) {
            [self.delegate storeView:self longPressInfo:content.text];
        }
    }
}

// 帮麦店单击手势
- (void)tapStoreInfoAction:(UITapGestureRecognizer *)tap
{
    UILabel * content = (UILabel *)tap.view;
    if ([self.delegate respondsToSelector:@selector(storeView:tapServicePhone:)]) {
        [self.delegate storeView:self tapServicePhone:content.text];
    }
}

- (void)longPressCodeAction:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(storeView:longPressQRImage:)]) {
            [self.delegate storeView:self longPressQRImage:self.QRCodeImage];
        }
    }
}

#pragma mark -- 更新视图
- (void)updateViewWithStoreInfo:(NSArray *)info
{
    for (int i = 0; i < info.count; i ++) {
        UILabel * content = self.items[i];
        NSString * contentStr = info[i];
        content.text = contentStr;
    }
}

#pragma mark -- private
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_storeDescription) {
        self.middleView.frame = CGRectMake(0, self.descriptionBack.viewBottomEdge, self.middleView.viewWidth, self.middleView.viewHeight);
        self.bottomView.frame = CGRectMake(0, _middleView.viewBottomEdge + 15 * W_ABCW, self.bottomView.viewWidth, self.bottomView.viewHeight);
        self.scrollView.contentSize = CGSizeMake(self.viewWidth, self.bottomView.viewBottomEdge);
    }
}
@end
