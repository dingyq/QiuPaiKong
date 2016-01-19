//
//  MyLikeViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/11/21.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "MyLikeViewController.h"
#import "EvaluationDetailViewController.h"
#import "SpecialTopicViewController.h"
#import "GoodsBuyViewController.h"
#import "GoodsDetailAndEvaViewController.h"
#import "HomePageViewController.h"

#import "TableViewCellInteractionDelegate.h"
#import "MyLikeScrollView.h"

#import "CircleInfoModel.h"
#import "RacketCollectionInfoModel.h"
#import "RacketSearchModel.h"

@interface MyLikeViewController() <NetWorkDelegate, CustomListTableViewDelegate, TableViewCellInteractionDelegate> {
    MyLikeScrollView *_likeScrollView;
    NSMutableArray *_STModelArr;
    NSMutableArray *_evaluationModelArr;
    NSMutableArray *_goodsModelArr;
    BOOL _isFirstLoadData;
    
    BOOL _isCommentBtnClick;
}

@end

@implementation MyLikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _STModelArr = [[NSMutableArray alloc] init];
    _evaluationModelArr = [[NSMutableArray alloc] init];
    _goodsModelArr = [[NSMutableArray alloc] init];
    _isCommentBtnClick = NO;
    [self initMyLikeScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
    _isFirstLoadData = YES;
    [self getEvaluAndSTAndGoodsILikedInfo:GetInfoTypeRefresh infoType:LikeListTableTypeEvaluation sortId:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initMyLikeScrollView {
    _likeScrollView = [[MyLikeScrollView alloc] initWithFrame:CGRectMake(0, 64, kFrameWidth, kFrameHeight - 64)];
    _likeScrollView.listViewDelegate = self;
    [self.view addSubview:_likeScrollView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender tableType:(LikeListTableType)type isReply:(BOOL)isReply {
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
        evaluationVC.isShowTag = YES;
        
        [self.navigationController pushViewController:evaluationVC animated:YES];
    } else if ([identifier isEqualToString:IdentifierSpecialTopicDetail]) {
        RacketCollectionInfoModel *infoModel = (RacketCollectionInfoModel *)sender;
        SpecialTopicViewController *stVC = [[SpecialTopicViewController alloc] init];
        stVC.hidesBottomBarWhenPushed = YES;
        stVC.title = infoModel.title;
        stVC.topicId = infoModel.itemId;
        stVC.turnToCommentVC = NO;
        stVC.pageHtmlUrl = infoModel.contDataHtml;
        [self.navigationController pushViewController:stVC animated:YES];
    } else if ([identifier isEqualToString:IdentifierGoodsDetailAndEva]) {
        RacketSearchModel *infoModel = (RacketSearchModel *)sender;
        GoodsDetailAndEvaViewController *stVC = [[GoodsDetailAndEvaViewController alloc] init];
        stVC.hidesBottomBarWhenPushed = YES;
        stVC.goodsId = infoModel.itemId;
        [self.navigationController pushViewController:stVC animated:YES];
    }  else if ([identifier isEqualToString:IdentifierUserMainPage]) {
        CircleInfoModel *tmpModel = (CircleInfoModel *)sender;
        HomePageViewController *vc = [[HomePageViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        vc.isMyHomePage = [tmpModel.evaluateUserId isEqualToString:[QiuPaiUserModel getUserInstance].userId];
        vc.turnToCommentVC = NO;
        vc.pageUserId = tmpModel.evaluateUserId;
    }
}

- (void)getEvaluAndSTAndGoodsILikedInfo:(NSInteger)getInfoType infoType:(LikeListTableType)infoType sortId:(NSInteger)latestId  {
    if (getInfoType == GetInfoTypeRefresh) {
        [self.netIndicatorView show];
    }
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:getInfoType] forKey:@"IdType"];
    [paramDic setObject:[NSNumber numberWithInteger:latestId] forKey:@"lastId"];
    [paramDic setObject:[NSNumber numberWithInteger:infoType] forKey:@"IdPart"];
    RequestInfo *info = [HttpRequestManager getAllMyLikedInfoList:paramDic];
    info.delegate = self;
}

#pragma mark - CustomListTableViewDelegate

- (void)getTableViewDidSelectRowAtIndexPath:(id)dataModel tableType:(NSInteger)type isReply:(BOOL)isReply {
    if (type == LikeListTableTypeGoods) {
        RacketSearchModel *dataM = (RacketSearchModel *)dataModel;
        if (dataM.itemStatus == ItemStatus_Delete) {
            return;
        }
        [self performSegueWithIdentifier:IdentifierGoodsDetailAndEva sender:dataModel tableType:type isReply:isReply];
    } else if (type == LikeListTableTypeSpecialTopic) {
        RacketCollectionInfoModel *dataM = (RacketCollectionInfoModel *)dataModel;
        if (dataM.itemStatus == ItemStatus_Delete) {
            return;
        }
        [self performSegueWithIdentifier:IdentifierSpecialTopicDetail sender:dataModel tableType:type isReply:isReply];
    } else if (type == LikeListTableTypeEvaluation) {
        CircleInfoModel *dataM = (CircleInfoModel *)dataModel;
        if (dataM.itemStatus == ItemStatus_Delete) {
            return;
        }
        [self performSegueWithIdentifier:IdentifierEvaluationDetail sender:dataModel tableType:type isReply:isReply];
    }
}

- (void)getLoadMoreTableView:(UITableView *)tableView {
    MyLikeListTableView *likeTV = (MyLikeListTableView *)tableView;
    NSInteger sortId = 0;
    if (likeTV.type == LikeListTableTypeEvaluation) {
        NSInteger arrCount = [_evaluationModelArr count];
        if (arrCount > 0) {
            sortId = [[_evaluationModelArr objectAtIndex:arrCount - 1] sortId];
        }
    } else if (likeTV.type == LikeListTableTypeSpecialTopic) {
        NSInteger arrCount = [_STModelArr count];
        if (arrCount > 0) {
            sortId = [[_STModelArr objectAtIndex:arrCount - 1] sortId];
        }
    } else {
        NSInteger arrCount = [_goodsModelArr count];
        if (arrCount > 0) {
            sortId = [[_goodsModelArr objectAtIndex:arrCount - 1] sortId];
        }
    }
    [self getEvaluAndSTAndGoodsILikedInfo:GetInfoTypePull infoType:likeTV.type sortId:sortId];
}

- (void)getStartRefreshTableView:(UITableView *)tableView {
    MyLikeListTableView *likeTV = (MyLikeListTableView *)tableView;
    NSInteger sortId = 0;
    [self getEvaluAndSTAndGoodsILikedInfo:GetInfoTypeRefresh infoType:likeTV.type sortId:sortId];
}

#pragma mark - TableViewCellInteractionDelegate
- (void)sendUserCollectRequest:(NSInteger)type itemId:(NSInteger)itemId {
    // 从我的收藏入口进来查看的消息都是我喜欢的，所以不需再发送任何请求
}

- (void)headImageClick:(id)sender {
    [self performSegueWithIdentifier:IdentifierUserMainPage sender:sender tableType:LikeListTableTypeEvaluation isReply:NO];
}

- (void)sendUserZanRequest:(NSInteger)type itemId:(NSInteger)itemId {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:itemId] forKey:@"itemId"];
    [paramDic setObject:[NSNumber numberWithInteger:type] forKey:@"IdPart"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserZanRequest:paramDic];
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
    if (infoModel.type == 3) {
        _isCommentBtnClick = YES;
        [self performSegueWithIdentifier:IdentifierEvaluationDetail sender:infoModel tableType:LikeListTableTypeEvaluation isReply:NO];
        _isCommentBtnClick = NO;
    }
}

- (void)sendUserAttentionRequest:(NSString *)evaluUserId {
    NSLog(@"%@", evaluUserId);
    if (!evaluUserId) {
        NSLog(@"关注用户id不可为空");
        return;
    }
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:evaluUserId forKey:@"concernedId"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserAttentionRequest:paramDic];
    info.delegate = self;
}

- (void)gotoBuyGoods:(NSString *)goodsName goodsId:(NSInteger)goodsId goodsUrl:(NSString *)goodsUrl {
    [Helper uploadGotoBuyPageDataToUmeng:goodsName goodsId:goodsId];
    GoodsBuyViewController *vc = [[GoodsBuyViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = goodsName;
    vc.pageHtmlUrl = goodsUrl;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - NetWorkDelegate
- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    [self.netIndicatorView hide];
    if (requestID == RequestID_GetAllMyLikedInfo) {
        
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            NSInteger IdPart = [[dataDic objectForKey:@"IdPart"] integerValue];
            NSInteger IdType = [[dataDic objectForKey:@"IdType"] integerValue];
            NSArray *evaluateData = [dataDic objectForKey:@"evaluateData"];
            NSArray *goodsData = [dataDic objectForKey:@"goodsData"];
            NSArray *themeData = [dataDic objectForKey:@"themeData"];
            
            BOOL hasMoreEvalu = [evaluateData count] >= kPageSizeCount ? YES : NO;
            BOOL hasMoreST = [themeData count] >= kPageSizeCount ? YES : NO;
            BOOL hasMoreGoods = [goodsData count] >= kPageSizeCount ? YES : NO;
            
            if (!_isFirstLoadData) {
                if (IdType == GetInfoTypeRefresh) {
                    // 刷新时传sortId为0，会带回全部数据，为防止出现刷新出的数据不彻底，清空数组
                    if (IdPart == LikeListTableTypeEvaluation) {
                        [_evaluationModelArr removeAllObjects];
                    } else if (IdPart == LikeListTableTypeGoods) {
                        [_goodsModelArr removeAllObjects];
                    } else {
                        [_STModelArr removeAllObjects];
                    }
                }
                
                // 非首次加载时，根据不同的tableview刷新或上推重新加载对应的数据，其他保持不变
                if (IdPart == LikeListTableTypeEvaluation) {
                    for (NSDictionary *tmpDic in evaluateData) {
                        CircleInfoModel *tmpModel = [[CircleInfoModel alloc] initWithAttributes:tmpDic];
                        tmpModel.type = 3;
                        [_evaluationModelArr addObject:tmpModel];
                    }
                    [_likeScrollView reloadEvaluationView:_evaluationModelArr hasMoreData:hasMoreEvalu isNeedReload:YES];
                } else if (IdPart == LikeListTableTypeSpecialTopic) {
                    for (NSDictionary *tmpDic in themeData) {
                        RacketCollectionInfoModel *tmpModel = [[RacketCollectionInfoModel alloc] initWithAttributes:tmpDic];
                        tmpModel.type = 1;
                        [_STModelArr addObject:tmpModel];
                    }
                    [_likeScrollView reloadSpecialTopicView:_STModelArr hasMoreData:hasMoreST isNeedReload:YES];
                } else {
                    for (NSDictionary *tmpDic in goodsData) {
                        RacketSearchModel *tmpModel = [[RacketSearchModel alloc] initWithAttributes:tmpDic];
                        [_goodsModelArr addObject:tmpModel];
                    }
                    [_likeScrollView reloadGoodsView:_goodsModelArr hasMoreData:hasMoreGoods isNeedReload:YES];
                }
            } else {
                [_evaluationModelArr removeAllObjects];
                [_STModelArr removeAllObjects];
                [_goodsModelArr removeAllObjects];
                for (NSDictionary *tmpDic in evaluateData) {
                    CircleInfoModel *tmpModel = [[CircleInfoModel alloc] initWithAttributes:tmpDic];
                    tmpModel.type = InfoType_Evaluation;
                    [_evaluationModelArr addObject:tmpModel];
                }
                
                for (NSDictionary *tmpDic in goodsData) {
                    RacketSearchModel *tmpModel = [[RacketSearchModel alloc] initWithAttributes:tmpDic];
                    [_goodsModelArr addObject:tmpModel];
                }
                
                for (NSDictionary *tmpDic in themeData) {
                    RacketCollectionInfoModel *tmpModel = [[RacketCollectionInfoModel alloc] initWithAttributes:tmpDic];
                    tmpModel.type = InfoType_SpecialTopic;
                    [_STModelArr addObject:tmpModel];
                }
                
                [_likeScrollView reloadSpecialTopicView:_STModelArr hasMoreData:hasMoreST isNeedReload:YES];
                [_likeScrollView reloadGoodsView:_goodsModelArr hasMoreData:hasMoreGoods isNeedReload:YES];
                [_likeScrollView reloadEvaluationView:_evaluationModelArr hasMoreData:hasMoreEvalu isNeedReload:YES];
            }
        } else {
            [_likeScrollView reloadSpecialTopicView:_STModelArr hasMoreData:NO isNeedReload:NO];
            [_likeScrollView reloadGoodsView:_goodsModelArr hasMoreData:NO isNeedReload:NO];
            [_likeScrollView reloadEvaluationView:_evaluationModelArr hasMoreData:NO isNeedReload:NO];
        }
        _isFirstLoadData = NO;
    } else if (RequestID_SendUserAttention == requestID) {
        NSLog(@"%@", dic);
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *returnData = [dic objectForKey:@"returnData"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < [_evaluationModelArr count]; i++) {
                CircleInfoModel *infoModel = [_evaluationModelArr objectAtIndex:i];
                if ([infoModel.evaluateUserId isEqualToString:[returnData objectForKey:@"userId"]]) {
                    infoModel.isConcerned = [[returnData objectForKey:@"isConcerned"] integerValue];
                    NSIndexPath *te=[NSIndexPath indexPathForRow:i inSection:0];
                    [array addObject:te];
                }
            }
            [_likeScrollView.evaluationListTV reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
        }
    } else if (requestID == RequestID_SendUserZan) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            NSInteger IdPart = [[dataDic objectForKey:@"IdPart"] integerValue];
            if (IdPart == LikeListTableTypeEvaluation) {
                for (int i = 0; i < [_evaluationModelArr count]; i++) {
                    CircleInfoModel *infoModel = [_evaluationModelArr objectAtIndex:i];
                    if (infoModel.itemId == [[dataDic objectForKey:@"itemId"] integerValue]) {
                        infoModel.isPraised = [[dataDic objectForKey:@"isPraised"] integerValue];
                        infoModel.praiseList = [[dataDic objectForKey:@"praiseData"] JSONString];
                        infoModel.praiseNum = [[dataDic objectForKey:@"praiseNum"] integerValue];
                        NSIndexPath *te=[NSIndexPath indexPathForRow:i inSection:0];
                        [_likeScrollView.evaluationListTV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te, nil] withRowAnimation:UITableViewRowAnimationNone];
                        return;
                    }
                }
            } else if (IdPart == LikeListTableTypeSpecialTopic) {
                for (int i = 0; i < [_STModelArr count]; i++) {
                    RacketCollectionInfoModel *infoModel = [_STModelArr objectAtIndex:i];
                    if (infoModel.itemId == [[dataDic objectForKey:@"itemId"] integerValue]) {
                        infoModel.isPraised = [[dataDic objectForKey:@"isPraised"] integerValue];
                        infoModel.praiseNum = [[dataDic objectForKey:@"praiseNum"] integerValue];
                        NSIndexPath *te=[NSIndexPath indexPathForRow:i inSection:0];
                        [_likeScrollView.specialTopicListTV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te, nil] withRowAnimation:UITableViewRowAnimationNone];
                        return;
                    }
                }
            }
        }
    }
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {
    if (requestID == RequestID_GetAllMyLikedInfo) {
        [self.netIndicatorView hide];
        _isFirstLoadData = NO;
        [_likeScrollView reloadEvaluationView:_evaluationModelArr hasMoreData:NO isNeedReload:NO];
        [_likeScrollView reloadSpecialTopicView:_STModelArr hasMoreData:NO isNeedReload:NO];
        [_likeScrollView reloadGoodsView:_goodsModelArr hasMoreData:NO isNeedReload:NO];
    }
}

@end
