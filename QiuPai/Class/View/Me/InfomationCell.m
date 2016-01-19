//
//  InfomationCell.m
//  QiuPai
//
//  Created by bigqiang on 15/11/23.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "InfomationCell.h"
#import "UIImageView+WebCache.h"

@interface InfomationCell(){
    UIView *_upLine;
}

@end

@implementation InfomationCell
@synthesize tipLabel = _tipLabel;
@synthesize valueLabel = _valueLabel;
@synthesize headImageView = _headImageView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 12, kFrameWidth/2, 20)];
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        [_tipLabel setTextColor:Gray51Color];
        [_tipLabel setBackgroundColor:[UIColor clearColor]];
        [_tipLabel setFont:[UIFont systemFontOfSize:15]];
        [_tipLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:_tipLabel];
        
        _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kFrameWidth/2, 12, kFrameWidth/2 - 35, 20)];
        _valueLabel.textAlignment = NSTextAlignmentRight;
        [_valueLabel setTextColor:Gray153Color];
        [_valueLabel setBackgroundColor:[UIColor clearColor]];
        [_valueLabel setFont:[UIFont systemFontOfSize:15]];
        [_valueLabel setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_valueLabel];
        
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kFrameWidth - 70, 4, 35, 35)];
        _headImageView.layer.cornerRadius = 35.0/2;
        _headImageView.layer.borderWidth = 1;
        _headImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _headImageView.clipsToBounds = YES;
        [_headImageView setHidden:YES];
        [self.contentView addSubview:_headImageView];
        
        
        _upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 0.5)];
        [_upLine setBackgroundColor:LineViewColor];
        [_upLine setHidden:YES];
        [self.contentView addSubview:_upLine];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(9, 42.5, kFrameWidth-9, 0.5)];
        [_lineView setBackgroundColor:LineViewColor];
        [self.contentView addSubview:_lineView];
    }
    
    return self;
}

- (void)bindCellWithData:(NSString *)tipStr valueStr:(NSString *)valueStr indexPath:(NSIndexPath*)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        [_valueLabel setHidden:YES];
        [_headImageView setHidden:NO];
        
        [_tipLabel setText:tipStr];
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:valueStr] placeholderImage:[UIImage imageNamed:@"placeholder_head.png"]];
    } else {
        [_valueLabel setHidden:NO];
        [_headImageView setHidden:YES];
        [_tipLabel setText:tipStr];
        [_valueLabel setText:valueStr];
    }
    
    if (indexPath.row == 0) {
        [_upLine setHidden:NO];
    } else {
        [_upLine setHidden:YES];
    }
    
    if ((indexPath.row == 4 && indexPath.section == 0) || (indexPath.row == 2 && indexPath.section == 1)) {
        [_lineView setFrame:CGRectMake(0, 42.5, kFrameWidth, 0.5)];
    } else {
        [_lineView setFrame:CGRectMake(9, 42.5, kFrameWidth-9, 0.5)];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
