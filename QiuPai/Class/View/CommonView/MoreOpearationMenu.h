//
//  MoreOpearationMenu.h
//  QiuPai
//
//  Created by bigqiang on 15/12/29.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MenuItemClick)(NSInteger btnIndex);
typedef void (^MenuItemCancel)(void);

@interface MoreOpearationMenu : UIView

- (instancetype)initWithTitles:(NSArray *)titles itemTags:(NSArray *)tags;

- (void)showActionSheetWithClickBlock:(MenuItemClick)clickBlock cancelBlock:(MenuItemCancel)cancelBlock;

@end
