//
//  CircleInfoModel.h
//  QiuPai
//
//  Created by bigqiang on 15/11/11.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleInfoModel : NSObject

@property (nonatomic, assign) NSInteger sortId;
@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger commentNum;
@property (nonatomic, assign) NSInteger shareNum;

@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *thumbPicUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger likeNum;
@property (nonatomic, assign) NSInteger isLike;

@property (nonatomic, copy) NSString *playYear;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger isConcerned;
@property (nonatomic, copy) NSString *commentUserId;
@property (nonatomic, copy) NSString *commentName;

@property (nonatomic, copy) NSString *commentUserURL;
@property (nonatomic, assign) NSInteger commentTime;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *evaluateUserId;
@property (nonatomic, copy) NSString *evaluateName;

@property (nonatomic, copy) NSString *evaluateUserURL;
@property (nonatomic, copy) NSString *evaluateUserThumbURL;
@property (nonatomic, assign) NSInteger evaluateTime;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *tagInfo;

@property (nonatomic, copy) NSString *praiseList;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, assign) NSInteger isPraised;
@property (nonatomic, assign) ItemStatus itemStatus;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (instancetype)initWithAttributes:(NSDictionary *)attributes isFromCache:(BOOL)fromCache;
- (void)updateAttributes:(NSDictionary *)attributes;
//- (float)getCircleInfoCellHeight:(BOOL)isHideTag;
- (float)getUserHomePageCellHeight;
- (float)getZanListCellHeight;
- (float)getCircleInfoCellHeight:(BOOL)isHideTag isCircleList:(BOOL)circleList;


- (NSDictionary *)convertToDicData;
@end
