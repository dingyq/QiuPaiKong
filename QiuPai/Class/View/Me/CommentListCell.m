//
//  CommentListCell.m
//  QiuPai
//
//  Created by bigqiang on 15/11/22.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "CommentListCell.h"
#import "QiuPaiUserModel.h"
#import "UIImageView+WebCache.h"

@interface CommentListCell(){
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UIButton *_replyBtn;
    UILabel *_contentLabel;
    UIImageView *_headImageView;
    
    UILabel *_selfNameLabel;
    UILabel *_oriContentLabel;
    
    UIImageView *_panelView;
    UIImageView *_oriHeadImageView;
    
    UIView *_lineView;
}

@property (nonatomic, weak) MessageCommentModel *commentModel;

@end

@implementation CommentListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *superView = self.contentView;
        
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 11, 32, 32)];
        _headImageView.layer.cornerRadius = 16;
        [_headImageView setClipsToBounds:YES];
        [self.contentView addSubview:_headImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(46, 16, kFrameWidth - 100, 16)];
        [_nameLabel setTextColor:Gray85Color];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:FS_PL_NAME]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_nameLabel];
        
        _replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_replyBtn setFrame:CGRectMake(kFrameWidth - 46, 12, 30, 16)];
        _replyBtn.titleLabel.font = [UIFont systemFontOfSize:FS_PC_BUTTON];
        [_replyBtn setTitleColor:CustomGreenColor forState:UIControlStateNormal];
        [_replyBtn setTitleColor:CustomGreenColor forState:UIControlStateHighlighted];
        [_replyBtn setTitle:@"回复" forState:UIControlStateNormal];
        [_replyBtn setTitle:@"回复" forState:UIControlStateHighlighted];
        [_replyBtn setBackgroundColor:[UIColor clearColor]];
        [_replyBtn addTarget:self action:@selector(replyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_replyBtn];
        [_replyBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(superView.mas_right).with.offset(-15);
            make.top.equalTo(superView.mas_top).with.offset(12);
            make.width.equalTo(@30);
            make.height.equalTo(@16);
        }];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, 36, kFrameWidth - 46-19, 30)];
        [_contentLabel setTextColor:Gray51Color];
        _contentLabel.numberOfLines = 0;
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setFont:[UIFont systemFontOfSize:FS_PL_CONTENT]];
        [_contentLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.mas_left);
            make.top.equalTo(_nameLabel.mas_bottom).with.offset(5);
            make.height.lessThanOrEqualTo(@(FS_PL_CONTENT*2+10));
            make.width.lessThanOrEqualTo(@(kFrameWidth-46-19));
        }];
        
        CGFloat panelViewW = kFrameWidth - 46 - 19.0;
//        CGFloat panelViewH = panelViewW*51/310;
        CGFloat panelViewH = 51;
        _panelView = [[UIImageView alloc] initWithFrame:CGRectMake(46, 82, panelViewW, panelViewH)];
        [_panelView setImage:[UIImage imageNamed:@"message_comment_panel.png"]];
        [self.contentView addSubview:_panelView];
        [_panelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_contentLabel.mas_left);
            make.top.equalTo(_contentLabel.mas_bottom).with.offset(3);
            make.width.equalTo(@(panelViewW));
            make.height.equalTo(@(panelViewH));
        }];
        
        CGFloat oriHeadImageWidth = 40*310.0/panelViewW;
        _oriHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, panelViewH/2 - oriHeadImageWidth/2+2, oriHeadImageWidth, oriHeadImageWidth)];
        [_panelView addSubview:_oriHeadImageView];
        UIEdgeInsets padding = UIEdgeInsetsMake(7.0f, 3.0f, 3.0f, 0);
        [_oriHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_panelView.mas_top).with.offset(padding.top); //with is an optional semantic filler
            make.left.equalTo(_panelView.mas_left).with.offset(padding.left);
            make.bottom.equalTo(_panelView.mas_bottom).with.offset(-padding.bottom);
            make.width.equalTo(_oriHeadImageView.mas_height).with.offset(0);
        }];
        
        _selfNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_oriHeadImageView.frame) + 5, CGRectGetMinY(_oriHeadImageView.frame), 80, 16)];
        [_selfNameLabel setTextColor:Gray102Color];
        [_selfNameLabel setBackgroundColor:[UIColor clearColor]];
        [_selfNameLabel setFont:[UIFont systemFontOfSize:FS_PL_SELF_NAME]];
        [_selfNameLabel setTextAlignment:NSTextAlignmentLeft];
        [_panelView addSubview:_selfNameLabel];
        [_selfNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_panelView.mas_centerY).with.offset(-CGRectGetHeight(_oriHeadImageView.frame)/4+3);
            make.left.equalTo(_oriHeadImageView.mas_right).with.offset(5.0f);
        }];
        
        _oriContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_selfNameLabel.frame), CGRectGetMaxY(_selfNameLabel.frame) + 4, panelViewW - 60, 16)];
        [_oriContentLabel setTextColor:Gray51Color];
        [_oriContentLabel setBackgroundColor:[UIColor clearColor]];
        [_oriContentLabel setFont:[UIFont systemFontOfSize:FS_PL_ORI_CONTENT]];
        [_oriContentLabel setTextAlignment:NSTextAlignmentLeft];
        [_panelView addSubview:_oriContentLabel];
        [_oriContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_selfNameLabel.mas_left);
            make.centerY.equalTo(_selfNameLabel.mas_centerY).with.offset(CGRectGetHeight(_oriHeadImageView.frame)/4+6);
            make.width.lessThanOrEqualTo(_panelView.mas_width).with.offset(-CGRectGetWidth(_oriHeadImageView.frame)-8);
        }];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kFrameWidth - 78, 144, 70, 15)];
        [_timeLabel setTextColor:Gray153Color];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:FS_PL_TIME]];
        [_timeLabel setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(superView.mas_right).with.offset(-17);
            make.top.equalTo(_panelView.mas_bottom).with.offset(6.0f);
//            make.width.equalTo(@70);
            make.height.equalTo(@15);
        }];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, kFrameWidth, 0.5)];
        [_lineView setBackgroundColor:LineViewColor];
        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)replyButtonClick:(UIButton *)sender {
    [self.myDelegate replyButtonClick:_commentModel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindCellWithDataModel:(MessageCommentModel *)infoModel {
    _commentModel = infoModel;
    
    CGFloat cellHeight = [infoModel getMessageCellHeight];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.commentUserThumbURL] placeholderImage:[UIImage imageNamed:@"placeholder_head.png"]];
   
    [_nameLabel setText:infoModel.commentName];
    [_nameLabel sizeToFit];

    NSString *strDate1 = [NSDate formatSecondsSince1970ToDateString:infoModel.commentTime];
    [_timeLabel setText:strDate1];
    [_timeLabel sizeToFit];
    
    [_contentLabel setText:infoModel.content];
    [_oriHeadImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.oriThumbPicUrl] placeholderImage:[UIImage imageNamed:@"placeholder_head.png"]];
    [_selfNameLabel setText:[NSString stringWithFormat:@"@%@", [[QiuPaiUserModel getUserInstance] nick]]];
    [_oriContentLabel setText:infoModel.oriContent];
    [_lineView setFrame:CGRectMake(0, cellHeight - 0.5, kFrameWidth, 0.5f)];
}


@end
