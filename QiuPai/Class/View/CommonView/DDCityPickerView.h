//
//  DDCityPickerView.h
//  QiuPai
//
//  Created by bigqiang on 15/12/18.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDTLocation.h"

#import "DDPickerViewDelegate.h"

typedef NS_ENUM(NSInteger, DDAreaPickerStyle) {
    DDAreaPickerWithStateAndCity,
    DDAreaPickerWithStateAndCityAndDistrict
};

@interface DDCityPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
@property (assign, nonatomic) id<DDPickerViewDelegate> delegate;

@property (strong, nonatomic) UIPickerView *locatePicker;
@property (strong, nonatomic) DDTLocation *locate;
@property (nonatomic) DDAreaPickerStyle pickerStyle;

- (instancetype)initWithFrame:(CGRect)frame style:(DDAreaPickerStyle)pickerStyle delegate:(id<DDPickerViewDelegate>)delegate;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;

@end
