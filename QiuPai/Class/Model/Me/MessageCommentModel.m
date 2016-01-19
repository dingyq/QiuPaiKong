//
//  MessageCommentModel.m
//  QiuPai
//
//  Created by bigqiang on 15/11/22.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "MessageCommentModel.h"

@interface MessageCommentModel() <NSCopying>

@end

@implementation MessageCommentModel

@synthesize sortId;
@synthesize commentUserId;
@synthesize commentName;
@synthesize commentUserURL;
@synthesize commentUserThumbURL;
@synthesize sex;
@synthesize playYear;
@synthesize commentTime;
@synthesize content;
@synthesize oriContent;
@synthesize userId;
@synthesize pageId;
@synthesize pageType;
@synthesize isConcerned;
@synthesize oriPicUrl;
@synthesize oriThumbPicUrl;
@synthesize themeUrl;

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        self.sortId = [[attributes objectForKey:@"sortId"] integerValue];
        self.commentUserId = [attributes objectForKey:@"commentUserId"];
        self.commentName = [attributes objectForKey:@"commentName"];
        self.commentUserURL = [attributes objectForKey:@"commentUserURL"];
        self.commentUserThumbURL = [attributes objectForKey:@"commentUserThumbURL"];
        self.sex = [[attributes objectForKey:@"sex"] integerValue];
        self.playYear = [[attributes objectForKey:@"playYear"] integerValue];
        self.commentTime = [[attributes objectForKey:@"commentTime"] integerValue];
        self.content = [attributes objectForKey:@"content"];
        self.oriContent = [attributes objectForKey:@"oriContent"];
        self.userId = [attributes objectForKey:@"userId"];
        self.pageId = [[attributes objectForKey:@"pageId"] integerValue];
        self.pageType = [[attributes objectForKey:@"pageType"] integerValue];
        self.isConcerned = [[attributes objectForKey:@"isConcerned"] integerValue];
        self.oriPicUrl = [attributes objectForKey:@"oriPicUrl"];
        self.oriThumbPicUrl = [attributes objectForKey:@"oriThumbPicUrl"];
        self.themeUrl = [attributes objectForKey:@"themeUrl"];
        self.itemStatus = [[attributes objectForKey:@"itemStatus"] integerValue];
    }
    return self;
}

- (void)updateAttributes:(NSDictionary *)attributes {
    
}

- (float)getMessageCellHeight {
    float height = 120.0f;
    CGRect newNameFrame = [self.content boundingRectWithSize:CGSizeMake(kFrameWidth - 46-19, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FS_PL_CONTENT]} context:nil];
    if (newNameFrame.size.height > 20.0f) {
        height = height+FS_PL_CONTENT*2+10;
    } else {
        height += FS_PL_CONTENT;
    }
    return height;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    MessageCommentModel *tmpModel = [[self class] allocWithZone:zone];
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
    tmpModel.userId = [self.userId copy];
    tmpModel.pageId = self.pageId;
    tmpModel.pageType = self.pageType;
    tmpModel.oriPicUrl = [self.oriPicUrl copy];
    tmpModel.oriThumbPicUrl = [self.oriThumbPicUrl copy];
    tmpModel.isConcerned = self.isConcerned;
    tmpModel.themeUrl = [self.themeUrl copy];
    return tmpModel;
}
@end
