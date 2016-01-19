//
//  UserMessageModel.h
//  QiuPai
//
//  Created by bigqiang on 15/12/10.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserMessageModel : NSObject

@property (nonatomic, assign) NSInteger sortId;
@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger isConcerned;
@property (nonatomic, copy) NSString *messageName;
@property (nonatomic, assign) NSInteger messageTime;
@property (nonatomic, copy) NSString *messageUserId;
@property (nonatomic, copy) NSString *messageUserURL;
@property (nonatomic, copy) NSString *messageUserThumbURL;
@property (nonatomic, copy) NSString *oriContent;
@property (nonatomic, assign) NSInteger playYear;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, copy) NSString *toMessageName;
@property (nonatomic, copy) NSString *toMessageUserId;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (void)updateAttributes:(NSDictionary *)attributes;

- (CGFloat)getUserMessageCellHeight;

@end



