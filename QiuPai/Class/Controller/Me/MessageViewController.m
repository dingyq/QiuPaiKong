//
//  MessageViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/11/21.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "MessageViewController.h"
#import "SpecialTopicViewController.h"
#import "EvaluationDetailViewController.h"
#import "HomePageViewController.h"

#import "MessageScrollView.h"

#import "MessageCommentModel.h"
#import "MessageLikeModel.h"

@interface MessageViewController() <CustomListTableViewDelegate, NetWorkDelegate> {
    MessageScrollView *_messageScrollView;
    NSMutableArray *_mCommentArr;
    NSMutableArray *_mLikeArr;
    BOOL _isFirstLoadData;
}

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mCommentArr = [[NSMutableArray alloc] init];
    _mLikeArr = [[NSMutableArray alloc] init];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self initMessageScrollView];
    
    _isFirstLoadData = YES;
    [self getCommentOrMyLikeInfo:GetInfoTypeRefresh infoType:MessageListTableTypeComment sortId:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initMessageScrollView {
    _messageScrollView = [[MessageScrollView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight)];
    _messageScrollView.listViewDelegate = self;
    [self.view addSubview:_messageScrollView];
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender tableType:(MessageListTableType)type isReply:(BOOL)isReply {
    if ([identifier isEqualToString:IdentifierEvaluationDetail]) {
        EvaluationDetailViewController *vc = [[EvaluationDetailViewController alloc] init];
        if (type == MessageListTableTypeComment) {
            MessageCommentModel *tmpModel = (MessageCommentModel *)sender;
            vc.hidesBottomBarWhenPushed = YES;
            vc.isSelfEvaluation = ([tmpModel.userId isEqualToString:[QiuPaiUserModel getUserInstance].userId]) ? YES:NO;
            vc.evaluateId = tmpModel.pageId;
            vc.isShowKeyBoard = isReply;
            if (isReply) {
                vc.placeHodlerStr = [NSString stringWithFormat:@"回复%@:", tmpModel.commentName];
            }
            vc.isShowTag = YES;
        } else {
            MessageLikeModel *tmpModel = (MessageLikeModel *)sender;
            vc.hidesBottomBarWhenPushed = YES;
            vc.isSelfEvaluation = YES; // 被喜欢的消息都是自己发出的评测
            vc.evaluateId = tmpModel.itemId;
            vc.isShowKeyBoard = isReply;
            vc.isShowTag = YES;
            vc.isPraised = (tmpModel.isPraised == PraisedState_YES) ? YES:NO;
        }

        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:IdentifierSpecialTopicDetail]) {
        MessageCommentModel *tmpModel = (MessageCommentModel *)sender;
        SpecialTopicViewController *vc = [[SpecialTopicViewController alloc] init];
        vc.topicId = tmpModel.pageId;
        vc.pageHtmlUrl = tmpModel.themeUrl;
        vc.turnToCommentVC = isReply;
        vc.commentPlaceHolderStr = [NSString stringWithFormat:@"回复%@:", tmpModel.commentName];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:IdentifierUserMainPage]) {
        // 未完待续
        MessageCommentModel *tmpModel = (MessageCommentModel *)sender;
        HomePageViewController *vc = [[HomePageViewController alloc] init];
        vc.isMyHomePage = YES;
        NSLog(@"未完待续");
        if (isReply) {
            NSLog(@"弹起键盘");
//            vc.commentPlaceHolderStr = @"";
            vc.commentPlaceHolderStr = [NSString stringWithFormat:@"回复%@:", tmpModel.commentName];
            vc.turnToCommentVC = YES;
        } else {
            vc.turnToCommentVC = NO;
        }
        vc.pageUserId = [[QiuPaiUserModel getUserInstance] userId];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)getCommentOrMyLikeInfo:(NSInteger)getInfoType infoType:(MessageListTableType)infoType sortId:(NSInteger)latestId  {
//    [self.netIndicatorView show];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:getInfoType] forKey:@"IdType"];
    [paramDic setObject:[NSNumber numberWithInteger:latestId] forKey:@"lastId"];
    [paramDic setObject:[NSNumber numberWithInteger:infoType] forKey:@"IdPart"];
    RequestInfo *info = [HttpRequestManager getCommentAndPraisedInfoList:paramDic];
    info.delegate = self;
}

#pragma mark - CustomListTableViewDelegate
- (void)getTableViewDidSelectRowAtIndexPath:(id)dataModel tableType:(NSInteger)type isReply:(BOOL)isReply {
    if (type == MessageListTableTypeComment) {
        MessageCommentModel *tmpModel = (MessageCommentModel *)dataModel;
        if (tmpModel.itemStatus == ItemStatus_Delete) {
            [self loadingTipView:@"该内容已被删除" callBack:nil];
            return;
        }
        if (tmpModel.pageType == UserMessageJumpType_Evaluation) {
            [self performSegueWithIdentifier:IdentifierEvaluationDetail sender:dataModel tableType:type isReply:isReply];
        } else if (tmpModel.pageType == UserMessageJumpType_SpecialTopic) {
            [self performSegueWithIdentifier:IdentifierSpecialTopicDetail sender:dataModel tableType:type isReply:isReply];
        } else if (tmpModel.pageType == UserMessageJumpType_PersonMainPage) {
            [self performSegueWithIdentifier:IdentifierUserMainPage sender:dataModel tableType:type isReply:isReply];
        }
    } else if (type == MessageListTableTypeLike) {
        // 只有自己发的评测才会被喜欢，然后收到通知消息
        MessageLikeModel *dataM = (MessageLikeModel *)dataModel;
        if (dataM.itemStatus == ItemStatus_Delete) {
            [self loadingTipView:@"该内容已被删除" callBack:nil];
            return;
        }
        [self performSegueWithIdentifier:IdentifierEvaluationDetail sender:dataModel tableType:type isReply:NO];
    }
}

- (void)getLoadMoreTableView:(UITableView *)tableView {
    MessageListTableView *messageTV = (MessageListTableView *)tableView;
    NSInteger sortId = 0;
    if (messageTV.type == MessageListTableTypeComment) {
        NSInteger arrCount = [_mCommentArr count];
        if (arrCount > 0) {
            sortId = [[_mCommentArr objectAtIndex:arrCount - 1] sortId];
        }
    } else {
        NSInteger arrCount = [_mLikeArr count];
        if (arrCount > 0) {
            sortId = [[_mLikeArr objectAtIndex:arrCount - 1] sortId];
        }
    }
    [self getCommentOrMyLikeInfo:GetInfoTypePull infoType:messageTV.type sortId:sortId];
}

- (void)getStartRefreshTableView:(UITableView *)tableView {
    NSInteger sortId = 0;
    MessageListTableView *messageTV = (MessageListTableView *)tableView;
    [self getCommentOrMyLikeInfo:GetInfoTypeRefresh infoType:messageTV.type sortId:sortId];
}

#pragma -mark NetWorkDelegate
- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    [self.netIndicatorView hide];
    if (requestID == RequestID_GetCommentAndPraised) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            NSInteger IdPart = [[dataDic objectForKey:@"IdPart"] integerValue];
            NSInteger IdType = [[dataDic objectForKey:@"IdType"] integerValue];
            NSArray *commentData = [dataDic objectForKey:@"commentData"];
            NSArray *praiseData = [dataDic objectForKey:@"praiseData"];
            
            BOOL hasMoreComment = [commentData count] >= kPageSizeCount ? YES : NO;
            BOOL hasMoreLike = [praiseData count] >= kPageSizeCount ? YES : NO;
            
            if (!_isFirstLoadData) {
                if (IdType == GetInfoTypeRefresh) {
                    // 刷新时传sortId为0，会带回全部数据，为防止出现刷新出的数据不彻底，清空数组
                    if (IdPart == MessageListTableTypeComment) {
                        [_mCommentArr removeAllObjects];
                    } else {
                        [_mLikeArr removeAllObjects];
                    }
                }
                
                // 非首次加载时，根据不同的tableview刷新或上推重新加载对应的数据，其他保持不变
                if (IdPart == MessageListTableTypeComment) {
                    for (NSDictionary *tmpDic in commentData) {
                        MessageCommentModel *tmpModel = [[MessageCommentModel alloc] initWithAttributes:tmpDic];
                        [_mCommentArr addObject:tmpModel];
                    }
                    [_messageScrollView reloadCommentView:_mCommentArr hasMoreData:hasMoreComment isNeedReload:YES];
                } else {
                    for (NSDictionary *tmpDic in praiseData) {
                        MessageLikeModel *tmpModel = [[MessageLikeModel alloc] initWithAttributes:tmpDic];
//                        if (tmpModel.isPraised == PraisedState_YES) {
                            [_mLikeArr addObject:tmpModel];
//                        }
                    }
                    [_messageScrollView reloadLikeView:_mLikeArr hasMoreData:hasMoreLike isNeedReload:YES];
                }
            
            } else {
                for (NSDictionary *tmpDic in commentData) {
                    MessageCommentModel *tmpModel = [[MessageCommentModel alloc] initWithAttributes:tmpDic];
                    [_mCommentArr addObject:tmpModel];
                }
                
                for (NSDictionary *tmpDic in praiseData) {
                    MessageLikeModel *tmpModel = [[MessageLikeModel alloc] initWithAttributes:tmpDic];
//                    if (tmpModel.isPraised == PraisedState_YES) {
                        [_mLikeArr addObject:tmpModel];
//                    }
                }
                
                
                [_messageScrollView reloadCommentView:_mCommentArr hasMoreData:hasMoreComment isNeedReload:YES];
                [_messageScrollView reloadLikeView:_mLikeArr hasMoreData:hasMoreLike isNeedReload:YES];
            }
        } else {
            [_messageScrollView reloadCommentView:_mCommentArr hasMoreData:NO isNeedReload:YES];
            [_messageScrollView reloadLikeView:_mLikeArr hasMoreData:NO isNeedReload:YES];
        }
        _isFirstLoadData = NO;
    }
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {
    if (requestID == RequestID_GetCommentAndPraised) {
        [self.netIndicatorView hide];
        _isFirstLoadData = NO;
        [_messageScrollView reloadCommentView:_mCommentArr hasMoreData:NO isNeedReload:YES];
        [_messageScrollView reloadLikeView:_mLikeArr hasMoreData:NO isNeedReload:YES];
    }
}

@end
