//
//  KnockUpResultModel.m
//  QiuPai
//
//  Created by bigqiang on 15/12/15.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "KnockUpResultModel.h"

@implementation KnockUpResultModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.balance = [attributes objectForKey:@"balance"];
    self.brand = [attributes objectForKey:@"brand"];
    self.desc = [attributes objectForKey:@"desc"];
    self.headSize = [[attributes objectForKey:@"headSize"] floatValue];
    self.picUrl = [attributes objectForKey:@"picUrl"];
    self.thumbPicUrl = [attributes objectForKey:@"thumbPicUrl"];    
    self.racName = [attributes objectForKey:@"racName"];
    self.rank = [[attributes objectForKey:@"rank"] integerValue];
    self.summaryBasic = [attributes objectForKey:@"summaryBasic"];
    self.weight = [[attributes objectForKey:@"weight"] floatValue];
    self.featuresRac = [attributes objectForKey:@"featuresRac"];
    

    return self;
}

+ (KnockUpResultModel *)generateTestModel {
    KnockUpResultModel *tmpModel = [[KnockUpResultModel alloc] init];
    tmpModel.balance = @"4psHL";
    tmpModel.brand = @"百宝力";
    tmpModel.desc = @"质保20年";
    tmpModel.headSize = 120;
    tmpModel.picUrl = @"";
    tmpModel.thumbPicUrl = @"";
    tmpModel.racName = @"babolat ps200";
    tmpModel.rank = 78;
    tmpModel.summaryBasic = @"耐打，上旋效果好";
    tmpModel.weight = 310;
    tmpModel.featuresRac = @[[NSNumber numberWithInt:74], [NSNumber numberWithInt:33], [NSNumber numberWithInt:72], [NSNumber numberWithInt:40], [NSNumber numberWithInt:45]];
    
    
    return tmpModel;
}

@end
