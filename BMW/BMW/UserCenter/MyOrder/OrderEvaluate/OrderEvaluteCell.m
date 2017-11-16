//
//  OrderEvaluteCell.m
//  BMW
//
//  Created by gukai on 16/3/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OrderEvaluteCell.h"

@interface OrderEvaluteCell ()<UITextViewDelegate>
@property(nonatomic,strong)UIImageView * goodImage;
@property(nonatomic,strong)UILabel * infoLabel;
@property(nonatomic,strong)UITextView * textView;
@property(nonatomic,copy)NSMutableArray * starArr;

@property(nonatomic,strong)UILabel * placeHolder;
@end
@implementation OrderEvaluteCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initData];
        [self initUserInterface];
    }
    return self;
}
-(void)initData
{
    _starArr = [NSMutableArray array];
}
-(void)initUserInterface
{
    UIImageView * goodImage = [[UIImageView alloc]initWithFrame:CGRectMake(15 * W_ABCW, 15, 60 * W_ABCW, 60 * W_ABCW)];
    //goodImage.backgroundColor = [UIColor orangeColor];
    [self addSubview:goodImage];
    self.goodImage = goodImage;
    
    UILabel * infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodImage.viewRightEdge + 14 , goodImage.viewY, SCREEN_WIDTH - goodImage.viewRightEdge  - 14 , 40)];
    //infoLabel.backgroundColor = [UIColor blueColor];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.font = fontForSize(14);
    infoLabel.numberOfLines = 2;
    infoLabel.text = @"德国爱他美奶粉Aptami l 1+(12个月以上)600g";
    [self addSubview:infoLabel];
    self.infoLabel = infoLabel;
    
    for (int i = 0; i < 5; i ++) {
        UIButton * starBtn = [[UIButton alloc]initWithFrame:CGRectMake(infoLabel.viewX + (18 + 8) * i, goodImage.viewBottomEdge - 17, 18, 17)];
        [starBtn setImage:[UIImage imageNamed:@"icon_pingxing_nor_pj.png"] forState:UIControlStateNormal];
        [starBtn setImage:[UIImage imageNamed:@"icon_pingxing_cli_pj.png"] forState:UIControlStateSelected];
        [starBtn addTarget:self action:@selector(starBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        starBtn.tag = 100 + i;
        starBtn.selected = YES;
        [self addSubview:starBtn];
        [_starArr addObject:starBtn];
    }
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(goodImage.viewX, goodImage.viewBottomEdge + 15, SCREEN_WIDTH - goodImage.viewX, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self addSubview:line];
    
    UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(goodImage.viewX, line.viewBottomEdge + 10, SCREEN_WIDTH - goodImage.viewX * 2, 109 - 15 - 10)];
    textView.textColor = [UIColor colorWithHex:0x181818];
    textView.delegate = self;
    textView.font = fontForSize(12);
   [self addSubview:textView];
    self.textView = textView;
    UILabel * placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH, 20)];
    placeHolderLabel.text = @"好评，商品质量优秀，快递速度快";
    placeHolderLabel.textColor = [UIColor colorWithHex:0xc8c8ce];
    placeHolderLabel.font = fontForSize(12);
    [textView addSubview:placeHolderLabel];
    self.placeHolder = placeHolderLabel;
    
    
    UIView * speaceView = [[UIView alloc]initWithFrame:CGRectMake(0, textView.viewBottomEdge + 15, SCREEN_WIDTH, 10)];
    speaceView.backgroundColor = [UIColor colorWithHex:0xf1f1ed];
    [self addSubview:speaceView];
    //NSLog(@"%@",speaceView);
    
}
-(void)starBtnAction:(UIButton *)sender
{
    NSInteger index = sender.tag - 100;
    NSInteger count = index + 1;
    
    for (int i = 0; i < count; i ++ ) {
        UIButton * btn = (UIButton *)_starArr[i];
        btn.selected = YES;
    }
    NSInteger others = _starArr.count - count;
    if (others > 0) {
        for (NSInteger i = count ; i < _starArr.count; i ++) {
            
            UIButton * btn = (UIButton *)_starArr[i];
            btn.selected = NO;
        }
    }
    if ([self.delegate respondsToSelector:@selector(OrderEvaluteCellDidClickStarBtn:index:)]) {
        [self.delegate OrderEvaluteCellDidClickStarBtn:sender index:self.index];
    }
}
#pragma mark -- UITextViewDelegate --
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.placeHolder.hidden = YES;
    }
    else{
        self.placeHolder.hidden = NO;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(OrderEvaluteCellDidBegainEditingTextView:textView:)]) {
        
        [self.delegate OrderEvaluteCellDidBegainEditingTextView:self textView:textView];
    }
   
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    
    if ([self.delegate respondsToSelector:@selector(OrderEvaluteCellDidEndEditingTextView:textView:index:)]) {
        
        [self.delegate OrderEvaluteCellDidEndEditingTextView:self textView:textView index:self.index];
    }
}
#pragma mark -- set --
-(void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    [_goodImage sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:nil];
    
}
- (void)setInfoText:(NSString *)infoText
{
    _infoText = infoText;
    _infoLabel.text = _infoText;
    [_infoLabel sizeToFit];
    _infoLabel.frame = CGRectMake(_infoLabel.viewX, _infoLabel.viewY, _infoLabel.bounds.size.width, _infoLabel.bounds.size.height);
}
-(void)setEvaluteString:(NSString *)evaluteString
{
    _evaluteString = evaluteString;
    _textView.text = _evaluteString;
    if (_evaluteString.length == 0) {
        _textView.text = nil;
        _placeHolder.hidden = NO;
    }
    else{
        _placeHolder.hidden = YES;
    }
}
- (void)setStarCount:(NSInteger)starCount
{
    if (starCount != 0) {
        for (int i = 0; i < starCount; i ++ ) {
            UIButton * btn = (UIButton *)_starArr[i];
            btn.selected = YES;
        }
        
        NSInteger others = _starArr.count - starCount;
        if (others > 0) {
            for (NSInteger i = starCount; i < _starArr.count; i ++) {
                UIButton * btn = _starArr[i];
                btn.selected = NO;
            }
        }
        
    }
    else{
        for (UIButton * btn in _starArr) {
            btn.selected = NO;
        }
    }
   
}
@end
