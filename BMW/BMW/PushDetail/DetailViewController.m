//
//  DetailViewController.m
//  BMW
//
//  Created by gukai on 16/2/1.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
    
}
-(void)initUserInterface
{
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 300, SCREEN_WIDTH - 60, 20)];
    nameLabel.text = self.name;
    nameLabel.font = FONT_HEITI_SC(15);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nameLabel];
    
    
    UILabel * ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.viewX, nameLabel.viewBottomEdge + 10 , nameLabel.viewWidth, nameLabel.viewHeight)];
    ageLabel.text = self.age;
    ageLabel.font = FONT_HEITI_SC(15);
    ageLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:ageLabel];
    
    
    UILabel * sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(ageLabel.viewX, ageLabel.viewBottomEdge + 10, ageLabel.viewWidth, ageLabel.viewHeight)];
    sexLabel.text = self.sex;
    sexLabel.font = FONT_HEITI_SC(15);
    sexLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:sexLabel];
}

@end
