//
//  AboutQPKViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/12/12.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "AboutQPKViewController.h"

#define kConfigNameKey @"name"
#define kConfigValueKey @"value"

@interface AboutQPKViewController() <UITableViewDelegate, UITableViewDataSource> {
    NSArray *_configArr;
    UITableView *_aboutTV;
}

@end

@implementation AboutQPKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:VCViewBGColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _configArr = @[
//                   @{kConfigNameKey:@"网址", kConfigValueKey:@"www.qiupai.co"},
                   @{kConfigNameKey:@"微信公众号", kConfigValueKey:@"qiupaico"},
                   @{kConfigNameKey:@"淘宝店", kConfigValueKey:@"球拍控进口网球装备"}
                   ];
    
    
    
    [self initTipView];
    [self initAboutTV];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initTipView {
    CGFloat logoW = 90.0f;
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(kFrameWidth/2 - logoW/2, 86, logoW, logoW)];
    [logoImage setImage:[UIImage imageNamed:@"logo"]];
    [self.view addSubview:logoImage];
    
    NSString *buildStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    UILabel *versionL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logoImage.frame)+10, kFrameWidth, 20)];
    [versionL setFont:[UIFont systemFontOfSize:16.0f]];
    [versionL setTextColor:Gray51Color];
    [versionL setTextAlignment:NSTextAlignmentCenter];
    [versionL setText:[NSString stringWithFormat:@"版本号：v%@", buildStr]];
    [self.view addSubview:versionL];

    UILabel *enCopyrightL = [[UILabel alloc] initWithFrame:CGRectMake(0, kFrameHeight - 55, kFrameWidth, 15)];
    [enCopyrightL setFont:[UIFont systemFontOfSize:11.0f]];
    [enCopyrightL setTextColor:Gray153Color];
    [enCopyrightL setTextAlignment:NSTextAlignmentCenter];
    [enCopyrightL setText:@"Copyright © 2015-2016 YunKaiRiChu All Rights Reserved"];
    [self.view addSubview:enCopyrightL];
    
    UILabel *cnCopyrightL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(enCopyrightL.frame)+5, kFrameWidth, 15)];
    [cnCopyrightL setFont:[UIFont systemFontOfSize:11.0f]];
    [cnCopyrightL setTextColor:Gray85Color];
    [cnCopyrightL setTextAlignment:NSTextAlignmentCenter];
    [cnCopyrightL setText:@"深圳云开日出科技有限公司 版权所有"];
    [self.view addSubview:cnCopyrightL];
    
}

- (void)initAboutTV {
    CGFloat tvH = _configArr.count * [self getCellHeight];
    _aboutTV = [[UITableView alloc] initWithFrame:CGRectMake(0, kFrameHeight/2-tvH/2, kFrameWidth, tvH) style:UITableViewStylePlain];
    [_aboutTV setDelegate:self];
    [_aboutTV setDataSource:self];
    [_aboutTV setScrollEnabled:NO];
    [_aboutTV setBackgroundColor:[UIColor whiteColor]];
    [_aboutTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_aboutTV];
    
    UIView *tmpView = [[UIView alloc] init];
    [tmpView setBackgroundColor:[UIColor clearColor]];
    [_aboutTV setTableFooterView:tmpView];
}

- (CGFloat)getCellHeight {
    return 45.0f;
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_configArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"aboutCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UILabel *tipLabel;
    UILabel *valueLabel;
    CGFloat cellHeight = [self getCellHeight];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 30, 20)];
        [tipLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [tipLabel setTextColor:Gray153Color];
        [tipLabel setTextAlignment:NSTextAlignmentLeft];
        [tipLabel setTag:100];
        [cell.contentView addSubview:tipLabel];
        
        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tipLabel.frame), 15, 40, 20)];
        [valueLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [valueLabel setTextColor:Gray51Color];
        [valueLabel setTextAlignment:NSTextAlignmentLeft];
        [valueLabel setTag:200];
        [cell.contentView addSubview:valueLabel];
        
        UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 0.5)];
        [upLine setBackgroundColor:LineViewColor];
        [upLine setTag:300];
        [upLine setHidden:YES];
        [cell.contentView addSubview:upLine];
        
        UIView *downLine = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight - 0.5, kFrameWidth, 0.5)];
        [downLine setBackgroundColor:LineViewColor];
        [cell.contentView addSubview:downLine];
    }
    NSString *tipStr = [_configArr[indexPath.row] objectForKey:kConfigNameKey];
    tipLabel = [cell.contentView viewWithTag:100];
    [tipLabel setText:tipStr];
    [tipLabel sizeToFit];
    
    [valueLabel setFrame:CGRectMake(CGRectGetMaxX(tipLabel.frame)+5, 15, 40, 20)];
    NSString *valueStr = [_configArr[indexPath.row] objectForKey:kConfigValueKey];
    valueLabel = [cell.contentView viewWithTag:200];
    [valueLabel setText:valueStr];
    [valueLabel sizeToFit];
    
    UIView *upLine = [cell.contentView viewWithTag:300];
    [upLine setHidden:(indexPath.row == 0 ? NO:YES)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
