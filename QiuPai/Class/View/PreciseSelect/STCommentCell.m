//
//  STCommentCell.m
//  QiuPai
//
//  Created by bigqiang on 15/12/10.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "STCommentCell.h"
#import "UIImageView+WebCache.h"

@interface STCommentCell() {
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_contentLabel;
    UIImageView *_headImageView;
    
    UIView *_lineView;
}

@end

@implementation STCommentCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 10, 32, 32)];
        _headImageView.layer.cornerRadius = 16;
        [self.contentView addSubview:_headImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(43, 10, kFrameWidth - 100, 14)];
        [_nameLabel setTextColor:Gray51Color];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_nameLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, 26, kFrameWidth - 46-19, 20)];
        [_contentLabel setTextColor:Gray85Color];
        _contentLabel.numberOfLines = 0;
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setFont:[UIFont systemFontOfSize:14.0]];
        [_contentLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_contentLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kFrameWidth - 78, 15, 70, 13)];
        [_timeLabel setTextColor:Gray153Color];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:11.0]];
        [_timeLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_timeLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 0.5)];
        [_lineView setBackgroundColor:LineViewColor];
        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)bindCellWithDataModel:(STCommentModel *) infoModel {
    CGFloat cellHeight = [infoModel getCommentCellHeight];
    
    [_lineView setFrame:CGRectMake(0, cellHeight - 0.5, kFrameWidth, 0.5)];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.commentUserThumbURL] placeholderImage:[UIImage imageNamed:@"placeholder_head.png"]];
    [_nameLabel setText:infoModel.commentName];
    
    NSString *strDate1 = [NSDate formatSecondsSince1970ToDateString:infoModel.commentTime];
    [_timeLabel setText:strDate1];
    [_timeLabel sizeToFit];
    CGRect oriTimeFrame = [_timeLabel frame];
    oriTimeFrame.origin.x = kFrameWidth - oriTimeFrame.size.width - 10;
    [_timeLabel setFrame:oriTimeFrame];
    
    CGRect oriContentFame = [_contentLabel frame];
    [_contentLabel setText:infoModel.content];
    CGRect newNameFrame = [infoModel.content boundingRectWithSize:CGSizeMake(kFrameWidth - 46-19, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    oriContentFame.size.height = newNameFrame.size.height;
    [_contentLabel setFrame:oriContentFame];
}

- (void)bindMessageCellWithDataModel:(UserMessageModel *)infoModel {
    CGFloat cellHeight = [infoModel getUserMessageCellHeight];
    
    [_lineView setFrame:CGRectMake(0, cellHeight - 0.5, kFrameWidth, 0.5)];
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.messageUserThumbURL] placeholderImage:[UIImage imageNamed:@"placeholder_head.png"]];
    [_nameLabel setText:infoModel.messageName];
    
    NSString *strDate1 = [NSDate formatSecondsSince1970ToDateString:infoModel.messageTime];
    [_timeLabel setText:strDate1];
    [_timeLabel sizeToFit];
    CGRect oriTimeFrame = [_timeLabel frame];
    oriTimeFrame.origin.x = kFrameWidth - oriTimeFrame.size.width - 10;
    [_timeLabel setFrame:oriTimeFrame];
    
    CGRect oriContentFame = [_contentLabel frame];
    [_contentLabel setText:infoModel.content];
    CGRect newNameFrame = [infoModel.content boundingRectWithSize:CGSizeMake(kFrameWidth - 46-19, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    oriContentFame.size.height = newNameFrame.size.height;
    [_contentLabel setFrame:oriContentFame];
}

@end
