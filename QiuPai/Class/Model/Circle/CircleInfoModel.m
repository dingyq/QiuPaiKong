//
//  CircleInfoModel.m
//  QiuPai
//
//  Created by bigqiang on 15/11/11.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "CircleInfoModel.h"

@interface CircleInfoModel() <NSCopying>{
    
}
@end

@implementation CircleInfoModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    return [self initWithAttributes:attributes isFromCache:NO];
}

- (instancetype)initWithAttributes:(NSDictionary *)attributes isFromCache:(BOOL)fromCache {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.sortId = [[attributes objectForKey:@"sortId"] integerValue];
    self.itemId = [[attributes objectForKey:@"itemId"] integerValue];
    self.type = [[attributes objectForKey:@"type"] integerValue];
    
    self.title = [attributes objectForKey:@"title"];
    self.likeNum = [[attributes objectForKey:@"likeNum"] integerValue];
    self.isLike = [[attributes objectForKey:@"isLike"] integerValue];
    self.playYear = [attributes objectForKey:@"playYear"];
    self.sex = [[attributes objectForKey:@"sex"] integerValue];
    
    self.isConcerned = [[attributes objectForKey:@"isConcerned"] integerValue];
    self.shareNum = [[attributes objectForKey:@"shareNum"] integerValue];
    self.commentNum = [[attributes objectForKey:@"commentName"] integerValue];
    self.commentUserId = [attributes objectForKey:@"commentUserId"];
    self.commentName = [attributes objectForKey:@"commentName"];
    
    self.commentUserURL = [attributes objectForKey:@"commentUserURL"];
    self.commentTime = [[attributes objectForKey:@"commentTime"] integerValue];
    self.comment = [attributes objectForKey:@"comment"];
    self.evaluateUserId = [attributes objectForKey:@"evaluateUserId"];
    self.evaluateName = [attributes objectForKey:@"evaluateName"];
    
    self.evaluateUserURL = [attributes objectForKey:@"evaluateUserURL"];
    self.evaluateUserThumbURL = [attributes objectForKey:@"evaluateUserThumbURL"];
    self.evaluateTime = [[attributes objectForKey:@"evaluateTime"] integerValue];
    self.content = [attributes objectForKey:@"content"];
    
    self.isPraised = [[attributes objectForKey:@"isPraised"] integerValue];
    self.praiseNum = [[attributes objectForKey:@"praiseNum"] integerValue];
    self.itemStatus = [[attributes objectForKey:@"itemStatus"] integerValue];
    if (fromCache) {
        self.picUrl = [attributes objectForKey:@"picUrl"];
        self.thumbPicUrl = [attributes objectForKey:@"thumbPicUrl"];
        self.tagInfo = [attributes objectForKey:@"tagInfo"];
        self.praiseList = [attributes objectForKey:@"praiseList"];
    } else {
        self.picUrl = [[attributes objectForKey:@"picUrl"] JSONString];
        self.thumbPicUrl = [[attributes objectForKey:@"thumbPicUrl"] JSONString];
        self.tagInfo = [[attributes objectForKey:@"tagInfo"] JSONString];
        self.praiseList = [[attributes objectForKey:@"praiseList"] JSONString];
    }
    
    return self;
}

- (void)updateAttributes:(NSDictionary *)attributes {
    if (!attributes) {
        return;
    }
    self.sortId = [[attributes objectForKey:@"sortId"] integerValue];
    self.itemId = [[attributes objectForKey:@"itemId"] integerValue];
    self.type = [[attributes objectForKey:@"type"] integerValue];
    self.title = [attributes objectForKey:@"title"];
    self.likeNum = [[attributes objectForKey:@"likeNum"] integerValue];
    self.isLike = [[attributes objectForKey:@"isLike"] integerValue];
    self.playYear = [attributes objectForKey:@"playYear"];
    self.sex = [[attributes objectForKey:@"sex"] integerValue];
    
    self.isConcerned = [[attributes objectForKey:@"isConcerned"] integerValue];
    self.shareNum = [[attributes objectForKey:@"shareNum"] integerValue];
    self.commentNum = [[attributes objectForKey:@"commentName"] integerValue];
    self.commentUserId = [attributes objectForKey:@"commentUserId"];
    self.commentName = [attributes objectForKey:@"commentName"];
    
    self.commentUserURL = [attributes objectForKey:@"commentUserURL"];
    self.commentTime = [[attributes objectForKey:@"commentTime"] integerValue];
    self.comment = [attributes objectForKey:@"comment"];
    self.evaluateUserId = [attributes objectForKey:@"evaluateUserId"];
    self.evaluateName = [attributes objectForKey:@"evaluateName"];
    
    self.evaluateUserURL = [attributes objectForKey:@"evaluateUserURL"];
    self.evaluateUserThumbURL = [attributes objectForKey:@"evaluateUserThumbURL"];
    self.evaluateTime = [[attributes objectForKey:@"evaluateTime"] integerValue];
    self.content = [attributes objectForKey:@"content"];

    self.isPraised = [[attributes objectForKey:@"isPraised"] integerValue];
    self.praiseNum = [[attributes objectForKey:@"praiseNum"] integerValue];
    self.itemStatus = [[attributes objectForKey:@"itemStatus"] integerValue];
    
    self.tagInfo = [[attributes objectForKey:@"tagInfo"] JSONString];
    self.picUrl = [[attributes objectForKey:@"picUrl"] JSONString];
    self.thumbPicUrl = [[attributes objectForKey:@"thumbPicUrl"] JSONString];
    self.praiseList = [[attributes objectForKey:@"praiseList"] JSONString];
}

- (NSDictionary *)convertToDicData {
    NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
    [tmpDic setObject:[NSNumber numberWithInteger:self.sortId] forKey:@"sortId"];
    [tmpDic setObject:[NSNumber numberWithInteger:self.itemId] forKey:@"itemId"];
    [tmpDic setObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
    [tmpDic setObject:self.picUrl forKey:@"picUrl"];
    [tmpDic setObject:self.thumbPicUrl forKey:@"thumbPicUrl"];
    
    [tmpDic setObject:self.title forKey:@"title"];
    [tmpDic setObject:[NSNumber numberWithInteger:self.isPraised] forKey:@"isPraised"];
    [tmpDic setObject:[NSNumber numberWithInteger:self.praiseNum] forKey:@"praiseNum"];
    [tmpDic setObject:self.praiseList forKey:@"praiseList"];
    [tmpDic setObject:[NSNumber numberWithInteger:self.shareNum] forKey:@"shareNum"];
    
    [tmpDic setObject:[NSNumber numberWithInteger:self.commentNum] forKey:@"commentNum"];
    [tmpDic setObject:[NSNumber numberWithInteger:self.likeNum] forKey:@"likeNum"];
    [tmpDic setObject:[NSNumber numberWithInteger:self.isLike] forKey:@"isLike"];
    [tmpDic setObject:self.playYear forKey:@"playYear"];
    [tmpDic setObject:[NSNumber numberWithInteger:self.sex] forKey:@"sex"];
    
    if (self.type == 2) {
        [tmpDic setObject:[NSNumber numberWithInteger:self.isConcerned] forKey:@"isConcerned"];
        [tmpDic setObject:[NSNumber numberWithInteger:self.commentTime] forKey:@"commentTime"];
        [tmpDic setObject:self.commentUserId forKey:@"commentUserId"];
        [tmpDic setObject:self.commentName forKey:@"commentName"];
        [tmpDic setObject:self.commentUserURL forKey:@"commentUserURL"];
        [tmpDic setObject:self.comment forKey:@"comment"];
    }
    
    if (self.type == InfoType_Evaluation) {
        [tmpDic setObject:[NSNumber numberWithInteger:self.isConcerned] forKey:@"isConcerned"];
        [tmpDic setObject:[NSNumber numberWithInteger:self.evaluateTime] forKey:@"evaluateTime"];
        [tmpDic setObject:self.evaluateUserId forKey:@"evaluateUserId"];
        [tmpDic setObject:self.evaluateName forKey:@"evaluateName"];
        [tmpDic setObject:self.evaluateUserURL forKey:@"evaluateUserURL"];
        [tmpDic setObject:self.evaluateUserThumbURL forKey:@"evaluateUserThumbURL"];
        [tmpDic setObject:self.content forKey:@"content"];
        [tmpDic setObject:self.tagInfo forKey:@"tagInfo"];
    }

    return tmpDic;
}

- (float)getZanListCellHeight {
    return [self getCircleInfoCellHeight:NO isCircleList:YES];
}

- (float)getCircleInfoCellHeight:(BOOL)isHideTag isCircleList:(BOOL)circleList {
    float height = 85.0f;
    if (self.type == InfoType_Evaluation) {
        if (self.thumbPicUrl && ![self.thumbPicUrl isEqualToString:@""]) {
            float imageHeight = (kFrameWidth - 20 - 10)/3.0f + 6.0f;
            height += imageHeight;
        }
    }
    if (isHideTag) {
        height -= 0;
    }
    
    //计算评测文本的高度
    float width = kFrameWidth - 20;
    CGRect frame = [self.content boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FS_PC_CONTENT]} context:nil];
    //加上文本高度
    if (circleList) {
        if (frame.size.height < 20.0f) {
            height = height + FS_PC_CONTENT + 4;
        } else {
            height = height + FS_PC_CONTENT*2 + 8;
        }
    } else {
        height = height + frame.size.height + 8;
    }
    if (![self.title isEqualToString:@""]) {
        height += (FS_PC_TITLE+4);
    }
    return height;
}

- (float)getUserHomePageCellHeight {
    float height = [self getCircleInfoCellHeight:NO isCircleList:YES];
    height -= 52;
//    float width = kFrameWidth - 20;
//    if (self.type == InfoType_Evaluation) {
//        float imageHeight = (kFrameWidth - 20 - 10)/3;
//        height = 97.0f + imageHeight;
//    } else {
//        return 178.0f;
//    }
//    
//    //计算评测文本的高度
//    CGRect frame = [self.content boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FS_PC_CONTENT]} context:nil];
//    //加上文本高度
//    height += frame.size.height;
//    height -= 14;
//    if ([self.title isEqualToString:@""]) {
//        height -= 24;
//    }
    return height;
}


- (instancetype)copyWithZone:(NSZone *)zone {
    CircleInfoModel *tmpModel = [[self class] allocWithZone:zone];
    tmpModel.sortId = self.sortId;
    tmpModel.itemId = self.itemId;
    tmpModel.type = self.type;
    tmpModel.picUrl = [self.picUrl copy];
    tmpModel.thumbPicUrl = [self.thumbPicUrl copy];
    tmpModel.title = [self.title copy];
    tmpModel.likeNum = self.likeNum;
    tmpModel.isLike = self.isLike;
    tmpModel.playYear = [self.playYear copy];
    tmpModel.sex = self.sex;
    tmpModel.isConcerned = self.isConcerned;
    
    tmpModel.shareNum = self.shareNum;
    tmpModel.commentNum = self.commentNum;
    tmpModel.commentUserId = [self.commentUserId copy];
    tmpModel.commentName = [self.commentName copy];
    tmpModel.commentUserURL = [self.commentUserURL copy];
    tmpModel.commentTime = self.commentTime;
    tmpModel.comment = [self.comment copy];
    
    tmpModel.evaluateUserId = [self.evaluateUserId copy];
    tmpModel.evaluateName = [self.evaluateName copy];
    tmpModel.evaluateUserURL = [self.evaluateUserURL copy];
    tmpModel.evaluateUserThumbURL = [self.evaluateUserThumbURL copy];
    tmpModel.evaluateTime = self.evaluateTime;
    tmpModel.content = [self.content copy];
    tmpModel.tagInfo = [self.tagInfo copy];
    
    tmpModel.praiseList = [self.praiseList copy];
    tmpModel.praiseNum = self.praiseNum;
    tmpModel.isPraised = self.isPraised;
    tmpModel.itemStatus = self.itemStatus;
    return tmpModel;
}


- (NSString *)content {
    return _content?_content:@"";
}

- (NSString *)tagInfo {
    return _tagInfo?_tagInfo:@"";
}

- (NSString *)evaluateUserId {
    return _evaluateUserId?_evaluateUserId:@"";
}

- (NSString *)evaluateName {
    return _evaluateName?_evaluateName:@"";
}

- (NSString *)evaluateUserURL {
    return _evaluateUserURL?_evaluateUserURL:@"";
}

- (NSString *)evaluateUserThumbURL {
    return _evaluateUserThumbURL?_evaluateUserThumbURL:@"";
}

- (NSString *)comment {
    return _comment?_comment:@"";
}

- (NSString *)commentName {
    return _commentName?_commentName:@"";
}

- (NSString *)commentUserId {
    return _commentUserId?_commentUserId:@"";
}

- (NSString *)commentUserURL {
    return _commentUserURL?_commentUserURL:@"";
}

- (NSString *)picUrl {
    return _picUrl?_picUrl:@"";
}

- (NSString *)thumbPicUrl {
    return _thumbPicUrl?_thumbPicUrl:@"";
}

- (NSString *)playYear {
    return _playYear?_playYear:@"";
}

- (NSString *)title {
    return _title?_title:@"";
}

- (NSString *)praiseList {
    return _praiseList?_praiseList:@"";
}

@end
