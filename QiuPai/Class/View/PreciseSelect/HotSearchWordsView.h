//
//  HotSearchWordsView.h
//  QiuPai
//
//  Created by bigqiang on 16/3/13.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCellInteractionDelegate.h"

@interface HotSearchWordsView : UIView
@property (nonatomic, weak) id<TableViewCellInteractionDelegate> myDelegate;

- (void)initHotWordsBtn:(NSArray *)btnTitleArr;

@end
