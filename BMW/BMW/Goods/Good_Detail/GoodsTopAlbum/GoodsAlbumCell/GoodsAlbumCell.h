//
//  GoodsAlbumCell.h
//  BMW
//
//  Created by gukai on 16/3/8.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsAlbumCellDelegate <NSObject>

@optional
-(void)GoodsAlbumCellClickImageTapgesture:(UIGestureRecognizer *)sender index:(NSIndexPath *)index;

@end

@interface GoodsAlbumCell : UICollectionViewCell
@property(nonatomic,copy)NSString * goodImageUrl;
@property(nonatomic,copy)NSArray * images;
@property(nonatomic,strong)UIImageView * goodImageView;
@property(nonatomic,assign)id<GoodsAlbumCellDelegate> delegate;
@property(nonatomic,strong)NSIndexPath * index;
@end
