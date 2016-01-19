//
//  ModifyNickViewController.h
//  QiuPai
//
//  Created by bigqiang on 15/12/20.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "BaseViewController.h"
#import "CompleteInfomationDelagate.h"

@interface ModifyNickViewController : BaseViewController

@property (nonatomic, weak) id<CompleteInfomationDelagate> callDelegate;

@property (nonatomic, copy) NSString *nickName;

@end
