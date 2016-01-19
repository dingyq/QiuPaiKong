//
//  KnockUpQuestion5View.h
//  QiuPai
//
//  Created by bigqiang on 15/12/15.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompleteInfomationDelagate.h"

@interface KnockUpQuestion5View : UIView

@property (nonatomic, weak) id<CompleteInfomationDelagate> myDelegate;

- (void)resetView:(NSInteger)region style:(NSInteger)style;

@end
