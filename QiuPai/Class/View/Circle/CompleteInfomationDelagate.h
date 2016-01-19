//
//  CompleteInfomationDelagate.h
//  QiuPai
//
//  Created by bigqiang on 15/12/15.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Step2CallBackBlock)(NSString *tipStr);

@protocol CompleteInfomationDelagate <NSObject>

@optional

- (void)racketChooseDone:(NSString *)racketName;

- (void)nickNameModify:(NSString *)nickName;

- (void)playYearChooseDone:(NSString *)playYear;

- (void)locationChooseDone:(NSString *)province city:(NSString *)city;

- (void)sexChooseDone:(SexIndicator)sex;

- (void)lvEveluateChooseDone:(NSInteger)lvEveluate;

//
- (void)ageChooseBtnClick:(Step2CallBackBlock)callBack;

- (void)heigthChooseBtnClick:(Step2CallBackBlock)callBack;

- (void)weightChooseBtnClick:(Step2CallBackBlock)callBack;

//
- (void)selfEveluateChooseDone:(NSInteger)selfEveluate;

- (void)playFrequencyChooseDone:(NSInteger)playFreq;

//
- (void)strengthPracticeChooseDone:(NSInteger)strength;

- (void)injuryChooseDone:(NSInteger)injury;

//
- (void)regionChooseDone:(NSInteger)region;

- (void)styleChooseDone:(NSInteger)style;

@end
