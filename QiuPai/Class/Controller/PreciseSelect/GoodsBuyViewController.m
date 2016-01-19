//
//  GoodsBuyViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/12/12.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "GoodsBuyViewController.h"

@interface GoodsBuyViewController () <UIWebViewDelegate> {
    UIWebView *_productWebView;
}
@end

@implementation GoodsBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initProductWebView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initProductWebView {
    if ([_pageHtmlUrl isEqualToString:@""] || _pageHtmlUrl == nil) {
        NSLog(@"illegal pageHtmlUrl");
    }
    
    _productWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kFrameWidth, kFrameHeight-64)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_pageHtmlUrl]];
    _productWebView.delegate = self;
    [self.view addSubview:_productWebView];
    [_productWebView loadRequest:request];
}

#pragma -mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.netIndicatorView show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.netIndicatorView hide];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [self.netIndicatorView hide];
}

@end
