//
//  SpecialTopicCommentViewController.h
//  QiuPai
//
//  Created by bigqiang on 15/12/9.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialTopicCommentViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *commentsArr;
@property (nonatomic, assign) NSInteger commentNum;
@property (nonatomic, assign) NSInteger topicId;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) BOOL isShowKeyBoard;
@property (nonatomic, copy) NSString *placeHodlerStr;

@end
