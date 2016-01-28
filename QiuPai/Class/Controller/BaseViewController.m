//
//  BaseViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/11/28.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "BaseViewController.h"
#import "UINavigationBar+BackgroundColor.h"

@interface BaseViewController () <MBProgressHUDDelegate> {
    MBProgressHUD* _proHUD;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = CustomGreenColor;
    self.navigationController.navigationBar.layer.contents = (id)[Helper imageWithColor:CustomGreenColor].CGImage;
    [self.navigationController.navigationBar lt_setBackgroundColor:CustomGreenColor];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSDictionary *tmpdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:18.0],NSFontAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = tmpdic;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 25, 25)];
    [backBtn setImage:[UIImage imageNamed:@"back_button.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToPreVC:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    _netIndicatorView = nil;
    _noDataTipV = nil;
    _badNetTipV = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)showMoreOperationBtn {
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setFrame:CGRectMake(0, 0, 22, 22)];
    [moreBtn setImage:[UIImage imageNamed:@"more_btn.png"] forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreOpClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    
//    UIBarButtonItem *tmpBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(moreOpClick:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)moreOpClick:(UIButton *)sender {
    
}

- (DDActivityIndicatorView *)netIndicatorView {
    if (!_netIndicatorView) {
        _netIndicatorView = [[DDActivityIndicatorView alloc] init];
        [_netIndicatorView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
        [self.view addSubview:_netIndicatorView];
        [_netIndicatorView hide];
    }
    [self.view bringSubviewToFront:_netIndicatorView];
    return _netIndicatorView;
}

- (BadNetTipView *)badNetTipV {
    if (!_badNetTipV) {
        __weak __typeof(self)weakSelf = self;
        _badNetTipV = [[BadNetTipView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight) withRetryEvent:^(UIButton *sender){
            [weakSelf requestMainInfo];
        }];
        [self.view addSubview:_badNetTipV];
        [_badNetTipV hide];
    }
    [self.view bringSubviewToFront:_badNetTipV];
    return _badNetTipV;
}

- (NoDataTipView *)noDataTipV {
    if (!_noDataTipV) {
        _noDataTipV = [[NoDataTipView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight)];
        [self.view addSubview:_noDataTipV];
        [_noDataTipV hide];
    }
    [self.view bringSubviewToFront:_noDataTipV];
    return _noDataTipV;
}

- (NoDataTipView *)noDataTipView {
    if (!_noDataTipV) {
        _noDataTipV = [[NoDataTipView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight)];
//        [self.view addSubview:_noDataTipV];
        [_noDataTipV hide];
    }
//    [self.view bringSubviewToFront:_noDataTipV];
    return _noDataTipV;
}

- (void)requestMainInfo {

}

- (void)backToPreVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadingViewDismiss {
    [_proHUD hide:YES];
}

- (void)loadingViewShow:(NSString *)tipStr {
    if (_proHUD == nil) {
        _proHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.navigationController.view addSubview:_proHUD];
    }
    _proHUD.delegate = self;
    if (!tipStr) {
        tipStr = @"网络加载中";
    }
    _proHUD.labelText = tipStr;
    [_proHUD show:YES];
}

- (void)loadingTipView:(NSString *)tipStr callBack:(MBLoadingCB)callBack {
    if (_proHUD == nil) {
        _proHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.navigationController.view addSubview:_proHUD];
    }
    _proHUD.opacity = 0.5f;
    _proHUD.labelFont = [UIFont systemFontOfSize:15.0f];
    _proHUD.cornerRadius = 5.0f;
//    [_proHUD show:YES];
    if (!tipStr) {
        tipStr = @"加载中...";
    }
    _proHUD.mode = MBProgressHUDModeText;
    _proHUD.margin = 10.f;
    //        _proHUD.yOffset = 150.f;
    _proHUD.labelText = tipStr;
    [_proHUD showAnimated:YES whileExecutingBlock:^{
        [self doTask];
    } completionBlock:^{
        [_proHUD removeFromSuperview];
        _proHUD = nil;
        if (callBack) {
            callBack();
        }
    }];
}

-(void) doTask{
    //你要进行的一些逻辑操作
    sleep(1.3);
}

#pragma -mark MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [_proHUD removeFromSuperview];
    _proHUD = nil;
}

@end
