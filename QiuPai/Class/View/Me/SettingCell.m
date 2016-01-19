//
//  SettingCell.m
//  QiuPai
//
//  Created by bigqiang on 15/12/12.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "SettingCell.h"

@interface SettingCell() {
}

@end

@implementation SettingCell


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
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(9, 42.5, kFrameWidth-9, 0.5)];
        [_lineView setBackgroundColor:LineViewColor];
        [_lineView setHidden:YES];
        [self.contentView addSubview:_lineView];
    }
    
    return self;
}

- (void)bindCellWithData:(NSString *)tipStr valueStr:(NSString *)valueStr indexPath:(NSIndexPath*)indexPath {
    [_valueLabel setHidden:YES];
    [_tipLabel setText:tipStr];
    [_tipLabel setFrame:CGRectMake(9, 12, kFrameWidth/2, 20)];
    [_tipLabel setTextColor:Gray51Color];
    [_tipLabel setTextAlignment:NSTextAlignmentLeft];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
            //消息推送开关
//            self.accessoryType = UITableViewCellAccessoryNone;
//        } else {
            [_valueLabel setHidden:NO];
            [_valueLabel setText:valueStr];
//        }
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        [_lineView setHidden:NO];
    } else if (indexPath.section == 2) {
        // 退出登录
        [_tipLabel setFrame:CGRectMake(0, 12, kFrameWidth, 20)];
        [_tipLabel setTextColor:mUIColorWithRGB(227, 39, 39)];
        [_tipLabel setTextAlignment:NSTextAlignmentCenter];
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
