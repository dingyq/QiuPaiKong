//
//  ModifyRacketViewController.h
//  QiuPai
//
//  Created by bigqiang on 15/12/20.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "BaseViewController.h"
#import "CompleteInfomationDelagate.h"
#import "RacketSearchModel.h"

@interface ModifyRacketViewController : BaseViewController

@property (nonatomic, weak) id<CompleteInfomationDelagate> callDelegate;

@property (nonatomic, strong) RacketSearchModel *racketModel;

@end
