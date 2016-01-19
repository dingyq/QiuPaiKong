//
//  GoodsDetailAndEvaViewController.h
//  QiuPai
//
//  Created by bigqiang on 15/11/30.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailAndEvaViewController : BaseViewController 

@property (nonatomic, strong) NSDictionary *paramDic;

@property (nonatomic, strong) NSString *goodsName;

@property (nonatomic, strong) NSString *goodsBrand;

@property (nonatomic, assign) NSInteger *goodsEvaluNum;

@property (nonatomic, assign) NSInteger goodsId;

@property (nonatomic, assign) BOOL isBackFromCompleteInfomation;

@end
