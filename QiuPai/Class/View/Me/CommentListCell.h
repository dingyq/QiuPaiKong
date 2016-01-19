//
//  CommentListCell.h
//  QiuPai
//
//  Created by bigqiang on 15/11/22.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCommentModel.h"

@protocol CommentListCellDelegate <NSObject>

@optional
- (void)replyButtonClick:(MessageCommentModel *)infoModel;

@end

@interface CommentListCell : UITableViewCell

@property (nonatomic, weak) id<CommentListCellDelegate> myDelegate;

- (void)bindCellWithDataModel:(MessageCommentModel *) infoModel;

@end
