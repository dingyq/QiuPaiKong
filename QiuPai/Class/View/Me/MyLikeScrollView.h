//
//  MyLikeScrollView.h
//  QiuPai
//
//  Created by bigqiang on 15/11/21.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLikeListTableView.h"
#import "SegmentControllView.h"
#import "CustomListTableViewDelegate.h"

@interface MyLikeScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) MyLikeListTableView *evaluationListTV;
@property (nonatomic, strong) MyLikeListTableView *specialTopicListTV;
@property (nonatomic, strong) MyLikeListTableView *goodsListTV;

@property (nonatomic, weak) id<CustomListTableViewDelegate>listViewDelegate;

- (void)reloadEvaluationView:(NSMutableArray *)evaluArr hasMoreData:(BOOL)hasMore isNeedReload:(BOOL)isNeed ;

- (void)reloadGoodsView:(NSMutableArray *)goodsArr hasMoreData:(BOOL)hasMore isNeedReload:(BOOL)isNeed ;

- (void)reloadSpecialTopicView:(NSMutableArray *)stArr hasMoreData:(BOOL)hasMore isNeedReload:(BOOL)isNeed ;

@end
