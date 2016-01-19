//
//  KnockUpResultModel.h
//  QiuPai
//
//  Created by bigqiang on 15/12/15.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KnockUpResultModel : NSObject

@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) CGFloat headSize;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *thumbPicUrl;
@property (nonatomic, copy) NSString *racName;
@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, copy) NSString *summaryBasic;
@property (nonatomic, assign) CGFloat weight;
@property (nonatomic, strong) NSArray *featuresRac;


- (instancetype)initWithAttributes:(NSDictionary *)attributes;
+ (KnockUpResultModel *)generateTestModel;


@end