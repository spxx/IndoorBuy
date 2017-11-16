//
//  ClassTitleView.m
//  BMW
//
//  Created by LiuP on 2016/12/8.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ClassTitleView.h"

@interface ClassTitleView ()
@property (nonatomic, strong) UIButton * classBtn;
@property (nonatomic, strong) UIButton * brandBtn;
@property (nonatomic, strong) UIView * line;
@property (nonatomic, strong) UIButton * selectedBtn;
@end

@implementation ClassTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.layer.borderWidth =1;
//        self.layer.borderColor = [UIColor colorWithHex:0xf84e40].CGColor;
//        self.layer.cornerRadius = 4;
//        self.clipsToBounds = YES;
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface
{
    
//    CGFloat btnWith = self.viewWidth/2;
//    
//    //分类button
//    _classBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btnWith, self.viewHeight)];
//    [_classBtn setTitle:@"分类" forState:UIControlStateNormal];
//    _classBtn.titleLabel.font = fontForSize(15);
//    [_classBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//    [_classBtn setTitleColor:[UIColor colorWithHex:0xf84e40] forState:UIControlStateNormal];
//    [_classBtn addTarget:self action:@selector(segementBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [_classBtn setBackgroundImage:[UIImage squareImageWithColor:[UIColor clearColor] andSize:_classBtn.viewSize] forState:UIControlStateNormal];
//    [_classBtn setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xf84e40] andSize:_classBtn.viewSize] forState:UIControlStateSelected];
//    _classBtn.tag = 100;
//    [self addSubview:_classBtn];
//    _classBtn.selected = YES;
//    self.selectedBtn = _classBtn;
//    
//    
//    //品牌button
//    _brandBtn = [[UIButton alloc]initWithFrame:CGRectMake(_classBtn.viewRightEdge, _classBtn.viewY, btnWith, self.viewHeight)];
//    [_brandBtn setTitle:@"品牌" forState:UIControlStateNormal];
//    _brandBtn.titleLabel.font = fontForSize(15);
//    [_brandBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//    [_brandBtn setTitleColor:[UIColor colorWithHex:0xf84e40] forState:UIControlStateNormal];
//    [_brandBtn setBackgroundImage:[UIImage squareImageWithColor:[UIColor clearColor] andSize:_brandBtn.viewSize] forState:UIControlStateNormal];
//    [_brandBtn setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xf84e40] andSize:_brandBtn.viewSize] forState:UIControlStateSelected];
//    [_brandBtn addTarget:self action:@selector(segementBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    _brandBtn.tag = 101;
//    [self addSubview:_brandBtn];

    
    _classBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _classBtn.selected = YES;
    _classBtn.frame = CGRectMake(0, 0, 37, self.viewHeight);
    _classBtn.titleLabel.font = fontForSize(13 * W_ABCW);
    [_classBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_classBtn setTitle:@"分类" forState:UIControlStateNormal];
    [_classBtn addTarget:self action:@selector(titleViewAction:) forControlEvents:UIControlEventTouchUpInside];
    _classBtn.titleEdgeInsets = UIEdgeInsetsMake(12, 0, 4, 0);
    [self addSubview:_classBtn];
    
    self.selectedBtn = _classBtn;
    
    _brandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _brandBtn.frame = CGRectMake(self.viewRightEdge - _classBtn.viewWidth, 0, _classBtn.viewWidth, self.viewHeight);
    _brandBtn.titleLabel.font = fontForSize(13 * W_ABCW);
    [_brandBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_brandBtn setTitle:@"品牌" forState:UIControlStateNormal];
    [_brandBtn addTarget:self action:@selector(titleViewAction:) forControlEvents:UIControlEventTouchUpInside];
    _brandBtn.titleEdgeInsets = UIEdgeInsetsMake(12, 0, 4, 0);
    [self addSubview:_brandBtn];

    _line = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewBottomEdge , _classBtn.viewWidth, 1.5)];
    _line.backgroundColor = [UIColor whiteColor];
    [self addSubview:_line];
}

//#pragma mark -- 临时
//- (void)segementBtnAction:(UIButton *)sender
//{
//    if (sender.selected) {
//        return;
//    }
//    self.selectedBtn.selected = NO;
//    sender.selected = YES;
//    self.selectedBtn = sender;
//    
//    ClassStatus status;
//    if (self.selectedBtn.tag == 100) {
//        status = ClassStatusClass;
//    }else {
//        status = ClassStatusBrand;
//    }
//    if ([self.delegate respondsToSelector:@selector(classTitleView:didSelectedBtnWithStatus:)]) {
//        [self.delegate classTitleView:self didSelectedBtnWithStatus:status];
//    }
//}


#pragma mark -- 暂时未使用
- (void)titleViewAction:(UIButton *)sender
{
    if (sender.selected) {
        return;
    }
    self.selectedBtn.selected = NO;
    sender.selected = YES;
    self.selectedBtn = sender;
    [self animationOfLine];
    
    ClassStatus status;
    if ([self.selectedBtn isEqual:self.classBtn]) {
        status = ClassStatusClass;
    }else {
        status = ClassStatusBrand;
    }
    if ([self.delegate respondsToSelector:@selector(classTitleView:didSelectedBtnWithStatus:)]) {
        [self.delegate classTitleView:self didSelectedBtnWithStatus:status];
    }
}

- (void)animationOfLine
{
    [UIView animateWithDuration:0.3 animations:^{
        self.line.frame = CGRectMake(self.selectedBtn.viewX, self.line.viewY, self.line.viewWidth, self.line.viewHeight);
    }];
}

#pragma mark -- other
// 交换按钮状态
- (void)exchangeBtnStatus:(ClassStatus)status
{
    if (status == ClassStatusClass) {
        _brandBtn.selected = NO;
        _classBtn.selected = YES;
        self.selectedBtn = _classBtn;
    }else {
        _classBtn.selected = NO;
        _brandBtn.selected = YES;
        self.selectedBtn = _brandBtn;

    }
    [self animationOfLine];
}
@end
