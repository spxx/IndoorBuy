//
//  OpenShopViewController.m
//  BMW
//
//  Created by rr on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OpenShopViewController.h"
#import "OpenShopView.h"
#import "JoinBangMaiViewController.h"

@interface OpenShopViewController ()<OpenShopDelegate>
{
    OpenShopView *_openShopV;
}

@end

@implementation OpenShopViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigation];
    [self initData];
    [self initUserInterface];
}

-(void)initData{
    [OpenShopModel requestImageandPrice:^(BOOL success, OpenShopModel * model, NSString *message) {
        if (success) {
            _openShopV.model = model;
        }else{
            _openShopV.openBtn.userInteractionEnabled = NO;
        }
    }];
}

-(void)initUserInterface{
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    _openShopV = [[OpenShopView alloc] initWithFrame:self.view.frame];
    _openShopV.delegate = self;
    [self.view addSubview:_openShopV];
}

-(void)NewShop:(OpenShopModel *)openModel{
    if (!openModel.recommend) {
        ChooseShopVC *chooseVC = [[ChooseShopVC alloc] init];
        chooseVC.choosePorS = ChoosePreson;
        chooseVC.title = @"成为麦咖";
        chooseVC.price = openModel.price;
        [self.navigationController pushViewController:chooseVC animated:YES];
    }else{
        _openShopV.openBtn.userInteractionEnabled = NO;
        [BaseRequset sendPOSTRequestWithBMWApi2Method:@"OpenStoreCheck" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID,@"phone":openModel.phone} callBack:^(RequestResult result, id object) {
            _openShopV.openBtn.userInteractionEnabled = YES;
            if (result == RequestResultSuccess) {
                JoinBangMaiViewController *joinVC = [[JoinBangMaiViewController alloc] init];
                joinVC.title = @"成为麦咖";
                joinVC.pay_sn = object[@"data"][@"paySn"];
                joinVC.price = openModel.price;
                [self.navigationController pushViewController:joinVC animated:YES];                
            }else if (result == RequestResultFailed){
                SHOW_EEROR_MSG(object);
            }
        }];
    }
}

@end


