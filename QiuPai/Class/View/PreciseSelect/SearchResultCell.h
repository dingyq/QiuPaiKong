//
//  SearchResultCell.h
//  QiuPai
//
//  Created by bigqiang on 15/12/6.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RacketSearchModel.h"
#import "TableViewCellInteractionDelegate.h"

@interface SearchResultCell : UITableViewCell
@property (nonatomic, weak) id<TableViewCellInteractionDelegate> myDelegate;

- (void)bindCellWithDataModel:(RacketSearchModel *) infoModel showBuyBtn:(BOOL)isShow;

- (void)showLoadMoreTip:(GoodsSearchType)searchType;
@end
