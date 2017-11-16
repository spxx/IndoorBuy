//
//  NotFoundView.m
//  BMW
//
//  Created by gukai on 16/3/16.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "NotFoundView.h"

@interface NotFoundView ()
@property(nonatomic,copy)NSString * title;
@end
@implementation NotFoundView

-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(64*W_ABCW, 53*W_ABCH, 13, 13)];
        imageV.image = IMAGEWITHNAME(@"icon_tixing_ssjg.png");
        [self addSubview:imageV];
        self.imageV = imageV;
        
        
        _sorryLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageV.viewRightEdge+5*W_ABCW, imageV.viewY, SCREEN_WIDTH-150, 29)];
        _sorryLabel.textAlignment = NSTextAlignmentCenter;
        _sorryLabel.font = fontForSize(12);
        _sorryLabel.textColor = [UIColor colorWithHex:0x878787];
        _sorryLabel.numberOfLines = 2;
        [self addSubview:_sorryLabel];
        self.title = title;
        
    }
    return self;
}
-(void)setTitle:(NSString *)title
{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 5;
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle};
       NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"抱歉！没有找到%@相关商品，\n换个搜索词再试试吧！",title]];
    //[attString setAttributes:attributes range:NSMakeRange(0, [[NSString stringWithFormat:@"抱歉！没有找到%@相关商品，\n换个搜索词再试试吧！",title] length])];
    [attString setAttributes:attributes range:NSMakeRange(0, attString.string.length)];
    
    
    _sorryLabel.attributedText = attString;
    [_sorryLabel sizeToFit];
    _sorryLabel.viewSize = CGSizeMake(_sorryLabel.viewWidth, 29*W_ABCH);
    _sorryLabel.textAlignment = NSTextAlignmentCenter;
}
-(void)changeStringColorWithRange:(NSRange)range
{
    NSDictionary *diction = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHex:0xfd5487]};
   NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithAttributedString:_sorryLabel.attributedText];
     [att setAttributes:diction range:range];
    _sorryLabel.attributedText = att;
}
@end
