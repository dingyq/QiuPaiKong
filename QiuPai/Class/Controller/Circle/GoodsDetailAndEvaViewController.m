//
//  GoodsDetailAndEvaViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/11/30.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "GoodsDetailAndEvaViewController.h"
#import "GoodsDetailAndEvaluModel.h"
#import "CircleInfoModel.h"
#import "CircleTVCell.h"
#import "UIImageView+WebCache.h"
#import "EvaluationDetailViewController.h"
#import "EditCircleInfoViewController.h"
#import "GoodsBuyViewController.h"
#import "CompleteInfomationViewController.h"
#import "KnockUpResultViewController.h"
#import "HomePageViewController.h"
#import "CircleInfoDB.h"

#define NAME_FONT_SIZE 14.0f

@interface GoodsDetailAndEvaViewController () <CompleteInfomationSuccessDelegate, UITableViewDataSource, UITableViewDelegate, NetWorkDelegate, TableViewCellInteractionDelegate, UIAlertViewDelegate, WXApiManagerDelegate, VCInteractionDelegate> {
    UITableView *_infoDetailTV;
    UIView *_briefHeadView;
    UIView *_footerBarView;
    GoodsDetailAndEvaluModel *_goodsEvaluModel;
    NSMutableArray *_evaluContDataArr;
    UIView *_racketParaView;
    BOOL _isCommentBtnClick;
    KnockUpResultModel *_knockUpResult;
    ShareScene _shareScene;
    NSMutableSet *_uncloseHeader;
}

@property (nonatomic, assign) NSInteger latestSortId;
@property (nonatomic, assign) NSInteger oldestSortId;

@end


@implementation GoodsDetailAndEvaViewController

- (NSInteger)latestSortId {
    if (_evaluContDataArr.count > 0) {
        _latestSortId = [[_evaluContDataArr firstObject] sortId];
    } else {
        _latestSortId = 0;
    }
    return _latestSortId;
}

- (NSInteger)oldestSortId {
    if (_evaluContDataArr.count > 0) {
        _oldestSortId = [[_evaluContDataArr lastObject] sortId];
    } else {
        _oldestSortId = 0;
    }
    return _oldestSortId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.title = @"装备详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _isCommentBtnClick = NO;
    _evaluContDataArr = [[NSMutableArray alloc] init];
    _uncloseHeader = [[NSMutableSet alloc] init];

    [WXApiManager sharedManager].delegate = self;
    [self initBriefIntroductionHeadView];
    [self createRacketParameterTipView];
    [self initDataTableView];
    [self initFooterBarView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sendGetGoodsDetailAndEvaluationRequest:GetInfoTypeRefresh sortId:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_isBackFromCompleteInfomation) {
        [self performSegueWithIdentifier:IdentifierKnockUpResult sender:_knockUpResult];
        _isBackFromCompleteInfomation = NO;
    }
}

- (void)dealloc {
    [WXApiManager sharedManager].delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
        evaluationVC.isShowTag = NO;
        [self.navigationController pushViewController:evaluationVC animated:YES];
    } else if ([identifier isEqualToString:IdentifierWriteEvaluation]) {
        EditCircleInfoViewController *vc = [[EditCircleInfoViewController alloc] init];
        vc.goodsSRModel = [self generateSerchResultToEditVC];
        vc.goodsSRModel.type = _goodsEvaluModel.type;
        vc.myDelegate = self;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:IdentifierGotoBuyGoods]) {
        // 去购买
        GoodsBuyViewController *vc = [[GoodsBuyViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = _goodsEvaluModel.name;
        vc.pageHtmlUrl = [_goodsEvaluModel.sellUrl objectAtIndex:0];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:IdentifierCompleteInfomation]) {
        CompleteInfomationViewController *vc = [[CompleteInfomationViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.isModify = NO;
        vc.goodsId = self.goodsId;
        vc.resultDelegate = self;
        [vc.navigationController setNavigationBarHidden:NO animated:NO];
        DDNavigationController* nav = [[DDNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    } else if ([identifier isEqualToString:IdentifierKnockUpResult]) {
        KnockUpResultModel *dataModel = (KnockUpResultModel *)sender;
        KnockUpResultViewController *vc = [[KnockUpResultViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.dataInfoModel = dataModel;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([identifier isEqualToString:IdentifierUserMainPage]) {
        CircleInfoModel *tmpModel = (CircleInfoModel *)sender;
        HomePageViewController *vc = [[HomePageViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        vc.isMyHomePage = [tmpModel.evaluateUserId isEqualToString:[QiuPaiUserModel getUserInstance].userId];
        vc.turnToCommentVC = NO;
        vc.pageUserId = tmpModel.evaluateUserId;
    }
}

- (RacketSearchModel *)generateSerchResultToEditVC {
    RacketSearchModel *srModel = [[RacketSearchModel alloc] init];
    srModel.balance = _goodsEvaluModel.balance;
    srModel.brand = _goodsEvaluModel.brand;
    srModel.desc = _goodsEvaluModel.desc;
    srModel.evaluateNum = _goodsEvaluModel.evaluateNum;
    srModel.headSize = _goodsEvaluModel.headSize;
    srModel.isLike = _goodsEvaluModel.isLike;
    srModel.likeNum = _goodsEvaluModel.likeNum;
    srModel.name = _goodsEvaluModel.name;
    srModel.picUrl = _goodsEvaluModel.picUrl;
    srModel.thumbPicUrl = _goodsEvaluModel.thumbPicUrl;
    srModel.type = _goodsEvaluModel.type;
    srModel.weight = _goodsEvaluModel.weight;
    return srModel;
}

- (void)sendGetGoodsDetailAndEvaluationRequest:(NSInteger)getInfoType sortId:(NSInteger)latestId {
    if (GetInfoTypeRefresh == getInfoType) {
        [self.netIndicatorView show];
    }
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:self.goodsId] forKey:@"goodsId"];
    [paramDic setObject:[NSNumber numberWithInteger:getInfoType] forKey:@"IdType"];
    [paramDic setObject:[NSNumber numberWithInteger:latestId] forKey:@"lastId"];
    RequestInfo *info = [HttpRequestManager getGoodsDetailAndEvaluationList:paramDic];
    info.delegate = self;
}

- (void)initDataTableView {
    _infoDetailTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+80, kFrameWidth, kFrameHeight-64-80-49) style:UITableViewStylePlain];
    [_infoDetailTV setDelegate:self];
    [_infoDetailTV setDataSource:self];
    [_infoDetailTV setBackgroundColor:[UIColor clearColor]];
    [_infoDetailTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_infoDetailTV];
    
    UIView *footerView = [[UIView alloc] init];
    _infoDetailTV.tableFooterView = footerView;
    [footerView setBackgroundColor:[UIColor clearColor]];
    
    [self addRefreshView:_infoDetailTV];
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
            [QQHelper shareImageMsg:_goodsEvaluModel.name description:_goodsEvaluModel.desc scene:QQShareScene_Session callBack:^(QQApiSendResultCode sendResult){
                [_weakSelf sendUserShare:UserLikeType_Goods itemId:self.goodsId];
            }];
        }
            break;
        case 3:
        {
            __weak typeof(self) _weakSelf = self;
            [QQHelper shareImageMsg:_goodsEvaluModel.name description:_goodsEvaluModel.desc scene:QQShareScene_QZone callBack:^(QQApiSendResultCode sendResult){
                [_weakSelf sendUserShare:UserLikeType_Goods itemId:self.goodsId];
            }];
        }
            break;
        default:
            break;
    }
}


- (void)footerBarViewBtnsClick:(UIButton *)sender {
    switch (sender.tag) {
        case 101:
        {
            // 喜欢商品
            NSString *senderTitle = @"";
            if ([sender isSelected]) {
                [sender setSelected:NO];
                senderTitle = [NSString stringWithFormat:@"%ld", (long)_goodsEvaluModel.likeNum-1];
            } else {
                [sender setSelected:YES];
                senderTitle = [NSString stringWithFormat:@"%ld", (long)_goodsEvaluModel.likeNum+1];
            }
            [sender setTitle:senderTitle forState:UIControlStateNormal];
            [sender setTitle:senderTitle forState:UIControlStateSelected];
            
            [self sendUserCollectRequest:UserLikeType_Goods itemId:_goodsEvaluModel.goodsId];
            break;
        }
        case 102:
        {
            [Helper generateGoodsTemplateImage:_goodsEvaluModel.name racketImageUrl:_goodsEvaluModel.thumbPicUrl];
            [Helper showShareSheetView:^(NSInteger btnIndex){
                [self shareBtnClick:btnIndex];
            } showQZone:NO cancelHandler:nil];
        }
            break;
        case 103:
            // 写评测
            [self performSegueWithIdentifier:IdentifierWriteEvaluation sender:nil];
            break;
        case 104:
            // 虚拟试打
        {
            if (_goodsEvaluModel.type == GoodsType_Racket) {
                [self sendKnockUpDirectly];
            } else {
                DDAlertView *alertView = [[DDAlertView alloc] initWithTitle:@"只有球拍才可以试打" itemTitles:@[@"确定"] itemTags:@[@100]];
                [alertView showWithClickBlock:^(NSInteger btnIndex) {
                    
                }];
            }
        }
            break;
        default:
            break;
    }
}

- (void)initFooterBarView {
    UIButton * (^createButton)(NSString *norImage, NSString *selImage, NSInteger tag, NSString *title, UIColor *textColor, NSString *tipText);
    createButton = ^(NSString *norImage, NSString *selImage, NSInteger tag, NSString *title, UIColor *textColor, NSString *tipText) {
        UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tmpButton setTitle:title forState:UIControlStateNormal];
        [tmpButton setTitle:title forState:UIControlStateSelected];
        [tmpButton setImage:[UIImage imageNamed:norImage] forState:UIControlStateNormal];
        [tmpButton setImage:[UIImage imageNamed:selImage] forState:UIControlStateHighlighted];
        [tmpButton setImage:[UIImage imageNamed:selImage] forState:UIControlStateSelected];
        [tmpButton setImage:[UIImage imageNamed:selImage] forState:UIControlStateDisabled];
        [tmpButton setTitleColor:textColor forState:UIControlStateNormal];
        [tmpButton setTitleColor:textColor forState:UIControlStateSelected];
        CGFloat gap = (kFrameWidth/8 - 27)/2;
        tmpButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [tmpButton setTag:tag];
        tmpButton.imageEdgeInsets = UIEdgeInsetsMake(11, gap, 11, kFrameWidth/8+gap);
        tmpButton.titleEdgeInsets = UIEdgeInsetsMake(8, 0, 24.5, 0);

        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(kFrameWidth/8 + 2, 27, kFrameWidth/8 - 2, 14)];
        [tipLabel setTextColor:textColor];
        [tipLabel setTextAlignment:NSTextAlignmentLeft];
        [tipLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [tipLabel setText:tipText];
        [tmpButton addSubview:tipLabel];
        
        return tmpButton;
    };
    
    _footerBarView = [[UIView alloc] initWithFrame:CGRectMake(0, kFrameHeight - 49, kFrameWidth, 49)];
    [_footerBarView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *likeBtn = createButton(@"like_button_green_nor.png", @"like_button_green_sel.png", 101, @"", Gray153Color, @"收藏");
    [likeBtn setFrame:CGRectMake(0, 0, kFrameWidth/4, 49)];
    [likeBtn addTarget:self action:@selector(footerBarViewBtnsClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footerBarView addSubview:likeBtn];
    
    UIButton *shareBtn = createButton(@"share_indicator_btn.png", @"share_indicator_btn.png", 102, @"", Gray153Color, @"分享");
    [shareBtn setFrame:CGRectMake(kFrameWidth/4, 0, kFrameWidth/4, 49)];
    [_footerBarView addSubview:shareBtn];
    [shareBtn addTarget:self action:@selector(footerBarViewBtnsClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *writeEvaluBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [writeEvaluBtn setBackgroundColor:mUIColorWithRGB(103, 215, 173)];
    [writeEvaluBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [writeEvaluBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    writeEvaluBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [writeEvaluBtn setTitle:@"写评测" forState:UIControlStateNormal];
    [writeEvaluBtn setTitle:@"写评测" forState:UIControlStateSelected];
    [writeEvaluBtn setTag:103];
    [writeEvaluBtn setFrame:CGRectMake(kFrameWidth/2, 0, kFrameWidth/4, 49)];
    [writeEvaluBtn addTarget:self action:@selector(footerBarViewBtnsClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footerBarView addSubview:writeEvaluBtn];
    
    UIButton *tryBeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tryBeatBtn setBackgroundColor:mUIColorWithRGB(2, 189, 119)];
    [tryBeatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tryBeatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    tryBeatBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [tryBeatBtn setTitle:@"虚拟试打" forState:UIControlStateNormal];
    [tryBeatBtn setTitle:@"虚拟试打" forState:UIControlStateSelected];
    [tryBeatBtn setTag:104];
    [tryBeatBtn setFrame:CGRectMake(kFrameWidth*3/4, 0, kFrameWidth/4, 49)];
    [tryBeatBtn addTarget:self action:@selector(footerBarViewBtnsClick:) forControlEvents:UIControlEventTouchUpInside];
    [tryBeatBtn setEnabled:NO];
    [_footerBarView addSubview:tryBeatBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 0.5)];
    [lineView setBackgroundColor:LineViewColor];
    [_footerBarView addSubview:lineView];
    
    for (int i = 0; i < 3; i++) {
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(i*kFrameWidth/4, 0, 0.5, 49)];
        [verticalLine setBackgroundColor:LineViewColor];
        [_footerBarView addSubview:verticalLine];
    }
    
    [self.view addSubview:_footerBarView];
}

- (void)updateFooterBarView {
    UIButton *likeBtn = [_footerBarView viewWithTag:101];
    [likeBtn setTitle:[NSString stringWithFormat:@"%ld", (long)_goodsEvaluModel.likeNum] forState:UIControlStateNormal];
    [likeBtn setTitle:[NSString stringWithFormat:@"%ld", (long)_goodsEvaluModel.likeNum] forState:UIControlStateSelected];
    [likeBtn setSelected:(_goodsEvaluModel.isLike == LikeState_YES ? YES : NO)];
    
    UIButton *shareBtn = [_footerBarView viewWithTag:102];
    [shareBtn setTitle:[NSString stringWithFormat:@"%ld", (long)_goodsEvaluModel.shareNum] forState:UIControlStateNormal];
    [shareBtn setTitle:[NSString stringWithFormat:@"%ld", (long)_goodsEvaluModel.shareNum] forState:UIControlStateSelected];
    
    UIButton *tryBeatBtn = [_footerBarView viewWithTag:104];
    [tryBeatBtn setEnabled:YES];
    if (_goodsEvaluModel.type != GoodsType_Racket) {
        [tryBeatBtn setBackgroundColor:Gray202Color];
    }
}

- (void)initBriefIntroductionHeadView {
    _briefHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kFrameWidth, 80)];
    [_briefHeadView setBackgroundColor:[UIColor whiteColor]];
//    [_briefHeadView setBackgroundColor:CustomGreenColor];
    
    UIImageView *goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    [goodsImageView setTag:104];
    [_briefHeadView addSubview:goodsImageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(91, 8, kFrameWidth - 101, 20)];
    [nameLabel setTextColor:Gray17Color];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setFont:[UIFont systemFontOfSize:NAME_FONT_SIZE]];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel setTag:101];
    [_briefHeadView addSubview:nameLabel];
    
    UILabel *brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(91, nameLabel.frame.size.height + nameLabel.frame.origin.y + 2, kFrameWidth - 150, 20)];
    [brandLabel setTextColor:Gray51Color];
    [brandLabel setBackgroundColor:[UIColor clearColor]];
    [brandLabel setFont:[UIFont systemFontOfSize:NAME_FONT_SIZE]];
    [brandLabel setTextAlignment:NSTextAlignmentLeft];
    [brandLabel setTag:102];
    [_briefHeadView addSubview:brandLabel];
    
    UILabel *evaluationNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(91, brandLabel.frame.size.height + brandLabel.frame.origin.y + 2, kFrameWidth - 150, 20)];
    [evaluationNumLabel setTextColor:mUIColorWithRGB(73, 119, 146)];
    [evaluationNumLabel setBackgroundColor:[UIColor clearColor]];
    [evaluationNumLabel setFont:[UIFont systemFontOfSize:15.0]];
    [evaluationNumLabel setTextAlignment:NSTextAlignmentLeft];
    [evaluationNumLabel setTag:103];
    [_briefHeadView addSubview:evaluationNumLabel];
    
    UIButton *gotoBuyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [gotoBuyBtn setFrame:CGRectMake(kFrameWidth - 62 - 10, 49, 62, 23)];
    [gotoBuyBtn setTitle:@"去购买" forState:UIControlStateNormal];
    [gotoBuyBtn setTitle:@"去购买" forState:UIControlStateSelected];
    gotoBuyBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [gotoBuyBtn setTitleColor:CustomGreenColor forState:UIControlStateNormal];
    [gotoBuyBtn setTitleColor:CustomGreenColor forState:UIControlStateSelected];
    [gotoBuyBtn addTarget:self action:@selector(gotoBuyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    gotoBuyBtn.layer.borderWidth = 0.5f;
    gotoBuyBtn.layer.borderColor = CustomGreenColor.CGColor;
    gotoBuyBtn.layer.cornerRadius = 11.5f;
    [_briefHeadView addSubview:gotoBuyBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 79.5, kFrameWidth, 0.5)];
    [lineView setBackgroundColor:LineViewColor];
    [_briefHeadView addSubview:lineView];
    
    [self.view addSubview:_briefHeadView];
}

- (void)updateBriefHeadView {
    UIImageView *goodsImageView = [_briefHeadView viewWithTag:104];
    [goodsImageView sd_setImageWithURL:[NSURL URLWithString:_goodsEvaluModel.thumbPicUrl] placeholderImage:[UIImage imageNamed:@"placeholder_evaluation.jpg"]];
    
    UILabel *nameLabel = [_briefHeadView viewWithTag:101];
    [nameLabel setText:[NSString stringWithFormat:@"型号:%@", _goodsEvaluModel.name]];
    
    UILabel *brandLabel = [_briefHeadView viewWithTag:102];
    [brandLabel setText:[NSString stringWithFormat:@"品牌:%@", _goodsEvaluModel.brand]];
    
    UILabel *evaluNumLabel = [_briefHeadView viewWithTag:103];
    [evaluNumLabel setText:[NSString stringWithFormat:@"%ld条评测", (long)_goodsEvaluModel.evaluateNum]];
}

- (void)gotoBuyButtonClick:(UIButton *)sender {
    [Helper uploadGotoBuyPageDataToUmeng:_goodsEvaluModel.name goodsId:self.goodsId];
    [self performSegueWithIdentifier:IdentifierGotoBuyGoods sender:nil];
}


- (void)addRefreshView:(UITableView *)tableView {
    
    __weak __typeof(self)weakSelf = self;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf sendGetGoodsDetailAndEvaluationRequest:GetInfoTypeRefresh sortId:0];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf sendGetGoodsDetailAndEvaluationRequest:GetInfoTypePull sortId:weakSelf.oldestSortId];
    }];
}

- (void)createRacketParameterTipView {
    UILabel * (^createTipLabel)(NSInteger tag, NSString *text,UIColor *textColor);
    createTipLabel = ^(NSInteger tag, NSString *text, UIColor *textColor) {
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
        [tipLabel setTextColor:textColor];
        [tipLabel setTag:tag];
        [tipLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [tipLabel setText:text];
        return tipLabel;
    };
    
    CGFloat heightGap = 11.0f;
    _racketParaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 180)];
    [_racketParaView setBackgroundColor:[UIColor whiteColor]];
    for (int i = 0; i < 10; i++) {
        CGFloat xPosi = 23;
        if (i % 2 == 1) {
            xPosi = kFrameWidth*8/15;
        }
        UILabel *tipLabel = createTipLabel(100+i, @"", Gray153Color);
        [tipLabel setFrame:CGRectMake(xPosi, 20 + (20 + heightGap) * (i/2), 35, 20)];
        [tipLabel sizeToFit];
        [tipLabel setHidden:YES];
        [_racketParaView addSubview:tipLabel];
    }
    
    for (int i = 0; i < 10; i++) {
        UILabel *tipL = [_racketParaView viewWithTag:100+i];
        CGFloat xPosi = CGRectGetMaxX(tipL.frame);
        CGFloat yPosi = tipL.frame.origin.y;
        
        UILabel *tipLabel = createTipLabel(200+i, @"", Gray102Color);
        [tipLabel setFrame:CGRectMake(xPosi, yPosi, 35, 20)];
        [tipLabel sizeToFit];
        [tipLabel setHidden:YES];
        [_racketParaView addSubview:tipLabel];
    }
}

- (CGFloat)getRacketParaViewH:(GoodsType)type {
    switch (type) {
        case GoodsType_Racket:
            return 180.0f;
        case GoodsType_RacketLine:
            return 116.0f;
        default:
            return 180.0f;
    }
}

- (void)updateRacketParameterView {
    NSArray *tipStrArr = @[@"品牌:", @"参考价:", @"长度:", @"颜色:",
                           @"硬度:", @"拍面:", @"穿线重量:", @"穿线方式:", @"边框厚度:"];
//    @"市场价:",
    if (_goodsEvaluModel.type == GoodsType_RacketLine) {
        tipStrArr = @[@"生产商:", @"直径:", @"颜色:", @"材料:", @"结构:", @"特性:"];
    }
    [_racketParaView setFrame:CGRectMake(0, 0, kFrameWidth, [self getRacketParaViewH:_goodsEvaluModel.type])];
    
    GoodsType goodsType = _goodsEvaluModel.type;
    for (int i = 0; i < 10; i++) {
        UILabel *tipL = [_racketParaView viewWithTag:100+i];
        [tipL setText:i < tipStrArr.count?tipStrArr[i]:@""];
        [tipL sizeToFit];
        
        CGFloat xPosi = CGRectGetMaxX(tipL.frame);
        CGFloat yPosi = tipL.frame.origin.y;
        UILabel *tipL1 = [_racketParaView viewWithTag:200+i];
        [tipL1 setFrame:CGRectMake(xPosi, yPosi, 35, 20)];
        
        BOOL isHide = i < tipStrArr.count? NO:YES;
        [tipL setHidden:isHide];
        [tipL1 setHidden:isHide];
       
        NSString *tipStr = @"";
        switch (i) {
            case 0:
                tipStr = _goodsEvaluModel.brand;
                break;
            case 1:
            {
                tipStr = [NSString stringWithFormat:@"￥%ld", (long)_goodsEvaluModel.price];
                if (_goodsEvaluModel.price == 0) {
                    tipStr = @"￥-";
                }
            }
                break;
            case 2:
            {
                if (goodsType == GoodsType_Racket) {
                    tipStr = [NSString stringWithFormat:@"%.2f英寸", _goodsEvaluModel.length];
                } else if (goodsType == GoodsType_RacketLine) {
                    tipStr = [NSString stringWithFormat:@"%@", _goodsEvaluModel.color];
                }
            }
                break;
            case 3:
            {
                if (goodsType == GoodsType_Racket) {
                    tipStr = _goodsEvaluModel.color;
                } else if (goodsType == GoodsType_RacketLine) {
                    tipStr = [NSString stringWithFormat:@"%@", _goodsEvaluModel.material];
                }
            }
                break;
            case 4:
            {
                if (goodsType == GoodsType_Racket) {
                    tipStr = [NSString stringWithFormat:@"%ld", (long)_goodsEvaluModel.stiffness];
                } else if (goodsType == GoodsType_RacketLine) {
                    tipStr = [NSString stringWithFormat:@"%@", _goodsEvaluModel.structure];
                }
            }
                break;
            case 5:
            {
                if (goodsType == GoodsType_Racket) {
                    tipStr = [NSString stringWithFormat:@"%.0f平方英寸", _goodsEvaluModel.headSize];
                } else if (goodsType == GoodsType_RacketLine) {
                    tipStr = [NSString stringWithFormat:@"%0.2fmm", _goodsEvaluModel.dia];
                }
            }
                break;
            case 6:
            {
                tipStr = [NSString stringWithFormat:@"%.2fg", _goodsEvaluModel.weight];
            }
                break;
            case 7:
            {
                tipStr = _goodsEvaluModel.stringPattern;
            }
                break;
            case 8:
//                tipStr = [NSString stringWithFormat:@"￥%ld", (long)_goodsEvaluModel.oriPrice];
//                break;
            case 9:
            {
                
                if (goodsType == GoodsType_Racket) {
                    tipStr = [NSString stringWithFormat:@"%.1f/%.1f/%.1f mm", _goodsEvaluModel.beamwidthA, _goodsEvaluModel.beamwidthB, _goodsEvaluModel.beamwidthC];
                } else if (goodsType == GoodsType_RacketLine) {
                    tipStr = [NSString stringWithFormat:@"%@", _goodsEvaluModel.character];
                }
            }
                break;
            default:
                break;
        }
        [tipL1 setText:tipStr];
        [tipL1 sizeToFit];
    }
}

- (void)sendKnockUpDirectly {
    // 统计虚拟试打行为
    [Helper uploadRacketKonckUpDataToUment:_goodsEvaluModel.type goodsName:_goodsEvaluModel.name goodsId:_goodsEvaluModel.goodsId];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:self.goodsId] forKey:@"racId"];
    RequestInfo *info = [HttpRequestManager knockUpDirectly:paramDic];
    info.delegate = self;
}

- (void)sendUserShare:(NSInteger)type itemId:(NSInteger)itemId {
    [Helper uploadShareEventDataToUmeng:_shareScene content:@"商品详情" name:_goodsEvaluModel.name cId:itemId];
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:itemId] forKey:@"itemId"];
    [paramDic setObject:[NSNumber numberWithInteger:type] forKey:@"IdPart"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserShareRequest:paramDic];
    info.delegate = self;
}

- (void)sendUserCollectReq:(NSInteger)type itemId:(NSInteger)itemId {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:itemId] forKey:@"itemId"];
    [paramDic setObject:[NSNumber numberWithInteger:type] forKey:@"IdPart"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserCollectRequest:paramDic];
    info.delegate = self;
}

#pragma -mark VCInteractionDelegate
- (void)publishNewEvaluationSuccess:(NSDictionary *)dataDic {
    // 刷新
    CircleInfoModel *tmpModel = [[CircleInfoModel alloc] initWithAttributes:dataDic];
    if (_evaluContDataArr.count > 0) {
        [_evaluContDataArr insertObject:tmpModel atIndex:0];
    } else {
        [_evaluContDataArr addObject:tmpModel];
    }
    NSIndexPath *te=[NSIndexPath indexPathForRow:0 inSection:1];
    [_infoDetailTV insertRowsAtIndexPaths:[NSArray arrayWithObjects:te, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    [[CircleInfoDB getInstance] insertDataToTable:dataDic];
}

- (void)deleteMainEvaluation:(NSInteger)evaluId {
    NSMutableArray *arrAlias = _evaluContDataArr;
    for (int i = 0; i < [arrAlias count]; i ++) {
        CircleInfoModel *infoModel = [arrAlias objectAtIndex:i];
        if (infoModel.itemId == evaluId) {
            [arrAlias removeObjectAtIndex:i];
            NSIndexPath *te=[NSIndexPath indexPathForRow:i inSection:1];
            [_infoDetailTV deleteRowsAtIndexPaths:[NSArray arrayWithObjects:te, nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

#pragma mark - CompleteInfomationSuccessDelegate
- (void)completeInfomaitonSuccessWithData:(NSDictionary *)dataDic {
    _knockUpResult = [[KnockUpResultModel alloc] initWithAttributes:dataDic];
    self.isBackFromCompleteInfomation = YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 完善资料
        [self performSegueWithIdentifier:IdentifierCompleteInfomation sender:nil];
    }
}

#pragma mark TableViewCellInteractionDelegate
- (void)headImageClick:(id)sender {
//    [self performSegueWithIdentifier:IdentifierUserMainPage sender:sender];
}

- (void)sendUserCollectRequest:(NSInteger)type itemId:(NSInteger)itemId {
    [self sendUserCollectReq:type itemId:itemId];
}

- (void)sendUserZanRequest:(NSInteger)type itemId:(NSInteger)itemId {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:itemId] forKey:@"itemId"];
    [paramDic setObject:[NSNumber numberWithInteger:type] forKey:@"IdPart"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserZanRequest:paramDic];
    info.delegate = self;
}

- (void)sendUserAttentionRequest:(NSString *)evaluUserId {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:evaluUserId forKey:@"concernedId"];
    [paramDic setObject:[NSNumber numberWithInteger:1] forKey:@"getBackData"];
    RequestInfo *info = [HttpRequestManager sendUserAttentionRequest:paramDic];
    info.delegate = self;
}

- (void)getTagGoodsRequest:(NSInteger)goodsId {

}

- (void)commentButtonClick:(id)sender {
    CircleInfoModel *infoModel = (CircleInfoModel *)sender;
    if (infoModel.type == InfoType_Evaluation) {
        _isCommentBtnClick = YES;
        [self performSegueWithIdentifier:IdentifierEvaluationDetail sender:infoModel];
        _isCommentBtnClick = NO;
    }
}


#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", response.errCode];
    if (response.errCode == 0) {
        NSLog(@"分享成功 %@", strMsg);
        [self sendUserShare:UserLikeType_Goods itemId:self.goodsId];
    } else {
        NSLog(@"分享失败 %@", strMsg);
    }
}

#pragma mark - NetWorkDelegate
- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    [self.netIndicatorView hide];
    if (RequestID_GetGoodsDetailAndEvaluation == requestID) {
        NSDictionary *dataDic = [dic objectForKey:@"returnData"];
        GetInfoType IdType = [[dataDic objectForKey:@"IdType"] integerValue];
        if ([dataDic objectForKey:@"statusCode"] == NetWorkJsonResOK) {
            _goodsEvaluModel = [[GoodsDetailAndEvaluModel alloc] initWithAttributes:dataDic];
            NSArray *contArr = [dataDic objectForKey:@"contData"];
            if (GetInfoTypeRefresh == IdType) {
                [_evaluContDataArr removeAllObjects];
            }
            for (int i = 0; i < [contArr count]; i ++) {
                NSDictionary *tmpDic = [contArr objectAtIndex:i];
                CircleInfoModel *tmpModel = [[CircleInfoModel alloc] initWithAttributes:tmpDic];
                tmpModel.type = InfoType_Evaluation; // 评测数据
                [_evaluContDataArr addObject:tmpModel];
            }
            NSInteger contDataCout = [contArr count];
            if (IdType == GetInfoTypeRefresh) {
                [_infoDetailTV.mj_header endRefreshing];
                if (contDataCout == 0) {
                    NSLog(@"没有更新数据了");
                }
            } else {
                [_infoDetailTV.mj_footer endRefreshing];
                if (contDataCout < kPageSizeCount) {
                    NSLog(@"没有更老数据了");
                    [_infoDetailTV.mj_footer endRefreshingWithNoMoreData];
                }
            }
            
            if (contDataCout >= kPageSizeCount) {
                [_infoDetailTV.mj_footer resetNoMoreData];
            }
            
            [self updateFooterBarView];
            [self updateBriefHeadView];
            [_infoDetailTV reloadData];
        } else {
            [_infoDetailTV reloadData];
            [_infoDetailTV.mj_header endRefreshing];
            [_infoDetailTV.mj_footer endRefreshingWithNoMoreData];
        }
    } else if (RequestID_SendUserCollect == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            UserLikeType likeType = [[dataDic objectForKey:@"IdPart"] integerValue];
            if (likeType == UserLikeType_Goods) {
                if (_goodsEvaluModel.goodsId == [[dataDic objectForKey:@"itemId"] integerValue]) {
                    _goodsEvaluModel.isLike = [[dataDic objectForKey:@"isLiked"] integerValue];
                    _goodsEvaluModel.likeNum = [[dataDic objectForKey:@"likeNum"] integerValue];
                    [self updateFooterBarView];
                    return;
                }
            } else if (likeType == UserLikeType_Evaluation) {
                for (int i = 0; i < [_evaluContDataArr count]; i ++) {
                    CircleInfoModel *tmpModel = [_evaluContDataArr objectAtIndex:i];
                    if (tmpModel.itemId == [[dataDic objectForKey:@"itemId"] integerValue]) {
                        tmpModel.isLike = [[dataDic objectForKey:@"isLiked"] integerValue];
                        tmpModel.likeNum = [[dataDic objectForKey:@"likeNum"] integerValue];
                        
                        NSIndexPath *te=[NSIndexPath indexPathForRow:i inSection:1];
                        [_infoDetailTV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te, nil] withRowAnimation:UITableViewRowAnimationNone];
                        return;
                    }
                }
            }
        }
    } else if (RequestID_SendUserAttention == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *returnData = [dic objectForKey:@"returnData"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < [_evaluContDataArr count]; i++) {
                CircleInfoModel *infoModel = [_evaluContDataArr objectAtIndex:i];
                if ([infoModel.evaluateUserId isEqualToString:[returnData objectForKey:@"userId"]]) {
                    infoModel.isConcerned = [[returnData objectForKey:@"isConcerned"] integerValue];
                    NSIndexPath *te=[NSIndexPath indexPathForRow:i inSection:1];
                    [array addObject:te];
                }
            }
            [_infoDetailTV reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
            
        }
    } else if (RequestID_SendUserShare == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSLog(@"分享成功");
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            if ([[dataDic objectForKey:@"itemId"] integerValue] == self.goodsId) {
                _goodsEvaluModel.shareNum = [[dataDic objectForKey:@"shareNum"] integerValue];
                [self updateFooterBarView];
            }
        }
    } else if (RequestID_KnockUpDirectly == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            if ([[dataDic objectForKey:@"hasAllInfo"] integerValue] == 0) {

                DDAlertView *alertView = [[DDAlertView alloc] initWithTitle:@"完善个人资料后查看球拍与你的匹配指数" itemTitles:@[@"立即完善"] itemTags:@[@100]];
                [alertView showWithClickBlock:^(NSInteger btnIndex) {
                    if (btnIndex == 100) {
                        [self performSegueWithIdentifier:IdentifierCompleteInfomation sender:nil];
                    }
                }];
                
            } else {
                KnockUpResultModel *tmpModel = [[KnockUpResultModel alloc] initWithAttributes:dataDic];
                [self performSegueWithIdentifier:IdentifierKnockUpResult sender:tmpModel];
            }
        }
    } else if (RequestID_SendUserZan == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            for (int i = 0; i < [_evaluContDataArr count]; i ++) {
                CircleInfoModel *tmpModel = [_evaluContDataArr objectAtIndex:i];
                if (tmpModel.itemId == [[dataDic objectForKey:@"itemId"] integerValue]) {
                    tmpModel.isPraised = [[dataDic objectForKey:@"isPraised"] integerValue];
                    tmpModel.praiseNum = [[dataDic objectForKey:@"praiseNum"] integerValue];
                    
                    NSIndexPath *te=[NSIndexPath indexPathForRow:i inSection:1];
                    [_infoDetailTV reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te, nil] withRowAnimation:UITableViewRowAnimationNone];
                    return;
                }
            }
        }
    }
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {
    if (RequestID_GetGoodsDetailAndEvaluation == requestID) {
        [self.netIndicatorView hide];
        [_infoDetailTV.mj_header endRefreshing];
        [_infoDetailTV.mj_footer endRefreshingWithNoMoreData];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }
    CircleInfoModel *infoModel = [_evaluContDataArr objectAtIndex:indexPath.row];
    if (infoModel.type == InfoType_Evaluation) {
        [self performSegueWithIdentifier:IdentifierEvaluationDetail sender:infoModel];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (![_uncloseHeader containsObject:[NSNumber numberWithInteger:section]]) {
            return 1;
        } else {
            return 0;
        }
    }
    
    
    return [_evaluContDataArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self getRacketParaViewH:_goodsEvaluModel.type]+5.0f;
    }
    CircleInfoModel *infoModel = [_evaluContDataArr objectAtIndex:indexPath.row];
    return [infoModel getCircleInfoCellHeight:YES isCircleList:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *tipStr = @"装备参数";
    if (section == 1) {
        tipStr = @"球友评测";
    }
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 20)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, kFrameWidth - 20, 18)];
    [tipLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [tipLabel setTextColor:Gray153Color];
    [tipLabel setText:tipStr];
    [bgView addSubview:tipLabel];
    
    UIButton *abtn = [UIButton buttonWithType:UIButtonTypeCustom];
    abtn.frame = CGRectMake(0, 0, kFrameWidth, 20);
    abtn.tag = section;
    [abtn addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
    abtn.backgroundColor = [UIColor clearColor];
    [bgView addSubview:abtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 19.5, kFrameWidth, 0.5)];
    [lineView setBackgroundColor:LineViewColor];
    [bgView addSubview:lineView];
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == 0) {
//        return 5.0f;
//    }
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"evaluationCell";
    if (indexPath.section == 0) {
        cellIdentifier = @"racketParameterCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            [cell.contentView addSubview:_racketParaView];
        }
        [cell setBackgroundColor:Gray240Color];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self updateRacketParameterView];
        return cell;
    } else {
        CircleTVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[CircleTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.myDelegate = self;
        }
        CircleInfoModel *info = [_evaluContDataArr objectAtIndex:indexPath.row];
        [cell bindCellWithDataModel:info hideTag:YES isCircleList:YES];
        return cell;
    }
}

-(void)headerClicked:(UIButton*)sender {
    NSInteger sectionIndex = sender.tag;
    if (sectionIndex != 0) {
        return;
    }
    if ([_uncloseHeader containsObject:[NSNumber numberWithInteger:sectionIndex]]) {
        [_uncloseHeader removeObject:[NSNumber numberWithInteger:sectionIndex]];
    } else {
        [_uncloseHeader addObject:[NSNumber numberWithInteger:sectionIndex]];
    }
    [_infoDetailTV reloadData];
    
    [_infoDetailTV beginUpdates];
    [_infoDetailTV reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
    [_infoDetailTV endUpdates];
}

@end
