//
//  UserInfoListCell.m
//  QiuPai
//
//  Created by bigqiang on 15/11/24.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "UserInfoListCell.h"
#import "UIImageView+WebCache.h"

@interface UserInfoListCell() {
    NSString *_userId;
}

@end

@implementation UserInfoListCell
@synthesize headImageView = _headImageView;
@synthesize levelLabel = _levelLabel;
@synthesize nameLabel = _nameLabel;
@synthesize sexLabel = _sexLabel;
@synthesize ageLabel = _ageLabel;
@synthesize playYearLabel = _playYearLabel;
@synthesize attentionBtn = _attentionBtn;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 10, 51, 51)];
        [self.contentView addSubview:_headImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 18, kFrameWidth - 130, 20)];
        [_nameLabel setTextColor:Gray51Color];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_nameLabel];
        
        _levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame) + 3, 0, 20)];
        [_levelLabel setTextColor:Gray153Color];
        [_levelLabel setBackgroundColor:[UIColor clearColor]];
        [_levelLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_levelLabel setTextAlignment:NSTextAlignmentLeft];
//        [self.contentView addSubview:_levelLabel];
        
        _sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, kFrameWidth/2, 20)];
        [_sexLabel setTextColor:Gray51Color];
        [_sexLabel setBackgroundColor:[UIColor clearColor]];
        [_sexLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_sexLabel setTextAlignment:NSTextAlignmentLeft];
//        [self.contentView addSubview:_sexLabel];
        
        _ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, kFrameWidth/2, 20)];
        [_ageLabel setTextColor:Gray51Color];
        [_ageLabel setBackgroundColor:[UIColor clearColor]];
        [_ageLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_ageLabel setTextAlignment:NSTextAlignmentLeft];
//        [self.contentView addSubview:_ageLabel];
        
        _playYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_levelLabel.frame), CGRectGetMinY(_levelLabel.frame), kFrameWidth/2, 20)];
        [_playYearLabel setTextColor:Gray153Color];
        [_playYearLabel setBackgroundColor:[UIColor clearColor]];
        [_playYearLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_playYearLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_playYearLabel];
        
        _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attentionBtn setFrame:CGRectMake(kFrameWidth - 50 - 13, 18, 50, 34)];
        [_attentionBtn setImage:[UIImage imageNamed:@"add_attention_btn.png"] forState:UIControlStateNormal];
        [_attentionBtn setImage:[UIImage imageNamed:@"add_attention_btn.png"] forState:UIControlStateSelected];
        [_attentionBtn setImage:[UIImage imageNamed:@"add_attention_btn.png"] forState:UIControlStateHighlighted];
        _attentionBtn.layer.borderColor = Gray220Color.CGColor;
        _attentionBtn.layer.borderWidth = 0.5f;
        _attentionBtn.layer.cornerRadius = 2.0f;
        [_attentionBtn addTarget:self action:@selector(attentionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_attentionBtn];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 72 -0.5, kFrameWidth, 0.5)];
        [lineView setBackgroundColor:LineViewColor];
        [lineView setTag:100];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)bindCellWithDataModel:(SimpleUserInfoModel *)infoModel isFansVC:(BOOL)isFansVC{
    _userId = infoModel.itemId;
    
    CGFloat cellHeight = [infoModel getCellHeight];
    UIView *lineView = [self.contentView viewWithTag:100];
    [lineView setFrame:CGRectMake(0, cellHeight - 0.5, kFrameWidth, 0.5)];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.headPic] placeholderImage:[UIImage imageNamed:@"placeholder_head.png"]];

    [_nameLabel setText:infoModel.name];
    [_nameLabel sizeToFit];
    
//    [_levelLabel setText:@"L2"];
    [_levelLabel setText:@""];
    [_levelLabel sizeToFit];
    
    NSString *sexStr = @"男";
    if (infoModel.sex == SexIndicatorGirl) {
        sexStr = @"女";
    }
    [_sexLabel setText:sexStr];
    [_sexLabel sizeToFit];
    
    [_ageLabel setText:[NSString stringWithFormat:@"年龄%ld", (long)infoModel.age]];
    [_ageLabel sizeToFit];
    
    [_playYearLabel setText:[NSString stringWithFormat:@"球龄%ld年", (long)infoModel.playYear]];
    [_playYearLabel sizeToFit];
    
    NSString *tipImageStr = @"add_attention_btn.png";
    if (infoModel.isConcerned == ConcernedState_Attentioned) {
        tipImageStr = @"already_attentioned_btn.png";
    } else if (infoModel.isConcerned == ConcernedState_HuFen) {
        tipImageStr = @"follow_each_other_btn.png";
    }
    [_attentionBtn setImage:[UIImage imageNamed:tipImageStr] forState:UIControlStateNormal];
}

- (void)attentionBtnClick:(UIButton *)sender {
    [self.myDelegate sendUserAttentionRequest:_userId];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
