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

#import "GoodsDetailAndEvaViewController.h"
#import "SpecialTopicViewController.h"
#import "GoodsBuyViewController.h"

@interface SearchViewController()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, DDRemoteSearchBarDelegate, NetWorkDelegate, TableViewCellInteractionDelegate> {
    UITableView *_resultTableView;
    
    BOOL _isFirstLoaded;
}
@property (strong, nonatomic) DDRemoteSearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray  *searchList;
@property (strong, nonatomic) NSString *keyWords;


@end

@implementation SearchViewController

@synthesize searchPlaceholder;
@synthesize searchList = _searchList;

- (NSString *)keyWords {
    return _keyWords?_keyWords:@"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchList = [[NSMutableArray alloc] init];
    _isFirstLoaded = YES;
    
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

//- (void)addRefreshView:(UITableView *)tableView {
//    __weak __typeof(self)weakSelf = self;
//    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
////        [weakSelf getSpecialTopicDetail:GetInfoTypeRefresh sortId:0];
//    }];
//    // 设置自动切换透明度(在导航栏下面自动隐藏)
//    tableView.mj_header.automaticallyChangeAlpha = YES;
//    // 上拉刷新
//    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
////        [weakSelf getSpecialTopicDetail:GetInfoTypePull sortId:weakSelf.oldestSortId];
//    }];
//}

- (void)initResultTableView {
    _resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight) style:UITableViewStylePlain];
    _resultTableView.delegate = self;
    _resultTableView.dataSource = self;
    _resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_resultTableView];
    
    UIView *footerView = [[UIView alloc] init];
    _resultTableView.tableFooterView = footerView;
    [footerView setBackgroundColor:[UIColor clearColor]];
//    [self addRefreshView:_resultTableView];
}

- (void)sendSearchGoodsRequest:(NSString *)goodsKeyWord {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:goodsKeyWord forKey:@"keyword"];
    [paramDic setObject:[NSNumber numberWithInteger:self.searchType] forKey:@"type"];
    RequestInfo *info = [HttpRequestManager getGoodsSearchList:paramDic];
    info.delegate = self;
}

# pragma mark - DDRemoteSearchBarDelegate
-(void)remoteSearchBar:(DDRemoteSearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText lengthOfBytesUsingEncoding:NSUTF8StringEncoding] > 3) {
        NSLog(@"searchText is %@", searchText);
        self.keyWords = searchText;
        [self sendSearchGoodsRequest:searchText];
    }
}

#pragma -mark TableViewCellInteractionDelegate
- (void)gotoBuyGoods:(NSString *)goodsName goodsId:(NSInteger)goodsId goodsUrl:(NSString *)goodsUrl {
    [Helper uploadGotoBuyPageDataToUmeng:goodsName goodsId:goodsId];
    GoodsBuyViewController *vc = [[GoodsBuyViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = goodsName;
    vc.pageHtmlUrl = goodsUrl;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

#pragma -mark UITableViewDelegate
#pragma -mark

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *itemsArr = [self.searchList objectAtIndex:indexPath.section];
    RacketSearchModel *tmpModel = [itemsArr objectAtIndex:indexPath.row];
    if (tmpModel.type == GoodsSearchType_Racket || tmpModel.type == GoodsSearchType_RacketLine) {
        return [tmpModel getSearchResultCellHeight];
    }
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_searchType == GoodsSearchType_All) {
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
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_searchType == GoodsSearchType_All) {
        return 30.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (_searchType == GoodsSearchType_All) {
        if (section < [self.searchList count]-1) {
//            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 30.0f)];
//            [bgView setBackgroundColor:Gray202Color];
//            return bgView;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_searchType == GoodsSearchType_All) {
        if (section < [self.searchList count]-1) {
            return 5.0f;
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
    return [[self.searchList objectAtIndex:section] count];
}

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *itemsArr = [self.searchList objectAtIndex:indexPath.section];
    static NSString *flag=@"goodsSearchListCell";
    BOOL shouldShowBuyBtn = YES;
    if (_isNeedBackPreVc) {
        shouldShowBuyBtn = NO;
    }
    
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:flag];
    if (cell == nil) {
        cell = [[SearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
    }
    RacketSearchModel *tmpModel = [itemsArr objectAtIndex:indexPath.row];
    [cell bindCellWithDataModel:tmpModel showBuyBtn:shouldShowBuyBtn];
    cell.myDelegate = self;
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
    NSLog(@"搜索Begin");
    [self sendSearchGoodsRequest:@""];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    NSLog(@"搜索End");
//    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}

#pragma -mark NetWorkDelegate
- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    [self.netIndicatorView hide];
    
    if (RequestID_SearchGoodsList == requestID) {
        NSDictionary *returnData = [dic objectForKey:@"returnData"];
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            [self.searchList removeAllObjects];
            if (_searchType == GoodsSearchType_All) {
                // 球拍
                NSArray *racketResult = [returnData objectForKey:@"goodsData_1"];
                NSMutableArray *racketItemArr = [[NSMutableArray alloc] init];
                for (NSDictionary *itemDic in racketResult) {
                    RacketSearchModel *tmpModel = [[RacketSearchModel alloc] initWithAttributes:itemDic];
                    [racketItemArr addObject:tmpModel];
                }
                if ([racketItemArr count] > 0) {
                    [self.searchList addObject:racketItemArr];
                }
                
                // 球线
//                NSArray *racketLineResult = [returnData objectForKey:@"goodsData_2"];
//                NSMutableArray *racketLineItemArr = [[NSMutableArray alloc] init];
//                for (NSDictionary *itemDic in racketLineResult) {
//                    RacketSearchModel *tmpModel = [[RacketSearchModel alloc] initWithAttributes:itemDic];
//                    [racketLineItemArr addObject:tmpModel];
//                }
//                if ([racketLineItemArr count] > 0) {
//                    [self.searchList addObject:racketLineItemArr];
//                }
                
            } else {
                NSArray *searchResult = [returnData objectForKey:@"goodsData"];
                NSMutableArray *goodsItemArr = [[NSMutableArray alloc] init];
                for (NSDictionary *itemDic in searchResult) {
                    RacketSearchModel *tmpModel = [[RacketSearchModel alloc] initWithAttributes:itemDic];
                    [goodsItemArr addObject:tmpModel];
                }
                [self.searchList addObject:goodsItemArr];
            }
            
            [_resultTableView reloadData];
        }
    }
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {
    [self.netIndicatorView hide];
    [self.badNetTipV show];
}

@end
