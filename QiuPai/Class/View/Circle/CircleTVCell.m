//
//  CircleTVCell.m
//  QiuPai
//
//  Created by bigqiang on 15/11/13.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "CircleTVCell.h"
#import "CircleInfoModel.h"
#import "UIImageView+WebCache.h"
#import "EvaluationView.h"

static CGFloat imageHeight;

@interface CircleTVCell(){
    AutoResizeLabel *_nameLabel;
    AutoResizeLabel *_playYearLabel;
    UIImageView *_headImageView;
    UIButton *_attentionBtn;
    UIButton *_collectBtn;
    UIButton *_zanBtn;
    UILabel *_tagLabel;
    UIButton *_commentBtn;
    EvaluationView *_evaluationView;
    UIView *_lineView;
    
    NSMutableArray *_tagBtnArr;
}

@property (nonatomic, weak) CircleInfoModel *circleInfoModel;

@end

@implementation CircleTVCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *superView = self.contentView;
        imageHeight = (kFrameWidth - 20 - 10)/3;
        
        // 评测cell
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
        _headImageView.layer.borderColor = [[UIColor clearColor] CGColor];
        _headImageView.layer.borderWidth = 0.5f;
        _headImageView.layer.cornerRadius = 35.0f/2;
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
        [self.contentView addSubview:_nameLabel];
        
        _playYearLabel = [[AutoResizeLabel alloc] initWithFrame:CGRectMake(54, 30, 50, 30)];
        [_playYearLabel setTextColor:Gray102Color];
        [_playYearLabel setBackgroundColor:[UIColor clearColor]];
        [_playYearLabel setFont:[UIFont systemFontOfSize:FS_PC_PLAY_YEAR]];
        [_playYearLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_playYearLabel];
        
        _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attentionBtn setFrame:CGRectMake(kFrameWidth - 20 - 44, 15, 44, 20)];
        _attentionBtn.titleLabel.font = [UIFont systemFontOfSize:FS_PC_BUTTON];
        [_attentionBtn setBackgroundImage:[UIImage imageNamed:@"button_attention.png"] forState:UIControlStateNormal];
        [_attentionBtn setBackgroundImage:[UIImage imageNamed:@"button_attention.png"] forState:UIControlStateSelected];
        [_attentionBtn setBackgroundImage:[UIImage imageNamed:@"button_attention.png"] forState:UIControlStateHighlighted];
        [_attentionBtn setTitleColor:CustomGreenColor forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:CustomGreenColor forState:UIControlStateHighlighted];
        [_attentionBtn setTitleColor:Gray102Color forState:UIControlStateSelected];
        [_attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
        [_attentionBtn setTitle:@"+关注" forState:UIControlStateHighlighted];
        [_attentionBtn setTitle:@"已关注" forState:UIControlStateSelected];
        [_attentionBtn addTarget:self action:@selector(attentionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_attentionBtn];
        [_attentionBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(superView.mas_top).with.offset(15);
            make.width.equalTo(@44);
            make.height.equalTo(@20);
            make.right.equalTo(superView.mas_right).with.offset(-20);
        }];
        
        _evaluationView = [[EvaluationView alloc] initWithFrame:CGRectMake(0, 55, kFrameWidth, 167)];
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
//        [self.contentView addSubview:_collectBtn];
        
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
        [self.contentView addSubview:_commentBtn];
        
        _tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, kFrameWidth - 80, 30)];
        [_tagLabel setText:@"商品标签:"];
        [_tagLabel setTextColor:CustomGreenColor];
        [_tagLabel setBackgroundColor:[UIColor clearColor]];
        [_tagLabel setFont:[UIFont systemFontOfSize:FS_PC_TAG]];
        [_tagLabel setTextAlignment:NSTextAlignmentLeft];
        [_tagLabel setHidden:YES];
//        [self.contentView addSubview:_tagLabel];
        
        _tagBtnArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < 2; i++) {
            UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tagBtn.titleLabel.font = [UIFont systemFontOfSize:FS_PC_TAG];
            [tagBtn setTitleColor:CustomGreenColor forState:UIControlStateNormal];
            [tagBtn setTitleColor:CustomGreenColor forState:UIControlStateSelected];
            [tagBtn setTitleColor:Gray102Color forState:UIControlStateDisabled];
            [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:tagBtn];
            [_tagBtnArr addObject:tagBtn];
        }
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 0.5)];
        [_lineView setBackgroundColor:LineViewColor];
        [self.contentView addSubview:_lineView];
        
    }
    return self;
}

- (void)zanBtnClick:(UIButton *)sender {
    NSString *titleStr = @"";
    if ([_zanBtn isSelected]) {
        [_zanBtn setSelected:NO];
        titleStr = [NSString stringWithFormat:@"%ld", (long)_circleInfoModel.praiseNum-1];
    } else {
        [_zanBtn setSelected:YES];
        titleStr = [NSString stringWithFormat:@"%ld", (long)_circleInfoModel.praiseNum+1];
    }
    [_zanBtn setTitle:titleStr forState:UIControlStateNormal];
    [_zanBtn setTitle:titleStr forState:UIControlStateSelected];
    [self.myDelegate sendUserZanRequest:_circleInfoModel.type itemId:_circleInfoModel.itemId];
}

- (void)headImagePress:(UITapGestureRecognizer *)tap {
    [self.myDelegate headImageClick:_circleInfoModel];
}

- (void)commentBtnClick:(UIButton *)sender {
    [self.myDelegate commentButtonClick:_circleInfoModel];
}

- (void)collectBtnClick:(UIButton *)sender {
    [_collectBtn setSelected:![_collectBtn isSelected]];
    [self.myDelegate sendUserCollectRequest:_circleInfoModel.type itemId:_circleInfoModel.itemId];
}

- (void)attentionBtnClick:(UIButton *)sender {
    [self.myDelegate sendUserAttentionRequest:_circleInfoModel.evaluateUserId];
}

- (void)tagBtnClick:(UIButton *)sender {
    long goodsId = [sender tag];
    [self.myDelegate getTagGoodsRequest:goodsId];
}

//- (void)bindCellWithDataModel:(CircleInfoModel *)circleInfo hideTag:(BOOL)isHideTag {
//    [self bindCellWithDataModel:circleInfo hideTag:isHideTag isCircleList:NO];
//}

- (void)bindCellWithDataModel:(CircleInfoModel *)circleInfo hideTag:(BOOL)isHideTag isCircleList:(BOOL)circleList {
    _circleInfoModel = circleInfo;
    if (circleInfo.type == InfoType_Evaluation) {
        float cellHeight = [circleInfo getCircleInfoCellHeight:isHideTag isCircleList:circleList];
        
        CGRect zanBtnFrame = _zanBtn.frame;
        [_zanBtn setFrame:CGRectMake(zanBtnFrame.origin.x, cellHeight - 27, zanBtnFrame.size.width, zanBtnFrame.size.height)];
        NSString *titleStr = [NSString stringWithFormat:@"%ld", (long)circleInfo.praiseNum];
        [_zanBtn setTitle:titleStr forState:UIControlStateNormal];
        [_zanBtn setTitle:titleStr forState:UIControlStateSelected];
        [_zanBtn setSelected:(circleInfo.isPraised==1?YES:NO)];

        [_collectBtn setSelected:(circleInfo.isLike==1?YES:NO)];
        
        CGRect colRect = [_collectBtn frame];
        [_collectBtn setFrame:CGRectMake(CGRectGetMaxX(_zanBtn.frame)+5, CGRectGetMinY(_zanBtn.frame), colRect.size.width, colRect.size.height)];
        
        if (circleInfo.isConcerned == ConcernedState_HuFen) {
            [_attentionBtn setTitle:@"已互粉" forState:UIControlStateNormal];
            [_attentionBtn setTitleColor:Gray102Color forState:UIControlStateNormal];
        } else if (circleInfo.isConcerned == ConcernedState_Attentioned) {
            [_attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
            [_attentionBtn setTitleColor:Gray102Color forState:UIControlStateNormal];
        } else {
            [_attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
            [_attentionBtn setTitleColor:CustomGreenColor forState:UIControlStateNormal];
        }
        
        if ([circleInfo.evaluateUserId isEqualToString:[QiuPaiUserModel getUserInstance].userId]) {
            [_attentionBtn setHidden:YES];
        } else {
            [_attentionBtn setHidden:NO];
        }
        
        CGRect commentBtnFrame = _commentBtn.frame;
        [_commentBtn setFrame:CGRectMake(commentBtnFrame.origin.x, cellHeight - 27, commentBtnFrame.size.width, commentBtnFrame.size.height)];
        
        CGRect frame = [@"商品标签:" boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FS_PC_TAG]} context:nil];
        [_tagLabel setFrame:CGRectMake(10, cellHeight - 30, frame.size.width, 22)];
        
        if (!isHideTag) {
            NSArray *tagArr = [circleInfo.tagInfo objectFromJSONString];
            float xPosi = 10;
            float yPosi = cellHeight - 30;
            for (int i = 0; i < [_tagBtnArr count]; i++) {
                if (i < [tagArr count]) {
                    NSDictionary *objDic = [tagArr objectAtIndex:i];
                    if ([objDic isKindOfClass:[NSDictionary class]]) {
                        int goodsId = [[objDic objectForKey:@"goodsId"] intValue]; //商品Id
                        //            int isPrivilege = [[objDic objectForKey:@"isPrivilege"] intValue]; //是否特惠 0否1是
                        NSString *goodsName = [objDic objectForKey:@"goodsName"]; //商品名
                        
                        UIButton *tagBtn = [_tagBtnArr objectAtIndex:i];
                        [tagBtn setHidden:NO];
                        if ([[objDic objectForKey:@"isSelfDefine"] intValue] == SelfDefine_YES) {
                            //是否自定义标签 0否1是
                            [tagBtn setEnabled:NO];
                        } else {
                            [tagBtn setEnabled:YES];
                        }
                        [tagBtn setTitle:goodsName forState:UIControlStateNormal];
                        [tagBtn setTitle:goodsName forState:UIControlStateSelected];
                        [tagBtn setTitle:goodsName forState:UIControlStateDisabled];
                        [tagBtn setTag:goodsId];
                        [tagBtn sizeToFit];
                        
                        CGRect btnFrame = tagBtn.frame;
                        btnFrame.origin.x = xPosi;
                        btnFrame.origin.y = yPosi;
                        [tagBtn setFrame:btnFrame];
                        [self.contentView addSubview:tagBtn];
                        xPosi = CGRectGetMaxX(tagBtn.frame);
                        
                        if (i != [tagArr count]-1) {
                            UILabel *commaLabel = [self.contentView viewWithTag:-(100+i)];
                            if (commaLabel == nil) {
                                commaLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPosi, yPosi, 20, 20)];
                                [commaLabel setTag:-(100+i)];
                                [self.contentView addSubview:commaLabel];
                            }
                            CGRect commaFrame = commaLabel.frame;
                            commaFrame.origin.x = xPosi;
                            commaFrame.origin.y = yPosi;
                            [commaLabel setFrame:commaFrame];
                            [commaLabel setHidden:NO];
                            [commaLabel setText:@", "];
                            [commaLabel setFont:[UIFont systemFontOfSize:FS_PC_TAG]];
                            [commaLabel sizeToFit];
                            xPosi = CGRectGetMaxX(commaLabel.frame);
                        } else {
                            UILabel *commaLabel = [self.contentView viewWithTag:-(100+i)];
                            if (commaLabel) {
                                [commaLabel setHidden:YES];
                            }
                        }
                    }
                } else {
                    UIButton *tagBtn = [_tagBtnArr objectAtIndex:i];
                    [tagBtn setHidden:YES];
                    UILabel *commaLabel = [self.contentView viewWithTag:-(100+i)];
                    if (commaLabel) {
                        [commaLabel setHidden:YES];
                    }
                }
            }
        }
        
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:circleInfo.evaluateUserURL] placeholderImage:[UIImage imageNamed:@"placeholder_head.png"]];
    
        if (circleInfo.evaluateName) {
            [_nameLabel setText:circleInfo.evaluateName];
            [_nameLabel sizeToFit];
        }
        [_playYearLabel setText:[NSString stringWithFormat:@"球龄%@年", circleInfo.playYear]];
        [_playYearLabel sizeToFit];
        
        NSArray *picArr = [circleInfo.picUrl objectFromJSONString];
        NSArray *thumbPicArr = [circleInfo.thumbPicUrl objectFromJSONString];
        [_evaluationView setPicArr:picArr thumbPicArray:thumbPicArr title:circleInfo.title contentStr:circleInfo.content isCircleList:YES];
        
        CGRect lineViewFrame = [_lineView frame];
        lineViewFrame.origin.y = cellHeight-0.5;
        [_lineView setFrame:lineViewFrame];
    }
}

- (void)bindUserHomeCellWithDataModel:(CircleInfoModel *)circleInfo {
    _circleInfoModel = circleInfo;
    if (circleInfo.type == InfoType_Evaluation) {
        float cellHeight = [circleInfo getUserHomePageCellHeight];
        CGRect zanBtnFrame = _zanBtn.frame;
        [_zanBtn setFrame:CGRectMake(zanBtnFrame.origin.x, cellHeight - 27, zanBtnFrame.size.width, zanBtnFrame.size.height)];
        NSString *titleStr = [NSString stringWithFormat:@"%ld", (long)circleInfo.praiseNum];
        [_zanBtn setTitle:titleStr forState:UIControlStateNormal];
        [_zanBtn setTitle:titleStr forState:UIControlStateSelected];
        [_zanBtn setSelected:(circleInfo.isPraised==1?YES:NO)];
        [_collectBtn setSelected:(circleInfo.isLike==1?YES:NO)];
        
        CGRect colRect = [_collectBtn frame];
        [_collectBtn setFrame:CGRectMake(CGRectGetMaxX(_zanBtn.frame)+5, CGRectGetMinY(_zanBtn.frame), colRect.size.width, colRect.size.height)];
        
        CGRect commentBtnFrame = _commentBtn.frame;
        [_commentBtn setFrame:CGRectMake(commentBtnFrame.origin.x, cellHeight - 27, commentBtnFrame.size.width, commentBtnFrame.size.height)];
        
        CGRect frame = [@"商品标签:" boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FS_PC_TAG]} context:nil];
        [_tagLabel setFrame:CGRectMake(10, cellHeight - 30, frame.size.width, 22)];
        
        NSArray *tagArr = [circleInfo.tagInfo objectFromJSONString];
        float xPosi = _tagLabel.frame.origin.x;
        //         + _tagLabel.frame.size.width
        float yPosi = _tagLabel.frame.origin.y ;
        for (int i = 0; i < [tagArr count]; i++) {
            NSDictionary *objDic = [tagArr objectAtIndex:i];
            if ([objDic isKindOfClass:[NSDictionary class]]) {
                int goodsId = [[objDic objectForKey:@"goodsId"] intValue]; //商品Id
                //            int isPrivilege = [[objDic objectForKey:@"isPrivilege"] intValue]; //是否特惠 0否1是
                NSString *goodsName = [objDic objectForKey:@"goodsName"]; //商品名
                
                UIButton *tagBtn = [_tagBtnArr objectAtIndex:i];
                if ([[objDic objectForKey:@"isSelfDefine"] intValue] == SelfDefine_YES) {
                    //是否自定义标签 0否1是
                    [tagBtn setEnabled:NO];
                } else {
                    [tagBtn setEnabled:YES];
                }
                [tagBtn setTitle:goodsName forState:UIControlStateNormal];
                [tagBtn setTitle:goodsName forState:UIControlStateSelected];
                [tagBtn setTitle:goodsName forState:UIControlStateDisabled];
                [tagBtn setTag:goodsId];
                [tagBtn sizeToFit];
                
                CGRect btnFrame = tagBtn.frame;
                btnFrame.origin.x = xPosi;
                btnFrame.origin.y = yPosi;
                [tagBtn setFrame:btnFrame];
                [self.contentView addSubview:tagBtn];
                xPosi = CGRectGetMaxX(tagBtn.frame);
                
                if (i != [tagArr count]-1) {
                    UILabel *commaLabel = [self.contentView viewWithTag:-(100+i)];
                    if (commaLabel == nil) {
                        commaLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPosi, yPosi, 20, 20)];
                        [commaLabel setTag:-(100+i)];
                        [self.contentView addSubview:commaLabel];
                    }
                    CGRect commaFrame = commaLabel.frame;
                    commaFrame.origin.x = xPosi;
                    commaFrame.origin.y = yPosi;
                    [commaLabel setFrame:commaFrame];
                    [commaLabel setHidden:NO];
                    [commaLabel setText:@", "];
                    [commaLabel setFont:[UIFont systemFontOfSize:FS_PC_TAG]];
                    [commaLabel sizeToFit];
                    xPosi = CGRectGetMaxX(commaLabel.frame);
                } else {
                    UILabel *commaLabel = [self.contentView viewWithTag:-(100+i)];
                    if (commaLabel) {
                        [commaLabel setHidden:YES];
                    }
                }
            }
        }
        
        NSArray *picArr = [circleInfo.picUrl objectFromJSONString];
        NSArray *thumbPicArr = [circleInfo.thumbPicUrl objectFromJSONString];
        [_evaluationView setPicArr:picArr thumbPicArray:thumbPicArr title:circleInfo.title contentStr:circleInfo.content isCircleList:YES];
        
        CGRect evaluViewFrame = [_evaluationView frame];
        evaluViewFrame.origin.y = 5;
        [_evaluationView setFrame:evaluViewFrame];
        
        CGRect lineViewFrame = [_lineView frame];
        lineViewFrame.origin.y = cellHeight-0.5;
        [_lineView setFrame:lineViewFrame];
        
        [_evaluationView mas_updateConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(@3);
        }];
    }
    
    [_attentionBtn setHidden:YES];
    [_headImageView setHidden:YES];
    [_nameLabel setHidden:YES];
    [_playYearLabel setHidden:YES];

}

- (void)bindEvaluLikeCellWithDataModel:(CircleInfoModel *)infoModel {
    [self bindCellWithDataModel:infoModel hideTag:NO isCircleList:YES];
}

@end
