//
//  KnockUpQuestion3View.h
//  QiuPai
//
//  Created by bigqiang on 15/12/14.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompleteInfomationDelagate.h"

@interface KnockUpQuestion3View : UIView

@property (nonatomic, weak) id<CompleteInfomationDelagate> myDelegate;

- (void)resetView:(NSInteger)selfEvalu playFreq:(NSInteger)playFreq;

@end
