//
//  GoodsAddCarView.m
//  BMW
//
//  Created by 白琴 on 16/3/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "GoodsAddCarView.h"

@interface GoodsAddCarView () {
//    NSDictionary * _dataSourceDic;          //数据信息
    NSString * _goodsPrice;                 //商品价格
    NSString * _goodsStorage;               //商品库存
    NSDictionary * _goodsSpecDic;           //商品默认的规格字典
    NSDictionary * _specNameDic;           //规格名称
    NSDictionary * _specValueDic;           //规格值
    NSDictionary * _specListMobileDic;      //规格对照表
    NSString * _goodsCommonid;              //商品的commonid
    
    
    NSArray * _allSpecificationArray;       //返回的所有规格数据
    NSMutableArray * _subArray;             //截取规格的对应
    NSMutableArray * _currentKeyArray;      //当前点击的key数组
    NSString * _goodsDetailOrAddCar;        //显示一个按钮还是2个按钮
    NSMutableArray * _goodsSizeArray;       //显示的规格数组【格式化之后】
    
    UIView * _backgroundBlackView;          //灰黑色的背景
    
    UILabel * _priceLabel;                  //单价Label
    UILabel * _stockLabel;                  //库存信息
    UILabel * _goodsNumLabel;               //购买数量
    UIButton * _jianButton;                 //减少按钮
    UIButton * _jiaButton;                  //增加按钮
    UIButton * _addCarButton;               //加入购物车按钮
    UIButton * _buyButton;                  //立即购买按钮
    NSString * _currentGoodsId;             //当前的goodsID
    
    //保存点击信息所需要的变量
    UIButton * _lastButton;
    NSMutableArray * _chooseButtonArray;
}

@property (nonatomic, strong)UIView * addCarScrollView;

@end

@implementation GoodsAddCarView
/**
 *  购物车规格界面初始化
 *
 *  @param frame               位置大小
 *  @param goodsId             商品ID
 *  @param goodsCommonid       商品commonid
 *  @param goodsPrice          商品价格
 *  @param goodsStorage        商品库存
 *  @param goodsSpecDic        商品当前规格字典
 *  @param specNameDic         商品所有规格的名称
 *  @param specValueDic        商品所有规格所对应的值
 *  @param specListMobileDic   商品规格值对应字典
 *  @param goodsDetailOrAddCar 一个按钮还是2个按钮 1个：addCar  2个:goodsDetail
 */
- (instancetype)initWithFrame:(CGRect)frame
                      GoodsId:(NSString *)goodsId
                goodsCommonid:(NSString *)goodsCommonid
                   goodsPrice:(NSString *)goodsPrice
                 goodsStorage:(NSString *)goodsStorage
                    goodsSpec:(NSDictionary *)goodsSpecDic
                     specName:(NSDictionary *)specNameDic
                    specValue:(NSDictionary *)specValueDic
               specListMobile:(NSDictionary *)specListMobileDic
          GoodsDetailOrAddCar:(NSString *)goodsDetailOrAddCar{
    self = [super initWithFrame:frame];
    if (self) {
        _goodsDetailOrAddCar = goodsDetailOrAddCar;
        _currentGoodsId = goodsId;
        _goodsCommonid = goodsCommonid;
        _goodsPrice = goodsPrice;
        _goodsStorage = goodsStorage;
        _goodsSpecDic = goodsSpecDic;
        _specNameDic = specNameDic;;
        _specValueDic = specValueDic;
        _specListMobileDic = specListMobileDic;
        
        [self subSpecListNumber];
        [self getSpecificationRequest];
        
        _chooseButtonArray = [NSMutableArray array];
        [self initUserInterface];
    }
    return self;
}
/**
 *  整体界面的初始化
 */
- (void)initUserInterface {
    [self addSubview:self.addCarScrollView];
    [UIView animateWithDuration:0.5 animations:^{
        [_addCarScrollView align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, self.viewHeight)];
    } completion:^(BOOL finished) {
        _backgroundBlackView = [UIView new];
        _backgroundBlackView.viewSize = CGSizeMake(self.viewWidth, self.viewHeight);
        [_backgroundBlackView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        _backgroundBlackView.backgroundColor = [UIColor blackColor];
        _backgroundBlackView.alpha = 0.4;
        [self addSubview:_backgroundBlackView];
        [self bringSubviewToFront:_addCarScrollView];
    }];
}

/**
 *  初始化加入购物车的界面
 */
- (UIView *)addCarScrollView {
    if (!_addCarScrollView) {
        _addCarScrollView = [UIView new];
        _addCarScrollView.viewSize = CGSizeMake(self.viewWidth, 288 * W_ABCW);
        _addCarScrollView.backgroundColor = [UIColor whiteColor];
        [_addCarScrollView align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, self.viewHeight + 700)];
        
        //价格
        _priceLabel = [UILabel new];
        _priceLabel.viewSize = CGSizeMake(100, 45);
        _priceLabel.textColor = [UIColor colorWithHex:0xfd5487];
        _priceLabel.text = [NSString stringWithFormat:@"¥%@", _goodsPrice];
        _priceLabel.font = fontForSize(17);
        [_addCarScrollView addSubview:_priceLabel];
        [_priceLabel sizeToFit];
        [_priceLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, (45 * W_ABCW - _priceLabel.viewHeight) / 2)];
        //库存信息
        _stockLabel = [UILabel new];
        _stockLabel.viewSize = CGSizeMake(100, 45);
        _stockLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
        _stockLabel.font = fontForSize(10);
        _stockLabel.text = [NSString stringWithFormat:@"库存数量  %@", _goodsStorage];
        [_addCarScrollView addSubview:_stockLabel];
        [_stockLabel sizeToFit];
        [_stockLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_priceLabel.viewRightEdge + 9, (45 * W_ABCW - _stockLabel.viewHeight) / 2)];
        //取消按钮
        UIButton * cancelButton = [UIButton new];
        cancelButton.viewSize = CGSizeMake(17, 17);
        [cancelButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(self.viewWidth - 15, 7 * W_ABCW)];
        [cancelButton setBackgroundImage:[UIImage imageNamed:@"icon_quxiao_jrgwc"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(clickedCancelButton) forControlEvents:UIControlEventTouchUpInside];
        [_addCarScrollView addSubview:cancelButton];
        //分割线
        UIView * lineView = [UIView new];
        lineView.viewSize = CGSizeMake(self.viewWidth - 30, 1);
        [lineView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 45 * W_ABCW)];
        lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_addCarScrollView addSubview:lineView];
        
        
        UIScrollView * _scrollView = [UIScrollView new];
        _scrollView.viewSize = CGSizeMake(self.viewWidth, 199 * W_ABCW);
        [_scrollView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, lineView.viewBottomEdge)];
        _scrollView.showsVerticalScrollIndicator = NO;
        [_addCarScrollView addSubview:_scrollView];
        
        
        //格式化规格的数据格式
        [self formatData];
        
        //如果没有规格只显示加减数量，高度降低
        if (_goodsSizeArray.count == 0) {
            _addCarScrollView.viewSize = CGSizeMake(self.viewWidth, 188 * W_ABCW);
            [_addCarScrollView align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, self.viewHeight + 700)];
            _scrollView.viewSize = CGSizeMake(self.viewWidth, 99 * W_ABCW);
            [_scrollView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, lineView.viewBottomEdge)];
        }
        
        
        
        UIView * _lineView = [UIView new];        //临时view
        NSInteger _buttonTag = 0;
        for (int i = 0; i < _goodsSizeArray.count; i ++) {
            //初始化保存选择信息的数组
            [_chooseButtonArray insertObject:@"" atIndex:i];
            //标题
            UILabel * colorLabel = [UILabel new];
            colorLabel.viewSize = CGSizeMake(100, 30);
            colorLabel.textColor = [UIColor colorWithHex:0x181818];
            colorLabel.font = fontForSize(13);
            colorLabel.text = _goodsSizeArray[i][@"name"];
            [colorLabel sizeToFit];
            [colorLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, _lineView.viewBottomEdge + 14 * W_ABCH)];
            [_scrollView addSubview:colorLabel];
            //对应的值
            NSArray * colorArray = [(NSDictionary *)_goodsSizeArray[i][@"value"] allValues];
            //设置默认
            NSArray * defaultArray = [_goodsSpecDic allValues];
            _currentKeyArray = [NSMutableArray arrayWithArray:[_goodsSpecDic allKeys]];
            NSInteger width = 0;        //整体所占宽度
            NSInteger line = 1;         //行数
            NSInteger row = 0;          //每排个数
            UIButton * lastButton = [UIButton new];     //上一个button
            UIButton * lastLineButton = [[UIButton alloc] initWithFrame:CGRectMake(15, colorLabel.viewBottomEdge, 100, 1)];
            _buttonTag = 10000 * (i + 1);
            for (int j = 0; j < colorArray.count; j ++) {
                UIButton * colorButton = [UIButton new];
                colorButton.viewSize = CGSizeMake(100, 22 * W_ABCH);
                [colorButton setTitle:colorArray[j] forState:UIControlStateNormal];
                [colorButton setTitleColor:[UIColor colorWithHex:0x181818] forState:UIControlStateNormal];
                colorButton.titleLabel.font = fontForSize(12);
                colorButton.layer.borderColor = [UIColor colorWithHex:0xe1e1e1].CGColor;
                colorButton.layer.borderWidth = 1;
                colorButton.tag = _buttonTag + j;
                colorButton.layer.cornerRadius = colorButton.viewHeight / 2;
                colorButton.layer.masksToBounds = YES;
                [colorButton.titleLabel sizeToFit];
                colorButton.viewSize = CGSizeMake(colorButton.titleLabel.viewWidth + 18, colorButton.viewHeight);
                [colorButton addTarget:self action:@selector(clickedChooseButton:) forControlEvents:UIControlEventTouchUpInside];
                //设置默认
                for (int k = 0; k < defaultArray.count; k ++) {
                    if ([colorArray[j] isEqualToString:defaultArray[k]]) {
                        [colorButton setTitleColor:[UIColor colorWithHex:0xfc4e30] forState:UIControlStateNormal];
                        colorButton.layer.borderColor = [UIColor colorWithHex:0xfc4e30].CGColor;
                        //保存信息
                        [_chooseButtonArray replaceObjectAtIndex:i withObject:colorButton];
                    }
                }
                //根据宽度计算button所在的位置
                width += colorButton.viewWidth + 7 * W_ABCH;
                if (width >= self.viewWidth - 30 * W_ABCH) {
                    width = colorButton.viewWidth + 7 * W_ABCH;
                    line += 1;
                    row = 0;
                    lastLineButton = lastButton;
                }
                if (row == 0) {
                    [colorButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15 * W_ABCH, lastLineButton.viewBottomEdge + 14 * W_ABCH)];
                }
                else {
                    [colorButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(lastButton.viewRightEdge + 7 * W_ABCH, lastLineButton.viewBottomEdge + 14 * W_ABCH)];
                }
                [_scrollView addSubview:colorButton];
                lastButton = colorButton;
                row += 1;
            }
            //分割线
            UIView * lineView1 = [UIView new];
            lineView1.viewSize = CGSizeMake(self.viewWidth - 30, 1);
            [lineView1 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, lastButton.viewBottomEdge + 14 * W_ABCH)];
            lineView1.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
            [_scrollView addSubview:lineView1];
            
            _lineView  = lineView1;
        }
        
        //数量选择
        UILabel * numberNameLabel = [UILabel new];
        numberNameLabel.viewSize = CGSizeMake(100, 52 * W_ABCH);
        [numberNameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, _lineView.viewBottomEdge)];
        numberNameLabel.textColor = [UIColor colorWithHex:0x181818];
        numberNameLabel.font = fontForSize(13);
        numberNameLabel.text = @"购买数量";
        [_scrollView addSubview:numberNameLabel];
        //加号
        _jiaButton = [UIButton new];
        _jiaButton.viewSize = CGSizeMake(28, 26 * W_ABCW);
        [_jiaButton setBackgroundImage:[UIImage imageNamed:@"icon_zengjia_jrgwc_nor"] forState:UIControlStateNormal];
        [_jiaButton setBackgroundImage:[UIImage imageNamed:@"icon_zengjia_jrgwc_enable"] forState:UIControlStateDisabled];
        [_jiaButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(self.viewWidth - 15, (52 * W_ABCW - _jiaButton.viewHeight) / 2 + _lineView.viewBottomEdge)];
        _jiaButton.tag = 11000;
        [_jiaButton addTarget:self action:@selector(processJiaButton:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:_jiaButton];
        
        if (_goodsStorage.integerValue <= 1) {
            _jiaButton.enabled = NO;
        }
        
        UIImageView * jiajianImageView = [UIImageView new];
        jiajianImageView.viewSize = CGSizeMake(32, 25 * W_ABCW);
        [jiajianImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(_jiaButton.viewX - 2, _jiaButton.viewY)];
        [jiajianImageView setImage:[UIImage imageNamed:@"btn_shuliangxianshikuang_jrgwc"]];
        jiajianImageView.userInteractionEnabled = YES;
        [_scrollView addSubview:jiajianImageView];
        _goodsNumLabel = [UILabel new];
        _goodsNumLabel.viewSize = jiajianImageView.viewSize;
        [_goodsNumLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 0)];
        _goodsNumLabel.textColor = [UIColor colorWithHex:0x181818];
        _goodsNumLabel.font = [UIFont systemFontOfSize:12];
        _goodsNumLabel.text = @"1";
        _goodsNumLabel.textAlignment = NSTextAlignmentCenter;
        [jiajianImageView addSubview:_goodsNumLabel];
        
        //减号
        _jianButton = [UIButton new];
        _jianButton.viewSize = CGSizeMake(28, 26 * W_ABCW);
        [_jianButton setBackgroundImage:[UIImage imageNamed:@"icon_jianshao_jrgwc_nor"] forState:UIControlStateNormal];
        [_jianButton setBackgroundImage:[UIImage imageNamed:@"icon_jianshao_jrgwc_enable"] forState:UIControlStateDisabled];
        [_jianButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(jiajianImageView.viewX - 2, _jiaButton.viewY)];
        _jianButton.tag = 11001;
        _jianButton.enabled = NO;
        [_jianButton addTarget:self action:@selector(processJianButton:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:_jianButton];
        //分割线
        UIView * lineView2 = [UIView new];
        lineView2.viewSize = CGSizeMake(self.viewWidth - 30, 1);
        [lineView2 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, numberNameLabel.viewBottomEdge)];
        lineView2.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
        [_scrollView addSubview:lineView2];
        
        _scrollView.contentSize = CGSizeMake(self.viewWidth, lineView2.viewBottomEdge);
        
        if ([_goodsDetailOrAddCar isEqualToString:@"goodsDetail"]) {
            _addCarButton = [UIButton new];
            _addCarButton.viewSize = CGSizeMake(self.viewWidth / 2, 45 * W_ABCW);
            [_addCarButton align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, _addCarScrollView.viewHeight)];
            [_addCarButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xfd5487] andSize:_addCarButton.viewSize] forState:UIControlStateSelected];
            [_addCarButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xcccccc] andSize:_addCarButton.viewSize] forState:UIControlStateNormal];
            _addCarButton.selected = YES;
            [_addCarButton setTitle:@"加入购物车" forState:UIControlStateNormal];
            [_addCarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_addCarButton addTarget:self action:@selector(clickedAddCarButton) forControlEvents:UIControlEventTouchUpInside];
            [_addCarScrollView addSubview:_addCarButton];
            
            _buyButton = [UIButton new];
            _buyButton.viewSize = CGSizeMake(self.viewWidth / 2, 45 * W_ABCW);
            [_buyButton align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(self.viewWidth / 2, _addCarScrollView.viewHeight)];
            [_buyButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xff9402] andSize:_buyButton.viewSize] forState:UIControlStateSelected];
            [_buyButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xcccccc] andSize:_buyButton.viewSize] forState:UIControlStateNormal];
            _buyButton.selected = YES;
            [_buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
            [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_buyButton addTarget:self action:@selector(clickedBuyButton) forControlEvents:UIControlEventTouchUpInside];
            [_addCarScrollView addSubview:_buyButton];
        }
        else {
            _addCarButton = [UIButton new];
            _addCarButton.viewSize = CGSizeMake(self.viewWidth, 45 * W_ABCW);
            [_addCarButton align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, _addCarScrollView.viewHeight)];
            [_addCarButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xfd5487] andSize:_addCarButton.viewSize] forState:UIControlStateSelected];
            [_addCarButton setBackgroundImage:[UIImage squareImageWithColor:[UIColor colorWithHex:0xcccccc] andSize:_addCarButton.viewSize] forState:UIControlStateNormal];
            _addCarButton.selected = YES;
            [_addCarButton setTitle:@"确定" forState:UIControlStateNormal];
            [_addCarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_addCarButton addTarget:self action:@selector(clickedAddCarButton) forControlEvents:UIControlEventTouchUpInside];
            [_addCarScrollView addSubview:_addCarButton];
        }
        
        if ([_goodsStorage integerValue] == 0) {
            _jiaButton.userInteractionEnabled = NO;
            _jiaButton.selected = NO;
            _addCarButton.userInteractionEnabled = NO;
            _addCarButton.selected = NO;
            _buyButton.userInteractionEnabled = NO;
            _buyButton.selected = NO;
        }
        else {
            _jiaButton.userInteractionEnabled = YES;
            _jiaButton.selected = YES;
            _addCarButton.userInteractionEnabled = YES;
            _addCarButton.selected = YES;
            _buyButton.userInteractionEnabled = YES;
            _buyButton.selected = YES;
        }
    }
    return _addCarScrollView;
}

#pragma mark -- 点击事件
/**
 *  加数量
 */
- (void)processJiaButton:(UIButton *)sender {
    NSInteger number = [_goodsNumLabel.text integerValue];
    
    if (number != [_goodsStorage integerValue]) {
        number++;
        _goodsNumLabel.text = [NSString stringWithFormat:@"%ld", (long)number];
    }
    if (number == [_goodsStorage integerValue]) {
        _jiaButton.enabled = NO;
    }
    _jianButton.enabled = YES;
}
/**
 *  减数量
 */
- (void)processJianButton:(UIButton *)sender {
    NSInteger number = [_goodsNumLabel.text integerValue];
    _jiaButton.enabled = YES;
    if (number > 1) {
        number--;
        _goodsNumLabel.text = [NSString stringWithFormat:@"%ld", (long)number];
        
    }
    if (number <= 1) {
        _jianButton.enabled = NO;
        _goodsNumLabel.text = @"1";
    }
}

/**
 *  点击了规格选择按钮
 */
- (void)clickedChooseButton:(UIButton *)sender {
    //当前button和上一个button  【使用sender.tag / 10000来区分是第几个规格】
    NSInteger _index = sender.tag / 10000;
    NSInteger _lastIndex = _lastButton.tag / 10000;
    //改变button的字体颜色和边框颜色
    [_lastButton setTitleColor:[UIColor colorWithHex:0x181818] forState:UIControlStateNormal];
    _lastButton.layer.borderColor = [UIColor colorWithHex:0xe1e1e1].CGColor;
    sender.layer.borderColor = [UIColor colorWithHex:0xfc4e30].CGColor;
    [sender setTitleColor:[UIColor colorWithHex:0xfc4e30] forState:UIControlStateNormal];
    //判断上一次点击的button是不是和现在点击的button为同一个分组里面的规格
    if (_lastIndex != _index) {
        for (UIButton * button in _chooseButtonArray) {
            if ([button isKindOfClass:[UIButton class]]) {
                if (button.tag / 10000 == _index && button.tag != sender.tag) {
                    [button setTitleColor:[UIColor colorWithHex:0x181818] forState:UIControlStateNormal];
                    button.layer.borderColor = [UIColor colorWithHex:0xe1e1e1].CGColor;
                }
            }
        }
        [_lastButton setTitleColor:[UIColor colorWithHex:0xfc4e30] forState:UIControlStateNormal];
        _lastButton.layer.borderColor = [UIColor colorWithHex:0xfc4e30].CGColor;
    }
    //保存信息
    [_chooseButtonArray replaceObjectAtIndex:_index - 1 withObject:sender];
    _lastButton = sender;
    
    
    //改变当前信息
    NSDictionary * dic = (NSDictionary *)_goodsSizeArray[_index - 1][@"value"];
    for (int i = 0; i < [dic allKeys].count ; i ++) {
        //找到当前点击按钮的key
        if ([[dic objectForKey:[[dic allKeys]objectAtIndex:i]] isEqualToString:sender.titleLabel.text]){
            NSString * buttonKey = [[dic allKeys] objectAtIndex:i];
            NSArray * keyArray = [NSArray arrayWithArray:[dic allKeys]];
            BOOL isBreak = NO;
            for (int k = 0; k < keyArray.count; k ++) {
                for (int l = 0; l < _currentKeyArray.count; l ++) {
                    if ([keyArray[k] integerValue] == [_currentKeyArray[l] integerValue]) {
                        [_currentKeyArray replaceObjectAtIndex:l withObject:buttonKey];
                        isBreak = YES;
                        break;
                    }
                }
                if (isBreak) {
                    break;
                }
            }
            
            for (int j = 0; j < _subArray.count; j++) {
                //判断两个数组是否相同
                BOOL sameBool = [self twoArraysAreTheSameWithOneArray:_currentKeyArray twoArray:_subArray[j][@"value"]];
                if (sameBool) {
                    //遍历所有的规格数组
                    for (NSDictionary * dic1 in _allSpecificationArray) {
                        //找到与当前goodsID【_subArray[j][@"key"]】所匹配的数据，然后改变界面显示
                        if ([dic1[@"goods_id"] isEqualToString:_subArray[j][@"key"]]) {
                            //改变当前的goodsID
                            _currentGoodsId = dic1[@"goods_id"];
                            //改变界面显示
                            _priceLabel.text = [NSString stringWithFormat:@"¥%@", dic1[@"goods_price"]];
                            _stockLabel.text = [NSString stringWithFormat:@"库存数量  %@", dic1[@"goods_storage"]];
                            _goodsStorage = dic1[@"goods_storage"];
                            [_priceLabel sizeToFit];
                            [_priceLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, (45 * W_ABCW - _priceLabel.viewHeight) / 2)];
                            [_stockLabel sizeToFit];
                            [_stockLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_priceLabel.viewRightEdge + 9, (45 * W_ABCW - _stockLabel.viewHeight) / 2)];
                            _goodsNumLabel.text = @"1";
                            _jianButton.userInteractionEnabled = NO;
                            _jianButton.selected = NO;
                            /**
                             *  判断库存如果为0  则不可点击
                             */
                            if ([dic1[@"goods_storage"] integerValue] == 0) {
                                _jiaButton.userInteractionEnabled = NO;
                                _jiaButton.selected = NO;
                                _addCarButton.userInteractionEnabled = NO;
                                _addCarButton.selected = NO;
                                _buyButton.userInteractionEnabled = NO;
                                _buyButton.selected = NO;
                            }
                            else {
                                _jiaButton.userInteractionEnabled = YES;
                                _jiaButton.selected = YES;
                                _addCarButton.userInteractionEnabled = YES;
                                _addCarButton.selected = YES;
                                _buyButton.userInteractionEnabled = YES;
                                _buyButton.selected = YES;
                            }
                        }
                    }
                }
            }
        }
    }
}
/**
 *  点击取消
 */
- (void)clickedCancelButton {
    NSLog(@"点击了取消");
    [self cancelAnimatioon];
}
/**
 *  点击加入购物车
 */
- (void)clickedAddCarButton {
    NSLog(@"点击了添加购物车");
    [self addCarRequest];
}

/**
 *  点击了立即购买
 */
- (void)clickedBuyButton {
    NSString * goodsCount;
    if (_goodsNumLabel) {
        goodsCount = _goodsNumLabel.text;
    }
    else {
        goodsCount = @"1";
    }
    self.clickedBuy(_currentGoodsId, goodsCount);
    [self cancelAnimatioon];
}

#pragma mark -- 其他
/**
 *  判断两个数组是否相等
 *
 *  @param array1   数组1
 *  @param twoArray 数组2
 *
 *  @return 返回是或否
 */
- (BOOL)twoArraysAreTheSameWithOneArray:(NSMutableArray *)array1 twoArray:(NSMutableArray *)twoArray {
    //对数组排序对比
    NSArray * array3 = [NSArray arrayWithArray:[array1 sortedArrayUsingSelector:@selector(compare:)]];
    NSArray * array4 = [NSArray arrayWithArray:[twoArray sortedArrayUsingSelector:@selector(compare:)]];
    BOOL bol = false;
    if (array3.count == array4.count) {
        bol = true;
        for (int16_t i = 0; i < array3.count; i++) {
            NSString *c1 = [array3 objectAtIndex:i];
            NSString *newc = [array4 objectAtIndex:i];
            if (![newc isEqualToString:c1]) {
                bol = false;
                break;
            }
        }
    }
    return bol;
}


/**
 *  截取多个规格的组合
 */
- (void)subSpecListNumber {
    _subArray = [NSMutableArray array];
    NSInteger num = 0;
    for (NSString * keyString in [_specListMobileDic allKeys]) {
        NSInteger _index = 0;
        NSMutableArray * array = [NSMutableArray array];
        for (int i = 0; i < keyString.length; i ++) {
            NSString * keyChar = [keyString substringWithRange:NSMakeRange(i, 1)];
            if ([keyChar isEqualToString:@"|"]) {
                NSString * subString = [keyString substringWithRange:NSMakeRange(_index, i - _index)];
                _index = i + 1;
                [array addObject:subString];
            }
        }
        NSString * subString = [keyString substringWithRange:NSMakeRange(_index, keyString.length - _index)];
        [array addObject:subString];
        NSDictionary * dic = @{@"key":[_specListMobileDic allValues][num], @"value":array};
        [_subArray addObject:dic];
        num ++;
    }
}

/**
 *  格式化规格数据【设置成想要的数据格式，方便显示使用】
 *  格式化成 数组套字典的格式
 */
- (void)formatData {
    if (![_specNameDic isKindOfClass:[NSNull class]]) {
        if ([_specNameDic isKindOfClass:[NSDictionary class]]) {
            NSArray * spec_nameKeyArray = [_specNameDic allKeys];
            _goodsSizeArray = [NSMutableArray array];
            for (int i = 0; i < spec_nameKeyArray.count; i ++) {
                NSMutableDictionary * dic = [NSMutableDictionary dictionary];
                [dic setObject:_specNameDic[spec_nameKeyArray[i]] forKey:@"name"];
                [dic setObject:_specValueDic[spec_nameKeyArray[i]] forKey:@"value"];
                [_goodsSizeArray addObject:dic];
            }
        }
    }
}
/**
 *  消失动画
 */
- (void)cancelAnimatioon {
    [UIView animateWithDuration:0.5 animations:^{
        [_addCarScrollView align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(0, self.viewHeight + 700)];
        _backgroundBlackView.alpha = 0;
    } completion:^(BOOL finished) {
        [_addCarScrollView removeFromSuperview];
        [_backgroundBlackView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark -- 网络请求
/**
 *  加入购物车的网络请求
 */
- (void)addCarRequest {
    NSString * goodsCount;
    if (_goodsNumLabel) {
        goodsCount = _goodsNumLabel.text;
    }
    else {
        goodsCount = @"1";
    }
    //加入购物车
    if (!_fixShopCar) {
        self.clickedAddCar(_currentGoodsId, goodsCount);
        
    }
    //修改购物车里面的规格
    else{
        self.changeCar(_catID,_currentGoodsId,goodsCount);
    }
    [self cancelAnimatioon];
}
/**
 *  获取所有商品规格所对应的价格和库存
 */
- (void)getSpecificationRequest {
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"StorageList" parameters:@{@"goodsCommonId":_goodsCommonid} callBack:^(RequestResult result, id object) {
        if (result == RequestResultSuccess) {
            _allSpecificationArray = [NSArray arrayWithArray:object[@"data"]];
        }
    }];
}


@end
