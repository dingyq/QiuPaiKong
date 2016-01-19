//
//  MessageLikeModel.m
//  QiuPai
//
//  Created by bigqiang on 15/11/22.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "MessageLikeModel.h"

@implementation MessageLikeModel

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        self.sortId = [[attributes objectForKey:@"sortId"] integerValue];
        self.itemId = [[attributes objectForKey:@"itemId"] integerValue];
        self.evaluateTime = [[attributes objectForKey:@"evaluateTime"] integerValue];
        self.picUrl = [attributes objectForKey:@"picUrl"];
        self.thumbPicUrl = [attributes objectForKey:@"thumbPicUrl"];
        self.title = [attributes objectForKey:@"title"];
        self.content = [attributes objectForKey:@"content"];
        
        self.tagInfo = [attributes objectForKey:@"tagInfo"];
        self.praiseNum = [[attributes objectForKey:@"praiseNum"] integerValue];
        self.isPraised = [[attributes objectForKey:@"isPraised"] integerValue];
        self.praiseList = [attributes objectForKey:@"praiseList"];
        
        self.itemStatus = [[attributes objectForKey:@"itemStatus"] integerValue];
    }
    
    return self;
}

- (void)updateAttributes:(NSDictionary *)attributes {

}

- (float)getMessageCellHeight {
    float height = 84.0f;
    
    NSMutableString *nameStr = [NSMutableString stringWithFormat:@""];
    NSArray *praiseListArr = self.praiseList;
    for (NSDictionary *dic in praiseListArr) {
        [nameStr appendFormat:@"%@,", [dic objectForKey:@"name"]];
    }
    NSString *tmpStr = @"";
    if ([praiseListArr count] > 0) {
        tmpStr = [nameStr substringWithRange:NSMakeRange(0, [nameStr length] - 1)];
    }
    NSString *str = [NSString stringWithFormat:@"%@喜欢了你的评测", tmpStr];
    
    CGRect frame = [str boundingRectWithSize:CGSizeMake(kFrameWidth - 36, 999.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]} context:nil];
    height = height + frame.size.height;
    
    return height;
}

- (instancetype)initWithTestData {
    NSDictionary *tmpDic = [MessageLikeModel generateTestData];
    
    self = [self initWithAttributes:tmpDic];
    if (self) {
        
    }
    return self;
}

+ (NSDictionary *)generateTestData {
    NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] init];
    
    [tmpDic setObject:[NSNumber numberWithInt:1231231] forKey:@"sortId"];
    [tmpDic setObject:[NSNumber numberWithInt:1231231] forKey:@"itemId"];
    NSNumber *time1 = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    [tmpDic setObject:time1 forKey:@"evaluateTime"];
    
    NSArray *picUrlArr = [NSArray arrayWithObjects:@"http://img.sc115.com/uploads/sc/pic/130713/1373540809198.jpg",
                          @"http://img.sc115.com/uploads/sc/jpgs/0623apic4457_sc115.com.jpg", nil];
    [tmpDic setObject:picUrlArr forKey:@"picUrl"];
    
    NSArray *thumbPicUrlArr = [NSArray arrayWithObjects:@"http://img.sc115.com/uploads/sc/pic/130713/1373540809198.jpg",
                               @"http://img.sc115.com/uploads/sc/jpgs/0623apic4457_sc115.com.jpg", nil];
    [tmpDic setObject:thumbPicUrlArr forKey:@"thumbPicUrl"];
    
    [tmpDic setObject:@"评测标题" forKey:@"title"];
    [tmpDic setObject:@"NSClassFromString是一个很有用的东西，最近遇到一个开源库用这个，ios5以后才有的twitter API，用此函数进行动态加载尝试，如果返回nil，则不能加载此类的实例" forKey:@"content"];
    
    NSMutableArray *tagInfoArr = [[NSMutableArray alloc] init];
    for (int j = 0; j < 2; j ++) {
        NSMutableDictionary *tagDic = [[NSMutableDictionary alloc] init];
        [tagDic setObject:[NSNumber numberWithInt:1231231] forKey:@"goodsId"];
        [tagDic setObject:@"head L4" forKey:@"goodsName"];
        [tagDic setObject:[NSNumber numberWithInt:1] forKey:@"isPrivilege"];
        [tagDic setObject:[NSNumber numberWithInt:1] forKey:@"isSelfDefine"];
        [tagInfoArr addObject:tagDic];
    }
    [tmpDic setObject:tagInfoArr forKey:@"tagInfo"];
    [tmpDic setObject:[NSNumber numberWithInt:23] forKey:@"praiseNum"];
    [tmpDic setObject:[NSNumber numberWithInt:1] forKey:@"isPraised"];
    
    NSMutableArray *likeListArr = [[NSMutableArray alloc] init];
    for (int j = 0; j < 2; j ++) {
        NSMutableDictionary *tagDic = [[NSMutableDictionary alloc] init];
        [tagDic setObject:@"dvt123" forKey:@"itemId"];
        [tagDic setObject:@"dick" forKey:@"name"];
        [tagDic setObject:@"http://f.hiphotos.baidu.com/image/pic/item/2e2eb9389b504fc2906eb86ee6dde71190ef6da3.jpg" forKey:@"headPic"];
        [tagDic setObject:@"http://f.hiphotos.baidu.com/image/pic/item/2e2eb9389b504fc2906eb86ee6dde71190ef6da3.jpg" forKey:@"thumbHeadPic"];
        [likeListArr addObject:tagDic];
    }
    [tmpDic setObject:likeListArr forKey:@"praiseList"];
    
    return tmpDic;
}

@end
