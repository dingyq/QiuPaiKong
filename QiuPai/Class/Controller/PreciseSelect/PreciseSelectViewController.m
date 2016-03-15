//
//  PreciseSelectViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/11/6.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "PreciseSelectViewController.h"
#import "EvaluationDetailViewController.h"
#import "SpecialTopicViewController.h"
#import "SearchViewController.h"
#import "PreciseSelectTVCell.h"
#import "RacketCollectionInfoModel.h"
#import "RacketCollectionDB.h"
#import "MJRefresh.h"
#import "UINavigationBar+BackgroundColor.h"

@interface PreciseSelectViewController()<TableViewCellInteractionDelegate>{
    UITableView *_detailTableView;
    NSMutableArray *_infoArrayList;
    CGFloat _lastYOffest;
    NSInteger _requestOldSortId;
}
@property (nonatomic, assign) NSInteger latestSortId;
@property (nonatomic, assign) NSInteger oldestSortId;

@end

@implementation PreciseSelectViewController

- (NSInteger)latestSortId {
    if (_infoArrayList.count > 0) {
        _latestSortId = [[_infoArrayList firstObject] sortId];
    } else {
        _latestSortId = 0;
    }
    return _latestSortId;
}

- (NSInteger)oldestSortId {
    if (_infoArrayList.count > 0) {
        _oldestSortId = [[_infoArrayList lastObject] sortId];
    } else {
        _oldestSortId = 0;
    }
    return _oldestSortId;
}

- (void)handleDataAndRefreshUI:(NSArray *)contData getInfoType:(GetInfoType)getInfoType {
    if (contData.count <= 0) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *remoArr = [[NSMutableArray alloc] init];
        NSMutableArray *addArr = [[NSMutableArray alloc] init];
        if (getInfoType == GetInfoTypeRefresh) {
            /*
             * 当刷新请求回来时，如果结果总数大于kPageSizeCount，
             * 且结果中的最小sortId比已知的最大sortId最少大2，则说明本地数据过老
             * 为防止这种情况上推获取更多数据时保证信息的连贯性，需remove掉已有的数据，显示最新的数据
             */
            if (contData.count >= kPageSizeCount && _infoArrayList.count > 0) {
                RacketCollectionInfoModel *tmpModel = [[RacketCollectionInfoModel alloc] initWithAttributes:[contData lastObject]];
                if (tmpModel.sortId > weakSelf.latestSortId + 1) {
                    [_infoArrayList removeAllObjects];
                }
            }
        } else if (getInfoType == GetInfoTypePull) {
            /*
             * 上推时，本地首先加载的缓存数据，如果出现回包数据中最大的sortId比已知的最小的sortId最少还小2，
             * 则说明本地后加载的缓存数据已被全部删除，找到清掉此部分缓存的数据
             */
            if (_infoArrayList.count > 0) {
                if (_requestOldSortId > weakSelf.oldestSortId) {
                    RacketCollectionInfoModel *tmpModel = [[RacketCollectionInfoModel alloc] initWithAttributes:[contData firstObject]];
                    if (tmpModel.sortId < weakSelf.oldestSortId - 1) {
                        BOOL find = NO;
                        NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
                        for (NSInteger i = 0; i < [_infoArrayList count]; i++) {
                            RacketCollectionInfoModel *oldModel = [_infoArrayList objectAtIndex:i];
                            if (find) {
                                [indexSet addIndex:i];
                                [remoArr addObject:oldModel];
                            } else if (oldModel.sortId == _requestOldSortId) {
                                [remoArr addObject:oldModel];
                                [indexSet addIndex:i];
                                find = YES;
                            }
                        }
                        [_infoArrayList removeObjectsAtIndexes:indexSet];
                    }
                }
            }
        }
        
        NSInteger curPos = 0;
        BOOL findFirst = NO;
        for (NSInteger i = 0; i < [contData count]; i++) {
            NSDictionary *tmpDic = [contData objectAtIndex:i];
            RacketCollectionInfoModel *tmpModel = [[RacketCollectionInfoModel alloc] initWithAttributes:tmpDic];
            if (tmpModel.sortId > weakSelf.latestSortId) {
                // 回包数据中model比已知最大的还大，说明本地没有此数据，直接add
                [addArr addObject:tmpModel];
            } else if(tmpModel.sortId < weakSelf.oldestSortId) {
                // 回包数据中最大sortId比已知最小的还小，说明本地没有此数据，直接add
                [addArr addObject:tmpModel];
            } else {
                // 出现重复部分（只有刷新时才会走这里，因为上推时，以最小sortId去获取数据，回包的最大sortId肯定比已知的最小sortId小）
                // 所以也只能在刷新数据时才能获知本地是否存在已被删除的数据
                // contData与_infoArrayList 数组都是降序排列
                for (NSInteger j = curPos; j < [_infoArrayList count]; j++) {
                    RacketCollectionInfoModel *oldModel = [_infoArrayList objectAtIndex:j];
                    if (tmpModel.itemId == oldModel.itemId) {
                        [oldModel updateAttributes:tmpDic];
                        findFirst = YES;
                        curPos = j+1;
                        break;
                    } else {
                        if (findFirst) {
                            // 找到对齐位置，但发生不连续，说明此处
                            // 本地缓存到了服务器上不存在的数据，记录此条非法数据，并继续比对下一个元素
                            [remoArr addObject:oldModel];
                        }
                    }
                }
                
            }
        }
        
        for (RacketCollectionInfoModel *tmpModel in addArr) {
            [_infoArrayList addObject:tmpModel];
        }
        
        for (RacketCollectionInfoModel *tmpModel in remoArr) {
            [_infoArrayList removeObject:tmpModel];
        }
        
        NSComparator cmptr = ^(RacketCollectionInfoModel *obj1, RacketCollectionInfoModel *obj2){
            if ([obj1 sortId] > [obj2 sortId]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            if ([obj1 sortId] < [obj2 sortId]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        NSArray *tmpArr = [_infoArrayList sortedArrayUsingComparator:cmptr];
        [_infoArrayList removeAllObjects];
        for (RacketCollectionInfoModel *tmpModel in tmpArr) {
            [_infoArrayList addObject:tmpModel];
        }
        
        // 将新数据更新入库
        NSMutableArray *dicArray = [[NSMutableArray alloc] init];
        for (RacketCollectionInfoModel *tmpModel in _infoArrayList) {
            [dicArray addObject:[tmpModel convertToDicData]];
        }
        NSMutableArray *remDicArray = [[NSMutableArray alloc] init];
        for (RacketCollectionInfoModel *tmpModel in remoArr) {
            [remDicArray addObject:[tmpModel convertToDicData]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_detailTableView reloadData];
            [[RacketCollectionDB getInstance] syncDataToDB:dicArray];
            [[RacketCollectionDB getInstance] deleteDataOfDB:remDicArray];
        });
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"精 选";
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 42, 24)];
//    [titleLabel setTextColor:[UIColor whiteColor]];
//    [titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
//    [titleLabel setText:@"精选"];
//    [titleLabel setBackgroundColor:[UIColor clearColor]];
//    self.navigationItem.titleView = titleLabel;
    self.navigationItem.leftBarButtonItem = nil;
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setFrame:CGRectMake(0, 0, 25, 25)];
    [searchBtn setImage:[UIImage imageNamed:@"search_bar_item.png"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    _lastYOffest = 0.0;
    _infoArrayList = [[NSMutableArray alloc] init];
    
    [self initDataTableView];
    [self addRefreshView];
    [self getDataFromRcDB:GetInfoTypeRefresh sortId:0];
    [self getPreciseSelectInfo:GetInfoTypeRefresh sortId:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    self.navigationController.navigationBar.alpha = 1.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    RacketCollectionInfoModel *infoModel = (RacketCollectionInfoModel *)sender;
    
    if ([identifier isEqualToString:IdentifierEvaluationDetail]) {
        EvaluationDetailViewController *evaluationVC = [[EvaluationDetailViewController alloc] init];
        evaluationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:evaluationVC animated:YES];
    } else if ([identifier isEqualToString:IdentifierSpecialTopicDetail]) {
        SpecialTopicViewController *productDetailVC = [[SpecialTopicViewController alloc] init];
        productDetailVC.hidesBottomBarWhenPushed = YES;
        productDetailVC.title = infoModel.title;
        productDetailVC.topicId = infoModel.itemId;
        productDetailVC.pageHtmlUrl = infoModel.contDataHtml;
        productDetailVC.turnToCommentVC = NO;
        productDetailVC.title = infoModel.title;
        [self.navigationController pushViewController:productDetailVC animated:YES];
    } else if ([identifier isEqualToString:IdentifierGoodsSearch]) {
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        searchVC.hidesBottomBarWhenPushed = YES;
        searchVC.searchType = GoodsSearchType_All;
        searchVC.searchPlaceholder = @"搜索装备";
        [self.navigationController pushViewController:searchVC animated:YES];
    }
}

- (void)rightBarButtonClick:(UIButton *)sender {
    [self performSegueWithIdentifier:IdentifierGoodsSearch sender:nil];
}

- (void)initDataTableView {
    CGFloat yOrigin = 0;
    CGFloat tvH = kFrameHeight;
    if (KSystemVersion <= 9.0) {
        yOrigin = 64.0;
        tvH = kFrameHeight - 49.0 - 64.0;
        self.automaticallyAdjustsScrollViewInsets = NO;
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, yOrigin, kFrameWidth, tvH) style:UITableViewStylePlain];
    [_detailTableView setDelegate:self];
    [_detailTableView setDataSource:self];
    _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_detailTableView];
    
    
    
    UIView *tmpfooterView = [[UIView alloc] init];
    _detailTableView.tableFooterView = tmpfooterView;
    [tmpfooterView setBackgroundColor:[UIColor clearColor]];
}

- (void)addRefreshView {
    __weak __typeof(self)weakSelf = self;
    _detailTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getPreciseSelectInfo:GetInfoTypeRefresh sortId:weakSelf.latestSortId];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _detailTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _detailTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _requestOldSortId = weakSelf.oldestSortId;
        [weakSelf getDataFromRcDB:GetInfoTypePull sortId:_requestOldSortId];
        [weakSelf getPreciseSelectInfo:GetInfoTypePull sortId:_requestOldSortId];
    }];
}

- (void)getDataFromRcDB:(GetInfoType)getInfoType sortId:(NSInteger)sorId {
    NSArray *dbResult = [[RacketCollectionDB getInstance] getLatestDataFromDB:sorId];
    [self doSomethingAfterDataBack:dbResult getInfoType:getInfoType];
}

- (void)getPreciseSelectInfo:(NSInteger)getInfoType sortId:(NSInteger)sortId {
    [self.netIndicatorView show];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:getInfoType] forKey:@"IdType"];
    [paramDic setObject:[NSNumber numberWithInteger:sortId] forKey:@"lastId"];
    RequestInfo *info = [HttpRequestManager getPreciseSelectInfo:paramDic];
    info.delegate = self;
}

#pragma -mark TableViewCellInteractionDelegate
- (void)sendUserZanRequest:(NSInteger)type itemId:(NSInteger)itemId {
    if ([[QiuPaiUserModel getUserInstance] isTimeOut]) {
        [[QiuPaiUserModel getUserInstance] showUserLoginVC];
        [_detailTableView reloadData];
        return;
    }
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:itemId] forKey:@"itemId"];
    [paramDic setObject:[NSNumber numberWithInteger:type] forKey:@"IdPart"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserZanRequest:paramDic];
    info.delegate = self;
}

- (void)sendUserCollectRequest:(NSInteger)type itemId:(NSInteger)itemId {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:itemId] forKey:@"itemId"];
    [paramDic setObject:[NSNumber numberWithInteger:type] forKey:@"IdPart"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserCollectRequest:paramDic];
    info.delegate = self;
}

- (void)doSomethingAfterDataBack:(NSArray *)contData getInfoType:(GetInfoType)getInfoType {
    if (!contData) {
        contData = @[];
    }
    
    [self handleDataAndRefreshUI:contData getInfoType:getInfoType];
    
    if (getInfoType == GetInfoTypeRefresh) {
        [_detailTableView.mj_header endRefreshing];
    } else {
        [_detailTableView.mj_footer endRefreshing];
        if ([contData count] < kPageSizeCount) {
            [_detailTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    if ([contData count] >= kPageSizeCount) {
        [_detailTableView.mj_footer resetNoMoreData];
    }
}

#pragma -mark NetWorkDelegate
- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    [self.netIndicatorView hide];
    if (RequestID_GetPreciseSelect == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            NSInteger getInfoType = [[dataDic objectForKey:@"IdType"] integerValue];
            NSArray *contData = [dataDic objectForKey:@"contData"];
            [self doSomethingAfterDataBack:contData getInfoType:getInfoType];
        } else {
            [_detailTableView reloadData];
            [_detailTableView.mj_header endRefreshing];
            [_detailTableView.mj_footer endRefreshingWithNoMoreData];
        }
    } else if (RequestID_SendUserCollect == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"itemId"];
            NSInteger itemId = [[dataDic objectForKey:@"itemId"] integerValue];
            for (int i = 0; i < [_infoArrayList count]; i++) {
                RacketCollectionInfoModel *infoModel = [_infoArrayList objectAtIndex:i];
                if (itemId == infoModel.itemId) {
                    infoModel.isLike = 1;
                    infoModel.likeNum ++;
                    NSIndexPath *te=[NSIndexPath indexPathForRow:i inSection:0];
                    [_detailTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te, nil] withRowAnimation:UITableViewRowAnimationNone];
                    return;
                }
            }
        }
    } else if (RequestID_SendUserZan == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            for (int i = 0; i < [_infoArrayList count]; i ++) {
                RacketCollectionInfoModel *tmpModel = [_infoArrayList objectAtIndex:i];
                if (tmpModel.itemId == [[dataDic objectForKey:@"itemId"] integerValue]) {
                    tmpModel.isPraised = [[dataDic objectForKey:@"isPraised"] integerValue];
                    tmpModel.praiseNum = [[dataDic objectForKey:@"praiseNum"] integerValue];
                    
                    NSIndexPath *te=[NSIndexPath indexPathForRow:i inSection:0];
                    [_detailTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te, nil] withRowAnimation:UITableViewRowAnimationNone];
                    return;
                }
            }
        }
    }
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {
    [self.netIndicatorView hide];
    [self.badNetTipV show];
}

#pragma -mark ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset = scrollView.contentOffset.y;
//    NSLog(@"yoffset is %f", yOffset);
//    NSLog(@"top:%f, bottom:%f", scrollView.contentInset.top, scrollView.contentInset.bottom);
    CGFloat alpha = (-yOffset + 100) / 100;
    if (yOffset - _lastYOffest > 0) {
        //向下滑动
    } else {
        //向上滑动
        if (scrollView.frame.size.height + yOffset - scrollView.contentInset.bottom >= scrollView.contentSize.height) {
        } else {
            alpha = 1.0;
        }
    }
    _lastYOffest = yOffset;
    if (alpha < 0) {
        alpha = 0;
    } else if (alpha > 1.0) {
        alpha = 1.0;
    }
    if (KSystemVersion > 9.0) {
        self.navigationController.navigationBar.alpha = alpha;
    }
//    [self.navigationController.navigationBar lt_setBackgroundColor:[CustomGreenColor colorWithAlphaComponent:alpha]];
}

#pragma -mark
#pragma -mark TableView Delegate
#pragma -mark

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    RacketCollectionInfoModel *infoModel = [_infoArrayList objectAtIndex:indexPath.row];
    if (infoModel.type == 3) {
        [self performSegueWithIdentifier:IdentifierEvaluationDetail sender:infoModel];
    } else {
        [self performSegueWithIdentifier:IdentifierSpecialTopicDetail sender:infoModel];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 20.0f)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RacketCollectionInfoModel *infoModel = [_infoArrayList objectAtIndex:indexPath.row];
    return [infoModel getRCICellHeight];
}

#pragma -mark TableView DataSource
#pragma -mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_infoArrayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RacketCollectionInfoModel *info = [_infoArrayList objectAtIndex:indexPath.row];
    NSString *identifier = @"SpecialListCell";
    if (info.type == InfoType_SpecialTopic) {
        PreciseSelectTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[PreciseSelectTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.myDelegate = self;
        }
        [cell bindCellWithDataModel:info];
        return cell;
    } else
//        if (info.type == InfoType_Evaluation)
    {
        // 预留接口，后续会加精选评测
        identifier = @"EvaluationListCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell.textLabel setText:@"当前版本暂不支持展示精选评测"];
        return cell;
    }
    
}

@end
