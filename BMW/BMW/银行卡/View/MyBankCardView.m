//
//  MyBankCardView.m
//  DP
//
//  Created by LiuP on 16/7/15.
//  Copyright © 2016年 sp. All rights reserved.
//

#import "MyBankCardView.h"
#import "MyBackCardTableViewCell.h"

static NSString * cellID = @"BankCell";

@interface MyBankCardView ()<UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate>
{
    NSIndexPath *_deleIndexPath;
}


@end

@implementation MyBankCardView

#pragma mark -- init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface
{
    _tableView = [UITableView new];
    _tableView.viewSize = CGSizeMake(self.viewWidth, self.viewHeight);
    [_tableView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[MyBackCardTableViewCell class] forCellReuseIdentifier:cellID];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UITableView alloc] init];
    [self addSubview:_tableView];
    
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refresh)];
}

#pragma mark -- getter
- (RemindLoginView *)remindNoCard
{
    if (!_remindNoCard) {
        _remindNoCard = [[RemindLoginView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) type:RemindTypeNoBackCard];
        _remindNoCard.hidden = YES;
        [self addSubview:_remindNoCard];
    }
    return _remindNoCard;
}

#pragma mark -- setter
- (void)setModels:(NSMutableArray<BankCardModel *> *)models
{
    if (_models != models ) {
        _models = models;
//        if (_models.count < 20) {
//            if (_tableView.legendFooter) {
//                [_tableView removeFooter];
//            }
//        }else {
//            [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
//        }
        [self.tableView reloadData];
    }
}

#pragma mark -- actions
- (void)refresh
{
    if ([self.delegate respondsToSelector:@selector(refreshAction)]) {
        [self.delegate refreshAction];
    }
}

- (void)loadMore
{
    if ([self.delegate respondsToSelector:@selector(loadMoreActionWithModels:)]) {
        [self.delegate loadMoreActionWithModels:self.models];
    }
}

#pragma mark -- UITableViewDelegate, UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*W_ABCH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return 55*W_ABCH;
    }else{
        return 75*W_ABCH;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return self.models.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyBackCardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        BankCardModel * model = self.models[indexPath.row];
        cell.bankModel = model;
//        cell.backNameLabel.text = model.bankName;
//        cell.backNumberLabel.text = model.bankNumber;
//        cell.backCardInfoLabel.text = @"储蓄卡";
    }else{
        cell.isSpecial = YES;
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = COLOR_BACKGRONDCOLOR;
    return headView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        if ([self.delegate respondsToSelector:@selector(addNewBankCardAction)]) {
            [self.delegate addNewBankCardAction];
        }
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return YES;
    }else{
        return NO;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    editingStyle = UITableViewCellEditingStyleDelete;
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (indexPath.section==0) {
            if ([self.delegate respondsToSelector:@selector(bankCardView:deleteWithModel:)]) {
                _deleIndexPath = indexPath;
                //二次提醒
                UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"删除银行卡" message:@"确认删除此张银行卡" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alterView show];
            }
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSLog(@"取消");
    }else{
        [self.delegate bankCardView:self deleteWithModel:self.models[_deleIndexPath.row]];
    }
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 10*W_ABCH;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
//    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
}


@end
