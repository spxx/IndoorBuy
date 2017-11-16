//
//  InviRecordViewController.m
//  BMW
//
//  Created by rr on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "InviRecordViewController.h"
#import "InviRecodeModel.h"
#import "InviRCView.h"

@interface InviRecordViewController ()<InviRCViewDelegate>
{
    InviRCView *_inviRecodV;
    NSMutableArray *_dataArray;
}
@end

@implementation InviRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"邀请记录";
    self.view.backgroundColor = COLOR_BACKGRONDCOLOR;
    _dataArray = [NSMutableArray array];
    [self navigation];
    [self initData];
    [self initUserInterfcae];
}

-(void)initData{
    [self.HUD show:YES];
    [InviRecodeModel requestRecordWithnum:(_dataArray.count+1) finish:^(NSInteger code, NSMutableArray * data, NSString * message) {
        [self.HUD hide:YES];
        if (code == 100) {
            [_dataArray addObjectsFromArray:data];
            _inviRecodV.dataArray = _dataArray;
        }else if(code == 902){
            _inviRecodV.recordView.hidden = YES;
            _inviRecodV.noRecordView.hidden = NO;
        }else{
            _inviRecodV.recordView.hidden = YES;
            _inviRecodV.noRecordView.hidden = NO;
            SHOW_MSG(message);
        }
    }];
    
}

-(void)initUserInterfcae{
    _inviRecodV = [[InviRCView alloc] initWithFrame:self.view.frame];
    _inviRecodV.delegate = self;
    [self.view addSubview:_inviRecodV];
}

-(void)viewReFresh{
    [_dataArray removeAllObjects];
    [self initData];
}

-(void)viewLoadMore{
    [self initData];
}


@end

