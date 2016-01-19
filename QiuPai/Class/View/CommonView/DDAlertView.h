//
//  DDAlertView.h
//  QiuPai
//
//  Created by bigqiang on 15/12/31.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MenuItemClick)(NSInteger btnIndex);

@interface DDAlertView : UIView

- (instancetype)initWithTitle:(NSString *)title itemTitles:(NSArray *)titles itemTags:(NSArray *)tags;

- (void)showWithClickBlock:(MenuItemClick)clickBlock;

@end
