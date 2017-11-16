//
//  ShoppingCarView.m
//  BMW
//
//  Created by LiuP on 2016/10/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ShoppingCarView.h"
#import "ShoppingCarTableViewCell.h"
#import "ShoppingCarHeader.h"

#define TOPVIEW_H    38     // 顶部广告高度
#define BOTTOMVIEW_H 47     // 底部结算高度
#define HEADER_H     50     // 活动标签高度
#define CELL_H       100    // cell高度

static  NSString * cellID   = @"ShoppingCarTableViewCell";
static  NSString * headerID = @"ShoppingCarHeader";

@interface ShoppingCarView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIView * topView;     /**< 顶部广告位 */
@property (nonatomic, strong) UIImageView * topImage;  // 图片位置
@property (nonatomic, strong) UILabel * topContent;    // 内容

@property (nonatomic, strong) UIView * bottomView;  /**< 结算视图 */
@property (nonatomic, strong) UIButton * settleBtn; /**< 结算按钮 */
@property (nonatomic, strong) UIButton * allBtn;    /**< 全选按钮 */
@property (nonatomic, strong) UILabel * totalCash;  /**< 合计金额 */
@property (nonatomic, strong) UILabel * saveCash;   /**< 节省金额 */
@property (nonatomic, strong) UILabel * member; /**< 加入麦咖 */
@property (nonatomic, strong) UIButton * memberBtn;
@end

@implementation ShoppingCarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_BACKGRONDCOLOR;
        [self initEmptyCarView];
        
        [self initUserInterface];
        
        self.empty = YES;
    }
    return self;
}

#pragma mark -- UI
// 购物车为空
- (void)initEmptyCarView
{
    UIImageView *tishiImageV = [UIImageView new];
    tishiImageV.viewSize = CGSizeMake(119, 118);
    [tishiImageV align:ViewAlignmentTopCenter relativeToPoint:CGPointMake(self.viewWidth/2, 70*W_ABCH)];
    tishiImageV.image = IMAGEWITHNAME(@"icon_gouwuche_gwc.png");
    [self addSubview:tishiImageV];
    
    UILabel *nomessage = [[UILabel alloc] initWithFrame:CGRectMake(0, 212*W_ABCH, self.viewWidth, 12)];
    nomessage.text = @"这里没有商品";
    nomessage.textAlignment = NSTextAlignmentCenter;
    nomessage.font = fontForSize(12);
    nomessage.textColor = [UIColor colorWithHex:0x878787];
    [self addSubview:nomessage];
    
    UIButton *gotoShop = [[UIButton alloc] initWithFrame:CGRectMake(35*W_ABCW, nomessage.viewBottomEdge+24*W_ABCH, 110*W_ABCW, 26*W_ABCH)];
    [gotoShop setTitle:@"去逛逛" forState:UIControlStateNormal];
    [gotoShop setTitleColor:[UIColor colorWithHex:0x3d3d3d] forState:UIControlStateNormal];
    gotoShop.titleLabel.font = fontForSize(13);
    gotoShop.layer.borderWidth = 0.5;
    gotoShop.layer.cornerRadius = 3;
    gotoShop.layer.borderColor = [UIColor colorWithHex:0x696969].CGColor;
    [gotoShop addTarget:self action:@selector(gotoClassAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:gotoShop];

    UIButton *myCollectionB = [[UIButton alloc] initWithFrame:CGRectMake(gotoShop.viewRightEdge+30*W_ABCW, nomessage.viewBottomEdge+24*W_ABCH, 110*W_ABCW, 26*W_ABCH)];
    [myCollectionB setTitle:@"我的收藏" forState:UIControlStateNormal];
    [myCollectionB setTitleColor:[UIColor colorWithHex:0xfd5487] forState:UIControlStateNormal];
    myCollectionB.titleLabel.font = fontForSize(13);
    myCollectionB.layer.borderWidth = 0.5;
    myCollectionB.layer.cornerRadius = 3;
    myCollectionB.layer.borderColor = [UIColor colorWithHex:0xfd5487].CGColor;
    [myCollectionB addTarget:self action:@selector(gotoCollectionAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:myCollectionB];
}

- (void)initUserInterface
{
    [self initTopView];
    [self initBottomView];
    [self initTableView];
}

// 初始化顶部广告视图
- (void)initTopView
{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, TOPVIEW_H)];
    _topView.userInteractionEnabled = YES;
    _topView.backgroundColor = [UIColor colorWithHex:0xffe7b3];
    _topView.hidden = YES;
    [self addSubview:_topView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topItemAction:)];
    [_topView addGestureRecognizer:tap];

    UIImageView *arrow = [UIImageView new];
    arrow.viewSize = CGSizeMake(6, 10);
    [arrow align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(self.viewWidth - 15, TOPVIEW_H / 2)];
    arrow.image = IMAGEWITHNAME(@"icon_xiaojiantou_gwc.png");
    [_topView addSubview:arrow];
    
    _topImage = [UIImageView new];
    _topImage.viewSize = CGSizeMake(16, 18);
    _topImage.center = CGPointMake(15 + _topImage.viewWidth / 2, _topView.viewHeight / 2);
    _topImage.image = [UIImage imageNamed:@"icon_tixing_gwc.png"];
    [_topView addSubview:_topImage];
    
    _topContent = [[UILabel alloc] initWithFrame:CGRectMake(_topImage.viewRightEdge + 4, 0, self.viewWidth - 25 - _topImage.viewRightEdge, TOPVIEW_H)];
    _topContent.text = @"";
    _topContent.textColor = [UIColor colorWithHex:0x181818];
    _topContent.font = fontForSize(13);
    [_topView addSubview:_topContent];
}


// 初始化购物车列表
- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight - BOTTOMVIEW_H) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = COLOR_BACKGRONDCOLOR;
//    [_tableView registerClass:[ShoppingCarTableViewCell class] forCellReuseIdentifier:cellID];
    [_tableView registerClass:[ShoppingCarHeader class] forHeaderFooterViewReuseIdentifier:headerID];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.viewWidth, CGFLOAT_MIN)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshCarList)];
    
    [self addSubview:_tableView];
    
    // 分割线顶头
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

// 初始化底部结算
- (void)initBottomView
{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewBottomEdge - BOTTOMVIEW_H, self.viewWidth, BOTTOMVIEW_H)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomView];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, _bottomView.viewWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [_bottomView addSubview:line];
    
    _allBtn = [UIButton new];
    _allBtn.viewSize = CGSizeMake(60, 30);
    _allBtn.center = CGPointMake(15 + _allBtn.viewWidth / 2, _bottomView.viewHeight / 2);
    _allBtn.titleLabel.font = fontForSize(16);
    [_allBtn setTitleColor:[UIColor colorWithHex:0x181818] forState:UIControlStateNormal];
    [_allBtn setImage:IMAGEWITHNAME(@"icon_gouxuan_nor_gwc.png") forState:UIControlStateNormal];// 18 * 18
    [_allBtn setImage:IMAGEWITHNAME(@"icon_gouxuan_cli_gwc.png") forState:UIControlStateSelected];
    [_allBtn setTitle:@"全选" forState:UIControlStateNormal];
    [_allBtn addTarget:self action:@selector(selectAllGoodsAction:) forControlEvents:UIControlEventTouchUpInside];
    _allBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -7, 0, 0);
    _allBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -7);
    [_bottomView addSubview:_allBtn];
    
    _settleBtn = [UIButton new];
    _settleBtn.enabled = NO;
    _settleBtn.viewSize = CGSizeMake(89, BOTTOMVIEW_H);
    [_settleBtn align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(_bottomView.viewWidth, BOTTOMVIEW_H/2)];
    _settleBtn.titleLabel.font = fontForSize(14);
    [_settleBtn setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xcccccc] andSize:_settleBtn.viewSize] forState:UIControlStateDisabled];
    [_settleBtn setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xfd5487] andSize:_settleBtn.viewSize] forState:UIControlStateNormal];
    [_settleBtn setTitle:@"结算" forState:UIControlStateNormal];
    [_settleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_settleBtn addTarget:self action:@selector(settleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_settleBtn];
    
    _totalCash = [[UILabel alloc] initWithFrame:CGRectMake(_settleBtn.viewX - 80, 3, 80, 0)];
    _totalCash.font = fontBoldForSize(14);
    _totalCash.text = @"合计：￥0.00";
    _totalCash.textAlignment = NSTextAlignmentRight;
    [_totalCash sizeToFit];
    _totalCash.textColor = [UIColor colorWithHex:0xfd5487];
    [_bottomView addSubview:_totalCash];
    
    _saveCash = [[UILabel alloc]initWithFrame:CGRectMake(_totalCash.viewX, _totalCash.viewBottomEdge, _totalCash.viewWidth, 0)];
    _saveCash.font = fontForSize(10);
    _saveCash.text = @"(已省0.00元)";
//    [_saveCash sizeToFit];
//    _saveCash.textAlignment = NSTextAlignmentRight;
//    _saveCash.textColor = [UIColor colorWithHex:0x7f7f7f];
//    [_bottomView addSubview:_saveCash];
    
    _member = [UILabel new];
    _member.font = fontForSize(10);
    _member.textAlignment = NSTextAlignmentRight;
    _member.textColor = [UIColor colorWithHex:0xfd5487];
    _member.text = @"加入麦咖  立享优惠";
    [_member sizeToFit];
    [_bottomView addSubview:_member];
    
    _memberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_memberBtn addTarget:self action:@selector(memberAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_memberBtn];
}

#pragma mark -- private
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.topView.hidden) {
        _tableView.frame = CGRectMake(0, 0, self.viewWidth, self.viewHeight - BOTTOMVIEW_H);
    }else {
        _tableView.frame = CGRectMake(0, _topView.viewBottomEdge, self.viewWidth, self.viewHeight - BOTTOMVIEW_H - TOPVIEW_H);
    }
    
    if (_isMember) {
        _totalCash.center = CGPointMake(_settleBtn.viewX - 7 - _totalCash.viewWidth / 2, _bottomView.viewHeight/2);
        _saveCash.center = CGPointMake(_totalCash.viewRightEdge - _saveCash.viewWidth / 2, _totalCash.viewBottomEdge + _saveCash.viewHeight / 2);
    }else {
        _totalCash.center = CGPointMake(_settleBtn.viewX - 7 - _totalCash.viewWidth / 2, 3 + _totalCash.viewHeight / 2);
        _saveCash.center = CGPointMake(_totalCash.viewRightEdge - _saveCash.viewWidth / 2, _totalCash.viewBottomEdge + _saveCash.viewHeight / 2);
        _member.center = CGPointMake(_totalCash.viewRightEdge - _member.viewWidth / 2, _saveCash.viewBottomEdge + _member.viewHeight / 2);
        _memberBtn.frame = CGRectMake(_member.viewX, _member.viewY - 10, _member.viewWidth, _member.viewHeight + 10);
    }
}

#pragma mark -- setter
-(void)setTopcontentS:(NSString *)topcontentS{
    _topContent.text = topcontentS;
}

- (void)setEmpty:(BOOL)empty
{
    _empty = empty;
    self.tableView.hidden = _empty;
//    self.topView.hidden = _empty;
    self.bottomView.hidden = _empty;
}

- (void)setModels:(NSMutableArray *)models
{
    _models = models;
    
    [_tableView reloadData];
}

- (void)setIsEditing:(BOOL)isEditing
{
    _isEditing = isEditing;
    NSString * titleStr = self.settleBtn.titleLabel.text;
    if (_isEditing) {
        titleStr = [titleStr stringByReplacingOccurrencesOfString:@"结算" withString:@"删除"];
        self.totalCash.hidden = YES;
        self.saveCash.hidden = YES;
        self.member.hidden = YES;
        self.memberBtn.hidden = YES;
    }else {
        titleStr = [titleStr stringByReplacingOccurrencesOfString:@"删除" withString:@"结算"];
        self.totalCash.hidden = NO;
        self.saveCash.hidden = NO;
        if (!_isMember) {
            self.member.hidden = NO;
            self.memberBtn.hidden = NO;
        }
    }
    [self.settleBtn setTitle:titleStr forState:UIControlStateNormal];
}

- (void)setSettleBtnEnable:(BOOL)settleBtnEnable
{
    _settleBtnEnable = settleBtnEnable;
    self.settleBtn.enabled = settleBtnEnable;
}

- (void)setIsMember:(BOOL)isMember
{
    _isMember = isMember;
    if (_isMember) {
        self.member.hidden = YES;
        self.memberBtn.hidden = YES;
    }else {
        self.member.hidden = NO;
        self.memberBtn.hidden = NO;
    }
}

- (void)reloadData
{
    [_tableView reloadData];
}
#pragma mark -- actions
- (void)topItemAction:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(shoppingView:clickedTopItemWithTap:)]) {
        [self.delegate shoppingView:self clickedTopItemWithTap:tap];
    }
}

- (void)refreshCarList
{
    if ([self.delegate respondsToSelector:@selector(shoppingViewRefreshAction)]) {
        [self.delegate shoppingViewRefreshAction];
    }
}

- (void)endRefresh
{
    if (self.tableView.legendHeader.isRefreshing) {
        [self.tableView.legendHeader endRefreshing];
    }
}

- (void)selectAllGoodsAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if ([self.delegate respondsToSelector:@selector(shoppingViewAllGoodsSelected:)]) {
        [self.delegate shoppingViewAllGoodsSelected:btn.selected];
    }
}

- (void)settleBtnAction:(UIButton *)btn
{
    if (self.isEditing) {
        if ([self.delegate respondsToSelector:@selector(shoppingViewDeleteGoodsAction)]) {
            [self.delegate shoppingViewDeleteGoodsAction];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(shoppingView:settleActionWithBtn:)]) {
            [self.delegate shoppingView:self settleActionWithBtn:btn];
        }
    }
}

- (void)gotoClassAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(shoppingView:gotoClassWithBtn:)]) {
        [self.delegate shoppingView:self gotoClassWithBtn:btn];
    }
}

- (void)gotoCollectionAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(shoppingView:gotoCollectionWithBtn:)]) {
        [self.delegate shoppingView:self gotoCollectionWithBtn:btn];
    }
}

- (void)memberAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(shoppingView:memberActionWithBtn:)]) {
        [self.delegate shoppingView:self memberActionWithBtn:btn];
    }
}

#pragma mark -- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.models.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GoodsListModel * goodsListModel = self.models[section];
    return goodsListModel.goodsModels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_H;
}

// group 类型只设置一个高度会不精确
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    GoodsListModel * model = self.models[section];
    if (model.activity == ActivityNone) {
        return 10;
    }else {
        return HEADER_H;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingCarTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ShoppingCarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseID:cellID];
    }
    GoodsListModel * goodListModel = self.models[indexPath.section];
    cell.model = goodListModel.goodsModels[indexPath.row];
    WEAK_SELF;
    cell.selectBlock = ^(GoodsModel * model, BOOL isSelected){
        if ([weakSelf.delegate respondsToSelector:@selector(shoppingView:selectedGoodsWithModel:select:)]) {
            [weakSelf.delegate shoppingView:weakSelf selectedGoodsWithModel:model select:isSelected];
        }
    };
    
    cell.addOrReduceBlock = ^(GoodsModel * model, UIButton * btn, NSString * amount){
        if ([weakSelf.delegate respondsToSelector:@selector(shoppingView:addOrReduceActionWithModel:btn:amount:)]) {
            [weakSelf.delegate shoppingView:weakSelf addOrReduceActionWithModel:model btn:btn amount:amount];
        }
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GoodsListModel * model = self.models[section];
    bool activity;
    if (model.activity == ActivityNone) {
        activity = NO;
    }else {
        activity = YES;
    }
    ShoppingCarHeader * header = [[ShoppingCarHeader alloc] initWithReuseIdentifier:headerID model:model activity:activity];
    WEAK_SELF;
    header.activityBlock = ^(GoodsListModel * model){
        if ([weakSelf.delegate respondsToSelector:@selector(shoppingView:activityActionWithModel:)]) {
            [weakSelf.delegate shoppingView:weakSelf activityActionWithModel:model];
        }
    };
    return header;
}

// 分割线顶头
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsListModel * model = self.models[indexPath.section];
    GoodsModel * goodsModel = model.goodsModels[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(shoppingView:didSelectGoodsWithModel:)]) {
        [self.delegate shoppingView:self didSelectGoodsWithModel:goodsModel];
    }

}

#pragma mark -- others
- (void)showTopView
{
    self.topView.hidden = NO;
    [self layoutSubviews];
}

- (void)hideTopView
{
    self.topView.hidden = YES;
    [self layoutSubviews];
}


/**
 更新底部结算视图

 @param totalCash
 @param saveCash
 @param amount
 @param all
 */
- (void)updateBottomViewWithModel:(GoodsListModel *)model amount:(NSInteger)amount all:(BOOL)all
{
    NSString * totalStr = [@"合计：￥" stringByAppendingString:[NSString stringWithFormat:@"%@", model.totalCash]];
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    [attributeStr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHex:0x3d3d3d]
                         range:NSMakeRange(0, totalStr.length)];
    [attributeStr addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHex:0xfd5487]
                         range:NSMakeRange(3, totalStr.length - 3)];
    NSString * memberStr = [NSString stringWithFormat:@"加入麦咖 立享优惠"];//再省%@元", model.beVipSave
    NSMutableAttributedString * memberAttribute = [[NSMutableAttributedString alloc] initWithString:memberStr];
    [memberAttribute addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithHex:0xfd5487]
                            range:NSMakeRange(0, memberStr.length)];
    [memberAttribute addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithHex:0x3d3d3d]
                            range:NSMakeRange(4, memberStr.length - 4)];
    
    self.totalCash.attributedText = attributeStr;
    [self.totalCash sizeToFit];
    self.saveCash.text = [NSString stringWithFormat:@"(已省%@元)", model.saveCash];
    [self.saveCash sizeToFit];
    self.member.attributedText = memberAttribute;
    [self.member sizeToFit];
    
    self.allBtn.selected = all;
    NSString * settleStr,  * originStr;
    if (_isEditing) {
        originStr = @"删除";
    }else {
        originStr = @"结算";
    }
    if (amount == 0) {
        settleStr = originStr;
    }else {
        settleStr = [originStr stringByAppendingString:[NSString stringWithFormat:@"(%ld)", amount]];
    }
    [self.settleBtn setTitle:settleStr forState:UIControlStateNormal];
    
    [self layoutSubviews];
    [self.tableView reloadData];
}
@end
