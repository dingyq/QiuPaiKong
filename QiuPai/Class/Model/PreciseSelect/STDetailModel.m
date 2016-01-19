//
//  STDetailModel.m
//  QiuPai
//
//  Created by bigqiang on 15/12/9.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "STDetailModel.h"

@implementation STDetailModel


//@property (nonatomic, assign) NSInteger commentNum;
//@property (nonatomic, copy) NSString *contDataHtml;
//@property (nonatomic, copy) NSString *content;
//@property (nonatomic, assign) NSInteger isLike;
//@property (nonatomic, assign) NSInteger likeNum;
//
//@property (nonatomic, copy) NSString *pic;
//@property (nonatomic, copy) NSString *thumbPic;
//@property (nonatomic, assign) NSInteger pubTime;
//@property (nonatomic, assign) NSInteger shareNum;
//@property (nonatomic, assign) NSInteger themeId;
//@property (nonatomic, copy) NSString *title;

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        self.commentNum = [[attributes objectForKey:@"commentNum"] integerValue];
        self.contDataHtml = [attributes objectForKey:@"contDataHtml"];
        self.content = [attributes objectForKey:@"content"];
        self.isLike = [[attributes objectForKey:@"isLike"] integerValue];
        self.likeNum = [[attributes objectForKey:@"likeNum"] integerValue];
        
        self.isPraised = [[attributes objectForKey:@"isPraised"] integerValue];
        self.praiseNum = [[attributes objectForKey:@"praiseNum"] integerValue];
        
        self.pic = [attributes objectForKey:@"pic"];
        self.thumbPic = [attributes objectForKey:@"thumbPic"];
        self.title = [attributes objectForKey:@"title"];

        self.pubTime = [[attributes objectForKey:@"pubTime"] integerValue];
        self.shareNum = [[attributes objectForKey:@"shareNum"] integerValue];
        self.themeId = [[attributes objectForKey:@"themeId"] integerValue];
    }
    return self;
}

- (void)updateAttributes:(NSDictionary *)attributes {
    
}

@end
