//
//  HomePageViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/11/21.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "HomePageViewController.h"
#import "UserHomeInfoModel.h"
#import "CircleInfoModel.h"
#import "UserMessageModel.h"
#import "CircleTVCell.h"
#import "UserHeaderView.h"
#import "UserMessageViewController.h"
#import "GoodsDetailAndEvaViewController.h"
#import "EvaluationDetailViewController.h"
#import "UINavigationBar+BackgroundColor.h"


//#define UserHeadViewH 139.0f
static const CGFloat UserHeadViewH = 139.0f;
static const CGFloat DetailViewH = 97.0f;


@interface HomePageViewController () <TableViewCellInteractionDelegate, NetWorkDelegate, UserHeaderViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    NSInteger _sectionNum;
    
    UITableView *_detailTableView;
    UserHeaderView *_userHeaderView;
    UIView *_footerToolBar;
    NSMutableArray *_userPageInfoArr;
    NSMutableArray *_messageArr;
    UserHomeInfoModel *_userHomeInfo;
    
    CGFloat _tvOrignY;
    BOOL _isCommentBtnClick;
}

@property (nonatomic, assign) NSInteger latestSortId;
@property (nonatomic, assign) NSInteger oldestSortId;
@property (nonatomic, strong) UIView *detailView;

@end

@implementation HomePageViewController

- (NSInteger)latestSortId {
    if (_userPageInfoArr.count > 0) {
        _latestSortId = [[_userPageInfoArr firstObject] sortId];
    } else {
        _latestSortId = 0;
    }
    return _latestSortId;
}

- (NSInteger)oldestSortId {
    if (_userPageInfoArr.count > 0) {
        _oldestSortId = [[_userPageInfoArr lastObject] sortId];
    } else {
        _oldestSortId = 0;
    }
    return _oldestSortId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的主页";
    _tvOrignY = 0;
    
    _isCommentBtnClick = NO;
    _userPageInfoArr = [[NSMutableArray alloc] init];
    _messageArr = [[NSMutableArray alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (!_pageUserId) {
        _pageUserId = [[QiuPaiUserModel getUserInstance] userId];
        self.isMyHomePage = YES;
    }
    [self initUserHeadView];
    [self initDetailInfoTableView];
    [self initFooterToolBarView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isMyHomePage) {
        _tvOrignY = 64;
    } else {
        self.title = @"";
        _tvOrignY = 0;
    }
    [_detailTableView setFrame:CGRectMake(0, _tvOrignY, kFrameWidth, kFrameHeight - 49 - _tvOrignY)];
    if (!_isMyHomePage) {
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        [self.navigationController.navigationBar setBackgroundImage:[Helper imageWithColor:[CustomGreenColor colorWithAlphaComponent:0]] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.layer.contents = nil;
        [self.navigationController.navigationBar lt_setBackgroundColor:[CustomGreenColor colorWithAlphaComponent:0]];
        
    } else {
        [self.navigationController setNavigationBarHidden:NO];
        self.navigationController.navigationBar.barTintColor = CustomGreenColor;
        self.navigationController.navigationBar.layer.contents = (id)[Helper imageWithColor:CustomGreenColor].CGImage;
        [self.navigationController.navigationBar lt_setBackgroundColor:CustomGreenColor];
    }
    [self addRefreshView:_detailTableView];
    [self getHomePageInfoList:GetInfoTypeRefresh sortId:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
//    [self.navigationController.navigationBar setShadowImage:nil];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar lt_setBackgroundColor:CustomGreenColor];
    
    self.navigationController.navigationBar.barTintColor = CustomGreenColor;
    self.navigationController.navigationBar.layer.contents = (id)[Helper imageWithColor:CustomGreenColor].CGImage;
    [self.navigationController.navigationBar lt_setBackgroundColor:CustomGreenColor];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:IdentifierEvaluationDetail]) {
        NSInteger evaluateId = [(CircleInfoModel *)sender itemId];
        NSInteger isPraised = [(CircleInfoModel *)sender isPraised];
        NSString *userId = self.pageUserId;
        
        EvaluationDetailViewController *evaluationVC = [[EvaluationDetailViewController alloc] init];
        evaluationVC.hidesBottomBarWhenPushed = YES;
        evaluationVC.isSelfEvaluation = ([userId isEqualToString:[QiuPaiUserModel getUserInstance].userId]) ? YES:NO;
        evaluationVC.isPraised = (isPraised == PraisedState_YES) ? YES:NO;
        evaluationVC.evaluateId = evaluateId;
        evaluationVC.isShowKeyBoard = _isCommentBtnClick;
        evaluationVC.isShowTag = YES;
        
        [self.navigationController pushViewController:evaluationVC animated:YES];
    } else if ([identifier isEqualToString:IdentifierUserMessage]) {
        UserMessageViewController *vc = [[UserMessageViewController alloc] init];
        vc.title = @"留言";
        vc.pageUserId = self.pageUserId;
        vc.messageNum = _userHomeInfo.messageNum;
        vc.isLike = NO;
        if (self.turnToCommentVC) {
            vc.isShowKeyBoard = YES;
            vc.placeHodlerStr = self.commentPlaceHolderStr;
        } else {
            vc.isShowKeyBoard = NO;
        }
        vc.messagesArr = _messageArr;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setIsMyHomePage:(BOOL)isMyHomePage {
    _isMyHomePage = isMyHomePage;
    _userHeaderView.isMyHeader = isMyHomePage;
}

- (void)initUserHeadView {
    if (!_isMyHomePage) {
        _userHeaderView = [[UserHeaderView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, UserHeadViewH)];
        _userHeaderView.myDelegate = self;
        [_userHeaderView setBackgroundColor:[UIColor yellowColor]];
    }
}

- (void)updateUserHeadView {
    if (!_isMyHomePage) {
        _userHeaderView.isMyHeader = _isMyHomePage;
        [_userHeaderView setHeadViewImage:_userHomeInfo.headPic];
        [_userHeaderView setNameLabelText:_userHomeInfo.nick];
        [_userHeaderView setSexImageTip:_userHomeInfo.sex];
        [_userHeaderView setAgeLabelText:[NSString stringWithFormat:@"%ld岁", (long)_userHomeInfo.age]];
        [_userHeaderView setRacketLabelText:_userHomeInfo.racquet];
        [_userHeaderView setOtherInfoLabelText:@""];
        [_userHeaderView setUserAttentioned:_userHomeInfo.isConcerned];
    }
}

- (void)initDetailInfoTableView {
    _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _tvOrignY, kFrameWidth, kFrameHeight - 49 - _tvOrignY) style:UITableViewStylePlain];
    [_detailTableView setDelegate:self];
    [_detailTableView setDataSource:self];
    _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_detailTableView];
    [_detailTableView setBackgroundColor:VCViewBGColor];
    
    UIView *tmpView = [[UIView alloc] init];
    [tmpView setBackgroundColor:[UIColor clearColor]];
    _detailTableView.tableFooterView = tmpView;
}

- (void)addRefreshView:(UITableView *)tableView {
    
    __weak __typeof(self)weakSelf = self;
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getHomePageInfoList:GetInfoTypeRefresh sortId:0];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getHomePageInfoList:GetInfoTypePull sortId:weakSelf.oldestSortId];
    }];
}

- (void)initFooterToolBarView {
    _footerToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kFrameHeight - 49, kFrameWidth, 49)];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setFrame:CGRectMake(0, 0, kFrameWidth, 49)];
    [commentBtn setImage:[UIImage imageNamed:@"leave_msg_btn"] forState:UIControlStateNormal];
    [commentBtn setImage:[UIImage imageNamed:@"leave_msg_btn"] forState:UIControlStateHighlighted];
    [commentBtn setTitle:@"留言" forState:UIControlStateNormal];
    [commentBtn setTitle:@"留言" forState:UIControlStateHighlighted];
    [commentBtn setTitleColor:Gray102Color forState:UIControlStateNormal];
    [commentBtn setTitleColor:Gray153Color forState:UIControlStateHighlighted];
    commentBtn.imageEdgeInsets = UIEdgeInsetsMake(11, kFrameWidth/2 - 35, 11, kFrameWidth/2 + 35 - 27);
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [commentBtn addTarget:self action:@selector(liveMessageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footerToolBar addSubview:commentBtn];
    
    UIView *linView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 0.5)];
    [linView setBackgroundColor:LineViewColor];
    [_footerToolBar addSubview:linView];
    
    [self.view addSubview:_footerToolBar];
}

- (void)liveMessageBtnClick:(UIButton *)sender {
    [self performSegueWithIdentifier:IdentifierUserMessage sender:nil];
}

- (void)getHomePageInfoList:(NSInteger)getInfoType sortId:(NSInteger)latestId {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:getInfoType] forKey:@"IdType"];
    // IdPart 为1是拉取主页信息流
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"IdPart"];
    [paramDic setObject:_pageUserId forKey:@"toUserId"];
    [paramDic setObject:[NSNumber numberWithInteger:latestId] forKey:@"lastId"];
    RequestInfo *info = [HttpRequestManager getUserMainPageInfo:paramDic];
    info.delegate = self;
}

#pragma -mark UserHeaderViewDelegate

- (void)sendAttentionUserRequest:(NSString *)usrId {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:_pageUserId forKey:@"concernedId"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserAttentionRequest:paramDic];
    info.delegate = self;
}

#pragma -mark TableViewCellInteractionDelegate

- (void)sendUserZanRequest:(NSInteger)type itemId:(NSInteger)itemId {
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

- (void)getTagGoodsRequest:(NSInteger)goodsId {
    GoodsDetailAndEvaViewController *vc = [[GoodsDetailAndEvaViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.goodsId = goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)commentButtonClick:(id)sender {
    CircleInfoModel *infoModel = (CircleInfoModel *)sender;
    if (infoModel.type == InfoType_Evaluation) {
        _isCommentBtnClick = YES;
        [self performSegueWithIdentifier:IdentifierEvaluationDetail sender:infoModel];
        _isCommentBtnClick = NO;
    }
}

#pragma -mark ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset = scrollView.contentOffset.y;
    if (!_isMyHomePage) {
        if (yOffset > 0) {
            CGFloat alpha = 1 - ((64 - yOffset) / 64);
            [self.navigationController.navigationBar lt_setBackgroundColor:[CustomGreenColor colorWithAlphaComponent:alpha]];
        } else {
            [self.navigationController.navigationBar lt_setBackgroundColor:[CustomGreenColor colorWithAlphaComponent:0]];
        }
    }
}

#pragma -mark NetWorkDelegate
- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    if (requestID == RequestID_GetUserMainPageInfo) {
        NSDictionary *dataDic = [dic objectForKey:@"returnData"];
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            _userHomeInfo = [[UserHomeInfoModel alloc] initWithAttributes:dataDic];
            NSInteger IdType = [[dataDic objectForKey:@"IdType"] integerValue];
            NSArray *contArr = [dataDic objectForKey:@"contData"];
            if (IdType == GetInfoTypeRefresh) {
                [_detailTableView.mj_header endRefreshing];
                // 下拉刷新清数组
                [_userPageInfoArr removeAllObjects];
            } else {
                [_detailTableView.mj_footer endRefreshing];
            }
            
            for (NSDictionary *tmpDic in contArr) {
                CircleInfoModel *tmpModel = [[CircleInfoModel alloc] initWithAttributes:tmpDic];
                [_userPageInfoArr addObject:tmpModel];
            }
            if ([contArr count] < kPageSizeCount) {
                [_detailTableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [_detailTableView.mj_footer resetNoMoreData];
            }
            
            [self updateUserHeadView];
            [self updateDetailView];
            [_detailTableView reloadData];
            
            
            if (!_isMyHomePage && contArr.count <= 0) {
//                [self.noDataTipV showWithTip:@"该用户较懒，暂未发表过内容"];
            } else {
                [self.noDataTipV hide];
            }
            
            NSArray *commentArr = [dataDic objectForKey:@"messageData"];
            if ([commentArr count] > 0) {
                for (NSDictionary *tmpDic in commentArr) {
                    UserMessageModel *tmpModel = [[UserMessageModel alloc] initWithAttributes:tmpDic];
                    [_messageArr addObject:tmpModel];
                }
            }
            
            if (_turnToCommentVC) {
                [self performSegueWithIdentifier:IdentifierUserMessage sender:nil];
                _turnToCommentVC = NO;
            }
        } else {
            [_detailTableView.mj_header endRefreshing];
            [_detailTableView.mj_footer endRefreshing];
        }
    } else if (RequestID_SendUserCollect == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            for (int i = 0; i < [_userPageInfoArr count]; i ++) {
                CircleInfoModel *tmpModel = [_userPageInfoArr objectAtIndex:i];
                if (tmpModel.itemId == [[dataDic objectForKey:@"itemId"] integerValue]) {
                    tmpModel.isLike = [[dataDic objectForKey:@"isLiked"] integerValue];
                    tmpModel.likeNum = [[dataDic objectForKey:@"likeNum"] integerValue];
                    
                    NSInteger section = _isMyHomePage?0:1;
                    NSIndexPath *te=[NSIndexPath indexPathForRow:i inSection:section];
                    [_detailTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te, nil] withRowAnimation:UITableViewRowAnimationNone];
                    return;
                }
            }
        }
    } else if (RequestID_SendUserZan == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            for (int i = 0; i < [_userPageInfoArr count]; i ++) {
                CircleInfoModel *tmpModel = [_userPageInfoArr objectAtIndex:i];
                if (tmpModel.itemId == [[dataDic objectForKey:@"itemId"] integerValue]) {
                    tmpModel.isPraised = [[dataDic objectForKey:@"isPraised"] integerValue];
                    tmpModel.praiseNum = [[dataDic objectForKey:@"praiseNum"] integerValue];
                    NSInteger section = _isMyHomePage?0:1;
                    NSIndexPath *te=[NSIndexPath indexPathForRow:i inSection:section];
                    [_detailTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te, nil] withRowAnimation:UITableViewRowAnimationNone];
                    return;
                }
            }
        }
    } else if (RequestID_SendUserAttention == requestID) {
        if ([[dic objectForKey:@""] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            _userHomeInfo.isConcerned = [[dataDic objectForKey:@"isConcerned"] integerValue];
            [self updateUserHeadView];
//            [self updateDetailView];
        }
    }
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {
    
}

#pragma -mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_isMyHomePage && indexPath.section == 0) {
        return UserHeadViewH + DetailViewH;
    }
    CircleInfoModel *tmpModel = [_userPageInfoArr objectAtIndex:indexPath.row];
    return [tmpModel getUserHomePageCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!_isMyHomePage) {
        if (indexPath.section == 0) {
            return;
        }
    }
    CircleInfoModel *infoModel = [_userPageInfoArr objectAtIndex:indexPath.row];
    if (infoModel.type == InfoType_Evaluation) {
        [self performSegueWithIdentifier:IdentifierEvaluationDetail sender:infoModel];
    } else {
        //        [self performSegueWithIdentifier:IdentifierSpecialTopicDetail sender:infoModel];
    }
}

#pragma -mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isMyHomePage) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && !_isMyHomePage) {
        return 1;
    }
    return [_userPageInfoArr count];
}

- (UIView *)detailView {
    if (!_detailView) {
        CGFloat orignY = UserHeadViewH;
        
        _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, kFrameWidth, DetailViewH)];
        [_detailView setBackgroundColor:VCViewBGColor];
        
        UILabel *tip1L = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 43.0f)];
        [tip1L setTextColor:Gray153Color];
        [tip1L setBackgroundColor:[UIColor whiteColor]];
        [tip1L setFont:[UIFont systemFontOfSize:12.0]];
        [tip1L setTextAlignment:NSTextAlignmentLeft];
        [tip1L setText:@"    使用球拍"];
        [_detailView addSubview:tip1L];
        
        UILabel *tipV1L = [[UILabel alloc] initWithFrame:CGRectMake(77, 0, kFrameWidth, 43.0f)];
        [tipV1L setTextColor:Gray85Color];
        [tipV1L setBackgroundColor:[UIColor clearColor]];
        [tipV1L setFont:[UIFont systemFontOfSize:12.0]];
        [tipV1L setTextAlignment:NSTextAlignmentLeft];
        [tipV1L setText:@""];
        [tipV1L setTag:100];
        [_detailView addSubview:tipV1L];
        
        UILabel *tip2L = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, kFrameWidth, 43.0f)];
        [tip2L setTextColor:Gray153Color];
        [tip2L setBackgroundColor:[UIColor whiteColor]];
        [tip2L setFont:[UIFont systemFontOfSize:12.0]];
        [tip2L setTextAlignment:NSTextAlignmentLeft];
        [tip2L setText:@"    打法"];
        [_detailView addSubview:tip2L];
        
        UILabel *tipV2L = [[UILabel alloc] initWithFrame:CGRectMake(77, 49, kFrameWidth, 43.0f)];
        [tipV2L setTextColor:Gray85Color];
        [tipV2L setBackgroundColor:[UIColor clearColor]];
        [tipV2L setFont:[UIFont systemFontOfSize:12.0]];
        [tipV2L setTextAlignment:NSTextAlignmentLeft];
        [tipV2L setText:@""];
        [tipV2L setTag:101];
        [_detailView addSubview:tipV2L];
        
    }
    return _detailView;
}

- (void)updateDetailView {
    if (_detailView) {
        UILabel *tipV1L = [_detailView viewWithTag:100];
        [tipV1L setText:_userHomeInfo.racquet];
        
        UILabel *tipV2L = [_detailView viewWithTag:101];
        [tipV2L setText:_userHomeInfo.region];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"evaluationDetailCell";
    if (indexPath.section == 0 && !_isMyHomePage) {
        cellIdentifier = @"userInfoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell.contentView addSubview:_userHeaderView];
            [cell.contentView addSubview:self.detailView];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        CircleTVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[CircleTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.myDelegate = self;
        }
        CircleInfoModel *tmpModel = [_userPageInfoArr objectAtIndex:indexPath.row];
        [cell bindUserHomeCellWithDataModel:tmpModel];
        return cell;
    }
}


@end
