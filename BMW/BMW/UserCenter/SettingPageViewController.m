//
//  SettingPageViewController.m
//  BMW
//
//  Created by rr on 16/3/23.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "SettingPageViewController.h"
#import "AboutUsViewController.h"
#import "ShareView.h"
#import "UITabBar+BadgeColor.h"

@interface SettingPageViewController ()<UIAlertViewDelegate,ShareVeiwDelegate>
{
    NSArray *_titleArray;
    UILabel *_numLabel;
}
@property(nonatomic,strong)UIView * shareBackView;
@property(nonatomic,strong)UIView * shareView;
@end

@implementation SettingPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    
    [self navigation];
    [self initData];
    [self initUserInterFace];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark -- 界面

-(void)initData{
//    ,@"分享给好友"
    _titleArray = @[@"关于我们",@"清除缓存"];
}

-(void)initUserInterFace{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 10*W_ABCH, SCREEN_WIDTH, 45*_titleArray.count*W_ABCH +10*W_ABCH)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    
    for (int i = 0; i<_titleArray.count; i++) {
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(15*W_ABCW, 45.5*W_ABCH*i, SCREEN_WIDTH-40*W_ABCW, 45*W_ABCH)];
        titleL.text = _titleArray[i];
        titleL.font = fontForSize(13);
        titleL.textColor = [UIColor colorWithHex:0x7f7f7f];
        [topView addSubview:titleL];
        
        if (i==1) {
            [titleL align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15*W_ABCW, 45.5*W_ABCH*i+10*W_ABCH)];
        }
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, titleL.viewBottomEdge+0.5*W_ABCH, SCREEN_WIDTH, 0.5*W_ABCH)];
        line.backgroundColor = COLOR_BACKGRONDCOLOR;
        if (i==0) {
            line.viewSize = CGSizeMake(SCREEN_WIDTH, 10*W_ABCH);
        }
        [topView addSubview:line];
        
        UIImageView *rightRow = [UIImageView new];
        rightRow.viewSize = CGSizeMake(6, 10);
        rightRow.image = IMAGEWITHNAME(@"icon_xiaojiantou_sy.png");
        [rightRow align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15*W_ABCW, 45*W_ABCH/2+45*W_ABCH*i)];
        [topView addSubview:rightRow];
        if (i==1) {
            [rightRow align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15*W_ABCW,45*W_ABCH/2+45*W_ABCH*i+10*W_ABCH)];
            CGFloat cache = [[SDImageCache sharedImageCache] getSize];
            _numLabel = [UILabel new];
            _numLabel.viewSize = CGSizeMake(100, 45*W_ABCH);
            [_numLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(rightRow.viewX-8*W_ABCW, titleL.viewY)];
            _numLabel.textColor = [UIColor colorWithHex:0x181818];
            _numLabel.textAlignment = NSTextAlignmentRight;
            _numLabel.font = fontForSize(13);
            _numLabel.text = [NSString stringWithFormat:@"%.2fM",cache/1024/1024];
            [topView addSubview:_numLabel];
        }
        UIButton *tapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, titleL.viewY, SCREEN_WIDTH, 45*W_ABCH)];
        tapButton.tag = i;
        [tapButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:tapButton];
    }
    
    
    UIButton *submitOrderButton = [UIButton new];
    submitOrderButton.viewSize = CGSizeMake(SCREEN_WIDTH-30*W_ABCW, 49*W_ABCH);
    [submitOrderButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15*W_ABCW, topView.viewBottomEdge+20*W_ABCH)];
    submitOrderButton.titleLabel.font = fontForSize(16);
    [submitOrderButton setTitle:@"注销登录" forState:UIControlStateNormal];
    [submitOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if ([JCUserContext sharedManager].isUserLogedIn) {
        submitOrderButton.backgroundColor = [UIColor colorWithHex:0xfd5487];
        submitOrderButton.userInteractionEnabled = YES;
    }else{
        submitOrderButton.backgroundColor = [UIColor colorWithHex:0xcccccc];
        submitOrderButton.userInteractionEnabled = NO;
    }
    [submitOrderButton addTarget:self action:@selector(logoutButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitOrderButton];
}

-(void)tapButton:(UIButton *)sender{
    switch (sender.tag) {
        case 0:{
            AboutUsViewController * aboutVC = [[AboutUsViewController alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;
        case 2: {
            ShareView * shareView = [[ShareView alloc] initWithTitle:@"该商品" QRCode:NO];
            shareView.delegate = self;
            [self.view.window addSubview:shareView];

        }
            break;
        case 1:{
            UIAlertView * alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"清除缓存图片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alterView.tag = 111;
            [alterView show];
        }
            break;
        default:
            break;
    }
}

-(void)logoutButton{
    UIAlertView * alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退出登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alterView.tag = 110;
    [alterView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==110) {
        if (buttonIndex==0) {
            [self loginOutNetWork];
            [[JCUserContext sharedManager] removeCurrentUser];
            [[JCUserContext sharedManager] clearSavedUserInfo];
            if ([JCUserContext sharedManager].isUserLogedIn) {
                NSLog(@"...");
            }
            RootTabBarVC *tabber= ROOTVIEWCONTROLLER;
            UINavigationController *shoppNAVC = tabber.viewControllers[2];
            [shoppNAVC.tabBarController.tabBar hideBadgeOnItemIndex];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        if (buttonIndex==0) {
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDisk]; //清除缓存更新页面
            _numLabel.text = @"0.00M";
        }

    }
}

#pragma mark -- ShareViewDelegate --
- (void)shareView:(ShareView *)shareView chooseItemWithDestination:(Share3RDParty)destination
{
    switch (destination) {
        case ShareWXSession:
            NSLog(@"微信好友");
            [ShareTools respondsShareWeiXin:@0 image:[UIImage imageNamed:@"logo_bangmaiwang_gywm"]
                                      title:BMW_TITLE
                                description:BMW_DESC
                                 webpageUrl:BMW_APPSTORE];
            break;
        case ShareWXFriend:
            NSLog(@"微信朋友圈");
            [ShareTools respondsShareWeiXin:@1 image:[UIImage imageNamed:@"logo_bangmaiwang_gywm"]
                                      title:BMW_TITLE
                                description:BMW_DESC
                                 webpageUrl:BMW_APPSTORE];
            break;
        case ShareSina:
            NSLog(@"新浪");
//                https://itunesconnect.apple.com/WebObjects/iTunesConnect.woa/ra/ng/app/1065728592
        {
            NSString * title = [[BMW_TITLE stringByAppendingFormat:@"。%@", BMW_DESC] stringByAppendingString:BMW_APPSTORE];
            [ShareTools respondsShareWeiboWithRedirectUrl:@"https://www.indoorbuy.com"
                                                    scope:@"all"
                                                     text:title
                                                 objectID:@""
                                               shareImage:[UIImage imageNamed:@"logo_bangmaiwang_gywm"]];
        }
            break;
        case ShareQQ:
            NSLog(@"QQ");
            [ShareTools respondsShareQQWithShareTitle:BMW_TITLE
                                             shareUrl:BMW_APPSTORE
                                     shareDescription:BMW_DESC
                                           shareImage:[UIImage imageNamed:@"logo_bangmaiwang_gywm"]];
            break;
        case ShareQQZone:
            NSLog(@"QQ空间");
            [ShareTools respondsShareQQZoneWithShareTitle:BMW_TITLE
                                                 shareUrl:BMW_APPSTORE
                                         shareDescription:BMW_DESC
                                               shareImage:[UIImage imageNamed:@"logo_bangmaiwang_gywm"]];
            break;
        case ShareCreatCode:
            NSLog(@"生成二维码");
            
            break;
        default:
            break;
    }
}

#pragma maek -- LoginOut --
-(void)loginOutNetWork
{
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"Logout" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
        NSLog(@"%@",object);
        if (result == RequestResultSuccess) {
            NSLog(@"注销成功");
        }
        else{
            NSLog(@"注销失败");
            
        }
        
    }];
}

@end
