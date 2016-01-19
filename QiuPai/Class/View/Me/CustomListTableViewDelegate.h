//
//  CustomListTableViewDelegate.h
//  QiuPai
//
//  Created by bigqiang on 15/12/12.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomListTableViewDelegate <NSObject>

/**
	cell点击进入
	@param itemId 点击对应的cell
	@returns 无返回
 */
//- (void)getTableViewDidSelectRowAtIndexPath:(NSString *)itemId pageType:(NSInteger)pageType isReply:(BOOL)isReply;
- (void)getTableViewDidSelectRowAtIndexPath:(id)dataModel tableType:(NSInteger)type isReply:(BOOL)isReply;

// 开始下拉刷新
- (void)getStartRefreshTableView:(UITableView *)tableView;

// 上推获取更多
- (void)getLoadMoreTableView:(UITableView *)tableView;

@end
