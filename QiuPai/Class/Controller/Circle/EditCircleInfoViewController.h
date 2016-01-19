//
//  EditCircleInfoViewController.h
//  QiuPai
//
//  Created by bigqiang on 15/11/19.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleEditView.h"
#import "RacketSearchModel.h"
#import "VCInteractionDelegate.h"

@interface EditCircleInfoViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource, NetWorkDelegate>

@property (nonatomic, weak) id<PhotoDisplayViewDelegate> delegate;

@property (nonatomic, strong) RacketSearchModel *goodsSRModel;

@property (nonatomic, weak) id<VCInteractionDelegate> myDelegate;

@end
