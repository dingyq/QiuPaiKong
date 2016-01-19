//
//  MessageScrollView.h
//  QiuPai
//
//  Created by bigqiang on 15/11/21.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageListTableView.h"
#import "SegmentControllView.h"

@interface MessageScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) MessageListTableView *replyListTV;
@property (nonatomic, strong) MessageListTableView *likeListTV;

@property (nonatomic, weak) id<CustomListTableViewDelegate>listViewDelegate;

- (void)reloadCommentView:(NSMutableArray *)commentArr hasMoreData:(BOOL)hasMore isNeedReload:(BOOL)isNeed;

- (void)reloadLikeView:(NSMutableArray *)likeArr hasMoreData:(BOOL)hasMore isNeedReload:(BOOL)isNeed;


@end
