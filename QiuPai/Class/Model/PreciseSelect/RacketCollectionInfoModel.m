//
//  RacketCollectionInfoModel.m
//  QiuPai
//
//  Created by bigqiang on 15/11/5.
//  Copyright © 2015年 barbecue. All rights reserved.
//
//  球拍精选信息
//
//


#import "RacketCollectionInfoModel.h"

@interface RacketCollectionInfoModel(){
    
}
@end

@implementation RacketCollectionInfoModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.sortId = [[attributes objectForKey:@"sortId"] integerValue];
    self.itemId = [[attributes objectForKey:@"itemId"] integerValue];
    self.type = [[attributes objectForKey:@"type"] integerValue];
    self.picUrl = [attributes objectForKey:@"picUrl"];
    self.thumbPicUrl = [attributes objectForKey:@"thumbPicUrl"];
    self.title = [attributes objectForKey:@"title"];
    if (self.title == nil || [self.title isEqualToString:@""]) {
        self.title = [attributes objectForKey:@"themeTitle"];
    }
    self.contDataHtml = [attributes objectForKey:@"contDataHtml"];
    self.praiseNum = [[attributes objectForKey:@"praiseNum"] integerValue];
    self.isPraised = [[attributes objectForKey:@"isPraised"] integerValue];
    self.likeNum = [[attributes objectForKey:@"likeNum"] integerValue];
    self.isLike = [[attributes objectForKey:@"isLike"] integerValue];
    self.pubTime = [[attributes objectForKey:@"pubTime"] integerValue];
    self.shareNum = [[attributes objectForKey:@"shareNum"] integerValue];
    self.themeAbstract = [attributes objectForKey:@"themeAbstract"];
    return self;
}

- (void)updateAttributes:(NSDictionary *)attributes {
    if (!attributes) {
        return;
    }
    self.sortId = [[attributes objectForKey:@"sortId"] integerValue];
    self.itemId = [[attributes objectForKey:@"itemId"] integerValue];
    self.type = [[attributes objectForKey:@"type"] integerValue];
    self.picUrl = [attributes objectForKey:@"picUrl"];
    self.thumbPicUrl = [attributes objectForKey:@"thumbPicUrl"];
    self.title = [attributes objectForKey:@"title"];
    if (self.title == nil || [self.title isEqualToString:@""]) {
        self.title = [attributes objectForKey:@"themeTitle"];
    }
    self.contDataHtml = [attributes objectForKey:@"contDataHtml"];
    self.praiseNum = [[attributes objectForKey:@"praiseNum"] integerValue];
    self.isPraised = [[attributes objectForKey:@"isPraised"] integerValue];
    self.likeNum = [[attributes objectForKey:@"likeNum"] integerValue];
    self.isLike = [[attributes objectForKey:@"isLike"] integerValue];
    self.pubTime = [[attributes objectForKey:@"pubTime"] integerValue];
    self.shareNum = [[attributes objectForKey:@"shareNum"] integerValue];
    self.themeAbstract = [attributes objectForKey:@"themeAbstract"];
}

- (NSDictionary *)convertToDicData {
    NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
    [tmpDic setObject:[NSNumber numberWithInteger:self.sortId] forKey:@"sortId"];
    [tmpDic setObject:[NSNumber numberWithInteger:self.itemId] forKey:@"itemId"];
    [tmpDic setObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
    [tmpDic setObject:self.picUrl forKey:@"picUrl"];
    [tmpDic setObject:self.thumbPicUrl forKey:@"thumbPicUrl"];
    [tmpDic setObject:self.title forKey:@"title"];
    [tmpDic setObject:[NSNumber numberWithInteger:self.likeNum] forKey:@"likeNum"];
    [tmpDic setObject:[NSNumber numberWithInteger:self.isLike] forKey:@"isLike"];
    [tmpDic setObject:[NSNumber numberWithInteger:self.praiseNum] forKey:@"praiseNum"];
    [tmpDic setObject:[NSNumber numberWithInteger:self.isPraised] forKey:@"isPraised"];
    [tmpDic setObject:[NSNumber numberWithInteger:self.pubTime] forKey:@"pubTime"];
    [tmpDic setObject:[NSNumber numberWithInteger:self.shareNum] forKey:@"shareNum"];
    [tmpDic setObject:self.themeAbstract forKey:@"themeAbstract"];
    [tmpDic setObject:self.contDataHtml forKey:@"contDataHtml"];
    
    return tmpDic;
}

- (NSString *)thumbPicUrl {
    return _thumbPicUrl?_thumbPicUrl:@"";
}

- (NSString *)picUrl {
    return _picUrl?_picUrl:@"";
}

- (NSString *)contDataHtml {
    return _contDataHtml?_contDataHtml:@"";
}

- (NSInteger)pubTime {
    return _pubTime?_pubTime:0;
}

- (NSString *)playYear {
    return _playYear? _playYear:@"";
}

- (NSString *)title {
    return _title?_title:@"";
}

- (float)getRCICellHeight {
    float height = 0;
    float width = kFrameWidth - 20;
    if (self.type == 3) {
        height = 155.0f;
        if (self.thumbPicUrl && ![self.thumbPicUrl isEqualToString:@""]) {
            float imageHeight = (kFrameWidth - 20 - 10)/3;
            height += imageHeight;
        }
        
    } else {
        CGFloat imageH = (kFrameWidth - 10) * 170 / 365;
        height = imageH + 5;
        return height;
    }
    //计算评测文本的高度
    CGRect frame = [self.content boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FS_PC_CONTENT]} context:nil];
    //加上文本高度
    height += frame.size.height;
    height -= 14;
    if ([self.title isEqualToString:@""]) {
        height -= 24;
    }
    return height;
}

- (float)getZanListCellHeight {
    return [self getRCICellHeight];
}

@end
