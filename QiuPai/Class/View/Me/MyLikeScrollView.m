//
//  MyLikeScrollView.m
//  QiuPai
//
//  Created by bigqiang on 15/11/21.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "MyLikeScrollView.h"

#define kNoListsTips_TAG 1000

@interface MyLikeScrollView() {
    UIView * _promptView;                          //提示语信息显示View
    UIScrollView * _contentScrollView;
    int contentScrollViewHeight;
    SegmentControllView * _segmentControl;

    UIView * _tabarBackView;
    NSInteger _tabNum;
    
    NSArray *_tipStrArr;
}

@end

@implementation MyLikeScrollView

@synthesize evaluationListTV = _evaluationListTV;
@synthesize specialTopicListTV = _specialTopicListTV;
@synthesize goodsListTV = _goodsListTV;

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
    _tabNum = 3;
    _tipStrArr = @[@"暂无数据", @"暂无数据", @"暂无数据"];
    [self initPromptView];
    [self initScrollView];
    [self initSegmentControl];
}

- (void)setListViewDelegate:(id<CustomListTableViewDelegate>)listViewDelegate {
    _listViewDelegate = listViewDelegate;
    _specialTopicListTV.myDelegate = listViewDelegate;
    _evaluationListTV.myDelegate = listViewDelegate;
    _goodsListTV.myDelegate = listViewDelegate;
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
   _evaluationListTV = [[MyLikeListTableView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, contentScrollViewHeight) style:UITableViewStylePlain];
    _evaluationListTV.type = LikeListTableTypeEvaluation;
    _evaluationListTV.myDelegate = self.listViewDelegate;
    [_contentScrollView addSubview:_evaluationListTV];
    
    _specialTopicListTV = [[MyLikeListTableView alloc] initWithFrame:CGRectMake(kFrameWidth, 0, kFrameWidth, contentScrollViewHeight) style:UITableViewStylePlain];
    _specialTopicListTV.type = LikeListTableTypeSpecialTopic;
    _specialTopicListTV.myDelegate = self.listViewDelegate;
    [_contentScrollView addSubview:_specialTopicListTV];
    
    _goodsListTV = [[MyLikeListTableView alloc] initWithFrame:CGRectMake(kFrameWidth*2, 0, kFrameWidth, contentScrollViewHeight) style:UITableViewStylePlain];
    _goodsListTV.type = LikeListTableTypeGoods;
    _goodsListTV.myDelegate = self.listViewDelegate;
    [_contentScrollView addSubview:_goodsListTV];
}

- (void)reloadEvaluationView:(NSMutableArray *)evaluArr hasMoreData:(BOOL)hasMore isNeedReload:(BOOL)isNeed {
    [_evaluationListTV.mj_header endRefreshing];
    [_evaluationListTV.mj_footer endRefreshing];
    if (hasMore) {
        [_evaluationListTV.mj_footer resetNoMoreData];
    } else {
        [_evaluationListTV.mj_footer endRefreshingWithNoMoreData];
    }
    if (isNeed) {
        _evaluationListTV.tableArray = [NSArray arrayWithArray:evaluArr];
        [_evaluationListTV reloadData];
    }
    if ([_evaluationListTV.tableArray count] > 0) {
        [self setPromptView:_tipStrArr[0] isShow:NO];
    } else {
        [self setPromptView:_tipStrArr[0] isShow:YES];
    }
}

- (void)reloadGoodsView:(NSMutableArray *)goodsArr hasMoreData:(BOOL)hasMore isNeedReload:(BOOL)isNeed {
    [_goodsListTV.mj_header endRefreshing];
    [_goodsListTV.mj_footer endRefreshing];
    if (hasMore) {
        [_goodsListTV.mj_footer resetNoMoreData];
    } else {
        [_goodsListTV.mj_footer endRefreshingWithNoMoreData];
    }
    if (isNeed) {
        _goodsListTV.tableArray = [NSArray arrayWithArray:goodsArr];
        [_goodsListTV reloadData];
    }
    if ([_goodsListTV.tableArray count] > 0) {
        [self setPromptView:_tipStrArr[2] isShow:NO];
    } else {
        [self setPromptView:_tipStrArr[2] isShow:YES];
    }
}

- (void)reloadSpecialTopicView:(NSMutableArray *)stArr hasMoreData:(BOOL)hasMore isNeedReload:(BOOL)isNeed {
    [_specialTopicListTV.mj_header endRefreshing];
    [_specialTopicListTV.mj_footer endRefreshing];
    if (hasMore) {
        [_specialTopicListTV.mj_footer resetNoMoreData];
    } else {
        [_specialTopicListTV.mj_footer endRefreshingWithNoMoreData];
    }
    if (isNeed) {
        _specialTopicListTV.tableArray = [NSArray arrayWithArray:stArr];
        [_specialTopicListTV reloadData];
    }
    if ([_specialTopicListTV.tableArray count] > 0) {
        [self setPromptView:_tipStrArr[1] isShow:NO];
    } else {
        [self setPromptView:_tipStrArr[1] isShow:YES];
    }
}

- (void)initScrollView{
    //出事话背景滑动View
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
    NSArray * itemArray = @[@"评测", @"专题", @"装备"];
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
    _segmentControl.backgroundColor = mUIColorWithRGB(247, 249, 252);;
    [self addSubview:_segmentControl];
    
    _tabarBackView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_segmentControl.frame)-1, kFrameWidth/_tabNum, 1)];
    _tabarBackView.backgroundColor = CustomGreenColor;
    [_segmentControl addSubview:_tabarBackView];
}

- (void)tabarRedBarExecutionAnimation:(CGRect)frame {
    [UIView animateWithDuration:0.3 animations:^{
        _tabarBackView.frame = frame;
    }];
}

- (void)setInterfaceSwitchProcess:(NSInteger)tag {
    switch (tag) {
        case 0: {
            if ([_evaluationListTV.tableArray count] > 0) {
                [self setPromptView:_tipStrArr[0] isShow:NO];
            } else {
                [self setPromptView:_tipStrArr[0] isShow:YES];
            }
        }
            break;
        case 1: {
            if ([_specialTopicListTV.tableArray count] > 0) {
                [self setPromptView:_tipStrArr[1] isShow:NO];
            } else {
                [self setPromptView:_tipStrArr[1] isShow:YES];
            }
        }
            break;
        case 2: {
            if ([_goodsListTV.tableArray count] > 0) {
                [self setPromptView:_tipStrArr[2] isShow:NO];
            } else {
                [self setPromptView:_tipStrArr[2] isShow:YES];
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

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int currentPage = 0;
    CGPoint offset = _contentScrollView.contentOffset;
    
    currentPage = offset.x / kFrameWidth; //计算当前的页码
    [self tabarRedBarExecutionAnimation:CGRectMake(currentPage*(kFrameWidth/_tabNum), _segmentControl.frame.size.height-1, kFrameWidth/_tabNum, 1)];
    
    [_segmentControl setSelectedIndex:currentPage];
    [self setInterfaceSwitchProcess:currentPage];
}

@end
