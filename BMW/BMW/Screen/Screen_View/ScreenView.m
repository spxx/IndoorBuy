//
//  ScreenView.m
//  BMW
//
//  Created by gukai on 16/3/2.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ScreenView.h"
#import "ScreenCollectionCell.h"
#import "ScreenCollectionViewFlowLayout.h"
#import "ScreenSectionView.h"
@interface ScreenView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ScreenSectionDelegate,ScreenCollectionCellDelegate,UITextFieldDelegate>
/**
 * 传进来的要加载在的父视图
 */
@property(nonatomic,strong)UIView * showView;
/**
 * 黑色办透明背景
 */
@property(nonatomic,strong)UIView * backgroundView;
/**
 * 白色展现的view
 */
@property(nonatomic,strong)UIView * contentView;
/**
 * 头部标题的视图（导航栏大小）
 */
@property(nonatomic,strong)UIView * titleView;
/**
 * 标题
 */
@property(nonatomic,strong)UILabel * titleLabel;
/**
 * 记录每个 Section 的 Row 的个数
 */
//@property(nonatomic,copy)NSMutableArray * cellRowCountArr;
/**
 * 数据源
 */
//@property(nonatomic,copy)NSMutableArray * dataSource;
/**
 * 筛选的组标题
 */
@property(nonatomic,copy)NSArray * sectionTitles;
@property(nonatomic,strong)UICollectionView * collectionView;

@property(nonatomic,strong)UIView * priceRangeView;

@property(nonatomic,strong)UIButton * clearBtn;
@property(nonatomic,strong)UIButton * sureBtn;
@property(nonatomic,strong)UIView * bottomBtnView;


@property(nonatomic,strong)UITextField * beginTF;
@property(nonatomic,strong)UITextField * endTF;



@end
@implementation ScreenView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame goods_platform_only:(NSString *)goods_platform_only screenModle:(ScreenModle *)modle andScreenType:(ScreenViewType)type{
    self = [super initWithFrame:frame];
    if (self) {
        _screenViewType = type;
        _goods_platform_only = goods_platform_only;
        _screenModle = modle;
        [self initData];
        [self initUserInterfaceScreenView];
        [self originListNetWork];
        
        if (_screenViewType == ScreenViewDefault) {
            [self brandLitWork];
            [self classifyLisyNetWork];
        }
        else if (_screenViewType == ScreenViewNoBrand){
            [self classifyLisyNetWork];
        }
        else if (_screenViewType == ScreenViewNoThirdClass){
            [self brandLitWork];
        }
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame classId:(NSString *)classId screenModle:(ScreenModle *)modle andScreenType:(ScreenViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _screenViewType = type;
        _classId = classId;
        _screenModle = modle;
        [self initData];
        [self initUserInterfaceScreenView];
        [self originListNetWork];
     
        if (_screenViewType == ScreenViewDefault) {
            [self brandLitWork];
            [self classifyLisyNetWork];
        }
        else if (_screenViewType == ScreenViewNoBrand){
            [self classifyLisyNetWork];
        }
        else if (_screenViewType == ScreenViewNoThirdClass){
            [self brandLitWork];
        }
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame classId:(NSString *)classId screenModle:(ScreenModle *)modle
{
    self = [super initWithFrame:frame];
    if (self) {
        _classId = classId;
        _screenModle = modle;
        [self initData];
        [self initUserInterfaceScreenView];
        [self originListNetWork];
        [self brandLitWork];
        [self classifyLisyNetWork];
        /*
        dispatch_queue_t global_quque = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
       dispatch_group_t group = dispatch_group_create();
       dispatch_group_async(group, global_quque, ^{
            [self originListNetWork];
        });
        dispatch_group_async(group, global_quque, ^{
            [self brandLitWork];
        });
        dispatch_group_async(group, global_quque, ^{
            [self classifyLisyNetWork];
        });
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"完成");
        });
         */

    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initUserInterfaceScreenView];
    }
    return self;
}
/**
 *
 */
-(void)initData
{
     _sectionTitles = [NSArray arrayWithObjects:@"价格",@"产地",@"品牌",@"品类", nil];
}
/**
 * 初始化筛选的视图
 */
 -(void)initUserInterfaceScreenView
{
    [self initBackgroundView];
    [self initContentView];
    [self initTitleView];
    [self initSwipeGesture];
    [self initCollectionView];
    
    
}
/**
 * 初始化半透明黑色背景
 */
-(void)initBackgroundView
{
    UIView * backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:backgroundView];
    self.backgroundView = backgroundView;
    [self initTapGeseture];
}
/**
 * 初始化白色展现的视图
 */
-(void)initContentView
{
    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH - 40, SCREEN_HEIGHT)];
    contentView.backgroundColor = [UIColor colorWithHex:0xefefef];
    [self addSubview:contentView];
    self.contentView = contentView;
    [self.contentView addSubview:self.bottomBtnView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditingAction:)];
    [self.contentView addGestureRecognizer:tap];
}
/**
 * 初始化导航栏高度的标题视图
 */
-(void)initTitleView
{
    UIView * titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.viewWidth, 64)];
    titleView.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, titleView.viewHeight - 1, self.contentView.viewWidth, 1)];
    line.backgroundColor = [UIColor colorWithHex:0xd4d4d4];
    
    [titleView addSubview:line];
    [self.contentView addSubview:titleView];
    self.titleView = titleView;
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, titleView.viewWidth, 30)];
    titleLabel.font = FONT_HEITI_SC(17);
    titleLabel.textColor = COLOR_NAVIGATIONBAR_ITEM;
    titleLabel.text = @"筛选";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    self.titleLabel = titleLabel;
}
/**
 * 初始化加载在黑色背景的点击手势
 */
-(void)initTapGeseture
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenTapGestureAction:)];
    [self.backgroundView addGestureRecognizer:tap];
}
/**
 * 初始化加载在视图上的滑动手势
 */
-(void)initSwipeGesture
{
    UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(screenSwipeGestureAction:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipe];
}

-(void)initCollectionView
{
    UIView *viewPlace = [[UIView alloc] init];
    [self.contentView addSubview:viewPlace];
    
    ScreenCollectionViewFlowLayout *  flowLayout = [[ScreenCollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 9;
    flowLayout.minimumLineSpacing = 9;
    flowLayout.maximumInteritemSpacing = 9;
    flowLayout.itemSize = CGSizeMake((self.contentView.viewWidth - 4 * 9)/3,26);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 9, 0, 9);
    
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.titleView.viewBottomEdge , self.contentView.viewWidth, self.contentView.viewHeight - self.titleView.viewHeight - 49) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor colorWithHex:0xefefef];
    
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[ScreenCollectionCell class] forCellWithReuseIdentifier:@"ScreenCollectionCell"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
     [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView"];
    
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
    [self.contentView addSubview:self.bottomBtnView];

    
}
/**
 * 展现筛选视图
 */
-(void)showScreenViewOnSuperView:(UIView *)view
{
    self.showView = view;
    [self.showView addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.frame = CGRectMake(40, 0, SCREEN_WIDTH - 40, SCREEN_HEIGHT);
        self.backgroundView.backgroundColor = [UIColor blackColor];
        self.backgroundView.alpha = 0.5;
    } completion:^(BOOL finished) {
        
    }];

}
/**
 * 隐藏筛选视图
 */
-(void)hiddenScreenView
{
    [self endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.frame = CGRectMake(SCREEN_WIDTH, 0, 0, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark -- Action --
-(void)endEditingAction:(UIGestureRecognizer *)sender
{
    [self.beginTF endEditing:YES];
    [self.endTF endEditing:YES];
}
-(void)sureBtnAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(screenView:clickSureBtn:)]) {
        [self.delegate screenView:self clickSureBtn:sender];
    }
}
-(void)clearBtnAcion:(UIButton *)sender
{
    self.screenModle.priceRange = @"";
    [self.screenModle.priceRangeArr removeAllObjects];
    [self.screenModle.productPlaces removeAllObjects];
    [self.screenModle.productPlaceDic removeAllObjects];
    [self.screenModle.brands removeAllObjects];
    [self.screenModle.brandDic removeAllObjects];
    [self.screenModle.classifies removeAllObjects];
    [self.screenModle.classifyDic removeAllObjects];
    self.screenModle.spreadPrice = NO;
    self.screenModle.spreadPlace = NO;
    self.screenModle.spreadBrand = NO;
    self.screenModle.spreadClass = NO;
    self.screenModle.cellRowCountArr =nil;
    [self.collectionView reloadData];
}
/**
 * 点击手势的事件
 */
-(void)screenTapGestureAction:(UIGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(screenView:touchTapGesture:)]) {
        
        [self.delegate screenView:self touchTapGesture:sender];
    }
}
/**
 * 滑动手势的事件
 */
-(void)screenSwipeGestureAction:(UIGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(screenView:touchSwipeGesture:)]) {
        
        [self.delegate screenView:self touchSwipeGesture:sender];
     }
}


#pragma mark -- 让 tableView 的 section 不悬浮 --
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = 50;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}
#pragma mark -- set --
#pragma mark -- get --
-(UIView *)bottomBtnView
{
    if (!_bottomBtnView) {
        _bottomBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentView.viewHeight - 49, self.contentView.viewWidth, 49)];
        _bottomBtnView.backgroundColor = [UIColor colorWithHex:0xefefef];
        
        UIButton * clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(15 * W_ABCW, 13, 110, 25)];
        [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
        clearBtn.backgroundColor = [UIColor whiteColor];
        clearBtn.titleLabel.font = FONT_HEITI_SC(13);
        [clearBtn setTitleColor:[UIColor colorWithHex:0x5e5e5e] forState:UIControlStateNormal];
        clearBtn.layer.borderWidth = 1;
        clearBtn.layer.borderColor = [UIColor colorWithHex:0xdedede].CGColor;
        clearBtn.layer.cornerRadius = 2;
        clearBtn.layer.masksToBounds = YES;
        [clearBtn addTarget:self action:@selector(clearBtnAcion:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBtnView addSubview:clearBtn];
        
        
        UIButton * sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(_bottomBtnView.viewWidth - 15 * W_ABCW - 110, clearBtn.viewY, 110, 25)];
        [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        sureBtn.backgroundColor = [UIColor whiteColor];
        sureBtn.titleLabel.font = FONT_HEITI_SC(13);
         [sureBtn setTitleColor:[UIColor colorWithHex:0x5e5e5e] forState:UIControlStateNormal];
        sureBtn.layer.borderWidth = 1;
        sureBtn.layer.borderColor = [UIColor colorWithHex:0xdedede].CGColor;
        sureBtn.layer.cornerRadius = 2;
        sureBtn.layer.masksToBounds = YES;
        [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBtnView addSubview:sureBtn];
    }
    
    return _bottomBtnView;
}
//-(ScreenModle *)screenModle
//{
//    if (!_screenModle) {
//        _screenModle = [[ScreenModle alloc]init];
//    }
//    return _screenModle;
//}
-(UIView *)priceRangeView
{
    if (!_priceRangeView) {
        _priceRangeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.viewWidth, 50)];
        _priceRangeView.backgroundColor = [UIColor whiteColor];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 90, _priceRangeView.viewHeight)];
        label.text = @"价格区间(区间)";
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = FONT_HEITI_SC(13);
        //[label sizeToFit];
        [_priceRangeView addSubview:label];
        
        UITextField * beginPriceTF = [[UITextField alloc]initWithFrame:CGRectMake(label.viewRightEdge + 6, 12, 62 * W_ABCW, 26)];
        //beginPriceTF.backgroundColor = [UIColor redColor];
        beginPriceTF.textAlignment = NSTextAlignmentCenter;
        beginPriceTF.font = fontForSize(12);
        beginPriceTF.layer.borderColor = [UIColor colorWithHex:0xe1e1e1].CGColor;
        beginPriceTF.layer.borderWidth = 1;
        beginPriceTF.layer.cornerRadius = beginPriceTF.viewHeight / 2;
        beginPriceTF.layer.masksToBounds = YES;
        beginPriceTF.keyboardType = UIKeyboardTypeNumberPad;
        beginPriceTF.delegate = self;
        beginPriceTF.returnKeyType = UIReturnKeyNext;
        beginPriceTF.tag = 2000;
        [_priceRangeView addSubview:beginPriceTF];
        self.beginTF = beginPriceTF;
        
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(beginPriceTF.viewRightEdge + 8, beginPriceTF.viewY + beginPriceTF.viewHeight / 2 - 1, 10 , 1)];
        line.backgroundColor = [UIColor blackColor];
        [_priceRangeView addSubview:line];
        
        
        UITextField * endPriceTF = [[UITextField alloc]initWithFrame:CGRectMake(line.viewRightEdge + 8, beginPriceTF.viewY, beginPriceTF.viewWidth, beginPriceTF.viewHeight)];
        endPriceTF.textAlignment = NSTextAlignmentCenter;
        endPriceTF.font = fontForSize(12);
        endPriceTF.layer.borderWidth = 1;
        endPriceTF.layer.borderColor = [UIColor colorWithHex:0xe1e1e1].CGColor;
        endPriceTF.layer.cornerRadius = beginPriceTF.viewHeight / 2;
        endPriceTF.layer.masksToBounds = YES;
        endPriceTF.delegate = self;
        endPriceTF.keyboardType = UIKeyboardTypeNumberPad;
        endPriceTF.returnKeyType = UIReturnKeyDone;
        endPriceTF.tag = 2001;
        [_priceRangeView addSubview:endPriceTF];
        self.endTF = endPriceTF;
        
        UIView * lineBottom = [[UIView alloc]initWithFrame:CGRectMake(0, _priceRangeView.viewHeight - 1, self.contentView.viewWidth, 1)];
        lineBottom.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_priceRangeView addSubview:lineBottom];
    }
    return _priceRangeView;
}

#pragma mark -- UICollectionViewDataSource --
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _sectionTitles.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.screenModle.cellRowCountArr[section]integerValue];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"ScreenCollectionCell";
    ScreenCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.index = indexPath;
    NSDictionary * dataDic = self.screenModle.dataSource[indexPath.section][indexPath.row];
    cell.dataDic = dataDic ;
    switch (indexPath.section) {
        case 0:{
            NSString * str = dataDic[@"name"];
            if (str == self.screenModle.priceRange) {
                cell.button.selected = YES;
                cell.button.layer.borderColor = [UIColor colorWithHex:0xfd5487].CGColor;
            }
            else{
                cell.button.selected = NO;
                cell.button.layer.borderColor = [UIColor colorWithHex:0xe1e1e1].CGColor;
            }
        }
            break;
        case 1:{
            NSString * str = dataDic[@"name"];
            if ([self.screenModle.productPlaceDic.allKeys containsObject:str]) {
                cell.button.selected = YES;
                cell.button.layer.borderColor = [UIColor colorWithHex:0xfd5487].CGColor;
            }
            else{
                cell.button.selected = NO;
                cell.button.layer.borderColor = [UIColor colorWithHex:0xe1e1e1].CGColor;
            }
        }
            break;
        case 2:{
            NSString * str = dataDic[@"brand_name"];
            if ([self.screenModle.brandDic.allKeys containsObject:str]) {
                cell.button.selected = YES;
                cell.button.layer.borderColor = [UIColor colorWithHex:0xfd5487].CGColor;
            }
            else{
                cell.button.selected = NO;
                cell.button.layer.borderColor = [UIColor colorWithHex:0xe1e1e1].CGColor;
            }
        }
            break;
        case 3:{
            
            NSString * str = dataDic[@"gc_name"];
            if ([self.screenModle.classifyDic.allKeys containsObject:str]) {
                cell.button.selected = YES;
                cell.button.layer.borderColor = [UIColor colorWithHex:0xfd5487].CGColor;
            }
            else{
                cell.button.selected = NO;
                cell.button.layer.borderColor = [UIColor colorWithHex:0xe1e1e1].CGColor;
            }
        }
            break;
            
        default:
            break;
    }
    return cell;
}
#pragma mark -- UICollectionViewDelegate --
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind  == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        for (UIView * view in header.subviews) {
            [view removeFromSuperview];
            
        }
        ScreenSectionView * sectionHeader = [[ScreenSectionView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.viewWidth, 36)];
        sectionHeader.backgroundColor = [UIColor whiteColor];
        sectionHeader.delegate = self;
        sectionHeader.button.tag = indexPath.section + 200;
        sectionHeader.textLabel.text = _sectionTitles[indexPath.section];
       
        [header addSubview:sectionHeader];
        switch (indexPath.section) {
            case 0:{
                if (self.screenModle.spreadPrice) {
                    sectionHeader.bottomLine.hidden = YES;
                    [sectionHeader arrowDownState];
                }
                else{
                     sectionHeader.bottomLine.hidden = NO;
                    [sectionHeader arrowUpState];
                }
               
                sectionHeader.detailLabel.text = self.screenModle.priceRange;
            }
            break;
            case 1:{
                if (self.screenModle.spreadPlace) {
                    sectionHeader.bottomLine.hidden = YES;
                    [sectionHeader arrowDownState];
                }
                else{
                    sectionHeader.bottomLine.hidden = NO;
                    [sectionHeader arrowUpState];
                }
                if (self.screenModle.productPlaces.count > 0) {
                     sectionHeader.detailLabel.text = [[self fromProductPlacesArray:self.screenModle.productPlaces]stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
                }
               
            }
                break;
            case 2:{
                if (self.screenModle.spreadBrand) {
                    sectionHeader.bottomLine.hidden = YES;
                    [sectionHeader arrowDownState];
                }
                else{
                    sectionHeader.bottomLine.hidden = NO;
                    [sectionHeader arrowUpState];
                }
                if (self.screenModle.brands.count > 0) {
                     sectionHeader.detailLabel.text = [[self fromBrandsArray:self.screenModle.brands]stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
                }
               
            }
                break;
            case 3:{
                if (self.screenModle.spreadClass) {
                    sectionHeader.bottomLine.hidden = YES;
                    [sectionHeader arrowDownState];
                }
                else{
                    sectionHeader.bottomLine.hidden = NO;
                    [sectionHeader arrowUpState];
                }
                if (self.screenModle.classifies.count > 0) {
                 sectionHeader.detailLabel.text =  [[self fromClassifyArray:self.screenModle.classifies] stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
                }
               
            }
                break;
                
            default:
                break;
        }
        return header;
    }
    else if (kind == UICollectionElementKindSectionFooter){
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView" forIndexPath:indexPath];
        for (UIView * view in footer.subviews) {
            [view removeFromSuperview];
            
        }
        if (indexPath.section == 0) {
            [footer addSubview:self.priceRangeView];
        }
        else{
            UIView * sectionFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
            sectionFooter.backgroundColor = [UIColor whiteColor];
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, sectionFooter.viewHeight - 1, self.contentView.viewWidth, 1)];
            line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
            [sectionFooter addSubview:line];
            [footer addSubview:sectionFooter];
        }
        
        return footer;
    
    };
    return nil;
    
    
    
   
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size;
    size = CGSizeMake(SCREEN_WIDTH, 36);
    if (self.screenViewType == ScreenViewNoBrand) {
        if (section == 2) {
             size = CGSizeMake(SCREEN_WIDTH, 0);
        }
    }
    else if (self.screenViewType == ScreenViewNoThirdClass){
        if (section == 3) {
            size = CGSizeMake(SCREEN_WIDTH, 0);
        }
    }
    return size;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size;
    if (section == 0) {
        if (self.screenModle.spreadPrice) {
           size = CGSizeMake(SCREEN_WIDTH, 50);
        }
        else{
           size = CGSizeMake(SCREEN_WIDTH, 0);
        }
    }
    else if (section == 1){
        if (self.screenModle.spreadPlace) {
            size = CGSizeMake(SCREEN_WIDTH, 12);
        }
        else{
            size = CGSizeMake(SCREEN_WIDTH, 0);
        }
    }
    else if (section == 2){
        if (self.screenModle.spreadBrand) {
            size = CGSizeMake(SCREEN_WIDTH, 12);
        }
        else{
            size = CGSizeMake(SCREEN_WIDTH, 0);
        }
    }
    else if (section == 3){
        if (self.screenModle.spreadClass) {
            size = CGSizeMake(SCREEN_WIDTH, 12);
        }
        else{
            size = CGSizeMake(SCREEN_WIDTH, 0);
        }
    }
    
    return size;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    UILabel * label = [[UILabel alloc]init];
    NSString * string = nil;
    switch (indexPath.section) {
        case 0:
            string = self.screenModle.dataSource[indexPath.section][indexPath.row][@"name"];
            break;
        case 1:
            string = self.screenModle.dataSource[indexPath.section][indexPath.row][@"name"];
            break;
        case 2:
            string = self.screenModle.dataSource[indexPath.section][indexPath.row][@"brand_name"];
            break;
        case 3:
            string = self.screenModle.dataSource[indexPath.section][indexPath.row][@"gc_name"];
            break;
            
        default:
            break;
    }
    label.text = string;
    [label sizeToFit];
    NSLog(@"%f",label.bounds.size.width);
    
    size = CGSizeMake(label.frame.size.width + 18, 26);
    return size;
    
}

#pragma mark --  ScreenSectionDelegate --
-(void)ScreenSectionClickButton:(UIButton *)sender
{
    NSInteger section = sender.tag - 200;
    NSArray * dataArray = self.screenModle.dataSource[section];
    if (dataArray.count > 0) {
        NSInteger rowCount = [self.screenModle.cellRowCountArr[section] integerValue];
        if (rowCount == 0) {
            NSInteger cellCount = ((NSArray *)self.screenModle.dataSource[section]).count;
            [self.screenModle.cellRowCountArr replaceObjectAtIndex:section withObject:[NSNumber numberWithInteger:cellCount]];
            switch (section) {
                case 0:self.screenModle.spreadPrice = YES;break;
                case 1:self.screenModle.spreadPlace = YES;break;
                case 2:self.screenModle.spreadBrand = YES;break;
                case 3:self.screenModle.spreadClass = YES;break;
                default:break;
            }
            
            
            
        }
        else{
            [self.screenModle.cellRowCountArr replaceObjectAtIndex:section withObject:@0];
            switch (section) {
                case 0:self.screenModle.spreadPrice = NO;break;
                case 1:self.screenModle.spreadPlace = NO;break;
                case 2:self.screenModle.spreadBrand = NO;break;
                case 3:self.screenModle.spreadClass = NO;break;
                default:break;
            }
            
            
        }
        
        // [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:section]];
        [self.collectionView reloadData];
    }
    
    
}
#pragma mark -- ScreenCollectionCellDelegate --
-(void)screenCollectionCell:(ScreenCollectionCell *)cell index:(NSIndexPath *)index dataDic:(NSDictionary *)dataDic button:(UIButton *)sender
{
    switch (index.section) {
        case 0:{
            if (sender.selected == NO) {
                self.screenModle.priceRange =@"";
                [self.screenModle.priceRangeArr removeAllObjects];
                break;
            }
            self.screenModle.priceRange = dataDic[@"name"];
            [self.screenModle.priceRangeArr removeAllObjects];
            [self.screenModle.priceRangeArr addObject:self.screenModle.priceRange];
            NSArray * arr = [self fromPriceRangeString:self.screenModle.priceRange];
            if (arr.count > 1) {
                self.beginTF.text = arr[0];
                self.endTF.text = arr[1];
            }
            else{
                self.beginTF.text = @"";
                self.endTF.text = @"";
            }
            
        }
            break;
        case 1:{
            if (sender.selected) {
                sender.selected = NO;
                [self.screenModle.productPlaces removeObject:dataDic];
                [self.screenModle.productPlaceDic removeObjectForKey:dataDic[@"name"]];
            }
            else{
                if (self.screenModle.productPlaces.count >=5) {
                    
                    [MBProgressHUD show:@"最多选五项" toView:self];
                }
                else{
                    [self.screenModle.productPlaces addObject:dataDic];
                    [self.screenModle.productPlaceDic setObject:dataDic[@"id"] forKey:dataDic[@"name"]];
                }
            }
            
        }
            break;
        case 2:{
            
            if (sender.selected) {
                sender.selected = NO;
                [self.screenModle.brands removeObject:dataDic];
                [self.screenModle.brandDic removeObjectForKey:dataDic[@"brand_name"]];
            }
            else{
                if (self.screenModle.brands.count >=5) {
                   [MBProgressHUD show:@"最多选五项" toView:self];
                }
                else{
                    [self.screenModle.brands addObject:dataDic];
                    [self.screenModle.brandDic setObject:dataDic[@"brand_id"] forKey:dataDic[@"brand_name"]];
                }
            }
            
            
        }
            break;
        case 3:{
            
            if (sender.selected) {
                sender.selected = NO;
                [self.screenModle.classifies removeObject:dataDic];
                [self.screenModle.classifyDic removeObjectForKey:dataDic[@"gc_name"]];
            }
            else{
                if (self.screenModle.classifies.count >=5) {
                    [MBProgressHUD show:@"最多选五项" toView:self];
                }
                else{
                    [self.screenModle.classifies addObject:dataDic];
                    [self.screenModle.classifyDic setObject:dataDic[@"gc_id"] forKey:dataDic[@"gc_name"]];
                }
            }

            
            
        }
            break;
            
        default:
            break;
    }
    
    [self.collectionView reloadData];
}
#pragma mark -- UITextFieldDelegate --
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 2001) {
        [textField endEditing:YES];
        UITextField * TF = (UITextField *)[self.priceRangeView viewWithTag:2000];
        CGFloat beginPrice = [TF.text floatValue];
        CGFloat endPrice = [textField.text floatValue];
        if (beginPrice > endPrice) {
            self.screenModle.priceRange = [NSString stringWithFormat:@"%@-%@",textField.text,TF.text];
        }
        else{
            self.screenModle.priceRange = [NSString stringWithFormat:@"%@-%@",TF.text,textField.text];
        }
        [self.screenModle.priceRangeArr removeAllObjects];
        [self.screenModle.priceRangeArr addObject:self.screenModle.priceRange];
        
        [self.collectionView reloadData];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 2000) {
        [textField resignFirstResponder];
        UITextField * TF = (UITextField *)[self.priceRangeView viewWithTag:2001];
        [TF becomeFirstResponder];
    }
    else if (textField.tag == 2001){
        [textField endEditing:YES];
        /*
         UITextField * TF = (UITextField *)[self.priceRangeView viewWithTag:2000];
        CGFloat beginPrice = [TF.text floatValue];
        CGFloat endPrice = [textField.text floatValue];
        if (beginPrice > endPrice) {
            self.screenModle.priceRange = [NSString stringWithFormat:@"%@-%@",textField.text,TF.text];
        }
        else{
          self.screenModle.priceRange = [NSString stringWithFormat:@"%@-%@",TF.text,textField.text];
        }
        [self.screenModle.priceRangeArr removeAllObjects];
        [self.screenModle.priceRangeArr addObject:self.screenModle.priceRange];
       
        [self.collectionView reloadData];
         */
    }
    return YES;
}
#pragma mark -- 网络请求 --
-(void)originListNetWork
{
    NSDictionary *parm;
    if ([self.classId length]==0) {
        parm = @{@"goods_platform_only":_goods_platform_only};
    }else{
        parm = @{@"classId":self.classId};
    }
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"OriginList" parameters:parm callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSArray * arr = object[@"data"];
            [self.screenModle.dataSource replaceObjectAtIndex:1 withObject:arr];
        }
        else if (result == RequestResultEmptyData){
        }
        else if (result == RequestResultException){
        }
        else if (result == RequestResultFailed){
        }
    }];
}
-(void)brandLitWork
{
    NSDictionary *parm;
    if ([self.classId length]==0) {
        parm = @{@"goods_platform_only":_goods_platform_only};
    }else{
        parm = @{@"classId":self.classId};
    }
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"BrandList" parameters:parm callBack:^(RequestResult result, id object) {

        if (result == RequestResultSuccess) {
            NSArray * arr = object[@"data"];
            [self.screenModle.dataSource replaceObjectAtIndex:2 withObject:arr];
        }
        else if (result == RequestResultEmptyData){
        }
        else if (result == RequestResultException){
        }
        else if (result == RequestResultFailed){
        }
    }];
}
-(void)classifyLisyNetWork
{
    NSDictionary *parm;
    if ([self.classId length]==0) {
        parm = @{@"goods_platform_only":_goods_platform_only};
    }else{
        parm = @{@"gcid":self.classId};
    }
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"ThirdgcList" parameters:parm callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSArray * arr = object[@"data"];
            [self.screenModle.dataSource replaceObjectAtIndex:3 withObject:arr];
        }
        else if (result == RequestResultEmptyData){
        }
        else if (result == RequestResultException){
        }
        else if (result == RequestResultFailed){
        }
    }];
}
#pragma mark -- private --
-(NSArray * )fromPriceRangeString:(NSString *)priceRangeStr
{
    NSArray * arr = [priceRangeStr componentsSeparatedByString:@"-"];
    return arr;
    
}

-(NSString *)fromProductPlacesArray:(NSMutableArray *)array
{
    if (array.count > 0) {
        NSMutableString * string = [NSMutableString string];
        for (int i = 0; i < array.count ; i ++) {
            [string appendFormat:@"%@,",array[i][@"name"]];
        }
        
        return [string substringWithRange:NSMakeRange(0, string.length - 1)];
    }
    return @"";
   
    
}
-(NSString *)fromBrandsArray:(NSMutableArray *)array
{
    if (array.count > 0) {
        NSMutableString * string = [NSMutableString string];
        for (int i = 0; i < array.count ; i ++) {
            [string appendFormat:@"%@,",array[i][@"brand_name"]];
        }
        
        return [string substringWithRange:NSMakeRange(0, string.length - 1)];
    }
    return @"";
    
    
}
-(NSString *)fromClassifyArray:(NSMutableArray *)array
{
    if (array.count > 0) {
        NSMutableString * string = [NSMutableString string];
        for (int i = 0; i < array.count ; i ++) {
            [string appendFormat:@"%@,",array[i][@"gc_name"]];
        }
        
        return [string substringWithRange:NSMakeRange(0, string.length - 1)];
    }
    return @"";
    
}
@end
