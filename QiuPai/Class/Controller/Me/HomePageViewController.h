//
//  HomePageViewController.h
//  QiuPai
//
//  Created by bigqiang on 15/11/21.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageViewController : BaseViewController

@property (nonatomic, assign) BOOL isMyHomePage;
@property (nonatomic, copy) NSString *pageUserId;

@property (nonatomic, assign) BOOL turnToCommentVC;
@property (nonatomic, copy) NSString *commentPlaceHolderStr;

@end
