//
//  LikeListCell.m
//  QiuPai
//
//  Created by bigqiang on 15/11/22.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "LikeListCell.h"
#import "QiuPaiUserModel.h"
#import "UIImageView+WebCache.h"

@interface LikeListCell(){
    UILabel *_nameLabel;
    UIImageView *_headImageView;
    
    UILabel *_selfNameLabel;
    UILabel *_contentLabel;
    
    UIImageView *_panelView;

    UIView *_lineView;
}

@end

@implementation LikeListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, kFrameWidth - 36, 50)];
        [_nameLabel setTextColor:Gray51Color];
//        _nameLabel.numberOfLines = 0;
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_nameLabel];
        
        CGFloat panelViewW = kFrameWidth - 22 - 13.0;
        //        CGFloat panelViewH = panelViewW*53/340;
        CGFloat panelViewH = 53;
        _panelView = [[UIImageView alloc] initWithFrame:CGRectMake(22, 54, panelViewW, panelViewH)];
        [_panelView setImage:[UIImage imageNamed:@"message_like_panel.png"]];
        [self.contentView addSubview:_panelView];
        
        CGFloat oriHeadImageWidth = 40*340.0/panelViewW;
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, panelViewH/2 - oriHeadImageWidth/2+2, oriHeadImageWidth, oriHeadImageWidth)];
        [_panelView addSubview:_headImageView];
        
        UIEdgeInsets padding = UIEdgeInsetsMake(7.0f, 3.0f, 3.0f, 0);
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_panelView.mas_top).with.offset(padding.top); //with is an optional semantic filler
            make.left.equalTo(_panelView.mas_left).with.offset(padding.left);
            make.bottom.equalTo(_panelView.mas_bottom).with.offset(-padding.bottom);
            make.width.equalTo(_headImageView.mas_height).with.offset(0);
        }];
        
        _selfNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headImageView.frame) + 5, CGRectGetMinY(_headImageView.frame), kFrameWidth - 100, 16)];
        [_selfNameLabel setTextColor:Gray102Color];
        [_selfNameLabel setBackgroundColor:[UIColor clearColor]];
        [_selfNameLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_selfNameLabel setTextAlignment:NSTextAlignmentLeft];
        [_panelView addSubview:_selfNameLabel];
        [_selfNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_panelView.mas_centerY).with.offset(-CGRectGetHeight(_headImageView.frame)/4+3);
            make.left.equalTo(_headImageView.mas_right).with.offset(5.0f);
        }];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_selfNameLabel.frame), CGRectGetMaxY(_selfNameLabel.frame) + 4, panelViewW - 60, 16)];
        [_contentLabel setTextColor:Gray102Color];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_contentLabel setTextAlignment:NSTextAlignmentLeft];
        [_panelView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_selfNameLabel.mas_left);
            make.centerY.equalTo(_selfNameLabel.mas_centerY).with.offset(CGRectGetHeight(_headImageView.frame)/4+6);
            make.width.lessThanOrEqualTo(_panelView.mas_width).with.offset(-CGRectGetWidth(_headImageView.frame)-8);
        }];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, kFrameWidth, 0.5)];
        [_lineView setBackgroundColor:LineViewColor];
        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindCellWithDataModel:(MessageLikeModel *) infoModel {
    NSMutableString *nameStr = [NSMutableString stringWithFormat:@""];
    NSArray *likeListArr = infoModel.praiseList;
    for (NSDictionary *dic in likeListArr) {
        [nameStr appendFormat:@"%@,", [dic objectForKey:@"name"]];
    }
    NSString *tmpStr = @"";
    if ([likeListArr count] > 0) {
        tmpStr = [nameStr substringWithRange:NSMakeRange(0, [nameStr length] - 1)];
    }
    NSString *str = [NSString stringWithFormat:@"%@喜欢了你的评测", tmpStr];
    [_nameLabel setText:str];
    [_nameLabel sizeToFit];
    
    CGRect oriPanelFrame = [_panelView frame];
    oriPanelFrame.origin.y = CGRectGetMaxY(_nameLabel.frame) + 6;
    [_panelView setFrame:oriPanelFrame];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:[QiuPaiUserModel getUserInstance].headPic] placeholderImage:[UIImage imageNamed:@"placeholder_head.png"]];
    [_selfNameLabel setText:[NSString stringWithFormat:@"@%@", [[QiuPaiUserModel getUserInstance] nick]]];
    [_contentLabel setText:infoModel.content];
    
    CGFloat cellHeight = [infoModel getMessageCellHeight];
    [_lineView setFrame:CGRectMake(0, cellHeight - 0.5, kFrameWidth, 0.5f)];
}

@end
