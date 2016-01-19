//
//  QQHelper.h
//  QiuPai
//
//  Created by bigqiang on 16/1/5.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, QQShareScene) {
    QQShareScene_Session = 1,
    QQShareScene_QZone = 2,
};

typedef void (^QQCallBack)(QQApiSendResultCode);

@interface QQHelper : NSObject

//+ (void)handleSendResult:(QQApiSendResultCode)sendResult;

// 分享图片
+ (void)shareImageMsg:(NSString *)title description:(NSString *)desc scene:(QQShareScene)scene callBack:(QQCallBack)successHandler;

// 分享本地图片链接
+ (void)sendNewsMessageWithLocalImage:(UIImage *)image pageUrl:(NSString *)pageUrl title:(NSString *)title description:(NSString *)desc scene:(QQShareScene)scene callBack:(QQCallBack)successHandler;

// 分享网络图片链接
+ (void)sendNewsMessageWithNetworkImage:(NSString *)imageUrl pageUrl:(NSString *)pageUrl title:(NSString *)title description:(NSString *)desc scene:(QQShareScene)scene callBack:(QQCallBack)successHandler;

@end
