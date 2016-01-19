//
//  PreciseSelectTVCell.h
//  QiuPai
//
//  Created by bigqiang on 15/11/21.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCellInteractionDelegate.h"

@class RacketCollectionInfoModel;
@interface PreciseSelectTVCell : UITableViewCell
@property (nonatomic, weak) id<TableViewCellInteractionDelegate> myDelegate;

- (void)bindCellWithDataModel:(RacketCollectionInfoModel *)rciModel;
@end
