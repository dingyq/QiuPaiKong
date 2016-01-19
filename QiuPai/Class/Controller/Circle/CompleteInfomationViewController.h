//
//  CompleteInfomationViewController.h
//  QiuPai
//
//  Created by bigqiang on 15/12/14.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "BaseViewController.h"

@protocol CompleteInfomationSuccessDelegate <NSObject>

- (void)completeInfomaitonSuccessWithData:(NSDictionary *)dataDic;

@end

@interface CompleteInfomationViewController : BaseViewController

@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, assign) BOOL isModify;

@property (nonatomic, weak) id<CompleteInfomationSuccessDelegate> resultDelegate;

@end
