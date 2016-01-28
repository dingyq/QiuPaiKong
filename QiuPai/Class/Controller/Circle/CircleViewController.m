//
//  CircleViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/11/3.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "AppDelegate.h"
#import "CircleViewController.h"
#import "CircleInfoModel.h"
#import "CircleInfoDB.h"
#import "CAttentionedInfoDB.h"
#import "CircleTVCell.h"

#import "GoodsDetailAndEvaViewController.h"
#import "EvaluationDetailViewController.h"
#import "EditCircleInfoViewController.h"
#import "HomePageViewController.h"
#import "VCInteractionDelegate.h"
#import "MJRefresh.h"


typedef NS_ENUM(NSInteger, CircleInfoType) {
    CircleInfoTypeRecent = 1,          // regular table view
    CircleInfoTypeAttention         // preferences style table view
};

@interface CircleViewController () <TableViewCellInteractionDelegate, VCInteractionDelegate> {
    UITableView *_infoDetailTV;
    NSMutableArray *_recentInfoArrayList;
    NSMutableArray *_attentionInfoArrayList;
    CircleInfoType _segmentIndex;
    BOOL _isCommentBtnClick;
    NSInteger _requestOldSortId;
    BOOL _isSegmentFirstClick;
}

@property (nonatomic, assign) NSInteger latestSortId;
@property (nonatomic, assign) NSInteger oldestSortId;
@end

@implementation CircleViewController

- (NSInteger)latestSortId {
    NSArray *aliasArr = _segmentIndex == CircleInfoTypeRecent ?_recentInfoArrayList:_attentionInfoArrayList;
    if (aliasArr.count > 0) {
        _latestSortId = [[aliasArr firstObject] sortId];
    } else {
        _latestSortId = 0;
    }
    return _latestSortId;
}

- (NSInteger)oldestSortId {
   NSArray *aliasArr = _segmentIndex == CircleInfoTypeRecent ?_recentInfoArrayList:_attentionInfoArrayList;
    if (aliasArr.count > 0) {
        _oldestSortId = [[aliasArr lastObject] sortId];
    } else {
        _oldestSortId = 0;
    }
    return _oldestSortId;
}

- (void)handleDataAndRefreshUI:(NSArray *)contData getInfoType:(GetInfoType)getInfoType cirInfoType:(CircleInfoType)cInfoType  isFromCache:(BOOL)fromCache {
    if (contData.count <= 0) {
//        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *aliasArr = cInfoType == CircleInfoTypeRecent ?_recentInfoArrayList:_attentionInfoArrayList;
        NSMutableArray *remoArr = [[NSMutableArray alloc] init];
        NSMutableArray *addArr = [[NSMutableArray alloc] init];
        if (getInfoType == GetInfoTypeRefresh) {
            /*
             * 当刷新请求回来时，如果结果总数大于kPageSizeCount，
             * 且结果中的最小sortId比已知的最大sortId最少大2，则说明本地数据过老
             * 为防止这种情况上推获取更多数据时保证信息的连贯性，需remove掉已有的数据，显示最新的数据
             */
            if (contData.count >= kPageSizeCount && aliasArr.count > 0) {
                CircleInfoModel *firstModel = [[CircleInfoModel alloc] initWithAttributes:[contData firstObject] isFromCache:fromCache];
                CircleInfoModel *lastModel = [[CircleInfoModel alloc] initWithAttributes:[contData lastObject] isFromCache:fromCache];
                if (lastModel.sortId > weakSelf.latestSortId + 1) {
                    [aliasArr removeAllObjects];
                } else if (firstModel.sortId < weakSelf.latestSortId) {
                    for (CircleInfoModel *tmpModel in aliasArr) {
                        if (tmpModel.sortId > firstModel.sortId) {
                            [remoArr addObject:tmpModel];
                        } else {
                            break;
                        }
                    }
                }
            }
        } else if (getInfoType == GetInfoTypePull) {
            /*
             * 上推时，本地首先加载的缓存数据，如果出现回包数据中最大的sortId比已知的最小的sortId最少还小2，
             * 则说明本地后加载的缓存数据已被全部删除，找到清掉此部分缓存的数据
             */
            if (aliasArr.count > 0) {
                if (_requestOldSortId > weakSelf.oldestSortId) {
                    CircleInfoModel *tmpModel = [[CircleInfoModel alloc] initWithAttributes:[contData firstObject] isFromCache:fromCache];
                    if (tmpModel.sortId < weakSelf.oldestSortId - 1) {
                        BOOL find = NO;
                        NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
                        for (NSInteger i = 0; i < [aliasArr count]; i++) {
                            CircleInfoModel *oldModel = [aliasArr objectAtIndex:i];
                            if (find) {
                                [indexSet addIndex:i];
                                [remoArr addObject:oldModel];
                            } else if (oldModel.sortId == _requestOldSortId) {
                                [remoArr addObject:oldModel];
                                [indexSet addIndex:i];
                                find = YES;
                            }
                        }
                        [aliasArr removeObjectsAtIndexes:indexSet];
                    }
                }
            }
        }
        
        NSInteger curPos = 0;
        BOOL findFirst = NO;
        NSMutableArray *dataBackFromServer = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < [contData count]; i++) {
            NSDictionary *tmpDic = [contData objectAtIndex:i];
            CircleInfoModel *tmpModel = [[CircleInfoModel alloc] initWithAttributes:tmpDic isFromCache:fromCache];
            if (!fromCache) {
                [dataBackFromServer addObject:tmpModel];
            }
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
//                for (NSInteger j = curPos; j < [aliasArr count]; j++) {
//                    CircleInfoModel *oldModel = [aliasArr objectAtIndex:j];
//                    if (tmpModel.itemId == oldModel.itemId) {
//                        if (!fromCache) {
//                            [oldModel updateAttributes:tmpDic];
//                        }
//                        findFirst = YES;
//                        curPos = j+1;
//                        break;
//                    } else {
//                        if (findFirst) {
//                            // 找到对齐位置，但发生不连续，说明此处
//                            // 本地缓存到了服务器上不存在的数据，记录此条非法数据，并继续比对下一个元素
//                            [remoArr addObject:oldModel];
//                        }
//                    }
//                }   

                for (NSInteger j = curPos; j < [aliasArr count]; j++) {
                    CircleInfoModel *oldModel = [aliasArr objectAtIndex:j];
                    if (tmpModel.itemId == oldModel.itemId) {
                        if (!fromCache) {
                            [oldModel updateAttributes:tmpDic];
                        }
                        findFirst = YES;
                        curPos = j+1;
                        break;
                    } else {
                        if (findFirst) {
                            // 找到对齐位置，但发生不连续，说明此处
                            // 本地缓存到了服务器上不存在的数据，记录此条非法数据，并继续比对下一个元素
                            if (fromCache) {
                                [remoArr addObject:oldModel];
                            } else {
                                [addArr addObject:tmpModel];
                            }
                            
                        }
                    }
                }
            
            }
        }
        
        for (CircleInfoModel *tmpModel in addArr) {
            [aliasArr addObject:tmpModel];
        }
        
        for (CircleInfoModel *tmpModel in remoArr) {
            [aliasArr removeObject:tmpModel];
        }
        
        if (cInfoType == CircleInfoTypeAttention) {
            // 关注列表时
            NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
            for (CircleInfoModel *tmpModel in aliasArr) {
                if (tmpModel.isConcerned == ConcernedState_None) {
                    [tmpArr addObject:tmpModel];
                }
            }
            for (CircleInfoModel *tmpModel in tmpArr) {
                [aliasArr removeObject:tmpModel];
            }
        }
        
        NSComparator cmptr = ^(CircleInfoModel *obj1, CircleInfoModel *obj2){
            if ([obj1 sortId] > [obj2 sortId]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            if ([obj1 sortId] < [obj2 sortId]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        NSArray *tmpArr = [aliasArr sortedArrayUsingComparator:cmptr];
        [aliasArr removeAllObjects];
        for (CircleInfoModel *tmpModel in tmpArr) {
            [aliasArr addObject:tmpModel];
        }
        
        if (!fromCache) {
            // 只有当有数据从服务器端回来时，才将新数据更新入库
            NSMutableArray *dicArray = [[NSMutableArray alloc] init];
            NSMutableArray *remDicArray = [[NSMutableArray alloc] init];
            for (CircleInfoModel *tmpModel in dataBackFromServer) {
                [dicArray addObject:[tmpModel convertToDicData]];
            }
            for (CircleInfoModel *tmpModel in remoArr) {
                [remDicArray addObject:[tmpModel convertToDicData]];
            }
            if (cInfoType == CircleInfoTypeRecent) {
                [[CircleInfoDB getInstance] syncDataToDB:dicArray];
                [[CircleInfoDB getInstance] deleteDataOfDB:remDicArray];
            } else {
                [[CAttentionedInfoDB getInstance] syncDataToDB:dicArray];
                [[CAttentionedInfoDB getInstance] deleteDataOfDB:remDicArray];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_infoDetailTV reloadData];
            [self checkAndShowNoDataTip];
        });
    });
}

- (void)checkAndShowNoDataTip {
    if (_segmentIndex == CircleInfoTypeAttention && _attentionInfoArrayList.count <= 0) {
        [self.noDataTipView show];
    } else if (_segmentIndex == CircleInfoTypeRecent && _recentInfoArrayList.count <= 0) {
        [self.noDataTipView show];
    } else {
        [self.noDataTipView hide];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评测";
    self.navigationItem.leftBarButtonItem = nil;
    UIButton *pubBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pubBtn setFrame:CGRectMake(0, 0, 22, 22)];
    [pubBtn setImage:[UIImage imageNamed:@"evaluation_publish_button.png"] forState:UIControlStateNormal];
    [pubBtn addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:pubBtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    _segmentIndex = CircleInfoTypeRecent;
    _isCommentBtnClick = NO;
    _isSegmentFirstClick = YES;
    _recentInfoArrayList = [[NSMutableArray alloc] init];
    _attentionInfoArrayList = [[NSMutableArray alloc] init];
    
    [self initTheSegementControl];
    [self initRecentDataTableView];
    [self addRefreshView:_infoDetailTV];

    [self getDataFromRcDB:GetInfoTypeRefresh sortId:0];
    [self getCircleLatestInfo:GetInfoTypeRefresh sortId:0];
    [self.netIndicatorView show];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
    if ([identifier isEqualToString:IdentifierEvaluationDetail]) {
        NSInteger evaluateId = [(CircleInfoModel *)sender itemId];
        NSInteger isPraised = [(CircleInfoModel *)sender isPraised];
        NSString *userId = [(CircleInfoModel *)sender evaluateUserId];
        
        EvaluationDetailViewController *evaluationVC = [[EvaluationDetailViewController alloc] init];
        evaluationVC.hidesBottomBarWhenPushed = YES;
        evaluationVC.isSelfEvaluation = ([userId isEqualToString:[QiuPaiUserModel getUserInstance].userId]) ? YES:NO;
        evaluationVC.isPraised = (isPraised == PraisedState_YES) ? YES:NO;
        evaluationVC.evaluateId = evaluateId;
        evaluationVC.isShowKeyBoard = _isCommentBtnClick;
        evaluationVC.myDelegate = self;
        evaluationVC.isShowTag = YES;
        
        [self.navigationController pushViewController:evaluationVC animated:YES];
    } else if ([identifier isEqualToString:IdentifierSpecialTopicDetail]) {

    } else if ([identifier isEqualToString:IdentifierUserMainPage]) {
        CircleInfoModel *tmpModel = (CircleInfoModel *)sender;
        HomePageViewController *vc = [[HomePageViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        vc.isMyHomePage = [tmpModel.evaluateUserId isEqualToString:[QiuPaiUserModel getUserInstance].userId];
        vc.turnToCommentVC = NO;
        vc.pageUserId = tmpModel.evaluateUserId;
    } else if ([identifier isEqualToString:IdentifierWriteEvaluation]) {
        EditCircleInfoViewController *vc = [[EditCircleInfoViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.myDelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)rightBarButtonClick:(UIButton *)sender {
    [self performSegueWithIdentifier:IdentifierWriteEvaluation sender:nil];
}

- (void)initTheSegementControl {
    NSArray* tmpArray = [[NSArray alloc] initWithObjects:@"最 新", @"关 注", nil];
    UISegmentedControl* betSeControl = [[UISegmentedControl alloc] initWithItems:tmpArray];
    betSeControl.frame = CGRectMake(0, 0, 132, 28);
    betSeControl.tintColor = [UIColor whiteColor];
    betSeControl.multipleTouchEnabled = NO;
    betSeControl.backgroundColor = CustomGreenColor;
    betSeControl.layer.borderWidth = 1;
    betSeControl.layer.cornerRadius = 5;
    betSeControl.layer.borderColor = [[UIColor whiteColor] CGColor];
    [betSeControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [betSeControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil] forState:UIControlStateSelected];
    betSeControl.selectedSegmentIndex=0;
    [betSeControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:betSeControl];
}

-(void)segmentAction:(UISegmentedControl *)seg{
    NSInteger index = seg.selectedSegmentIndex;
    if (index == 0) {
        _segmentIndex = CircleInfoTypeRecent;
    } else {
        _segmentIndex = CircleInfoTypeAttention;
    }
    [_infoDetailTV.mj_footer resetNoMoreData];
    if (_isSegmentFirstClick) {
        _isSegmentFirstClick = NO;
        [self getDataFromRcDB:GetInfoTypeRefresh sortId:self.latestSortId];
        [self getCircleLatestInfo:GetInfoTypeRefresh sortId:self.latestSortId];
    } else {
        [_infoDetailTV reloadData];
        [self checkAndShowNoDataTip];
    }
}

- (void)initRecentDataTableView {
    CGFloat yOrigin = 0;
    CGFloat tvH = kFrameHeight;
    if (KSystemVersion <= 9.0) {
        yOrigin = 64.0;
        tvH = kFrameHeight - 49.0 - 64.0;
        self.automaticallyAdjustsScrollViewInsets = NO;
    } else {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    
    _infoDetailTV = [[UITableView alloc] initWithFrame:CGRectMake(0, yOrigin, kFrameWidth, tvH) style:UITableViewStylePlain];
    [_infoDetailTV setDelegate:self];
    [_infoDetailTV setDataSource:self];
    [self.view addSubview:_infoDetailTV];
    _infoDetailTV.separatorStyle = UITableViewCellSeparatorStyleNone;

    UIView *footerView = [[UIView alloc] init];
    _infoDetailTV.tableFooterView = footerView;
    [footerView setBackgroundColor:[UIColor clearColor]];
    [_infoDetailTV addSubview:self.noDataTipView];
}

- (void)addRefreshView:(UITableView *)tableView {
    __weak __typeof(self)weakSelf = self;
    _infoDetailTV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getCircleLatestInfo:GetInfoTypeRefresh sortId:0];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _requestOldSortId = weakSelf.oldestSortId;
        [weakSelf getDataFromRcDB:GetInfoTypePull sortId:_requestOldSortId];
        [weakSelf getCircleLatestInfo:GetInfoTypePull sortId:_requestOldSortId];
    }];
}

- (void)getDataFromRcDB:(GetInfoType)getInfoType sortId:(NSInteger)sorId {
    NSArray *dbResult = nil;
    if (_segmentIndex == CircleInfoTypeRecent) {
        dbResult = [[CircleInfoDB getInstance] getLatestDataFromDB:sorId];
    } else {
        dbResult = [[CAttentionedInfoDB getInstance] getLatestDataFromDB:sorId];
    }
    [self doSomethingAfterDataBack:dbResult getInfoType:getInfoType cirInfoType:_segmentIndex isFromCache:YES];
}

- (void)getCircleLatestInfo:(NSInteger)getInfoType sortId:(NSInteger)latestId {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:getInfoType] forKey:@"IdType"];
    [paramDic setObject:[NSNumber numberWithInteger:latestId] forKey:@"lastId"];
    [paramDic setObject:[NSNumber numberWithInteger:_segmentIndex] forKey:@"IdPart"];
    RequestInfo *info = [HttpRequestManager getCircleInfo:paramDic];
    info.delegate = self;
}

#pragma -mark VCInteractionDelegate
- (void)deleteMainEvaluation:(NSInteger)evaluId {
    NSMutableArray *arrAlias = nil;
    if (_segmentIndex == CircleInfoTypeRecent) {
        arrAlias = _recentInfoArrayList;
    } else {
        arrAlias = _attentionInfoArrayList;
    }
    for (int i = 0; i < [arrAlias count]; i ++) {
        CircleInfoModel *infoModel = [arrAlias objectAtIndex:i];
        if (infoModel.itemId == evaluId) {
            [arrAlias removeObjectAtIndex:i];
            NSIndexPath *te=[NSIndexPath indexPathForRow:i inSection:0];
            [_infoDetailTV deleteRowsAtIndexPaths:[NSArray arrayWithObjects:te, nil] withRowAnimation:UITableViewRowAnimationNone];
            
            if (_segmentIndex == CircleInfoTypeRecent) {
                [[CircleInfoDB getInstance] deleteDataOfTable:[infoModel convertToDicData]];
            } else {
                [[CAttentionedInfoDB getInstance] deleteDataOfTable:[infoModel convertToDicData]];
            }
            break;
        }
    }
}

- (void)publishNewEvaluationSuccess:(NSDictionary *)dataDic {
    // 刷新
    CircleInfoModel *tmpModel = [[CircleInfoModel alloc] initWithAttributes:dataDic];
    if (_recentInfoArrayList.count > 0) {
        [_recentInfoArrayList insertObject:tmpModel atIndex:0];
    } else {
        [_recentInfoArrayList addObject:tmpModel];
    }
    NSIndexPath *te=[NSIndexPath indexPathForRow:0 inSection:0];
    [_infoDetailTV insertRowsAtIndexPaths:[NSArray arrayWithObjects:te, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    [[CircleInfoDB getInstance] insertDataToTable:dataDic];
}

#pragma -mark TableViewCellInteractionDelegate
- (void)sendUserCollectRequest:(NSInteger)type itemId:(NSInteger)itemId {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:itemId] forKey:@"itemId"];
    [paramDic setObject:[NSNumber numberWithInteger:type] forKey:@"IdPart"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserCollectRequest:paramDic];
    info.delegate = self;
}

- (void)sendUserZanRequest:(NSInteger)type itemId:(NSInteger)itemId {
    if ([[QiuPaiUserModel getUserInstance] isTimeOut]) {
        [[QiuPaiUserModel getUserInstance] showUserLoginVC];
        [_infoDetailTV reloadData];
        return;
    }
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:itemId] forKey:@"itemId"];
    [paramDic setObject:[NSNumber numberWithInteger:type] forKey:@"IdPart"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserZanRequest:paramDic];
    info.delegate = self;
}

- (void)sendUserAttentionRequest:(NSString *)evaluUserId{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:evaluUserId forKey:@"concernedId"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserAttentionRequest:paramDic];
    info.delegate = self;
}

- (void)getTagGoodsRequest:(NSInteger)goodsId {
    NSLog(@"goodsId is %ld", (long)goodsId);
    GoodsDetailAndEvaViewController *vc = [[GoodsDetailAndEvaViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.goodsId = goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)commentButtonClick:(id)sender {
    NSLog(@"commentButtonClick");
    CircleInfoModel *infoModel = (CircleInfoModel *)sender;
    if (infoModel.type == InfoType_Evaluation) {
        _isCommentBtnClick = YES;
        [self performSegueWithIdentifier:IdentifierEvaluationDetail sender:infoModel];
        _isCommentBtnClick = NO;
    }
}

- (void)headImageClick:(id)sender {
    [self performSegueWithIdentifier:IdentifierUserMainPage sender:sender];
}

- (void)doSomethingAfterDataBack:(NSArray *)contData getInfoType:(GetInfoType)getInfoType cirInfoType:(CircleInfoType)cInfoType isFromCache:(BOOL)fromCache {
    if (!contData) {
        contData = @[];
    }
    [self handleDataAndRefreshUI:contData getInfoType:getInfoType cirInfoType:cInfoType isFromCache:fromCache];
    
    if (getInfoType == GetInfoTypeRefresh) {
        [_infoDetailTV.mj_header endRefreshing];
    } else {
        [_infoDetailTV.mj_footer endRefreshing];
        if ([contData count] < kPageSizeCount) {
            [_infoDetailTV.mj_footer endRefreshingWithNoMoreData];
        }
    }
    if ([contData count] >= kPageSizeCount) {
        [_infoDetailTV.mj_footer resetNoMoreData];
    }
}

#pragma -mark NetWorkDelegate
- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    [self.netIndicatorView hide];
    if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkNoSuchUser) {
        [[QiuPaiUserModel getUserInstance] showUserLoginVC];
    } else if([[dic objectForKey:@"statusCode"] integerValue] != NetWorkJsonResOK) {
        [Helper showAlertView:[dic objectForKey:@"statusInfo"]];
    }
    
    if (RequestID_GetCircleInfo == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            NSInteger getInfoType = [[dataDic objectForKey:@"IdType"] integerValue];
            CircleInfoType infoType = [[dataDic objectForKey:@"IdPart"] integerValue];
            NSArray *contData = [dataDic objectForKey:@"contData"];
            [self doSomethingAfterDataBack:contData getInfoType:getInfoType cirInfoType:infoType isFromCache:NO];
        } else {
            [_infoDetailTV.mj_header endRefreshing];
            [_infoDetailTV.mj_footer endRefreshingWithNoMoreData];
        }
    } else if (RequestID_SendUserCollect == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            NSArray *opArr = _recentInfoArrayList;
            if (_segmentIndex == CircleInfoTypeAttention) {
                opArr = _attentionInfoArrayList;
            }
            for (int i = 0; i < [opArr count]; i ++) {
                CircleInfoModel *tmpModel = [opArr objectAtIndex:i];
                if (tmpModel.itemId == [[dataDic objectForKey:@"itemId"] integerValue]) {
                    tmpModel.isLike = [[dataDic objectForKey:@"isLiked"] integerValue];
                    tmpModel.likeNum = [[dataDic objectForKey:@"likeNum"] integerValue];
                    
                    NSIndexPath *te=[NSIndexPath indexPathForRow:i inSection:0];
                    [_infoDetailTV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te, nil] withRowAnimation:UITableViewRowAnimationNone];
                    return;
                }
            }
        }
    } else if (RequestID_SendUserZan == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            NSArray *opArr = _recentInfoArrayList;
            if (_segmentIndex == CircleInfoTypeAttention) {
                opArr = _attentionInfoArrayList;
            }
            for (int i = 0; i < [opArr count]; i ++) {
                CircleInfoModel *tmpModel = [opArr objectAtIndex:i];
                if (tmpModel.itemId == [[dataDic objectForKey:@"itemId"] integerValue]) {
                    tmpModel.isPraised = [[dataDic objectForKey:@"isPraised"] integerValue];
                    tmpModel.praiseNum = [[dataDic objectForKey:@"praiseNum"] integerValue];
                    
                    NSIndexPath *te=[NSIndexPath indexPathForRow:i inSection:0];
                    [_infoDetailTV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te, nil] withRowAnimation:UITableViewRowAnimationNone];
                    return;
                }
            }
        } else {
            [_infoDetailTV reloadData];
        }
    } else if (RequestID_SendUserAttention == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *returnData = [dic objectForKey:@"returnData"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableArray *rowsNeedUpdateArr = [[NSMutableArray alloc] init];
                NSMutableArray *dataNeedWriteToDBArr = [[NSMutableArray alloc] init];
                
//                NSArray *aliasArr = _segmentIndex == CircleInfoTypeRecent?_recentInfoArrayList:_attentionInfoArrayList;
                
                for (int i = 0; i < [_recentInfoArrayList count]; i++) {
                    CircleInfoModel *infoModel = [_recentInfoArrayList objectAtIndex:i];
                    if ([infoModel.evaluateUserId isEqualToString:[returnData objectForKey:@"userId"]]) {
                        infoModel.isConcerned = [[returnData objectForKey:@"isConcerned"] integerValue];
                        if (_segmentIndex == CircleInfoTypeRecent) {
                            [rowsNeedUpdateArr addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                            [dataNeedWriteToDBArr addObject:[infoModel convertToDicData]];
                        }
                    }
                }
                
                NSMutableArray *attNeedRemArr = [[NSMutableArray alloc] init];
                for (int i = 0; i < [_attentionInfoArrayList count]; i++) {
                    CircleInfoModel *infoModel = [_attentionInfoArrayList objectAtIndex:i];
                    if ([infoModel.evaluateUserId isEqualToString:[returnData objectForKey:@"userId"]]) {
                        infoModel.isConcerned = [[returnData objectForKey:@"isConcerned"] integerValue];
                        if (_segmentIndex == CircleInfoTypeAttention) {
                            if (infoModel.isConcerned == ConcernedState_None) {
                                [rowsNeedUpdateArr addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                                [attNeedRemArr addObject:infoModel];
                            }
                            [dataNeedWriteToDBArr addObject:[infoModel convertToDicData]];
                        } else {
                            // 最新消息列表处，取消关注某一人时，将关注列表中对应此人的消息全部remove掉
                            if (infoModel.isConcerned == ConcernedState_None) {
                                [attNeedRemArr addObject:infoModel];
                            }
                        }
                    }
                }
                
                if (_segmentIndex == CircleInfoTypeAttention) {
                    for (CircleInfoModel *tmpModel in attNeedRemArr) {
                        [_attentionInfoArrayList removeObject:tmpModel];
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 将新数据更新入库
                    [[CircleInfoDB getInstance] syncDataToDB:dataNeedWriteToDBArr];
                    [[CAttentionedInfoDB getInstance] syncDataToDB:dataNeedWriteToDBArr];
                    
                    [_infoDetailTV beginUpdates];
                    if (_segmentIndex == CircleInfoTypeRecent) {
                        [_infoDetailTV reloadRowsAtIndexPaths:rowsNeedUpdateArr withRowAnimation:UITableViewRowAnimationNone];
                    } else {
                        // 关注列表删除已取消关注的人全部消息
//                        [_infoDetailTV reloadData];
                        [_infoDetailTV deleteRowsAtIndexPaths:rowsNeedUpdateArr withRowAnimation:UITableViewRowAnimationNone];
                    }
                    [_infoDetailTV endUpdates];
                    [self checkAndShowNoDataTip];
                    
                });
            });
        }
    }
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {
    NSLog(@"%@", err);
    [self.netIndicatorView hide];
    if (RequestID_GetCircleInfo == requestID) {
        [self.badNetTipV show];
        [_infoDetailTV.mj_header endRefreshing];
        [_infoDetailTV.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma -mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    CircleInfoModel *infoModel;
    if (_segmentIndex == CircleInfoTypeRecent) {
        infoModel = [_recentInfoArrayList objectAtIndex:indexPath.row];
    } else {
        infoModel = [_attentionInfoArrayList objectAtIndex:indexPath.row];
    }
    
    if (infoModel.type == InfoType_Evaluation) {
        [self performSegueWithIdentifier:IdentifierEvaluationDetail sender:infoModel];
    } else {
        //        [self performSegueWithIdentifier:IdentifierSpecialTopicDetail sender:infoModel];
    }
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
    CircleInfoModel *infoModel;
    if (_segmentIndex == CircleInfoTypeRecent) {
        NSInteger index = indexPath.row < _recentInfoArrayList.count ? indexPath.row : _recentInfoArrayList.count-1;
        infoModel = [_recentInfoArrayList objectAtIndex:index];
    } else {
        NSInteger index = indexPath.row < _attentionInfoArrayList.count ? indexPath.row : _attentionInfoArrayList.count-1;
        infoModel = [_attentionInfoArrayList objectAtIndex:index];
    }
    return [infoModel getCircleInfoCellHeight:NO isCircleList:YES];
}

#pragma -mark
#pragma -mark TableView DataSource
#pragma -mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_segmentIndex == CircleInfoTypeRecent) {
        NSLog(@"ddd %ld", (unsigned long)_recentInfoArrayList.count);
        return [_recentInfoArrayList count];
    } else {
        return [_attentionInfoArrayList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleInfoModel *info;
    NSInteger indexRow = indexPath.row;
    if (_segmentIndex == CircleInfoTypeRecent) {
        NSLog(@"%ld, count is %ld", (long)indexPath.row, (unsigned long)_recentInfoArrayList.count);
        NSInteger index = indexRow < _recentInfoArrayList.count ? indexRow : _recentInfoArrayList.count-1;
        info = [_recentInfoArrayList objectAtIndex:index];
    } else {
        NSInteger index = indexRow < _attentionInfoArrayList.count ? indexRow : _attentionInfoArrayList.count-1;
        info = [_attentionInfoArrayList objectAtIndex:index];
    }
    NSString *identifier = @"CircleListCell";
    if (info.type == InfoType_Evaluation) {
        CircleTVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[CircleTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.myDelegate = self;
        }
        [cell bindCellWithDataModel:info hideTag:NO isCircleList:YES];
        return cell;
    } else
        //        if (info.type == InfoType_Evaluation)
    {
        // 预留接口
        identifier = @"SpecialTopicCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell.textLabel setText:@"当前版本暂不支持展示精选评测"];
        return cell;
    }
    
    
}
@end
