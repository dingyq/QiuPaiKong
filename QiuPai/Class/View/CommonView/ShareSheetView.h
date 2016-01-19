//
//  ShareSheetView.h
//  QiuPai
//
//  Created by bigqiang on 15/12/22.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ClickBlock)(NSInteger btnIndex);
typedef void(^CancelBlock)(void);

@interface ShareSheetView : UIView

//- (instancetype)initWithTitles:(NSArray *)titles iconNames:(NSArray *)iconNames;
- (instancetype)initWithTitleAndIcons:(NSArray *)config;

- (void)showActionSheetWithClickBlock:(ClickBlock)clickBlock cancelBlock:(CancelBlock)cancelBlock;

@end
