//
//  KnockUpQuestion3View.m
//  QiuPai
//
//  Created by bigqiang on 15/12/14.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "KnockUpQuestion3View.h"

@interface KnockUpQuestion3View(){
    UIView *_playYearView;
    UIView *_playFrequencyView;
}

@end

@implementation KnockUpQuestion3View

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:VCViewBGColor];
        
        CGFloat orignY = 0;
        _playYearView = [self createQuestionUnitView:CGRectMake(0, orignY, frame.size.width, 165) tipStr:@"5、网球水平自评" btnTipArr:@[@"零基础", @"初学者", @"进阶级", @"专业级"] btnClick:@selector(playYearBtnClick:)];
        [self addSubview:_playYearView];
        
        orignY += 165;
        _playFrequencyView = [self createQuestionUnitView:CGRectMake(0, orignY, frame.size.width, 165) tipStr:@"6、哪项最接近你打网球的频率？" btnTipArr:@[@"偶尔", @"1个月1~3次", @"1周1次", @"1周2次或更多"] btnClick:@selector(playFrequencyBtnClick:)];
        [self addSubview:_playFrequencyView];        
    }
    return self;
}

- (void)playYearBtnClick:(UIButton *)sender {
    if ([sender isSelected]) {
        return;
    }
    NSArray *btnsArr = [_playYearView subviews];
    for (UIButton *btn in btnsArr) {
        if ([NSStringFromClass([btn class]) isEqualToString:NSStringFromClass([UIButton class])]) {
            [btn setSelected:NO];
            [btn setBackgroundColor:mUIColorWithRGB(239, 247, 244)];
        }
    }
    [sender setSelected:YES];
    [sender setBackgroundColor:CustomGreenColor];
    // 1、零基础 2、初学者 3、进阶级 4、专业级
    [self.myDelegate selfEveluateChooseDone:(sender.tag/100)];
}

- (void)playFrequencyBtnClick:(UIButton *)sender {
    if ([sender isSelected]) {
        return;
    }
    NSArray *btnsArr = [_playFrequencyView subviews];
    for (UIButton *btn in btnsArr) {
        if ([NSStringFromClass([btn class]) isEqualToString:NSStringFromClass([UIButton class])]) {
            [btn setSelected:NO];
            [btn setBackgroundColor:mUIColorWithRGB(239, 247, 244)];
        }
    }
    [sender setSelected:YES];
    [sender setBackgroundColor:CustomGreenColor];
    //频率 1、偶尔 2、1-3次/月 3、一周一次 4、1周2次或更多
    [self.myDelegate playFrequencyChooseDone:(sender.tag/100)];
}

- (UIView *)createQuestionUnitView:(CGRect)viewFrame tipStr:(NSString *)tipStr btnTipArr:(NSArray *)btnTipArr btnClick:(SEL)callBack {
    UIView *unitView = [[UIView alloc] initWithFrame:viewFrame];
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, viewFrame.size.width - 20, 16)];
    [tipLabel setTextAlignment:NSTextAlignmentLeft];
    [tipLabel setText:tipStr];
    [tipLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [tipLabel setTextColor:Gray85Color];
    [unitView addSubview:tipLabel];
    
    CGFloat orignY = 68;
    CGFloat hGap = 4;
    CGFloat vGap = 4;
    CGFloat btnWidth = (self.frame.size.width - hGap)/2;
    CGFloat btnHeight = 45;
    for (int i = 0; i < [btnTipArr count]; i++) {
        NSString *btnTip = [btnTipArr objectAtIndex:i];
        UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [chooseBtn setTitle:btnTip forState:UIControlStateNormal];
        [chooseBtn setTitle:btnTip forState:UIControlStateSelected];
        [chooseBtn setTag:(i*100+100)];
        [chooseBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [chooseBtn setTitleColor:Gray85Color forState:UIControlStateNormal];
        [chooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [chooseBtn setFrame:CGRectMake((btnWidth+hGap)*(i%2), orignY+(btnHeight+vGap)*(i/2), btnWidth, btnHeight)];
        [chooseBtn setBackgroundColor:mUIColorWithRGB(239, 247, 244)];
        [chooseBtn addTarget:self action:callBack forControlEvents:UIControlEventTouchUpInside];
        [unitView addSubview:chooseBtn];
    }
    return unitView;
}

- (void)resetView:(NSInteger)selfEvalu playFreq:(NSInteger)playFreq {
    NSArray *btnsArr = [_playYearView subviews];
    selfEvalu = (selfEvalu > 0 && selfEvalu < 5) ? selfEvalu : 1;
//    [self.myDelegate selfEveluateChooseDone:selfEvalu];
    for (UIButton *btn in btnsArr) {
        if ([NSStringFromClass([btn class]) isEqualToString:NSStringFromClass([UIButton class])]) {
            if (btn.tag == selfEvalu*100) {
                [btn setSelected:YES];
                [btn setBackgroundColor:CustomGreenColor];
                
            } else {
                [btn setSelected:NO];
                [btn setBackgroundColor:mUIColorWithRGB(239, 247, 244)];
            }
        }
    }
    
    NSArray *btnsArr1 = [_playFrequencyView subviews];
    playFreq = (playFreq > 0 && playFreq < 5) ? playFreq : 1;
//    [self.myDelegate playFrequencyChooseDone:playFreq];
    for (UIButton *btn in btnsArr1) {
        if ([NSStringFromClass([btn class]) isEqualToString:NSStringFromClass([UIButton class])]) {
            if (btn.tag == playFreq*100) {
                [btn setSelected:YES];
                [btn setBackgroundColor:CustomGreenColor];
            } else {
                [btn setSelected:NO];
                [btn setBackgroundColor:mUIColorWithRGB(239, 247, 244)];
            }
        }
    }
}

@end
