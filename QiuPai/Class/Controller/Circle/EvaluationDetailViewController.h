//
//  EvaluationDetailViewController.h
//  QiuPai
//
//  Created by bigqiang on 15/11/18.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCInteractionDelegate.h"

@interface EvaluationDetailViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, NetWorkDelegate>

@property (nonatomic, assign) NSInteger evaluateId;
@property (nonatomic, assign) BOOL isSelfEvaluation;
@property (nonatomic, assign) BOOL isPraised;
@property (nonatomic, assign) BOOL isShowKeyBoard;
@property (nonatomic, assign) BOOL isShowTag;
@property (nonatomic, copy) NSString *placeHodlerStr;

@property (nonatomic, weak) id<VCInteractionDelegate> myDelegate;

@end
