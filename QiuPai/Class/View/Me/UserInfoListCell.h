//
//  UserInfoListCell.h
//  QiuPai
//
//  Created by bigqiang on 15/11/24.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleUserInfoModel.h"
#import "TableViewCellInteractionDelegate.h"

@interface UserInfoListCell : UITableViewCell

@property (nonatomic, weak) id<TableViewCellInteractionDelegate> myDelegate;

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) UILabel *sexLabel;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *playYearLabel;
@property (nonatomic, strong) UIButton *attentionBtn;

- (void)bindCellWithDataModel:(SimpleUserInfoModel *)infoModel isFansVC:(BOOL)isFansVC;

@end
