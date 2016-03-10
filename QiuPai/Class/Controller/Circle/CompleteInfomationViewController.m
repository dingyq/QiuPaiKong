//
//  CompleteInfomationViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/12/14.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "CompleteInfomationViewController.h"

#import "SexChooseView.h"
#import "KnockUpQuestion2View.h"
#import "KnockUpQuestion3View.h"
#import "KnockUpQuestion4View.h"
#import "KnockUpQuestion5View.h"
#import "NumPageControl.h"
#import "StepControlToolBar.h"
#import "CompleteInfomationDelagate.h"

#define PickerViewHeight 216.0f

typedef NS_ENUM(NSInteger, PickerType) {
    PickerTypeBorthYear = 1,
    PickerTypeHeight = 2,
    PickerTypeWeight = 3,
};

@interface CompleteInfomationViewController() <NetWorkDelegate, StepControlToolBarDelegate, CompleteInfomationDelagate, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate> {
    Step2CallBackBlock _step2CallBack;
    PickerType _pickerType;
    
//    NSInteger _sex;             //性别0男1女
//    NSInteger _bornYear;        //出生年份
//    NSInteger _height;          //身高(cm)
//    NSInteger _weight;          //体重(kg)
//    NSInteger _playYear;
//    NSInteger _selfEveluate;
//    NSInteger _playFreq;        //频率 1没打过 2偶尔 3 1-4次/月 4一周三次以上
//    NSInteger _powerSelfEveluate;//力量自评 1不参加 2偶尔 3一周一次 4一周三次及以上
//    NSInteger _injuries;        //伤病史 1有 2无 3不清楚
//    NSInteger _region;          //活动区域 1没打过 2全场 3网前 4底线附近 5底线后
//    NSInteger _style;           //击球风格 1没打过 2旋转 3平击
    
    UIScrollView *_contentScrollView;
    CGFloat _contentSVHeight;
    SexChooseView *_sexChooseView;
    KnockUpQuestion2View *_stage2View;
    KnockUpQuestion3View *_stage3View;
    KnockUpQuestion4View *_stage4View;
    KnockUpQuestion5View *_stage5View;
    NumPageControl *_numPageControl;
    StepControlToolBar *_footerToolBar;
    NSMutableArray *_answerPresetArr;
    UIView *_answerPickerView;
}

@property (nonatomic, assign) SexIndicator sex;        //性别0男1女
@property (nonatomic, assign) NSInteger bornYear;        //出生年份
@property (nonatomic, assign) NSInteger height;          //身高(cm)
@property (nonatomic, assign) NSInteger weight;          //体重(kg)
@property (nonatomic, assign) NSInteger selfEveluate;
@property (nonatomic, assign) NSInteger playFreq;        //频率 1没打过 2偶尔 3 1-4次/月 4一周三次以上
@property (nonatomic, assign) NSInteger powerSelfEveluate;//力量自评 1不参加 2偶尔 3一周一次 4一周三次及以上
@property (nonatomic, assign) NSInteger injuries;        //伤病史 1有 2无 3不清楚
@property (nonatomic, assign) NSInteger region;          //活动区域 1没打过 2全场 3网前 4底线附近 5底线后
@property (nonatomic, assign) NSInteger style;           //击球风格 1没打过 2旋转 3平击

@end

static NSInteger ViewsCount = 4;

@implementation CompleteInfomationViewController
-(SexIndicator)sex {
    return _sex ? _sex : SexIndicatorBoy;
}

- (NSInteger)region {
    if (self.selfEveluate == 1) {
        return _region;
    }
    return _region ? _region : 1;
}

- (NSInteger)style {
    if (self.selfEveluate == 1) {
        return _style;
    }
    return _style ? _style : 1;
}

- (NSInteger)powerSelfEveluate {
    return _powerSelfEveluate ? _powerSelfEveluate : 1;
}

- (NSInteger)injuries {
    return _injuries ? _injuries : 1;
}

- (NSInteger)selfEveluate {
    return _selfEveluate ? _selfEveluate : 1;
}

- (NSInteger)playFreq {
    return _playFreq ? _playFreq : 1;
}

- (NSInteger)bornYear {
    NSInteger year = [Helper getCurrentYear];
    return _bornYear == year ? 1991 : _bornYear;
}

- (NSInteger)weight {
    return _weight ? _weight : 68;
}

- (NSInteger)height {
    return _height ? _height : 178;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 40, 25)];
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [backBtn setTitleColor:Gray240Color forState:UIControlStateNormal];
    [backBtn setTitleColor:Gray240Color forState:UIControlStateSelected];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    self.title = @"资料完善";
    self.automaticallyAdjustsScrollViewInsets = NO;
    _contentSVHeight = kFrameHeight - 64 - 49;
    _answerPresetArr = [[NSMutableArray alloc] init];
    
    [self initContentScrollView];
    [self initNumPageControlView];
    [self initFooterToolBar];
    [self initAnswerPickerView];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
//    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _powerSelfEveluate = [[QiuPaiUserModel getUserInstance].powerSelfEveluate integerValue];
    _style = [[QiuPaiUserModel getUserInstance].style integerValue];
    _sex = [[QiuPaiUserModel getUserInstance].sex integerValue];
    _region = [[QiuPaiUserModel getUserInstance].region integerValue];
    _injuries = [[QiuPaiUserModel getUserInstance].injuries integerValue];
    _selfEveluate = [[QiuPaiUserModel getUserInstance].selfEveluate integerValue];
    _playFreq = [[QiuPaiUserModel getUserInstance].playFreq integerValue];
    NSInteger year = [Helper getCurrentYear];
    _bornYear =  year - [[QiuPaiUserModel getUserInstance].age integerValue];
    _weight = [[QiuPaiUserModel getUserInstance].weight integerValue];
    _height = [[QiuPaiUserModel getUserInstance].height integerValue];
    
    // stage1
    [_sexChooseView resetSexBtn:self.sex];
    // stage2
    [_stage2View resetView:self.bornYear height:self.height weight:self.weight];
    // stage3
    [_stage3View resetView:self.selfEveluate playFreq:self.playFreq];
    // stage4
    [_stage4View resetView:self.powerSelfEveluate injuries:self.injuries];
    // stage5
    [_stage5View resetView:self.region style:self.style];
}

- (void)backBtnClick:(UIButton *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewTapped:(UITapGestureRecognizer *)tap {
    [self showAnswerPickerView:NO];
}

- (void)initContentScrollView {
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kFrameWidth, _contentSVHeight)];
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.scrollsToTop = YES;
    _contentScrollView.userInteractionEnabled = YES;
    _contentScrollView.bounces = NO;
    _contentScrollView.delegate = self;
    _contentScrollView.scrollEnabled = NO;
    _contentScrollView.backgroundColor = [UIColor clearColor];
    _contentScrollView.contentSize = CGSizeMake(kFrameWidth * ViewsCount, _contentSVHeight);
    [self.view addSubview:_contentScrollView];

    [self initSexChooseView];
    [self initStage2View];
    [self initStage3View];
    [self initStage4View];
    [self initStage5View];
}

- (void)initSexChooseView {
    _sexChooseView = [[SexChooseView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, _contentSVHeight)];
    _sexChooseView.myDelegate = self;
    [_contentScrollView addSubview:_sexChooseView];
}

- (void)initStage2View {
    _stage2View = [[KnockUpQuestion2View alloc] initWithFrame:CGRectMake(kFrameWidth, 0, kFrameWidth, _contentSVHeight)];
    _stage2View.myDelegate = self;
    [_contentScrollView addSubview:_stage2View];
}

- (void)initStage3View {
    _stage3View = [[KnockUpQuestion3View alloc] initWithFrame:CGRectMake(kFrameWidth*2, 0, kFrameWidth, _contentSVHeight)];
    _stage3View.myDelegate = self;
    [_contentScrollView addSubview:_stage3View];
}

- (void)initStage4View {
    _stage4View = [[KnockUpQuestion4View alloc] initWithFrame:CGRectMake(kFrameWidth*3, 0, kFrameWidth, _contentSVHeight)];
    _stage4View.myDelegate = self;
    [_contentScrollView addSubview:_stage4View];
}

- (void)initStage5View {
    _stage5View = [[KnockUpQuestion5View alloc] initWithFrame:CGRectMake(kFrameWidth*4, 0, kFrameWidth, _contentSVHeight)];
    _stage5View.myDelegate = self;
    [_contentScrollView addSubview:_stage5View];
}

- (void)initNumPageControlView {
    _numPageControl = [[NumPageControl alloc] initWithFrame:CGRectMake(0, kFrameHeight - 49 - 25, kFrameWidth, 25)];
    [self.view addSubview:_numPageControl];
    [_numPageControl setBackgroundColor:[UIColor clearColor]];
    _numPageControl.numberOfPages = ViewsCount;
    _numPageControl.currentPage = 0;
    _numPageControl.userInteractionEnabled = NO;
}

- (void)initFooterToolBar {
    _footerToolBar = [[StepControlToolBar alloc] initWithFrame:CGRectMake(0, kFrameHeight - 49, kFrameWidth, 49)];
    _footerToolBar.myDelegate = self;
    _footerToolBar.numberOfStep = ViewsCount;
    _footerToolBar.currentStep = _numPageControl.currentPage;
    [_footerToolBar setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_footerToolBar];
}

- (void)initAnswerPickerView {
    _answerPickerView = [[UIView alloc] initWithFrame:CGRectMake(0, kFrameHeight, kFrameWidth, PickerViewHeight)];
    [_answerPickerView setBackgroundColor:[UIColor whiteColor]];
    UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 0.5)];
    [upLine setBackgroundColor:LineViewColor];
    [_answerPickerView addSubview:upLine];
//    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 48.5, kFrameWidth, 0.5)];
//    [bottomLine setBackgroundColor:LineViewColor];
//    [_answerPickerView addSubview:bottomLine];
    
    UIPickerView *_answerPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 49.0, kFrameWidth, PickerViewHeight - 49.0)];
    // 显示选中框
    [_answerPicker setBackgroundColor:[UIColor whiteColor]];
    _answerPicker.showsSelectionIndicator=YES;
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

- (UIPickerView *)getPickerView {
    return [_answerPickerView viewWithTag:101];
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
            case PickerTypeBorthYear:
                _bornYear = [[_answerPresetArr objectAtIndex:row] integerValue];
                pickResult = [NSString stringWithFormat:@"%ld年出生", (long)_bornYear];
                break;
            case PickerTypeHeight:
                _height = [[_answerPresetArr objectAtIndex:row] integerValue];
                pickResult = [NSString stringWithFormat:@"%ld厘米", (long)_height];
                break;
            case PickerTypeWeight:
                _weight = [[_answerPresetArr objectAtIndex:row] integerValue];
                pickResult = [NSString stringWithFormat:@"%ld公斤", (long)_weight];
                break;
            default:
                break;
        }
        _step2CallBack(pickResult);
        if (_bornYear && _height && _weight) {
            [_footerToolBar setNextBtnState:YES];
        }
    }
    [self showAnswerPickerView:NO];
}

- (void)openAnswerPickerView {
    UIPickerView *answerPicker = [self getPickerView];
    [answerPicker reloadAllComponents];
    [self showAnswerPickerView:YES];
}

#pragma -mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma -mark UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int currentPage = 0;
    CGPoint offset = _contentScrollView.contentOffset;
    currentPage = offset.x / kFrameWidth; //计算当前的页码
    [_numPageControl setCurrentPage:currentPage];
}

#pragma -mark CompleteInfomationDelagate
// stage 1
- (void)sexChooseDone:(SexIndicator)sex {
    [_footerToolBar setNextBtnState:YES];
    _sex = sex;
}

// stage 2
- (void)ageChooseBtnClick:(Step2CallBackBlock)callBack {
    [_answerPresetArr removeAllObjects];
    NSInteger year = [Helper getCurrentYear];
    for (NSInteger i = 0; i < 70; i ++) {
        [_answerPresetArr addObject:[NSString stringWithFormat:@"%ld", (long)year-i]];
    }
    [self openAnswerPickerView];

    
    [[self getPickerView] selectRow:year - self.bornYear inComponent:0 animated:NO];
    _step2CallBack = callBack;
    _pickerType = PickerTypeBorthYear;
}

- (void)heigthChooseBtnClick:(Step2CallBackBlock)callBack {
    [_answerPresetArr removeAllObjects];
    for (int i = 0; i < 91; i ++) {
        [_answerPresetArr addObject:[NSString stringWithFormat:@"%d", 200-i]];
    }
    [self openAnswerPickerView];
    
    [[self getPickerView] selectRow:200-self.height inComponent:0 animated:NO];
    
    _step2CallBack = callBack;
    _pickerType = PickerTypeHeight;
}

- (void)weightChooseBtnClick:(Step2CallBackBlock)callBack {
    [_answerPresetArr removeAllObjects];
    for (int i = 0; i < 71; i ++) {
        [_answerPresetArr addObject:[NSString stringWithFormat:@"%d", 100-i]];
    }
    [self openAnswerPickerView];
    
    [[self getPickerView] selectRow:100-self.weight inComponent:0 animated:NO];
    
    _step2CallBack = callBack;
    _pickerType = PickerTypeWeight;
}

// stage 3
- (void)selfEveluateChooseDone:(NSInteger)selfEveluate {
    _selfEveluate = selfEveluate;
    if (_selfEveluate && _playFreq) {
        [_footerToolBar setNextBtnState:YES];
    }
}

- (void)playFrequencyChooseDone:(NSInteger)playFreq {
    _playFreq = playFreq;
    if (_selfEveluate && _playFreq) {
        [_footerToolBar setNextBtnState:YES];
    }
}

// stage4
- (void)strengthPracticeChooseDone:(NSInteger)strength {
    _powerSelfEveluate = strength;
    if (_powerSelfEveluate && _injuries) {
        [_footerToolBar setNextBtnState:YES];
    }
}

- (void)injuryChooseDone:(NSInteger)injury {
    _injuries = injury;
    if (_powerSelfEveluate && _injuries) {
        [_footerToolBar setNextBtnState:YES];
    }
}

// stage5
- (void)regionChooseDone:(NSInteger)region {
    _region = region;
    if (_region && _style) {
        [_footerToolBar setNextBtnState:YES];
    }
}

- (void)styleChooseDone:(NSInteger)style {
    _style = style;
    if (_region && _style) {
        [_footerToolBar setNextBtnState:YES];
    }
}

- (void)sendCompleteUserInfomationRequest {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    [paramDic setObject:[NSNumber numberWithInteger:_goodsId] forKey:@"racId"];
    [paramDic setObject:[NSNumber numberWithInteger:self.sex] forKey:@"sex"];
    [paramDic setObject:[NSNumber numberWithInteger:self.bornYear] forKey:@"bornYear"];
    [paramDic setObject:[NSNumber numberWithInteger:self.weight] forKey:@"weight"];
    [paramDic setObject:[NSNumber numberWithInteger:self.height] forKey:@"height"];
    [paramDic setObject:[NSNumber numberWithInteger:self.selfEveluate] forKey:@"selfEveluate"];
    [paramDic setObject:[NSNumber numberWithInteger:self.playFreq] forKey:@"playFreq"];
    [paramDic setObject:[NSNumber numberWithInteger:self.powerSelfEveluate] forKey:@"powerSelfEveluate"];
    [paramDic setObject:[NSNumber numberWithInteger:self.injuries] forKey:@"injuries"];
    [paramDic setObject:[NSNumber numberWithInteger:self.region] forKey:@"region"];
    [paramDic setObject:[NSNumber numberWithInteger:self.style] forKey:@"style"];
    
    // 预留字段
    [paramDic setObject:[QiuPaiUserModel getUserInstance].age forKey:@"age"];
    [paramDic setObject:@1 forKey:@"backHand"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].grapHand forKey:@"grapHand"];
    [paramDic setObject:@1 forKey:@"otherGame"];
    [paramDic setObject:@3 forKey:@"staOrBurn"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].gripSize forKey:@"gripSize"];
    [paramDic setObject:@[] forKey:@"preference"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].star forKey:@"star"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].color forKey:@"color"];
    [paramDic setObject:[QiuPaiUserModel getUserInstance].brand forKey:@"brand"];
    
    if (_isModify) {
        RequestInfo *info = [HttpRequestManager modifyPersonalInfo:paramDic];
        info.delegate = self;
    } else {
        RequestInfo *info = [HttpRequestManager completeInfomationAndKnockUp:paramDic];
        info.delegate = self;
    }
}

#pragma -mark StepControlToolBarDelegate

- (void)preStepBtnClick:(UIButton *)sender {
    [_contentScrollView setContentOffset:CGPointMake(kFrameWidth*_footerToolBar.currentStep, 0) animated:YES];
    [_numPageControl setCurrentPage:_footerToolBar.currentStep];
}

- (void)nextStepBtnClick:(UIButton *)sender {
    if (_footerToolBar.currentStep < ViewsCount) {
        [_contentScrollView setContentOffset:CGPointMake(kFrameWidth*_footerToolBar.currentStep, 0) animated:YES];
        [_numPageControl setCurrentPage:_footerToolBar.currentStep];
    }
    if (_footerToolBar.currentStep == 3) {
        if (self.selfEveluate && self.selfEveluate != 1) {
            // 非初学者
            ViewsCount = 5;
            _footerToolBar.numberOfStep = ViewsCount;
            _numPageControl.numberOfPages = ViewsCount;
            _contentScrollView.contentSize = CGSizeMake(kFrameWidth * ViewsCount, _contentSVHeight);
        } else {
            ViewsCount = 4;
            _footerToolBar.numberOfStep = ViewsCount;
            _numPageControl.numberOfPages = ViewsCount;
            _contentScrollView.contentSize = CGSizeMake(kFrameWidth * ViewsCount, _contentSVHeight);
        }
    }
//    if ([[sender.titleLabel text] isEqualToString:@"完成"]) {
    if (_footerToolBar.currentStep == ViewsCount) {
        // 资料填写完成，提交服务器
        [self sendCompleteUserInfomationRequest];
    }
}


#pragma -mark NetWorkDelegate 

- (void)netWorkFinishedCallBack:(NSDictionary *)dic withRequestID:(NetWorkRequestID)requestID {
    if (RequestID_CompleteSelfInfomation == requestID) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            [self.resultDelegate completeInfomaitonSuccessWithData:dataDic];
            [self backBtnClick:nil];
        } else {
            NSLog(@"err is %@", [dic objectForKey:@"statusInfo"]);
        }
    } else if (requestID == RequestID_ModifyPersonalInfo) {
        if ([[dic objectForKey:@"statusCode"] integerValue] == NetWorkJsonResOK) {
            NSDictionary *dataDic = [dic objectForKey:@"returnData"];
            [QiuPaiUserModel getUserInstance].report = [dataDic objectForKey:@"report"];
            [QiuPaiUserModel getUserInstance].sex = @(self.sex);
            [QiuPaiUserModel getUserInstance].powerSelfEveluate  = @(self.powerSelfEveluate);
            [QiuPaiUserModel getUserInstance].style = @(self.style);
            [QiuPaiUserModel getUserInstance].region = @(self.region);
            [QiuPaiUserModel getUserInstance].injuries = @(self.injuries);
            [QiuPaiUserModel getUserInstance].selfEveluate = @(self.selfEveluate);
            [QiuPaiUserModel getUserInstance].playFreq = @(self.playFreq);
            [QiuPaiUserModel getUserInstance].weight = @(self.weight);
            [QiuPaiUserModel getUserInstance].height = @(self.height);
            NSInteger year = [Helper getCurrentYear];
            [QiuPaiUserModel getUserInstance].age = @(year - self.bornYear);

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"试打资料完善成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        } else {
            NSLog(@"err is %@", [dic objectForKey:@"statusInfo"]);
        }
    }
}

- (void)netWorkFailedCallback:(NSError *)err withRequestID:(NetWorkRequestID)requestID {

}

#pragma -mark UIPickerViewDelegate
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _answerPresetArr.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

#pragma -mark UIPickerViewDataSource

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *textStr = @"";
    UILabel* myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 30)];
    switch (_pickerType) {
        case PickerTypeBorthYear:
            textStr = [NSString stringWithFormat:@"%@ 年",[_answerPresetArr objectAtIndex:row]];
            break;
        case PickerTypeHeight:
            textStr = [NSString stringWithFormat:@"%@ 厘米",[_answerPresetArr objectAtIndex:row]];
            break;
        case PickerTypeWeight:
            textStr = [NSString stringWithFormat:@"%@ 公斤",[_answerPresetArr objectAtIndex:row]];
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


@end

