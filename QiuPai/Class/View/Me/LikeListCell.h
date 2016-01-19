//
//  LikeListCell.h
//  QiuPai
//
//  Created by bigqiang on 15/11/22.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageLikeModel.h"

@interface LikeListCell : UITableViewCell

- (void)bindCellWithDataModel:(MessageLikeModel *) infoModel;

@end
