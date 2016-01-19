//
//  UserHomeInfoModel.h
//  QiuPai
//
//  Created by bigqiang on 15/12/10.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserHomeInfoModel : NSObject


@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *headPic;
@property (nonatomic, copy) NSString *thumbHeadPic;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger playYear;
@property (nonatomic, copy) NSString *racquet;
@property (nonatomic, copy) NSString *region;

@property (nonatomic, assign) NSInteger messageNum;
@property (nonatomic, assign) NSInteger concernNum;
@property (nonatomic, assign) NSInteger isConcerned;


- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (void)updateAttributes:(NSDictionary *)attributes;

@end


//\"userId\":\"dvc123\",
//\"headPic\":\"http://baidu.com\",   //头像url
//\"thumbHeadPic\":\"http://baidu.com\",   //头像url缩略
//\"nick\":\"dick\",          //昵称
//\"sex\":1,          //性别0男1女
//\"age\":23,         //年龄
//\"playYear\":20,    //球龄
//\"racquet\":\"head speed L3\",  //使用球拍
//\"messageNum\":123,   //留言数
//\"concernNum\":123,   //关注数
//\"isConcerned\":1,             //是否已关注 0否1是