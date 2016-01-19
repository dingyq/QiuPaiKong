//
//  NSDate+DateFormatter.h
//  QiuPai
//
//  Created by bigqiang on 15/11/30.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DateFormatter)

+ (NSString *)formatSecondsSince1970ToDateString:(double)timeDoubleValue;

@end
