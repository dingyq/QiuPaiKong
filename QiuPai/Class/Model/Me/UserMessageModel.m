//
//  UserMessageModel.m
//  QiuPai
//
//  Created by bigqiang on 15/12/10.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "UserMessageModel.h"

@implementation UserMessageModel


- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        self.sortId = [[attributes objectForKey:@"sortId"] integerValue];
        self.itemId = [[attributes objectForKey:@"itemId"] integerValue];
        self.content = [attributes objectForKey:@"content"];
        self.isConcerned = [[attributes objectForKey:@"isConcerned"] integerValue];
        self.messageName = [attributes objectForKey:@"messageName"];
        self.messageTime = [[attributes objectForKey:@"messageTime"] integerValue];
        self.messageUserId = [attributes objectForKey:@"messageUserId"];
        self.messageUserURL = [attributes objectForKey:@"messageUserURL"];
        self.messageUserThumbURL = [attributes objectForKey:@"messageUserThumbURL"];
        self.oriContent = [attributes objectForKey:@"oriContent"];
        self.playYear = [[attributes objectForKey:@"playYear"] integerValue];
        self.sex = [[attributes objectForKey:@"sex"] integerValue];
        self.toMessageName = [attributes objectForKey:@"toMessageName"];
        self.toMessageUserId = [attributes objectForKey:@"toMessageUserId"];
    }
    return self;
}

- (void)updateAttributes:(NSDictionary *)attributes {
    
}

- (CGFloat)getUserMessageCellHeight {
    float height = 42.0f;
    CGRect newNameFrame = [self.content boundingRectWithSize:CGSizeMake(kFrameWidth - 46-19, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    height += newNameFrame.size.height;
    return height;
}

@end
