//
//  HomePageFlowLayout.m
//  BMW
//
//  Created by rr on 16/3/9.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "HomePageFlowLayout.h"

static NSString *kDecorationReuseIdentifier = @"section_background";
//static NSString *kCellReuseIdentifier = @"view_cell";

@implementation HPCollectionViewLayoutAttributes
+ (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind
                                                                withIndexPath:(NSIndexPath *)indexPath {
    
    HPCollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForDecorationViewOfKind:decorationViewKind
                                                                                          withIndexPath:indexPath];
    
//    if (indexPath.section%2 == 0) {
//        layoutAttributes.color = [UIColor redColor];
//    } else {
//        layoutAttributes.color = [UIColor blueColor];
//    }
    
    layoutAttributes.color = [UIColor whiteColor];
    return layoutAttributes;
}

- (id)copyWithZone:(NSZone *)zone {
    HPCollectionViewLayoutAttributes *newAttributes = [super copyWithZone:zone];
    newAttributes.color = [self.color copyWithZone:zone];
    return newAttributes;
}

@end

@implementation HPCollectionReusableView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    HPCollectionViewLayoutAttributes *ecLayoutAttributes = (HPCollectionViewLayoutAttributes*)layoutAttributes;
    self.backgroundColor = ecLayoutAttributes.color;
}

@end


@implementation HomePageFlowLayout
+ (Class)layoutAttributesClass
{
    return [HPCollectionViewLayoutAttributes class];
}

- (void)prepareLayout {
    [super prepareLayout];
    [self registerClass:[HPCollectionReusableView class] forDecorationViewOfKind:kDecorationReuseIdentifier];
}

//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray *allAttributes = [NSMutableArray arrayWithArray:attributes];
        // Look for the first item in a row
            for (UICollectionViewLayoutAttributes *attribute in attributes) {
                if (attribute.representedElementKind == UICollectionElementCategoryCell
                    && attribute.indexPath.section>1) {
                    // Create decoration attributes
                    HPCollectionViewLayoutAttributes *decorationAttributes =
                    [HPCollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kDecorationReuseIdentifier
                                                                                withIndexPath:attribute.indexPath];
                    
                    // Make the decoration view span the entire row (you can do item by item as well.  I just
                    // chose to do it this way)
                    decorationAttributes.frame =
                    CGRectMake(0,
                               attribute.frame.origin.y-(self.sectionInset.top),
                               self.collectionViewContentSize.width,223+8*W_ABCW);
//                    self.itemSize.height+(self.minimumLineSpacing+self.sectionInset.top+self.sectionInset.bottom)
                    
                    // Set the zIndex to be behind the item
                    decorationAttributes.zIndex = attribute.zIndex-1;
                    
                    // Add the attribute to the list
                    [allAttributes addObject:decorationAttributes];
                    
                }
    }
    return allAttributes;
}
- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound
{
    return YES;
}

@end
