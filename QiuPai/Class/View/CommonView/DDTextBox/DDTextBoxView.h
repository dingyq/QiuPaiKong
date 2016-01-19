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
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, weak) id<DDTextBoxViewDelegate> myDelegate;
@property (nonatomic, assign) BOOL isSelfEvalu;
@property (nonatomic, assign) BOOL isReply;
@property (nonatomic, assign) BOOL isUserLike;

@property (nonatomic, assign) BOOL isShowLike;

- (NSString *)getTextStr;
- (void)displayKeyBoard;
- (void)hideKeyBoard;
- (void)resetViewWithTheKeyboardState:(BOOL)isDisplay;

@end
