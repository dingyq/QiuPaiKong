//
//  MessageScrollView.m
//  QiuPai
//
//  Created by bigqiang on 15/11/21.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "MessageScrollView.h"

#define kNoListsTips_TAG 1000

@interface MessageScrollView() {
    UIView * _promptView;                          //提示语信息显示View
    UIScrollView * _contentScrollView;
    int contentScrollViewHeight;
    SegmentControllView * _segmentControl;
    
    UIView * _tabarBackView;
    NSInteger _tabNum;
    NSArray *_tipStrArr;
}

@end


@implementation MessageScrollView
@synthesize replyListTV = _replyListTV;
@synthesize likeListTV = _likeListTV;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadMySubView];
    }
    return self;
}

- (void)loadMySubView {
    contentScrollViewHeight = kFrameHeight - 38 - 64;
    _tabNum = 2;
    _tipStrArr = @[@"暂无数据", @"暂无数据"];
    [self initPromptView];
    [self initScrollView];
    [self initSegmentControl];
}

- (void)setListViewDelegate:(id<CustomListTableViewDelegate>)listViewDelegate {
    _listViewDelegate = listViewDelegate;
    _likeListTV.myDelegate = listViewDelegate;
    _replyListTV.myDelegate = listViewDelegate;
}

/**
 界面提示语
 @returns 无返回
 */
- (void)initPromptView {
    _promptView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, contentScrollViewHeight)];
    [self addSubview:_promptView];
    
    UILabel * noListsTips = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , kFrameWidth, contentScrollViewHeight)];
    noListsTips.backgroundColor = [UIColor clearColor];
    noListsTips.textColor = Gray202Color;
    noListsTips.text = @"";
    noListsTips.textAlignment = NSTextAlignmentCenter;
    noListsTips.font = [UIFont systemFontOfSize:FS_COMMON_PROMPT];
    noListsTips.tag = kNoListsTips_TAG;
    _promptView.hidden = YES;
    [_promptView addSubview:noListsTips];
}

- (void)setPromptView:(NSString *)lableText isShow:(BOOL)isShow {
    if (isShow) {
        _promptView.hidden = NO;
        [(UILabel *)[_promptView viewWithTag:kNoListsTips_TAG] setText:lableText];
    }else {
        _promptView.hidden = YES;
    }
}

- (void)initTableView{
    _replyListTV = [[MessageListTableView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, contentScrollViewHeight) style:UITableViewStylePlain];
    _replyListTV.type = MessageListTableTypeComment;
    _replyListTV.myDelegate = self.listViewDelegate;
    [_contentScrollView addSubview:_replyListTV];
    
    _likeListTV = [[MessageListTableView alloc] initWithFrame:CGRectMake(kFrameWidth, 0, kFrameWidth, contentScrollViewHeight) style:UITableViewStylePlain];
    _likeListTV.type = MessageListTableTypeLike;
    _likeListTV.myDelegate = self.listViewDelegate;
    [_contentScrollView addSubview:_likeListTV];
    
}

- (void)reloadCommentView:(NSMutableArray *)commentArr hasMoreData:(BOOL)hasMore isNeedReload:(BOOL)isNeed {
    [_replyListTV.mj_header endRefreshing];
    [_replyListTV.mj_footer endRefreshing];
    if (hasMore) {
        [_replyListTV.mj_footer resetNoMoreData];
    } else {
        [_replyListTV.mj_footer endRefreshingWithNoMoreData];
    }
    if (isNeed) {
        _replyListTV.tableArray = [NSArray arrayWithArray:commentArr];
        [_replyListTV reloadData];
    }
    
    if ([_replyListTV.tableArray count] > 0) {
        [self setPromptView:_tipStrArr[0] isShow:NO];
    } else {
        [self setPromptView:_tipStrArr[0] isShow:YES];
    }
}

- (void)reloadLikeView:(NSMutableArray *)likeArr hasMoreData:(BOOL)hasMore isNeedReload:(BOOL)isNeed {
    [_likeListTV.mj_header endRefreshing];
    [_likeListTV.mj_footer endRefreshing];
    
    if (hasMore) {
        [_likeListTV.mj_footer resetNoMoreData];
    } else {
        [_likeListTV.mj_footer endRefreshingWithNoMoreData];
    }
    if (isNeed) {
        _likeListTV.tableArray = [NSArray arrayWithArray:likeArr];
        [_likeListTV reloadData];
    }
    
    if ([_replyListTV.tableArray count] > 0) {
        [self setPromptView:_tipStrArr[1] isShow:NO];
    } else {
        [self setPromptView:_tipStrArr[1] isShow:YES];
    }
}

- (void)initScrollView{
    //初始化背景滑动View
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, kFrameWidth, contentScrollViewHeight)];
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.scrollsToTop = YES;
    _contentScrollView.userInteractionEnabled = YES;
    _contentScrollView.bounces = NO;
    _contentScrollView.delegate = self;
    _contentScrollView.backgroundColor = [UIColor clearColor];
    _contentScrollView.contentSize = CGSizeMake(kFrameWidth * _tabNum, contentScrollViewHeight);
    [self addSubview:_contentScrollView];
    
    [self initTableView];
}

/**
 *  初始化导航按钮控件
 */
- (void)initSegmentControl {
    NSArray * itemArray = @[@"回复", @"喜欢"];
    int itemWidth = self.bounds.size.width/[itemArray count];
    NSMutableArray* items = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [itemArray count]; i++) {
        SegmentItem* item = [[SegmentItem alloc] initWithFrame:CGRectMake(itemWidth*i, 0, itemWidth, 38) NormalColor:Gray51Color SelectedColor:CustomGreenColor];
        item.itemIndex = i;
        item.itemTitle = [itemArray objectAtIndex:i];
        item.isSelected = (i == 0)?YES:NO;
        [items addObject:item];
    }
    
    _segmentControl = [[SegmentControllView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 38) items:items];
    [_segmentControl addTarget:self action:@selector(onSegmentAction:) forControlEvents:UIControlEventValueChanged];
    _segmentControl.backgroundColor = mUIColorWithRGB(247, 249, 252);
    [self addSubview:_segmentControl];
    
    _tabarBackView = [[UIView alloc] initWithFrame:CGRectMake(0, _segmentControl.frame.size.height-1, kFrameWidth/_tabNum, 1)];
    _tabarBackView.backgroundColor = CustomGreenColor;
    [self addSubview:_tabarBackView];
    
}

- (void)tabarRedBarExecutionAnimation:(CGRect)frame {
    [UIView animateWithDuration:0.3 animations:^{
        _tabarBackView.frame = frame;
    }];
}

- (void)setInterfaceSwitchProcess:(NSInteger)tag {
    switch (tag) {
        case 0: {
            if ([_replyListTV.tableArray count] > 0) {
                [self setPromptView:_tipStrArr[0] isShow:NO];
            } else {
                [self setPromptView:_tipStrArr[0] isShow:YES];
            }
        }
            break;
        case 1: {
            if ([_likeListTV.tableArray count] > 0) {
                [self setPromptView:_tipStrArr[1] isShow:NO];
            } else {
                [self setPromptView:_tipStrArr[1] isShow:YES];
            }
        }
            break;
        default:
            break;
    }
}

-(void)onSegmentAction:(id)sender {
    SegmentControllView *segment = (SegmentControllView *)sender;
    NSInteger x = segment.selectedIndex;
    [self tabarRedBarExecutionAnimation:CGRectMake(x*(kFrameWidth/_tabNum), _segmentControl.frame.size.height-1, kFrameWidth/_tabNum, 1)];
    [_contentScrollView setContentOffset:CGPointMake(kFrameWidth*x, _contentScrollView.contentOffset.y) animated:NO];
    [self setInterfaceSwitchProcess:x];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int currentPage = 0;
    CGPoint offset = _contentScrollView.contentOffset;
    
    currentPage = offset.x / kFrameWidth; //计算当前的页码
    [self tabarRedBarExecutionAnimation:CGRectMake(currentPage*(kFrameWidth/_tabNum), _segmentControl.frame.size.height-1, kFrameWidth/_tabNum, 1)];
    
    [_segmentControl setSelectedIndex:currentPage];
    [self setInterfaceSwitchProcess:currentPage];
}

@end
