//
//  ModifyRacketViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/12/20.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "ModifyRacketViewController.h"
#import "EvalGoodsSimpleInfoView.h"
#import "SearchViewController.h"

@interface ModifyRacketViewController() <VCInteractionDelegate> {
    EvalGoodsSimpleInfoView *_racketInfoView;
    
    BOOL _isFirstLoad;
    
    UILabel *_tipLabel;
}

@end

@implementation ModifyRacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:VCViewBGColor];
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake(0, 0, 40, 25)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateHighlighted];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [saveBtn setTitleColor:Gray153Color forState:UIControlStateDisabled];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    _isFirstLoad = YES;
    
    [self initRacketInfoView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isFirstLoad) {
        [_racketInfoView showGoodsSelectTip:_racketModel.name];
        _isFirstLoad = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:IdentifierRacketSearch]) {
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        searchVC.hidesBottomBarWhenPushed = YES;
        searchVC.myDelegate = self;
        searchVC.isNeedBackPreVc = YES;
        searchVC.searchType = GoodsSearchType_Racket;
        searchVC.searchPlaceholder = @"搜索你要使用的球拍";
        [self.navigationController pushViewController:searchVC animated:YES];
    }
}

- (void)saveBtnClick:(UIButton *)sender {
    [self.callDelegate racketChooseDone:_racketModel.name];
    
    [self backToPreVC:nil];
}

- (RacketSearchModel *)racketModel {
    if (!_racketModel) {
        _racketModel = [[RacketSearchModel alloc] init];
    }
    return _racketModel;
}

- (void)initRacketInfoView {
    CGFloat viewH = 96.0f;
    _racketInfoView = [[EvalGoodsSimpleInfoView alloc] initWithFrame:CGRectMake(0, 64+17, kFrameWidth, viewH)];
    [_racketInfoView setBackgroundColor:[UIColor whiteColor]];
    [_racketInfoView showGoodsSelectTip:@""];
    [_racketInfoView setTag:100];
    [self.view addSubview:_racketInfoView];
    
    UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tagBtn setFrame:CGRectMake(0, 0, kFrameWidth, viewH)];
    [tagBtn setBackgroundColor:[UIColor clearColor]];
    [tagBtn addTarget:self action:@selector(chooseRacketBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_racketInfoView addSubview:tagBtn];
    
    UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 0.5f)];
    [upLine setBackgroundColor:LineViewColor];
    [_racketInfoView addSubview:upLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 95.5, kFrameWidth, 0.5f)];
    [bottomLine setBackgroundColor:LineViewColor];
    [_racketInfoView addSubview:bottomLine];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_racketInfoView.frame), viewH)];
    [_tipLabel setTextColor:Gray153Color];
    [_tipLabel setBackgroundColor:[UIColor clearColor]];
    [_tipLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_tipLabel setTextAlignment:NSTextAlignmentCenter];
    [_tipLabel setText:@"点击选择你使用的球拍"];
    [_racketInfoView addSubview:_tipLabel];
    [_tipLabel setHidden:YES];
}

- (void)chooseRacketBtnClick:(UIButton *)sender {
    [self performSegueWithIdentifier:IdentifierRacketSearch sender:nil];
}

#pragma -mark VCInteractionDelegate
- (void)sendSearchResult:(id)result {
    _racketModel = [(RacketSearchModel*)result copy];
    [_racketInfoView setRacketInfo:_racketModel.thumbPicUrl name:_racketModel.name weight:[NSString stringWithFormat:@"%ldg", (long)_racketModel.weight] balance:_racketModel.balance headSize:[NSString stringWithFormat:@"%.0f平方英寸", _racketModel.headSize]];
}

@end
