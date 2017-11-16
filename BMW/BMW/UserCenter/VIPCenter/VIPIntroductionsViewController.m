//
//  VIPIntroductionsViewController.m
//  BMW
//
//  Created by 白琴 on 16/3/22.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "VIPIntroductionsViewController.h"
#import "VIPActivationViewController.h"
#import "WaitApplyViewController.h"
#import "JoinVIPViewController.h"

@interface VIPIntroductionsViewController ()

@end

@implementation VIPIntroductionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isProtocol) {
        self.title = @"申明条款";
    }
    else{
        self.title = @"麦咖会员";
    }
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
    
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    NSString * string;
    if (self.isProtocol) {
        backgroundView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        [backgroundView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
        string  = @"我自愿成为帮麦网付费会员，本人已准确、完整的了解帮麦网付费会员的权益和约定并确认愿意接受和遵守下述约定。\n\n1、会员的权利：\n\n A. 会员需向成都帮麦电子商务有限公司缴纳会员费200元/年（自申办及缴费成功之日起计时，时效一年），当年会员卡消费满2000元，可免次年会员年费；\nB. 会员可以会员价购买帮麦网线上线下的所有商品。线上包括帮麦网网站、手机站，微信公众号，手机APP；线下包括所有帮麦网跨境电商体验店，线下购物需先出示会员卡才能享受会员价。\n\n2、会员的义务\n\nA.因海关及国家相关政策需要，会员需提交真实无误的个人身份证号码以及地址、联系 方式等资料，由于提交虚假资料导致无法发货或无法收货的由本人承担由此带来的责任；\n\nB.付费会员年费一经缴纳，概不退还。\n\n3、解释权\n\nA.大促/特价商品不再双重享受会员折扣。\n\nB.帮麦网付费会员的所有解释权归成都帮麦电子商务有限公司所有。";
    }
    else {
        backgroundView.viewSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 * W_ABCW);
        [backgroundView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 1)];
        string  = @"快来加入“麦咖”，享受多重福利\n●麦咖独享优惠\n帮麦网线上、线下10000+种商品尊享超低麦咖价。\n\n●麦咖专场活动\n帮麦网线上、线下将不定期举办麦咖专场活动。\n\n●欧洲小镇之旅\n麦咖有机会参与帮麦网组织的欧洲小镇之旅，观看帮麦网在欧洲的产品生产过程，体验来自原产地的风情。\n\n●合作商家折扣\n麦咖可享受合作商家的优享折扣。第一波“中石油加油卡”即将来袭！\n\n●新品优先试用权\n麦咖可以优先试用、体验国际新品，品质生活快人一步。\n\n如何成为麦咖？\n麦咖年费：200元/年（全年消费满2000元免次年年费）\n";
    }
    UITextView * textView = [UITextView new];
    textView.viewSize = CGSizeMake(backgroundView.viewWidth - 30 * W_ABCW, backgroundView.viewHeight - 30 * W_ABCW);
    [textView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCW, 15 * W_ABCW)];
    textView.textColor = [UIColor colorWithHex:0x181818];
    textView.editable = NO;
    textView.showsVerticalScrollIndicator = NO;
    textView.showsHorizontalScrollIndicator = NO;
    [backgroundView addSubview:textView];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:13],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:string attributes:attributes];
    
    
    //会员说明才显示按钮
    if (!self.isProtocol) {
        UIButton * onlineServiceButton = [UIButton new];
        onlineServiceButton.viewSize = CGSizeMake(SCREEN_WIDTH / 2 - 0.5, 49 * W_ABCW);
        [onlineServiceButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, backgroundView.viewBottomEdge)];
        [onlineServiceButton setTitleColor:[UIColor colorWithHex:0x181818] forState:UIControlStateNormal];
        onlineServiceButton.titleLabel.font = fontForSize(16);
        [onlineServiceButton setTitle:@"激活麦咖特权" forState:UIControlStateNormal];
        [onlineServiceButton addTarget:self action:@selector(clickedOnlineServiceButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:onlineServiceButton];
        
        UIButton * addButton = [UIButton new];
        addButton.viewSize = CGSizeMake(SCREEN_WIDTH / 2 - 0.5, 49 * W_ABCW);
        [addButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH, backgroundView.viewBottomEdge)];
        [addButton setTitleColor:[UIColor colorWithHex:0xfd5487] forState:UIControlStateNormal];
        addButton.titleLabel.font = fontForSize(16);
        [addButton setTitle:@"申请成为麦咖" forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(clickedAddButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addButton];
        
        UIView * line = [UIView new];
        line.viewSize = CGSizeMake(0.5 * W_ABCW, 21 * W_ABCW);
        [line align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(onlineServiceButton.viewRightEdge, backgroundView.viewBottomEdge + (49 * W_ABCW - line.viewHeight) / 2)];
        line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [self.view addSubview:line];
    }
    
}

#pragma mark -- 点击
/**
 *  激活会员
 */
- (void)clickedOnlineServiceButton:(UIButton *)sender {
    NSLog(@"激活会员");
    VIPActivationViewController * vipVC = [[VIPActivationViewController alloc] init];
    [self.navigationController pushViewController:vipVC animated:YES];
}
/**
 *  加入会员
 */
- (void)clickedAddButton {
    NSLog(@"加入会员");
    if ([[JCUserContext sharedManager].currentUserInfo.status integerValue] == 20) {
        //申请中
        WaitApplyViewController *waitAVC = [[WaitApplyViewController alloc] init];
        [self.navigationController pushViewController:waitAVC animated:YES];
    }
    else {
        JoinVIPViewController * joinVIPVC = [[JoinVIPViewController alloc] init];
        [self.navigationController pushViewController:joinVIPVC animated:YES];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
