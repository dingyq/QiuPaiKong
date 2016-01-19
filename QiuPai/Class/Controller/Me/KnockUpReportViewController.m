//
//  KnockUpReportViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/12/24.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "KnockUpReportViewController.h"
#import "CompleteInfomationViewController.h"

@interface KnockUpReportViewController()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    
    NSArray *_tvConfigArr;
    NSMutableArray *_valueArr;
    
    UITableView *_detailTV;
}

@end

static NSString *kTitle = @"title";
static NSString *kImage = @"image";

@implementation KnockUpReportViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"试打报告";

    UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [modifyBtn setFrame:CGRectMake(0, 0, 40, 30)];
    [modifyBtn setTitle:@"修改" forState:UIControlStateNormal];
    modifyBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [modifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [modifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [modifyBtn addTarget:self action:@selector(modifyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:modifyBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
//    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"the_bg_view.png"]];
    
    
    
    
    _tvConfigArr = @[@{kTitle:@"网球运动频率", kImage:@"report_frequent"},
                     @{kTitle:@"力量训练", kImage:@"report_power"},
//                     @{kTitle:@"肌肉类型", kImage:@"report_muscle"},
                     @{kTitle:@"伤病史", kImage:@"report_injury"},
                     @{kTitle:@"场地活动类型", kImage:@"report_ground"},
                     @{kTitle:@"擅长击球风格", kImage:@"report_play"}];
    

    _valueArr = [[NSMutableArray alloc] init];
    [self initDetailTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateValueArr];
    [_detailTV reloadData];
    
    BOOL hasValue = NO;
    if ([_valueArr count]>0) {
        for (NSString *tmpStr in _valueArr) {
            if (![tmpStr isEqualToString:@""]) {
                hasValue = YES;
                return;
            }
        }
    }
    
    if (!hasValue) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"完善个人资料后才可查看试打报告" message:@"" delegate:self cancelButtonTitle:@"立即完善" otherButtonTitles:@"取消", nil];
        [alertView show];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:IdentifierCompleteInfomation]) {
        CompleteInfomationViewController *vc = [[CompleteInfomationViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.isModify = YES;
        [vc.navigationController setNavigationBarHidden:NO animated:NO];
        DDNavigationController* nav = [[DDNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)modifyBtnClick:(UIButton *)sender {
    [self performSegueWithIdentifier:IdentifierCompleteInfomation sender:nil];
}

- (void)updateValueArr {
    [_valueArr removeAllObjects];
    NSDictionary *report = [QiuPaiUserModel getUserInstance].report;
    if (report) {
        NSString *playFreq = [report objectForKey:@"playFreq"]?[report objectForKey:@"playFreq"]:@"";
        NSString *powerSelfEveluate = [report objectForKey:@"powerSelfEveluate"]?[report objectForKey:@"powerSelfEveluate"]:@"";
//        NSString *staOrBurn = [report objectForKey:@"staOrBurn"]?[report objectForKey:@"staOrBurn"]:@"";
        NSString *injuries = [report objectForKey:@"injuries"]?[report objectForKey:@"injuries"]:@"";
        NSString *region = [report objectForKey:@"region"]?[report objectForKey:@"region"]:@"";
        NSString *style = [report objectForKey:@"style"]?[report objectForKey:@"style"]:@"";
        
        [_valueArr addObject:playFreq];
        [_valueArr addObject:powerSelfEveluate];
//        [_valueArr addObject:staOrBurn];
        [_valueArr addObject:injuries];
        [_valueArr addObject:region];
        [_valueArr addObject:style];
    } else {
        [_valueArr addObject:@"一周一次"];
        [_valueArr addObject:@"较强"];
//        [_valueArr addObject:@"爆发型"];
        [_valueArr addObject:@"无"];
        [_valueArr addObject:@"底线附近"];
        [_valueArr addObject:@"平击"];
    }
}

- (void)initDetailTableView {
    _detailTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight) style:UITableViewStylePlain];
    [_detailTV setBackgroundColor:[UIColor clearColor]];
    _detailTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _detailTV.delegate = self;
    _detailTV.dataSource = self;
    [self.view addSubview:_detailTV];
    
    UIView *tmpView = [[UIView alloc] init];
    [tmpView setBackgroundColor:[UIColor clearColor]];
    [_detailTV setTableFooterView:tmpView];
}

#pragma -mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self performSegueWithIdentifier:IdentifierCompleteInfomation sender:nil];
    }
}

#pragma -mark UITableViewDelegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

#pragma -mark UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tvConfigArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"KonckUpReportListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    UILabel *tipLabel;
    UIImageView *tipImage;
    UILabel *contentTip;
    UIView *lineView;
    if (cell == nil) {
        CGFloat cellHeight = 80.0f;
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, cellHeight)];
        
        tipImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, (cellHeight - 50)/2, 50, 50)];
        [tipImage setTag:100];
        [cell.contentView addSubview:tipImage];
        
        tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tipImage.frame)+32, (cellHeight - 46)/2, kFrameWidth - 100, 22)];
        [tipLabel setTextColor:Gray51Color];
        [tipLabel setBackgroundColor:[UIColor clearColor]];
        [tipLabel setFont:[UIFont systemFontOfSize:15.0]];
        [tipLabel setTextAlignment:NSTextAlignmentLeft];
        [tipLabel setTag:101];
        [cell.contentView addSubview:tipLabel];
        
        contentTip = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(tipLabel.frame), CGRectGetMaxY(tipLabel.frame)+3, kFrameWidth -100, 22)];
        [contentTip setBackgroundColor:[UIColor clearColor]];
        [contentTip setTextColor:Gray153Color];
        [contentTip setFont:[UIFont systemFontOfSize:13.0]];
        [contentTip setTextAlignment:NSTextAlignmentLeft];
        [contentTip setTag:102];
        [cell.contentView addSubview:contentTip];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(20, cellHeight - 0.5f, kFrameWidth-20, 0.5f)];
        [lineView setBackgroundColor:LineViewColor];
        [lineView setTag:103];
        [cell.contentView addSubview:lineView];
    } else {
        tipImage = [cell.contentView viewWithTag:100];
        tipLabel = [cell.contentView viewWithTag:101];
        contentTip = [cell.contentView viewWithTag:102];
        lineView = [cell.contentView viewWithTag:103];
    }
    NSInteger indexRow = [indexPath row];
    NSDictionary *configDic = [_tvConfigArr objectAtIndex:indexRow];
    
    tipLabel.text = [configDic objectForKey:kTitle];
    contentTip.text = [_valueArr objectAtIndex:indexRow];
    [tipImage setImage:[UIImage imageNamed:[configDic objectForKey:kImage]]];
    [lineView setHidden:[_tvConfigArr count] - 1 == indexRow ? YES : NO];

    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}


@end
