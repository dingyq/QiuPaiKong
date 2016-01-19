//
//  PlaceHolderTextView.h
//  QiuPai
//
//  Created by bigqiang on 15/11/19.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceHolderTextView : UITextView {
    NSString *placeholder;
    UIColor *placeholderColor;

@private
    UILabel *placeHolderLabel;
}

@property(nonatomic, retain) UILabel *placeHolderLabel;
@property(nonatomic, retain) NSString *placeholder;
@property(nonatomic, retain) UIColor *placeholderColor;

- (void)textChanged:(NSNotification*)notification;

@end
