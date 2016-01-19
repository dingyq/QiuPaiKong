//
//  BadNetTipView.h
//  QiuPai
//
//  Created by bigqiang on 15/12/18.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RetryConnectNetEvent)(UIButton *sender);

@interface BadNetTipView : UIView

@property(nonatomic, copy) RetryConnectNetEvent retryEvent;

- (instancetype)initWithFrame:(CGRect)frame withRetryEvent:(RetryConnectNetEvent)event;

- (void)hide;

- (void)show;

@end
