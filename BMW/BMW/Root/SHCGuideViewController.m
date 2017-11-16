//
//  JCGuideViewController.m
//  AutoGang
//
//  Created by luoxu on 14/12/12.
//  Copyright (c) 2014年 com.qcb008.QiCheApp. All rights reserved.
//

#import "SHCGuideViewController.h"

@interface SHCGuideViewController ()<UIScrollViewDelegate> {
    NSMutableArray * _dataSourceArray;
    NSMutableArray * _UserDefultsArray;
}

@property (nonatomic, strong)UIScrollView * scrollView;

@end

@implementation SHCGuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataSourceArray = [NSMutableArray array];
    _UserDefultsArray = [NSMutableArray array];
    NSArray *imageArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"ImageArrayCache"];
    if (imageArray.count>0) {
        [_UserDefultsArray addObjectsFromArray:imageArray];
    }
    [self Request];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
}

- (void)Request {
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GuidList" parameters:@{@"type":@"1"} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            _dataSourceArray = [NSMutableArray arrayWithArray:object[@"data"]];
            for (int i = 0; i < _dataSourceArray.count; i ++) {
                UIImageView *loadImage = [[UIImageView alloc] init];
                [loadImage sd_setImageWithURL:[NSURL URLWithString:_dataSourceArray[i]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [_UserDefultsArray addObject:image];
                    if (_UserDefultsArray.count==_dataSourceArray.count) {
                        [[NSUserDefaults standardUserDefaults]setObject:_dataSourceArray forKey:@"ImageArrayCache"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        NSArray *imageArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"ImageArrayCache"];
                        NSLog(@"%@",imageArray);
                    }
                }];
                [self.view addSubview:loadImage];
            }
            [self loadViews];
        }else {
            [self loadViews];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadViews
{
    UIView * bootomView = [UIView new];
    bootomView.viewSize = CGSizeMake(10*5*W_ABCW+40, 10);
    bootomView.backgroundColor = [UIColor clearColor];
    [bootomView align:ViewAlignmentBottomCenter relativeToPoint:CGPointMake(SCREEN_WIDTH/2, self.scrollView.viewBottomEdge-29)];
    [self.view addSubview:bootomView];
    
    if (_VersionUpdate) {
        for (int i = 0; i < _UserDefultsArray.count; i ++)
        {
            UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, self.view.viewWidth, self.view.viewHeight)];
            [iv sd_setImageWithURL:[NSURL URLWithString:_UserDefultsArray[i]]];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10+i*20, 0, 10, 10)];
            button.tag = 100+i;
            if (i==0) {
                button.selected = YES;
            }
            [button setImage:IMAGEWITHNAME(@"icon_qipao_nor_hyy.png") forState:UIControlStateNormal];
            [button setImage:IMAGEWITHNAME(@"icon_qipao_cli_hyy.png") forState:UIControlStateSelected];
            [bootomView addSubview:button];
            
            [self.scrollView addSubview:iv];
            if (i == _UserDefultsArray.count-1)
            {
//                UIImageView * alertImageView = [UIImageView new];
//                alertImageView.viewSize = CGSizeMake(137.5, 50.5);
//                [alertImageView align:ViewAlignmentBottomCenter relativeToPoint:CGPointMake((SCREEN_WIDTH / 2) + i * SCREEN_WIDTH, SCREEN_HEIGHT - 87*W_ABCH)];
//                alertImageView.image = [UIImage imageNamed:@"icon_lijitiyan_hyy"];
//                [self.scrollView addSubview:alertImageView];
                
                UILabel *gotoTiyan = [UILabel new];
                gotoTiyan.viewSize = CGSizeMake(135, 36);
                [gotoTiyan align:ViewAlignmentBottomCenter relativeToPoint:CGPointMake((SCREEN_WIDTH / 2) + i * SCREEN_WIDTH, SCREEN_HEIGHT - 87*W_ABCH)];
                gotoTiyan.text = @"立即体验";
                gotoTiyan.textAlignment = NSTextAlignmentCenter;
                gotoTiyan.font = fontForSize(17);
                gotoTiyan.textColor = [UIColor whiteColor];
                gotoTiyan.layer.borderWidth = 1;
                gotoTiyan.layer.cornerRadius = 18;
                gotoTiyan.layer.borderColor = [UIColor whiteColor].CGColor;
                gotoTiyan.layer.masksToBounds = YES;
                [self.scrollView addSubview:gotoTiyan];
                
                
                [iv setUserInteractionEnabled:YES];
                [iv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissMe)]];
            }
        }

        self.scrollView.contentSize = CGSizeMake(self.scrollView.viewWidth * _UserDefultsArray.count, self.scrollView.viewHeight);
    }else{
        for (int i = 0; i < 4 ; i ++)
        {
            UIImage *image = [self imageForPage:i];
            UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, self.view.viewWidth, self.view.viewHeight)];
            iv.image = image;
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((10*W_ABCW+10)*i+10*W_ABCW, 0, 10, 10)];
            button.tag = 100+i;
            if (i==0) {
                button.selected = YES;
            }
            [button setImage:IMAGEWITHNAME(@"icon_qipao_nor_hyy.png") forState:UIControlStateNormal];
            [button setImage:IMAGEWITHNAME(@"icon_qipao_cli_hyy.png") forState:UIControlStateSelected];
            [bootomView addSubview:button];
            
            [self.scrollView addSubview:iv];
            if (i == 3)
            {
                UILabel *gotoTiyan = [UILabel new];
                gotoTiyan.viewSize = CGSizeMake(135, 36);
                [gotoTiyan align:ViewAlignmentBottomCenter relativeToPoint:CGPointMake((SCREEN_WIDTH / 2) + i * SCREEN_WIDTH, SCREEN_HEIGHT - 87* W_ABCW)];
                if (IPHONE4S_SCREEN_HEIGHT == SCREEN_HEIGHT) {
                    [gotoTiyan align:ViewAlignmentBottomCenter relativeToPoint:CGPointMake((SCREEN_WIDTH / 2) + i * SCREEN_WIDTH, SCREEN_HEIGHT - 57* W_ABCW)];
                }
                gotoTiyan.text = @"立即体验";
                gotoTiyan.textAlignment = NSTextAlignmentCenter;
                gotoTiyan.font = fontForSize(17);
                gotoTiyan.textColor = [UIColor whiteColor];
                gotoTiyan.layer.borderWidth = 1;
                gotoTiyan.layer.cornerRadius = 18;
                gotoTiyan.layer.borderColor = [UIColor whiteColor].CGColor;
                gotoTiyan.layer.masksToBounds = YES;
                [self.scrollView addSubview:gotoTiyan];
                
                [iv setUserInteractionEnabled:YES];
                [iv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissMe)]];
            }
        }
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 4, self.scrollView.viewHeight);
    }
    
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
    if (_VersionUpdate) {
        for (int i = 100; i<100+_UserDefultsArray.count; i++) {
            UIButton *button = [self.view viewWithTag:i];
            button.selected = NO;
        }
        UIButton *seletecdB = [self.view viewWithTag:100+index];
        seletecdB.selected = YES;
    }else{
        for (int i = 100; i<104; i++) {
            UIButton *button = [self.view viewWithTag:i];
            button.selected = NO;
        }
        UIButton *seletecdB = [self.view viewWithTag:100+index];
        seletecdB.selected = YES;
    }
    
}


- (void)dismissMe
{
    [[NSUserDefaults standardUserDefaults]setObject:@"1.0" forKey:@"hello1.0"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)imageForPage:(NSUInteger)page
{
    NSString * fileName = [NSString stringWithFormat:@"_%lu",(unsigned long)page];
    CGSize size = [UIScreen mainScreen].bounds.size;
    NSInteger type = 2;
    if (size.height == 480) {
        type = 0;
    } else {
        if (size.width == 320) {
            type = 1;
        } else if(size.width == 375) {
            type = 2;
        } else if(size.width == 540) {
            type = 3;
        }
    }
    switch (type)
    {
        case 0:
            fileName = [@"3_5_guide" stringByAppendingString:fileName];
            break;
        case 1:
            fileName = [@"4_7_guide" stringByAppendingString:fileName];
            break;
        case 2:
            fileName = [@"4_guide" stringByAppendingString:fileName];
            break;
        case 3:
            fileName = [@"5_5_guide" stringByAppendingString:fileName];
            break;
    }
    return [UIImage imageNamed:[fileName stringByAppendingString:@".png"]];
}
@end
