//
//  UILabel+FontAppearance.m
//  QiuPai
//
//  Created by bigqiang on 15/12/20.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "UILabel+FontAppearance.h"

@implementation UILabel (FontAppearance)

-(void)setAppearanceFont:(UIFont *)font {
    if (font)
        [self setFont:font];
}

-(UIFont *)appearanceFont {
    return self.font;
}

@end
