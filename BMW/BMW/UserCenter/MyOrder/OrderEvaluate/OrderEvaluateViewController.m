//
//  OrderEvaluateViewController.m
//  BMW
//
//  Created by gukai on 16/3/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "OrderEvaluateViewController.h"
#import "OrderEvaluteCell.h"

@interface OrderEvaluateViewController ()<UITableViewDataSource,UITableViewDelegate,OrderEvaluteCellDelegate>
@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)OrderEvaluteCell * editingCell;
@property(nonatomic,strong)UITextView * editingTextView;
@property(nonatomic,assign)CGFloat diffrence;


@property(nonatomic,copy)NSMutableDictionary * evaluteDic;
@property(nonatomic,copy)NSMutableDictionary * starDic;
@property(nonatomic,copy)NSMutableArray * evaluteArray;
@property(nonatomic,strong)UIButton * submitBtn;
/**
 * 是否匿名
 */
@property(nonatomic,assign)NSInteger isanonymous;

@end
@implementation OrderEvaluateViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUserInterface];
   
}
-(void)initData
{
    _evaluteDic = [NSMutableDictionary dictionary];
    _starDic = [NSMutableDictionary dictionary];
}
-(void)initUserInterface
{
    self.title = @"评价";
    self.view.backgroundColor = [UIColor colorWithHex:0xf1f1ed];
    [self initLeftItem];
    [self initgesture];
    [self initTableView];
    [self initBottomSubmit];
    [self initLine];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShowNotification:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHiddenNotification:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)initLine
{
    //导航栏分割线
    UIView * lineView = [UIView new];
    lineView.viewSize = CGSizeMake(SCREEN_WIDTH, 0.5);
    [lineView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
    lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self.view addSubview:lineView];
    [self.view bringSubviewToFront:lineView];
}
-(void)initLeftItem
{
    //配置导航栏的左侧返回按钮
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"icon_fanhui_gdtj.png"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(15, 0, 10, 18);
    UIBarButtonItem * backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backBtnItem;
}
-(void)initgesture
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    
}
-(void)initTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 0.5)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 220;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithHex:0xf1f1ed];
    [self.view addSubview:_tableView];
    
    
    UIView * footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    footView.backgroundColor = [UIColor colorWithHex:0xf1f1ed];
    UIButton * hiddenNameBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 18, 18)];
    [hiddenNameBtn setBackgroundImage:[UIImage imageNamed:@"icon_gouxuan_nor_pj.png"] forState:UIControlStateNormal];
    [hiddenNameBtn setBackgroundImage:[UIImage imageNamed:@"icon_gouxuan_cli_gwc.png"] forState:UIControlStateSelected];
    [hiddenNameBtn addTarget:self action:@selector(hiddenNameBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:hiddenNameBtn];
    
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(hiddenNameBtn.viewRightEdge + 10, hiddenNameBtn.viewY, 150, hiddenNameBtn.viewHeight)];
    label.text = @"匿名评价";
    label.font = fontForSize(14);
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor colorWithHex:0x7f7f7f];
    [footView addSubview:label];
    
    
    _tableView.tableFooterView = footView;
    
}
-(void)initBottomSubmit
{
    UIButton * submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - 49 , SCREEN_WIDTH, 49)];
    submitBtn.backgroundColor = [UIColor colorWithHex:0xfd5487];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = fontForSize(16);
    [submitBtn setTintColor:[UIColor whiteColor]];
    [submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    self.submitBtn = submitBtn;
}
#pragma mark -- UITableViewDataSource --
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 15;
    return _dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"orderEvluateCell";
    OrderEvaluteCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell =  [[OrderEvaluteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    cell.index = indexPath;
    cell.imageUrl = _dataSource[indexPath.row][@"goods_image"];
    cell.infoText = _dataSource[indexPath.row][@"goods_name"];
    
    if ([_evaluteDic objectForKeyNotNull:indexPath]) {
        cell.evaluteString = [_evaluteDic objectForKeyNotNull:indexPath];
    }
    else{
        cell.evaluteString = @"";
    }
    
    if ([_starDic objectForKeyNotNull:indexPath]) {
        cell.starCount = [[_starDic objectForKeyNotNull:indexPath] integerValue];
    }
    else{
        cell.starCount = 5;
    }
    
    return cell;
}
#pragma mark -- UITableViewDelegate --
#pragma mark -- Action --
-(void)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)hiddenNameBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.isanonymous = 1;
    }
    else{
        self.isanonymous = 0;
    
    }
}
-(void)tapAction:(UIGestureRecognizer *)sender
{
    [_tableView endEditing:YES];
}
-(void)submitAction:(UIButton *)sender
{
    NSString * evaluteJsonStr = [TYTools dataJsonWithDic:_evaluteArray];
    
//    NSString * evaluteString = [TYTools JSONObjectWithString:evaluteJsonStr];
    self.submitBtn.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    self.submitBtn.userInteractionEnabled = NO;
    self.HUD.labelText = @"提交中...";
    [self.HUD show:YES];
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"Evalua" parameters:@{@"orderId":_orderDic[@"order_id"],@"memberId":[JCUserContext sharedManager].currentUserInfo.memberID,@"evaluate":evaluteJsonStr,@"isanonymous":@(self.isanonymous)} callBack:^(RequestResult result, id object) {
        [self.HUD hide:YES];
        self.submitBtn.backgroundColor = [UIColor colorWithHex:0xfd5487];
        self.submitBtn.userInteractionEnabled = YES;
        NSLog(@"%@",object);
        if (result == RequestResultSuccess) {
            if (self.refresh) {
                self.refresh();
            }
            
            SHOW_MSG(@"评价成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            
            SHOW_MSG(@"评价失败,稍后再试");
        }
        
    }];
    
}
#pragma mark -- OrderEvaluteCellDelegate --
-(void)OrderEvaluteCellDidClickStarBtn:(UIButton *)sender index:(NSIndexPath *)index
{
    NSInteger starCount  = sender.tag + 1 - 100 ;
    [_starDic setObject:@(starCount) forKey:index];
    
    NSDictionary * dic = (NSDictionary *)_evaluteArray[index.row];
    NSMutableDictionary * tempDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [tempDic setObject:@(starCount) forKey:@"star"];
    [_evaluteArray replaceObjectAtIndex:index.row withObject:tempDic];
    
    
}
-(void)OrderEvaluteCellDidBegainEditingTextView:(OrderEvaluteCell *)cell textView:(UITextView *)textView
{
    self.editingCell = cell;
    self.editingTextView = textView;
}
-(void)OrderEvaluteCellDidEndEditingTextView:(OrderEvaluteCell *)cell textView:(UITextView *)textView index:(NSIndexPath *)index
{
    if (textView.text.length > 0) {
        
        [_evaluteDic setObject:textView.text forKey:index];
        
        NSDictionary * dic = (NSDictionary *)_evaluteArray[index.row];
        NSMutableDictionary * tempDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [tempDic setObject:textView.text forKey:@"content"];
        [_evaluteArray replaceObjectAtIndex:index.row withObject:tempDic];
    }
    
}
#pragma mark -- keyBoardNotification --
-(void)keyboardShowNotification:(NSNotification *)notification
{
    
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //CGFloat keyboardHeight = keyboardF.size.height;
    //    CGFloat viewY = _scrollView.viewY + _code.viewBottomEdge + 50 * W_ABCW + 46 * W_ABCW;
    //    NSLog(@"%.f = %.f",keyboardF.origin.y, viewY);
    
    CGFloat MaxY = _tableView.viewY + self.editingCell.viewY + self.editingTextView.viewBottomEdge  - _tableView.contentOffset.y;
    CGFloat difference = MaxY - (keyboardF.origin.y);
    NSLog(@"%f === %f", MaxY, difference);
    self.diffrence = difference;
    if (difference > 0) {
        [UIView animateWithDuration:duration animations:^{
            [_tableView setContentOffset:CGPointMake(0, _tableView.contentOffset.y +difference + 90) animated:YES];
        }];
    }
    
    
}
-(void)keyboardHiddenNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self.editingTextView endEditing:YES];
    if (self.diffrence > 0) {
        [UIView animateWithDuration:duration animations:^{
            [_tableView setContentOffset:CGPointMake(0, _tableView.contentOffset.y - self.diffrence - 90) animated:YES];
        }completion:^(BOOL finished) {
            self.editingCell = nil;
            self.editingTextView = nil;
            self.diffrence = 0;
        }];

    }
}
#pragma mark -- set --
-(void)setOrderDic:(NSDictionary *)orderDic
{
    _orderDic = orderDic;
    _dataSource = _orderDic[@"goods"];
    _evaluteArray = nil;
    _evaluteArray = [NSMutableArray array];
    
    for (int i = 0; i < _dataSource.count; i ++) {
        
        NSDictionary * dic = (NSDictionary *)_dataSource[i];
        
        NSMutableDictionary * evalute = [NSMutableDictionary dictionary];
        
        [evalute setObject:[dic objectForKeyNotNull:@"goods_id"] forKey:@"goodsId"];
        [evalute setObject:@"5" forKey:@"star"];
        [evalute setObject:@"" forKey:@"content"];
        [_evaluteArray addObject:evalute];
    }
}


@end
