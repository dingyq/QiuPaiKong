//
//  EvaluationDetailViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/11/18.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "EvaluationDetailViewController.h"
#import "DDTextBoxView.h"
#import "EvaluationDetailCell.h"
#import "EvaluationDetailModel.h"
#import "PlaceHolderTextView.h"
#import "EvaluationPublishStatusView.h"
#import "GoodsDetailAndEvaViewController.h"
#import "HomePageViewController.h"

#define PublishTipViewTag 9898
#define TEXT_BOX_FIELD_HEIGHT 49
typedef NS_ENUM(NSInteger, IdPartType){
    IdPartType_Evaluation = 1,
    IdPartType_Comment = 2,
};

@interface EvaluationDetailViewController()<DDTextBoxViewDelegate, TableViewCellInteractionDelegate, WXApiManagerDelegate, WBApiManagerDelegate, UIAlertViewDelegate>{
    UITableView *_detailTableView;
    DDTextBoxView *_textBoxView;
    EvaluationDetailModel *_evaluationDetailModel;
    
    NSInteger _toSortId;            // 评论toSortId
    
    CGFloat _totalBytesWritten;
    CGFloat _totalBytesExpectedToWrite;
    NSInteger _imageWaitToUploadCount; // 待上传图片数量
    NSString *_content;
    BOOL _isHasMoreContent;
    BOOL _isLoadingMore;
    ShareScene _shareScene;
}
@property (nonatomic, strong) NSMutableArray *picUrl;
@property (nonatomic, strong) NSMutableArray *thumbPicUrl;
// 评测最新的一个sortId，用于点击查看更多详情
@property (nonatomic, assign) NSInteger evaluationSortId;
// 评论最旧的一个sortId，用于上推拉取信息
@property (nonatomic, assign) NSInteger commentSortId;
@end

@implementation EvaluationDetailViewController
@synthesize evaluateId = _evaluateId;

- (NSMutableArray *)picUrl {
    if (!_picUrl) {
        _picUrl = [[NSMutableArray alloc] init];
    }
    return _picUrl;
}

- (NSMutableArray *)thumbPicUrl {
    if (!_thumbPicUrl) {
        _thumbPicUrl = [[NSMutableArray alloc] init];
    }
    return _thumbPicUrl;
}

- (NSInteger)evaluationSortId {
    if ([_evaluationDetailModel.contData count] > 0) {
        SubEvaluationModel *tmpModel = [_evaluationDetailModel.contData lastObject];
        _evaluationSortId = tmpModel.sortId;
    } else {
        _evaluationSortId = 0;
    }
    return _evaluationSortId;
}

- (NSInteger)commentSortId {
    if ([_evaluationDetailModel.commentData count] > 0) {
        EvaluaCommentModel *tmpModel = [_evaluationDetailModel.commentData lastObject];
        _commentSortId = tmpModel.sortId;
    } else {
        _commentSortId = 0;
    }
    return _commentSortId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评测详情";
    NSDictionary *tmpdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:18.0],NSFontAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = tmpdic;
    
    self.navigationController.navigationBar.alpha = 1.0f;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;

    _toSortId = 0;
    _imageWaitToUploadCount = 0;
    
    _isHasMoreContent = NO;
    _isLoadingMore = NO;
    
    [WXApiManager sharedManager].delegate = self;
    [WBApiManager sharedManager].delegate = self;
    [self showMoreOperationBtn];
    [self initDataTableView];
    [self addRefreshView];
    [self initDDTextBox];
}

- (void)loadView {
    [super loadView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getEvaluationDetail:GetInfoTypeRefresh evaluateId:self.evaluateId idPart:IdPartType_Evaluation sortId:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
    [WXApiManager sharedManager].delegate = nil;
    [WBApiManager sharedManager].delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:IdentifierUserMainPage]) {
        NSString *userId = (NSString *)sender;
        HomePageViewController *vc = [[HomePageViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        vc.isMyHomePage = [userId isEqualToString:[QiuPaiUserModel getUserInstance].userId];
        vc.turnToCommentVC = NO;
        vc.pageUserId = userId;
    } else if ([identifier isEqualToString:IdentifierGoodsDetailAndEva]) {
        GoodsDetailAndEvaViewController *vc = [[GoodsDetailAndEvaViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.goodsId = [sender integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [_textBoxView hideKeyBoard];
}

- (void)moreOpClick:(UIButton *)sender {
    [_textBoxView hideKeyBoard];
    
    NSString *item0Title = @"分享";
    NSString *item1Title = @"收藏";
    NSString *item2Title = @"举报";
    if ([self getFirstEvaluationItem].isLike == LikeState_YES) {
        item1Title = @"取消收藏";
    }
    if (_isSelfEvaluation) {
        item2Title = @"删除";
    }
    NSArray *titles = @[item0Title, item1Title, item2Title];
    __weak __typeof(self)weakSelf = self;
    [Helper showMoreOpMenu:^(NSInteger tag){
        [weakSelf moreOpMenuItemClick:tag];
    } cancelHandler:nil titles:titles tags:@[@100, @200, @300]];
}

- (SubEvaluationModel *)getFirstEvaluationItem {
    SubEvaluationModel *evaluModel;
    if ([_evaluationDetailModel.contData count] > 0) {
        evaluModel = [_evaluationDetailModel.contData objectAtIndex:0];
    } else {
        evaluModel = [[SubEvaluationModel alloc] init];
    }
    return evaluModel;
}

- (void)shareBtnClick:(NSInteger)btnIndex {
    _shareScene = btnIndex;
    switch (btnIndex) {
        case 0:
        {
            UIImage *tmpImage = [UIImage imageWithContentsOfFile:KShareImagePath];
            NSData *imageData = UIImageJPEGRepresentation(tmpImage, 1.0);
            UIImage *thumbImage =[UIImage imageWithContentsOfFile:KShareThumbImagePath];
            [WXApiRequestHandler sendImageData:imageData
                                       TagName:kImageTagName
                                    MessageExt:kMessageExt
                                        Action:kMessageAction
                                    ThumbImage:thumbImage
                                       InScene:WXSceneSession];
        }
            break;
        case 1:
        {
            UIImage *tmpImage = [UIImage imageWithContentsOfFile:KShareImagePath];
            NSData *imageData = UIImageJPEGRepresentation(tmpImage, 1.0);
            UIImage *thumbImage =[UIImage imageWithContentsOfFile:KShareThumbImagePath];
            [WXApiRequestHandler sendImageData:imageData
                                       TagName:kImageTagName
                                    MessageExt:kMessageExt
                                        Action:kMessageAction
                                    ThumbImage:thumbImage
                                       InScene:WXSceneTimeline];
        }
            
            break;
        case 2:
        {
            __weak typeof(self) _weakSelf = self;
            [QQHelper shareImageMsg:[self getFirstEvaluationItem].title description:[self getFirstEvaluationItem].content scene:QQShareScene_Session callBack:^(QQApiSendResultCode sendResult){
                [_weakSelf sendUserShare:UserLikeType_Evaluation itemId:_evaluateId];
            }];
        }
            break;
        case 3:
        {
            _shareScene = ShareScene_Weibo;
            UIImage *tmpImage = [UIImage imageWithContentsOfFile:KShareImagePath];
            NSData *imageData = UIImageJPEGRepresentation(tmpImage, 1.0);
            [WBApiRequestHandler sendWeiboImageData:imageData];
        }
            break;
        default:
            break;
    }
}

- (void)moreOpMenuItemClick:(NSInteger)tag {
    switch (tag) {
        case 100:
        {
            [Helper generateUserTemplateImage:_evaluationDetailModel.nick sex:_evaluationDetailModel.sex headImage:_evaluationDetailModel.headPic likeNum:[self getFirstEvaluationItem].praiseNum influence:[_evaluationDetailModel.commentData count]];
            
            [Helper showShareSheetView:^(NSInteger btnIndex){
                [self shareBtnClick:btnIndex];
            } showQZone:NO cancelHandler:nil];
        }
            break;
        case 200:
        {
            [self sendUserCollectRequest:UserLikeType_Evaluation itemId:_evaluateId];
        }
            break;
        case 300:
        {
            if (_isSelfEvaluation) {
                NSString *titleStr = @"";
                NSString *msgStr = @"确定删除么？";
                NSString *cancalBtnStr = @"确定";
                NSString *otherBtnStr = @"取消";
                
                if (TARGET_IS_IOS8) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleStr message:msgStr preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancalBtnStr style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [self deleteUgcContent:UserLikeType_Evaluation opType:DeleteOpType_Evaluation itemId:_evaluateId sceneId:0];
                    }];
                    
                    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherBtnStr style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    }];
                    [alertController addAction:cancelAction];
                    [alertController addAction:otherAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:msgStr delegate:self cancelButtonTitle:cancalBtnStr otherButtonTitles:otherBtnStr, nil];
                    [alert show];
                }
            } else {
                [self reportUgcContent:UserLikeType_Evaluation opType:DeleteOpType_Evaluation itemId:_evaluateId sceneId:0];
            }
            
        }
            break;
        default:
            break;
    }
}

- (void)deleteUgcContent:(NSInteger)type opType:(NSInteger)opType itemId:(NSInteger)itemId sceneId:(NSInteger)sceneId {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:itemId] forKey:@"itemId"];
    [paramDic setObject:[NSNumber numberWithInteger:type] forKey:@"IdPart"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    
    [paramDic setObject:[NSNumber numberWithInteger:opType] forKey:@"opType"];
    [paramDic setObject:@"" forKey:@"sceneUserId"];
    [paramDic setObject:[NSNumber numberWithInteger:sceneId] forKey:@"sceneId"];
    RequestInfo *info = [HttpRequestManager deleteUGCContent:paramDic];
    info.delegate = self;
}

- (void)reportUgcContent:(NSInteger)type opType:(NSInteger)opType itemId:(NSInteger)itemId sceneId:(NSInteger)sceneId {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:itemId] forKey:@"itemId"];
    [paramDic setObject:[NSNumber numberWithInteger:type] forKey:@"IdPart"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    
    [paramDic setObject:[NSNumber numberWithInteger:opType] forKey:@"opType"];
    [paramDic setObject:@"" forKey:@"sceneUserId"];
    [paramDic setObject:[NSNumber numberWithInteger:sceneId] forKey:@"sceneId"];
    RequestInfo *info = [HttpRequestManager reportUGCContent:paramDic];
    info.delegate = self;
}

- (void)initDataTableView {
    _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kFrameWidth, kFrameHeight - 64 - TEXT_BOX_FIELD_HEIGHT) style:UITableViewStylePlain];
    [_detailTableView setDelegate:self];
    [_detailTableView setDataSource:self];
    [_detailTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_detailTableView];
    
    UIView *tmpfooterView = [[UIView alloc] init];
    _detailTableView.tableFooterView = tmpfooterView;
    [tmpfooterView setBackgroundColor:[UIColor clearColor]];
}


- (void)initDDTextBox {
    _textBoxView = [[DDTextBoxView alloc] initWithFrame:CGRectMake(0, kFrameHeight - TEXT_BOX_FIELD_HEIGHT, kFrameWidth, TEXT_BOX_FIELD_HEIGHT)];
    _textBoxView.myDelegate = self;
    _textBoxView.isSelfEvalu = self.isSelfEvaluation;
    [self.view addSubview:_textBoxView];
//    [_textBoxView setConstraints:0 bottom:0 width:kFrameWidth height:TEXT_BOX_FIELD_HEIGHT];
}

- (void)addRefreshView {
    __weak __typeof(self)weakSelf = self;
    _detailTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getEvaluationDetail:GetInfoTypeRefresh evaluateId:self.evaluateId idPart:IdPartType_Evaluation sortId:0];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _detailTableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _detailTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getEvaluationDetail:GetInfoTypePull evaluateId:self.evaluateId idPart:IdPartType_Comment sortId:self.commentSortId];
    }];
}

// 用于获取更多评测or评论or页面刷新的请求服务
- (void)getEvaluationDetail:(NSInteger)getInfoType evaluateId:(NSInteger)evaluId idPart:(NSInteger)idPart sortId:(NSInteger)sortId{
    if (getInfoType == GetInfoTypeRefresh) {
        [self.netIndicatorView show];
    }
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].userId forKey:@"userId"];
    [paramDic setObject:[NSNumber numberWithInteger:getInfoType] forKey:@"IdType"];
    [paramDic setObject:[NSNumber numberWithInteger:idPart] forKey:@"IdPart"];
    [paramDic setObject:[NSNumber numberWithInteger:sortId] forKey:@"lastId"];
    [paramDic setObject:[NSNumber numberWithInteger:evaluId] forKey:@"evaluateId"];
    RequestInfo *info = [HttpRequestManager getEvaluationDetailInfo:paramDic];
    info.delegate = self;
}

// 发送新评论
- (void)sendComment:(NSString *)content toSortId:(NSInteger)sortId {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:@"" forKey:@"sceneUserId"];
    [paramDic setObject:[NSNumber numberWithInteger:self.evaluateId] forKey:@"sceneId"];
    [paramDic setObject:[NSNumber numberWithInteger:MessageSceneType_Evaluation] forKey:@"scene"];
    [paramDic setObject:[NSNumber numberWithInteger:sortId] forKey:@"toSortId"];
    [paramDic setObject:content forKey:@"content"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserComment:paramDic];
    info.delegate = self;
}

// 上传图片
- (void)uploadImage:(UIImage *)image fileName:(NSString *)name {
    EvaluationPublishStatusView *publishTipView = [[[UIApplication sharedApplication] keyWindow] viewWithTag:PublishTipViewTag];
    RequestInfo *info = [HttpRequestManager sendUploadImageRequest:image fileName:name];
    info.delegate = self;
    info.uploadProgress = ^(NSUInteger bytesWritten,long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        _totalBytesWritten += bytesWritten;
        [publishTipView updateProgress:_totalBytesWritten/_totalBytesExpectedToWrite];
    };
}

- (void)sendUserShare:(NSInteger)type itemId:(NSInteger)itemId {
    [Helper uploadShareEventDataToUmeng:_shareScene content:@"装备评测" name:_evaluationDetailModel.racquet cId:itemId];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:itemId] forKey:@"itemId"];
    [paramDic setObject:[NSNumber numberWithInteger:type] forKey:@"IdPart"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserShareRequest:paramDic];
    info.delegate = self;
}

#pragma -mark DDTextBoxViewDelegate
- (void)sendUserZanRequest {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:self.evaluateId] forKey:@"itemId"];
    [paramDic setObject:[NSNumber numberWithInteger:3] forKey:@"IdPart"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserZanRequest:paramDic];
    info.delegate = self;
}

- (void)sendEvaluation {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:self.evaluateId] forKey:@"evaluateId"];
    [paramDic setObject:@"" forKey:@"title"];
    [paramDic setObject:_content forKey:@"content"];
    [paramDic setObject:@[] forKey:@"goodsName"];
    [paramDic setObject:self.picUrl forKey:@"picUrl"];
    [paramDic setObject:self.thumbPicUrl forKey:@"thumbPicUrl"];
    [paramDic setObject:[NSNumber numberWithInteger:4] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager publishNewEvaluation:paramDic];
    info.delegate = self;
}

- (void)sendMessageRequest:(NSString *)comment imageArr:(NSArray *)imageArr isReply:(BOOL)isreply {
    if (isreply) {
        if (![comment isEqualToString:@""]) {
            [self sendComment:comment toSortId:_toSortId];
        }
    } else {
        _content = comment;
        [self.picUrl removeAllObjects];
        [self.thumbPicUrl removeAllObjects];
        _totalBytesWritten = 0;
        _totalBytesExpectedToWrite = 0;
        _imageWaitToUploadCount = [imageArr count];
        
        if ([imageArr count] > 0) {
            EvaluationPublishStatusView *publishTipView = [[EvaluationPublishStatusView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight)];
            [publishTipView setTag:PublishTipViewTag];
            [[[UIApplication sharedApplication] keyWindow] addSubview:publishTipView];
            
            for (int i = 0; i < [imageArr count]; i++) {
                NSString *fileName = [NSString stringWithFormat:@"image_%d", i];
                UIImage *image = [imageArr objectAtIndex:i];
                NSData *imgDataCompress = UIImageJPEGRepresentation(image, 0.9);
                _totalBytesExpectedToWrite += [imgDataCompress length];
                _totalBytesExpectedToWrite += 257;
                [self uploadImage:image fileName:fileName];
            }
        } else {
            [self sendEvaluation];
        }
    }
}

#pragma -mark TableViewCellInteractionDelegate

- (void)headImageClick:(id)sender {
    [self performSegueWithIdentifier:IdentifierUserMainPage sender:sender];
}

- (void)loadMoreSubEvalution {
    NSLog(@"loadMoreSubEvalution");
    if (!_isLoadingMore) {
        [self getEvaluationDetail:GetInfoTypePull evaluateId:self.evaluateId idPart:IdPartType_Evaluation sortId:self.evaluationSortId];
        _isLoadingMore = YES;
    }
}

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

- (void)sendUserAttentionRequest:(NSString *)evaluUserId{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:_evaluationDetailModel.userId forKey:@"concernedId"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserAttentionRequest:paramDic];
    info.delegate = self;
}

- (void)getTagGoodsRequest:(NSInteger)goodsId {
    [self performSegueWithIdentifier:IdentifierGoodsDetailAndEva sender:[NSNumber numberWithInteger:goodsId]];
}

- (void)commentButtonClick:(id)sender {
    NSLog(@"commentButtonClick");
}

#pragma mark - WBApiManagerDelegate
- (void)wbApiManagerDidRecvMessageResponse:(WBSendMessageToWeiboResponse *)response {
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%ld", (long)response.statusCode];
    if ((NSInteger)response.statusCode == 0) {
        [self sendUserShare:UserLikeType_Evaluation itemId:_evaluateId];
        NSString* accessToken = [response.authResponse accessToken];
        if (accessToken) {
            [QiuPaiUserModel getUserInstance].wbtoken = accessToken;
        }
        NSString* userID = [response.authResponse userID];
        if (userID) {
            [QiuPaiUserModel getUserInstance].wbCurrentUserID = userID;
        }
    } else {
        NSLog(@"分享失败 %@", strMsg);
    }
}


#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", response.errCode];
    if (response.errCode == 0) {
        NSLog(@"分享成功 %@", strMsg);
        [self sendUserShare:UserLikeType_Evaluation itemId:_evaluateId];
    } else {
        NSLog(@"分享失败 %@", strMsg);
    }
}

#pragma -mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self deleteUgcContent:UserLikeType_Evaluation opType:DeleteOpType_Evaluation itemId:_evaluateId sceneId:0];
    }
}

#pragma -mark NetWorkDelegate
- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    [self.netIndicatorView hide];
    if (RequestID_UploadImage == requestID) {
        _imageWaitToUploadCount --;
        if (NetWorkJsonResOK == [[dic objectForKey:@"statusCode"] integerValue]) {
            [self.picUrl addObject:[dic objectForKey:@"fileName"]];
            [self.thumbPicUrl addObject:[dic objectForKey:@"thumbFileName"]];
        }
        if (_imageWaitToUploadCount == 0) {
            [self sendEvaluation];
        }
    } else if (RequestID_PublishNewEvaluation == requestID) {
        EvaluationPublishStatusView *publishTipView = [[[UIApplication sharedApplication] keyWindow] viewWithTag:PublishTipViewTag];
        [publishTipView removeFromSuperview];
        if (NetWorkJsonResOK == [[dic objectForKey:@"statusCode"] integerValue]) {
            NSLog(@"发布成功");
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            for (NSDictionary *tmpDic in [dataDic objectForKey:@"contData"] ) {
                SubEvaluationModel *tmpModel = [[SubEvaluationModel alloc] initWithAttributes:tmpDic];
                [_evaluationDetailModel.contData addObject:tmpModel];
            }
            NSIndexPath *te=[NSIndexPath indexPathForRow:_evaluationDetailModel.contData.count-1 inSection:0];
            [_detailTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:te, nil] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            NSLog(@"发布失败");
        }
    } else if (RequestID_GetEvaluationDetailInfo == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            NSArray *contData = [dataDic objectForKey:@"contData"];
            NSArray *commentData = [dataDic objectForKey:@"commentData"];
            
            GetInfoType getInfoType = [[dataDic objectForKey:@"IdType"] integerValue];
            IdPartType IdPart = [[dataDic objectForKey:@"IdPart"] integerValue];

            if (getInfoType == GetInfoTypeRefresh) {
                [_detailTableView.mj_header endRefreshing];
                // 下拉刷新全部数据
                [_evaluationDetailModel.contData removeAllObjects];
                [_evaluationDetailModel.commentData removeAllObjects];
                _evaluationDetailModel = [[EvaluationDetailModel alloc] initWithAttributes:dataDic];
                if ([_evaluationDetailModel.commentData count] < kPageSizeCount) {
                    [_detailTableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [_detailTableView.mj_footer resetNoMoreData];
                }
                
                if (_isShowKeyBoard) {
                    [_textBoxView displayKeyBoard];
                    _isShowKeyBoard = NO;
                    if (_placeHodlerStr && ![_placeHodlerStr isEqualToString:@""]) {
                        _textBoxView.textView.placeholder = _placeHodlerStr;
                    } else {
                        _textBoxView.textView.placeholder = @"评论一下吧";
                    }
                    _textBoxView.isReply = YES;
                }
                
                if ([contData count] < kPageSizeCount) {
                    _isHasMoreContent = NO;
                } else {
                    _isHasMoreContent = YES;
                }
            } else {
                if (IdPart == IdPartType_Evaluation) {
                    // 点击获取更多评测数据
                    _isLoadingMore = NO;
                    for (int i = 0; i < [contData count]; i++) {
                        SubEvaluationModel *tmpModel = [[SubEvaluationModel alloc] initWithAttributes:[contData objectAtIndex:i]];
                        [_evaluationDetailModel.contData addObject:tmpModel];
                    }
                    
                    if ([contData count] < kPageSizeCount) {
                        _isHasMoreContent = NO;
                    } else {
                        _isHasMoreContent = YES;
                    }
                    
                } else {
                    // 上推拉取更多评论
                    [_detailTableView.mj_footer endRefreshing];
                    if ([commentData count] < kPageSizeCount) {
                        [_detailTableView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        [_detailTableView.mj_footer resetNoMoreData];
                    }
                    for (int i = 0; i < [commentData count]; i++) {
                        EvaluaCommentModel *tmpModel = [[EvaluaCommentModel alloc] initWithAttributes:[commentData objectAtIndex:i]];
                        [_evaluationDetailModel.commentData addObject:tmpModel];
                    }
                }
            }
            if ([commentData count] > 0 || [contData count] > 0) {
                [_detailTableView reloadData];
            }            
        } else {
            [_detailTableView.mj_header endRefreshing];
        }
    
    } else if (RequestID_SendComment == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            if ([[[dic objectForKey:@"returnData"] objectForKey:@"messageNum"] integerValue]) {
                _evaluationDetailModel.messageNum = [[[dic objectForKey:@"returnData"] objectForKey:@"messageNum"] integerValue];
            }            
            NSArray *comentData = [[dic objectForKey:@"returnData"] objectForKey:@"contData"];
            if ([comentData count] < kPageSizeCount) {
                [_detailTableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [_detailTableView.mj_footer resetNoMoreData];
            }
            
            if ([comentData count] > 0) {
                [_evaluationDetailModel.commentData removeAllObjects];
            }
            
            for (int i = 0; i < [comentData count]; i++) {
                EvaluaCommentModel *tmpModel = [[EvaluaCommentModel alloc] initWithAttributes:[comentData objectAtIndex:i]];
                [_evaluationDetailModel.commentData addObject:tmpModel];
            }
            
            if ([comentData count] > 0) {
                [_detailTableView reloadData];
            }
        }
    } else if (RequestID_SendUserCollect == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            NSInteger IdPart = [[dataDic objectForKey:@"IdPart"] integerValue];
            if (IdPart == UserLikeType_Evaluation) {
                if (_evaluationDetailModel.evaluateId == [[dataDic objectForKey:@"itemId"] integerValue]) {
                    [self getFirstEvaluationItem].isLike = [[dataDic objectForKey:@"isLiked"] integerValue];
                    NSInteger newLikeNum = [[dataDic objectForKey:@"likeNum"] integerValue];
                    _evaluationDetailModel.likeNum = newLikeNum;
//                    NSIndexPath *te=[NSIndexPath indexPathForRow:0 inSection:0];
//                    [_detailTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te, nil] withRowAnimation:UITableViewRowAnimationNone];
                    NSString *tipStr = [self getFirstEvaluationItem].isLike == LikeState_YES ? @"收藏成功":@"已取消收藏";
                    [self loadingTipView:tipStr callBack:nil];
                    return;
                }
            }
        }
    } else if (RequestID_SendUserAttention == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *returnData = [dic objectForKey:@"returnData"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            if ([_evaluationDetailModel.userId isEqualToString:[returnData objectForKey:@"userId"]]) {
                _evaluationDetailModel.isConcerned = [[returnData objectForKey:@"isConcerned"] integerValue];
                NSIndexPath *te=[NSIndexPath indexPathForRow:0 inSection:0];
                [array addObject:te];
                [_detailTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    } else if (RequestID_SendUserZan == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            NSInteger itemId = [[dataDic objectForKey:@"itemId"] integerValue];
            for (int i = 0; i < [_evaluationDetailModel.contData count]; i ++) {
                SubEvaluationModel *tmpModel = [_evaluationDetailModel.contData objectAtIndex:i];
                if (tmpModel.itemId == itemId || _evaluationDetailModel.evaluateId == itemId) {
                    tmpModel.isPraised = [[dataDic objectForKey:@"isPraised"] integerValue];
                    tmpModel.praiseNum = [[dataDic objectForKey:@"praiseNum"] integerValue];
                    NSArray *zanArr = [dataDic objectForKey:@"praiseData"];
                    tmpModel.praiseList = [[NSMutableArray alloc] initWithArray:zanArr];
                    NSIndexPath *te=[NSIndexPath indexPathForRow:i inSection:0];
                    [_detailTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te, nil] withRowAnimation:UITableViewRowAnimationNone];
                    return;
                }
            }
        }
    } else if (RequestID_DeleteUGCContent == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            NSInteger IdPart = [[dataDic objectForKey:@"IdPart"] integerValue];
            NSInteger opType = [[dataDic objectForKey:@"opType"] integerValue];
            if (IdPart == UserLikeType_Evaluation) {
                if (opType == DeleteOpType_Evaluation) {
                    if ([[dataDic objectForKey:@"itemId"] integerValue] == _evaluateId) {
                        // 删除主评测成功
                        [self loadingTipView:@"删除成功" callBack:^{
                            NSLog(@"test");
                            [self.myDelegate deleteMainEvaluation:_evaluateId];
                            [self backToPreVC:nil];
                        }];
                    }
                } else if (opType == DeleteOpType_Message) {
                    for (int i = 0; i < [_evaluationDetailModel.commentData count]; i++) {
                        EvaluaCommentModel *tmpModel = [_evaluationDetailModel.commentData objectAtIndex:i];
                        if ([[dataDic objectForKey:@"itemId"] integerValue] == tmpModel.itemId) {
                            // 删除评论成功
                            [_evaluationDetailModel.commentData removeObjectAtIndex:i];
                            _evaluationDetailModel.messageNum = [[dataDic objectForKey:@"commentNum"] integerValue];
                            [_detailTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                            return;
                        }
                    }
                }
                
            } else if (IdPart == UserLikeType_SubEvaluation) {
                for (int i = 0; i < [_evaluationDetailModel.contData count]; i++) {
                    SubEvaluationModel *tmpModel = [_evaluationDetailModel.contData objectAtIndex:i];
                    if ([[dataDic objectForKey:@"itemId"] integerValue] == tmpModel.itemId) {
                        // 子评测删除成功
                        [_evaluationDetailModel.contData removeObjectAtIndex:i];
                        [_detailTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        return;
                    }
                }
            }
        }
    } else if (RequestID_SendUserShare == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSLog(@"分享成功");
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            if ([[dataDic objectForKey:@"itemId"] integerValue] == _evaluateId) {
                _evaluationDetailModel.shareNum = [[dataDic objectForKey:@"shareNum"] integerValue];
            }
        }
    } else if (requestID == RequestID_ReportUGCContent) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            NSInteger IdPart = [[dataDic objectForKey:@"IdPart"] integerValue];
            NSInteger opType = [[dataDic objectForKey:@"opType"] integerValue];
            if (IdPart == UserLikeType_Evaluation) {
                if (opType == DeleteOpType_Evaluation) {
                    if ([[dataDic objectForKey:@"itemId"] integerValue] == _evaluateId) {
                        // 举报主评测成功
                        [self loadingTipView:@"举报成功" callBack:^{
                            NSLog(@"test");
                            [self.myDelegate deleteMainEvaluation:_evaluateId];
                            [self backToPreVC:nil];
                        }];
                    }
                }
            } else if (IdPart == UserLikeType_SubEvaluation) {
                for (int i = 0; i < [_evaluationDetailModel.contData count]; i++) {
                    SubEvaluationModel *tmpModel = [_evaluationDetailModel.contData objectAtIndex:i];
                    if ([[dataDic objectForKey:@"itemId"] integerValue] == tmpModel.itemId) {
                        // 子评测举报成功
                        [_evaluationDetailModel.contData removeObjectAtIndex:i];
                        [_detailTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        return;
                    }
                }
            }
        }
    }
    
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {
    if (RequestID_UploadImage == requestID) {
        _imageWaitToUploadCount --;
        if (_imageWaitToUploadCount == 0) {
//            [self sendEvaluation];
        }
    } else if (RequestID_GetEvaluationDetailInfo == requestID) {
        [self.netIndicatorView hide];
        [self.badNetTipV show];
        
        [_detailTableView.mj_header endRefreshing];
        [_detailTableView.mj_footer endRefreshingWithNoMoreData];
        _isLoadingMore = NO;
    }
}

#pragma -mark MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    
}

#pragma -mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_textBoxView hideKeyBoard];
}


#pragma -mark TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        SubEvaluationModel *evaluModel = _evaluationDetailModel.contData[row];
        [_textBoxView hideKeyBoard];
        if (row > 0) {

            if (_isSelfEvaluation) {
                MoreOpearationMenu *tmpView = [[MoreOpearationMenu alloc] initWithTitles:@[@"删除"] itemTags:@[@100]];
                [tmpView showActionSheetWithClickBlock:^(NSInteger tag){
                    if (tag == 100) {
                        // 删除子评测
                        [self deleteUgcContent:UserLikeType_SubEvaluation opType:DeleteOpType_Evaluation itemId:evaluModel.itemId sceneId:_evaluateId];
                    }
                } cancelBlock:nil];
            }
        }
    } else if (section == 1) {
        EvaluaCommentModel *commentModel = _evaluationDetailModel.commentData[row];
        if ([commentModel.commentUserId isEqualToString:[QiuPaiUserModel getUserInstance].userId]) {
            [_textBoxView hideKeyBoard];
            MoreOpearationMenu *tmpView = [[MoreOpearationMenu alloc] initWithTitles:@[@"删除"] itemTags:@[@100]];
            [tmpView showActionSheetWithClickBlock:^(NSInteger tag){
                if (tag == 100) {
                    // 删除评论
                    [self deleteUgcContent:UserLikeType_Evaluation opType:DeleteOpType_Message itemId:commentModel.itemId sceneId:_evaluateId];
                }
            } cancelBlock:nil];
        } else {
            _toSortId = commentModel.sortId;
            NSString *nickName = commentModel.commentName;
            [_textBoxView displayKeyBoard];
            _textBoxView.textView.placeholder = [NSString stringWithFormat:@"回复 %@:", nickName];
            _textBoxView.isReply = YES;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 22.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        NSString *tipStr = @"";
        if ([_evaluationDetailModel.contData count] > 0) {
            tipStr = [NSString stringWithFormat:@"   全部评论：(%ld)", (long)_evaluationDetailModel.messageNum];
        }
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 22)];
        [tmpView setBackgroundColor:Gray240Color];
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 22)];
        [tipLabel setText:tipStr];
        [tipLabel setTextColor:Gray153Color];
        [tipLabel setBackgroundColor:[UIColor whiteColor]];
        [tipLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [tipLabel setTextAlignment:NSTextAlignmentLeft];
        [tmpView addSubview:tipLabel];
        
        return tmpView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == 0) {
//        if (_isHasMoreContent) {
//            return 30.0f;
//        }
//    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_evaluationDetailModel getEvaluationDetailCellHeight:indexPath.section cellRow:indexPath.row isHideGoodsTag:!_isShowTag];
}

#pragma -mark
#pragma -mark TableView DataSource
#pragma -mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = 0;
    if (section == 0) {
        rowCount = [_evaluationDetailModel.contData count];
        if (_isHasMoreContent) {
            rowCount ++;
        }
    } else {
        rowCount = [_evaluationDetailModel.commentData count];
    }
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    NSString *identifier = @"EvaluationDetailContentCell";
    EvaluationDetailCellType cellType = EvaluationDetailCellType_Evalu;
    if (section == 1) {
        identifier = @"EvaluationDetailCommentCell";
        cellType = EvaluationDetailCellType_Comment;
    }
    EvaluationDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[EvaluationDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier cellType:cellType];
        cell.myDelegate = self;
    }
    
    if (section == 0) {
        if (_isSelfEvaluation && row > 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    [cell bindContentCellWithModel:_evaluationDetailModel cellSection:section cellIndex:row hideGoodsTag:!_isShowTag];
    return cell;
}


@end
