//
//  KnockUpResultViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/12/15.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "KnockUpResultViewController.h"
#import "UIImageView+WebCache.h"
#import "RadarChartView.h"
#import "DDStarRatingView.h"

@interface KnockUpResultViewController() {
    UIView *_goodsBriefView;
    RadarChartView *_radarChartView;
    DDStarRatingView *_starRatingView;
}

@end

@implementation KnockUpResultViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"试打结果";
    [self.view setBackgroundColor:VCViewBGColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake(0, 0, 27, 27)];
    [shareBtn setImage:[UIImage imageNamed:@"share_indicator_btn.png"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"share_indicator_btn.png"] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
//    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self initGoodsBriefInfomation];
    [self initRadarChartView];
    [self initDDStarRatingView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateGoodsBriefInfoView];
    _radarChartView.userPropertyArr = _dataInfoModel.featuresRac;
    _starRatingView.currentScore = _dataInfoModel.rank;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
}

- (void)shareItemClick:(NSInteger)btnIndex {
    NSLog(@"btnIndex is %ld", (long)btnIndex);
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
//            __weak typeof(self) _weakSelf = self;
            [QQHelper shareImageMsg:@"试打报告" description:@"" scene:QQShareScene_Session callBack:^(QQApiSendResultCode sendResult){
//                [_weakSelf sendUserShare:UserLikeType_Goods itemId:_goodsId];
            }];
        }
            break;
        case 3:
        {
            //            __weak typeof(self) _weakSelf = self;
            [QQHelper shareImageMsg:@"试打报告" description:@"" scene:QQShareScene_QZone callBack:^(QQApiSendResultCode sendResult){
                //                [_weakSelf sendUserShare:UserLikeType_Goods itemId:_goodsId];
            }];
        }
            break;
            
        case 4:
        {
//            _shareScene = ShareScene_Weibo;
            UIImage *tmpImage = [UIImage imageWithContentsOfFile:KShareImagePath];
            NSData *imageData = UIImageJPEGRepresentation(tmpImage, 1.0);
            [WBApiRequestHandler sendWeiboImageData:imageData];
        }
            break;
        default:
            break;
    }
}

- (void)shareBtnClick:(UIButton *)sender {
    [Helper showShareSheetView:^(NSInteger btnIndex){
        [self shareItemClick:btnIndex];
    } showQZone:NO cancelHandler:nil];
}

- (void)initRadarChartView {
    _radarChartView = [[RadarChartView alloc] initWithFrame:CGRectMake(0, 238, kFrameWidth, 280)];
    [self.view addSubview:_radarChartView];
}

- (void)initDDStarRatingView {
    _starRatingView = [[DDStarRatingView alloc] initWithFrame:CGRectMake(0, kFrameHeight - 95, kFrameWidth, 45)];
    [self.view addSubview:_starRatingView];
}

- (void)initGoodsBriefInfomation {
    _goodsBriefView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 23, kFrameWidth, 97)];
    [_goodsBriefView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *goodImage = [[UIImageView alloc] initWithFrame:CGRectMake(11, 6, 85, 85)];
    [goodImage setTag:100];
    [_goodsBriefView addSubview:goodImage];
//    mDebugShowBorder(goodImage, [UIColor redColor]);
    CGFloat gap = 5.50f;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodImage.frame) + 4, 8, kFrameWidth - 104 - 10, 18)];
    [nameLabel setTag:200];
    [nameLabel setTextAlignment:NSTextAlignmentLeft];
    [nameLabel setTextColor:Gray17Color];
    [nameLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [_goodsBriefView addSubview:nameLabel];
    
//    UILabel *weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, 66, 62, 14)];
    UILabel *weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame)+gap*2, 62, 14)];
    [weightLabel setTag:300];
    [weightLabel setTextAlignment:NSTextAlignmentLeft];
    [weightLabel setTextColor:Gray153Color];
    [weightLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [_goodsBriefView addSubview:weightLabel];
    
//    UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(weightLabel.frame.origin.x + weightLabel.frame.size.width + 8, weightLabel.frame.origin.y, 62, 14)];
    UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(weightLabel.frame), CGRectGetMaxY(weightLabel.frame)+gap, 62, 14)];
    [balanceLabel setTag:400];
    [balanceLabel setTextAlignment:NSTextAlignmentLeft];
    [balanceLabel setTextColor:Gray153Color];
    [balanceLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [_goodsBriefView addSubview:balanceLabel];
    
    UILabel *headSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(weightLabel.frame), CGRectGetMaxY(balanceLabel.frame)+gap, 62, 14)];
    [headSizeLabel setTag:500];
    [headSizeLabel setTextAlignment:NSTextAlignmentLeft];
    [headSizeLabel setTextColor:Gray153Color];
    [headSizeLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [_goodsBriefView addSubview:headSizeLabel];
    
    [self.view addSubview:_goodsBriefView];
}

- (void)updateGoodsBriefInfoView {
    UIImageView *goodImage = [_goodsBriefView viewWithTag:100];
    [goodImage sd_setImageWithURL:[NSURL URLWithString:_dataInfoModel.thumbPicUrl] placeholderImage:[UIImage imageNamed:@"placeholder_evaluation.jpg"]];
    
    UILabel *nameLabel = [_goodsBriefView viewWithTag:200];
    [nameLabel setText:_dataInfoModel.racName];
    [nameLabel sizeToFit];
    
    UILabel *weightLabel = [_goodsBriefView viewWithTag:300];
    [weightLabel setText:[NSString stringWithFormat:@"重量:%.2fg", _dataInfoModel.weight]];
    [weightLabel sizeToFit];
    
    UILabel *balanceLabel = [_goodsBriefView viewWithTag:400];
    [balanceLabel setText:[NSString stringWithFormat:@"平衡点:%@", _dataInfoModel.balance]];
    [balanceLabel sizeToFit];
//    CGRect balanceOrignFrame = [balanceLabel frame];
//    balanceOrignFrame.origin.x = weightLabel.frame.origin.x + weightLabel.frame.size.width + 8;
//    [balanceLabel setFrame:balanceOrignFrame];
    
    UILabel *headSizeLabel = [_goodsBriefView viewWithTag:500];
    [headSizeLabel setText:[NSString stringWithFormat:@"拍面:%.0f平方英寸", _dataInfoModel.headSize]];
    [headSizeLabel sizeToFit];
//    CGRect headSizeOrignFrame = [headSizeLabel frame];
//    headSizeOrignFrame.origin.x = balanceLabel.frame.origin.x + balanceLabel.frame.size.width + 8;
//    [headSizeLabel setFrame:headSizeOrignFrame];
}

@end
