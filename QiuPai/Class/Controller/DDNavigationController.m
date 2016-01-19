//
//  DDNavigationController.m
//  QiuPai
//
//  Created by bigqiang on 15/12/10.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "DDNavigationController.h"

@interface DDNavigationController () {

}

@end

@implementation DDNavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)addAlphaView {
    CGRect frame = self.navigationBar.frame;
    _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
    _alphaView.backgroundColor = CustomGreenColor;
    [self.view insertSubview:_alphaView belowSubview:self.navigationBar];
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar_shadow.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.layer.masksToBounds = YES;
}


- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}
@end
