//
//  SpecialTopicCommentViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/12/9.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "SpecialTopicCommentViewController.h"

#import "STCommentModel.h"
#import "STCommentCell.h"
#import "DDTextBoxView.h"
#import "PlaceHolderTextView.h"

#define TEXT_BOX_FIELD_HEIGHT 49

@interface SpecialTopicCommentViewController() <NetWorkDelegate, DDTextBoxViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    UITableView *_commentsListTV;
    DDTextBoxView *_textBoxView;
    NSInteger _toSortId;            // 评论toSortId
}

@property (nonatomic, assign) NSInteger latestSortId;
@property (nonatomic, assign) NSInteger oldestSortId;

@end

@implementation SpecialTopicCommentViewController

- (NSInteger)latestSortId {
    if (_commentsArr.count > 0) {
        _latestSortId = [[_commentsArr firstObject] sortId];
    } else {
        _latestSortId = 0;
    }
    return _latestSortId;
}

- (NSInteger)oldestSortId {
    if (_commentsArr.count > 0) {
        _oldestSortId = [[_commentsArr lastObject] sortId];
    } else {
        _oldestSortId = 0;
    }
    return _oldestSortId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:VCViewBGColor];
    
    self.title = @"评论";
    _toSortId = 0;
    [self initCommentsListTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addRefreshView:_commentsListTV];
    [self initDDTextBox];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_isShowKeyBoard) {
        [_textBoxView displayKeyBoard];
        _isShowKeyBoard = NO;
        if (_placeHodlerStr && ![_placeHodlerStr isEqualToString:@""]) {
            _textBoxView.textView.placeholder = _placeHodlerStr;
        }
        _textBoxView.isReply = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCommentsArr:(NSMutableArray *)commentsArr {
    _commentsArr = [[NSMutableArray alloc] initWithArray:commentsArr];
}

- (NSInteger)commentNum {
    return _commentNum?_commentNum:[_commentsArr count];
}

- (void)initCommentsListTableView {
    _commentsListTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kFrameWidth, kFrameHeight - 64 - TEXT_BOX_FIELD_HEIGHT) style:UITableViewStylePlain];
    [_commentsListTV setDelegate:self];
    [_commentsListTV setDataSource:self];
    [self.view addSubview:_commentsListTV];
    
    _commentsListTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footerView = [[UIView alloc] init];
    _commentsListTV.tableFooterView = footerView;
    [footerView setBackgroundColor:[UIColor clearColor]];
}

- (void)initDDTextBox {
    _textBoxView = [[DDTextBoxView alloc] initWithFrame:CGRectMake(0, kFrameHeight - TEXT_BOX_FIELD_HEIGHT, kFrameWidth, TEXT_BOX_FIELD_HEIGHT)];
    _textBoxView.myDelegate = self;
    _textBoxView.isSelfEvalu = NO;
    _textBoxView.isUserLike = self.isLike;
    _textBoxView.isShowLike = NO;
    
    
    [_textBoxView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_textBoxView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [_textBoxView hideKeyBoard];
}

- (void)addRefreshView:(UITableView *)tableView {
    __weak __typeof(self)weakSelf = self;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getSpecialTopicDetail:GetInfoTypeRefresh sortId:0];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getSpecialTopicDetail:GetInfoTypePull sortId:weakSelf.oldestSortId];
    }];
}

- (void)getSpecialTopicDetail:(GetInfoType)getInfoType sortId:(NSInteger)latestId {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:self.topicId] forKey:@"themeId"];
    [paramDic setObject:[NSNumber numberWithInteger:2] forKey:@"IdPart"];
    [paramDic setObject:[NSNumber numberWithInteger:getInfoType] forKey:@"IdType"];
    [paramDic setObject:[NSNumber numberWithInteger:latestId] forKey:@"lastId"];
    RequestInfo *info = [HttpRequestManager getSpecialTopicDetailInfo:paramDic];
    info.delegate = self;
}

// 删除评论
- (void)deleteUgcContent:(NSInteger)itemId sceneId:(NSInteger)sceneId {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:itemId] forKey:@"itemId"];
    [paramDic setObject:[NSNumber numberWithInteger:UserLikeType_SpecialTopic] forKey:@"IdPart"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    
    [paramDic setObject:[NSNumber numberWithInteger:DeleteOpType_Message] forKey:@"opType"];
    [paramDic setObject:@"" forKey:@"sceneUserId"];
    [paramDic setObject:[NSNumber numberWithInteger:sceneId] forKey:@"sceneId"];
    RequestInfo *info = [HttpRequestManager deleteUGCContent:paramDic];
    info.delegate = self;
}

// 发送新评论
- (void)sendComment:(NSString *)content toSortId:(NSInteger)sortId {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:@"" forKey:@"sceneUserId"];
    [paramDic setObject:[NSNumber numberWithInteger:self.topicId] forKey:@"sceneId"];
    [paramDic setObject:[NSNumber numberWithInteger:MessageSceneType_SpecialTopic] forKey:@"scene"];
    [paramDic setObject:[NSNumber numberWithInteger:sortId] forKey:@"toSortId"];
    [paramDic setObject:content forKey:@"content"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserComment:paramDic];
    info.delegate = self;
}

#pragma -mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_textBoxView hideKeyBoard];
}

#pragma -mark DDTextBoxViewDelegate
- (void)sendMessageRequest:(NSString *)comment imageArr:(NSArray *)imageArr isReply:(BOOL)isreply {
    if (![comment isEqualToString:@""]) {
        [self sendComment:comment toSortId:_toSortId];
    }
}

#pragma -mark NetWorkDelegate
- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    if (requestID == RequestID_GetSpecialTopicDetail) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            NSArray *commentArr = [dataDic objectForKey:@"commentData"];
            NSInteger getInfoType = [[dataDic objectForKey:@"IdType"] integerValue];
            if (getInfoType == GetInfoTypeRefresh) {
                [_commentsListTV.mj_header endRefreshing];
                // 每次返回10条，为保证刷新出来的为最新的10条，所以每次刷新都要清掉原有数据
                [_commentsArr removeAllObjects];
            } else {
                [_commentsListTV.mj_footer endRefreshing];
            }
            
            for (int i = 0; i < [commentArr count]; i ++) {
                NSDictionary *tmpDic = [commentArr objectAtIndex:i];
                STCommentModel *tmpModel = [[STCommentModel alloc] initWithAttributes:tmpDic];
                [_commentsArr addObject:tmpModel];
            }
            
            if ([commentArr count] < kPageSizeCount) {
                [_commentsListTV.mj_footer endRefreshingWithNoMoreData];
            } else {
                [_commentsListTV.mj_footer resetNoMoreData];
            }
            [_commentsListTV reloadData];
        }
    } else if (RequestID_SendComment == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            self.commentNum = [[[dic objectForKey:@"returnData"] objectForKey:@"messageNum"] integerValue];
            NSArray *comentData = [[dic objectForKey:@"returnData"] objectForKey:@"contData"];
            if ([comentData count] < kPageSizeCount) {
                NSLog(@"没有更多评论数据了");
                [_commentsListTV.mj_footer endRefreshingWithNoMoreData];
            } else {
                [_commentsListTV.mj_footer resetNoMoreData];
            }
            
            if ([comentData count] > 0) {
                [_commentsArr removeAllObjects];
            }
            
            for (int i = 0; i < [comentData count]; i++) {
                NSDictionary *tmpDic = [comentData objectAtIndex:i];
                [_commentsArr addObject:[[STCommentModel alloc] initWithAttributes:tmpDic]];
            }
            
            if ([comentData count] > 0) {
                [_commentsListTV reloadData];
            }
        }
    } else if (RequestID_SendUserZan == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            
        }
    } else if (RequestID_DeleteUGCContent == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            NSInteger IdPart = [[dataDic objectForKey:@"IdPart"] integerValue];
            if (IdPart == UserLikeType_SpecialTopic) {
                for (int i = 0; i < [_commentsArr count]; i++) {
                    STCommentModel *tmpModel = [_commentsArr objectAtIndex:i];
                    if ([[dataDic objectForKey:@"itemId"] integerValue] == tmpModel.itemId) {
                        // 评论删除成功
                        [_commentsArr removeObjectAtIndex:i];
                        _commentNum = [[dataDic objectForKey:@"commentNum"] integerValue];
                        [_commentsListTV reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                        return;
                    }
                }
            }
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
    return [_commentsArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[_commentsArr objectAtIndex:indexPath.row] getCommentCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 20)];
    [bgView setBackgroundColor:LineViewColor];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 19.5)];
    [tipLabel setBackgroundColor:[UIColor whiteColor]];
    [tipLabel setFont:[UIFont systemFontOfSize:13]];
    [tipLabel setTextColor:Gray153Color];
    [tipLabel setTextAlignment:NSTextAlignmentLeft];
    [tipLabel setText:[NSString stringWithFormat:@"  共条%lu评论", (long)self.commentNum]];
    [bgView addSubview:tipLabel];
    
    return bgView;
    
    
//    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 19.0, kFrameWidth, 1)];
//    [lineView setBackgroundColor:LineViewColor];
//    [tipLabel addSubview:lineView];
//    
//    return tipLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"stCommentCell";
    STCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[STCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell bindCellWithDataModel:[_commentsArr objectAtIndex:indexPath.row]];
//    [cell.textLabel setText:[[_commentsArr objectAtIndex:indexPath.row] content]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    
    STCommentModel *commentModel = _commentsArr[row];
    if ([commentModel.commentUserId isEqualToString:[QiuPaiUserModel getUserInstance].userId]) {
        [_textBoxView hideKeyBoard];
        MoreOpearationMenu *tmpView = [[MoreOpearationMenu alloc] initWithTitles:@[@"删除"] itemTags:@[@100]];
        [tmpView showActionSheetWithClickBlock:^(NSInteger tag){
            if (tag == 100) {
                // 删除评论
                [self deleteUgcContent:commentModel.itemId sceneId:_topicId];
            }
        } cancelBlock:nil];
    } else {
        _toSortId = [commentModel sortId];
        NSString *nickName = [commentModel commentName];
        [_textBoxView displayKeyBoard];
        _textBoxView.textView.placeholder = [NSString stringWithFormat:@"回复 %@:", nickName];
        _textBoxView.isReply = YES;
    }
}


@end
