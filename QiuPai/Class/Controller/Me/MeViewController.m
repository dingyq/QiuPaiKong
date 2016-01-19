//
//  MeViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/11/3.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "MeViewController.h"

#import "FansTBViewController.h"
#import "QiuPaiUserModel.h"
#import "UIImageView+WebCache.h"
#import "UserHeaderView.h"
#import "NaviBarCustomButton.h"
#import "HomePageViewController.h"
#import "LoginInViewController.h"
#import "MyInfomationViewController.h"

static const CGFloat HeadImageViewHeight = 139;


@interface MeViewController () <NetWorkDelegate, LoginSuccessDelegate> {
    UITableView *_detailTableView;
    NSArray *_configListArr;

    UserHeaderView *_headerView;
    UIView *_naviBarView;
    
    BOOL _isFirstLoad;
}

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.automaticallyAdjustsScrollViewInsets = false;    
    self.title = @"我";
    _isFirstLoad = YES;
    [self initConfigListArr];
    [self initDetailTableView];
    [self initNaviBarView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (![[QiuPaiUserModel getUserInstance] isTimeOut]) {
        [self getAllNewMessage];
        [self getUserInfo];
    } else if(_isFirstLoad) {
        _isFirstLoad = NO;
        [[QiuPaiUserModel getUserInstance] showUserLoginVC];
    }
    
    [self updateUserHeaderView];
    [self updateNaviBarView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:IdentifierAttentionVC]) {
        FansTBViewController *attVC = [[FansTBViewController alloc] init];
        attVC.hidesBottomBarWhenPushed = YES;
        attVC.title = @"关注";
        attVC.isFansVC = NO;
        [self.navigationController pushViewController:attVC animated:YES];
        [attVC.navigationController setNavigationBarHidden:NO animated:NO];
    } else if ([identifier isEqualToString:IdentifierFansVC]) {
        FansTBViewController *fansVC = [[FansTBViewController alloc] init];
        fansVC.hidesBottomBarWhenPushed = YES;
        fansVC.title = @"粉丝";
        fansVC.isFansVC = YES;
        [self.navigationController pushViewController:fansVC animated:YES];
        [fansVC.navigationController setNavigationBarHidden:NO animated:NO];
    } else if ([identifier isEqualToString:IdentifierJifenVC]) {
    
    } else if ([identifier isEqualToString:IdentifierLoadLoginInVC]) {
        LoginInViewController *vc = [[LoginInViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.loginDelegate = self;
        [vc.navigationController setNavigationBarHidden:NO animated:NO];
        DDNavigationController* nav = [[DDNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)initConfigListArr {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *fileName = @"MeConfigList.plist";
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *array;
    if ([fileManager fileExistsAtPath:filePath]) {
        array = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    } else {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MeConfigList" ofType:@"plist"];
        array = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    }
    _configListArr = array;
}

- (void)initDetailTableView {
    _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HeadImageViewHeight + 56, kFrameWidth, kFrameHeight - HeadImageViewHeight - 56) style:UITableViewStylePlain];
    [_detailTableView setDelegate:self];
    [_detailTableView setDataSource:self];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [_detailTableView setBackgroundColor:Gray240Color];
    [_detailTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_detailTableView];
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [_detailTableView setTableFooterView:view];

    _headerView = [[UserHeaderView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, HeadImageViewHeight)];
    [_headerView setBackgroundColor:CustomGreenColor];
    _headerView.isMyHeader = YES;
    [self.view addSubview:_headerView];
}

- (void)updateUserHeaderView {
    [_headerView setHeadViewImage:[QiuPaiUserModel getUserInstance].headPic];
    [_headerView setNameLabelText:[QiuPaiUserModel getUserInstance].nick];
    [_headerView setSexImageTip:[[QiuPaiUserModel getUserInstance].sex integerValue]];
    [_headerView setAgeLabelText:[NSString stringWithFormat:@"%@岁", [[QiuPaiUserModel getUserInstance].age stringValue]]];
    [_headerView setRacketLabelText:[QiuPaiUserModel getUserInstance].racquet];
    [_headerView setOtherInfoLabelText:[[QiuPaiUserModel getUserInstance].lvEevaluate stringValue]];
    
    [_headerView setLoginState:![QiuPaiUserModel getUserInstance].isTimeOut];
}

- (void)initNaviBarView {
    CGFloat naviToolHeight = 50.0f;
    _naviBarView = [[UIView alloc] initWithFrame:CGRectMake(0, HeadImageViewHeight, kFrameWidth, naviToolHeight + 6)];
    [_naviBarView setBackgroundColor:Gray240Color];
    [self.view addSubview:_naviBarView];
    
    NaviBarCustomButton *attentionBtn = [[NaviBarCustomButton alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth/3-1, naviToolHeight) numTip:@"23" tipTitle:@"关注"];
    [attentionBtn setBackgroundColor:[UIColor whiteColor]];
    [attentionBtn setTitleColor:Gray51Color forState:UIControlStateNormal];
    [attentionBtn setTitleColor:Gray51Color forState:UIControlStateHighlighted];
    attentionBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [attentionBtn setTag:101];
    [attentionBtn addTarget:self action:@selector(attentionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_naviBarView addSubview:attentionBtn];
    
    NaviBarCustomButton *fansBtn = [[NaviBarCustomButton alloc] initWithFrame:CGRectMake(kFrameWidth/3, 0, kFrameWidth/3-1, naviToolHeight) numTip:@"23" tipTitle:@"粉丝"];
    [fansBtn setBackgroundColor:[UIColor whiteColor]];
    [fansBtn setTitleColor:Gray51Color forState:UIControlStateNormal];
    [fansBtn setTitleColor:Gray51Color forState:UIControlStateHighlighted];
    fansBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [fansBtn setTag:102];
    [fansBtn addTarget:self action:@selector(fansBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_naviBarView addSubview:fansBtn];
    
    NaviBarCustomButton *jifenBtn = [[NaviBarCustomButton alloc] initWithFrame:CGRectMake(kFrameWidth*2/3, 0, kFrameWidth/3, naviToolHeight) numTip:@"23" tipTitle:@"积分"];
    [jifenBtn setBackgroundColor:[UIColor whiteColor]];
    [jifenBtn setTitleColor:Gray51Color forState:UIControlStateNormal];
    [jifenBtn setTitleColor:Gray51Color forState:UIControlStateHighlighted];
    jifenBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [jifenBtn setTag:103];
    [jifenBtn setEnabled:NO];
    [jifenBtn addTarget:self action:@selector(jifenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_naviBarView addSubview:jifenBtn];
    
}

- (void)updateNaviBarView {
    NaviBarCustomButton *attentionBtn = [_naviBarView viewWithTag:101];
    NSString *concernNnum = [[QiuPaiUserModel getUserInstance].concernNum stringValue];
    if (!concernNnum) {
        concernNnum = @"";
    }
    [attentionBtn setTitle:concernNnum];
    
    NSString *fansNum = [[QiuPaiUserModel getUserInstance].concernedNum stringValue];
    if (!fansNum) {
        fansNum = @"";
    }
    NaviBarCustomButton *fansBtn = [_naviBarView viewWithTag:102];
    [fansBtn setTitle:fansNum];
    
    NSString *score = [[QiuPaiUserModel getUserInstance].score stringValue];
    if (!score) {
        score = @"";
    }
    NaviBarCustomButton *jifenBtn = [_naviBarView viewWithTag:103];
    [jifenBtn setTitle:score];
}

- (void)attentionBtnClick:(UIButton *)sender {
    if ([QiuPaiUserModel getUserInstance].isTimeOut) {
        [[QiuPaiUserModel getUserInstance] showUserLoginVC];
        return;
    }
    [self performSegueWithIdentifier:IdentifierAttentionVC sender:nil];
}

- (void)fansBtnClick:(UIButton *)sender {
    if ([QiuPaiUserModel getUserInstance].isTimeOut) {
        [[QiuPaiUserModel getUserInstance] showUserLoginVC];
        return;
    }
    [self performSegueWithIdentifier:IdentifierFansVC sender:nil];
}

- (void)jifenBtnClick:(UIButton *)sender {
    if ([QiuPaiUserModel getUserInstance].isTimeOut) {
        [[QiuPaiUserModel getUserInstance] showUserLoginVC];
        return;
    }
    [self performSegueWithIdentifier:IdentifierJifenVC sender:nil];
}

- (void)modifyUserInfomation {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].sex forKey:@"sex"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].weight forKey:@"weight"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].height forKey:@"height"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].selfEveluate forKey:@"selfEveluate"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].playFreq forKey:@"playFreq"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].powerSelfEveluate forKey:@"powerSelfEveluate"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].injuries forKey:@"injuries"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].region forKey:@"region"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].style forKey:@"style"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].lvEevaluate forKey:@"lvEevaluate"];
    
    [paramDic setObject:[QiuPaiUserModel getUserInstance].city forKey:@"city"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].province forKey:@"province"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].racquet forKey:@"racquet"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].playYear forKey:@"playYear"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].thumbHeadPic forKey:@"thumbHeadPic"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].headPic forKey:@"headPic"];
    
    // 预留字段
    [paramDic setObject:[QiuPaiUserModel getUserInstance].age forKey:@"age"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].backHand forKey:@"backHand"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].grapHand forKey:@"grapHand"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].otherGame forKey:@"otherGame"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].staOrBurn forKey:@"staOrBurn"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].gripSize forKey:@"gripSize"];
    [paramDic setObject:@[] forKey:@"preference"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].star forKey:@"star"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].color forKey:@"color"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].brand forKey:@"brand"];
    
    [paramDic setObject:[NSNumber numberWithInt:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager modifyPersonalInfo:paramDic];
    info.delegate = self;

}

- (void)getUserInfo {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    RequestInfo *info = [HttpRequestManager getUserInfo:paramDic];
    info.delegate = self;
}

- (void)getAllNewMessage {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    RequestInfo *info = [HttpRequestManager getAllNewMessageTip:paramDic];
    info.delegate = self;
}

#pragma -mark LoginSuccessDelegate
- (void)loginSuccessBackWithData:(NSDictionary *)infoDic {
    
}

#pragma -mark NetWorkDelegate
- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    if (RequestID_GetUserInfo == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            [[QiuPaiUserModel getUserInstance] updateWithDic:dataDic];
            [self updateUserHeaderView];
            [self updateNaviBarView];
        }
    } else if (RequestID_ModifyPersonalInfo == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            // 修改个人信息成功
            
        }
    } else if (RequestID_GetAllMessageInfo == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            // 更新消息数量
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            [QiuPaiUserModel getUserInstance].nConcerned = [dataDic objectForKey:@"newConcerned"];
            [QiuPaiUserModel getUserInstance].nLike = [dataDic objectForKey:@"newPraise"];
            [QiuPaiUserModel getUserInstance].nMessage = [dataDic objectForKey:@"newMessage"];
            
            [_detailTableView reloadData];
        }
    }
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {
    
}

#pragma -mark TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    BOOL needCheckLogin = YES;
    if (indexPath.section == 2 && indexPath.row == 1) {
        needCheckLogin = NO;
    }
    if (needCheckLogin && [QiuPaiUserModel getUserInstance].isTimeOut) {
        [[QiuPaiUserModel getUserInstance] showUserLoginVC];
        return;
    }
    NSArray *configArr = [_configListArr objectAtIndex:indexPath.section];
    NSString * viewClassString = [[configArr objectAtIndex:indexPath.row] objectForKey:@"ViewController"];
    UIViewController* viewController = [[NSClassFromString(viewClassString) alloc] init];
    if(viewController) {
        viewController.hidesBottomBarWhenPushed = YES;
        [viewController.view setBackgroundColor:[UIColor whiteColor]];
        viewController.title = [[configArr objectAtIndex:indexPath.row] objectForKey:@"CellTitle"];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 6.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 6.0)];
    [tmpView setBackgroundColor:Gray240Color];
    return tmpView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48.0f;
}

#pragma -mark TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_configListArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_configListArr objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"MeListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    UILabel *tipLabel;
    UIImageView *tipImage;
    UILabel *newMesTip;
    UIView *lineView;
    if (cell == nil) {
        CGFloat cellHeight = 48.0f;
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, cellHeight)];
        
        tipImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, (cellHeight - 20)/2, 20, 20)];
        [tipImage setTag:100];
        [cell.contentView addSubview:tipImage];
        
        tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, (cellHeight - 20)/2, kFrameWidth - 100, 20)];
        [tipLabel setTextColor:Gray51Color];
        [tipLabel setBackgroundColor:[UIColor clearColor]];
        [tipLabel setFont:[UIFont systemFontOfSize:15.0]];
        [tipLabel setTextAlignment:NSTextAlignmentLeft];
        [tipLabel setTag:101];
        [cell.contentView addSubview:tipLabel];
        
        newMesTip = [[UILabel alloc] initWithFrame:CGRectMake(kFrameWidth - 55, (cellHeight - 16)/2, 24, 16)];
        [newMesTip setBackgroundColor:mUIColorWithRGB(239, 181, 39)];
        [newMesTip setTextColor:[UIColor whiteColor]];
        [newMesTip setFont:[UIFont systemFontOfSize:12.0]];
        [newMesTip setTextAlignment:NSTextAlignmentCenter];
        newMesTip.layer.borderColor = [UIColor clearColor].CGColor;
        newMesTip.layer.borderWidth = 1.0f;
        newMesTip.layer.cornerRadius = 8.0f;
        [newMesTip setClipsToBounds:YES];
        [newMesTip setTag:102];
        [newMesTip setHidden:YES];
        [cell.contentView addSubview:newMesTip];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(50, cellHeight - 0.5f, kFrameWidth-50, 0.5f)];
        [lineView setBackgroundColor:LineViewColor];
        [lineView setTag:103];
        [cell.contentView addSubview:lineView];
    } else {
        tipImage = [cell.contentView viewWithTag:100];
        tipLabel = [cell.contentView viewWithTag:101];
        newMesTip = [cell.contentView viewWithTag:102];
        lineView = [cell.contentView viewWithTag:103];
    }
    NSInteger indexRow = [indexPath row];
    NSInteger indexSection = [indexPath section];
    NSArray *configArr = [_configListArr objectAtIndex:indexSection];
    
    tipLabel.text = [[configArr objectAtIndex:indexRow] objectForKey:@"CellTitle"];
    [tipImage setImage:[UIImage imageNamed:[[configArr objectAtIndex:indexRow] objectForKey:@"CellImage"]]];
    [cell setBackgroundColor:[UIColor whiteColor]];

    if (indexSection == 0 && indexRow == 0) {
        NSInteger countTip = [[QiuPaiUserModel getUserInstance].nMessage integerValue] +
        [[QiuPaiUserModel getUserInstance].nLike integerValue];
        if (countTip > 0) {
            [newMesTip setHidden:NO];
            [newMesTip setText:[NSString stringWithFormat:@"%ld", (long)countTip]];
        }
    } else {
        [newMesTip setHidden:YES];
    }
    
    if (indexRow == [_configListArr[indexSection] count] - 1) {
        [lineView setHidden:YES];
    } else {
        [lineView setHidden:NO];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}




@end
