//
//  SexChooseViewController.h
//  QiuPai
//
//  Created by bigqiang on 15/12/18.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "BaseViewController.h"
#import "CompleteInfomationDelagate.h"

@interface SexChooseViewController : BaseViewController

@property (nonatomic, assign) SexIndicator sex;

@property (nonatomic, weak) id<CompleteInfomationDelagate> callDelegate;

@end
