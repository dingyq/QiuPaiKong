//
//  QQSdkCall.h
//  QiuPai
//
//  Created by bigqiang on 16/1/5.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "QQSdkCall.h"


@interface QQSdkCall : NSObject<TencentSessionDelegate, TencentApiInterfaceDelegate, TCAPIRequestDelegate>
+ (QQSdkCall *)getInstance;
+ (void)resetSDK;

+ (void)showInvalidTokenOrOpenIDMessage;
@property (nonatomic, retain)TencentOAuth *oauth;
@property (nonatomic, retain)NSMutableArray* photos;
@property (nonatomic, retain)NSMutableArray* thumbPhotos;
@end