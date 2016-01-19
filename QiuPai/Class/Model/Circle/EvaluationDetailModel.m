//
//  EvaluationDetailModel.m
//  QiuPai
//
//  Created by bigqiang on 15/11/18.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "EvaluationDetailModel.h"

@implementation SubEvaluationModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.itemId = [[attributes objectForKey:@"itemId"] integerValue];
    self.sortId = [[attributes objectForKey:@"sortId"] integerValue];
    self.title = [attributes objectForKey:@"title"];
    self.content = [attributes objectForKey:@"content"];
    self.evaluateTime = [[attributes objectForKey:@"evaluateTime"] integerValue];
    self.likeNum = [[attributes objectForKey:@"likeNum"] integerValue];
    self.isLike = [[attributes objectForKey:@"isLike"] integerValue];
    self.picUrl = [attributes objectForKey:@"picUrl"];
    self.thumbPicUrl = [attributes objectForKey:@"thumbPicUrl"];
    self.tagInfo = [attributes objectForKey:@"tagInfo"];
    
    self.praiseNum = [[attributes objectForKey:@"praiseNum"] integerValue];
    self.isPraised = [[attributes objectForKey:@"isPraised"] integerValue];
    self.praiseList = [[NSMutableArray alloc] initWithArray:[attributes objectForKey:@"praiseList"]];
    
    return self;
}

- (NSInteger)isPraised {
    return _isPraised?_isPraised:0;
}

- (NSInteger)isLike {
    return _isLike?_isLike:0;
}

@end


@implementation EvaluaCommentModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.beId = [[attributes objectForKey:@"beId"] integerValue];
    self.itemId = [[attributes objectForKey:@"itemId"] integerValue];
    self.sortId = [[attributes objectForKey:@"sortId"] integerValue];
    self.commentName = [attributes objectForKey:@"commentName"];
    self.commentUserId = [attributes objectForKey:@"commentUserId"];
    self.commentUserThumbURL = [attributes objectForKey:@"commentUserThumbURL"];
    self.commentUserURL = [attributes objectForKey:@"commentUserURL"];
    self.content = [attributes objectForKey:@"content"];
    self.commentTime = [[attributes objectForKey:@"commentTime"] integerValue];
    self.isConcerned = [[attributes objectForKey:@"isConcerned"] integerValue];
    self.playYear = [[attributes objectForKey:@"playYear"] integerValue];
    self.oriContent = [attributes objectForKey:@"oriContent"];
    self.toCommentName = [attributes objectForKey:@"toCommentName"];
    self.sex = [[attributes objectForKey:@"sex"] integerValue];
    self.toCommentUserId = [attributes objectForKey:@"toCommentUserId"];
    return self;
}

@end



@implementation EvaluationDetailModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.userId = [attributes objectForKey:@"userId"];
    self.evaluateId = [[attributes objectForKey:@"evaluateId"] integerValue];
    self.headPic = [attributes objectForKey:@"headPic"];
    self.thumbHeadPic = [attributes objectForKey:@"thumbHeadPic"];
    self.nick = [attributes objectForKey:@"nick"];
    self.sex = [[attributes objectForKey:@"sex"] integerValue];
    self.age = [[attributes objectForKey:@"age"] integerValue];
    self.shareNum = [[attributes objectForKey:@"shareNum"] integerValue];
    self.likeNum = [[attributes objectForKey:@"likeNum"] integerValue];
    self.playYear = [attributes objectForKey:@"playYear"];
    self.racquet = [attributes objectForKey:@"racquet"];
    self.messageNum = [[attributes objectForKey:@"messageNum"] integerValue];
    self.isConcerned = [[attributes objectForKey:@"isConcerned"] integerValue];
    
    self.contData = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in [attributes objectForKey:@"contData"]) {
        SubEvaluationModel *tmpModel = [[SubEvaluationModel alloc] initWithAttributes:dic];
        [self.contData addObject:tmpModel];
    }
    
    self.commentData = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in [attributes objectForKey:@"commentData"]) {
        EvaluaCommentModel *tmpModel = [[EvaluaCommentModel alloc] initWithAttributes:dic];
        [self.commentData addObject:tmpModel];
    }
    return self;
}

- (void)updateAttributes:(NSDictionary *)attributes {
    
}

- (float)getEvaluationDetailCellHeight:(NSInteger)cellSection cellRow:(NSInteger)cellRow isHideGoodsTag:(BOOL)isHideTag {
    float height = 0;
    float width = kFrameWidth - 20;
    NSString *tmpStr = @"";
    SubEvaluationModel *evaluModel;
    CGFloat fontSize = FS_PC_CONTENT;
    if (cellSection == 0) {
        if (cellRow == 0) {
            // 头像+标签+赞+时间的高度
            height = height + 55 + 63;
            if (isHideTag) {
                height -= 25;
            }
        } else {
            // 子评测的时间、赞等
            height = height + 27;
        }
        if (cellRow < [self.contData count]) {
            evaluModel = [self.contData objectAtIndex:cellRow];
            tmpStr = evaluModel.content;
        } else {
            // 加载更多 cell
            return 40.0f;
        }
    } else {
        EvaluaCommentModel *commentModel = [self.commentData objectAtIndex:cellRow];
        tmpStr = commentModel.content;
        width -= 38;
        height += 30;
        fontSize = FS_PC_COMMENT;
    }
    
    CGRect frame = [tmpStr boundingRectWithSize:CGSizeMake(width, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil];
    height += frame.size.height+8;
    
    NSArray *thumbPicUrlArr = evaluModel.thumbPicUrl;
    if (thumbPicUrlArr != nil && [thumbPicUrlArr count] > 0) {
        height += ((kFrameWidth-30)/3);
        if (cellRow == 0) {
            if (![evaluModel.title isEqualToString:@""]) {
                height += (FS_PC_TITLE+4);
            }
        }
    }
    return height;
}
@end
