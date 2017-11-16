//
//  InviRCView.m
//  BMW
//
//  Created by rr on 2016/12/19.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "InviRCView.h"
#import "InviRCTableViewCell.h"

@interface InviRCView ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_personNum;
    UILabel *_priceNum;
    
}
@end

@implementation InviRCView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUserInterface];
    }
    return self;
}

-(void)initUserInterface{
    [self addSubview:self.noRecordView];
    [self addSubview:self.recordView];
}


-(UIView *)noRecordView{
    if (!_noRecordView) {
        _noRecordView = [[UIView alloc] initWithFrame:self.frame];
        _noRecordView.hidden = YES;
        _noRecordView.backgroundColor = [UIColor colorWithHex:0xfffbeb];
        UIImageView *noImageV = [UIImageView new];
        noImageV.viewSize = CGSizeMake(75, 75);
        noImageV.image = IMAGEWITHNAME(@"icon_tishi_yaoqingjilu.png");
        [noImageV align:ViewAlignmentTopCenter relativeToPoint:CGPointMake(SCREEN_WIDTH/2, 167*W_ABCH)];
        [_noRecordView addSubview:noImageV];
        UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, noImageV.viewBottomEdge+13*W_ABCH, SCREEN_WIDTH, 27*W_ABCH)];
        textLabel.font = fontForSize(12*W_ABCH);
        textLabel.numberOfLines = 0;
        textLabel.textColor = [UIColor colorWithHex:0x2f2f2f];
        textLabel.text = @"暂无邀请记录\n赶快去推举好友赚钱去~";
        [textLabel sizeToFit];
        textLabel.viewWidth = SCREEN_WIDTH;
        textLabel.textAlignment = NSTextAlignmentCenter;
        [_noRecordView addSubview:textLabel];
    }
    return _noRecordView;
}

-(UIView *)recordView{
    if (!_recordView) {
        _recordView = [[UIView alloc] initWithFrame:self.frame];
        _recordView.backgroundColor = [UIColor colorWithHex:0xfffbeb];
        _recordView.hidden = YES;
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 69*W_ABCH)];
        topView.backgroundColor = [UIColor colorWithHex:0xf8ebd1];
        [_recordView addSubview:topView];
        _personNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 16*W_ABCH, SCREEN_WIDTH/2, 15)];
        _personNum.textAlignment = NSTextAlignmentCenter;
        _personNum.textColor = COLOR_NAVIGATIONBAR_BARTINT;
        _personNum.font = fontForSize(15);
        [topView addSubview:_personNum];
        UILabel *personText = [[UILabel alloc] initWithFrame:CGRectMake(0, _personNum.viewBottomEdge+7*W_ABCH, SCREEN_WIDTH/2, 15)];
        personText.textColor = [UIColor colorWithHex:0x000000];
        personText.textAlignment = NSTextAlignmentCenter;
        personText.text = @"邀请人数";
        personText.font = fontForSize(15);
        [topView addSubview:personText];
        
        _priceNum = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 16*W_ABCH, SCREEN_WIDTH/2, 15)];
        _priceNum.textAlignment = NSTextAlignmentCenter;
        _priceNum.textColor = COLOR_NAVIGATIONBAR_BARTINT;
        _priceNum.font = fontForSize(15);
        [topView addSubview:_priceNum];
        
        UILabel *priceText = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, _priceNum.viewBottomEdge+7*W_ABCH, SCREEN_WIDTH/2, 15)];
        priceText.textColor = [UIColor colorWithHex:0x000000];
        priceText.textAlignment = NSTextAlignmentCenter;
        priceText.text = @"优惠券(元)";
        priceText.font = fontForSize(15);
        [topView addSubview:priceText];
        
        UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.viewBottomEdge+2*W_ABCH, SCREEN_WIDTH, 30*W_ABCH)];
        centerView.backgroundColor = [UIColor colorWithHex:0xf3e0b8];
        [_recordView addSubview:centerView];
        
        NSArray *textArray = @[@"账户名",@"邀请时间",@"邀请奖励"];
        for (int i = 0; i<3; i++) {
            UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 30*W_ABCH)];
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.text = textArray[i];
            textLabel.font = fontForSize(15);
            textLabel.textColor = [UIColor colorWithHex:0x000000];
            [centerView addSubview:textLabel];
        }
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, centerView.viewBottomEdge, SCREEN_WIDTH, SCREEN_HEIGHT - centerView.viewBottomEdge)];
        _tableView.backgroundColor = [UIColor colorWithHex:0xfffbeb];
        [_tableView registerClass:[InviRCTableViewCell class] forCellReuseIdentifier:@"recordCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreList)];
        _tableView.legendFooter.hidden = YES;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_recordView addSubview:_tableView];
        
    }
    return _recordView;
}

-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    if (_dataArray.count==20) {
        _tableView.legendFooter.hidden = NO;
    }else{
        [_tableView.legendFooter setState:MJRefreshFooterStateNoMoreData];
    }
    self.recordView.hidden = NO;
    InviRecodeModel *model = [_dataArray firstObject];
    _personNum.text = model.num;
    _priceNum.text = model.Tprice;
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
    [_tableView reloadData];
}


-(void)refresh{
    if ([self.delegate respondsToSelector:@selector(viewReFresh)]) {
        [self.delegate viewReFresh];
    }
}

-(void)loadMoreList{
    if ([self.delegate respondsToSelector:@selector(viewLoadMore)]) {
        [self.delegate viewLoadMore];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InviRCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recordCell" forIndexPath:indexPath];
    cell.model = _dataArray[indexPath.row];
    return  cell;
}





@end

