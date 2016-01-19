//
//  LoginInViewController.h
//  QiuPai
//
//  Created by bigqiang on 15/12/17.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginSuccessDelegate <NSObject>

- (void)loginSuccessBackWithData:(NSDictionary *)infoDic;

@end

@interface LoginInViewController : BaseViewController

@property (nonatomic, weak) id<LoginSuccessDelegate> loginDelegate;

@end
