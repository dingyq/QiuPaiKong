//
//  MessageLikeModel.h
//  QiuPai
//
//  Created by bigqiang on 15/11/22.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageLikeModel : NSObject

@property (nonatomic, assign) NSInteger sortId;
@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, assign) NSInteger evaluateTime;
@property (nonatomic, strong) NSArray *picUrl;
@property (nonatomic, strong) NSArray *thumbPicUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSArray *tagInfo;
@property (nonatomic, assign) NSInteger praiseNum;
@property (nonatomic, assign) NSInteger isPraised;
@property (nonatomic, strong) NSArray *praiseList;

@property (nonatomic, assign) ItemStatus itemStatus;


- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (void)updateAttributes:(NSDictionary *)attributes;
- (float)getMessageCellHeight;

- (instancetype)initWithTestData;

@end


//\"sortId\":1231231,       //序列Id
//\"itemId\":1231231,       //条目Id
//\"evaluateTime\":1231231231,        //评测时间戳
//\"picUrl\":[\"www.tencent.com\",\"www.weixin.com\"],//图片URL群
//\"thumbPicUrl\":[\"www.tencent.com\",\"www.weixin.com\"],//缩略图片URL群
//\"title\":\"评测标题\",
//\"content\":\"评测内容\",
//\"tagInfo\":[  //商品标签
//{
//    \"goodsId\":1231231,          //商品Id
//    \"goodsName\":\"head L4\",    //商品名
//    \"isPrivilege\":1,            //是否特惠 0否1是
//    \"isSelfDefine\":1            //是否自定义标签 0否1是
//},
//{
//    \"goodsId\":1231231,          //商品Id
//    \"goodsName\":\"head L4\",    //商品名
//    \"isPrivilege\":1,            //是否特惠 0否1是
//    \"isSelfDefine\":1            //是否自定义标签 0否1是
//}
//]
//\"likeNum\":2,                //喜欢数
//\"isLike\":1                  //是否已喜欢 0否1是
//\"likeList\":[
//{
//    \"itemId\":\"dvt123\",       //条目Id(即用户Id)
//    \"name\":\"dick\",        //昵称
//    \"headPic\":\"www.tencent.com\",//头像
//    \"thumbHeadPic\":\"www.tencent.com\"//缩略头像
//},
//{
//    \"itemId\":\"dvt123\",       //条目Id(即用户Id)
//    \"name\":\"dick\",        //昵称
//    \"headPic\":\"www.tencent.com\",//头像
//    \"thumbHeadPic\":\"www.tencent.com\"//缩略头像
//},
//]//头像url群