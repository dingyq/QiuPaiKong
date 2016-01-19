//
//  FansTBViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/11/23.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "FansTBViewController.h"
#import "SimpleUserInfoModel.h"
#import "UserInfoListCell.h"
#import "HomePageViewController.h"

@interface FansTBViewController () <NetWorkDelegate, TableViewCellInteractionDelegate> {
    NSMutableArray *_fansListArr;
}

@property (nonatomic, assign) NSInteger latestSortId;
@property (nonatomic, assign) NSInteger oldestSortId;
@end

@implementation FansTBViewController

- (NSInteger)latestSortId {
    if (_fansListArr.count > 0) {
        _latestSortId = [[_fansListArr firstObject] sortId];
    } else {
        _latestSortId = 0;
    }
    return _latestSortId;
}

- (NSInteger)oldestSortId {
    if (_fansListArr.count > 0) {
        _oldestSortId = [[_fansListArr lastObject] sortId];
    } else {
        _oldestSortId = 0;
    }
    return _oldestSortId;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _fansListArr = [[NSMutableArray alloc] init];
    
    UIView *tmpView = [[UIView alloc] init];
    [tmpView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableFooterView:tmpView];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addRefreshView:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self getFansListRequest:GetInfoTypeRefresh sortId:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:IdentifierUserMainPage]) {
        SimpleUserInfoModel *tmpModel = (SimpleUserInfoModel *)sender;
        HomePageViewController *vc = [[HomePageViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        vc.isMyHomePage = [tmpModel.itemId isEqualToString:[QiuPaiUserModel getUserInstance].userId];
        vc.turnToCommentVC = NO;
        vc.pageUserId = tmpModel.itemId;
    }
}

- (void)addRefreshView:(UITableView *)tableView {
    
    __weak __typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getFansListRequest:GetInfoTypeRefresh sortId:0];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getFansListRequest:GetInfoTypePull sortId:weakSelf.oldestSortId];
    }];
}

- (void)showNoDataTip {
    if (_fansListArr.count == 0) {
        [self.noDataTipV showWithTip:_isFansVC?@"暂无粉丝":@"暂无关注"];
    } else {
        [self.noDataTipV hide];
    }
}

- (void)getFansListRequest:(GetInfoType)getInfoType sortId:(NSInteger)latestId {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:getInfoType] forKey:@"IdType"];
    [paramDic setObject:[NSNumber numberWithInteger:latestId] forKey:@"lastId"];
    if (_isFansVC) {
        [paramDic setObject:[NSNumber numberWithInteger:ConcernedState_HuFen] forKey:@"IdPart"];
    } else {
        [paramDic setObject:[NSNumber numberWithInteger:ConcernedState_Attentioned] forKey:@"IdPart"];
    }
    
    RequestInfo *info = [HttpRequestManager getAttentionedOrFansUsersList:paramDic];
    info.delegate = self;
}

#pragma mark TableViewCellInteractionDelegate
- (void)sendUserAttentionRequest:(NSString *)evaluUserId {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:evaluUserId forKey:@"concernedId"];
    RequestInfo *info = [HttpRequestManager sendUserAttentionRequest:paramDic];
    info.delegate = self;
}

#pragma mark - NetWorkDelegate

- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    if (requestID == RequestID_GetUserListRelatedWithMe) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSArray *fansData;
            if (_isFansVC) {
                fansData = [[dic objectForKey:@"returnData"] objectForKey:@"concernedMeData"];
            } else {
                fansData = [[dic objectForKey:@"returnData"] objectForKey:@"myConcernedData"];
            }
            
            GetInfoType getType = [[[dic objectForKey:@"returnData"] objectForKey:@"IdType"] integerValue];
            if (getType == GetInfoTypeRefresh) {
                [_fansListArr removeAllObjects];
            }
            for (int i = 0; i < [fansData count]; i++) {
                NSDictionary *tmpDic = [fansData objectAtIndex:i];
                [_fansListArr addObject:[[SimpleUserInfoModel alloc] initWithAttributes:tmpDic]];
            }
            
            NSInteger contDataCout = [fansData count];
            if (getType == GetInfoTypeRefresh) {
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
                if (contDataCout < kPageSizeCount) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            if (contDataCout >= kPageSizeCount) {
                [self.tableView.mj_footer resetNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
            [self showNoDataTip];
        } else {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } else if (requestID == RequestID_SendUserAttention) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            for (int i = 0; i < [_fansListArr count]; i ++) {
                SimpleUserInfoModel *tmpModel = (SimpleUserInfoModel *)[_fansListArr objectAtIndex:i];
                if ([tmpModel.itemId isEqualToString:[dataDic objectForKey:@"userId"]]) {
                    tmpModel.isConcerned = [[dataDic objectForKey:@"isConcerned"] integerValue];
                    if (_isFansVC) {
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    } else {
                        [_fansListArr removeObjectAtIndex:i];
                        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }
            }
            [self showNoDataTip];
        }
    }
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return [_fansListArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[_fansListArr objectAtIndex:indexPath.row] getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"fansInfoCell";
    UserInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UserInfoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.myDelegate = self;
    }
    [cell bindCellWithDataModel:[_fansListArr objectAtIndex:indexPath.row] isFansVC:_isFansVC];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SimpleUserInfoModel *userModel = [_fansListArr objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:IdentifierUserMainPage sender:userModel];
}
@end
