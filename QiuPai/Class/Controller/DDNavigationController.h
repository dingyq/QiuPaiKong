//
//  DDNavigationController.h
//  QiuPai
//
//  Created by bigqiang on 15/12/10.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDNavigationController : UINavigationController

@property(nonatomic, strong) UIView *alphaView;

- (void)addAlphaView;

@end
