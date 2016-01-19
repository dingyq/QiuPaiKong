//
//  ShareSheetItem.m
//  QiuPai
//
//  Created by bigqiang on 15/12/22.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "ShareSheetItem.h"

@implementation ShareSheetItem

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect titleRect = CGRectMake(5, CGRectGetHeight(self.bounds) - 40, CGRectGetWidth(self.bounds)-10, 40);
    return titleRect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect imageRect = self.bounds;
    imageRect.size.height = CGRectGetWidth(self.bounds);
    return imageRect;
}

- (void)setTitle:(NSString *)title image:(UIImage *)image {
    [self setTitle:title forState:UIControlStateNormal];
//    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self setTitleColor:Gray51Color forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateNormal];
}

@end
