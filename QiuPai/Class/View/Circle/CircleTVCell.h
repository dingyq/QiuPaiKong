//
//  CircleTVCell.h
//  QiuPai
//
//  Created by bigqiang on 15/11/13.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCellInteractionDelegate.h"

@class CircleInfoModel;

@interface CircleTVCell : UITableViewCell

@property (nonatomic, weak) id<TableViewCellInteractionDelegate> myDelegate;

//- (void)bindCellWithDataModel:(CircleInfoModel *)circleInfo hideTag:(BOOL)isHideTag;

- (void)bindCellWithDataModel:(CircleInfoModel *)circleInfo hideTag:(BOOL)isHideTag isCircleList:(BOOL)circleList;

- (void)bindUserHomeCellWithDataModel:(CircleInfoModel *)circleInfo;

- (void)bindEvaluLikeCellWithDataModel:(CircleInfoModel *)infoModel;

@end
