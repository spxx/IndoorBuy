//
//  AddressListTableViewCell.m
//  BMW
//
//  Created by 白琴 on 16/3/2.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "AddressListTableViewCell.h"

@interface AddressListTableViewCell () {
    UIView * _buttonView;
    
    NSMutableDictionary * _dataSourceDic;
    UILabel * _defaultLabel;
    NSString * _isDefault;
}

@end

@implementation AddressListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self LoadViews];
    }
    return self;
}

-(void)LoadViews
{
    _nameLabel = [UILabel new];
    _nameLabel.viewSize = CGSizeMake(100, 30);
    [_nameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 12)];
    _nameLabel.font = fontForSize(15);
    _nameLabel.textColor = [UIColor colorWithHex:0x181818];
    [self.contentView addSubview:_nameLabel];
    
    _phoneLabel = [UILabel new];
    _phoneLabel.viewSize = CGSizeMake(100, 30);
    [_phoneLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_nameLabel.viewRightEdge + 24, 12)];
    _phoneLabel.font = fontForSize(15);
    _phoneLabel.textColor = [UIColor colorWithHex:0x181818];
    [self.contentView addSubview:_phoneLabel];
    
    _IDCardLabel = [UILabel new];
    _IDCardLabel.viewSize = CGSizeMake(100, 30);
    [_IDCardLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, _phoneLabel.viewBottomEdge + 12)];
    _IDCardLabel.font = fontForSize(15);
    _IDCardLabel.textColor = [UIColor colorWithHex:0x181818];
    [self.contentView addSubview:_IDCardLabel];
    
    _addressInfoLabel = [UILabel new];
    _addressInfoLabel.viewSize = CGSizeMake(SCREEN_WIDTH - 30, 30);
    [_addressInfoLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, _IDCardLabel.viewBottomEdge + 12)];
    _addressInfoLabel.font = fontForSize(12);
    _addressInfoLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    [self.contentView addSubview:_addressInfoLabel];
    
    _buttonView = [UIView new];
    _buttonView.viewSize = CGSizeMake(SCREEN_WIDTH, 38);
    [_buttonView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(0, 110)];
    _buttonView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_buttonView];
    
    
    UIView * line1 = [UIView new];
    line1.viewSize = CGSizeMake(SCREEN_WIDTH - 30, 0.5);
    [line1 align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 0)];
    line1.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    [_buttonView addSubview:line1];
    
    
    UILabel * deleteLabel = [UILabel new];
    deleteLabel.viewSize = CGSizeMake(20, 30);
    deleteLabel.font = fontForSize(12);
    deleteLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    deleteLabel.text = @"删除";
    [deleteLabel sizeToFit];
    [deleteLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, line1.viewBottomEdge + (38 - deleteLabel.viewHeight) / 2)];
    [_buttonView addSubview:deleteLabel];
    
    UIImageView * deleteImageView = [UIImageView new];
    deleteImageView.viewSize = CGSizeMake(15, 15);
    [deleteImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(deleteLabel.viewX - 6, line1.viewBottomEdge + (38 - deleteImageView.viewHeight) / 2)];
    deleteImageView.image = [UIImage imageNamed:@"icon_shanchu_shdz"];
    [_buttonView addSubview:deleteImageView];
    
    UIButton * deleteButton = [UIButton new];
    deleteButton.viewSize = CGSizeMake(deleteImageView.viewWidth + deleteLabel.viewWidth + 6, 38);
    [deleteButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(SCREEN_WIDTH - 15, line1.viewBottomEdge)];
    [deleteButton addTarget:self action:@selector(ClickedDeleteButton) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:deleteButton];
    
    UILabel * editLabel = [UILabel new];
    editLabel.viewSize = CGSizeMake(20, 30);
    editLabel.font = fontForSize(12);
    editLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    editLabel.text = @"编辑";
    [editLabel sizeToFit];
    [editLabel align:ViewAlignmentTopRight relativeToPoint:CGPointMake(deleteButton.viewX - 15, line1.viewBottomEdge + (38 - editLabel.viewHeight) / 2)];
    [_buttonView addSubview:editLabel];
    
    UIImageView * editImageView = [UIImageView new];
    editImageView.viewSize = CGSizeMake(15, 15);
    [editImageView align:ViewAlignmentTopRight relativeToPoint:CGPointMake(editLabel.viewX - 6, line1.viewBottomEdge + (38 - editImageView.viewHeight) / 2)];
    editImageView.image = [UIImage imageNamed:@"icon_bianji_shdz"];
    [_buttonView addSubview:editImageView];
    
    UIButton * editButton = [UIButton new];
    editButton.viewSize = CGSizeMake(editImageView.viewWidth + editLabel.viewWidth + 6, 38);
    [editButton align:ViewAlignmentTopRight relativeToPoint:CGPointMake(deleteButton.viewX - 15, line1.viewBottomEdge)];
    [editButton addTarget:self action:@selector(ClickedEditButton) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:editButton];
    
    
    _setDefaultButton = [UIButton new];
    _setDefaultButton.viewSize = CGSizeMake(18, 18);
    [_setDefaultButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, line1.viewBottomEdge + (38 - _setDefaultButton.viewHeight) / 2)];
    [_setDefaultButton setBackgroundImage:[UIImage imageNamed:@"icon_gouxuan_nor_gwc"] forState:UIControlStateNormal];
    [_setDefaultButton setBackgroundImage:[UIImage imageNamed:@"icon_gouxuan_cli_gwc"] forState:UIControlStateSelected];
    [_setDefaultButton addTarget:self action:@selector(ClickedSetDefaultButton:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:_setDefaultButton];
    
    _defaultLabel = [UILabel new];
    _defaultLabel.viewSize = CGSizeMake(20, 30);
    _defaultLabel.font = fontForSize(12);
    _defaultLabel.textColor = [UIColor colorWithHex:0x7f7f7f];
    _defaultLabel.text = @"默认地址";
    [_defaultLabel sizeToFit];
    [_defaultLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_setDefaultButton.viewRightEdge + 10, line1.viewBottomEdge + (38 - _defaultLabel.viewHeight) / 2)];
    [_buttonView addSubview:_defaultLabel];
}

- (void)setDataSource:(NSDictionary *)dataSource {
    if (dataSource) {
        _dataSourceDic = [NSMutableDictionary dictionaryWithDictionary:dataSource];
        
        _nameLabel.text = dataSource[@"true_name"];
        [_nameLabel sizeToFit];
        [_nameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, 12)];
        
        _phoneLabel.text = dataSource[@"mob_phone"];
        [_phoneLabel sizeToFit];
        [_phoneLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(_nameLabel.viewRightEdge + 24, 12)];
        
        _IDCardLabel.text = dataSource[@"idcard"];
        [_IDCardLabel sizeToFit];
        [_IDCardLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, _phoneLabel.viewBottomEdge + 12)];
        
        _addressInfoLabel.viewSize = CGSizeMake(SCREEN_WIDTH - 30, 30);
        _addressInfoLabel.text = [NSString stringWithFormat:@"%@ %@", dataSource[@"area_info"], dataSource[@"address"]];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle};
        _addressInfoLabel.attributedText =[[NSAttributedString alloc] initWithString:_addressInfoLabel.text attributes:attributes];
        _addressInfoLabel.numberOfLines = 2;
        _addressInfoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_addressInfoLabel sizeToFit];
        [_addressInfoLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(15, _IDCardLabel.viewBottomEdge + 12)];
        
        if ([dataSource[@"is_default"] isEqualToString:@"1"]) {
            _isDefault = @"0";
            _setDefaultButton.selected = YES;
            _defaultLabel.text = @"默认地址";
        }
        else {
            _isDefault = @"1";
            _setDefaultButton.selected = NO;
            _defaultLabel.text = @"设为默认";
        }
    }
}

#pragma mark -- 点击事件
/**
 *  点击删除按钮
 */
- (void)ClickedDeleteButton {
    NSLog(@"点击删除按钮");
    self.clickedDeleteButton();
}
/**
 *  点击编辑按钮
 */
- (void)ClickedEditButton {
    NSLog(@"点击编辑按钮");
    self.clickedEditButton();
}
/**
 *  点击设为默认按钮
 */
- (void)ClickedSetDefaultButton:(UIButton *)sender {
    NSLog(@"点击设为默认按钮");
//    sender.selected = !sender.selected;
    if (!sender.selected) {
        _isDefault = @"1";
    }
    else {
        _isDefault = @"0";
    }
    [BaseRequset sendPOSTRequestWithBMWApi2Method:@"AddressEdit" parameters:@{@"addressId":_dataSourceDic[@"address_id"], @"true_name":_dataSourceDic[@"true_name"],  @"area_id":_dataSourceDic[@"area_id"], @"city_id":_dataSourceDic[@"city_id"], @"area_info":_dataSourceDic[@"area_info"], @"address":_dataSourceDic[@"address"], @"mob_phone":_dataSourceDic[@"mob_phone"], @"idcard":_dataSourceDic[@"idcard"], @"is_default":_isDefault} callBack:^(RequestResult result, id object) {

        if (result==RequestResultSuccess) {
            SHOW_MSG(@"修改成功");
            sender.selected = !sender.selected;
            self.btnBlock();
            if ([_isDefault isEqualToString:@"1"]) {
                _defaultLabel.text = @"默认地址";
            }
            else {
                _defaultLabel.text = @"设为默认";
            }
        }
        else {
            SHOW_MSG(@"修改失败");
//            sender.selected = !sender.selected;
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
