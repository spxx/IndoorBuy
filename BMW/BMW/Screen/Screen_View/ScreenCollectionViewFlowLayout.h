//
//  ScreenCollectionViewFlowLayout.h
//  BMW
//
//  Created by gukai on 16/3/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes
@property (nonatomic, strong) UIColor *color;
@end

@interface ECCollectionReusableView : UICollectionReusableView
@end

@interface ScreenCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic) CGFloat maximumInteritemSpacing;
@end
