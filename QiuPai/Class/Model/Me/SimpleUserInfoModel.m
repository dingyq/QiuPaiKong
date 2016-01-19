//
//  SimpleUserInfoModel.m
//  QiuPai
//
//  Created by bigqiang on 15/11/23.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "SimpleUserInfoModel.h"

@implementation SimpleUserInfoModel
@synthesize sortId;
@synthesize itemId;
@synthesize name;
@synthesize headPic;
@synthesize thumbHeadPic;
@synthesize sex;
@synthesize age;
@synthesize playYear;
@synthesize isConcerned;
@synthesize pubTime;


- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        self.sortId = [[attributes objectForKey:@"sortId"] integerValue];
        self.itemId = [attributes objectForKey:@"itemId"];
        self.name = [attributes objectForKey:@"name"];
        self.headPic = [attributes objectForKey:@"headPic"];
        self.thumbHeadPic = [attributes objectForKey:@"thumbHeadPic"];
        self.sex = [[attributes objectForKey:@"sex"] integerValue];
        self.age = [[attributes objectForKey:@"age"] integerValue];
        
        self.playYear = [[attributes objectForKey:@"playYear"] integerValue];
        self.isConcerned = [[attributes objectForKey:@"isConcerned"] integerValue];
        self.pubTime = [[attributes objectForKey:@"pubTime"] integerValue];
    }
    
    return self;
}

- (void)updateAttributes:(NSDictionary *)attributes {
    
}

- (float)getCellHeight {
    float height = 72.0f;
    return height;
}

- (instancetype)initWithTestData {
    NSDictionary *tmpDic = [SimpleUserInfoModel generateTestData];
    
    self = [self initWithAttributes:tmpDic];
    if (self) {
        
    }
    return self;
}

+ (NSDictionary *)generateTestData {
    NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
    
    [tmpDic setObject:[NSNumber numberWithInt:1231231] forKey:@"sortId"];
    [tmpDic setObject:@"asdfa" forKey:@"itemId"];
    [tmpDic setObject:@"vida" forKey:@"name"];
    [tmpDic setObject:@"http://img.sc115.com/uploads/sc/pic/130713/1373540809198.jpg" forKey:@"headPic"];
    [tmpDic setObject:@"http://img.sc115.com/uploads/sc/pic/130713/1373540809198.jpg" forKey:@"thumbHeadPic"];
    
    [tmpDic setObject:[NSNumber numberWithInt:1] forKey:@"sex"];
    [tmpDic setObject:[NSNumber numberWithInt:23] forKey:@"age"];
    [tmpDic setObject:[NSNumber numberWithInt:23] forKey:@"playYear"];
    [tmpDic setObject:[NSNumber numberWithInt:1] forKey:@"isConcerned"];
    
    NSNumber *time1 = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    [tmpDic setObject:time1 forKey:@"pubTime"];
    return tmpDic;
}

@end


