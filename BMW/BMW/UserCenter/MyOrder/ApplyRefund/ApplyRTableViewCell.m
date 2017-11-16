//
//  ApplyRTableViewCell.m
//  BMW
//
//  Created by rr on 16/3/21.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ApplyRTableViewCell.h"

@interface ApplyRTableViewCell ()
{
    NSInteger _currentNum;
    UIButton *_bigChoose;
}
@property(nonatomic, strong)UIImageView *goodsImage;

@property(nonatomic, strong)UILabel *goodsPrice;

@property(nonatomic, strong)UILabel *goodsLabel;

@property(nonatomic, strong)UILabel *goodsS;

@property(nonatomic, strong)UILabel *goodsNum;

@property(nonatomic, strong)UIButton *reduceButton;

@property(nonatomic, strong)UIButton *addButton;

@property(nonatomic, strong)UILabel *changeNum;


@end


@implementation ApplyRTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self loadViews];
    }
    return self;
}

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
    [self addSubview:_goodsS];

    
    _goodsPrice = [UILabel new];
    _goodsPrice.viewSize = CGSizeMake(100, 12);
    [_goodsPrice align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(_goodsImage.viewRightEdge+12, 82)];
    _goodsPrice.textColor = [UIColor colorWithHex:0xfd5487];
    _goodsPrice.font = fontBoldForSize(12);
    [self addSubview:_goodsPrice];
    
    
    _goodsNum = [UILabel new];
    _goodsNum.viewSize = CGSizeMake(50, 12);
    _goodsNum.textColor = [UIColor colorWithHex:0x3d3d3d];
    _goodsNum.font = fontForSize(12);
    [_goodsNum align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(_goodsPrice.viewRightEdge+7, 82)];
    [self addSubview:_goodsNum];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewHeight-0.5, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [self addSubview:line];
    
    _addButton = [UIButton new];
    _addButton.viewSize = CGSizeMake(28, 26);
    [_addButton setBackgroundImage:[UIImage imageNamed:@"icon_zengjia_jrgwc"] forState:UIControlStateSelected];
    [_addButton setBackgroundImage:[UIImage imageNamed:@"icon_zengjia_enable_jrgwc"] forState:UIControlStateNormal];
    [_addButton align:ViewAlignmentBottomRight relativeToPoint:CGPointMake(SCREEN_WIDTH-15,90)];
    [_addButton addTarget:self action:@selector(processJiaButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addButton];
    
    _changeNum = [[UILabel alloc] initWithFrame:CGRectMake(_addButton.viewX-31, _addButton.viewY, 30, 25)];
    _changeNum.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    _changeNum.text =@"1";
    _changeNum.textAlignment = NSTextAlignmentCenter;
    _changeNum.font = fontForSize(15);
    _changeNum.textColor = [UIColor blackColor];
    [self addSubview:_changeNum];


    _reduceButton = [UIButton new];
    _reduceButton.viewSize = CGSizeMake(28, 25);
    [_reduceButton setBackgroundImage:[UIImage imageNamed:@"icon_jianshao_nor_jrgwc"] forState:UIControlStateSelected];
    [_reduceButton setBackgroundImage:[UIImage imageNamed:@"icon_jianshao_enable_jrgwc"] forState:UIControlStateNormal];
    [_reduceButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_changeNum.viewX-29, _addButton.viewY)];
    [_reduceButton addTarget:self action:@selector(processJianButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_reduceButton];
    
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    _currentNum = 1;
    UIImageView *centerImage = [UIImageView new];
    centerImage.viewSize = CGSizeMake(33, 26);
    centerImage.image = IMAGEWITHNAME(@"logo_bangmaiwang_splb.png");
    [centerImage align:ViewAlignmentCenter relativeToPoint:CGPointMake(_goodsImage.viewWidth/2, _goodsImage.viewHeight/2)];
    [_goodsImage addSubview:centerImage];
    _goodsImage.backgroundColor = [UIColor whiteColor];
    [_goodsImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataDic[@"goods_image"]]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!error) {
            [centerImage removeFromSuperview];
        }
    }];
    _goodsLabel.text = [NSString stringWithFormat:@"%@",_dataDic[@"goods_name"]];
    _goodsLabel.numberOfLines = 2;
    [_goodsLabel sizeToFit];
    _goodsLabel.viewSize = CGSizeMake(SCREEN_WIDTH-150, _goodsLabel.viewHeight);

    
    if ([_dataDic[@"goods_spec"] isKindOfClass:[NSDictionary class]]) {
        NSMutableString *goodsguige = [NSMutableString string];
        NSArray *allkeys =[_dataDic[@"goods_spec"] allKeys];
        if (allkeys.count==1) {
            _goodsS.text = [[_dataDic[@"goods_spec"] allValues] firstObject];
        }else{
            [allkeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx==allkeys.count-1) {
                    [goodsguige insertString:[NSString stringWithFormat:@"%@,",_dataDic[@"goods_spec"][obj]] atIndex:0];
                }else{
                    [goodsguige insertString:[NSString stringWithFormat:@"%@",_dataDic[@"goods_spec"][obj]] atIndex:0];
                }
            }];
            _goodsS.text = [NSString stringWithFormat:@"%@",goodsguige];
        }
    }else{
        if ([[_dataDic objectForKeyNotNull:@"goods_spec"] isEqualToString:@"(null)"]||![_dataDic objectForKeyNotNull:@"goods_spec"]) {
            _goodsS.text =@"";
        }else{
            _goodsS.text = [NSString stringWithFormat:@"%@",[_dataDic objectForKeyNotNull:@"goods_spec"]];
        }
    }
    _goodsPrice.text = [NSString stringWithFormat:@"￥ %@",_dataDic[@"goods_pay_price"]];
    [_goodsPrice sizeToFit];
    _goodsPrice.viewSize = CGSizeMake(_goodsPrice.viewWidth, 12);
    _goodsNum.text =  [NSString stringWithFormat:@"x%@",_dataDic[@"goods_num"]];
    [_goodsNum align:ViewAlignmentBottomLeft relativeToPoint:CGPointMake(_goodsPrice.viewRightEdge+7, 82)];
    if ([_dataDic[@"goods_num"] integerValue]>1) {
        _addButton.selected = YES;
        _addButton.userInteractionEnabled = YES;
    }else{
        _addButton.selected = NO;
        _addButton.userInteractionEnabled = NO;
        _reduceButton.selected = NO;
        _reduceButton.userInteractionEnabled = NO;
        
    }
}

-(void)chageCools{
    _chooseButton.selected = !_chooseButton.selected;
    self.clickButton(_chooseButton.selected);
}




-(void)processJianButton{
    if ([_changeNum.text isEqualToString:@"1"]){
        _reduceButton.enabled = NO;
//        _reduceButton.userInteractionEnabled = NO;
        _addButton.enabled = YES;
//        _addButton.userInteractionEnabled = YES;
        _currentNum = 1;
    }else{
        _addButton.enabled = YES;
//        _addButton.userInteractionEnabled = YES;
        _currentNum--;
    }
    _changeNum.text = [NSString stringWithFormat:@"%ld",_currentNum];
    self.numaddOrduce(_changeNum.text);
}

-(void)processJiaButton{
    if ([_changeNum.text isEqualToString:[_goodsNum.text substringFromIndex:1]]){
        _addButton.enabled = NO;
//        _addButton.userInteractionEnabled = NO;
//        _reduceButton.userInteractionEnabled = YES;
        _reduceButton.enabled = YES;
    }else{
        _currentNum++;
        _reduceButton.enabled = YES;
//        _reduceButton.userInteractionEnabled = YES;
//        _reduceButton.userInteractionEnabled = YES;
        _reduceButton.enabled = YES;
        if (_currentNum == [_dataDic[@"goods_num"] integerValue]) {
            _addButton.enabled =  NO;
//            _addButton.userInteractionEnabled = NO;
        }
    }
    _changeNum.text = [NSString stringWithFormat:@"%ld",_currentNum];
    self.numaddOrduce(_changeNum.text);
}




@end

