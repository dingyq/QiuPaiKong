//
//  NoDataTipView.h
//  QiuPai
//
//  Created by bigqiang on 15/12/18.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDataTipView : UIView

@property (nonatomic, copy) NSString *tipText;

- (instancetype)initWithFrame:(CGRect)frame tipStr:(NSString *)tipStr;

- (void)hide;

- (void)show;

- (void)showWithTip:(NSString *)tip;

@end
