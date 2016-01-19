//
//  VCInteractionDelegate.h
//  QiuPai
//
//  Created by bigqiang on 16/1/3.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VCInteractionDelegate <NSObject>

@optional

- (void)sendSearchResult:(id)result;

- (void)deleteMainEvaluation:(NSInteger)evaluId;

- (void)publishNewEvaluationSuccess:(NSDictionary *)dataDic;

@end