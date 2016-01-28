//
//  WBApiManager.h
//  QiuPai
//
//  Created by bigqiang on 16/1/22.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"

@protocol WBApiManagerDelegate <NSObject>

@optional

- (void)wbApiManagerDidRecvMessageResponse:(WBSendMessageToWeiboResponse *)response;

- (void)wbApiManagerDidRecvAuthResponse:(WBAuthorizeResponse *)response;

- (void)wbApiManagerDidRecvPaymentResponse:(WBPaymentResponse *)response;

- (void)wbApiManagerDidRecvRecommendResponse:(WBSDKAppRecommendResponse *)response;

@end


@interface WBApiManager : NSObject<WeiboSDKDelegate>

@property (nonatomic, weak) id<WBApiManagerDelegate> delegate;

+ (instancetype)sharedManager;

@end
