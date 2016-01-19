//
//  DDPickerViewDelegate.h
//  QiuPai
//
//  Created by bigqiang on 15/12/20.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DDPickerViewDelegate <NSObject>

@optional
- (void)pickerDidChaneStatus:(UIView *)picker;

@end
