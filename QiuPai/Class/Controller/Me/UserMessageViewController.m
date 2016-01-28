//
//  UserMessageViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/12/10.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "UserMessageViewController.h"
#import "DDTextBoxView.h"
#import "PlaceHolderTextView.h"
#import "STCommentCell.h"
#import "UserMessageModel.h"

#define TEXT_BOX_FIELD_HEIGHT 49

@interface UserMessageViewController() <NetWorkDelegate, DDTextBoxViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    UITableView *_messageListTV;
    DDTextBoxView *_textBoxView;
    NSInteger _toSortId;            // 评论toSortId
}

@property (nonatomic, assign) NSInteger latestSortId;
@property (nonatomic, assign) NSInteger oldestSortId;

@end

@implementation UserMessageViewController

- (NSInteger)latestSortId {
    if (_messagesArr.count > 0) {
        _latestSortId = [[_messagesArr firstObject] sortId];
    } else {
        _latestSortId = 0;
    }
    return _latestSortId;
}

- (NSInteger)oldestSortId {
    if (_messagesArr.count > 0) {
        _oldestSortId = [[_messagesArr lastObject] sortId];
    } else {
        _oldestSortId = 0;
    }
    return _oldestSortId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:VCViewBGColor];
    self.title = @"留言";
    
    [self initMessagesListTableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addRefreshView:_messageListTV];
    [self initDDTextBox];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self getUserMessagesList:GetInfoTypeRefresh sortId:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [_textBoxView hideKeyBoard];
}

- (void)setMessagesArr:(NSMutableArray *)messagesArr {
    _messagesArr = [[NSMutableArray alloc] initWithArray:messagesArr];
    [_messageListTV reloadData];
}

- (NSInteger)messageNum {
    return _messageNum?_messageNum:[_messagesArr count];
}

- (void)initMessagesListTableView {
    _messageListTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kFrameWidth, kFrameHeight - TEXT_BOX_FIELD_HEIGHT - 64) style:UITableViewStylePlain];
    [_messageListTV setDelegate:self];
    [_messageListTV setDataSource:self];
    [self.view addSubview:_messageListTV];
    
    _messageListTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footerView = [[UIView alloc] init];
    _messageListTV.tableFooterView = footerView;
    [footerView setBackgroundColor:[UIColor clearColor]];
}

- (void)initDDTextBox {
    _textBoxView = [[DDTextBoxView alloc] initWithFrame:CGRectMake(0, kFrameHeight - TEXT_BOX_FIELD_HEIGHT, kFrameWidth, TEXT_BOX_FIELD_HEIGHT)];
    _textBoxView.myDelegate = self;
    _textBoxView.isSelfEvalu = NO;
    [self.view addSubview:_textBoxView];
}

- (void)addRefreshView:(UITableView *)tableView {
    
    __weak __typeof(self)weakSelf = self;
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getUserMessagesList:GetInfoTypeRefresh sortId:0];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getUserMessagesList:GetInfoTypePull sortId:weakSelf.oldestSortId];
    }];
}

- (void)getUserMessagesList:(GetInfoType)getInfoType sortId:(NSInteger)latestId {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:getInfoType] forKey:@"IdType"];
    // IdPart 为1是拉取主页信息流
    [paramDic setObject:[NSNumber numberWithInteger:2] forKey:@"IdPart"];
    [paramDic setObject:_pageUserId forKey:@"toUserId"];
    [paramDic setObject:[NSNumber numberWithInteger:latestId] forKey:@"lastId"];
    RequestInfo *info = [HttpRequestManager getUserMainPageInfo:paramDic];
    info.delegate = self;
}

// 发送新评论
- (void)sendComment:(NSString *)content toSortId:(NSInteger)sortId {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:_pageUserId forKey:@"sceneUserId"];
    [paramDic setObject:[NSNumber numberWithInteger:MessageSceneType_MainPage] forKey:@"scene"];
    [paramDic setObject:[NSNumber numberWithInteger:sortId] forKey:@"toSortId"];
    [paramDic setObject:content forKey:@"content"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserComment:paramDic];
    info.delegate = self;
}

// 删除评论
- (void)deleteUgcContent:(NSInteger)itemId userId:(NSString *)userId {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:itemId] forKey:@"itemId"];
    [paramDic setObject:[NSNumber numberWithInteger:UserLikeType_MainPage] forKey:@"IdPart"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    [paramDic setObject:[NSNumber numberWithInteger:DeleteOpType_Message] forKey:@"opType"];
    [paramDic setObject:userId forKey:@"sceneUserId"];
    [paramDic setObject:@0 forKey:@"sceneId"];
    RequestInfo *info = [HttpRequestManager deleteUGCContent:paramDic];
    info.delegate = self;
}

#pragma -mark DDTextBoxViewDelegate
- (void)sendMessageRequest:(NSString *)comment imageArr:(NSArray *)imageArr isReply:(BOOL)isreply {
    if (![comment isEqualToString:@""]) {
        [self sendComment:comment toSortId:_toSortId];
    }
}

- (void)sendUserZanRequest {
    NSLog(@"user main page zan");
}

#pragma -mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_textBoxView hideKeyBoard];
}

#pragma -mark NetWorkDelegate
- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    if (requestID == RequestID_GetUserMainPageInfo) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            _messageNum = [[dataDic objectForKey:@"messageNum"] integerValue];
            NSInteger IdType = [[dataDic objectForKey:@"IdType"] integerValue];
            NSArray *messArr = [dataDic objectForKey:@"messageData"];
            if (IdType == GetInfoTypeRefresh) {
                // 刷新
                [_messageListTV.mj_header endRefreshing];
                [_messagesArr removeAllObjects];
            } else {
                [_messageListTV.mj_footer endRefreshing];
            }
            for (NSDictionary *tmpDic in messArr) {
                UserMessageModel *tmpModel = [[UserMessageModel alloc] initWithAttributes:tmpDic];
                [_messagesArr addObject:tmpModel];
            }
            
            if ([messArr count] < kPageSizeCount) {
                [_messageListTV.mj_footer endRefreshingWithNoMoreData];
            } else {
                [_messageListTV.mj_footer resetNoMoreData];
            }
            [_messageListTV reloadData];
            
            if (_isShowKeyBoard) {
                [_textBoxView displayKeyBoard];
                _isShowKeyBoard = NO;
                if (_placeHodlerStr && ![_placeHodlerStr isEqualToString:@""]) {
                    _textBoxView.textView.placeholder = _placeHodlerStr;
                }
            }
            
        } else {
            [_messageListTV.mj_footer endRefreshingWithNoMoreData];
            [_messageListTV.mj_header endRefreshing];
        }
        
    } else if (RequestID_SendComment == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            _messageNum = [[dataDic objectForKey:@"messageNum"] integerValue];
            NSArray *messArr = [dataDic objectForKey:@"contData"];
            if ([messArr count] < kPageSizeCount) {
                NSLog(@"没有更多评论数据了");
                [_messageListTV.mj_footer endRefreshingWithNoMoreData];
            } else {
                [_messageListTV.mj_footer resetNoMoreData];
            }
            
            if ([messArr count] > 0) {
                [_messagesArr removeAllObjects];
            }
            
            for (int i = 0; i < [messArr count]; i++) {
                NSDictionary *tmpDic = [messArr objectAtIndex:i];
                [_messagesArr addObject:[[UserMessageModel alloc] initWithAttributes:tmpDic]];
            }
            
            if ([messArr count] > 0) {
                [_messageListTV reloadData];
            }
        }
    } else if (RequestID_DeleteUGCContent == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            NSInteger IdPart = [[dataDic objectForKey:@"IdPart"] integerValue];
            if (IdPart == UserLikeType_MainPage) {
                for (int i = 0; i < [_messagesArr count]; i++) {
                    UserMessageModel *tmpModel = [_messagesArr objectAtIndex:i];
                    if ([[dataDic objectForKey:@"itemId"] integerValue] == tmpModel.itemId) {
                        // 评论删除成功
                        [_messagesArr removeObjectAtIndex:i];
                        _messageNum = [[dataDic objectForKey:@"commentNum"] integerValue];
                        [_messageListTV reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                        return;
                    }
                }
            }
        }
    }
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {
    if (requestID == RequestID_GetUserMainPageInfo) {
        [_messageListTV.mj_footer endRefreshingWithNoMoreData];
        [_messageListTV.mj_header endRefreshing];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return [_messagesArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[_messagesArr objectAtIndex:indexPath.row] getUserMessageCellHeight];
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
    [tipLabel setText:[NSString stringWithFormat:@"  共%ld条留言", (long)self.messageNum]];
    [bgView addSubview:tipLabel];
    
    return bgView;
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
    [cell bindMessageCellWithDataModel:[_messagesArr objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    
    UserMessageModel *commentModel = _messagesArr[row];
    if ([commentModel.messageUserId isEqualToString:[QiuPaiUserModel getUserInstance].userId]) {
        [_textBoxView hideKeyBoard];
        MoreOpearationMenu *tmpView = [[MoreOpearationMenu alloc] initWithTitles:@[@"删除"] itemTags:@[@100]];
        [tmpView showActionSheetWithClickBlock:^(NSInteger tag){
            if (tag == 100) {
                // 删除评论
                [self deleteUgcContent:commentModel.itemId userId:_pageUserId];
            }
        } cancelBlock:nil];
    } else {
        _toSortId = [commentModel sortId];
        NSString *nickName = [commentModel messageName];
        [_textBoxView displayKeyBoard];
        _textBoxView.textView.placeholder = [NSString stringWithFormat:@"回复 %@:", nickName];
    }   
}

@end
