//
//  WBApiManager.m
//  QiuPai
//
//  Created by bigqiang on 16/1/22.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import "WBApiManager.h"

@implementation WBApiManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WBApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WBApiManager alloc] init];
    });
    return instance;
}

#pragma -mark WeiboSDKDelegate
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(wbApiManagerDidRecvMessageResponse:)]) {
            WBSendMessageToWeiboResponse *messageResp = (WBSendMessageToWeiboResponse *)response;
            [_delegate wbApiManagerDidRecvMessageResponse:messageResp];
        }
//        NSString *title = NSLocalizedString(@"发送结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
//        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
//        if (accessToken)
//        {
//            self.wbtoken = accessToken;
//        }
//        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
//        if (userID) {
//            self.wbCurrentUserID = userID;
//        }
//        [alert show];
    } else if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(wbApiManagerDidRecvAuthResponse:)]) {
            WBAuthorizeResponse *authResp = (WBAuthorizeResponse *)response;
            [_delegate wbApiManagerDidRecvAuthResponse:authResp];
        }
//        NSString *title = NSLocalizedString(@"认证结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        
//        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
//        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
//        self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
//        [alert show];
    } else if ([response isKindOfClass:WBPaymentResponse.class]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(wbApiManagerDidRecvPaymentResponse:)]) {
            WBPaymentResponse *payResp = (WBPaymentResponse *)response;
            [_delegate wbApiManagerDidRecvPaymentResponse:payResp];
        }
        
//        NSString *title = NSLocalizedString(@"支付结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.payStatusCode: %@\nresponse.payStatusMessage: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBPaymentResponse *)response payStatusCode], [(WBPaymentResponse *)response payStatusMessage], NSLocalizedString(@"响应UserInfo数据", nil),response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        [alert show];
    } else if([response isKindOfClass:WBSDKAppRecommendResponse.class]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(wbApiManagerDidRecvRecommendResponse:)]) {
            WBSDKAppRecommendResponse *recommendResp = (WBSDKAppRecommendResponse *)response;
            [_delegate wbApiManagerDidRecvRecommendResponse:recommendResp];
        }
//        NSString *title = NSLocalizedString(@"邀请结果", nil);
//        NSString *message = [NSString stringWithFormat:@"accesstoken:\n%@\nresponse.StatusCode: %d\n响应UserInfo数据:%@\n原请求UserInfo数据:%@",[(WBSDKAppRecommendResponse *)response accessToken],(int)response.statusCode,response.userInfo,response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        [alert show];
    }
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

@end
