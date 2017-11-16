//
//  ChooseShopVC.m
//  BMW
//
//  Created by rr on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ChooseShopVC.h"
#import "chooseShopModel.h"
#import "ChooseShopView.h"
#import "JoinBangMaiViewController.h"

@interface ChooseShopVC ()<ChooseShopViewDelegate>
{
    ChooseShopView *_chooseShopView;
}
@end

@implementation ChooseShopVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigation];
    [self initData];
    [self initUserInterface];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyhiden) name:UIKeyboardWillHideNotification object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ - %@", self, NSStringFromSelector(_cmd));
}

-(void)keyWillShow:(NSNotification *)noticition{
    NSDictionary* info = [noticition userInfo];
     CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _chooseShopView.frame = CGRectMake(0, -kbSize.height, SCREEN_WIDTH, SCREEN_HEIGHT);
}

-(void)keyhiden{
    _chooseShopView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

-(void)initData{
    [chooseShopModel requestImageandPrice:^(BOOL success, chooseShopModel *model, NSString *message) {
        if (success) {
            _chooseShopView.model = model;
        }else{
            SHOW_MSG(message);
        }
    }];
}

-(void)initUserInterface{
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    _chooseShopView = [[ChooseShopView alloc] initWithFrame:self.view.frame andWithChoose:_choosePorS];
    _chooseShopView.delegate = self;
    [self.view addSubview:_chooseShopView];
    
}

#pragma mark chooseShopVDelegate

-(void)gotoPay:(NSString *)phone{
    if (_choosePorS == ChoosePreson) {
        
        [chooseShopModel OpenStoreCheck:phone complete:^(BOOL success, NSDictionary *dic, NSString *message) {
            if (success) {
                JoinBangMaiViewController *joinBVC = [[JoinBangMaiViewController alloc] init];
                joinBVC.pay_sn = dic[@"paySn"];
                joinBVC.title = @"成为麦咖";//我要开店
                joinBVC.price = self.price;
                [self.navigationController pushViewController:joinBVC animated:YES];
            }else{
                SHOW_EEROR_MSG(message);
            }
        }];
    }else{
        [chooseShopModel BindingStoreWithPhone:phone andFinish:^(BOOL success, NSString * message) {
            if (success) {
                [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetUserInfo" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
                    if (result == RequestResultSuccess) {
                        Userentity *user = [[Userentity alloc] initWithJSONObject:object[@"data"]];
                        [[JCUserContext sharedManager] updateUserInfo:user];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }];
            }else{
                SHOW_EEROR_MSG(message);
            }
        }];

        
        
    }
}

-(void)bangmaitiyan{
    if (_choosePorS == ChoosePreson) {
        [chooseShopModel OpenStoreCheck:nil complete:^(BOOL success, NSDictionary *dic, NSString *message) {
            if (success) {
                JoinBangMaiViewController *joinBVC = [[JoinBangMaiViewController alloc] init];
                joinBVC.pay_sn = dic[@"paySn"];
                joinBVC.title = @"成为麦咖";//我要开店
                joinBVC.price = self.price;
                [self.navigationController pushViewController:joinBVC animated:YES];
            }else{
                SHOW_EEROR_MSG(message);
            }
        }];
    }else{
        [chooseShopModel BindingStoreWithPhone:nil andFinish:^(BOOL success, NSString * message) {
            if (success) {
                [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GetUserInfo" parameters:@{@"userId":[JCUserContext sharedManager].currentUserInfo.memberID} callBack:^(RequestResult result, id object) {
                    if (result == RequestResultSuccess) {
                        Userentity *user = [[Userentity alloc] initWithJSONObject:object[@"data"]];
                        [[JCUserContext sharedManager] updateUserInfo:user];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }];
            }else{
                SHOW_EEROR_MSG(message);
            }
        }];
    }
}



-(void)ending{
    [self.view endEditing:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}






@end

