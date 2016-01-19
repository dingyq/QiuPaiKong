//
//  MessageCommentModel.h
//  QiuPai
//
//  Created by bigqiang on 15/11/22.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageCommentModel : NSObject

@property (nonatomic, assign) NSInteger sortId;
@property (nonatomic, copy) NSString *commentUserId;
@property (nonatomic, copy) NSString *commentName;
@property (nonatomic, copy) NSString *commentUserURL;
@property (nonatomic, copy) NSString *commentUserThumbURL;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger playYear;
@property (nonatomic, assign) NSInteger commentTime;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *oriContent;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) NSInteger pageId;
@property (nonatomic, assign) UserMessageJumpType pageType;
@property (nonatomic, assign) NSInteger isConcerned;
@property (nonatomic, copy) NSString *oriPicUrl;
@property (nonatomic, copy) NSString *oriThumbPicUrl;
@property (nonatomic, copy) NSString *themeUrl;
@property (nonatomic, assign) ItemStatus itemStatus;


- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (void)updateAttributes:(NSDictionary *)attributes;
- (float)getMessageCellHeight;

@end