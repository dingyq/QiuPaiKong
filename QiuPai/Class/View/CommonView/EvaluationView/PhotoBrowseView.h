//
//  PhotoBrowseView.h
//  QiuPai
//
//  Created by bigqiang on 15/11/16.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoBrowseView : UIView <UIScrollViewDelegate>

- (instancetype)initWithUrlPathArr:(NSArray *)pathArr thumbImageArr:(NSArray *)thumbPathArr thumbImages:(NSArray *)thumbImages index:(long)index fromRect:(CGRect)rect;
@end
