//
//  DDTextBoxView.h
//  QiuPai
//
//  Created by bigqiang on 15/11/19.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlaceHolderTextView;

@protocol DDTextBoxViewDelegate <NSObject>

- (void)sendMessageRequest:(NSString *)comment imageArr:(NSArray *)imageArr isReply:(BOOL)isreply;
@optional
- (void)sendUserZanRequest;
@end

@interface DDTextBoxView : UIView <UITextViewDelegate>

@property (nonatomic, strong) PlaceHolderTextView *textView;
@property (nonatomic, weak) id<DDTextBoxViewDelegate> myDelegate;
@property (nonatomic, assign) BOOL isSelfEvalu;
@property (nonatomic, assign) BOOL isReply;

//- (void)setConstraints:(CGFloat)left bottom:(CGFloat)bottom width:(CGFloat)width height:(CGFloat)height;

- (NSString *)getTextStr;
- (void)displayKeyBoard;
- (void)hideKeyBoard;

@end
