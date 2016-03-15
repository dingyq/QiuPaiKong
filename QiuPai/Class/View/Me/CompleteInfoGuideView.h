//
//  CompleteInfoGuideView.h
//  QiuPai
//
//  Created by bigqiang on 16/3/13.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompleteInfomationDelagate.h"

@interface CompleteInfoGuideView : UIView

@property (nonatomic, weak) id<CompleteInfomationDelagate> myDelegate;


- (void)reloadRacketUsedView:(NSString *)imageUrl name:(NSString *)goodsName weight:(NSString *)weight balance:(NSString *)balance headSize:(NSString *)headSize;

@end
