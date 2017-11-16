//
//  ScreenCell.m
//  BMW
//
//  Created by gukai on 16/3/2.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ScreenCell.h"

@interface ScreenCell ()
/**
 * 价格栏
 */
@property(nonatomic,strong)UIView * priceRangeView;
/**
 * 产地栏
 */
@property(nonatomic,strong)UIView * productPlaceView;
/**
 * 品牌栏
 */
@property(nonatomic,strong)UIView * brandView;
/**
 * 类别栏
 */
@property(nonatomic,strong)UIView * classifyView;
/**
 * 记录当前展开的是哪个栏
 */
@property(nonatomic,strong)UIView * currentView;
@end
@implementation ScreenCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
    }
    return self;
}
-(void)initUserInterfaceScreenCell
{
    
}
-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
}
-(void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    [self.currentView removeFromSuperview];
    self.currentView = nil;
     CGFloat height = 0;
    switch (self.index.row) {
        case 0: height = [self heightShowPriceRangeView:_dataSource];break;
        case 1: height =[self heightShowProductPlaceView:_dataSource];
            break;
        case 2: height =[self heightShowBrandView:_dataSource];break;
        case 3: height =[self heightShowClassifyView:_dataSource];break;
            
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(screenCell:indexPath:cellHeight:)]) {
        [self.delegate screenCell:self indexPath:self.index cellHeight:height];
    }
}
-(void)setIndex:(NSIndexPath *)index
{
    _index = index;
}
/**
 * 选择价格的界面
 */
-(CGFloat)heightShowPriceRangeView:(NSArray*)dataSource
{
    self.priceRangeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 100)];
   CGFloat height = [self initButtonOnView:self.priceRangeView dataSource:dataSource];
    self.priceRangeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height );
    [self.contentView addSubview:self.priceRangeView];
    _currentView = self.priceRangeView;
    return self.priceRangeView.viewBottomEdge;
    
}
/**
 * 选择产地的界面
 */
-(CGFloat)heightShowProductPlaceView:(NSArray*)dataSource
{
    self.productPlaceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 100)];
    CGFloat height = [self initButtonOnView:self.productPlaceView dataSource:dataSource];
    self.productPlaceView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    [self.contentView addSubview:self.productPlaceView];
    _currentView = self.productPlaceView;
    return self.productPlaceView.viewBottomEdge;
}
/**
 * 选择品牌界面
 */
-(CGFloat)heightShowBrandView:(NSArray*)dataSource
{
    self.brandView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 100)];
    CGFloat height = [self initButtonOnView:self.brandView dataSource:dataSource];
    self.brandView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    [self.contentView addSubview:self.brandView];
    _currentView = self.brandView;
    return self.brandView.viewBottomEdge;
}
/**
 * 选择类别的界面
 */
-(CGFloat)heightShowClassifyView:(NSArray*)dataSource
{
    self.classifyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 100)];
    CGFloat height = [self initButtonOnView:self.classifyView dataSource:dataSource];
    self.classifyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    [self.contentView addSubview:self.classifyView];
    _currentView = self.classifyView;
    return self.classifyView.viewBottomEdge;
}
#pragma mark -- 初始化 button --
-(CGFloat)initButtonOnView:(UIView *)view dataSource:(NSArray *)dataSource
{
    
    CGFloat btnWith = 81 * W_ABCW;
    CGFloat btnHeigt = 26;
    
    CGFloat btn_x = (SCREEN_WIDTH - 80 - 3 * btnWith) / 4;
    CGFloat btn_y = 9;
    
    NSInteger indexCount = dataSource.count;
    NSInteger count = dataSource.count / 3;
    NSInteger lines = 0;
    
    if (count > 0) {
        if (dataSource.count % 3 > 0) {
            lines = count + 1;
        }
        else{
            lines = count;
        }
    }
    else{
        lines = 1;
    }
    NSInteger breakCount = 0;
    UIButton * lastBtn = nil;
    for (int i = 0; i < lines; i ++) {
        for (int j = 0; j < 3; j++) {
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(btn_x + (btnWith + btn_x) * j, (btnHeigt + btn_y) * i, btnWith, btnHeigt)];
            [btn setTitle:_dataSource[breakCount] forState:UIControlStateNormal];
            btn.titleLabel.font = FONT_HEITI_SC(12);
            [btn setTitleColor:[UIColor colorWithHex:0x181818] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            btn.layer.cornerRadius = btn.viewHeight/2;
            btn.layer.masksToBounds = YES;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor colorWithHex:0xe1e1e1].CGColor;
            
            [view addSubview:btn];
           
            switch (self.index.row) {
                case 0:
                    [btn addTarget:self action:@selector(priceAction:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 1:
                    [btn addTarget:self action:@selector(placeAction:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 2:
                    [btn addTarget:self action:@selector(brandAction:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 3:
                    [btn addTarget:self action:@selector(classifyAction:) forControlEvents:UIControlEventTouchUpInside];
                    break;
                    
                default:
                    break;
            }
            lastBtn = btn;
            breakCount = breakCount + 1;
            if (breakCount == indexCount) {
                break;
            }
        }
    }
    return lastBtn.viewBottomEdge + 10;
}
#pragma mark -- Action --
/**
 * 价格栏的按钮点击事件
 */
-(void)priceAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
         sender.layer.borderColor = [UIColor colorWithHex:0xfd5478].CGColor;
    }
    else{
        sender.layer.borderColor = [UIColor colorWithHex:0xe1e1e1].CGColor;
    }
    
}

/**
 * 产地栏的按钮点击事件
 */
-(void)placeAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.layer.borderColor = [UIColor colorWithHex:0xfd5478].CGColor;
    }
    else{
        sender.layer.borderColor = [UIColor colorWithHex:0xe1e1e1].CGColor;
    }

}

/**
 * 品牌栏的按钮点击事件
 */
-(void)brandAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.layer.borderColor = [UIColor colorWithHex:0xfd5478].CGColor;
    }
    else{
        sender.layer.borderColor = [UIColor colorWithHex:0xe1e1e1].CGColor;
    }

}

/**
 * 类别栏的按钮点击事件
 */
-(void)classifyAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.layer.borderColor = [UIColor colorWithHex:0xfd5478].CGColor;
    }
    else{
        sender.layer.borderColor = [UIColor colorWithHex:0xe1e1e1].CGColor;
    }

}
@end
