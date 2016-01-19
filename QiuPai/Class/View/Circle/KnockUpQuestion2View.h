//
//  KnockUpQuestion2View.h
//  QiuPai
//
//  Created by bigqiang on 15/12/14.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompleteInfomationDelagate.h"

@interface KnockUpQuestion2View : UIView

@property (nonatomic, weak) id<CompleteInfomationDelagate> myDelegate;

- (void)resetView:(NSInteger)bornYear height:(NSInteger)height weight:(NSInteger)weight;

@end
