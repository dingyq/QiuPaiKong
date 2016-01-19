//
//  NetWorkDelegate.h
//  QiuPai
//
//  Created by bigqiang on 15/11/10.
//  Copyright © 2015年 barbecue. All rights reserved.
//


#import "NetWorkConstants.h"

@protocol NetWorkDelegate <NSObject>

- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID;
- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID;

@optional

- (void)netWorkUploadFileFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID;
- (void)netWorkUploadFileFailedCallBack:(NSError *)err withRequestID:(NetWorkRequestID)requestID;

@end