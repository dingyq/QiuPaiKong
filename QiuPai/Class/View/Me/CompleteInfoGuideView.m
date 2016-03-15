//
//  CompleteInfoGuideView.m
//  QiuPai
//
//  Created by bigqiang on 16/3/13.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import "CompleteInfoGuideView.h"
#import "EvalGoodsSimpleInfoView.h"

@interface CompleteInfoGuideView() {
    
    UIView *_ageView;
    UIView *_selfEvalueView;
    UIView *_racketView;
    
    EvalGoodsSimpleInfoView *_racketInfoView;
}
@property (assign, nonatomic) NSInteger lvEvalu;

@end

@implementation CompleteInfoGuideView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:VCViewBGColor];
        
        CGFloat orignY = 86;
        CGFloat viewH = 98;
        _ageView = [self createQuestionUnitView:CGRectMake(0, orignY, frame.size.width, viewH) tipStr:@"你的网球球龄" btnTip:@"1年" btnTag:100];
        [self addSubview:_ageView];
//        mDebugWithBorder(_ageView);
        
        orignY = orignY + viewH;
        _selfEvalueView = [self createQuestionUnitView:CGRectMake(0, orignY, frame.size.width, viewH) tipStr:@"你的网球水平自测" btnTip:@"2.0" btnTag:200];
        [self addSubview:_selfEvalueView];

        orignY = orignY + viewH;
        _racketView = [self createRacketUsedView:CGRectMake(0, orignY, frame.size.width, viewH + 41) tipStr:@"你使用的球拍" btnTip:@"从数据库中添加球拍" btnTag:300];
        [self addSubview:_racketView];
    }
    return self;
}

- (UIView *)createRacketUsedView:(CGRect)viewFrame tipStr:(NSString *)tipStr btnTip:(NSString *)btnTip btnTag:(NSInteger)btnTag {
    UIView *unitView = [[UIView alloc] initWithFrame:viewFrame];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, viewFrame.size.width - 20, 16)];
    [tipLabel setTextAlignment:NSTextAlignmentCenter];
    [tipLabel setText:tipStr];
    [tipLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [tipLabel setTextColor:Gray85Color];
    [unitView addSubview:tipLabel];
    
    CGFloat viewH = 96.0f;
    _racketInfoView = [[EvalGoodsSimpleInfoView alloc] initWithFrame:CGRectMake(0, viewFrame.size.height - 100, kFrameWidth, viewH)];
    [_racketInfoView setBackgroundColor:[UIColor whiteColor]];
    [_racketInfoView showGoodsSelectTip:@""];
    [_racketInfoView setTag:100];
    [unitView addSubview:_racketInfoView];
    
    UIButton *tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tagBtn setFrame:CGRectMake(0, 0, kFrameWidth, viewH)];
    [tagBtn setBackgroundColor:[UIColor clearColor]];
    [tagBtn setTag:300];
    [tagBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_racketInfoView addSubview:tagBtn];
    
    UILabel * tipLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_racketInfoView.frame), viewH)];
    [tipLabel1 setTextColor:Gray153Color];
    [tipLabel1 setBackgroundColor:[UIColor clearColor]];
    [tipLabel1 setFont:[UIFont systemFontOfSize:14.0]];
    [tipLabel1 setTextAlignment:NSTextAlignmentCenter];
    [tipLabel1 setText:@"从数据库中添加球拍"];
    [_racketInfoView addSubview:tipLabel1];
    [tipLabel1 setHidden:YES];
    
    return unitView;
}

- (UIView *)createQuestionUnitView:(CGRect)viewFrame tipStr:(NSString *)tipStr btnTip:(NSString *)btnTip btnTag:(NSInteger)btnTag {
    UIView *unitView = [[UIView alloc] initWithFrame:viewFrame];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, viewFrame.size.width - 20, 16)];
    [tipLabel setTextAlignment:NSTextAlignmentCenter];
    [tipLabel setText:tipStr];
    [tipLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [tipLabel setTextColor:Gray85Color];
    [unitView addSubview:tipLabel];
//    mDebugWithBorder(tipLabel);
    
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseBtn setTitle:btnTip forState:UIControlStateNormal];
    [chooseBtn setTitle:btnTip forState:UIControlStateSelected];
    [chooseBtn setTag:btnTag];
    [chooseBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [chooseBtn setTitleColor:Gray153Color forState:UIControlStateNormal];
    [chooseBtn setTitleColor:Gray153Color forState:UIControlStateSelected];
//    mDebugWithBorder(chooseBtn);
    [chooseBtn setFrame:CGRectMake(0, viewFrame.size.height - 60, viewFrame.size.width, 50)];
    [chooseBtn setBackgroundColor:[UIColor whiteColor]];
    [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, chooseBtn.frame.size.width, 0.5)];
    [upLine setBackgroundColor:LineViewColor];
    [chooseBtn addSubview:upLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, chooseBtn.frame.size.height - 0.5, chooseBtn.frame.size.width, 0.5)];
    [bottomLine setBackgroundColor:LineViewColor];
    [chooseBtn addSubview:bottomLine];
    
    [unitView addSubview:chooseBtn];
    
    return unitView;
}

- (void)chooseBtnClick:(UIButton *)sender {
    Step2CallBackBlock callBack = ^(NSString *tipStr) {
//        [sender setTitleColor:Gray51Color forState:UIControlStateNormal];
//        [sender setTitleColor:Gray51Color forState:UIControlStateSelected];
        [sender setTitle:tipStr forState:UIControlStateNormal];
        [sender setTitle:tipStr forState:UIControlStateSelected];
    };
    switch (sender.tag) {
        case 100:
            [self.myDelegate ageChooseBtnClick:callBack];
            break;
        case 200:
            [self.myDelegate selfEvalueBtnClick:callBack];
            break;
        case 300:
            [self.myDelegate racketUsedBtnClick:callBack];
            break;
        default:
            break;
    }
}

- (void)reloadRacketUsedView:(NSString *)imageUrl name:(NSString *)goodsName weight:(NSString *)weight balance:(NSString *)balance headSize:(NSString *)headSize {
    [_racketInfoView setRacketInfo:imageUrl name:goodsName weight:weight balance:balance headSize:headSize];
}

@end
