//
//  OilRecordViewController.m
//  BMW
//
//  Created by LiuP on 2016/12/17.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OilRecordViewController.h"
#import "OilRecordView.h"

@interface OilRecordViewController ()

@property (nonatomic, strong) OilRecordView * oilRecordView;

@end

@implementation OilRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUserInterface];
}

#pragma mark -- UI
- (void)initUserInterface
{
    self.title = @"油卡兑换";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    [self navigation];
    
    _oilRecordView = [[OilRecordView alloc] initWithFrame:CGRectMake(0, 0, self.view.viewWidth, self.view.viewHeight - 64)];
    [self.view addSubview:_oilRecordView];
    
    [self.HUD show:YES];
    [OilRecordModel requestForOilRecordListWithComplete:^(BOOL success, NSMutableArray *models, NSString *message) {
        [self.HUD hide:YES];
        if (success) {
            if (models) {
                _oilRecordView.models = models;
            }else {
                SHOW_MSG(message);
            }
        }else {
            SHOW_EEROR_MSG(message);
        }
    }];
}
@end
