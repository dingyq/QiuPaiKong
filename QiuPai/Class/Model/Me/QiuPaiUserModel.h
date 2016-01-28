//
//  QiuPaiUserModel.h
//  QiuPai
//
//  Created by bigqiang on 15/11/9.
//  Copyright © 2015年 barbecue. All rights reserved.
//

//基础信息
/**
 * \"headPic\":\"http://baidu.com\",   //头像url
 * \"nick\":\"dick\",          //昵称
 * \"sex\":1,          //性别0男1女
 * \"age\":23,         //年龄
 * \"playYear\":20,    //球龄
 * \"racquet\":\"head speed L3\",  //使用球拍
 * \"province\":\"广东\", //省份
 * \"city\":\"深圳\",    //城市
 * \"lvEevaluate\":35, //网球指数自评(保留1位小数，即乘以10)
 */

//评测信息
/**
 * \"height\":173,     //身高(cm)
 * \"weight\":25,      //体重(kg)
 * \"selfEveluate\":1  //自评 1零基础 2初学 3进阶 4专业 5巡回赛
 * \"backHand\":1      //反手 1零基础 2单手反拍 3双手翻拍
 * \"playFreq\":2,     //频率 1没打过 2偶尔 3 1-4次/月 4一周三次以上
 * \"grapHand\":3,     //持拍手 1左手 2右手
 * \"otherGame\":1,    //其他球类 1没有 2偶尔参加 3经常参加
 * \"powerSelfEveluate\":1,      //力量自评 1不参加 2偶尔 3一周一次 4一周三次及以上
 * \"staOrBurn\":1,       //耐力爆发 1爆发 2耐力 3均衡
 * \"injuries\":2,        //伤病史 1有 2无 3不清楚
 * \"style\":1,           //击球风格 1没打过 2上旋 3平击
 * \"region\":1,          //活动区域 1没打过 2全场 3网前 4底线附近 5底线后
 * \"star\":[1,2],             //明星喜好 1德约科维奇 2沃达斯科 3伊斯托明 4库德拉 5蒂普萨勒维奇 6费德勒 7瓦林卡
 * \"color\":[1,2],         //颜色偏好 1黑 2金 3白 4红 5银 6棕 7灰 8黄 9蓝 10海军蓝 11浅蓝 12青橙绿 13绿 14黑灰 15橙
 * \"brand\":[1,2],         //品牌偏好 1Wilson 2Babolat 3Head 4Yonex 5Prince
 * \"gripSize\":1          //握把尺寸编号
 */

#import <Foundation/Foundation.h>

@interface QiuPaiUserModel : NSObject

@property (nonatomic, assign) BOOL isTimeOut;

@property (nonatomic, strong) NSNumber *playFreq;
@property (nonatomic, strong) NSNumber *powerSelfEveluate;
@property (nonatomic, strong) NSNumber *injuries;
@property (nonatomic, strong) NSNumber *staOrBurn;
@property (nonatomic, strong) NSNumber *style;
@property (nonatomic, strong) NSNumber *region;
@property (nonatomic, copy) NSString *headPic;
@property (nonatomic, copy) NSString *thumbHeadPic;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, strong) NSNumber *sex;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, copy) NSString *playYear;
@property (nonatomic, copy) NSString *racquet;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, strong) NSNumber *lvEevaluate;
@property (nonatomic, strong) NSNumber *height;
@property (nonatomic, strong) NSNumber *weight;
@property (nonatomic, strong) NSNumber *selfEveluate;
@property (nonatomic, strong) NSNumber *backHand;
@property (nonatomic, strong) NSNumber *grapHand;
@property (nonatomic, strong) NSNumber *otherGame;
@property (nonatomic, strong) NSNumber *gripSize;
@property (nonatomic, strong) id star;
@property (nonatomic, strong) id color;
@property (nonatomic, strong) id brand;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, strong) NSNumber *concernNum;     // 关注
@property (nonatomic, strong) NSNumber *messageNum;
@property (nonatomic, strong) NSNumber *nConcerned;
@property (nonatomic, strong) NSNumber *nLike;
@property (nonatomic, strong) NSNumber *nMessage;
@property (nonatomic, strong) NSNumber *concernedNum;   // 粉丝
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, copy) NSString *authKey;

@property (nonatomic, strong) id report;


@property (copy, nonatomic) NSString *wbtoken;
@property (copy, nonatomic) NSString *wbRefreshToken;
@property (copy, nonatomic) NSString *wbCurrentUserID;


+ (QiuPaiUserModel *)getUserInstance;

- (void)updateWithDic:(NSDictionary *)dic;

+ (void)saveSelfToCoreData;

- (void)userLogout;

- (void)showUserLoginVC;


@end
