//
//  UILabel+StringSize.m
//  BMW
//
//  Created by gukai on 16/3/9.
//  Copyright © 2016年 成都欧品在线电子商务有限公司. All rights reserved.
//

#import "UILabel+StringSize.h"

@implementation UILabel (StringSize)
- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}


@end
