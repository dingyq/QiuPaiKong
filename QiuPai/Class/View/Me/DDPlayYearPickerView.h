//
//  DDPlayYearPickerView.h
//  QiuPai
//
//  Created by bigqiang on 15/12/20.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPickerViewDelegate.h"

typedef NS_ENUM(NSInteger, DDPickerStyle) {
    DDPickerStylePlayYear,
    DDPickerStyleSelfEvalu,
};

@interface DDPlayYearPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
@property (assign, nonatomic) id<DDPickerViewDelegate> delegate;
@property (strong, nonatomic) UIPickerView *playYearPicker;
@property (copy, nonatomic) NSString *playYear;

@property (nonatomic) DDPickerStyle pickerStyle;
@property (assign, nonatomic) NSInteger selfEvalu;

- (instancetype)initWithFrame:(CGRect)frame pickerStyle:(DDPickerStyle)stype delegate:(id<DDPickerViewDelegate>)delegate;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;

@end
