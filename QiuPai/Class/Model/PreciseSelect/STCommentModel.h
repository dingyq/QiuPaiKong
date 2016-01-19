//
//  STCommentModel.h
//  QiuPai
//
//  Created by bigqiang on 15/12/9.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STCommentModel : NSObject
@property (nonatomic, assign) NSInteger sortId;
@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, copy) NSString *commentUserId;
@property (nonatomic, copy) NSString *commentName;
@property (nonatomic, copy) NSString *toCommentUserId;
@property (nonatomic, copy) NSString *toCommentName;
@property (nonatomic, copy) NSString *commentUserURL;
@property (nonatomic, copy) NSString *commentUserThumbURL;

@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger playYear;
@property (nonatomic, assign) NSInteger commentTime;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *oriContent;
@property (nonatomic, assign) NSInteger isConcerned;


- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (void)updateAttributes:(NSDictionary *)attributes;

- (float)getCommentCellHeight;

- (instancetype)initWithTestData;
@end
