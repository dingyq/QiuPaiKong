//
//  SearchViewController.h
//  QiuPai
//
//  Created by bigqiang on 15/11/9.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCInteractionDelegate.h"


@interface SearchViewController : BaseViewController
@property (nonatomic, weak) id<VCInteractionDelegate> myDelegate;
@property (copy, nonatomic) NSString *searchPlaceholder;
@property (nonatomic, assign) GoodsSearchType searchType;

@property (nonatomic, assign) BOOL isNeedBackPreVc;

@end
