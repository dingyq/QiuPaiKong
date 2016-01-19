//
//  MessageListTableView.m
//  QiuPai
//
//  Created by bigqiang on 15/11/21.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "MessageListTableView.h"
#import "CommentListCell.h"
#import "LikeListCell.h"

@interface MessageListTableView() <CommentListCellDelegate> {

}
@end


@implementation MessageListTableView
@synthesize myDelegate = _myDelegate;
@synthesize tableArray = _tableArray;
@synthesize type = _type;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        self.tableArray = [[NSMutableArray alloc] init];
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UIView *tmpfooterView = [[UIView alloc] init];
        self.tableFooterView = tmpfooterView;
        [tmpfooterView setBackgroundColor:[UIColor clearColor]];
        [self addRefreshView];
    }
    return self;
}

- (void)addRefreshView {
    
    __weak __typeof(self)weakSelf = self;
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.myDelegate getStartRefreshTableView:weakSelf];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.myDelegate getLoadMoreTableView:weakSelf];
    }];
}

- (void)refreshAction {
    [self.myDelegate getStartRefreshTableView:self];
}

- (void)loadMoreAction {
    [self.myDelegate getLoadMoreTableView:self];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [[self.tableArray objectAtIndex:indexPath.row] getMessageCellHeight];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * kCellIdentifier = @"MessageListCell";
    if (self.type == MessageListTableTypeComment) {
        CommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        if (!cell) {
            cell = [[CommentListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        }
        cell.myDelegate = self;
        [cell bindCellWithDataModel:[self.tableArray objectAtIndex:indexPath.row]];
        return cell;
    } else {
        LikeListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        if (!cell) {
            cell = [[LikeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        }
        [cell bindCellWithDataModel:[self.tableArray objectAtIndex:indexPath.row]];
        return cell;
    }
}

#pragma mark - UITableViewDelegate -

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    id dataModel;
    if (self.type == MessageListTableTypeComment) {
        dataModel = [self.tableArray objectAtIndex:indexPath.row];
    } else{
        dataModel = [self.tableArray objectAtIndex:indexPath.row];
    }
    [self.myDelegate getTableViewDidSelectRowAtIndexPath:dataModel tableType:self.type isReply:NO];
}

#pragma mark - CommentListCellDelegate
- (void)replyButtonClick:(MessageCommentModel *)infoModel {
    [self.myDelegate getTableViewDidSelectRowAtIndexPath:infoModel tableType:self.type isReply:YES];
}


@end
