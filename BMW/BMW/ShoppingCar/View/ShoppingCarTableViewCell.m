//
//  ShoppingCarTableViewCell.m
//  BMW
//
//  Created by rr on 16/3/2.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ShoppingCarTableViewCell.h"

@interface ShoppingCarTableViewCell ()
{
    NSInteger _currentNum;
    UIButton *_bigChoose;
}
@property(nonatomic, strong)UILabel *goodsPrice;
@property(nonatomic, strong)UILabel *goods_VipPrice;

//不是编辑状态
@property(nonatomic, strong)UILabel *goodsLabel;
@property(nonatomic, strong)UILabel *goodsS;
@property(nonatomic, strong)UILabel *goodsNum;

//编辑状态
@property(nonatomic, strong)UIButton *reduceButton;
@property(nonatomic, strong)UIButton *addButton;
@property(nonatomic, strong)UILabel *changeNum;
@property(nonatomic, strong)UIImageView *chooseSome;
@property(nonatomic, strong)UIView *placeView;


// 新代码 **************************************
@property (nonatomic, assign) BOOL tempMark;                /**< 临时标记，区分新旧代码。。其因为不止购物车在使用旧代码 */
@property (nonatomic, strong) UIButton * selectBtn;         /**< 选中按钮 */
@property (nonatomic, strong) UIImageView * goodsImage;     /**< 商品图片 */
@property (nonatomic, strong) UIImageView * activityImage;  /**< 商品标签 */
@property (nonatomic, strong) UILabel * goodsName;
@property (nonatomic, strong) UILabel * normalPrice;        /**< 商品普通价格 */
@property (nonatomic, strong) UILabel * vipPrice;           /**< 麦咖价格 */
@property (nonatomic, strong) UILabel * standard;           /**< 规格 */
//@property (nonatomic, strong) UIView * standardBackView;    /**< 可选择规格底部视图 */
//@property (nonatomic, strong) UIImageView * downArrow;      /**< 下拉箭头 */
@property (nonatomic, strong) UILabel * origin;             /**< 来源 */
@property (nonatomic, strong) UIButton * addBtn;            /**< 加按钮 */
@property (nonatomic, strong) UIButton * reduceBtn;         /**< 减按钮 */
@property (nonatomic, strong) UILabel * amount;             /**< 商品数量 */
@end
@implementation ShoppingCarTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseID:(NSString *)reuseID
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseID]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tempMark = YES;
        [self initUserInterface];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tempMark = NO;
        [self loadViews];
    }
    return self;
}


#pragma mark -- UI
- (void)initUserInterface
{
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.viewSize = CGSizeMake(48, 48);
    [_selectBtn setImage:[UIImage imageNamed:@"icon_gouxuan_nor_gwc.png"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"icon_gouxuan_cli_gwc.png"] forState:UIControlStateSelected];
    [_selectBtn setImage:[UIImage imageNamed:@"icon_bukegouxuan_gwc.png"] forState:UIControlStateDisabled];
    [_selectBtn addTarget:self action:@selector(selectedBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_selectBtn];
    
    _goodsImage = [UIImageView new];
    _goodsImage.viewSize = CGSizeMake(79, 79);
    _goodsImage.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_goodsImage];
    
    _activityImage = [UIImageView new];
    _activityImage.viewSize = _goodsImage.viewSize;
    [self.contentView addSubview:_activityImage];
    
    _goodsName = [UILabel new];
    _goodsName.numberOfLines = 2;
    _goodsName.font = fontForSize(12);
    _goodsName.textColor = [UIColor colorWithHex:0x3d3d3d];
    [self.contentView addSubview:_goodsName];
    
    _standard = [UILabel new];
    _standard.font = fontForSize(9);
    _standard.textColor = [UIColor colorWithHex:0x7f7f7f];
    [self.contentView addSubview:_standard];
    
//    _standardBackView = [UIView new];
//    _standardBackView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
//    [self.contentView addSubview:_standardBackView];
//    
//    _downArrow = [UIImageView new];
//    _chooseSome.viewSize = CGSizeMake(10, 6);
////    [_downArrow align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-24, _goodsImage.viewY+_goodsImage.viewHeight/2)];
//    _downArrow.image = IMAGEWITHNAME(@"icon_xialajiantou_js.png");
//    [_standardBackView addSubview:_downArrow];
    
    _origin = [UILabel new];
    _origin.font = fontForSize(9);
    _origin.textColor = _standard.textColor;
    [self.contentView addSubview:_origin];
    
    _normalPrice = [UILabel new];
    _normalPrice.font = fontForSize(12);
    _normalPrice.textColor = [UIColor colorWithHex:0xfd5487];
    [self.contentView addSubview:_normalPrice];
    
    _vipPrice = [UILabel new];
    _vipPrice.font = fontForSize(9);
    _vipPrice.textColor = _standard.textColor;
    [self.contentView addSubview:_vipPrice];
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.viewSize = CGSizeMake(34, 31);
    [_addBtn setImage:[UIImage imageNamed:@"icon_zengjia_jrgwc_nor.png"] forState:UIControlStateNormal];
    [_addBtn setImage:[UIImage imageNamed:@"icon_zengjia_jrgwc_enable.png"] forState:UIControlStateDisabled];
    [_addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_addBtn];

    _reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _reduceBtn.viewSize = CGSizeMake(34, 31);
    [_reduceBtn setImage:[UIImage imageNamed:@"icon_jianshao_jrgwc_nor.png"] forState:UIControlStateNormal];
    [_reduceBtn setImage:[UIImage imageNamed:@"icon_jianshao_jrgwc_enable.png"] forState:UIControlStateDisabled];
    [_reduceBtn addTarget:self action:@selector(reduceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_reduceBtn];
    
    _amount = [UILabel new];
    _amount.viewSize = CGSizeMake(32, 25);
    _amount.font = fontForSize(13);
    _amount.backgroundColor = [UIColor colorWithHex:0xf0f0f0];
    _amount.textColor = [UIColor colorWithHex:0x181818];
    _amount.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_amount];
}

#pragma mark -- other
- (void)updateAmount:(NSString *)amount
{
    self.amount.text = amount;
}

#pragma mark -- actions
- (void)selectedBtnAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.selectBlock(self.model, btn.selected);
}

- (void)addBtnAction:(UIButton *)btn
{
    NSString * amount = [NSString stringWithFormat:@"%ld", self.amount.text.integerValue + 1];
    self.addOrReduceBlock(self.model, btn, amount);
}

- (void)reduceBtnAction:(UIButton *)btn
{
    // 商品数量为1 屏蔽减按钮
    if (self.amount.text.integerValue == 1) {
        return;
    }
    NSString * amount = [NSString stringWithFormat:@"%ld", self.amount.text.integerValue - 1];
    self.addOrReduceBlock(self.model, btn, amount);
}

#pragma mark -- setter
- (void)setModel:(GoodsModel *)model
{
    _model = model;
    [self layoutSubviews];
    UIImageView * tempImage = [UIImageView new];
    tempImage.viewSize = CGSizeMake(33, 26);
    tempImage.image = IMAGEWITHNAME(@"logo_bangmaiwang_splb.png");
    tempImage.center = CGPointMake(self.goodsImage.viewWidth / 2, self.goodsImage.viewHeight / 2);
    [self.goodsImage addSubview:tempImage];
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:_model.goodsImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [tempImage removeFromSuperview];
    }];
    self.goodsName.viewSize     = CGSizeMake(SCREEN_WIDTH - _goodsImage.viewRightEdge - 12 - 10, 0);
    self.goodsName.text         = _model.goodsName;
    self.standard.text          = _model.standard;
    self.origin.text            = _model.origin;
    self.vipPrice.text          = [@"麦咖专享返现：￥" stringByAppendingString:[NSString stringWithFormat:@"%.2f", _model.vipPrice.floatValue]];
    self.amount.text            = _model.goodsNum;
    [self.goodsName     sizeToFit];
    [self.standard      sizeToFit];
    [self.origin        sizeToFit];
    [self.normalPrice   sizeToFit];
    [self.vipPrice      sizeToFit];
    
    self.selectBtn.selected = _model.selected;
    
    if (_model.goodsNum.integerValue >= 2) {
        self.editBtnEnable = YES;
        self.reduceBtn.userInteractionEnabled = YES;
        self.addBtn.userInteractionEnabled = YES;
    }
    // 是否是赠品
    if (_model.isGift) { 
        self.selectBtn.enabled = NO; 
        self.editBtnEnable = NO;
        self.normalPrice.text       = [@"￥ " stringByAppendingString:_model.normalPrice];
    }else {
        self.selectBtn.enabled = YES;
        self.editBtnEnable = YES;
        self.normalPrice.text       = [@"￥ " stringByAppendingString:[NSString stringWithFormat:@"%.2f", _model.normalPrice.floatValue]];
    }
}

// 加减按钮 // 切换样式
- (void)setEditBtnEnable:(BOOL)editBtnEnable
{
    _editBtnEnable = editBtnEnable;
    self.addBtn.enabled = editBtnEnable;
    self.reduceBtn.enabled = editBtnEnable;
}

#pragma mark -- private
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.tempMark) {
        
        _selectBtn.center       = CGPointMake(_selectBtn.viewWidth / 2, self.contentView.viewHeight / 2);
        _goodsImage.center      = CGPointMake(_selectBtn.viewRightEdge + 6 + _goodsImage.viewWidth / 2, _selectBtn.center.y);
        _activityImage.center   = _goodsImage.center;
        _goodsName.frame        = CGRectMake(_goodsImage.viewRightEdge + 12, 10, _goodsName.viewWidth, _goodsName.viewHeight);
        
        _standard.frame         = CGRectMake(_goodsName.viewX, 41, _standard.viewWidth, _standard.viewHeight);
        _origin.frame           = CGRectMake(_standard.viewX, _standard.viewBottomEdge + 2, _origin.viewWidth, _origin.viewHeight);
        _addBtn.center          = CGPointMake(self.contentView.viewWidth - 7 - _addBtn.viewWidth / 2, self.contentView.viewBottomEdge - 7 - _addBtn.viewHeight / 2);
        _amount.center          = CGPointMake(_addBtn.viewX - 1 - _amount.viewWidth / 2, _addBtn.center.y);
        _reduceBtn.center       = CGPointMake(_amount.viewX - 1 - _reduceBtn.viewWidth / 2, _addBtn.center.y);
        _normalPrice.frame      = CGRectMake(_origin.viewX, _origin.viewBottomEdge + 1, _reduceBtn.viewX - _origin.viewX, 13);
        _vipPrice.frame         = CGRectMake(_normalPrice.viewX, _normalPrice.viewBottomEdge + 1, _normalPrice.viewWidth, _origin.viewHeight);
    }
}


/* *************************************************************************************************** */
#pragma mark -- 旧代码
-(void)loadViews{
    self.viewHeight = 100;
    _chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(15, self.viewHeight/2-9, 18, 18)];
    [_chooseButton setBackgroundImage:IMAGEWITHNAME(@"icon_gouxuan_nor_gwc.png") forState:UIControlStateNormal];
    [_chooseButton setBackgroundImage:IMAGEWITHNAME(@"icon_gouxuan_cli_gwc.png") forState:UIControlStateSelected];
    [_chooseButton addTarget:self action:@selector(chageCools) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_chooseButton];
    
    _bigChoose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 100)];
    [_bigChoose addTarget:self action:@selector(chageCools) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_bigChoose];
    
    _goodsImage = [[UIImageView alloc] initWithFrame:CGRectMake(_chooseButton.viewRightEdge+12, 10, 79, 79)];
    [self addSubview:_goodsImage];
    
    _goodsLabel = [[UILabel alloc] initWithFrame:CGRectMake(_goodsImage.viewRightEdge+12, 10, SCREEN_WIDTH-150, 12)];
    _goodsLabel.textColor = [UIColor colorWithHex:0x3d3d3d];
    _goodsLabel.font = fontForSize(12);
    [self addSubview:_goodsLabel];
    
    _goodsS = [UILabel new];
    _goodsS.viewSize = CGSizeMake(_goodsLabel.viewWidth, 10);
    [_goodsS align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(_goodsImage.viewRightEdge+12, _goodsImage.viewY+_goodsImage.viewHeight/2)];
    _goodsS.textColor = [UIColor colorWithHex:0x7f7f7f];
    _goodsS.font = fontForSize(10);
    
    _goodsPrice = [[UILabel alloc] initWithFrame:CGRectMake(_goodsImage.viewRightEdge+12, self.viewHeight-22, 100, 12)];
    _goodsPrice.textColor = [UIColor colorWithHex:0xfd5487];
    _goodsPrice.font = fontBoldForSize(12);
    [self addSubview:_goodsPrice];
    
    _goods_VipPrice = [UILabel new];
    _goods_VipPrice.viewSize = CGSizeMake(100, 9);
    [_goods_VipPrice align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(_goodsPrice.viewRightEdge+5, _goodsPrice.viewY+_goodsPrice.viewHeight/2)];
    _goods_VipPrice.textColor = [UIColor colorWithHex:0x7f7f7f];
    _goods_VipPrice.font = fontForSize(9);
    [self addSubview:_goods_VipPrice];
    
    _goodsNum = [UILabel new];
    _goodsNum.viewSize = CGSizeMake(50, 12);
    _goodsNum.textColor = [UIColor colorWithHex:0x3d3d3d];
    _goodsNum.font = fontForSize(12);
    [_goodsNum align:ViewAlignmentBottomRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15, 85)];
    [self addSubview:_goodsNum];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewHeight-0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self addSubview:line];
    
    //编辑状态
    _reduceButton = [UIButton new];
    _reduceButton.viewSize = CGSizeMake(28, 25);
    [_reduceButton setBackgroundImage:[UIImage imageNamed:@"icon_jianshao_jrgwc_nor"] forState:UIControlStateNormal];
    [_reduceButton setBackgroundImage:[UIImage imageNamed:@"icon_jianshao_jrgwc_enable"] forState:UIControlStateDisabled];
    [_reduceButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_goodsImage.viewRightEdge+12, 10)];
    [_reduceButton addTarget:self action:@selector(processJianButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_reduceButton];
    
    _changeNum = [[UILabel alloc] initWithFrame:CGRectMake(_reduceButton.viewRightEdge+1, 10, SCREEN_WIDTH-45-_reduceButton.viewRightEdge, 25)];
    _changeNum.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    _changeNum.textAlignment = NSTextAlignmentCenter;
    _changeNum.font = fontForSize(15);
    _changeNum.textColor = [UIColor blackColor];
    [self addSubview:_changeNum];
    
    
    _addButton = [UIButton new];
    _addButton.viewSize = CGSizeMake(28, 26);
    [_addButton setBackgroundImage:[UIImage imageNamed:@"icon_zengjia_jrgwc_nor.png"] forState:UIControlStateNormal];
    [_addButton setBackgroundImage:[UIImage imageNamed:@"icon_zengjia_jrgwc_enable.png"] forState:UIControlStateDisabled];
    [_addButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15,10)];
    [_addButton addTarget:self action:@selector(processJiaButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addButton];
    
    _chooseSome = [UIImageView new];
    _chooseSome.viewSize = CGSizeMake(10, 6);
    [_chooseSome align:ViewAlignmentMiddleRight relativeToPoint:CGPointMake(SCREEN_WIDTH-24, _goodsImage.viewY+_goodsImage.viewHeight/2)];
    _chooseSome.image = IMAGEWITHNAME(@"icon_xialajiantou_js.png");
    
    _placeView = [UIView new];
    _placeView.userInteractionEnabled = YES;
    _placeView.viewSize = CGSizeMake(SCREEN_WIDTH-27-_goodsImage.viewRightEdge, 25);
    [_placeView align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(_goodsImage.viewRightEdge+12, _goodsImage.viewY+_goodsImage.viewHeight/2)];
    _placeView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeGuige)];
    [_placeView addGestureRecognizer:tapGuesture];
    
    [self addSubview:_placeView];
    [self addSubview:_chooseSome];
    [self addSubview:_goodsS];
    
}

-(void)changeGuige{
    self.changeGuiGe();
}

-(void)chageCools{
    _chooseButton.selected = !_chooseButton.selected;
    self.clickButton(_chooseButton.selected);
}

-(void)setCurrenttState:(BOOL)currenttState{
    if (currenttState) {
        _goodsLabel.hidden = YES;
        _goodsNum.hidden = YES;
        
        _reduceButton.hidden = NO;
        _addButton.hidden = NO;
        _changeNum.hidden = NO;
        _chooseSome.hidden = NO;
        _placeView.hidden = NO;
        
    }else{
        _goodsLabel.hidden = NO;
        _goodsNum.hidden = NO;
        
        _reduceButton.hidden = YES;
        _addButton.hidden = YES;
        _changeNum.hidden = YES;
        _chooseSome.hidden = YES;
        _placeView.hidden = YES;
    }
}


-(void)setHideChooseB:(BOOL)hideChooseB{
    if (hideChooseB) {
        _chooseButton.hidden = YES;
        _bigChoose.hidden = YES;
        [_goodsImage align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 10)];
        [_goodsLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_goodsImage.viewRightEdge+12, 10)];
        [_goodsS align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(_goodsImage.viewRightEdge+12, _goodsImage.viewY+_goodsImage.viewHeight/2)];
        [_goodsPrice align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_goodsImage.viewRightEdge+12, self.viewHeight-22)];
        [_goods_VipPrice align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(_goodsPrice.viewRightEdge+5, _goodsPrice.viewY+_goodsPrice.viewHeight/2)];
        
        [_goodsNum align:ViewAlignmentBottomRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15, 85)];
    }
}

-(void)setGoodsDic:(NSDictionary *)goodsDic{
    
    _goodsDic = goodsDic;
    _goodsLabel.text = [NSString stringWithFormat:@"%@",_goodsDic[@"goods_name"]];
    _goodsLabel.numberOfLines = 2;
    [_goodsLabel sizeToFit];
    _goodsLabel.viewSize = CGSizeMake(SCREEN_WIDTH-150, _goodsLabel.viewHeight);
    
    [self commoent:_goodsDic];
    _placeView.hidden = YES;
    _chooseSome.hidden = YES;
    _goodsNum.text = [NSString stringWithFormat:@"x%@",_goodsDic[@"goods_num"]];
    [_goodsNum sizeToFit];
    _goodsNum.viewSize = CGSizeMake(_goodsNum.viewWidth, 12);
    [_goodsNum align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15, self.viewHeight-22)];
}

-(void)commoent:(NSDictionary *)commentDic{
    UIImageView *centerImage = [UIImageView new];
    centerImage.viewSize = CGSizeMake(33, 26);
    centerImage.image = IMAGEWITHNAME(@"logo_bangmaiwang_splb.png");
    [centerImage align:ViewAlignmentCenter relativeToPoint:CGPointMake(_goodsImage.viewWidth/2, _goodsImage.viewHeight/2)];
    [_goodsImage addSubview:centerImage];
    _goodsImage.backgroundColor = [UIColor whiteColor];
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",commentDic[@"goods_image"]]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            [centerImage removeFromSuperview];
        }
    }];
    if ([commentDic[@"goods_spec"] isKindOfClass:[NSDictionary class]]) {
        _placeView.hidden = NO;
        _chooseSome.hidden = NO;
        NSMutableString *goodsguige = [NSMutableString string];
        NSArray *allkeys =[commentDic[@"goods_spec"] allKeys];
        if (allkeys.count==1) {
            _goodsS.text = [[commentDic[@"goods_spec"] allValues] firstObject];
        }else{
            [allkeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx==allkeys.count-1) {
                    [goodsguige insertString:[NSString stringWithFormat:@"%@,",commentDic[@"goods_spec"][obj]] atIndex:0];
                }else{
                    [goodsguige insertString:[NSString stringWithFormat:@"%@",commentDic[@"goods_spec"][obj]] atIndex:0];
                }
            }];
            _goodsS.text = [NSString stringWithFormat:@"%@",goodsguige];
        }
    }else{
        if ([[commentDic objectForKeyNotNull:@"goods_spec"] isEqualToString:@"(null)"]||![commentDic objectForKeyNotNull:@"goods_spec"]) {
            _goodsS.text =@"";
            _placeView.hidden = YES;
            _chooseSome.hidden = YES;
        }else{
            _placeView.hidden = YES;
            _chooseSome.hidden = YES;
            _goodsS.text = [NSString stringWithFormat:@"%@",[commentDic objectForKeyNotNull:@"goods_spec"]];
        }
    }
    
    _goodsPrice.text = [NSString stringWithFormat:@"￥ %@",commentDic[@"goods_price"]];
    [_goodsPrice sizeToFit];
    _goodsPrice.viewSize = CGSizeMake(_goodsPrice.viewWidth, 12);
    float vipFan = [commentDic[@"goods_price"] floatValue] - [commentDic[@"goods_vip_price"] floatValue];
    _goods_VipPrice.text = [NSString stringWithFormat:@"麦咖专享返现￥ %.2f",vipFan>0?vipFan:0.00];
    if(commentDic[@"back_total"]){
        _goods_VipPrice.text = [NSString stringWithFormat:@"麦咖专享返现￥ %.2f",[commentDic[@"back_total"] floatValue]];
    }
    [_goods_VipPrice sizeToFit];
    _goods_VipPrice.viewSize = CGSizeMake(_goods_VipPrice.viewWidth, 9);
    [_goods_VipPrice align:ViewAlignmentMiddleLeft relativeToPoint:CGPointMake(_goodsPrice.viewRightEdge+5, _goodsPrice.viewY+_goodsPrice.viewHeight/2)];
    // 赠品判断
    NSString * goods_type = [commentDic objectForKeyNotNull:@"goods_type"];
    if (goods_type.integerValue == 5) {
        _goodsPrice.text = @"￥ 0.00";
        [_goodsPrice sizeToFit];
        _goodsPrice.viewSize = CGSizeMake(_goodsPrice.viewWidth, 12);
        _goods_VipPrice.text = @"￥ 0.00";
        [_goods_VipPrice sizeToFit];
        _goods_VipPrice.viewSize = CGSizeMake(_goods_VipPrice.viewWidth, 9);
    }

}

-(void)setEditDic:(NSDictionary *)editDic{
    _editDic = editDic;
    [self commoent:editDic];
    _changeNum.text = [NSString stringWithFormat:@"%@",_editDic[@"goods_num"]];
    _currentNum = [_editDic[@"goods_num"] integerValue];
    if ([_changeNum.text isEqualToString:@"1"]) {
        _reduceButton.userInteractionEnabled = NO;
        _reduceButton.selected = NO;
        _addButton.userInteractionEnabled = YES;
        _addButton.selected = YES;
    }
    else if ([_changeNum.text isEqualToString:@"20"]){
        _reduceButton.userInteractionEnabled = YES;
        _reduceButton.selected = YES;
        _addButton.userInteractionEnabled = NO;
        _addButton.selected = NO;
    }
    else{
        _reduceButton.userInteractionEnabled = YES;
        _reduceButton.selected = YES;
        _addButton.userInteractionEnabled = YES;
        _addButton.selected = YES;
    }
    
    
}

-(void)processJianButton{
    _reduceButton.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _reduceButton.userInteractionEnabled = YES;
        if([_changeNum.text isEqualToString:@"1"]){
            _reduceButton.userInteractionEnabled = NO;
        }
    });
    if ([_changeNum.text isEqualToString:@"2"]) {
        _reduceButton.selected = NO;
        _reduceButton.userInteractionEnabled = NO;
        _currentNum = 1;
        SHOW_EEROR_MSG(@"已经最少了，不能再减了亲");
    }else{
        _addButton.selected = YES;
        _addButton.userInteractionEnabled = YES;
        _currentNum--;
    }
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"CartEdit" parameters:@{@"cartId":_editDic[@"cart_id"],@"goodsId":_editDic[@"goods_id"], @"num":NSNumber(_currentNum)} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            NSLog(@"减少数量%@",object);
            self.refreshView();
        }
    }];
    
    
    _changeNum.text = [NSString stringWithFormat:@"%ld",_currentNum];
}

-(void)processJiaButton{
    _addButton.userInteractionEnabled = NO;
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"CartEdit" parameters:@{@"cartId":_editDic[@"cart_id"],@"goodsId":_editDic[@"goods_id"], @"num":NSNumber(_currentNum+1)} callBack:^(RequestResult result, id object) {
        _addButton.userInteractionEnabled = YES;
        NSLog(@"增加%@",object);
        if (result==RequestResultSuccess) {
            _currentNum++;
            self.refreshView();
        }else if(RequestResultException == result){
            if ([object[@"code"] integerValue] == 911) {
                NSLog(@"超过库存");
                SHOW_MSG(@"超过库存");
                _changeNum.text = [NSString stringWithFormat:@"%ld",_currentNum];
            }
        }
    }];
    
    //    if ([_changeNum.text isEqualToString:@"19"]){
    //        _addButton.selected = NO;
    //        _addButton.userInteractionEnabled = NO;
    //        SHOW_EEROR_MSG(@"够多了，还他妈想买");
    //    }else{
    //        _reduceButton.selected = YES;
    //        _reduceButton.userInteractionEnabled = YES;
    //        _currentNum++;
    //    }
    _changeNum.text = [NSString stringWithFormat:@"%ld",_currentNum];
}


@end
