//
//  LoginInViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/12/17.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "LoginInViewController.h"
#import "RegisterViewController.h"
#import "PwdLoginViewController.h"
#import "QQSdkCall.h"
#import "H5ViewController.h"
#import "CompleteInfoGuideViewController.h"

@interface LoginInViewController() <NetWorkDelegate, WXApiManagerDelegate, WBApiManagerDelegate, UITextFieldDelegate> {
    UITextField *_telePhoneInput;
    UIButton *_getCodeBtn;
    UIButton *_pwdLoginBtn;
    
    UIView *_authCodeView;
    UITextField *_authCodeInput;
    UIButton *_regetCodeBtn;
    
    NSString *_telePhone;
    NSString *_mobileCode;
}

@end

@implementation LoginInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 25)];
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    [self initUserLoginView];
    [self initThirdLoginView];
    [self initPrivatePolicyBtn];
    
    [WXApiManager sharedManager].delegate = self;
    [WBApiManager sharedManager].delegate = self;
    // QQ
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessed) name:kLoginSuccessed object:[QQSdkCall getInstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:kLoginFailed object:[QQSdkCall getInstance]];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginSuccessed object:[QQSdkCall getInstance]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginFailed object:[QQSdkCall getInstance]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_telePhoneInput resignFirstResponder];
    [_authCodeInput resignFirstResponder];
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:IdentifierPwdLoginVC]) {
        PwdLoginViewController *vc = [[PwdLoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:IdentifierUserRegisterVC]) {
        RegisterViewController *vc = [[RegisterViewController alloc] init];
        vc.telePhoneNum = _telePhone;
        vc.mobileCode = _mobileCode;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:IdentifierPrivatePolicyVC]) {
        H5ViewController *vc = [[H5ViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = @"隐私政策";
        [vc.navigationController setNavigationBarHidden:NO animated:NO];
        DDNavigationController* nav = [[DDNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    } else if ([IdentifierCompleteInfoGuideVC isEqualToString:identifier]) {
        CompleteInfoGuideViewController *vc = [[CompleteInfoGuideViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)backBtnClick:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)initUserLoginView {
    CGFloat viewW = kFrameWidth;
    CGFloat viewH = 200.0f;
    CGFloat originY = 100;
    UIView *loginInView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, viewW, viewH)];
    
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
    [loginInView addSubview:_telePhoneInput];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(originX, CGRectGetMaxY(_telePhoneInput.frame), btnW, 1)];
    [lineView setBackgroundColor:LineViewColor];
    [loginInView addSubview:lineView];
    
    _authCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), viewW, 0)];
    [_authCodeView setHidden:YES];
    [_authCodeView setBackgroundColor:[UIColor clearColor]];
    [loginInView addSubview:_authCodeView];
    
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

    _regetCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_regetCodeBtn setFrame:CGRectMake(CGRectGetMaxX(_authCodeInput.frame), 0, 70, 40.0f)];
    [_regetCodeBtn setBackgroundColor:[UIColor clearColor]];
    [_regetCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    [_regetCodeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_regetCodeBtn setTitleColor:Gray202Color forState:UIControlStateDisabled];
    [_regetCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [_regetCodeBtn addTarget:self action:@selector(getCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_regetCodeBtn setEnabled:NO];
    [_authCodeView addSubview:_regetCodeBtn];

    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(originX, CGRectGetHeight(_authCodeView.frame), btnW, 1)];
    [lineView1 setBackgroundColor:LineViewColor];
    [_authCodeView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_authCodeView.mas_bottom).with.offset(-1);
        make.left.equalTo(@(originX));
        make.width.equalTo(@(btnW));
        make.height.equalTo(@1);
    }];

    //
    _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getCodeBtn setFrame:CGRectMake(originX, CGRectGetMaxY(_authCodeView.frame) + 16.0, btnW, 42.0f)];
    [_getCodeBtn.layer setCornerRadius:2.0f];
    [_getCodeBtn setBackgroundColor:CustomGreenColor];
    [_getCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [_getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_getCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [_getCodeBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginInView addSubview:_getCodeBtn];
    
    _pwdLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pwdLoginBtn setFrame:CGRectMake(originX, CGRectGetMaxY(_getCodeBtn.frame) + 12.0, btnW, 16.0f)];
    [_pwdLoginBtn setBackgroundColor:[UIColor clearColor]];
    [_pwdLoginBtn setTitle:@"使用密码登录" forState:UIControlStateNormal];
    [_pwdLoginBtn setTitleColor:Gray202Color forState:UIControlStateNormal];
    [_pwdLoginBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [_pwdLoginBtn addTarget:self action:@selector(userPwdToLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginInView addSubview:_pwdLoginBtn];

    [self.view addSubview:loginInView];
}

- (void)loginBtnClick:(UIButton *)sender {
    if ([_authCodeView isHidden]) {
        NSString *phoneNum = _telePhoneInput.text;
        if ([phoneNum isEqualToString:@""]) {
            [self loadingTipView:@"请输入手机号" callBack:nil];
            return;
        } else if (![Helper validateMobile:phoneNum]) {
            [self loadingTipView:@"请输入正确的手机号" callBack:nil];
            return;
        }
        [_authCodeView setHidden:NO];
        [sender setTitle:@"登录" forState:UIControlStateNormal];
        CGRect authVframe = [_authCodeView frame];
        authVframe.size.height = 41.0f;
        
        CGRect getCodeBtnFrame = [_getCodeBtn frame];
        getCodeBtnFrame.origin.y = CGRectGetMaxY(authVframe) + 16.0;
        
        CGRect pwdLoginBtnFrame = [_pwdLoginBtn frame];
        pwdLoginBtnFrame.origin.y = CGRectGetMaxY(getCodeBtnFrame) + 12.0;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [_authCodeView setFrame:authVframe];
        [_getCodeBtn setFrame:getCodeBtnFrame];
        [_pwdLoginBtn setFrame:pwdLoginBtnFrame];
        [UIView commitAnimations];
        [self getCodeBtnClick:nil];
        
        [_authCodeInput becomeFirstResponder];
    } else {
        // 发送使用验证码登录请求
        NSLog(@"send login request");
        NSString *authCode = _authCodeInput.text;
        if ([authCode isEqualToString:@""]) {
            [self loadingTipView:@"请输入短信验证码" callBack:nil];
            return;
        } else if (![Helper validateMobileCode:authCode]) {
            [self loadingTipView:@"请输入正确的验证码" callBack:nil];
            return;
        }
        _telePhone = _telePhoneInput.text;
        _mobileCode = _authCodeInput.text;
        [self sendUserLoginRequest:UserTypeLocalUser loginMode:LoginModeCode loginName:_telePhone loginPwd:_mobileCode];
    }
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

- (void)userPwdToLoginBtnClick:(UIButton *)sender {
    [self performSegueWithIdentifier:IdentifierPwdLoginVC sender:nil];
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
                [_regetCodeBtn setEnabled:YES];
                [_regetCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
            });
        } else {
            NSInteger seconds = timeout%kTotalTime;
            NSString *strTime = [NSString stringWithFormat:@"%.2ld", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_regetCodeBtn setEnabled:NO];
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1.0f];
                [_regetCodeBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateDisabled];
                [UIView commitAnimations];
            });
            timeout -- ;
        }
    });
    dispatch_resume(_timer);
}

- (void)privatePolicyBtnClick:(UIButton *)sender {
    [self performSegueWithIdentifier:IdentifierPrivatePolicyVC sender:nil];
}

- (void)initPrivatePolicyBtn {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"隐私政策"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:Gray202Color range:strRange];
    
    UIButton *policyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [policyBtn setAttributedTitle:str forState:UIControlStateNormal];
    policyBtn.titleLabel.font = [UIFont systemFontOfSize:11.0];
    [policyBtn addTarget:self action:@selector(privatePolicyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:policyBtn];
    [policyBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(@0);
        make.bottom.equalTo(@(-15));
        make.width.equalTo(@55);
        make.height.equalTo(@16);
    }];
}

- (void)initThirdLoginView {
    CGFloat viewW = kFrameWidth;
    CGFloat viewH = 180.0f;
    UIView *panelView = [[UIView alloc] initWithFrame:CGRectMake(0, 300.0f, viewW, viewH)];
    UILabel *tipL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 20)];
    [tipL setFont:[UIFont systemFontOfSize:14.0f]];
    [tipL setTextColor:Gray102Color];
    [tipL setText:@"用社交账号登录"];
    [tipL sizeToFit];
    [tipL setTextAlignment:NSTextAlignmentCenter];
    [panelView addSubview:tipL];
    [tipL mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(panelView.mas_centerX);
        make.top.equalTo(@0);
    }];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 57, 0.5)];
    [leftLine setBackgroundColor:LineViewColor];
    [panelView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(tipL.mas_left).with.offset(-10);
        make.top.equalTo(tipL.mas_top).with.offset(tipL.frame.size.height/2);
        make.width.equalTo(@57);
        make.height.equalTo(@0.5);
    }];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 57, 0.5)];
    [rightLine setBackgroundColor:LineViewColor];
    [panelView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(tipL.mas_right).with.offset(10);
        make.top.equalTo(tipL.mas_top).with.offset(tipL.frame.size.height/2);
        make.width.equalTo(@57);
        make.height.equalTo(@0.5);
    }];
    
    UIView *(^createBtn)(NSString *title, NSString *image, NSInteger tag, CGRect frame, SEL btnEvent) = ^UIView *(NSString *title, NSString *image, NSInteger tag, CGRect frame, SEL btnEvent){
        UIView *tmpView = [[UIView alloc] initWithFrame:frame];
        [tmpView setBackgroundColor:[UIColor clearColor]];
        
        UIButton *tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tmpBtn setFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        [tmpBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        [tmpBtn setTag:tag];
        [tmpBtn addTarget:self action:btnEvent forControlEvents:UIControlEventTouchUpInside];
        [tmpView addSubview:tmpBtn];
        
        UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.width, frame.size.width, frame.size.height - frame.size.width)];
        [tmpLabel setFont:[UIFont systemFontOfSize:11.0f]];
        [tmpLabel setTextColor:Gray202Color];
        [tmpLabel setTextAlignment:NSTextAlignmentCenter];
        [tmpLabel setText:title];
        [tmpView addSubview:tmpLabel];

        return tmpView;
    };
    
    
    NSArray *configArr = @[@{@"title":@"微信", @"image":@"wx_login_btn", @"tag":@100},
                           @{@"title":@"QQ", @"image":@"qq_login_btn", @"tag":@200},
                           @{@"title":@"微博", @"image":@"wb_login_btn", @"tag":@300}];
    CGFloat gap = 37.0f;
    CGFloat vW = 32.0f;
    CGFloat vH = 32.0f + 20.0f;
    CGFloat originY = CGRectGetMaxY(tipL.frame) + 30;
    CGFloat originX = viewW/2 - (vW*configArr.count + gap*(configArr.count - 1))/2;
    for (NSInteger i = 0; i < configArr.count; i++) {
        NSDictionary *dic = [configArr objectAtIndex:i];
        NSString *title = [dic objectForKey:@"title"];
        NSString *image = [dic objectForKey:@"image"];
        NSInteger tag = [[dic objectForKey:@"tag"] integerValue];
        UIView *tmpView = createBtn(title, image, tag, CGRectMake(originX+i*(vW+gap), originY, vW, vH), @selector(thirdLoginBtnClick:));
        [panelView addSubview:tmpView];
    }
    
    [self.view addSubview:panelView];
}

- (void)thirdLoginBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
        {
            NSLog(@"微信登录");
            [WXApiRequestHandler sendAuthRequestScope:KAuthScope State:KAuthState OpenID:@"" InViewController:self];
        }
            break;
        case 200:
        {
            NSLog(@"QQ登录");
            NSArray* permissions = [NSArray arrayWithObjects:
                                    kOPEN_PERMISSION_GET_USER_INFO,
                                    kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                                    kOPEN_PERMISSION_ADD_ALBUM,
                                    kOPEN_PERMISSION_ADD_SHARE,
                                    kOPEN_PERMISSION_ADD_TOPIC,
                                    kOPEN_PERMISSION_GET_INFO,
                                    kOPEN_PERMISSION_GET_OTHER_INFO,
                                    kOPEN_PERMISSION_UPLOAD_PIC,
                                    nil];
            [[[QQSdkCall getInstance] oauth] authorize:permissions inSafari:NO];
        }
            break;
        case 300:
        {
            NSLog(@"微博登录");
            [WBApiRequestHandler sendWeiboAuthRequestScope:@"LoginInViewController"];
        }
            break;
            
        default:
            break;
    }
}

- (void)sendGetMobileCodeRequest:(NSString *)phoneNum {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:phoneNum forKey:@"userPhone"];
    RequestInfo *info = [HttpRequestManager getMobileAuthCode:paramDic];
    info.delegate = self;
}

- (void)sendUserLoginRequest:(UserType)userType loginMode:(LoginMode)mode loginName:(NSString *)name loginPwd:(NSString *)pwd {
    [self loadingViewShow:@"正在登录中..."];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:userType] forKey:@"userType"];
    [paramDic setObject:[NSNumber numberWithInteger:mode] forKey:@"logmod"];
    [paramDic setObject:name forKey:@"userName"];
    [paramDic setObject:pwd forKey:@"pwd"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].wbRefreshToken forKey:@"refreshToken"];
    RequestInfo *info = [HttpRequestManager sendUserLoginRequest:paramDic];
    info.delegate = self;
}

#pragma -mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {}

- (void)textFieldDidEndEditing:(UITextField *)textField {}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (_telePhoneInput == textField) {
        [_authCodeInput becomeFirstResponder];
    } else if (_authCodeInput == textField) {
        [_authCodeInput resignFirstResponder];
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
    }
    return YES;
}

#pragma mark - NetWorkDelegate
- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    if (requestID == RequestID_SendUserLoginRequest) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            LoginFlag logFlag = [[dataDic objectForKey:@"logFlag"] integerValue];
            if (logFlag == LoginFlag_NoUser_AuthCode) {
                [self loadingViewDismiss];
                // 新用户需注册
                [self performSegueWithIdentifier:IdentifierUserRegisterVC sender:nil];
            } else if (logFlag == LoginFlag_Success){
                NSLog(@"登录成功");
                [self loadingViewDismiss];
                [[QiuPaiUserModel getUserInstance] updateWithDic:dataDic];
                UserLoginState isFirstLogin = [[dataDic objectForKey:@"isFirstLogin"] integerValue];
                if (isFirstLogin == UserLoginFirst) {
                    // 用户首次登录时，跳到新用户资料完善页
                    // 只有第三方登录的用户才会走这里的逻辑，手机号首次验证码登录会要求先完善用户名与密码
                    // 第三方首次登录的用户直接完善个人资料
                    [self performSegueWithIdentifier:IdentifierCompleteInfoGuideVC sender:nil];
                } else {
                    [self backBtnClick:nil];
                }
            } else if (logFlag == LoginFlag_Error_PhoneNum) {
                [self loadingTipView:@"手机号不正确" callBack:nil];
            } else {
                [self loadingTipView:[dataDic objectForKey:@"logInfo"] callBack:nil];
            }
        } else {
            NSLog(@"登录失败");
            [self loadingViewDismiss];
        }
    } else if (requestID == RequestID_GetMobileAuthCode) {
        
    }
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {
    [self loadingViewDismiss];
}


#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    if (response.errCode == 0) {
        // 授权成功
        [self sendUserLoginRequest:UserTypeWeiXin loginMode:LoginModePwd loginName:@"" loginPwd:response.code];
    } else {
        // 授权失败
    }
}

#pragma mark -WBApiManagerDelegate
- (void)wbApiManagerDidRecvAuthResponse:(WBAuthorizeResponse *)response {
    if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
        // 授权成功
        NSString *wbtoken = [(WBAuthorizeResponse *)response accessToken];
        NSString *wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        NSString *wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
        
        [QiuPaiUserModel getUserInstance].wbtoken = wbtoken;
        [QiuPaiUserModel getUserInstance].wbCurrentUserID = wbCurrentUserID;
        [QiuPaiUserModel getUserInstance].wbRefreshToken = wbRefreshToken;
        
        [self sendUserLoginRequest:UserTypeWeibo loginMode:LoginModePwd loginName:wbCurrentUserID loginPwd:wbtoken];
    } else {
        // 授权失败
        
    }
}

#pragma mark qq login notify back
-(void)loginSuccessed {
    NSLog(@"loginSuccessed");
    NSString* openId = [[[QQSdkCall getInstance] oauth] openId];
    NSString* accessToken = [[[QQSdkCall getInstance] oauth] accessToken];
    [self sendUserLoginRequest:UserTypeQQ loginMode:LoginModePwd loginName:openId loginPwd:accessToken];
}

-(void)loginFailed {
    NSLog(@"loginFailed");
    NSDictionary* dataDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"", @"openId", @"", @"accessToken", @"-1", @"errCode", nil];
    NSLog(@"%@", dataDic);
}





@end
