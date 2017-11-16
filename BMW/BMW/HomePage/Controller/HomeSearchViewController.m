//
//  HomeSearchViewController.m
//  BMW
//
//  Created by rr on 16/3/3.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "HomeSearchViewController.h"
#import "HomeCell.h"
#import "GoodsDetailViewController.h"

#define kAlertString(keyWord) [NSString stringWithFormat:@"抱歉！没有找到“%@”相关商品，\n换个搜索词再试试吧！", keyWord]

@interface HomeSearchViewController ()<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    
    UIImageView *_searchImageV;
    UITextField *_searchText;
    UIButton *_keyButton;
    
    NSArray *_hotSource;
    UILabel *_currentLabel;
    UILabel *_currentHisLabel;
    CGFloat _totalWith;
    CGFloat _totalWithHis;
    CGFloat _contentHight;
    NSArray *_hisArray;
    int _count;
    int _disCount;
    
    UIButton *_clearButton;
    
    UILabel *_salesLabel;
    UILabel *_priceLabel;
    UIImageView *_priceImage;
    
    UIButton *_salesButton;
    UIButton *_priceButton;
    
    UILabel *_hisSearch;
    
    NSMutableArray *_dataSource;
    NSInteger _index;
    
    UIView *_resultView;
    UILabel *_sorroyLabel;
    
    CGFloat _topHight;
    BOOL _firstB;
    
}
@property(nonatomic,strong)UIView *hotseaerchView;
@property(nonatomic,strong)UIView *mainView;


@end

@implementation HomeSearchViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(UIView *)hotseaerchView{
    if (!_hotseaerchView) {
        _hotseaerchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _hotseaerchView.backgroundColor = [UIColor colorWithHex:0xffffff];
        
        UILabel *hotSearch = [[UILabel alloc] initWithFrame:CGRectMake(15*W_ABCW, 17, 48, 12)];
        hotSearch.text =@"热门搜索";
        hotSearch.textColor = [UIColor colorWithHex:0x969696];
        hotSearch.font = fontForSize(12);
        [hotSearch sizeToFit];
        hotSearch.viewHeight = 12;
        [_hotseaerchView  addSubview:hotSearch];
        
        for (int i=0; i<_hotSource.count; i++) {
            UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*W_ABCW, 0, 10, 22)];
            hotLabel.tag = 1314+i;
            hotLabel.text = _hotSource[i];
            hotLabel.textColor = [UIColor colorWithHex:0x6f6f6f];
            hotLabel.layer.borderWidth = 0.5;
            hotLabel.layer.cornerRadius = 11;
            hotLabel.layer.borderColor = [UIColor colorWithHex:0xe1e1e1].CGColor;
            hotLabel.layer.masksToBounds = YES;
            hotLabel.font = fontForSize(12);
            [hotLabel sizeToFit];
            hotLabel.viewSize =  CGSizeMake(hotLabel.viewWidth+18, 22);
            _totalWith += hotLabel.viewWidth;
            hotLabel.textAlignment = NSTextAlignmentCenter;
            if (_currentLabel) {
                if ((30*W_ABCW+7*W_ABCW*_disCount+_totalWith)>SCREEN_WIDTH) {
                    _count++;
                    _disCount  = 0;
                    _totalWith = hotLabel.viewWidth;
                    [hotLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15*W_ABCW, _currentLabel.viewBottomEdge+13)];
                }else{
                    if (_count>0) {
                        _disCount++;
                        [hotLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15*W_ABCW+_disCount*7+(_totalWith-hotLabel.viewWidth), 35*_count+hotLabel.viewBottomEdge+12)];
                    }else{
                        _disCount++;
                        [hotLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15*W_ABCW+_disCount*7+(_totalWith-hotLabel.viewWidth), 12+hotSearch.viewBottomEdge)];
                    }
                }
            }else{
                [hotLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15*W_ABCW, 12+hotSearch.viewBottomEdge)];
            }
            _currentLabel = hotLabel;
            [_hotseaerchView addSubview:hotLabel];
            
            UIButton *tagButton = [[UIButton alloc] initWithFrame:CGRectMake(hotLabel.viewX, hotLabel.viewY, hotLabel.viewWidth, hotLabel.viewHeight)];
            tagButton.backgroundColor = [UIColor clearColor];
            tagButton.tag = 200+i;
            [tagButton addTarget:self action:@selector(choosehotTitle:) forControlEvents:UIControlEventTouchUpInside];
            [_hotseaerchView addSubview:tagButton];
        }
        _contentHight = (_count+1)*35+12+17+12+4;
        _topHight = _contentHight;
        _disCount = 0;
        
    }
    return _hotseaerchView;
}

-(UIView *)mainView{
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _mainView.backgroundColor = COLOR_BACKGRONDCOLOR;
        _mainView.hidden = YES;
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38)];
        topView.backgroundColor = [UIColor whiteColor];
        [_mainView addSubview:topView];
        
        _salesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 38)];
        _salesLabel.text = @"销量";
        _salesLabel.textAlignment = NSTextAlignmentCenter;
        _salesLabel.textColor = [UIColor colorWithHex:0xfd5487];
        _salesLabel.font = fontForSize(14);
        [_mainView addSubview:_salesLabel];
        
        _salesButton = [[UIButton alloc] initWithFrame:_salesLabel.frame];
        _salesButton.selected = YES;
        [_salesButton addTarget:self action:@selector(chooseSale) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:_salesButton];
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 38)];
        _priceLabel.text = @"价格";
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.textColor = [UIColor colorWithHex:0x181818];
        _priceLabel.font = fontForSize(14);
        [_mainView addSubview:_priceLabel];
        
        _priceImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4+20, 13, 9, 11)];
        _priceImage.image = IMAGEWITHNAME(@"icon_jiantoupaixu_nor_ssjg.png");
        [_priceLabel addSubview:_priceImage];
        
        _priceButton = [[UIButton alloc] initWithFrame:_priceLabel.frame];
        [_priceButton addTarget:self action:@selector(priceChoose) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:_priceButton];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, topView.viewBottomEdge, SCREEN_WIDTH, 0.5*W_ABCH)];
        line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_mainView addSubview:line];
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(4*W_ABCW, line.viewBottomEdge, SCREEN_WIDTH-8*W_ABCW, SCREEN_HEIGHT-64-42) collectionViewLayout:layout];
            _collectionView.backgroundColor = COLOR_BACKGRONDCOLOR;
        [_collectionView registerClass:[HomeCell class] forCellWithReuseIdentifier:@"pageCell"];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate= self;
        [_collectionView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
        [_collectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreList)];
        _collectionView.legendFooter.hidden = YES;
        [_mainView addSubview:_collectionView];

        _resultView = [[UIView alloc] initWithFrame:CGRectMake(0, 38, SCREEN_WIDTH, _mainView.viewHeight-38-64)];
        _resultView.backgroundColor = COLOR_BACKGRONDCOLOR;
        _resultView.hidden = YES;
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(64*W_ABCW, 87*W_ABCH, 13, 13)];
        imageV.image = IMAGEWITHNAME(@"icon_tixing_ssjg.png");
        [_resultView addSubview:imageV];
        
        
        _sorroyLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageV.viewRightEdge+5*W_ABCW, imageV.viewY, SCREEN_WIDTH-150, 29)];
        _sorroyLabel.textAlignment = NSTextAlignmentCenter;
        _sorroyLabel.font = fontForSize(12);
        _sorroyLabel.textColor = [UIColor colorWithHex:0x878787];
        _sorroyLabel.numberOfLines = 2;
        [_resultView addSubview:_sorroyLabel];
        
        [_mainView addSubview:_resultView];
        
        
    }
    return _mainView;
}

-(void)refreshView{
    _index = 1;
    [_dataSource removeAllObjects];
    if (_salesButton.selected) {
        [self updateWithKey:_searchText.text];
    }else{
        if (_priceButton.selected) {
            [self updateWithKey:_searchText.text andPrice:@"1"];
        }else{
            [self updateWithKey:_searchText.text andPrice:@"0"];
        }
    }
}

-(void)loadMoreList{
    _index+=20;
    if (_salesButton.selected) {
        [self.HUD show:YES];
        [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GoodsList" parameters:@{@"keywd":_searchText.text,@"salenum":@"0",@"start":NSNumber(_index),@"limit":@"20"} callBack:^(RequestResult result, id object) {
            [self.HUD hide:YES];
            [_collectionView.header endRefreshing];
            [_collectionView.footer endRefreshing];
            if (result == RequestResultSuccess) {
                [_dataSource addObjectsFromArray:object[@"data"]];
                if (_dataSource.count<20) {
                    [_collectionView.footer setState:MJRefreshFooterStateNoMoreData];
                }
                [_collectionView reloadData];
            }else if(result == RequestResultEmptyData){
                [_collectionView.footer setState:MJRefreshFooterStateNoMoreData];
            }
        }];
    }else{
        if (_priceButton.selected) {
            [self updateWithKey:_searchText.text andPrice:@"1"];
        }else{
            [self updateWithKey:_searchText.text andPrice:@"0"];
        }
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self customNavigationBar];
    [self initData];
    [self initUserInterface];
}
-(void)customNavigationBar{
    
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
    titleView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    self.navigationItem.titleView = titleView;
    
    _searchImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15*W_ABCW, 5, 240*W_ABCW, 34)];
//    _searchImageV.image = IMAGEWITHNAME(@"btn_sousuokuang_ss.png");
    _searchImageV.backgroundColor = [UIColor whiteColor];
    _searchImageV.layer.cornerRadius = 3;
    _searchImageV.layer.masksToBounds = YES;
    _searchImageV.userInteractionEnabled = YES;
    [titleView addSubview:_searchImageV];
    
    UIImageView *sousuoImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*W_ABCW, 0, 12, 12)];
    sousuoImage.center =CGPointMake(10*W_ABCW+6, 17);
    sousuoImage.image = IMAGEWITHNAME(@"Search_ss.png");
    [_searchImageV addSubview:sousuoImage];
    
    _searchText = [[UITextField alloc] initWithFrame:CGRectMake(32, 4, 260*W_ABCW-30, 30)];
    _searchText.placeholder = @"搜索商品名称或品牌";
    [_searchText becomeFirstResponder];
//    _searchText.textColor = [UIColor colorWithHex:0x969696];
    _searchText.textColor = [UIColor blackColor];
    _searchText.returnKeyType = UIReturnKeySearch;
    _searchText.font = fontForSize(12);
    _searchText.delegate = self;
    [_searchImageV addSubview:_searchText];
    
    UIButton *backVC = [UIButton new];
    backVC.viewSize = CGSizeMake(44, 44);
    [backVC setTitle:@"取消" forState:UIControlStateNormal];
    [backVC setTitleColor:COLOR_NAVIGATIONBAR_ITEM forState:UIControlStateNormal];
    backVC.titleLabel.font = fontForSize(15*W_ABCW);
//    [backVC sizeToFit];
//    backVC.viewSize = CGSizeMake(backVC.viewWidth, 44);
    [backVC addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [backVC align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15, 0)];
    [titleView addSubview:backVC];
}

-(void)backVC{
    [self.view endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:NO];
    });
}

-(void)chooseSale{
    [_dataSource removeAllObjects];
    _salesButton.selected = YES;
    _salesLabel.textColor = [UIColor colorWithHex:0xfd5487];
    _priceLabel.textColor = [UIColor colorWithHex:0x181818];
    _priceImage.image = IMAGEWITHNAME(@"icon_jiantoupaixu_nor_ssjg.png");
    _priceButton.selected = NO;
    [self updateWithKey:_searchText.text];
}

-(void)priceChoose{
    [_dataSource removeAllObjects];
    _index = 1;
    _priceLabel.textColor = [UIColor colorWithHex:0xfd5487];
    _salesLabel.textColor = [UIColor colorWithHex:0x181818];
    _salesButton.selected = NO;
    if (_priceButton.selected) {
        _priceButton.selected = NO;
        _priceImage.image = IMAGEWITHNAME(@"icon_jiangejiantou2_gdtj.png");
        [self updateWithKey:_searchText.text andPrice:@"0"];
    }else{
        _priceButton.selected = YES;
        [self updateWithKey:_searchText.text andPrice:@"1"];
        _priceImage.image = IMAGEWITHNAME(@"icon_jiangejiantou1_gdtj.png");
    }
}

-(void)updateWithKey:(NSString *)keyWord andPrice:(NSString *)loworHigt{
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GoodsList" parameters:@{@"keywd":keyWord,@"price":loworHigt,@"start":NSNumber(_index),@"limit":@"20"} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        [_collectionView.header endRefreshing];
        [_collectionView.footer endRefreshing];
        if (result == RequestResultSuccess) {
            [_dataSource addObjectsFromArray:object[@"data"]];
            if (_dataSource.count==20) {
                _collectionView.footer.hidden = NO;
            }else{
                [_collectionView.footer setState:MJRefreshFooterStateNoMoreData];
            }
        }else if(result == RequestResultEmptyData){
            [_collectionView.footer setState:MJRefreshFooterStateNoMoreData];
        }
        [_collectionView reloadData];
    }];

}

-(void)initData{
    _contentHight = 0;
    _topHight =0;
    _count = 0;
    _totalWith = 0;
    _disCount = 0;
    _index = 1;
    _firstB = NO;
    _dataSource = [NSMutableArray array];
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"HotSearch" parameters:nil callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        if (RequestResultSuccess == result) {
            NSString *jsonString = object[@"data"][@"value"];
            _hotSource = [jsonString componentsSeparatedByString:@","];
            [self.view addSubview:self.hotseaerchView];
            _hisArray = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"baopinSearchHistory"]];
            if (_hisArray.count>0) {
                [self initHisSearchView];
            }
        }
    }];
}

-(void)initUserInterface{
    [self.view addSubview:self.mainView];
}

-(void)initHisSearchView
{
    _firstB = YES;
    _hisSearch = [[UILabel alloc] initWithFrame:CGRectMake(15*W_ABCW, _topHight, 48, 12)];
    _hisSearch.text =@"历史搜索";
    _hisSearch.textColor = [UIColor colorWithHex:0x969696];
    _hisSearch.font = fontForSize(12);
    [_hisSearch sizeToFit];
    _hisSearch.viewHeight = 12;
    [_hotseaerchView  addSubview:_hisSearch];
    for (int i=0; i<_hisArray.count; i++) {
        UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(15*W_ABCW, 0, 10, 22)];
        hotLabel.tag = 13140+i;
        hotLabel.text = _hisArray[i];
        hotLabel.textColor = [UIColor colorWithHex:0x6f6f6f];
        hotLabel.layer.borderWidth = 0.5;
        hotLabel.layer.cornerRadius = 11;
        hotLabel.layer.borderColor = [UIColor colorWithHex:0xe1e1e1].CGColor;
        hotLabel.layer.masksToBounds = YES;
        hotLabel.font = fontForSize(12);
        [hotLabel sizeToFit];
        hotLabel.viewSize =  CGSizeMake(hotLabel.viewWidth+18, 22);
        _totalWithHis += hotLabel.viewWidth;
        hotLabel.textAlignment = NSTextAlignmentCenter;
        if (_currentHisLabel) {
            if ((30*W_ABCW+7*W_ABCW*_disCount+_totalWithHis)>SCREEN_WIDTH) {
                _count++;
                _disCount  = 0;
                _totalWithHis = hotLabel.viewWidth;
                [hotLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15*W_ABCW, _currentHisLabel.viewBottomEdge+13)];
            }else{
                if (_count>0) {
                    _disCount++;
                    [hotLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15*W_ABCW+_disCount*7+(_totalWithHis-hotLabel.viewWidth), _currentHisLabel.viewY)];
                }else{
                    _disCount++;
                    [hotLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15*W_ABCW+_disCount*7+(_totalWithHis-hotLabel.viewWidth), 12+_hisSearch.viewBottomEdge)];
                }
            }
        }else{
            [hotLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15*W_ABCW, 12+_hisSearch.viewBottomEdge)];
        }
        _currentHisLabel = hotLabel;
        [_hotseaerchView addSubview:hotLabel];
        
        UIButton *tagButton = [[UIButton alloc] initWithFrame:CGRectMake(hotLabel.viewX, hotLabel.viewY, hotLabel.viewWidth, hotLabel.viewHeight)];
        tagButton.backgroundColor = [UIColor clearColor];
        tagButton.tag = 2000+i;
        [tagButton addTarget:self action:@selector(choosehotTitle:) forControlEvents:UIControlEventTouchUpInside];
        [_hotseaerchView addSubview:tagButton];
    }
    if (_contentHight!=0) {
        _contentHight = 0;
    }
    _contentHight += (_count+1)*35+12+12+14;
    
    _clearButton = [[UIButton alloc] initWithFrame:CGRectMake(15, _contentHight+_topHight, SCREEN_WIDTH-30, 35)];
    _clearButton.layer.borderWidth =1;
    _clearButton.layer.borderColor = [UIColor colorWithHex:0xfd5487].CGColor;
    [_clearButton setTitle:@"清空搜索历史" forState:UIControlStateNormal];
    [_clearButton setTitleColor:[UIColor colorWithHex:0xfd5487] forState:UIControlStateNormal];
    _clearButton.titleLabel.font = fontForSize(12);
    [_clearButton addTarget:self action:@selector(clearHis) forControlEvents:UIControlEventTouchUpInside];
    [_hotseaerchView addSubview:_clearButton];
}

-(void)clearHis{
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"baopinSearchHistory"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    for (int i = 0; i<_hisArray.count; i++) {
        UILabel *removeL = [_hotseaerchView viewWithTag:13140+i];
        [removeL removeFromSuperview];
    }
    [_hisSearch removeFromSuperview];
    [_clearButton removeFromSuperview];
}

-(void)updateWithKey:(NSString *)keyWord{
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"GoodsList" parameters:@{@"keywd":keyWord,@"salenum":@"0",@"start":NSNumber(_index),@"limit":@"20"} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        [_collectionView.header endRefreshing];
        [_collectionView.footer endRefreshing];
        if (result == RequestResultSuccess) {
            [_dataSource addObjectsFromArray:object[@"data"]];
            if (_dataSource.count>=20) {
                _resultView.hidden = YES;
                _collectionView.hidden = NO;
                _collectionView.footer.hidden = NO;
            }else if(_dataSource.count==0){
                _collectionView.hidden = YES;
                _resultView.hidden = NO;
                _collectionView.footer.hidden = YES;
            }else{
                _collectionView.hidden = NO;
                _resultView.hidden  =YES;
                _collectionView.footer.hidden = YES;
            }
            [_collectionView reloadData];
        }else if(result == RequestResultEmptyData){
            _collectionView.hidden = YES;
            _sorroyLabel.viewSize = CGSizeMake(SCREEN_WIDTH-150, 29);
            _sorroyLabel.attributedText = [self attributed];
            _sorroyLabel.attributedText = [self otherAtt];
            [_sorroyLabel sizeToFit];
//            _sorroyLabel.viewSize = CGSizeMake(_sorroyLabel.viewWidth, 29*W_ABCH);
            _sorroyLabel.textAlignment = NSTextAlignmentCenter;
            
            _resultView.hidden = NO;
            _collectionView.footer.hidden = YES;
            [_collectionView reloadData];
            SHOW_MSG(@"暂无相关商品信息");
        }else {
            NSString * message = @"获取相关商品信息失败，请重试";
            if ([object isKindOfClass:[NSString class]]) {
                message = object;
            }
            SHOW_EEROR_MSG(message);
        }
    }];
}



#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSLog(@"点击了搜索");
    NSMutableArray *historyArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"baopinSearchHistory"]];
    if (textField.text && textField.text.length > 0) {
        if ([historyArray containsObject:textField.text]) {
        }else{
            [historyArray addObject:textField.text];
            [[NSUserDefaults standardUserDefaults]setObject:historyArray forKey:@"baopinSearchHistory"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    _hotseaerchView.hidden = YES;
    _mainView.hidden = NO;
    [_dataSource removeAllObjects];
    
    [self keyButton:textField.text];
    [self updateWithKey:textField.text];
    
    return YES;
}

-(void)cancelKey{
    [_keyButton removeFromSuperview];
    _index = 1;
    _keyButton = nil;
    _mainView.hidden = YES;
    _hotseaerchView.hidden = NO;
    _keyButton.hidden = YES;
    _searchText.text = @"";
    [_searchText becomeFirstResponder];
    _hisArray = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"baopinSearchHistory"]];
    for (int i = 0; i<_hisArray.count; i++) {
        UILabel *removeL = [_hotseaerchView viewWithTag:13140+i];
        [removeL removeFromSuperview];
    }
    [_hisSearch removeFromSuperview];
    [_clearButton removeFromSuperview];
    _currentHisLabel = nil;
    _totalWithHis = 0;
    _count = 0;
    _contentHight = 0;
    _disCount = 0;
    [self initHisSearchView];
}

-(NSMutableAttributedString *)attributed{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 5;
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle};
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:kAlertString(_searchText.text)];
    [att setAttributes:attributes range:NSMakeRange(0, [kAlertString(_searchText.text) length])];
    if (_searchText.text.length>4) {
        att = [[NSMutableAttributedString alloc] initWithString:kAlertString(_searchText.text)];
        [att setAttributes:attributes range:NSMakeRange(0, [kAlertString(_searchText.text) length])];
    }
    return att;
}
-(NSMutableAttributedString *)otherAtt{
    NSDictionary *diction = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHex:0xfd5487]};
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:kAlertString(_searchText.text)];
    if (_searchText.text.length>4) {
        att = [[NSMutableAttributedString alloc] initWithString:kAlertString(_searchText.text)];
    }
    [att setAttributes:diction range:NSMakeRange(7, _searchText.text.length+2)];
    return att;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_firstB) {
        _mainView.hidden = YES;
        _hotseaerchView.hidden = NO;
        _keyButton.hidden = YES;
        _hisArray = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"baopinSearchHistory"]];
        for (int i = 0; i<_hisArray.count; i++) {
            UILabel *removeL = [_hotseaerchView viewWithTag:13140+i];
            [removeL removeFromSuperview];
        }
        [_hisSearch removeFromSuperview];
        [_clearButton removeFromSuperview];
        _currentHisLabel = nil;
        _totalWithHis = 0;
        _count = 0;
        _contentHight = 0;
        _disCount = 0;
        if(_hisArray.count>0){
            [self initHisSearchView];
        }
    }
}


-(void)choosehotTitle:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    [_searchText resignFirstResponder];
    if (sender.tag<2000) {
        UILabel *buttonLabel = [_hotseaerchView viewWithTag:1314+sender.tag-200];
        _searchText.text = buttonLabel.text;
        NSMutableArray *historyArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"baopinSearchHistory"]];
        if (_searchText.text && _searchText.text.length > 0) {
            if (![historyArray containsObject:_searchText.text]) {
                [historyArray addObject:_searchText.text];
                [[NSUserDefaults standardUserDefaults]setObject:historyArray forKey:@"baopinSearchHistory"];
                [[NSUserDefaults standardUserDefaults]synchronize];                
            }
        }
    }else{
        UILabel *buttonLabel = [_hotseaerchView viewWithTag:13140+sender.tag-2000];
        _searchText.text = buttonLabel.text;
    }
    _hotseaerchView.hidden = YES;
    _mainView.hidden = NO;
    [_dataSource removeAllObjects];
    [self keyButton:_searchText.text];
    [self updateWithKey:_searchText.text];
}

-(void)keyButton:(NSString *)keyword
{
    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
    testLabel.layer.borderWidth = 1;
    testLabel.layer.borderColor = [UIColor colorWithHex:0x5f5f5f].CGColor;
    testLabel.layer.cornerRadius = 2;
    testLabel.layer.masksToBounds = YES;
    testLabel.font = fontForSize(12);
    testLabel.text = keyword;
    testLabel.textColor = [UIColor colorWithHex:0xffffff];
    [testLabel sizeToFit];
    testLabel.viewSize = CGSizeMake(testLabel.viewWidth, 12);
    
    _keyButton = [[UIButton alloc] initWithFrame:CGRectMake(32, 4, testLabel.viewWidth+36, 27)];
    _keyButton.layer.borderWidth = 1;
    _keyButton.layer.borderColor = [UIColor colorWithHex:0x5f5f5f].CGColor;
    _keyButton.layer.cornerRadius = 2;
    _keyButton.layer.masksToBounds = YES;
    [_keyButton setBackgroundColor:[UIColor colorWithHex:0x5f5f5f]];
    [testLabel align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(9, 27/2)];
    [_keyButton addTarget:self action:@selector(cancelKey) forControlEvents:UIControlEventTouchUpInside];
    [_keyButton addSubview:testLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(testLabel.viewRightEdge+5.5, 0, 0.5, 27)];
    line.backgroundColor = [UIColor colorWithHex:0x6e6e6e];
    [_keyButton addSubview:line];
    
    UIImageView *cancleImageV = [UIImageView new];
    cancleImageV.layer.borderWidth = 0.5;
    cancleImageV.layer.borderColor = [UIColor colorWithHex:0x5f5f5f].CGColor;
    cancleImageV.layer.cornerRadius = 2;
    cancleImageV.layer.masksToBounds = YES;
    cancleImageV.viewSize = CGSizeMake(8, 8);
    [cancleImageV align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(line.viewRightEdge+6, 27/2)];
    cancleImageV.image = IMAGEWITHNAME(@"icon_quxiao_ss.png");
    [_keyButton addSubview:cancleImageV];
    [_searchImageV addSubview:_keyButton];

}

#pragma mark UICollection


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_dataSource && _dataSource.count > 0) {
         return _dataSource.count;
    }
    else{
        return 0;
    }
   
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pageCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (_dataSource && _dataSource.count > 0) {
         cell.dataDic = _dataSource[indexPath.row];
    }
   
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size ;
    size = CGSizeMake((_collectionView.viewWidth-4*W_ABCW)/2, 223);
    return size;
}
//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4*W_ABCW;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 4*W_ABCW;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(4*W_ABCW,0,4*W_ABCW,0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *sectionDic = _dataSource[indexPath.row];
    GoodsDetailViewController * goodsDetailVC =[[GoodsDetailViewController alloc]init];
    goodsDetailVC.goodsId = sectionDic[@"goods_id"];
    [self.navigationController pushViewController:goodsDetailVC animated:YES];

}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchText resignFirstResponder];
}


@end
