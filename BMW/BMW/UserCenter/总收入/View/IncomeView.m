//
//  IncomeView.m
//  BMW
//
//  Created by LiuP on 2016/12/20.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "IncomeView.h"
#import "PercentView.h"

NSString * beService(NSInteger num) {
    return [NSString stringWithFormat:@"收益提醒：\n1）还差%ld人邀请即可成为服务商，将新增创收权益：直属收益提成\n2）订单相关收益需要在用户确认收货后7天到账", num];
}

NSString * bePartner(NSInteger num) {
    return [NSString stringWithFormat:@"收益提醒：\n1)还差%ld人邀请即可成为合伙人，成为合伙人将自动脱离现有团队，成立新团队，且新增三项创收权益\n2）订单相关收益需要在用户确认收货后7天到账", num];
}

NSString * partnerMsg() {
    return @"收益提醒：\n订单相关收益需要在用户确认收货后7天到账";
}


@interface IncomeView ()
@property (nonatomic, assign) MemberType member;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIView * percentView;             /**< 收入占比 */
@property (nonatomic, strong) PercentView * percent;            /**< 圆形百分比视图 */
@property (nonatomic, copy) NSMutableArray * allIncome;         /**< 所有收入来源 */
@property (nonatomic, copy) NSMutableArray * allIncomeColors;   /**< 所有收入对应的颜色 */

@property (nonatomic, copy) NSMutableArray * allPercentItems;   /**< 所有收入百分比的label */
@property (nonatomic, copy) NSMutableArray * allItems;          /**< 所有收入的金额label */

@property (nonatomic, strong) UIView * redView;                 /**< 红色总收入视图 */
@property (nonatomic, strong) NSArray * totalItems;             /**< 合计项目 */
@property (nonatomic, copy) NSMutableArray * redItems;          /**< 统计部分所有label */
@property (nonatomic, strong) UILabel * remind;                 /**< 收益提醒 */
@end

@implementation IncomeView

- (instancetype)initWithFrame:(CGRect)frame member:(MemberType)member
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.member = member;
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];

    [self initPercentView];
    [self initAllIncomeView];
}

// 上部百分比视图
- (void)initPercentView
{
    _percentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, 231 * W_ABCW)];
    _percentView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_percentView];
    
    /**< 用户头衔图片 */  //280 * 27
    CGFloat width = 280 * W_ABCW;
    CGFloat height = 27 * W_ABCW;
    UIImageView * titleImage = [UIImageView new];
    titleImage.frame = CGRectMake((self.viewWidth - width) / 2, 10 * W_ABCW, width, height);
    [_percentView addSubview:titleImage];

    NSMutableArray * colors = [NSMutableArray arrayWithArray:@[COLOR_NAVIGATIONBAR_BARTINT,
                                                               [UIColor colorWithHex:0xa3a3a3],
                                                               [UIColor colorWithHex:0xa3a3a3]]];
    if (self.member == MemberMK) {
        titleImage.image = IMAGEWITHNAME(@"jpg_maika_wdsr.png");
        [self.allIncome removeObjectsInRange:NSMakeRange(2, 4)];
        [self.allIncomeColors removeObjectsInRange:NSMakeRange(2, 4)];
    }else if (self.member == MemberService) {
        titleImage.image = IMAGEWITHNAME(@"jpg_fuwushang_wdsr.png");
        [colors exchangeObjectAtIndex:0 withObjectAtIndex:1];
        [self.allIncome removeObjectsInRange:NSMakeRange(3, 3)];
        [self.allIncomeColors removeObjectsInRange:NSMakeRange(3, 3)];
    }else if (self.member == MemberPartner) {
        titleImage.image = IMAGEWITHNAME(@"jpg_hehuoren_wdsr.png");
        [colors exchangeObjectAtIndex:0 withObjectAtIndex:2];
    }else {
        NSLog(@"普通用户");
    }
    NSArray * members = @[@"麦咖", @"服务商", @"合伙人"];
    CGFloat viewBottomEdge = 0;
    for (int i = 0; i < members.count; i ++) {
        UILabel * label = [UILabel new];
        label.viewSize = CGSizeMake(30, 0);
        label.font = fontForSize(13 * W_ABCW);
        label.textColor = colors[i];
        label.text = members[i];
        [label sizeToFit];
        [_percentView addSubview:label];
        switch (i) {
            case 0: label.center = CGPointMake(titleImage.viewX + label.viewWidth / 2, titleImage.viewBottomEdge + 2 * W_ABCW + label.viewHeight / 2);
                break;
            case 1: label.center = CGPointMake(self.center.x, titleImage.viewBottomEdge + 2 * W_ABCW + label.viewHeight / 2);
                break;
            case 2: label.center = CGPointMake(titleImage.viewRightEdge - label.viewWidth / 2, titleImage.viewBottomEdge + 2 * W_ABCW + label.viewHeight / 2);
                break;
            default:
                break;
        }
        viewBottomEdge = label.viewBottomEdge;
    }
    
    // 圆圈百分比
    CGFloat cycleW = 120 * W_ABCW;
    _percent = [[PercentView alloc] initWithFrame:CGRectMake((self.viewWidth - cycleW) / 2, viewBottomEdge + 25 * W_ABCW, cycleW, cycleW)
                                            title:@"收入占比"];
    _percent.colors = self.allIncomeColors;
    [_percentView addSubview:_percent];
    
    _allPercentItems = [NSMutableArray array];
    CGFloat itemWidth = self.viewWidth / 3;
    CGFloat itemHeight = 10 * W_ABCW;
    for (int i = 0; i < self.allIncome.count; i ++) {
        NSInteger row = i / 3; // 行
        NSInteger colum = i % 3; // 列
        CGFloat originY = _percent.viewBottomEdge + 12 * W_ABCW + (10 * W_ABCW + 12 * W_ABCW) * row;
        UIView * itemView = [[UIView alloc] initWithFrame:CGRectMake(itemWidth * colum, originY, itemWidth, itemHeight)];
        [_percentView addSubview:itemView];
        
        UIView * cube = [UIView new];
        cube.viewSize = CGSizeMake(itemHeight, itemHeight);
        cube.backgroundColor = self.allIncomeColors[i];
        [itemView addSubview:cube];
        
        UILabel * item = [UILabel new];
        item.viewSize = CGSizeMake(50, 0);
        item.font = fontForSize(9);
        item.text = @"0.00%  ";
        [item sizeToFit];
        item.viewSize = CGSizeMake(item.viewWidth, itemHeight);
        [itemView addSubview:item];
        
        // 计算位置
        if (self.allIncome.count <= 2) {  // 只有两个
            CGFloat originX = (self.viewWidth - itemWidth * 2) / 2;
            itemView.frame = CGRectMake(originX + itemWidth * colum, itemView.viewY, itemView.viewWidth, itemView.viewHeight);
        }
        cube.center = CGPointMake(itemWidth / 2 - itemHeight, cube.center.y);
        CGFloat itemX = cube.viewRightEdge + 5;
        item.frame = CGRectMake(itemX, item.viewY, itemWidth - itemX, item.viewHeight);
        
        [_allPercentItems addObject:item];
        viewBottomEdge = itemView.viewBottomEdge;
    }
    
    _percentView.viewSize = CGSizeMake(self.viewWidth, viewBottomEdge + 5 * W_ABCW);
}

// 所有收入视图
- (void)initAllIncomeView
{
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, self.percentView.viewBottomEdge, self.viewWidth, 5 * W_ABCW)];
    line.backgroundColor = COLOR_BACKGRONDCOLOR;;
    [_scrollView addSubview:line];

    UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, line.viewBottomEdge, self.viewWidth, 0)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:backgroundView];
    
    _allItems = [NSMutableArray array];
    CGFloat itemH = 35 * W_ABCW;
    CGFloat cubeH = 10 * W_ABCW;
    CGFloat viewBottomEdge = 0;
    for (int i = 0; i < self.allIncome.count; i ++) {
        CGFloat origin_y = (itemH - cubeH) / 2 + (itemH + 0.5) * i;
        UIView * cube = [UIView new];
        cube.frame = CGRectMake(15 * W_ABCW, origin_y, cubeH, cubeH);
        cube.backgroundColor = self.allIncomeColors[i];
        [backgroundView addSubview:cube];

        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(cube.viewRightEdge + 5 * W_ABCW, (itemH + 0.5) * i, self.viewWidth - cube.viewRightEdge - 20 * W_ABCW, itemH)];
        label.font = fontForSize(13 * W_ABCW);
        label.text = [self.allIncome[i] stringByAppendingString:@"：0.00元"];
        [backgroundView addSubview:label];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, label.viewBottomEdge, self.viewWidth, 0.5)];
        line.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
        [backgroundView addSubview:line];
        
        [_allItems addObject:label];
        viewBottomEdge = line.viewBottomEdge;
    }
    
    // 红色视图、统计
    _redView = [[UIView alloc] initWithFrame:CGRectMake(0, viewBottomEdge + 31 * W_ABCW, self.viewWidth, 55 * W_ABCW)];
    _redView.backgroundColor = COLOR_NAVIGATIONBAR_BARTINT;
    [backgroundView addSubview:_redView];
    
    CGFloat height = _redView.viewHeight / 2;
    CGFloat width = self.viewWidth / 2 - 40;  // 左边距30
    _redItems = [NSMutableArray array];
    for (int i = 0 ; i < self.totalItems.count; i ++) {
        NSInteger row = i / 2;
        NSInteger colum = i % 2;
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(40 + (width + 40) * colum, height * row, width, height)];
        label.textColor = [UIColor colorWithHex:0xfdfdfd];
        label.text = [self.totalItems[i] stringByAppendingString:@"0.00"];
        label.font = fontForSize(11 * W_ABCW);
        [_redView addSubview:label];
        [_redItems addObject:label];
    }
    
    _remind = [[UILabel alloc] initWithFrame:CGRectMake(15 * W_ABCW, _redView.viewBottomEdge + 10 * W_ABCW, self.viewWidth - 30 * W_ABCW, 0)];
    _remind.numberOfLines = 0;
    _remind.font = fontForSize(10 * W_ABCW);
    _remind.textColor = [UIColor colorWithHex:0x585757];
    [backgroundView addSubview:_remind];
    NSString * message;
    if (self.member == MemberMK) {
        message = beService(0);
    }else if (self.member == MemberService){
        message = bePartner(0);
    }else if (self.member == MemberPartner){
        message = partnerMsg();
    }else {
        message = @"";
    }
    _remind.text = message;
    [_remind sizeToFit];
    
    backgroundView.viewSize = CGSizeMake(backgroundView.viewWidth, _remind.viewBottomEdge + 10 * W_ABCW);
    self.scrollView.contentSize = CGSizeMake(self.viewWidth, backgroundView.viewBottomEdge);
}

#pragma mark -- getter
- (NSMutableArray *)allIncome
{
    if (!_allIncome) {
        NSArray * temp = @[@"邀请奖励", @"麦咖佣金返现", @"直属收益奖励", @"团队销售奖励", @"团队拓展奖励", @"新团队孵化奖励"];
        _allIncome = [NSMutableArray arrayWithArray:temp];
    }
    return _allIncome;
}

- (NSMutableArray *)allIncomeColors
{
    if (!_allIncomeColors) {
        NSArray * temp = @[[UIColor colorWithHex:0xff6e18],
                           [UIColor colorWithHex:0xf8bf00],
                           [UIColor colorWithHex:0xb4d700],
                           [UIColor colorWithHex:0x48ae33],
                           [UIColor colorWithHex:0x7d57fb],
                           [UIColor colorWithHex:0xfd38af]];
        _allIncomeColors = [NSMutableArray arrayWithArray:temp];
    }
    return _allIncomeColors;
}

- (NSArray *)totalItems
{
    if (!_totalItems) {
        _totalItems = @[@"我的收入：¥", @"结算中：¥", @"提现审核：¥", @"已提现：¥"];
    }
    return _totalItems;
}

#pragma mark -- 更新视图 setter
- (void)setModel:(IncomeModel *)model
{
    _model = model;
    if (model.totalIncome > 0) {
        self.percent.dataSource = model.percents;
    }
    for (int i = 0; i < model.allIncomes.count; i ++) {
        NSString * itemStr = self.allIncome[i];
        NSString * cash = model.allIncomes[i];
        NSString * percent = model.percents[i]; // 小数
        UILabel * item = self.allItems[i];
        UILabel * percentItem = self.allPercentItems[i];
        if (i == 0) {
            item.text = [itemStr stringByAppendingFormat:@"（%@/人）：%@元", model.award, cash];
        }else {
            item.text = [itemStr stringByAppendingFormat:@"：%@元", cash];
        }
        percentItem.text = [[NSString stringWithFormat:@"%.2f", percent.floatValue * 100] stringByAppendingString:@"%"];
    }
    
    for (int i = 0; i < model.totalIncomes.count; i ++) {
        NSString * totalItem = self.totalItems[i];
        NSString * cash = model.totalIncomes[i];
        UILabel * item = self.redItems[i];
        item.text = [totalItem stringByAppendingString:cash];
    }
    NSString * message;
    if (self.member == MemberMK) {
        message = beService(model.needNum.integerValue);
    }else if (self.member == MemberService){
        message = bePartner(model.needNum.integerValue);
    }else if (self.member == MemberPartner){
        message = partnerMsg();
    }else {
        message = @"";
    }
    _remind.text = message;
    [_remind sizeToFit];
}

@end
