//
//  GoinShopViewController.m
//  BMW
//
//  Created by rr on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "GoinShopViewController.h"
#import "GoinV.h"
#import "ChooseShopVC.h"
#import "OpenShopViewController.h"

@interface GoinShopViewController ()<GoinVdelegate>
{
    GoinV *_goinView;
}

@end

@implementation GoinShopViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUserinterface];
}

-(void)initUserinterface{
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    _goinView = [[GoinV alloc] initWithFrame:self.view.frame];
    _goinView.delegate = self;
    [self.view addSubview:_goinView];
}

-(void)gotoShop{
    //我要购物
    ChooseShopVC *chooseVC = [[ChooseShopVC alloc] init];
    chooseVC.choosePorS = ChooseShopping;
    chooseVC.title = @"我要购物";
    [self.navigationController pushViewController:chooseVC animated:YES];
    
}

-(void)wantToShop{
    //我要开店 改为 成为麦咖
    OpenShopViewController *openVc = [[OpenShopViewController alloc] init];
    openVc.chooseP = ChooseShopping;
    openVc.title = @"成为麦咖";
    [self.navigationController pushViewController:openVc animated:YES];
//    ChooseShopVC *chooseVC = [[ChooseShopVC alloc] init];
//    chooseVC.choosePorS = ChooseShopping;
//    chooseVC.title = @"成为麦咖";
//    [self.navigationController pushViewController:chooseVC animated:YES];
}


@end
