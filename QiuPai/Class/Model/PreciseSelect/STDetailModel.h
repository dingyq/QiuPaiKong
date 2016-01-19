//
//  STDetailModel.h
//  QiuPai
//
//  Created by bigqiang on 15/12/9.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STDetailModel : NSObject

@property (nonatomic, assign) NSInteger commentNum;
@property (nonatomic, copy) NSString *contDataHtml;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger isLike;
@property (nonatomic, assign) NSInteger likeNum;
@property (nonatomic, assign) NSInteger isPraised;
@property (nonatomic, assign) NSInteger praiseNum;

@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *thumbPic;
@property (nonatomic, assign) NSInteger pubTime;
@property (nonatomic, assign) NSInteger shareNum;
@property (nonatomic, assign) NSInteger themeId;
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (void)updateAttributes:(NSDictionary *)attributes;

@end