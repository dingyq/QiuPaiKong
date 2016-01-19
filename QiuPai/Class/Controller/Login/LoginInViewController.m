//
//  LoginInViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/12/17.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "LoginInViewController.h"
#import "RegisterViewController.h"

@interface LoginInViewController() <NetWorkDelegate, WXApiManagerDelegate> {

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
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setFrame:CGRectMake(0, 0, 40, 25)];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:registerBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self initThirdLoginView];
    [WXApiManager sharedManager].delegate = self;
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

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:IdentifierUserRegisterVC]) {
        RegisterViewController *vc = [[RegisterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)backBtnClick:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)registerBtnClick:(UIButton *)sender {
    [self performSegueWithIdentifier:IdentifierUserRegisterVC sender:nil];
}

- (void)initThirdLoginView {
    CGFloat viewH = 180.0f;
    UIView *panelView = [[UIView alloc] initWithFrame:CGRectMake(0, kFrameHeight/2-130.0f, kFrameWidth, viewH)];
    CGFloat originY = 0.0f;
    
    UILabel *tipL = [[UILabel alloc] initWithFrame:CGRectMake(0, originY, kFrameWidth, 20)];
    [tipL setFont:[UIFont systemFontOfSize:15.0f]];
    [tipL setTextColor:Gray51Color];
    [tipL setText:@"智能一键登录"];
    [tipL setTextAlignment:NSTextAlignmentCenter];
    [panelView addSubview:tipL];
    originY = originY + 55;
    
    UIButton *wxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wxBtn setFrame:CGRectMake(kFrameWidth/2 - 76/2, originY, 76, 76)];
    [wxBtn setImage:[UIImage imageNamed:@"wx_login_btn.png"] forState:UIControlStateNormal];
    [wxBtn setImage:[UIImage imageNamed:@"wx_login_btn.png"] forState:UIControlStateSelected];
    [wxBtn addTarget:self action:@selector(wxLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [panelView addSubview:wxBtn];
    originY = originY + 76 + 5;
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, originY, kFrameWidth, 20)];
    [tipLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [tipLabel setTextColor:Gray51Color];
    [tipLabel setText:@"微信登录"];
    [tipLabel setTextAlignment:NSTextAlignmentCenter];
    [panelView addSubview:tipLabel];
    
    [self.view addSubview:panelView];
}

- (void)wxLoginBtnClick:(UIButton *)sender {
    NSLog(@"wxLoginBtnClick");
    [WXApiRequestHandler sendAuthRequestScope:KAuthScope State:KAuthState OpenID:@"" InViewController:self];
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

#pragma mark - NetWorkDelegate

- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    [self loadingViewDismiss];
    if (requestID == RequestID_SendUserLoginRequest) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            [[QiuPaiUserModel getUserInstance] updateWithDic:dataDic];
            NSLog(@"登录成功");
            [self backBtnClick:nil];
        }
    }
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {
    [self loadingViewDismiss];
}


#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
//    NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
//    NSString *strMsg = [NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", response.code, response.state, response.errCode];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
//                                                    message:strMsg
//                                                   delegate:self
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil, nil];
//    [alert show];
    if (response.errCode == 0) {
        // 授权成功
        [self sendUserLoginRequest:UserTypeWeiXin loginMode:LoginModePwd loginName:@"" loginPwd:response.code];
    } else {
        // 授权失败
        
    }
}


@end
