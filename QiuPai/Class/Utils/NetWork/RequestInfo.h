//
//  RequestInfo.h
//  QiuPai
//
//  Created by bigqiang on 15/11/10.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestInfo : NSObject

@property (nonatomic, weak) id<NetWorkDelegate> delegate;
@property (nonatomic, assign) NetWorkRequestID requestID;
@property (nonatomic, assign) HttpRequestMethod method;
@property (nonatomic, strong) id userinfo;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong) NSMutableDictionary *jsonDict;
@property (nonatomic, strong) NSData *imgData;
@property (nonatomic, copy) NSString *fileName;
@property (readwrite, nonatomic, copy) void (^uploadProgress)(NSUInteger bytes, long long totalBytes, long long totalBytesExpected);

@end
