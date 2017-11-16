//
//  ScreenCollectionViewFlowLayout.m
//  BMW
//
//  Created by gukai on 16/3/7.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "ScreenCollectionViewFlowLayout.h"

static NSString *kDecorationReuseIdentifier = @"section_background";
//static NSString *kCellReuseIdentifier = @"view_cell";

@implementation ECCollectionViewLayoutAttributes
+ (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind
                                                                withIndexPath:(NSIndexPath *)indexPath {
    
    ECCollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForDecorationViewOfKind:decorationViewKind
                                                                                          withIndexPath:indexPath];
    /*
    if (indexPath.section%2 == 0) {
        layoutAttributes.color = [UIColor redColor];
    } else {
        layoutAttributes.color = [UIColor blueColor];
    }
     */
    layoutAttributes.color = [UIColor whiteColor];
    return layoutAttributes;
}

- (id)copyWithZone:(NSZone *)zone {
    ECCollectionViewLayoutAttributes *newAttributes = [super copyWithZone:zone];
    newAttributes.color = [self.color copyWithZone:zone];
    return newAttributes;
}

@end

@implementation ECCollectionReusableView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    ECCollectionViewLayoutAttributes *ecLayoutAttributes = (ECCollectionViewLayoutAttributes*)layoutAttributes;
    self.backgroundColor = ecLayoutAttributes.color;
}

@end

@implementation ScreenCollectionViewFlowLayout
+ (Class)layoutAttributesClass
{
    return [ECCollectionViewLayoutAttributes class];
}

- (void)prepareLayout {
    [super prepareLayout];
    [self registerClass:[ECCollectionReusableView class] forDecorationViewOfKind:kDecorationReuseIdentifier];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self. maximumInteritemSpacing = 9;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //使用系统帮我们计算好的结果。
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *allAttributes = [NSMutableArray arrayWithArray:attributes];
    //第0个cell没有上一个cell，所以从1开始
    for(int i = 1; i < [allAttributes count]; ++i) {
        //这里 UICollectionViewLayoutAttributes 的排列总是按照 indexPath的顺序来的。
        UICollectionViewLayoutAttributes *curAttr = allAttributes[i];
        UICollectionViewLayoutAttributes *preAttr = allAttributes[i - 1];
        
        NSInteger origin = CGRectGetMaxX(preAttr.frame);
        //根据  maximumInteritemSpacing 计算出的新的 x 位置
        CGFloat targetX = origin + _maximumInteritemSpacing;
        // 只有系统计算的间距大于  maximumInteritemSpacing 时才进行调整
       if (CGRectGetMinX(curAttr.frame) > targetX) {
           
            if (targetX + CGRectGetWidth(curAttr.frame) < self.collectionView.frame.size.width) {
                
                NSLog(@"%f",self.collectionViewContentSize.width);
                CGRect frame = curAttr.frame;
                frame.origin.x = targetX;
                curAttr.frame = frame;
                
                
                //CGRect frame = curAttr.frame;
                //frame.origin.x = self.sectionInset.left;
                //curAttr.frame = frame;
               
            }
       }else if (targetX + CGRectGetWidth(curAttr.frame) >= self.collectionView.frame.size.width - self.sectionInset.right || CGRectGetMinX(curAttr.frame)>=self.collectionView.frame.size.width - self.sectionInset.right){
          
           if (curAttr.representedElementKind == UICollectionElementCategoryCell) {
               curAttr.frame = CGRectMake(self.sectionInset.left, curAttr.frame.origin.y, curAttr.frame.size.width, curAttr.frame.size.height);
               NSLog(@"YES");
           }
          
       }

      
        
    }
    //CGFloat leftMargin = self.sectionInset.left;
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        

    
        
        // Look for the first item in a row
        if (attribute.representedElementKind == UICollectionElementCategoryCell
            /*&& attribute.frame.origin.x == self.sectionInset.left*/) {
            
            // Create decoration attributes
            ECCollectionViewLayoutAttributes *decorationAttributes =
            [ECCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kDecorationReuseIdentifier
                                                                        withIndexPath:attribute.indexPath];
            
            // Make the decoration view span the entire row (you can do item by item as well.  I just
            // chose to do it this way)
            decorationAttributes.frame =
            CGRectMake(0,
                       attribute.frame.origin.y-(self.sectionInset.top),
                       self.collectionViewContentSize.width,
                       self.itemSize.height+(self.minimumLineSpacing+self.sectionInset.top+self.sectionInset.bottom));
            
            // Set the zIndex to be behind the item
            decorationAttributes.zIndex = attribute.zIndex-1;
            
            // Add the attribute to the list
            [allAttributes addObject:decorationAttributes];
            
        }
    }
    return allAttributes;
    //return allAttributes;
}@end
