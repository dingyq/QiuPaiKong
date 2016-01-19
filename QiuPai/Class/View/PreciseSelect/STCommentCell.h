//
//  STCommentCell.h
//  QiuPai
//
//  Created by bigqiang on 15/12/10.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STCommentModel.h"
#import "UserMessageModel.h"

@interface STCommentCell : UITableViewCell

- (void)bindCellWithDataModel:(STCommentModel *) infoModel;

- (void)bindMessageCellWithDataModel:(UserMessageModel *)infoModel;

@end
