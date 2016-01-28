//
//  EvaluationDetailCell.m
//  QiuPai
//
//  Created by bigqiang on 15/11/18.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "EvaluationDetailCell.h"
#import "EvaluationView.h"
#import "EvaluationDetailModel.h"
#import "UIImageView+WebCache.h"

@interface DDImageView : UIImageView{
    NSString *_imageId;
}
@property (nonatomic, copy) NSString *imageId;
@end

@implementation DDImageView

@end

@interface EvaluationDetailCell() {
    UIButton *_zanBtn;
    UIButton *_collectBtn;
    UILabel *_nameLabel;
    UILabel *_likeCountLabel;
    UILabel *_playYearLabel;
    
    UIImageView *_headImageView;
    UIButton *_attentionBtn;
    UILabel *_commentLabel;
    UIImageView *_tagTipImageView;
    UIImageView *_likeTipImageView;
    UIButton *_commentBtn;
    UILabel *_timeLabel;
    EvaluationView *_evaluationView;
    UIButton *_loadMoreBtn;
    UIView *_lineView;
    
    NSMutableArray *_tagBtnArr;
    NSMutableArray *_likeUserImageArr;
    float _cellHeight;
}

@property (nonatomic, weak) SubEvaluationModel *subEvaluModel;
@property (nonatomic, weak) EvaluationDetailModel *evaluDetailModel;
@property (nonatomic, copy) NSString *userId;

@end

@implementation EvaluationDetailCell

- (NSString *)userId{
    return _userId ? _userId : [QiuPaiUserModel getUserInstance].userId;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(EvaluationDetailCellType)type {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initEvaluationUI:type];
    }
    return self;
}

- (void)initEvaluationUI:(EvaluationDetailCellType)type {
    UIView *superView = self.contentView;
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
    _headImageView.layer.borderWidth = 0.5f;
    _headImageView.layer.borderColor = [[UIColor clearColor] CGColor];
    _headImageView.layer.cornerRadius = 35.0f/2;
    [_headImageView setHidden:YES];
    [_headImageView setClipsToBounds:YES];
    [self.contentView addSubview:_headImageView];
    [_headImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImagePress:)];
    [_headImageView addGestureRecognizer:singleTap1];
    
    _nameLabel = [[AutoResizeLabel alloc] initWithFrame:CGRectMake(54, 13, 50, 30)];
    [_nameLabel setTextColor:Gray51Color];
    [_nameLabel setBackgroundColor:[UIColor clearColor]];
    [_nameLabel setFont:[UIFont systemFontOfSize:FS_PC_NAME]];
    [_nameLabel setTextAlignment:NSTextAlignmentLeft];
    [_nameLabel setHidden:YES];
    [self.contentView addSubview:_nameLabel];
    
    if (type == EvaluationDetailCellType_Evalu) {
        _playYearLabel = [[AutoResizeLabel alloc] initWithFrame:CGRectMake(54, 30, 50, 30)];
        [_playYearLabel setTextColor:Gray102Color];
        [_playYearLabel setBackgroundColor:[UIColor clearColor]];
        [_playYearLabel setFont:[UIFont systemFontOfSize:FS_PC_PLAY_YEAR]];
        [_playYearLabel setTextAlignment:NSTextAlignmentLeft];
        [_playYearLabel setHidden:YES];
        [self.contentView addSubview:_playYearLabel];
        
        _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attentionBtn setHidden:YES];
        [_attentionBtn setFrame:CGRectMake(kFrameWidth - 20 - 44, 15, 44, 20)];
        _attentionBtn.titleLabel.font = [UIFont systemFontOfSize:FS_PC_BUTTON];
        [_attentionBtn setBackgroundImage:[UIImage imageNamed:@"button_attention.png"] forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:CustomGreenColor forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:CustomGreenColor forState:UIControlStateHighlighted];
        [_attentionBtn setTitleColor:Gray102Color forState:UIControlStateSelected];
        [_attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
        [_attentionBtn addTarget:self action:@selector(attentionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_attentionBtn];
        
        float imageHeight = (kFrameWidth - 20 - 10)/3;
        _evaluationView = [[EvaluationView alloc] initWithFrame:CGRectMake(0, 30, kFrameWidth, 0) showDetailContent:YES];
        [_evaluationView setHidden:YES];
        [self.contentView addSubview:_evaluationView];
        [_evaluationView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(superView.mas_top).with.offset(CGRectGetMaxY(_headImageView.frame)+5);
            make.width.equalTo(superView.mas_width);
            make.height.equalTo(@(imageHeight+FS_PC_TITLE+FS_PC_CONTENT));
            make.left.equalTo(@0);
        }];
        
        _zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_zanBtn setFrame:CGRectMake(kFrameWidth - 102, 242, 36, 22)];
        _zanBtn.titleLabel.font = [UIFont systemFontOfSize:FS_PC_BUTTON];
        [_zanBtn setImage:[UIImage imageNamed:@"button_zan_nor.png"] forState:UIControlStateNormal];
        [_zanBtn setImage:[UIImage imageNamed:@"button_zan_sel.png"] forState:UIControlStateSelected];
        [_zanBtn setTitleColor:Gray102Color forState:UIControlStateNormal];
        [_zanBtn setTitleColor:Gray102Color forState:UIControlStateSelected];
        _zanBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 14);
        [_zanBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_zanBtn];
        
        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectBtn setFrame:CGRectMake(kFrameWidth - 102, 242, 36, 22)];
        _collectBtn.titleLabel.font = [UIFont systemFontOfSize:FS_PC_BUTTON];
        [_collectBtn setTitleColor:Gray102Color forState:UIControlStateNormal];
        [_collectBtn setTitleColor:Gray102Color forState:UIControlStateSelected];
        [_collectBtn setTitle:@"未收藏" forState:UIControlStateNormal];
        [_collectBtn setTitle:@"已收藏" forState:UIControlStateSelected];
        [_collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        //    [self.contentView addSubview:_collectBtn];
        
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setFrame:CGRectMake(kFrameWidth - 58, 242, 48, 22)];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:FS_PC_BUTTON];
        [_commentBtn setImage:[UIImage imageNamed:@"button_comment.png"] forState:UIControlStateNormal];
        [_commentBtn setImage:[UIImage imageNamed:@"button_comment.png"] forState:UIControlStateSelected];
        [_commentBtn setTitleColor:Gray102Color forState:UIControlStateNormal];
        [_commentBtn setTitleColor:Gray102Color forState:UIControlStateSelected];
        [_commentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [_commentBtn setTitle:@"评论" forState:UIControlStateHighlighted];
        _commentBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 26);
        [_commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_commentBtn setHidden:YES];
        [self.contentView addSubview:_commentBtn];
        
        _tagTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 17, 17)];
        [_tagTipImageView setHidden:YES];
        [_tagTipImageView setImage:[UIImage imageNamed:@"tag_indicator.png"]];
        [self.contentView addSubview:_tagTipImageView];
        
        _likeTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 17, 17)];
        [_likeTipImageView setHidden:YES];
        [_likeTipImageView setImage:[UIImage imageNamed:@"like_indicator.png"]];
        [self.contentView addSubview:_likeTipImageView];
        
        _likeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 50, 30)];
        [_likeCountLabel setTextColor:CustomGreenColor];
        [_likeCountLabel setBackgroundColor:[UIColor clearColor]];
        [_likeCountLabel setFont:[UIFont systemFontOfSize:FS_PC_TAG]];
        [_likeCountLabel setTextAlignment:NSTextAlignmentLeft];
        [_likeCountLabel setHidden:YES];
        [self.contentView addSubview:_likeCountLabel];
        
        _tagBtnArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < 3; i++) {
            UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tagBtn.titleLabel.font = [UIFont systemFontOfSize:FS_PC_TAG];
            [tagBtn setTitleColor:CustomGreenColor forState:UIControlStateNormal];
            [tagBtn setTitleColor:CustomGreenColor forState:UIControlStateSelected];
            [tagBtn setTitleColor:Gray102Color forState:UIControlStateDisabled];
            [tagBtn setHidden:YES];
            [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:tagBtn];
            [_tagBtnArr addObject:tagBtn];
        }
        
        _likeUserImageArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < 5; i++) {
            DDImageView *tmpImageView = [[DDImageView alloc] initWithFrame:CGRectMake(0, 0, 17, 17)];
            tmpImageView.layer.borderColor = [[UIColor clearColor] CGColor];
            tmpImageView.layer.borderWidth = 0.5f;
            tmpImageView.layer.cornerRadius = 17.0f/2;
            [tmpImageView setClipsToBounds:YES];
            [self.contentView addSubview:tmpImageView];
            [_likeUserImageArr addObject:tmpImageView];
            [tmpImageView setHidden:YES];
            tmpImageView.imageId = @"";
            
            [tmpImageView setUserInteractionEnabled:YES];
            UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeHeadImagePress:)];
            [tmpImageView addGestureRecognizer:singleTap1];
        }
        
        _loadMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loadMoreBtn setTitle:@"点击加载更多评测..." forState:UIControlStateNormal];
        [_loadMoreBtn setTitle:@"点击加载更多评测..." forState:UIControlStateSelected];
        [_loadMoreBtn setTag:-1010];
        _loadMoreBtn.titleLabel.font = [UIFont systemFontOfSize:FS_PCXQ_LOAD_MORE];
        [_loadMoreBtn setTitleColor:Gray153Color forState:UIControlStateNormal];
        [_loadMoreBtn setTitleColor:Gray153Color forState:UIControlStateSelected];
        [_loadMoreBtn setFrame:CGRectMake(0, 0, 0, 0)];
        [_loadMoreBtn addTarget:self action:@selector(loadMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_loadMoreBtn];

    } else if (type == EvaluationDetailCellType_Comment) {
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, kFrameWidth - 80, 30)];
        [_commentLabel setText:@""];
        [_commentLabel setTextColor:Gray85Color];
        [_commentLabel setBackgroundColor:[UIColor clearColor]];
        [_commentLabel setFont:[UIFont systemFontOfSize:FS_PC_COMMENT]];
        [_commentLabel setTextAlignment:NSTextAlignmentLeft];
        [_commentLabel setHidden:YES];
        [self.contentView addSubview:_commentLabel];
    }
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
    [_timeLabel setTextColor:Gray153Color];
    [_timeLabel setBackgroundColor:[UIColor clearColor]];
    [_timeLabel setFont:[UIFont systemFontOfSize:FS_PCXQ_TIME]];
    [_timeLabel setTextAlignment:NSTextAlignmentLeft];
    [_timeLabel setHidden:YES];
    [self.contentView addSubview:_timeLabel];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 0.5)];
    [_lineView setBackgroundColor:LineViewColor];
    [self.contentView addSubview:_lineView];
}

- (void)likeHeadImagePress:(UITapGestureRecognizer *)tapGesture {
    DDImageView *imageView = (DDImageView *)tapGesture.view;
    [self.myDelegate headImageClick:imageView.imageId];
}

- (void)headImagePress:(UITapGestureRecognizer *)tap {
    NSLog(@"headImagePress");
    [self.myDelegate headImageClick:self.userId];
}

- (void)commentBtnClick:(UIButton *)sender {

}

- (void)loadMoreBtnClick:(UIButton *)sender {
//    [sender setTitle:@"..." forState:UIControlStateNormal];
//    [sender setTitle:@"..." forState:UIControlStateSelected];
    [self.myDelegate loadMoreSubEvalution];
}

- (void)zanBtnClick:(UIButton *)sender {
    NSString *titleStr = @"";
    if ([_zanBtn isSelected]) {
        [_zanBtn setSelected:NO];
        titleStr = [NSString stringWithFormat:@"%ld", (long)_subEvaluModel.praiseNum-1];
    } else {
        [_zanBtn setSelected:YES];
        titleStr = [NSString stringWithFormat:@"%ld", (long)_subEvaluModel.praiseNum+1];
    }
    
    [_zanBtn setTitle:titleStr forState:UIControlStateNormal];
    [_zanBtn setTitle:titleStr forState:UIControlStateSelected];
    
    NSInteger idPart = 4;
    [self.myDelegate sendUserZanRequest:idPart itemId:_subEvaluModel.itemId];
}

- (void)collectBtnClick:(UIButton *)sender {
    [_collectBtn setSelected:![_collectBtn isSelected]];
    NSInteger idPart = 4;
    [self.myDelegate sendUserCollectRequest:idPart itemId:_subEvaluModel.itemId];
}

- (void)attentionBtnClick:(UIButton *)sender {
    [self.myDelegate sendUserAttentionRequest:_evaluDetailModel.userId];
}

- (void)tagBtnClick:(UIButton *)sender {
    long goodsId = [sender tag];
    [self.myDelegate getTagGoodsRequest:goodsId];
}

- (void)showLoadMoreBtn {
    [_loadMoreBtn setHidden:NO];
    [_loadMoreBtn setFrame:CGRectMake(0, 0, kFrameWidth, _cellHeight)];
    
    for (UIButton *tagBtn in _tagBtnArr) {
        [tagBtn setHidden:YES];
    }
    [_zanBtn setHidden:YES];
    [_collectBtn setHidden:YES];
    [_attentionBtn setHidden:YES];
    [_evaluationView setHidden:YES];
    [_likeCountLabel setHidden:YES];
    [_tagTipImageView setHidden:YES];
    [_likeTipImageView setHidden:YES];
    [_playYearLabel setHidden:YES];
    [_commentBtn setHidden:YES];
    [_headImageView setHidden:YES];
    [_nameLabel setHidden:YES];
    [_timeLabel setHidden:YES];
    [_commentLabel setHidden:YES];

    [_lineView setFrame:CGRectMake(0, _cellHeight - 0.5, kFrameWidth, 0.5)];    
    for (int i = 0; i < [_likeUserImageArr count]; i++) {
        DDImageView *tmpImageView = [_likeUserImageArr objectAtIndex:i];
        [tmpImageView setHidden:YES];
    }
    for (int i = 0; i < [_tagBtnArr count]; i++) {
        UIButton *tmpBtn = [_tagBtnArr objectAtIndex:i];
        [tmpBtn setHidden:YES];
    }
    UILabel *commaLabel = [self.contentView viewWithTag:-101];
    if (commaLabel) {
        [commaLabel setHidden:YES];
    }
}

- (void)bindContentCellWithModel:(EvaluationDetailModel *)infoModel cellSection:(NSInteger)section cellIndex:(NSInteger)row hideGoodsTag:(BOOL)isHideTag {
    _evaluDetailModel = infoModel;
    _cellHeight = [infoModel getEvaluationDetailCellHeight:section cellRow:row isHideGoodsTag:isHideTag];
    if (section == 0) {
        if (row < [infoModel.contData count]) {
            // 评测详情
            [self bindContDataCellWithModel:infoModel cellIndex:row hideGoodsTag:isHideTag];
        } else {
            // 加载更多
            [self showLoadMoreBtn];
        }
    } else {
        // 评论详情
        [self bindCommentCellWithModel:infoModel cellIndex:row];
    }
}

- (void)bindContDataCellWithModel:(EvaluationDetailModel *)infoModel cellIndex:(NSInteger)row hideGoodsTag:(BOOL)isHideTag {
    _subEvaluModel = [infoModel.contData objectAtIndex:row];
    _userId = _evaluDetailModel.userId;
    [_commentLabel setHidden:YES];
    [_loadMoreBtn setHidden:YES];
    if (row == 0) {
        [_nameLabel setHidden:NO];
        [_nameLabel setText:infoModel.nick];
        [_nameLabel sizeToFit];
        
        [_playYearLabel setHidden:NO];
        [_playYearLabel setText:[NSString stringWithFormat:@"球龄%@年", infoModel.playYear]];
        [_playYearLabel sizeToFit];
        
        [_headImageView setHidden:NO];
        [_headImageView setFrame:CGRectMake(10, 10, 35, 35)];
        _headImageView.layer.cornerRadius = 35.0f/2;
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.thumbHeadPic] placeholderImage:[UIImage imageNamed:@"placeholder_head.png"]];
        
        if ([infoModel.userId isEqualToString:[QiuPaiUserModel getUserInstance].userId]) {
            [_attentionBtn setHidden:YES];
        } else {
            [_attentionBtn setHidden:NO];
            if (infoModel.isConcerned == ConcernedState_None) {
                [_attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
                [_attentionBtn setTitleColor:CustomGreenColor forState:UIControlStateNormal];
            } else if (infoModel.isConcerned == ConcernedState_Attentioned) {
                [_attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
                [_attentionBtn setTitleColor:Gray102Color forState:UIControlStateNormal];
            } else {
                [_attentionBtn setTitle:@"已互粉" forState:UIControlStateNormal];
                [_attentionBtn setTitleColor:Gray102Color forState:UIControlStateNormal];
            }
        }
        
        CGRect commentBtnFrame = _commentBtn.frame;
        commentBtnFrame.origin.y = _cellHeight - 25;
        [_commentBtn setFrame:commentBtnFrame];
        [_commentBtn setHidden:YES];
        
        CGRect zanBtnFrame = _zanBtn.frame;
        zanBtnFrame.origin.x = kFrameWidth - 55;
        zanBtnFrame.origin.y = _cellHeight - 25;
        [_zanBtn setFrame:zanBtnFrame];
        
        CGRect colRect = _collectBtn.frame;
        [_collectBtn setFrame:CGRectMake(CGRectGetMaxX(_zanBtn.frame), CGRectGetMinY(_zanBtn.frame), colRect.size.width, colRect.size.height)];
        
//        CGRect evaluFrame = _evaluationView.frame;
//        evaluFrame.origin.y = CGRectGetMaxY(_headImageView.frame) + 8;
//        [_evaluationView setFrame:evaluFrame];
        
        [_likeTipImageView setHidden:NO];
        CGRect likeTipFrame = _tagTipImageView.frame;
        likeTipFrame.origin.y = _cellHeight - 40;
        [_likeTipImageView setFrame:likeTipFrame];

        // 标签列表
        if (!isHideTag) {
            [_tagTipImageView setHidden:NO];
            CGRect tagTipFrame = _tagTipImageView.frame;
            tagTipFrame.origin.y = _cellHeight - 62;
            [_tagTipImageView setFrame:tagTipFrame];
            
            NSArray *tagArr = _subEvaluModel.tagInfo;
            float xPosi = CGRectGetMaxX(_tagTipImageView.frame) + 2;
            float yPosi = CGRectGetMinY(_tagTipImageView.frame);
            for (int i = 0; i < [tagArr count]; i++) {
                NSDictionary *objDic = [tagArr objectAtIndex:i];
                int goodsId = [[objDic objectForKey:@"goodsId"] intValue]; //商品Id
                //        int isPrivilege = [[objDic objectForKey:@"isPrivilege"] intValue]; //是否特惠 0否1是
                NSString *goodsName = [objDic objectForKey:@"goodsName"]; //商品名
                
                UIButton *tagBtn = [_tagBtnArr objectAtIndex:i];
                [tagBtn setHidden:NO];
                if ([[objDic objectForKey:@"isSelfDefine"] intValue] == 1) {
                    //是否自定义标签 0否1是
                    [tagBtn setEnabled:NO];
                } else {
                    [tagBtn setEnabled:YES];
                }
                [tagBtn setTitle:goodsName forState:UIControlStateNormal];
                [tagBtn setTitle:goodsName forState:UIControlStateHighlighted];
                [tagBtn setTitle:goodsName forState:UIControlStateDisabled];
                [tagBtn setTag:goodsId];
                [tagBtn sizeToFit];

                CGRect btnFrame = tagBtn.frame;
                [tagBtn setFrame:CGRectMake(xPosi, yPosi, btnFrame.size.width, 15)];
                [self.contentView addSubview:tagBtn];
                
                xPosi = xPosi + CGRectGetMaxX(tagBtn.frame);
                if (i != [tagArr count]-1) {
                    CGRect commaFrame = [@", " boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11.0f]} context:nil];
                    UILabel *commaLabel = [self.contentView viewWithTag:-101];
                    if (commaLabel == nil) {
                        commaLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPosi, yPosi, commaFrame.size.width, 20)];
                        [commaLabel setTag:-101];
                        [self.contentView addSubview:commaLabel];
                    }
                    [commaLabel setText:@", "];
                    [commaLabel setFont:[UIFont systemFontOfSize:FS_PC_TAG]];
                    xPosi = xPosi + commaFrame.size.width;
                }
            }
        }
        
        CGRect sexFrame = [[NSString stringWithFormat:@"%ld", (long)_subEvaluModel.praiseNum] boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FS_PC_TAG]} context:nil];
        [_likeCountLabel setHidden:NO];
        [_likeCountLabel setFrame:CGRectMake(2 + CGRectGetMaxX(_likeTipImageView.frame), CGRectGetMinY(_likeTipImageView.frame), sexFrame.size.width, 17)];
        [_likeCountLabel setText:[NSString stringWithFormat:@"%ld", (long)_subEvaluModel.praiseNum]];

        // 喜欢头像列表
        NSArray *praiseListArr = _subEvaluModel.praiseList;
        float xxPosi = CGRectGetMaxX(_likeCountLabel.frame) + 2;
        float yyPosi = CGRectGetMinY(_likeTipImageView.frame);
        for (int i = 0; i < [_likeUserImageArr count]; i++) {
            DDImageView *tmpImageView = [_likeUserImageArr objectAtIndex:i];
            CGRect tpImageFrame = tmpImageView.frame;
            tpImageFrame.origin.y = yyPosi;
            tpImageFrame.origin.x = xxPosi;
            [tmpImageView setFrame:tpImageFrame];
            if (i < [praiseListArr count]) {
                [tmpImageView setHidden:NO];
                NSDictionary *objDic = [praiseListArr objectAtIndex:i];
                tmpImageView.imageId = [objDic objectForKey:@"itemId"];
                [tmpImageView sd_setImageWithURL:[NSURL URLWithString:[objDic objectForKey:@"thumbHeadPic"]]  placeholderImage:[UIImage imageNamed:@"placeholder_head.png"]];

            } else {
                [tmpImageView setHidden:YES];
            }
            xxPosi = xxPosi + 19;
        }
    } else {
        [_attentionBtn setHidden:YES];
        [_likeCountLabel setHidden:YES];
        [_tagTipImageView setHidden:YES];
        [_likeTipImageView setHidden:YES];
        [_headImageView setHidden:YES];
        [_nameLabel setHidden:YES];
        [_playYearLabel setHidden:YES];
        [_commentBtn setHidden:YES];
        for (int i = 0; i < [_likeUserImageArr count]; i++) {
            DDImageView *tmpImageView = [_likeUserImageArr objectAtIndex:i];
            [tmpImageView setHidden:YES];
        }
        for (int i = 0; i < [_tagBtnArr count]; i++) {
            UIButton *tmpBtn = [_tagBtnArr objectAtIndex:i];
            [tmpBtn setHidden:YES];
        }
        UILabel *commaLabel = [self.contentView viewWithTag:-101];
        if (commaLabel) {
            [commaLabel setHidden:YES];
        }
        
        CGRect zanBtnFrame = _zanBtn.frame;
        zanBtnFrame.origin.x = kFrameWidth - 55;
        zanBtnFrame.origin.y = _cellHeight - 25;
        [_zanBtn setFrame:zanBtnFrame];
        
        CGRect colRect = _collectBtn.frame;
        [_collectBtn setFrame:CGRectMake(CGRectGetMaxX(_zanBtn.frame), CGRectGetMinY(_zanBtn.frame), colRect.size.width, colRect.size.height)];
        
        [_evaluationView setFrame:CGRectMake(0, 0, kFrameWidth, 10)];
        
        for (int i = 0; i < [_tagBtnArr count]; i++) {
            UIButton *tagBtn = [_tagBtnArr objectAtIndex:i];
            [tagBtn setHidden:YES];
        }
    }
    CGRect timeFrame = _timeLabel.frame;
    timeFrame.origin.y = _cellHeight - 22;
    [_timeLabel setFrame:timeFrame];
    [_timeLabel setHidden:NO];
    [_timeLabel setText:[NSDate formatSecondsSince1970ToDateString:_subEvaluModel.evaluateTime]];
    
    [_zanBtn setHidden:NO];
    [_zanBtn setSelected:(_subEvaluModel.isPraised == PraisedState_YES ? YES:NO)];
    NSString *zanTitle = [NSString stringWithFormat:@"%ld", (long)_subEvaluModel.praiseNum];
    [_zanBtn setTitle:zanTitle forState:UIControlStateNormal];
    [_zanBtn setTitle:zanTitle forState:UIControlStateSelected];

    [_lineView setFrame:CGRectMake(0, _cellHeight-0.5, kFrameWidth, 0.5)];
    
    [_collectBtn setHidden:NO];
    [_collectBtn setSelected:(_subEvaluModel.isLike==1?YES:NO)];
    
    [_evaluationView setHidden:NO];
    NSArray *picArr = _subEvaluModel.picUrl;
    NSArray *thumbPicArr = _subEvaluModel.thumbPicUrl;
    NSString *contentStr = _subEvaluModel.content;
    NSString *titleStr = _subEvaluModel.title;
    if (row != 0) {
        titleStr = @"";
        [_evaluationView mas_updateConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(@3);
        }];
    } else {
        [_evaluationView mas_updateConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(@((CGRectGetMaxY(_headImageView.frame)+5)));
        }];
    }
    [_evaluationView setPicArr:picArr thumbPicArray:thumbPicArr title:titleStr contentStr:contentStr isCircleList:NO];
    
    
    
}

- (void)bindCommentCellWithModel:(EvaluationDetailModel *)infoModel cellIndex:(NSInteger)row {
    for (UIButton *tagBtn in _tagBtnArr) {
        [tagBtn setHidden:YES];
    }
    [_loadMoreBtn setHidden:YES];
    [_zanBtn setHidden:YES];
    [_collectBtn setHidden:YES];
    [_attentionBtn setHidden:YES];
    [_evaluationView setHidden:YES];
    [_likeCountLabel setHidden:YES];
    [_tagTipImageView setHidden:YES];
    [_likeTipImageView setHidden:YES];
    [_playYearLabel setHidden:YES];
    [_commentBtn setHidden:YES];

    EvaluaCommentModel *commentModel = [infoModel.commentData objectAtIndex:row];
    _userId = commentModel.commentUserId;
    
    for (int i = 0; i < [_likeUserImageArr count]; i++) {
        DDImageView *tmpImageView = [_likeUserImageArr objectAtIndex:i];
        [tmpImageView setHidden:YES];
    }
    for (int i = 0; i < [_tagBtnArr count]; i++) {
        UIButton *tmpBtn = [_tagBtnArr objectAtIndex:i];
        [tmpBtn setHidden:YES];
    }
    UILabel *commaLabel = [self.contentView viewWithTag:-101];
    if (commaLabel) {
        [commaLabel setHidden:YES];
    }

    // 头像
    [_headImageView setHidden:NO];
    [_headImageView setFrame:CGRectMake(6, 10, 32, 32)];
    _headImageView.layer.cornerRadius = 32.0/2;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:commentModel.commentUserThumbURL] placeholderImage:[UIImage imageNamed:@"placeholder_head.png"]];
    
    // 昵称
    [_nameLabel setHidden:NO];
    CGRect nameFrame = [commentModel.commentName boundingRectWithSize:CGSizeMake(100, 30) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FS_PC_NAME]} context:nil];
    [_nameLabel setFrame:CGRectMake(47, 10, nameFrame.size.width, 22)];
    [_nameLabel setText:commentModel.commentName];

    // 显示时间
    [_timeLabel setHidden:NO];
    [_timeLabel setText:[NSDate formatSecondsSince1970ToDateString:commentModel.commentTime]];
    [_timeLabel sizeToFit];
    CGRect timeFrame = _timeLabel.frame;
    timeFrame.origin.y = CGRectGetMinY(_nameLabel.frame)+2;
    timeFrame.origin.x = kFrameWidth - 6.0f - timeFrame.size.width;
    [_timeLabel setFrame:timeFrame];
    
    // 改成显示评论内容
    [_commentLabel setHidden:NO];
    _commentLabel.numberOfLines = 0;
    NSString *comentStr = commentModel.content;
    CGRect commentFrame = [comentStr boundingRectWithSize:CGSizeMake(kFrameWidth - 20 - 38, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FS_PC_COMMENT]} context:nil];
    [_commentLabel setFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_timeLabel.frame) + 2, commentFrame.size.width, commentFrame.size.height)];
    [_commentLabel setText:comentStr];
    
    [_lineView setFrame:CGRectMake(0, _cellHeight-0.5, kFrameWidth, 0.5)];
}

@end
