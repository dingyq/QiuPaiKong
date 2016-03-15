//
//  SearchViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/11/9.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "SearchViewController.h"
#import "DDRemoteSearchBar.h"
#import "RacketSearchModel.h"
#import "SearchResultCell.h"
#import "HotSearchWordsView.h"

#import "GoodsDetailAndEvaViewController.h"
#import "SpecialTopicViewController.h"
#import "GoodsBuyViewController.h"

@interface SearchViewController()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, DDRemoteSearchBarDelegate, NetWorkDelegate, TableViewCellInteractionDelegate> {
    UITableView *_resultTableView;
    HotSearchWordsView *_hotWordsView;
    
    BOOL _isFirstLoaded;
    GoodsSearchType _loadMoreType;
    BOOL _isLoadMoreClick;
}
@property (strong, nonatomic) DDRemoteSearchBar *searchBar;
@property (strong, nonatomic) NSArray *searchList;
@property (strong, nonatomic) NSString *keyWords;
@property (copy, nonatomic) NSArray *hotWordsArr;

@end

@implementation SearchViewController

static const NSInteger pageCount = 10;

- (NSString *)keyWords {
    return _keyWords?_keyWords:@"";
}

- (NSArray *)searchList {
    if (!_searchList) {
        _searchList = [NSArray arrayWithObjects:[NSArray array], [NSArray array], nil];
    }
    return _searchList;
}

- (NSMutableArray *)copyFromSearchList {
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (NSArray *arr in self.searchList) {
        NSMutableArray *arrM = [[NSMutableArray alloc] initWithArray:arr];
        [tmpArr addObject:arrM];
    }
    return tmpArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isFirstLoaded = YES;
    _isLoadMoreClick = NO;
    
    [self initSearchBar];
    [self initResultTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha = 1.0;
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_isFirstLoaded) {
        [self sendGetHotSearchWordsList];
        [_searchBar becomeFirstResponder];
        _isFirstLoaded = NO;
    }
    self.navigationController.navigationBar.alpha = 1.0;
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    RacketSearchModel *infoModel = (RacketSearchModel *)sender;
    [self.searchBar resignFirstResponder];
    if ([identifier isEqualToString:IdentifierGoodsDetailAndEva]) {
        GoodsDetailAndEvaViewController *vc = [[GoodsDetailAndEvaViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.goodsId = infoModel.goodsId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)backToPreVC:(id)sender {
    [super backToPreVC:sender];
    [self.searchBar resignFirstResponder];
}

- (void)initSearchBar {
    _searchBar = [[DDRemoteSearchBar alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 44.0)];
    _searchBar.delegate = self;
    self.navigationItem.titleView = _searchBar;
    _searchBar.placeholder = self.searchPlaceholder;
//    _searchBar.timeToWait = 1;
}

- (void)initResultTableView {
    _resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight) style:UITableViewStylePlain];
    _resultTableView.delegate = self;
    _resultTableView.dataSource = self;
    _resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_resultTableView];
    
    UIView *footerView = [[UIView alloc] init];
    _resultTableView.tableFooterView = footerView;
    [footerView setBackgroundColor:[UIColor clearColor]];
}

- (void)reloadSearchTableView {
    [self showHotSearchWordsMiddleView:NO];
    [_resultTableView reloadData];
}

- (void)showHotSearchWordsMiddleView:(BOOL)show {
    if (!_hotWordsView) {
        _hotWordsView = [[HotSearchWordsView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight)];
        [_hotWordsView setBackgroundColor:[UIColor whiteColor]];
        _hotWordsView.myDelegate = self;
        [self.view addSubview:_hotWordsView];
    }
    if (show) {
        [_hotWordsView initHotWordsBtn:_hotWordsArr];
    }
    
    [_hotWordsView setHidden:!show];
    [_resultTableView setHidden:show];
}

- (void)sendGetHotSearchWordsList {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:@(HotSearchWordsTypeHistory) forKey:@"staType"];
    [paramDic setObject:[NSNumber numberWithInteger:self.searchType] forKey:@"goodsType"];
    RequestInfo *info = [HttpRequestManager getHotSearchWordsList:paramDic];
    info.delegate = self;
}

- (void)sendSearchGoodsRequest:(NSString *)goodsKeyWord {
    self.keyWords = goodsKeyWord;
    _isLoadMoreClick = NO;
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:self.keyWords forKey:@"keyword"];
    [paramDic setObject:[NSNumber numberWithInteger:self.searchType] forKey:@"type"];
    RequestInfo *info = [HttpRequestManager getGoodsSearchList:paramDic];
    info.delegate = self;
}

# pragma mark - DDRemoteSearchBarDelegate

- (void)remoteSearchBar:(DDRemoteSearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText lengthOfBytesUsingEncoding:NSUTF8StringEncoding] > 3) {
        NSLog(@"searchText is %@", searchText);
        [self sendSearchGoodsRequest:searchText];
    } else if([searchText lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 0) {
        if (!_isFirstLoaded) {
            [self showHotSearchWordsMiddleView:YES];
        }
    }
}

#pragma -mark TableViewCellInteractionDelegate
- (void)hotSearchWordsBtnClick:(NSString *)hotWords {
    [self.searchBar resignFirstResponder];
    self.keyWords = hotWords;
    [_searchBar setText:hotWords];
    [self sendSearchGoodsRequest:hotWords];
}

- (void)gotoBuyGoods:(NSString *)goodsName goodsId:(NSInteger)goodsId goodsUrl:(NSString *)goodsUrl {
    [Helper uploadGotoBuyPageDataToUmeng:goodsName goodsId:goodsId];
    GoodsBuyViewController *vc = [[GoodsBuyViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = goodsName;
    vc.pageHtmlUrl = goodsUrl;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)getLastId:(GoodsSearchType)searchType {
    switch (searchType) {
        case GoodsSearchType_Racket:
        {
            NSArray *racketArr = [self.searchList objectAtIndex:0];
            if (racketArr.count> 0) {
                return [((RacketSearchModel *)[racketArr lastObject]) goodsId];
            }
        }
            break;
        case GoodsSearchType_RacketLine:
        {
            NSArray *racketLineArr = [self.searchList objectAtIndex:1];
            if (racketLineArr.count> 0) {
                return [((RacketSearchModel *)[racketLineArr lastObject]) goodsId];
            }
        }
            break;
        default:
            break;
    }
    return 0;
}

- (void)loadMoreSearchData:(GoodsSearchType)searchType {
    _isLoadMoreClick = YES;
    _loadMoreType = searchType;
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:self.keyWords forKey:@"keyword"];
    [paramDic setObject:@([self getLastId:searchType]) forKey:@"lastId"];
    [paramDic setObject:[NSNumber numberWithInteger:searchType] forKey:@"type"];
    RequestInfo *info = [HttpRequestManager getGoodsSearchList:paramDic];
    info.delegate = self;
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

#pragma -mark UITableViewDelegate
#pragma -mark

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *itemsArr = [self.searchList objectAtIndex:indexPath.section];
    NSInteger rowCount = [itemsArr count];
    NSInteger row = [indexPath row];

    if (row >= rowCount) {
        if (rowCount%pageCount == 0) {
            return 30.0f;
        }
    }
    RacketSearchModel *tmpModel = [itemsArr objectAtIndex:row];
    if (tmpModel.type == GoodsSearchType_Racket || tmpModel.type == GoodsSearchType_RacketLine) {
        return [tmpModel getSearchResultCellHeight];
    }
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_searchType == GoodsSearchType_All) {
        if ([[self.searchList objectAtIndex:section] count] > 0) {
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kFrameWidth-20, 29.5f)];
            [tipLabel setTextColor:Gray119Color];
            [tipLabel setBackgroundColor:[UIColor clearColor]];
            [tipLabel setFont:[UIFont systemFontOfSize:13.0]];
            [tipLabel setTextAlignment:NSTextAlignmentLeft];
            if (section == 0) {
                [tipLabel setText:@"球拍"];
            } else {
                [tipLabel setText:@"球线"];
            }
            [tipLabel setBackgroundColor:[UIColor whiteColor]];
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 30.0f)];
            [bgView setBackgroundColor:[UIColor whiteColor]];
            [bgView addSubview:tipLabel];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 29.5, kFrameWidth, 0.5f)];
            [lineView setBackgroundColor:Gray202Color];
            [bgView addSubview:lineView];
            
            return bgView;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_searchType == GoodsSearchType_All) {
        if ([[self.searchList objectAtIndex:section] count] > 0) {
            return 30.0f;
        }
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_searchType == GoodsSearchType_All) {
        if (section == 0 && [[self.searchList objectAtIndex:0] count] > 0) {
            if (self.searchList.count > 1) {
                if ([[self.searchList objectAtIndex:1] count] > 0) {
                    return 5.0f;
                }
            }
        }
    }
    return 0.0f;
}

//设置区域
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.searchList count];
}

//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowCount = [[self.searchList objectAtIndex:section] count];
    if (rowCount != 0 && rowCount%pageCount == 0) {
        return rowCount + 1;
    }
    return rowCount;
}

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *itemsArr = [self.searchList objectAtIndex:indexPath.section];
    static NSString *flag=@"goodsSearchListCell";
    BOOL shouldShowBuyBtn = YES;
    if (_isNeedBackPreVc) {
        shouldShowBuyBtn = NO;
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:flag];
    if (cell == nil) {
        cell = [[SearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
    }

    NSInteger rowCount = [[self.searchList objectAtIndex:section] count];
    if (row >= rowCount) {
        switch (_searchType) {
            case GoodsSearchType_All:
                if (section == 0) {
                    [cell showLoadMoreTip:GoodsSearchType_Racket];
                } else if (section == 1) {
                    [cell showLoadMoreTip:GoodsSearchType_RacketLine];
                }
                break;
            case GoodsSearchType_Racket:
            {
                [cell showLoadMoreTip:GoodsSearchType_Racket];
            }
                break;
            case GoodsSearchType_RacketLine:
            {
                [cell showLoadMoreTip:GoodsSearchType_RacketLine];
            }
                break;
            default:
                break;
        }
    } else {
        RacketSearchModel *tmpModel = [itemsArr objectAtIndex:indexPath.row];
        [cell bindCellWithDataModel:tmpModel showBuyBtn:shouldShowBuyBtn];
        cell.myDelegate = self;
    }
    return cell;
}

#pragma -mark UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.searchBar resignFirstResponder];
    NSArray *itemsArr = [self.searchList objectAtIndex:indexPath.section];
    RacketSearchModel *tmpModel = [itemsArr objectAtIndex:indexPath.row];
    
    if (_isNeedBackPreVc) {
        [self.myDelegate sendSearchResult:tmpModel];
        [self backToPreVC:nil];
        return;
    }
    if (self.searchType == GoodsSearchType_All) {
        [self performSegueWithIdentifier:IdentifierGoodsDetailAndEva sender:tmpModel];
    }
}


#pragma -mark UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

#pragma -mark NetWorkDelegate
- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    [self.netIndicatorView hide];
    if (RequestID_SearchGoodsList == requestID) {
        NSDictionary *returnData = [dic objectForKey:@"returnData"];
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableArray *searchArr;
                if (_searchType == GoodsSearchType_All) {
                    if (!_isLoadMoreClick) {
                        searchArr = [[NSMutableArray alloc] init];
                        // 球拍
                        NSArray *racketResult = [returnData objectForKey:@"goodsData_1"];
                        NSMutableArray *racketItemArr = [[NSMutableArray alloc] init];
                        for (NSDictionary *itemDic in racketResult) {
                            RacketSearchModel *tmpModel = [[RacketSearchModel alloc] initWithAttributes:itemDic];
                            [racketItemArr addObject:tmpModel];
                        }
                        [searchArr addObject:racketItemArr];
                        
                        // 球线
                        NSMutableArray *racketLineItemArr = [[NSMutableArray alloc] init];
                        NSArray *racketLineResult = [returnData objectForKey:@"goodsData_2"];
                        for (NSDictionary *itemDic in racketLineResult) {
                            RacketSearchModel *tmpModel = [[RacketSearchModel alloc] initWithAttributes:itemDic];
                            [racketLineItemArr addObject:tmpModel];
                        }
                        [searchArr addObject:racketLineItemArr];
                    } else {
                        searchArr = [self copyFromSearchList];
                        NSInteger index = _loadMoreType == GoodsSearchType_Racket ? 0 : 1;
                        NSMutableArray *itemArr = [searchArr objectAtIndex:index];
                        NSArray *loadResult = [returnData objectForKey:@"goodsData"];
                        for (NSDictionary *itemDic in loadResult) {
                            RacketSearchModel *tmpModel = [[RacketSearchModel alloc] initWithAttributes:itemDic];
                            [itemArr addObject:tmpModel];
                        }
                    }
                } else {
                    if (!_isLoadMoreClick) {
                        searchArr = [[NSMutableArray alloc] init];
                        NSArray *searchResult = [returnData objectForKey:@"goodsData"];
                        NSMutableArray *itemArr = [[NSMutableArray alloc] init];
                        for (NSDictionary *itemDic in searchResult) {
                            RacketSearchModel *tmpModel = [[RacketSearchModel alloc] initWithAttributes:itemDic];
                            [itemArr addObject:tmpModel];
                        }
                        [searchArr addObject:itemArr];
                        
                    } else {
                        searchArr = [self copyFromSearchList];
                        NSInteger index = _loadMoreType == GoodsSearchType_Racket ? 0 : 1;
                        NSMutableArray *itemArr = [searchArr objectAtIndex:index];
                        NSArray *loadResult = [returnData objectForKey:@"goodsData"];
                        for (NSDictionary *itemDic in loadResult) {
                            RacketSearchModel *tmpModel = [[RacketSearchModel alloc] initWithAttributes:itemDic];
                            [itemArr addObject:tmpModel];
                        }
                    }
                }
                self.searchList = [NSArray arrayWithArray:searchArr];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadSearchTableView];
                });
            });
        }
    } else if (RequestID_GetHotSearchWords == requestID) {
        NSDictionary *returnData = [dic objectForKey:@"returnData"];
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            _hotWordsArr = [NSArray arrayWithArray:[returnData objectForKey:@"keyword"]];
            [self showHotSearchWordsMiddleView:YES];
        }
    }
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {
    [self.netIndicatorView hide];
    [self.badNetTipV show];
}

@end
