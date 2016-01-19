//
//  UserHomeInfoModel.m
//  QiuPai
//
//  Created by bigqiang on 15/12/10.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "UserHomeInfoModel.h"

@implementation UserHomeInfoModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        self.userId = [attributes objectForKey:@"userId"];
        self.headPic = [attributes objectForKey:@"headPic"];
        self.thumbHeadPic = [attributes objectForKey:@"thumbHeadPic"];
        self.nick = [attributes objectForKey:@"nick"];
        self.sex = [[attributes objectForKey:@"sex"] integerValue];
        
        self.age = [[attributes objectForKey:@"age"] integerValue];
        self.playYear = [[attributes objectForKey:@"playYear"] integerValue];
        self.racquet = [attributes objectForKey:@"racquet"];
        self.region = [attributes objectForKey:@"region"];
        
        self.messageNum = [[attributes objectForKey:@"messageNum"] integerValue];
        self.concernNum = [[attributes objectForKey:@"concernNum"] integerValue];
        self.isConcerned = [[attributes objectForKey:@"isConcerned"] integerValue];
    }
    return self;
}

- (void)updateAttributes:(NSDictionary *)attributes {
    
}


- (NSString *)region {
    return (_region && ![_region isEqualToString:@""])?_region:@"暂无";
}

- (NSString *)racquet {
    return (_racquet && ![_racquet isEqualToString:@""])?_racquet:@"暂无";
}

@end
