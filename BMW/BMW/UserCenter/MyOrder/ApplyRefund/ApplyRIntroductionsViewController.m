//
//  ApplyRIntroductionsViewController.m
//  BMW
//
//  Created by 白琴 on 16/3/28.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ApplyRIntroductionsViewController.h"

@interface ApplyRIntroductionsViewController ()

@end

@implementation ApplyRIntroductionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    
    [self navigation];
    [self initUserInterface];
}
#pragma mark -- 界面
/**
 *  基本界面
 */
- (void)initUserInterface {
    UIView * backgroundView = [UIView new];
    backgroundView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 65);
    [backgroundView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    UITextView * textView = [UITextView new];
    textView.viewSize = CGSizeMake(backgroundView.viewWidth - 30 * W_ABCW, backgroundView.viewHeight - 15 * W_ABCW);
    [textView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, 15 * W_ABCW)];
    textView.textColor = [UIColor colorWithHex:0x181818];
                                   textView.showsHorizontalScrollIndicator = NO;
    textView.editable = NO;
    [backgroundView addSubview:textView];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:self.contentString attributes:attributes];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
