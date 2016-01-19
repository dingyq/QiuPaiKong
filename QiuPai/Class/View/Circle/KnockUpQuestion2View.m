//
//  KnockUpQuestion2View.m
//  QiuPai
//
//  Created by bigqiang on 15/12/14.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "KnockUpQuestion2View.h"

@interface KnockUpQuestion2View() {

    UIView *_ageView;
    UIView *_heightView;
    UIView *_weightView;
}

@end

@implementation KnockUpQuestion2View

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:VCViewBGColor];
        
        CGFloat orignY = 0;
        
        _ageView = [self createQuestionUnitView:CGRectMake(0, orignY, frame.size.width, 120) tipStr:@"2、出生年份" btnTip:@"点击选择出生年份" btnTag:100];
        [self addSubview:_ageView];
        
        orignY = orignY + 120;
        _heightView = [self createQuestionUnitView:CGRectMake(0, orignY, frame.size.width, 120) tipStr:@"3、选择身高" btnTip:@"点击选择身高" btnTag:200];
        [self addSubview:_heightView];
        
        orignY = orignY + 120;
        _weightView = [self createQuestionUnitView:CGRectMake(0, orignY, frame.size.width, 120) tipStr:@"4、选择体重" btnTip:@"点击选择体重" btnTag:300];
        [self addSubview:_weightView];
    }
    return self;
}

- (UIView *)createQuestionUnitView:(CGRect)viewFrame tipStr:(NSString *)tipStr btnTip:(NSString *)btnTip btnTag:(NSInteger)btnTag {
    UIView *unitView = [[UIView alloc] initWithFrame:viewFrame];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, viewFrame.size.width - 20, 16)];
    [tipLabel setTextAlignment:NSTextAlignmentLeft];
    [tipLabel setText:tipStr];
    [tipLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [tipLabel setTextColor:Gray85Color];
    [unitView addSubview:tipLabel];
    
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseBtn setTitle:btnTip forState:UIControlStateNormal];
    [chooseBtn setTitle:btnTip forState:UIControlStateSelected];
    [chooseBtn setTag:btnTag];
    [chooseBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [chooseBtn setTitleColor:Gray153Color forState:UIControlStateNormal];
    [chooseBtn setTitleColor:Gray153Color forState:UIControlStateSelected];
    [chooseBtn setFrame:CGRectMake(0, viewFrame.size.height - 50, viewFrame.size.width, 50)];
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
        [sender setTitleColor:Gray51Color forState:UIControlStateNormal];
        [sender setTitleColor:Gray51Color forState:UIControlStateSelected];
        [sender setTitle:tipStr forState:UIControlStateNormal];
        [sender setTitle:tipStr forState:UIControlStateSelected];
    };
    switch (sender.tag) {
        case 100:
            [self.myDelegate ageChooseBtnClick:callBack];
            break;
        case 200:
            [self.myDelegate heigthChooseBtnClick:callBack];
            break;
        case 300:
            [self.myDelegate weightChooseBtnClick:callBack];
            break;
        default:
            break;
    }
}

- (void)resetView:(NSInteger)bornYear height:(NSInteger)height weight:(NSInteger)weight {
    UIButton *yearBtn = [_ageView viewWithTag:100];
    [yearBtn setTitleColor:Gray51Color forState:UIControlStateNormal];
    [yearBtn setTitleColor:Gray51Color forState:UIControlStateSelected];
    [yearBtn setTitle:[NSString stringWithFormat:@"%ld年出生", (long)bornYear] forState:UIControlStateNormal];
    [yearBtn setTitle:[NSString stringWithFormat:@"%ld年出生", (long)bornYear] forState:UIControlStateSelected];
    
    UIButton *heightBtn = [_heightView viewWithTag:200];
    [heightBtn setTitleColor:Gray51Color forState:UIControlStateNormal];
    [heightBtn setTitleColor:Gray51Color forState:UIControlStateSelected];
    [heightBtn setTitle:[NSString stringWithFormat:@"%ld厘米", (long)height] forState:UIControlStateNormal];
    [heightBtn setTitle:[NSString stringWithFormat:@"%ld厘米", (long)height] forState:UIControlStateSelected];

    UIButton *weightBtn = [_weightView viewWithTag:300];
    [weightBtn setTitleColor:Gray51Color forState:UIControlStateNormal];
    [weightBtn setTitleColor:Gray51Color forState:UIControlStateSelected];
    [weightBtn setTitle:[NSString stringWithFormat:@"%ld公斤", (long)weight] forState:UIControlStateNormal];
    [weightBtn setTitle:[NSString stringWithFormat:@"%ld公斤", (long)weight] forState:UIControlStateSelected];
}

@end
