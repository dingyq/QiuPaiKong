//
//  STCommentModel.m
//  QiuPai
//
//  Created by bigqiang on 15/12/9.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "STCommentModel.h"

@implementation STCommentModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        self.sortId = [[attributes objectForKey:@"sortId"] integerValue];
        self.itemId = [[attributes objectForKey:@"itemId"] integerValue];
        self.commentUserId = [attributes objectForKey:@"commentUserId"];
        self.commentName = [attributes objectForKey:@"commentName"];
        self.toCommentName = [attributes objectForKey:@"toCommentName"];
        self.toCommentUserId = [attributes objectForKey:@"toCommentUserId"];
        self.commentUserURL = [attributes objectForKey:@"commentUserURL"];
        self.commentUserThumbURL = [attributes objectForKey:@"commentUserThumbURL"];
        self.sex = [[attributes objectForKey:@"sex"] integerValue];
        self.playYear = [[attributes objectForKey:@"playYear"] integerValue];
        self.commentTime = [[attributes objectForKey:@"commentTime"] integerValue];
        self.content = [attributes objectForKey:@"content"];
        self.oriContent = [attributes objectForKey:@"oriContent"];
        self.isConcerned = [[attributes objectForKey:@"isConcerned"] integerValue];
    }
    return self;
}

- (void)updateAttributes:(NSDictionary *)attributes {
    
}

- (float)getCommentCellHeight {
    float height = 42.0f;
    CGRect newNameFrame = [self.content boundingRectWithSize:CGSizeMake(kFrameWidth - 46-19, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    height += newNameFrame.size.height;
    return height;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    STCommentModel *tmpModel = [[self class] allocWithZone:zone];
    tmpModel.sortId = self.sortId;
    tmpModel.commentUserId = [self.commentUserId copy];
    tmpModel.commentName = [self.commentName copy];
    tmpModel.commentUserURL = [self.commentUserURL copy];
    tmpModel.commentUserThumbURL = self.commentUserThumbURL;
    tmpModel.sex = self.sex;
    tmpModel.playYear = self.playYear;
    tmpModel.commentTime = self.commentTime;
    tmpModel.content = [self.content copy];
    tmpModel.oriContent = [self.oriContent copy];
    tmpModel.toCommentUserId = [self.toCommentUserId copy];
    tmpModel.toCommentName = [self.toCommentName copy];
    tmpModel.isConcerned = self.isConcerned;
    
    return tmpModel;
}

- (instancetype)initWithTestData {
    NSDictionary *tmpDic = [STCommentModel generateTestData];
    
    self = [self initWithAttributes:tmpDic];
    if (self) {
        
    }
    return self;
}

+ (NSDictionary *)generateTestData {
    NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
    
    [tmpDic setObject:[NSNumber numberWithInt:123] forKey:@"sortId"];
    [tmpDic setObject:@"hjh123" forKey:@"commentUserId"];
    [tmpDic setObject:@"jason" forKey:@"commentName"];
    [tmpDic setObject:@"hjh123" forKey:@"toCommentUserId"];
    [tmpDic setObject:@"jason" forKey:@"toCommentName"];
    [tmpDic setObject:@"http://f.hiphotos.baidu.com/image/pic/item/2e2eb9389b504fc2906eb86ee6dde71190ef6da3.jpg" forKey:@"commentUserURL"];
    [tmpDic setObject:@"http://f.hiphotos.baidu.com/image/pic/item/2e2eb9389b504fc2906eb86ee6dde71190ef6da3.jpg" forKey:@"commentUserThumbURL"];
    
    [tmpDic setObject:[NSNumber numberWithInt:1] forKey:@"sex"];
    [tmpDic setObject:[NSNumber numberWithInt:4] forKey:@"playYear"];
    NSNumber *time1 = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    [tmpDic setObject:time1 forKey:@"commentTime"];
    [tmpDic setObject:@"留言内容" forKey:@"content"];
    [tmpDic setObject:@"被留言的内容" forKey:@"oriContent"];
    [tmpDic setObject:[NSNumber numberWithInt:1] forKey:@"isConcerned"];
    
    return  tmpDic;
}



@end
