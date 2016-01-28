//
//  RegisterViewController.m
//  QiuPai
//
//  Created by bigqiang on 16/1/19.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController() <UITextFieldDelegate, NetWorkDelegate>{
    UITextField *_nickInput;
    UITextField *_pwdInput;
    UIButton *_nextBtn;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"完善个人资料";
    [self initPersonInfoView];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_nickInput resignFirstResponder];
    [_pwdInput resignFirstResponder];
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {

}

- (void)initPersonInfoView {
    CGFloat panelVW = kFrameWidth;
    CGFloat panelVH = 200;
    CGFloat btnW = 232.0f;
    CGFloat originX = panelVW/2 - btnW/2;
    CGFloat originY = 100.0f;
    
    UIView *panelV = [[UIView alloc] initWithFrame:CGRectMake(0, originY, panelVW, panelVH)];
    [panelV setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:panelV];

    _nickInput = [[UITextField alloc] initWithFrame:CGRectMake(originX, 0, btnW, 40.0)];
    _nickInput.placeholder = @"创建用户名";
    _nickInput.font = [UIFont systemFontOfSize:14.0f];
    _nickInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nickInput.delegate = self;
    _nickInput.returnKeyType = UIReturnKeyDone;
    _nickInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _nickInput.keyboardType = UIKeyboardTypeDefault;
    [_nickInput setBackgroundColor:[UIColor whiteColor]];
    [panelV addSubview:_nickInput];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(originX, CGRectGetMaxY(_nickInput.frame), btnW, 1)];
    [lineView setBackgroundColor:LineViewColor];
    [panelV addSubview:lineView];
    
    _pwdInput = [[UITextField alloc] initWithFrame:CGRectMake(originX, CGRectGetMaxY(lineView.frame), btnW, 40.0)];
    _pwdInput.placeholder = @"设置密码";
    _pwdInput.font = [UIFont systemFontOfSize:14.0f];
    _pwdInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdInput.delegate = self;
    _pwdInput.secureTextEntry = YES;
    _pwdInput.returnKeyType = UIReturnKeyDone;
    _pwdInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _pwdInput.keyboardType = UIKeyboardTypeAlphabet;
    [_pwdInput setBackgroundColor:[UIColor whiteColor]];
    [panelV addSubview:_pwdInput];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(originX, CGRectGetHeight(_pwdInput.frame), btnW, 1)];
    [lineView1 setBackgroundColor:LineViewColor];
    [panelV addSubview:lineView1];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setFrame:CGRectMake(originX, CGRectGetMaxY(_pwdInput.frame) + 16.0, btnW, 42.0f)];
    [_nextBtn.layer setCornerRadius:2.0f];
    [_nextBtn setBackgroundColor:CustomGreenColor];
    [_nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_nextBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [panelV addSubview:_nextBtn];
}

- (void)nextBtnClick:(UIButton *)sender {
    NSString *nick = _nickInput.text;
    NSString *pwd = _pwdInput.text;
    if ([nick isEqualToString:@""]) {
        [self loadingTipView:@"请输入用户名" callBack:nil];
        return;
    } else if ([pwd isEqualToString:@""]) {
        [self loadingTipView:@"请输入密码" callBack:nil];
        return;
    }
    [self sendUserRegisterRequest:nick pwd:[pwd selfDefineMD5Encryption]];
    // 校验用户名
//    else if (![Helper validateUserName:nick]) {
//        [self loadingTipView:@"请输入正确的用户名" callBack:nil];
//        return;
//    }
}

#pragma -mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {

}

- (void)textFieldDidEndEditing:(UITextField *)textField {

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_nickInput == textField) {
        if ([toBeString length] > kNickCount) {
            textField.text = [toBeString substringToIndex:kNickCount];
            return NO;
        } else if ([toBeString length] < kNickCount) {
            return YES;
        }
    } else if (_pwdInput == textField) {
        if ([toBeString length] > kPwdMaxCount) {
            textField.text = [toBeString substringToIndex:kPwdMaxCount];
            return NO;
        } else if ([toBeString length] < kPwdMaxCount) {
            return YES;
        }
    }
    return YES;
}

- (void)sendUserRegisterRequest:(NSString *)name pwd:(NSString *)pwd {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:name forKey:@"nick"];
    [paramDic setObject:pwd forKey:@"pwd"];
    [paramDic setObject:self.telePhoneNum forKey:@"userPhone"];
    [paramDic setObject:self.mobileCode forKey:@"validKey"];
    [paramDic setObject:@1 forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserRegisterRequest:paramDic];
    info.delegate = self;
}

#pragma -mark NetWorkDelegate
- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    if (requestID == RequestID_SendUserRegisterRequest) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            [[QiuPaiUserModel getUserInstance] updateWithDic:dataDic];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self loadingTipView:[dic objectForKey:@"statusInfo"] callBack:nil];
        }
    }
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {
    
}


@end
