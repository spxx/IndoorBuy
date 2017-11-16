//
//  GoodsAlbumCell.m
//  BMW
//
//  Created by gukai on 16/3/8.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "GoodsAlbumCell.h"

@interface GoodsAlbumCell ()

@end
@implementation GoodsAlbumCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}
-(void)initUserInterface
{
    _goodImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    _goodImageView.backgroundColor = [UIColor grayColor];
//    [_goodImageView sd_setImageWithURL:[NSURL URLWithString:_goodImageUrl] placeholderImage:nil];
    _goodImageView.userInteractionEnabled = YES;
    [self addSubview:_goodImageView];
    
    
    UITapGestureRecognizer * tap  =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_goodImageView addGestureRecognizer:tap];
    
}
-(void)setGoodImageUrl:(NSString *)goodImageUrl
{
     _goodImageUrl = goodImageUrl;
    

}
-(void)tapAction:(UIGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(GoodsAlbumCellClickImageTapgesture:index:)]) {
        [self.delegate GoodsAlbumCellClickImageTapgesture:gesture index:self.index];
    }
}
@end
