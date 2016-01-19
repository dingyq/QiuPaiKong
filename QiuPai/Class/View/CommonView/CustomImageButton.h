//
//  CustomImageButton.h
//  QiuPai
//
//  Created by bigqiang on 16/1/17.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomImageButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame norImage:(NSString *)norImage selImage:(NSString *)selImage imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets title:(NSString *)title tip:(NSString *)tip;

- (void)setTipColor:(UIColor *)color;

- (void)setTip:(NSString *)tip;

- (void)setTipFont:(CGFloat)pointSize;

- (void)setTitle:(NSString *)title;

- (void)setTitleLabelColor:(UIColor *)color;

- (void)setTitleLFont:(CGFloat)pointSize;


@end


