//
//  SpecialTopicViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/11/6.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "SpecialTopicViewController.h"
#import "SpecialTopicCommentViewController.h"
#import "GoodsDetailAndEvaViewController.h"
#import "UIImageView+WebCache.h"
#import "CustomImageButton.h"

#import "STDetailModel.h"
#import "STCommentModel.h"

@interface SpecialTopicViewController () <UIWebViewDelegate, NetWorkDelegate, WXApiManagerDelegate> {
    UIWebView *_productWebView;
    UIView *_footerToolBar;
    
    STDetailModel *_stDetailModel;
    NSMutableArray *_stCommentsArr;
    
    ShareScene _shareScene;
}
@end

@implementation SpecialTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _stCommentsArr = [[NSMutableArray alloc] init];

    [WXApiManager sharedManager].delegate = self;
    [self showMoreOperationBtn];
    [self initProductWebView];
    [self initFooterToolBarView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha = 1.0;
    [self.navigationController setNavigationBarHidden:NO];
    [self getSpecialTopicDetail];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.alpha = 1.0;
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)dealloc {
    [WXApiManager sharedManager].delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:IdentifierSpecialTopicComment]) {
        SpecialTopicCommentViewController *vc = [[SpecialTopicCommentViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.commentNum = _stDetailModel.commentNum;
        vc.commentsArr = _stCommentsArr;
        vc.topicId = self.topicId;
        vc.isLike = (_stDetailModel.isPraised == PraisedState_YES);
        if (self.turnToCommentVC) {
            vc.isShowKeyBoard = YES;
            vc.placeHodlerStr = self.commentPlaceHolderStr;
        }
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:IdentifierGoodsDetailAndEva]) {
        GoodsDetailAndEvaViewController *vc = [[GoodsDetailAndEvaViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.goodsId = [sender integerValue];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)moreOpClick:(UIButton *)sender {
    NSArray *titles = @[@"收藏"];
    if (_stDetailModel.isLike == LikeState_YES) {
        titles = @[@"取消收藏"];
    }
    __weak __typeof(self)weakSelf = self;
    [Helper showMoreOpMenu:^(NSInteger tag){
        NSLog(@"tag is %ld", (long)tag);
        [weakSelf moreOpMenuItemClick:tag];
    } cancelHandler:nil titles:titles tags:@[@100]];
}

- (void)moreOpMenuItemClick:(NSInteger)tag {
    switch (tag) {
        case 100:
        {
            [self sendUserCollectRequest];
        }
            break;
        case 200:
        {
            [self reportUgcContent];
        }
            break;
        default:
            break;
    }
}


- (void)zanBtnClick:(UIButton *)sender {
    [sender setSelected:![sender isSelected]];
    if ([sender isSelected]) {
        _stDetailModel.praiseNum++;
    } else {
        _stDetailModel.praiseNum--;
    }
//    [self updateFooterToolBar];
    [self sendUserZanRequest];
}

- (void)shareBtnClick:(NSInteger)btnIndex {
    _shareScene = btnIndex;
    switch (btnIndex) {
        case 0:
        {
            UIImageView *tmpImageView = [[UIImageView alloc] init];
            [tmpImageView sd_setImageWithURL:[NSURL URLWithString:_stDetailModel.thumbPic] placeholderImage:[UIImage imageNamed:@"placeholder_theme.jpg"]];
            [WXApiRequestHandler sendLinkURL:_pageHtmlUrl TagName:kLinkTagName Title:_stDetailModel.title Description:_stDetailModel.content ThumbImage:tmpImageView.image InScene:WXSceneSession];
        }
            break;
        case 1:
        {
            UIImageView *tmpImageView = [[UIImageView alloc] init];
            [tmpImageView sd_setImageWithURL:[NSURL URLWithString:_stDetailModel.thumbPic] placeholderImage:[UIImage imageNamed:@"placeholder_theme.jpg"]];
            [WXApiRequestHandler sendLinkURL:_pageHtmlUrl
                                     TagName:kLinkTagName
                                       Title:_stDetailModel.title
                                 Description:_stDetailModel.content
                                  ThumbImage:tmpImageView.image
                                     InScene:WXSceneTimeline];
        }
            
            break;
        case 2:
        {
            __weak typeof(self) _weakSelf = self;
            [QQHelper sendNewsMessageWithNetworkImage:_stDetailModel.thumbPic pageUrl:_pageHtmlUrl title:_stDetailModel.title description:_stDetailModel.content scene:QQShareScene_Session callBack:^(QQApiSendResultCode sendResult){
                [_weakSelf sendUserShare:UserLikeType_SpecialTopic itemId:_topicId];
            }];
        }
            break;
        case 3:
        {
            __weak typeof(self) _weakSelf = self;
            [QQHelper sendNewsMessageWithNetworkImage:_stDetailModel.thumbPic pageUrl:_pageHtmlUrl title:_stDetailModel.title description:_stDetailModel.content scene:QQShareScene_QZone callBack:^(QQApiSendResultCode sendResult){
                [_weakSelf sendUserShare:UserLikeType_SpecialTopic itemId:_topicId];
            }];
            
        }
            break;
        default:
            break;
    }
}

- (void)shareButtonClick:(UIButton *)sender {
    [Helper showShareSheetView:^(NSInteger btnIndex){
        [self shareBtnClick:btnIndex];
    } showQZone:YES cancelHandler:nil];
}

- (void)commentButtonClick:(UIButton *)sender {
    [self performSegueWithIdentifier:IdentifierSpecialTopicComment sender:nil];
}

- (void)initProductWebView {
    _productWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight - 49)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_pageHtmlUrl]];
    _productWebView.delegate = self;
    [self.view addSubview:_productWebView];
    [_productWebView loadRequest:request];
}

- (void)initFooterToolBarView {
    CGFloat btnW = kFrameWidth/3;
    CGFloat btnH = 49.0f;
    CustomImageButton * (^createButton)(NSString *norImage, NSString *selImage, NSInteger tag, NSString *title, UIColor *textColor, NSString *tipText);
    createButton = ^(NSString *norImage, NSString *selImage, NSInteger tag, NSString *title, UIColor *textColor, NSString *tipText) {
        CustomImageButton *tmpButton = [[CustomImageButton alloc] initWithFrame:CGRectMake(btnW, 0, btnW, btnH) norImage:norImage selImage:selImage imageEdgeInsets:UIEdgeInsetsMake(11, btnW/2-6-27, 11, btnW/2+6) title:title tip:tipText];
        [tmpButton setTag:tag];
        [tmpButton setTipColor:textColor];
        [tmpButton setTipFont:11.0f];
        [tmpButton setTitleLabelColor:textColor];
        [tmpButton setTitleLFont:13.0f];
        return tmpButton;
    };
    _footerToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kFrameHeight - 49, kFrameWidth, 49)];
    CustomImageButton *commentBtn = createButton(@"comment_btn.png", @"comment_btn.png", 101, @"", Gray153Color, @"评论");
    [commentBtn setFrame:CGRectMake(0, 0, btnW, btnH)];
    [commentBtn addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footerToolBar addSubview:commentBtn];
    
    CustomImageButton *likeBtn = createButton(@"like_button_green_nor.png", @"like_button_green_sel.png", 102, @"", Gray153Color, @"赞");
    [likeBtn setFrame:CGRectMake(btnW, 0, btnW, btnH)];
    [likeBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footerToolBar addSubview:likeBtn];
    
    CustomImageButton *shareBtn = createButton(@"share_indicator_btn.png", @"share_indicator_btn.png", 103, @"", Gray153Color, @"分享");
    [shareBtn setFrame:CGRectMake(btnW*2, 0, btnW, btnH)];
    [shareBtn addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footerToolBar addSubview:shareBtn];
    
    UIView *linView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 0.5)];
    [linView setBackgroundColor:LineViewColor];
    [_footerToolBar addSubview:linView];
    
    for (int i = 0; i < 3; i++) {
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(i*kFrameWidth/3, 0, 0.5, 49)];
        [verticalLine setBackgroundColor:LineViewColor];
        [_footerToolBar addSubview:verticalLine];
    }
    
    [self.view addSubview:_footerToolBar];
}

- (void)updateFooterToolBar {
    CustomImageButton *commentBtn = [_footerToolBar viewWithTag:101];
    [commentBtn setTitle:[NSString stringWithFormat:@"%ld", (long)_stDetailModel.commentNum]];
    
    CustomImageButton *likeBtn = [_footerToolBar viewWithTag:102];
    [likeBtn setTitle:[NSString stringWithFormat:@"%ld", (long)_stDetailModel.praiseNum]];
    [likeBtn setSelected:(_stDetailModel.isPraised == PraisedState_YES) ? YES : NO];
    
    CustomImageButton *shareBtn = [_footerToolBar viewWithTag:103];
    [shareBtn setTitle:[NSString stringWithFormat:@"%ld", (long)_stDetailModel.shareNum]];
}

- (void)getSpecialTopicDetail {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:self.topicId] forKey:@"themeId"];
    [paramDic setObject:[NSNumber numberWithInteger:UserLikeType_SpecialTopic] forKey:@"IdPart"];
    [paramDic setObject:[NSNumber numberWithInteger:GetInfoTypeRefresh] forKey:@"IdType"];
    [paramDic setObject:[NSNumber numberWithInteger:0] forKey:@"lastId"];
    RequestInfo *info = [HttpRequestManager getSpecialTopicDetailInfo:paramDic];
    info.delegate = self;
}

- (void)sendUserZanRequest {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:_stDetailModel.themeId] forKey:@"itemId"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"IdPart"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserZanRequest:paramDic];
    info.delegate = self;
}

- (void)sendUserCollectRequest {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:_stDetailModel.themeId] forKey:@"itemId"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"IdPart"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserCollectRequest:paramDic];
    info.delegate = self;
}

- (void)sendUserShare:(NSInteger)type itemId:(NSInteger)itemId {
    [Helper uploadShareEventDataToUmeng:_shareScene content:@"专题" name:_stDetailModel.title cId:_topicId];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:itemId] forKey:@"itemId"];
    [paramDic setObject:[NSNumber numberWithInteger:type] forKey:@"IdPart"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserShareRequest:paramDic];
    info.delegate = self;
}

- (void)reportUgcContent {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:_stDetailModel.themeId] forKey:@"itemId"];
    [paramDic setObject:[NSNumber numberWithInteger:UserLikeType_SpecialTopic] forKey:@"IdPart"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    
    [paramDic setObject:@0 forKey:@"opType"];
    [paramDic setObject:@"" forKey:@"sceneUserId"];
    [paramDic setObject:@0 forKey:@"sceneId"];
    RequestInfo *info = [HttpRequestManager reportUGCContent:paramDic];
    info.delegate = self;
}

#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", response.errCode];
    if (response.errCode == 0) {
        NSLog(@"分享成功 %@", strMsg);
        [self sendUserShare:UserLikeType_SpecialTopic itemId:_topicId];
    } else {
        NSLog(@"分享失败 %@", strMsg);
    }
}

#pragma -mark NetWorkDelegate
- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    if (requestID == RequestID_GetSpecialTopicDetail) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            _stDetailModel = [[STDetailModel alloc] initWithAttributes:dataDic];
            NSArray *commentArr = [dataDic objectForKey:@"commentData"];
            [_stCommentsArr removeAllObjects];
            for (int i = 0; i < [commentArr count]; i ++) {
                NSDictionary *tmpDic = [commentArr objectAtIndex:i];
                STCommentModel *tmpModel = [[STCommentModel alloc] initWithAttributes:tmpDic];
                [_stCommentsArr addObject:tmpModel];
            }
            self.title = _stDetailModel.title;
            [self updateFooterToolBar];
            if (self.turnToCommentVC) {
                // 需要直接跳转到评论列表
                [self performSegueWithIdentifier:IdentifierSpecialTopicComment sender:nil];
                self.turnToCommentVC = NO;
            }
        }
    } else if (requestID == RequestID_SendUserCollect) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            if ([[dataDic objectForKey:@"itemId"] integerValue] == _stDetailModel.themeId) {
                _stDetailModel.isLike = [[dataDic objectForKey:@"isLiked"] integerValue];
                _stDetailModel.likeNum = [[dataDic objectForKey:@"likeNum"] integerValue];
//                [self updateFooterToolBar];
                NSString *tipStr = _stDetailModel.isLike == LikeState_YES ? @"收藏成功":@"已取消收藏";
                [self loadingTipView:tipStr callBack:nil];
            }
        }
    } else if (requestID == RequestID_SendUserZan) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            if ([[dataDic objectForKey:@"itemId"] integerValue] == _stDetailModel.themeId) {
                _stDetailModel.isPraised = [[dataDic objectForKey:@"isPraised"] integerValue];
                _stDetailModel.praiseNum = [[dataDic objectForKey:@"praiseNum"] integerValue];
                [self updateFooterToolBar];
            }
        }
    } else if (RequestID_SendUserShare == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSLog(@"分享成功");
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            if ([[dataDic objectForKey:@"itemId"] integerValue] == _topicId) {
                _stDetailModel.shareNum = [[dataDic objectForKey:@"shareNum"] integerValue];
                [self updateFooterToolBar];
            }
        }
    } else if (requestID == RequestID_ReportUGCContent) {
        
    }
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {
    [self.badNetTipV show];
}

#pragma -mark UIWebViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *path=[[request URL] absoluteString];
    NSLog(@"path is %@",path);
    NSString *_goodsIdStr = [Helper jiexi:@"goodsId" webaddress:path];
    if (![_goodsIdStr isEqualToString:@""]) {
        [self performSegueWithIdentifier:IdentifierGoodsDetailAndEva sender:[NSNumber numberWithInteger:[_goodsIdStr integerValue] ]];
    }
    return YES;
}

@end
