//
//  NSString+MD5Addition.m
//  QiuPai
//
//  Created by bigqiang on 16/1/22.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import "NSString+MD5Addition.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5Addition)

- (NSString *)selfDefineMD5Encryption {
    if(self == nil || [self length] == 0)
        return nil;
    NSString *addKey = @"dick";
    
//    NSString *outputStr = @"";
    NSMutableString *originStr = [[NSMutableString alloc] initWithString:self];
    for (NSInteger i = 0; i < addKey.length; i++) {
        [originStr appendString:[addKey substringWithRange:NSMakeRange(i, 1)]];
        NSLog(@"originStr is %@", originStr);
        originStr = [[NSMutableString alloc] initWithString:[originStr stringFromMD5]];
    }
    return originStr;
}

- (NSString *)stringFromMD5 {
    if(self == nil || [self length] == 0)
        return nil;
    const char *value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}

@end
