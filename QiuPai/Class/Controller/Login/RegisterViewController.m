//
//  RegisterViewController.m
//  QiuPai
//
//  Created by bigqiang on 16/1/19.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController(){
    UITextField *_telePhoneInput;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self.view setBackgroundColor:VCViewBGColor];
    
    [self initTelephoneInputView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initTelephoneInputView {
    CGFloat panelVW = kFrameWidth - 18.0f;
    CGFloat panelVH = 49.0f;
    
    UIView *panelV = [[UIView alloc] initWithFrame:CGRectMake(9, 77, panelVW, panelVH)];
    [panelV setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:panelV];
    
    _telePhoneInput = [[UITextField alloc] initWithFrame:CGRectMake(22, 0, panelVW-44.0f, panelVH)];
    _telePhoneInput.placeholder = @"请输入您的手机号码";
    _telePhoneInput.font = [UIFont systemFontOfSize:14.0f];
    [_telePhoneInput setBackgroundColor:[UIColor whiteColor]];
    [panelV addSubview:_telePhoneInput];
    
    UIButton *getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [getCodeBtn setFrame:CGRectMake(9, CGRectGetMaxY(panelV.frame)+8.0f, panelVW, 45.0f)];
    [getCodeBtn.layer setCornerRadius:2.0f];
    [getCodeBtn setBackgroundColor:CustomGreenColor];
    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [getCodeBtn addTarget:self action:@selector(getCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getCodeBtn];
}

- (void)getCodeBtnClick:(UIButton *)sender {
    
}


@end
