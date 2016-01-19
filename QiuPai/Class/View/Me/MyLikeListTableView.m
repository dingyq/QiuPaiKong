//
//  MyLikeListTableView.m
//  QiuPai
//
//  Created by bigqiang on 15/11/21.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "MyLikeListTableView.h"

#import "CircleTVCell.h"
#import "PreciseSelectTVCell.h"
#import "SearchResultCell.h"

@interface MyLikeListTableView() {

}

@end


@implementation MyLikeListTableView
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

#pragma mark - UITableViewDataSource -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [[self.tableArray objectAtIndex:indexPath.row] getZanListCellHeight];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == LikeListTableTypeEvaluation) {
        static NSString * kCellIdentifier = @"CircleLikeListCell";
        CircleTVCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        if (!cell) {
            cell = [[CircleTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
            cell.myDelegate = (id<TableViewCellInteractionDelegate>)self.myDelegate;
        }
        [cell bindEvaluLikeCellWithDataModel:[self.tableArray objectAtIndex:indexPath.row]];
        return cell;
    } else if (self.type == LikeListTableTypeSpecialTopic) {
        static NSString * kCellIdentifier = @"STLikeListCell";
        PreciseSelectTVCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        if (!cell) {
            cell = [[PreciseSelectTVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
            cell.myDelegate = (id<TableViewCellInteractionDelegate>)self.myDelegate;
        }
        [cell bindCellWithDataModel:[self.tableArray objectAtIndex:indexPath.row]];
        return cell;
    } else {
        static NSString * kCellIdentifier = @"GoodsLikeListCell";
        SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        if (!cell) {
            cell = [[SearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
            cell.myDelegate = (id<TableViewCellInteractionDelegate>)self.myDelegate;
        }
        [cell bindCellWithDataModel:[self.tableArray objectAtIndex:indexPath.row] showBuyBtn:YES];
        return cell;
    }
}

#pragma mark - UITableViewDelegate -

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    id dataModel;
    if (self.type == LikeListTableTypeEvaluation) {
        dataModel = [self.tableArray objectAtIndex:indexPath.row];
    } else if (self.type == LikeListTableTypeSpecialTopic) {
        dataModel = [self.tableArray objectAtIndex:indexPath.row];
    } else if (self.type == LikeListTableTypeGoods) {
        dataModel = [self.tableArray objectAtIndex:indexPath.row];
    }
    [self.myDelegate getTableViewDidSelectRowAtIndexPath:dataModel tableType:self.type isReply:NO];
}

@end
