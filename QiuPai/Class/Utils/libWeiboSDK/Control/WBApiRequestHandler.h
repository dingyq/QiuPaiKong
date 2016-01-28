//
//  WBApiRequestHandler.h
//  QiuPai
//
//  Created by bigqiang on 16/1/22.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBApiRequestHandler : NSObject


+ (BOOL)sendWeiboAuthRequestScope:(NSString *)viewController;

+ (BOOL)sendWeiboText:(NSString *)text;

+ (BOOL)sendWeiboImageData:(NSData *)imageData;

+ (BOOL)sendWeiboLinkURL:(NSString *)urlString
                   Title:(NSString *)title
             Description:(NSString *)description
              ThumbImage:(UIImage *)thumbImage;

@end
