//
//  SpecialTopicViewController.h
//  QiuPai
//
//  Created by bigqiang on 15/11/6.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialTopicViewController : BaseViewController

@property (nonatomic, copy) NSString *pageHtmlUrl;
@property (nonatomic, assign) NSInteger topicId;

@property (nonatomic, assign) BOOL turnToCommentVC;
@property (nonatomic, copy) NSString *commentPlaceHolderStr;

@end
