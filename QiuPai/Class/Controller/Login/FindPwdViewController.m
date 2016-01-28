//
//  FindPwdViewController.m
//  QiuPai
//
//  Created by bigqiang on 16/1/21.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import "FindPwdViewController.h"

@interface FindPwdViewController() <NetWorkDelegate, UITextFieldDelegate> {
    UITextField *_telePhoneInput;
    UIButton *_completeBtn;
    
    UIView *_authCodeView;
    UITextField *_authCodeInput;
    UIButton *_getCodeBtn;
    
    UITextField *_pwdInput;
    UITextField *_confirmPwdInput;
    
    NSString *_telePhone;
    NSString *_mobileCode;
}

@end

@implementation FindPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    [self initFindPwdView];
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
    [_telePhoneInput resignFirstResponder];
    [_authCodeInput resignFirstResponder];
    [_pwdInput resignFirstResponder];
    [_confirmPwdInput resignFirstResponder];
}

- (void)initFindPwdView {
    CGFloat viewW = kFrameWidth;
    CGFloat viewH = 280.0f;
    CGFloat originY = 100.0f;
    UIView *findPwdView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, viewW, viewH)];
    
    CGFloat btnW = 232.0f;
    CGFloat originX = viewW/2 - btnW/2;

    _telePhoneInput = [[UITextField alloc] initWithFrame:CGRectMake(originX, 0, btnW, 40.0)];
    _telePhoneInput.placeholder = @"请输入您的手机号码";
    _telePhoneInput.font = [UIFont systemFontOfSize:14.0f];
    _telePhoneInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    _telePhoneInput.delegate = self;
    _telePhoneInput.returnKeyType = UIReturnKeyDone;
    _telePhoneInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _telePhoneInput.keyboardType = UIKeyboardTypeNumberPad;
    [_telePhoneInput setBackgroundColor:[UIColor whiteColor]];
    [findPwdView addSubview:_telePhoneInput];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(originX, CGRectGetMaxY(_telePhoneInput.frame), btnW, 1)];
    [lineView setBackgroundColor:LineViewColor];
    [findPwdView addSubview:lineView];
    
    _authCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), viewW, 41.0f)];
    [_authCodeView setBackgroundColor:[UIColor clearColor]];
    [findPwdView addSubview:_authCodeView];
    
    _authCodeInput = [[UITextField alloc] initWithFrame:CGRectMake(originX, 0, btnW - 70, 40.0)];
    _authCodeInput.placeholder = @"请输入短信验证码";
    _authCodeInput.font = [UIFont systemFontOfSize:14.0f];
    _authCodeInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    _authCodeInput.delegate = self;
    _authCodeInput.returnKeyType = UIReturnKeyDone;
    _authCodeInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _authCodeInput.keyboardType = UIKeyboardTypeNumberPad;
    [_authCodeInput setBackgroundColor:[UIColor whiteColor]];
    [_authCodeView addSubview:_authCodeInput];
    
    _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getCodeBtn setFrame:CGRectMake(CGRectGetMaxX(_authCodeInput.frame), 0, 70, 40.0f)];
    [_getCodeBtn setBackgroundColor:[UIColor clearColor]];
    [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getCodeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_getCodeBtn setTitleColor:Gray202Color forState:UIControlStateDisabled];
    [_getCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [_getCodeBtn addTarget:self action:@selector(getCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_getCodeBtn setEnabled:YES];
    [_authCodeView addSubview:_getCodeBtn];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(originX, CGRectGetMaxY(_authCodeInput.frame), btnW, 1)];
    [lineView1 setBackgroundColor:LineViewColor];
    [_authCodeView addSubview:lineView1];
    
    _pwdInput = [[UITextField alloc] initWithFrame:CGRectMake(originX, CGRectGetMaxY(_authCodeView.frame), btnW, 40.0)];
    _pwdInput.placeholder = @"设置密码";
    _pwdInput.font = [UIFont systemFontOfSize:14.0f];
    _pwdInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdInput.delegate = self;
    _pwdInput.secureTextEntry = YES;
    _pwdInput.returnKeyType = UIReturnKeyDone;
    _pwdInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _pwdInput.keyboardType = UIKeyboardTypeAlphabet;
    [_pwdInput setBackgroundColor:[UIColor whiteColor]];
    [findPwdView addSubview:_pwdInput];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(originX, CGRectGetMaxY(_pwdInput.frame), btnW, 1)];
    [lineView2 setBackgroundColor:LineViewColor];
    [findPwdView addSubview:lineView2];

    _confirmPwdInput = [[UITextField alloc] initWithFrame:CGRectMake(originX, CGRectGetMaxY(lineView2.frame), btnW, 40.0)];
    _confirmPwdInput.placeholder = @"再次输入密码";
    _confirmPwdInput.font = [UIFont systemFontOfSize:14.0f];
    _confirmPwdInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    _confirmPwdInput.delegate = self;
    _confirmPwdInput.secureTextEntry = YES;
    _confirmPwdInput.returnKeyType = UIReturnKeyDone;
    _confirmPwdInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _confirmPwdInput.keyboardType = UIKeyboardTypeAlphabet;
    [_confirmPwdInput setBackgroundColor:[UIColor whiteColor]];
    [findPwdView addSubview:_confirmPwdInput];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(originX, CGRectGetMaxY(_confirmPwdInput.frame), btnW, 1)];
    [lineView3 setBackgroundColor:LineViewColor];
    [findPwdView addSubview:lineView3];
    
    _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_completeBtn setFrame:CGRectMake(originX, CGRectGetMaxY(_confirmPwdInput.frame) + 16.0, btnW, 42.0f)];
    [_completeBtn.layer setCornerRadius:2.0f];
    [_completeBtn setBackgroundColor:CustomGreenColor];
    [_completeBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_completeBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [_completeBtn addTarget:self action:@selector(completeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [findPwdView addSubview:_completeBtn];

    [self.view addSubview:findPwdView];
}

- (void)completeBtnClick:(UIButton *)sender {
    // 发送使用验证码登录请求
    NSLog(@"send login request");
    NSString *phoneNum = _telePhoneInput.text;
    NSString *authCode = _authCodeInput.text;
    NSString *newPwd = _pwdInput.text;
    NSString *confirmPwd = _confirmPwdInput.text;
    if ([phoneNum isEqualToString:@""]) {
        [self loadingTipView:@"请输入手机号" callBack:nil];
        return;
    } else if (![Helper validateMobile:phoneNum]) {
        [self loadingTipView:@"请输入正确的手机号" callBack:nil];
        return;
    } else if ([authCode isEqualToString:@""]) {
        [self loadingTipView:@"请输入短信验证码" callBack:nil];
        return;
    } else if (![Helper validateMobileCode:authCode]) {
        [self loadingTipView:@"请输入正确的验证码" callBack:nil];
        return;
    } else if ([newPwd isEqualToString:@""]) {
        [self loadingTipView:@"请输入新密码" callBack:nil];
        return;
    } else if (newPwd.length < 6) {
        [self loadingTipView:@"请输入正确的新密码" callBack:nil];
        return;
    } else if ([confirmPwd isEqualToString:@""]) {
        [self loadingTipView:@"请输入确认密码" callBack:nil];
        return;
    } else if (confirmPwd.length < 6) {
        [self loadingTipView:@"请输入正确的确认密码" callBack:nil];
        return;
    } else if (![newPwd isEqualToString:confirmPwd]) {
        [self loadingTipView:@"两次输入的密码不同" callBack:nil];
        return;
    }
    _telePhone = _telePhoneInput.text;
    _mobileCode = _authCodeInput.text;
    
    [self sendFindPwdRequest:phoneNum mobileCode:authCode newPwd:[newPwd selfDefineMD5Encryption]];
}

- (void)getCodeBtnClick:(UIButton *)sender {
    NSString *phoneNum = _telePhoneInput.text;
    if ([phoneNum isEqualToString:@""]) {
        [self loadingTipView:@"请输入手机号" callBack:nil];
        return;
    } else if (![Helper validateMobile:phoneNum]) {
        [self loadingTipView:@"请输入正确的手机号" callBack:nil];
        return;
    }
    [self startTime];
    [self sendGetMobileCodeRequest:phoneNum];
}

- (void)startTime {
    __block NSInteger timeout = kTotalTime - 1;
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_getCodeBtn setEnabled:YES];
                [_getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
            });
        } else {
            NSInteger seconds = timeout%kTotalTime;
            NSString *strTime = [NSString stringWithFormat:@"%.2ld", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_getCodeBtn setEnabled:NO];
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1.0f];
                [_getCodeBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateDisabled];
                [UIView commitAnimations];
            });
            timeout -- ;
        }
    });
    dispatch_resume(_timer);
}

- (void)sendGetMobileCodeRequest:(NSString *)phoneNum {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:phoneNum forKey:@"userPhone"];
    RequestInfo *info = [HttpRequestManager getMobileAuthCode:paramDic];
    info.delegate = self;
}

- (void)sendFindPwdRequest:(NSString *)telePhone mobileCode:(NSString *)code newPwd:(NSString *)newPwd {
    [self loadingViewShow:@"正在修改中..."];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:telePhone forKey:@"userPhone"];
    [paramDic setObject:code forKey:@"validKey"];
    [paramDic setObject:newPwd forKey:@"newPwd"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager findPwdBack:paramDic];
    info.delegate = self;
}

#pragma -mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {}

- (void)textFieldDidEndEditing:(UITextField *)textField {}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_telePhoneInput == textField) {
        [_authCodeInput becomeFirstResponder];
    } else if (_authCodeInput == textField) {
        [_pwdInput becomeFirstResponder];
    } else if (_pwdInput == textField) {
        [_confirmPwdInput becomeFirstResponder];
    } else if (_confirmPwdInput == textField) {
        [_confirmPwdInput resignFirstResponder];
        [self completeBtnClick:nil];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_telePhoneInput == textField) {
        if ([toBeString length] > kPhoneNumCount) {
            textField.text = [toBeString substringToIndex:kPhoneNumCount];
            return NO;
        } else if ([toBeString length] < kPhoneNumCount) {
            return YES;
        }
    } else if (_authCodeInput == textField) {
        if ([toBeString length] > kMobileCodeCount) {
            textField.text = [toBeString substringToIndex:kMobileCodeCount];
            return NO;
        } else if ([toBeString length] < kMobileCodeCount) {
            return YES;
        }
    } else if (_pwdInput == textField) {
        if ([toBeString length] > kPwdMaxCount) {
            textField.text = [toBeString substringToIndex:kPwdMaxCount];
            return NO;
        } else if ([toBeString length] < kPwdMaxCount) {
            return YES;
        }
    } else if (_confirmPwdInput == textField) {
        if ([toBeString length] > kPwdMaxCount) {
            textField.text = [toBeString substringToIndex:kPwdMaxCount];
            return NO;
        } else if ([toBeString length] < kPwdMaxCount) {
            return YES;
        }
    }
    return YES;
}

#pragma mark - NetWorkDelegate
- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    if (requestID == RequestID_FindPwdBack) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            [self loadingViewDismiss];
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            [[QiuPaiUserModel getUserInstance] updateWithDic:dataDic];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkErrorMobileCode) {
            // 提示短信验证码有误，待验证
            [self loadingTipView:@"验证码不正确" callBack:nil];
        } else if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkNoSuchUser) {
            // 新用户需注册
            [self loadingTipView:@"该号码不存在，请直接使用短信验证码方式登录" callBack:^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        } else {
            [self loadingTipView:[dic objectForKey:@"statusInfo"] callBack:nil];
        }
        
    } else if (requestID == RequestID_GetMobileAuthCode) {
        
    }
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {
    [self loadingViewDismiss];
}


@end
