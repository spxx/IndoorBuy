//
//  HomePageFlowLayout.h
//  BMW
//
//  Created by rr on 16/3/9.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes
@property (nonatomic, strong) UIColor *color;
@end

@interface HPCollectionReusableView : UICollectionReusableView

@end


@interface HomePageFlowLayout : UICollectionViewFlowLayout

@property (nonatomic) CGFloat maximumInteritemSpacing;

@end
