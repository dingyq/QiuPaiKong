//
//  RacketCollectionInfoModel.h
//  QiuPai
//
//  Created by bigqiang on 15/11/5.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RacketCollectionDB.h"

@interface RacketCollectionInfoModel : NSObject

@property (nonatomic, assign) NSInteger sortId;
@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *thumbPicUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger likeNum;
@property (nonatomic, assign) NSInteger isLike;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, assign) NSInteger isPraised;
@property (nonatomic, copy) NSString *contDataHtml;
@property (nonatomic, assign) NSInteger shareNum;
@property (nonatomic, copy) NSString *themeAbstract;
@property (nonatomic, assign) NSInteger pubTime;

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
@property (nonatomic, assign) NSInteger itemStatus;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (void)updateAttributes:(NSDictionary *)attributes;
- (float)getRCICellHeight;
- (float)getZanListCellHeight;

- (NSDictionary *)convertToDicData;

@end
