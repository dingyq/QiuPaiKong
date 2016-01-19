//
//  SimpleUserInfoModel.h
//  QiuPai
//
//  Created by bigqiang on 15/11/23.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleUserInfoModel : NSObject

@property (nonatomic, assign) NSInteger sortId;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *headPic;
@property (nonatomic, copy) NSString *thumbHeadPic;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger playYear;
@property (nonatomic, assign) NSInteger isConcerned;
@property (nonatomic, assign) NSInteger pubTime;


- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (void)updateAttributes:(NSDictionary *)attributes;
- (float)getCellHeight;

- (instancetype)initWithTestData;

@end
