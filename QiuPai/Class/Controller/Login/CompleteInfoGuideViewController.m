//
//  CompleteInfoGuideViewController.m
//  QiuPai
//
//  Created by bigqiang on 16/3/13.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import "CompleteInfoGuideViewController.h"
#import "CompleteInfoGuideView.h"
#import "SearchViewController.h"
#import "RacketSearchModel.h"

#define PickerViewHeight 216.0f

typedef NS_ENUM(NSInteger, PickerType) {
    PickerTypePlayYear = 1,
    PickerTypeSelfEvalue = 2,
};

@interface CompleteInfoGuideViewController() <VCInteractionDelegate, CompleteInfomationDelagate, NetWorkDelegate, UIPickerViewDelegate, UIPickerViewDataSource>{
    CompleteInfoGuideView *_infoGuideView;
    
    PickerType _pickerType;
    Step2CallBackBlock _step2CallBack;
    NSMutableArray *_answerPresetArr;
    UIView *_answerPickerView;
    
}

@property (nonatomic, assign) NSInteger playYear;
@property (nonatomic, assign) CGFloat selfEvalue;
@end

@implementation CompleteInfoGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"基本资料";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 25)];
    [backBtn setTitle:@"跳过" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    [self.view setBackgroundColor:VCViewBGColor];
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake(0, 0, 40, 25)];
    [saveBtn setTitle:@"完成" forState:UIControlStateNormal];
    [saveBtn setTitle:@"完成" forState:UIControlStateHighlighted];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [saveBtn setTitleColor:Gray153Color forState:UIControlStateDisabled];
    [saveBtn addTarget:self action:@selector(completeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    _answerPresetArr = [[NSMutableArray alloc] init];
    _playYear = 1;
    _selfEvalue = 20;
    
    _infoGuideView = [[CompleteInfoGuideView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight)];
    _infoGuideView.myDelegate = self;
    [self.view addSubview:_infoGuideView];
    
    [self initAnswerPickerView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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

- (void)backBtnClick:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)completeBtnClick:(UIButton *)sender {
    if (!_racketModel) {
        [self loadingTipView:@"请选择球拍" callBack:nil];
        return;
    }
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:self.playYear] forKey:@"playYear"];
    [paramDic setObject:[NSNumber numberWithInteger:self.selfEvalue] forKey:@"lvEevaluate"];
    [paramDic setObject:_racketModel.name forKey:@"racquet"];    
    RequestInfo *info = [HttpRequestManager modifyPersonalInfo:paramDic];
    info.delegate = self;
}

- (void)completeIofoGuide:(NSInteger)playYear selfEvalue:(CGFloat)selfEvalue racket:(NSString *)racket {
    
}

- (void)initAnswerPickerView {
    _answerPickerView = [[UIView alloc] initWithFrame:CGRectMake(0, kFrameHeight, kFrameWidth, PickerViewHeight)];
    [_answerPickerView setBackgroundColor:[UIColor whiteColor]];
    UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 0.5)];
    [upLine setBackgroundColor:LineViewColor];
    [_answerPickerView addSubview:upLine];
    
    UIPickerView *_answerPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 49.0, kFrameWidth, PickerViewHeight - 49.0)];
    // 显示选中框
    [_answerPicker setBackgroundColor:[UIColor whiteColor]];
    _answerPicker.showsSelectionIndicator = YES;
    _answerPicker.dataSource = self;
    _answerPicker.delegate = self;
    [_answerPicker setTag:101];
    [_answerPickerView addSubview:_answerPicker];
    
    [self.view addSubview:_answerPickerView];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitle:@"取消" forState:UIControlStateSelected];
    [cancleBtn setTitleColor:Gray153Color forState:UIControlStateNormal];
    [cancleBtn setTitleColor:Gray153Color forState:UIControlStateSelected];
    [cancleBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [cancleBtn setFrame:CGRectMake(0, 0, 50, 40)];
    [cancleBtn addTarget:self action:@selector(pickerViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setTag:100];
    [_answerPickerView addSubview:cancleBtn];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateSelected];
    [confirmBtn setTitleColor:CustomGreenColor forState:UIControlStateNormal];
    [confirmBtn setTitleColor:CustomGreenColor forState:UIControlStateSelected];
    [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [confirmBtn setFrame:CGRectMake(kFrameWidth - 50, 0, 50, 40)];
    [confirmBtn addTarget:self action:@selector(pickerViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTag:200];
    [_answerPickerView addSubview:confirmBtn];
}

- (void)showAnswerPickerView:(BOOL)isShow {
    if (isShow) {
        [UIView beginAnimations:@"PopView" context:nil];
        [UIView setAnimationDuration:0.3];
        [self.view bringSubviewToFront:_answerPickerView];
        [_answerPickerView setFrame:CGRectMake(0, kFrameHeight - PickerViewHeight, kFrameWidth, PickerViewHeight)];
        [UIView commitAnimations];
    } else {
        [UIView beginAnimations:@"PopView" context:nil];
        [UIView setAnimationDuration:0.3];
        [self.view bringSubviewToFront:_answerPickerView];
        [_answerPickerView setFrame:CGRectMake(0, kFrameHeight, kFrameWidth, PickerViewHeight)];
        [UIView commitAnimations];
    }
}

- (void)pickerViewBtnClick:(UIButton *)sender {
    NSInteger btnTag  = [sender tag];
    if (btnTag == 200) {
        NSString *pickResult = @"";
        UIPickerView *answerPicker = [self getPickerView];;
        NSInteger row = [answerPicker selectedRowInComponent:0];
        switch (_pickerType) {
            case PickerTypePlayYear:
                _playYear = [[_answerPresetArr objectAtIndex:row] integerValue];
                pickResult = [NSString stringWithFormat:@"%ld年", (long)_playYear];
                break;
            case PickerTypeSelfEvalue:
                _selfEvalue = [[_answerPresetArr objectAtIndex:row] integerValue];
                pickResult = [NSString stringWithFormat:@"%.1f", _selfEvalue/10];
                break;
            default:
                break;
        }
        _step2CallBack(pickResult);
    }
    [self showAnswerPickerView:NO];
}


- (UIPickerView *)getPickerView {
    return [_answerPickerView viewWithTag:101];
}

- (void)openAnswerPickerView {
    UIPickerView *answerPicker = [self getPickerView];
    [answerPicker reloadAllComponents];
    [self showAnswerPickerView:YES];
}

#pragma -mark CompleteInfomationDelagate
- (void)ageChooseBtnClick:(Step2CallBackBlock)callBack {
    [_answerPresetArr removeAllObjects];
    for (NSInteger i = 0; i < 70; i ++) {
        [_answerPresetArr addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    }
    _pickerType = PickerTypePlayYear;
    [self openAnswerPickerView];
    
    [[self getPickerView] selectRow:_playYear inComponent:0 animated:NO];
    _step2CallBack = callBack;
    
}

- (void)selfEvalueBtnClick:(Step2CallBackBlock)callBack {
    [_answerPresetArr removeAllObjects];
    for (int i = 10; i < 75; i+=5) {
        [_answerPresetArr addObject:[NSNumber numberWithInt:i]];
    }
    _pickerType = PickerTypeSelfEvalue;
    [self openAnswerPickerView];
    
    [[self getPickerView] selectRow:(_selfEvalue - 10)/5 inComponent:0 animated:NO];
    _step2CallBack = callBack;
}

- (void)racketUsedBtnClick:(Step2CallBackBlock)callBack {
    _step2CallBack = callBack;
    [self performSegueWithIdentifier:IdentifierRacketSearch sender:nil];
}

#pragma -mark VCInteractionDelegate
- (void)sendSearchResult:(id)result {
    _racketModel = [(RacketSearchModel*)result copy];
    [_infoGuideView reloadRacketUsedView:_racketModel.thumbPicUrl name:_racketModel.name weight:[NSString stringWithFormat:@"%ldg", (long)_racketModel.weight] balance:_racketModel.balance headSize:[NSString stringWithFormat:@"%.0f平方英寸", _racketModel.headSize]];
}


#pragma -mark UIPickerViewDataSource

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *textStr = @"";
    UILabel* myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 30)];
    switch (_pickerType) {
        case PickerTypePlayYear:
            textStr = [NSString stringWithFormat:@"%@年", [_answerPresetArr objectAtIndex:row]];
            break;
        case PickerTypeSelfEvalue:
            textStr = [NSString stringWithFormat:@"%.1f", [((NSNumber *)[_answerPresetArr objectAtIndex:row]) integerValue]/10.0];
            break;
        default:
            break;
    }
    myLabel.text = textStr;
    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.textColor = [UIColor blackColor];
    myLabel.font = [UIFont systemFontOfSize:15.0f];
    myLabel.backgroundColor = [UIColor clearColor];
    return myLabel;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return kFrameWidth;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40.0;
}

#pragma -mark UIPickerViewDelegate
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _answerPresetArr.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

#pragma -mark NetWorkDelegate
- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    if (requestID == RequestID_ModifyPersonalInfo) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
//            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            [QiuPaiUserModel getUserInstance].selfEveluate = @(self.selfEvalue);
            [QiuPaiUserModel getUserInstance].playYear = [NSString stringWithFormat:@"%ld", (long)self.playYear];
            [QiuPaiUserModel getUserInstance].racquet = _racketModel.name;
            
            [self backBtnClick:nil];
        } else {
            NSLog(@"err is %@", [dic objectForKey:@"statusInfo"]);
        }
    }
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {
    
}


@end
