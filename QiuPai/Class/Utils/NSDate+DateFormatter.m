//
//  NSDate+DateFormatter.m
//  QiuPai
//
//  Created by bigqiang on 15/11/30.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "NSDate+DateFormatter.h"

@implementation NSDate (DateFormatter)

+ (NSString *)formatSecondsSince1970ToDateString:(double)timeDoubleValue {
    //    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //    NSInteger interval = [zone secondsFromGMTForDate:date];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeDoubleValue];
    NSDate *localeDate = [date dateByAddingTimeInterval:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
   return [dateFormatter stringFromDate:localeDate];
}

@end
