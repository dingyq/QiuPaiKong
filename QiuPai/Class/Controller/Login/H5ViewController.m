//
//  H5ViewController.m
//  QiuPai
//
//  Created by bigqiang on 16/1/27.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import "H5ViewController.h"

@interface H5ViewController () <UIWebViewDelegate> {
    UIWebView *_productWebView;
}
@end

@implementation H5ViewController

- (NSString *)pageHtmlUrl {
    return _pageHtmlUrl ? _pageHtmlUrl : kPrivatePolicyH5Url;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 25)];
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    [self initProductWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtnClick:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)initProductWebView {
    _productWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.pageHtmlUrl]];
    _productWebView.delegate = self;
    [self.view addSubview:_productWebView];
    [_productWebView loadRequest:request];
    UIView *superView = self.view;
    [_productWebView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(@0);
        make.top.equalTo(superView.mas_top).with.offset(0);
        make.width.equalTo(@(kFrameWidth));
        make.height.equalTo(@(kFrameHeight));
    }];
    
    _productWebView.scrollView.bounces = NO;
}

#pragma -mark UIWebViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    NSString *path=[[request URL] absoluteString];
    return YES;
}


@end
