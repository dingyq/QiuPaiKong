//
//  UserMessageViewController.h
//  QiuPai
//
//  Created by bigqiang on 15/12/10.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "BaseViewController.h"

@interface UserMessageViewController : BaseViewController

@property(nonatomic, strong) NSMutableArray *messagesArr;
@property (nonatomic, copy) NSString *pageUserId;
@property (nonatomic, assign) NSInteger messageNum;
@property (nonatomic, assign) BOOL isShowKeyBoard;
@property (nonatomic, copy) NSString *placeHodlerStr;
@property (nonatomic, assign) BOOL isLike;

@end
