//
//  InfomationCell.h
//  QiuPai
//
//  Created by bigqiang on 15/11/23.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfomationCell : UITableViewCell

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIView *lineView;

- (void)bindCellWithData:(NSString *)tipStr valueStr:(NSString *)valueStr indexPath:(NSIndexPath*)indexPath;
@end
