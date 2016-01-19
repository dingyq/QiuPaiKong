//
//  CircleEditView.h
//  QiuPai
//
//  Created by bigqiang on 15/11/20.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceHolderTextView.h"

@protocol PhotoDisplayViewDelegate <NSObject>
- (void)openPhotoPickerView:(id)sender;
- (void)photoTapAction:(UITapGestureRecognizer *)tapGesture;
@end

@interface CircleEditView : UIView

@property (nonatomic, strong) PlaceHolderTextView *textView;
@property (nonatomic, weak) id<PhotoDisplayViewDelegate> delegate;

- (void)reloadImageData:(NSArray *)imageArr;

- (void)hideKeyBoard;

@end
