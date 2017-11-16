//
//  AccountView.m
//  BMW
//
//  Created by LiuP on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "AccountView.h"
#import "LPTableViewManager.h"

static NSString * freezeMessage = @"为了避免不法分子套取账户资金，用户授权使用账户资金支付订单中断后，支付金额将被冻结24h。若要立即取消冻结资金，请您到待付款取消相应订单。";

@interface MenuModel : NSObject
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * imageName;
@end

@implementation MenuModel

- (instancetype)initWithTitle:(NSString *)title iamge:(NSString *)image
{
    self = [super init];
    if (self) {
        self.title = title;
        self.imageName = image;
    }
    return self;
}

@end


@interface AccountView ()<UITableViewDelegate>
@property (nonatomic, assign) AccountType account;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIView * topView;    /**< 账户资金 */
@property (nonatomic, strong) UILabel * title;     /**< 账户余额 */
@property (nonatomic, strong) UILabel * cash;      /**< 余额/M币 */
@property (nonatomic, strong) UILabel * freeze;    /**< 冻结的M币 */

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, retain) LPTableViewManager * manager;
@property (nonatomic, retain) NSMutableArray * menuModels;
@end

@implementation AccountView

- (instancetype)initWithFrame:(CGRect)frame account:(AccountType)account
{
    self = [super initWithFrame:frame];
    if (self) {
        self.account = account;
        
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = COLOR_BACKGRONDCOLOR;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 145 * W_ABCW)];
    _topView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_topView];
    
    _cash = [UILabel new];
    _cash.viewSize = CGSizeMake(200, 0);
    _cash.textColor = COLOR_NAVIGATIONBAR_BARTINT;
    _cash.font = [UIFont systemFontOfSize:40 * W_ABCW];
    _cash.text = @"0.00";
    [_cash sizeToFit];
    [_topView addSubview:_cash];
    
    NSArray * images = @[@"icon_chongzhi_ye", @"icon_chongzhijilu_ye", @"icon_wodeshoucang_wd1"];
    NSArray * titles;
    if (self.account == AccountCash) {
        titles = @[@"充值", @"充值记录", @"资金记录"];
        //红色圆圈
        UIView * redRound = [UIView new];
        redRound.viewSize = CGSizeMake(8 * W_ABCW, 8 * W_ABCW);
        [redRound align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(20 * W_ABCW, 22 * W_ABCW)];
        redRound.layer.cornerRadius = redRound.viewHeight / 2;
        redRound.layer.masksToBounds = YES;
        redRound.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
        [_topView addSubview:redRound];
        //标题
        _title = [UILabel new];
        _title.viewSize = CGSizeMake(200, 10);
        _title.textColor = [UIColor colorWithHex:0x181818];
        _title.font = [UIFont systemFontOfSize:13];
        _title.text = @"账户余额（元）";
        [_title sizeToFit];
        [_title align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(redRound.viewRightEdge + 10 * W_ABCW, 20 * W_ABCW)];
        [_topView addSubview:_title];
        
        _cash.frame = CGRectMake(redRound.viewX, _title.viewBottomEdge + 37 * W_ABCW, _topView.viewWidth - redRound.viewX * 2, _cash.viewHeight);
    }else {
        titles = @[@"M币充值", @"充值记录", @"资金记录"];
        _cash.textAlignment = NSTextAlignmentCenter;
        _cash.frame = CGRectMake(20 * W_ABCW, (_topView.viewHeight - _cash.viewHeight) / 2, _topView.viewWidth - 40 * W_ABCW, _cash.viewHeight);
        
        // 支付冻结
        _freeze = [UILabel new];
        _freeze.viewSize = CGSizeMake(100, 0);
        _freeze.textAlignment = NSTextAlignmentCenter;
        _freeze.font = fontForSize(13 * W_ABCW);
        _freeze.textColor = [UIColor colorWithHex:0x181818];
        _freeze.text = @"支付冻结：0.00";
        [_freeze sizeToFit];
        _freeze.frame = CGRectMake(_cash.viewX, _cash.viewBottomEdge + 20 * W_ABCW, _cash.viewWidth, _freeze.viewHeight);
        [_topView addSubview:_freeze];
    }
    
    _menuModels = [NSMutableArray array];
    for (int i = 0; i < images.count; i ++) {
        NSString * title = titles[i];
        NSString * image = images[i];
        MenuModel * model = [[MenuModel alloc] initWithTitle:title iamge:image];
        [_menuModels addObject:model];
    }
    
    [self initMenuView];
}

- (void)initMenuView
{
    NSString * cellID = NSStringFromClass(UITableViewCell.class);
    _manager = [[LPTableViewManager alloc] initWithIdentifier:cellID cellBack:^(id cell, id model) {
        UITableViewCell * item = (UITableViewCell *)cell;
        MenuModel * itemM = model;
        item.textLabel.font = [UIFont systemFontOfSize:13];
        item.textLabel.textColor = [UIColor colorWithHex:0x181818];
        item.textLabel.text = itemM.title;
        item.imageView.image = IMAGEWITHNAME(itemM.imageName);
    }];
    _manager.type = CellTypeDefault;
    _manager.models = self.menuModels;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _topView.viewBottomEdge + 10 * W_ABCW, self.viewWidth, 45 * W_ABCW * 3)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.scrollEnabled = NO;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = _manager;
    _tableView.delegate = self;
    _tableView.rowHeight = 45 * W_ABCW;
    [_scrollView addSubview:_tableView];

    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    _scrollView.contentSize = CGSizeMake(self.viewWidth, _tableView.viewBottomEdge + 10);
    
    if (self.account == AccountM) {
        UIView * noticeView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.viewBottomEdge + 10 * W_ABCW, self.viewWidth, 108 * W_ABCW)];
        noticeView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:noticeView];
        
        UILabel * noticeTitle = [[UILabel alloc] initWithFrame:CGRectMake(15 * W_ABCW, 15 * W_ABCW, 100, 0)];
        noticeTitle.font = fontForSize(14 * W_ABCW);
        noticeTitle.textColor = [UIColor colorWithHex:0x181818];
        noticeTitle.text = @"支付金额冻结说明";
        [noticeTitle sizeToFit];
        [noticeView addSubview:noticeTitle];
        
        NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = 6;
        NSAttributedString * atttibute = [[NSAttributedString alloc] initWithString:freezeMessage attributes:@{NSParagraphStyleAttributeName:style}];
        UILabel * message = [[UILabel alloc] initWithFrame:CGRectMake(noticeTitle.viewX, noticeTitle.viewBottomEdge + 13 * W_ABCW, noticeView.viewWidth - noticeTitle.viewX * 2, 0)];
        message.font = fontForSize(11 * W_ABCW);
        message.numberOfLines = 0;
        message.textColor = [UIColor colorWithHex:0x7f7f7f];
        message.attributedText = atttibute;
        [message sizeToFit];
        [noticeView addSubview:message];
        
        noticeView.viewSize = CGSizeMake(noticeView.viewWidth, message.viewBottomEdge + 12 * W_ABCW);
        _scrollView.contentSize = CGSizeMake(self.viewWidth, noticeView.viewBottomEdge + 10);
    }
}

#pragma mark -- setter
- (void)setModel:(AccountModel *)model
{
    _model = model;
    if (self.account == AccountCash) {
        self.cash.text = @"0.00";
    }else {
        self.cash.text = model.mCash;
        self.freeze.text = [@"支付冻结：" stringByAppendingString:model.freezeM];
    }
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ItemType item = ItemNone;
    if (self.account == AccountCash) {
        switch (indexPath.row) {
            case 0: item = ItemCashPay;
                break;
            case 1: item = ItemCashRecord;
                break;
            case 2: item = ItemCapitalRecord;
                break;
            default:
                break;
        }
    }else {
        switch (indexPath.row) {
            case 0: item = ItemMPay;
                break;
            case 1: item = ItemMRecord;
                break;
            case 2: item = ItemCapitalRecord;
                break;
            default:
                break;
        }
    }
    if ([self.delegate respondsToSelector:@selector(accountView:didSelectedMenuWithItem:)]) {
        [self.delegate accountView:self didSelectedMenuWithItem:item];
    }
}
@end
