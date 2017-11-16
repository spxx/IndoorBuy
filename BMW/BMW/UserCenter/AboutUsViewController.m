//
//  AboutUsViewController.m
//  BMW
//
//  Created by 白琴 on 16/3/24.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController () {
    UIWebView * _webView;
    UIScrollView * _scrollView;
}
/**
 *  顶部
 */
@property (nonatomic, strong)UIView * headerView;
/**
 *  正文
 */
@property (nonatomic, strong)UIView * contentView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    
    [self navigation];
    [self initUserInterface];
}
#pragma mark -- 界面
- (void)initUserInterface {
    _scrollView = [UIScrollView new];
    _scrollView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 65);
    [_scrollView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
    _scrollView.backgroundColor = COLOR_BACKGRONDCOLOR;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    
    [_scrollView addSubview:self.headerView];
    [_scrollView addSubview:self.contentView];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _contentView.viewBottomEdge + 15 * W_ABCW);
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.viewSize = CGSizeMake(SCREEN_WIDTH, 100);
        [_headerView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        _headerView.backgroundColor = COLOR_BACKGRONDCOLOR;
        
        UIImageView * iconImageView = [UIImageView new];
        iconImageView.viewSize = CGSizeMake(60 * W_ABCW, 60 * W_ABCW);
        [iconImageView align:ViewAlignmentTopCenter relativeToPoint:CGPointMake(self.view.center.x, 26 * W_ABCW)];
        iconImageView.image = [UIImage imageNamed:@"logo_bangmaiwang_gywm"];
        [_headerView addSubview:iconImageView];
        
        UILabel * nameLable = [UILabel new];
        nameLable.viewSize = CGSizeMake(100, 30);
        nameLable.text = @"帮麦网";
        nameLable.font = fontForSize(13);
        nameLable.textColor = [UIColor colorWithHex:0x3d3d3d];
        [nameLable sizeToFit];
        [nameLable align:ViewAlignmentTopLeft relativeToPoint:CGPointMake((self.view.viewWidth - nameLable.viewWidth) / 2, iconImageView.viewBottomEdge + 11 * W_ABCW)];
        [_headerView addSubview:nameLable];
        
        UILabel * numLable = [UILabel new];
        numLable.viewSize = CGSizeMake(100, 30);
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        numLable.text = [NSString stringWithFormat:@"V%@版", appVersion];
        numLable.font = fontForSize(11);
        numLable.textColor = [UIColor colorWithHex:0xa0a0a0];
        [numLable sizeToFit];
        [numLable align:ViewAlignmentTopLeft relativeToPoint:CGPointMake((self.view.viewWidth - numLable.viewWidth) / 2, nameLable.viewBottomEdge + 7 * W_ABCW)];
        [_headerView addSubview:numLable];
        
        _headerView.viewSize = CGSizeMake(SCREEN_WIDTH, numLable.viewBottomEdge + 27 * W_ABCW);
    }
    return _headerView;
}


- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.viewSize = CGSizeMake(SCREEN_WIDTH, 100);
        [_contentView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, _headerView.viewBottomEdge)];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        NSString * string = @" 成都帮麦电子商务有限公司是一家专业从事跨境贸易的综合性电商平台公司，依托线上电商平台帮麦网（www.Indoorbuy.com ）和跨境电商体验店（地址：四川省成都市成华区猛追湾街168号锦绣天府塔一层）从事B2B2C的跨境商品贸易活动，让消费者在线上即可实现下单-->完税-->通关的环节，真正实现全程价格透明、物流时间缩短、消费者跨境购物体验优化。 帮麦网销售的商品均来自北美、欧洲及日、韩等国，上万种商品涵盖了进口奶粉、母婴用品、营养保健、个护彩妆、轻奢尚品、家电、进口汽车等。";
        
        UILabel * contentLabel = [UILabel new];
        contentLabel.viewSize = CGSizeMake(SCREEN_WIDTH - 30 * W_ABCW, 100);
        [contentLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, 15 * W_ABCW)];
        contentLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = 9 * W_ABCW;
        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle};
        contentLabel.attributedText =[[NSAttributedString alloc] initWithString:string attributes:attributes];
        contentLabel.numberOfLines = 0;
        [contentLabel sizeToFit];
        [_contentView addSubview:contentLabel];
        _contentView.viewSize = CGSizeMake(SCREEN_WIDTH, contentLabel.viewHeight + 30 * W_ABCW);
    }
    return _contentView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
