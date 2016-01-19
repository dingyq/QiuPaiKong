//
//  EvaluationDetailModel.h
//  QiuPai
//
//  Created by bigqiang on 15/11/18.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

// 评测实体
@interface SubEvaluationModel : NSObject
@property (nonatomic, assign) NSInteger sortId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger evaluateTime;
@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, assign) NSInteger isLike;
@property (nonatomic, assign) NSInteger likeNum;
@property (nonatomic, strong) NSArray *picUrl;
@property (nonatomic, strong) NSArray *thumbPicUrl;
@property (nonatomic, strong) NSArray *tagInfo;
@property (nonatomic, strong) NSMutableArray *praiseList;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, assign) NSInteger isPraised;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end

@interface EvaluaCommentModel : NSObject
@property (nonatomic, assign) NSInteger beId;
@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, copy) NSString *commentName;
@property (nonatomic, copy) NSString *commentUserURL;
@property (nonatomic, copy) NSString *commentUserThumbURL;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger commentTime;
@property (nonatomic, copy) NSString *commentUserId;
@property (nonatomic, assign) NSInteger isConcerned;
@property (nonatomic, assign) NSInteger playYear;
@property (nonatomic, copy) NSString *oriContent;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger sortId;
@property (nonatomic, copy) NSString *toCommentName;
@property (nonatomic, copy) NSString *toCommentUserId;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end

@interface EvaluationDetailModel : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) NSInteger evaluateId;
@property (nonatomic, copy) NSString *headPic;
@property (nonatomic, copy) NSString *thumbHeadPic;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger likeNum;
@property (nonatomic, assign) NSInteger shareNum;
@property (nonatomic, copy) NSString *playYear;
@property (nonatomic, copy) NSString *racquet;
@property (nonatomic, assign) NSInteger messageNum;
@property (nonatomic, assign) NSInteger isConcerned;
@property (nonatomic, strong) NSMutableArray *contData;
@property (nonatomic, strong) NSMutableArray *commentData;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

- (float)getEvaluationDetailCellHeight:(NSInteger)cellSection cellRow:(NSInteger)cellRow isHideGoodsTag:(BOOL)isHideTag;
@end
