//
//  PwdLoginViewController.m
//  QiuPai
//
//  Created by bigqiang on 16/1/21.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import "PwdLoginViewController.h"
#import "FindPwdViewController.h"

@interface PwdLoginViewController() <UITextFieldDelegate, NetWorkDelegate>{
    UITextField *_telePhoneInput;
    UITextField *_pwdInput;
    UIButton *_getCodeBtn;
    
    UILabel *_tipLabel;
}

@end

@implementation PwdLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"使用密码登录";
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_telePhoneInput resignFirstResponder];
    [_pwdInput resignFirstResponder];
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:IdentifierFindPwdVC]) {
        FindPwdViewController *vc = [[FindPwdViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)initTelephoneInputView {
    CGFloat panelVW = kFrameWidth;
    CGFloat panelVH = 49.0f+200;
    
    UIView *panelV = [[UIView alloc] initWithFrame:CGRectMake(0, 100, panelVW, panelVH)];
    [panelV setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:panelV];
    
    CGFloat btnW = 232.0f;
    CGFloat originX = panelVW/2 - btnW/2;
    _telePhoneInput = [[UITextField alloc] initWithFrame:CGRectMake(originX, 0, btnW, 40.0)];
    _telePhoneInput.placeholder = @"请输入您的手机号码";
    _telePhoneInput.font = [UIFont systemFontOfSize:14.0f];
    _telePhoneInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    _telePhoneInput.delegate = self;
    _telePhoneInput.returnKeyType = UIReturnKeyDone;
    _telePhoneInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _telePhoneInput.keyboardType = UIKeyboardTypeNumberPad;
    [_telePhoneInput setBackgroundColor:[UIColor whiteColor]];
    [panelV addSubview:_telePhoneInput];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(originX, CGRectGetMaxY(_telePhoneInput.frame), btnW, 1)];
    [lineView setBackgroundColor:LineViewColor];
    [panelV addSubview:lineView];
    
    _pwdInput = [[UITextField alloc] initWithFrame:CGRectMake(originX, CGRectGetMaxY(lineView.frame), btnW, 40.0)];
    _pwdInput.placeholder = @"请输入您的密码";
    _pwdInput.font = [UIFont systemFontOfSize:14.0f];
    _pwdInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwdInput.delegate = self;
    _pwdInput.secureTextEntry = YES;
    _pwdInput.returnKeyType = UIReturnKeyDone;
    _pwdInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _pwdInput.keyboardType = UIKeyboardTypeAlphabet;
    [_pwdInput setBackgroundColor:[UIColor whiteColor]];
    [panelV addSubview:_pwdInput];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(originX, CGRectGetMaxY(_pwdInput.frame), btnW, 1)];
    [lineView1 setBackgroundColor:LineViewColor];
    [panelV addSubview:lineView1];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setFrame:CGRectMake(originX, CGRectGetMaxY(_getCodeBtn.frame) + 12.0, btnW, 16.0f)];
    loginBtn.layer.cornerRadius = 2.0f;
    [loginBtn setBackgroundColor:CustomGreenColor];
    [loginBtn setTitle:@"确认登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setFrame:CGRectMake(originX, CGRectGetMaxY(lineView1.frame)+16.0f, btnW, 42.0f)];
    [panelV addSubview:loginBtn];
    
    UIButton *findPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [findPwdBtn setFrame:CGRectMake(originX, CGRectGetMaxY(loginBtn.frame) + 12.0, btnW, 16.0f)];
    [findPwdBtn setBackgroundColor:[UIColor clearColor]];
    [findPwdBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [findPwdBtn setTitleColor:Gray202Color forState:UIControlStateNormal];
    [findPwdBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [findPwdBtn addTarget:self action:@selector(findPwdBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [panelV addSubview:findPwdBtn];
}

- (void)loginBtnClick:(UIButton *)sender {
    NSString *phoneNum = _telePhoneInput.text;
    NSString *pwd = _pwdInput.text;
    
    if ([phoneNum isEqualToString:@""]) {
        [self loadingTipView:@"请输入手机号" callBack:nil];
        return;
    } else if (![Helper validateMobile:phoneNum]) {
        [self loadingTipView:@"请输入正确的手机号" callBack:nil];
        return;
    } else if ([pwd isEqualToString:@""]) {
        [self loadingTipView:@"请输入密码" callBack:nil];
        return;
    } else if (pwd.length < kPwdMinCount) {
        [self loadingTipView:@"请输入正确的密码" callBack:nil];
        return;
    }
    [self sendUserLoginRequest:UserTypeLocalUser loginMode:LoginModePwd loginName:phoneNum loginPwd:[pwd selfDefineMD5Encryption]];
}

- (void)findPwdBtnClick:(UIButton *)sender {
    [self performSegueWithIdentifier:IdentifierFindPwdVC sender:nil];
}

- (void)sendUserLoginRequest:(UserType)userType loginMode:(LoginMode)mode loginName:(NSString *)name loginPwd:(NSString *)pwd {
    [self loadingViewShow:@"正在登录中..."];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:userType] forKey:@"userType"];
    [paramDic setObject:[NSNumber numberWithInteger:mode] forKey:@"logmod"];
    [paramDic setObject:name forKey:@"userName"];
    [paramDic setObject:pwd forKey:@"pwd"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserLoginRequest:paramDic];
    info.delegate = self;
}

#pragma -mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {}

- (void)textFieldDidEndEditing:(UITextField *)textField {}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_telePhoneInput == textField) {
        [_pwdInput becomeFirstResponder];
    } else if (_pwdInput == textField) {
        [_pwdInput resignFirstResponder];
        [self loginBtnClick:nil];
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


#pragma -mark NetWorkDelegate

- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    if (requestID == RequestID_SendUserLoginRequest) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            LoginFlag logFlag = [[dataDic objectForKey:@"logFlag"] integerValue];
            if (logFlag == LoginFlag_Success){
                NSLog(@"登录成功");
                [self loadingViewDismiss];
                [[QiuPaiUserModel getUserInstance] updateWithDic:dataDic];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            } else if (logFlag == LoginFlag_Error_PhoneNum) {
                [self loadingTipView:@"手机号不正确" callBack:nil];
            } else {
                NSString *tipStr = [dataDic objectForKey:@"logInfo"];
                if (tipStr == nil && [tipStr isEqualToString:@""]) {
                    tipStr = @"登录错误";
                }
                [self loadingTipView:tipStr callBack:nil];
            }
        }
    }
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {
    
}

@end
