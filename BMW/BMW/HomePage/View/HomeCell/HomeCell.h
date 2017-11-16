//
//  HomeCell.h
//  BMW
//
//  Created by gukai on 16/3/3.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsListModle.h"
@interface HomeCell : UICollectionViewCell
@property(nonatomic,copy)NSMutableDictionary * dataDic;
@property(nonatomic,strong)GoodsListModle * modle;
@property(nonatomic,strong)NSDictionary *adverDic;
@end
