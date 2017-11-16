//
//  InvitationViewController.m
//  BMW
//
//  Created by rr on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "InvitationViewController.h"
#import "InviView.h"
#import "InvitationModel.h"
#import "InviRecordViewController.h"
#import "ShareView.h"
#import "CreateCodeVC.h"

@interface InvitationViewController ()<InviViewDelegate,ShareVeiwDelegate>
{
    InviView *_invitionV;
}
@end

@implementation InvitationViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"邀请有礼";

    //配置导航栏的左侧返回按钮
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"icon_fanhui_gdtj.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(15, 0, 10, 18);
    UIBarButtonItem * backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backBtnItem;
    //配置导航栏的右侧按钮
    UIButton * addAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addAddressButton setTitle:@"邀请记录" forState:UIControlStateNormal];
    addAddressButton.frame = CGRectMake(0, 0, 80, 80);
    addAddressButton.titleLabel.font = fontForSize(15);
    [addAddressButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
    UIBarButtonItem * addAddressBtnItem = [[UIBarButtonItem alloc] initWithCustomView:addAddressButton];
    [addAddressButton addTarget:self action:@selector(clickedRecordButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = addAddressBtnItem;
    
    [self initData];
    [self initUserInterFace];
    
}
-(void)leftItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initData{
    [InvitationModel requestImage:^(BOOL have, NSDictionary * dic, NSString * message) {
        if (have) {
            [_invitionV updateImageV:dic[@"img"]];
        }
    }];
}

-(void)initUserInterFace{
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    _invitionV = [[InviView alloc] initWithFrame:self.view.frame];
    _invitionV.delegate =  self;
    [self.view addSubview:_invitionV];
}

-(void)clickedRecordButton{
    InviRecordViewController *inviRecodVC = [[InviRecordViewController alloc] init];
    [self.navigationController pushViewController:inviRecodVC animated:YES];
}

-(void)InviTion{
    NSLog(@"邀请");
    ShareView * shareView = [[ShareView alloc] initWithTitle:@"" QRCode:YES];
    shareView.delegate = self;
    [self.view.window addSubview:shareView];

}

-(void)shareView:(ShareView *)shareView chooseItemWithDestination:(Share3RDParty)destination{
    UIImage * shareImage = IMAGEWITHNAME(@"classifyAll.jpg");
    NSString * shareUrl = INVI_MEMBER([JCUserContext sharedManager].currentUserInfo.memberID);
    NSString * goodsName = @"新人专享礼包";
    switch (destination) {
        case ShareWXSession:            
            NSLog(@"微信好友");
            [ShareTools respondsShareWeiXin:@0
                                      image:shareImage
                                      title:goodsName
                                description:SHARE_DESCRIPTION
                                 webpageUrl:shareUrl];
            break;
        case ShareWXFriend:
            NSLog(@"微信朋友圈");
            [ShareTools respondsShareWeiXin:@1
                                      image:shareImage
                                      title:SHARE_DESCRIPTION
                                description:goodsName
                                 webpageUrl:shareUrl];
            break;
            
        case ShareSina:
            NSLog(@"新浪");
            [ShareTools respondsShareWeiboWithRedirectUrl:@"https://www.indoorbuy.com"
                                                    scope:@"all"
                                                     text:[NSString stringWithFormat:@"%@。%@。%@",SHARE_DESCRIPTION, goodsName, shareUrl]
                                                 objectID:@""
                                               shareImage:shareImage];
            break;
        case ShareQQ:
            NSLog(@"QQ");
            [ShareTools respondsShareQQWithShareTitle:SHARE_DESCRIPTION
                                             shareUrl:shareUrl
                                     shareDescription:goodsName
                                           shareImage:shareImage];
            break;
        case ShareQQZone:
            NSLog(@"QQ空间");
            [ShareTools respondsShareQQZoneWithShareTitle:SHARE_DESCRIPTION
                                                 shareUrl:shareUrl
                                         shareDescription:goodsName
                                               shareImage:shareImage];
            break;
        case ShareCreatCode:{
            NSLog(@"生成二维码");
            CreateCodeVC * codeVC = [[CreateCodeVC alloc] init];
            codeVC.titleStr = @"新人扫码获取新人礼包";
            codeVC.shareUrl = shareUrl;
            [self.navigationController pushViewController:codeVC animated:YES];
        }
            break;
        default:
            break;
    }
}





@end

