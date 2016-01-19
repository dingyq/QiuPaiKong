//
//  KnockUpQuestion4View.m
//  QiuPai
//
//  Created by bigqiang on 15/12/14.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "KnockUpQuestion4View.h"

@interface KnockUpQuestion4View(){
    UIView *_strengthPracticeView;
    UIView *_injuryView;
}

@end

@implementation KnockUpQuestion4View

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:VCViewBGColor];
        
        CGFloat orignY = 0;
        _strengthPracticeView = [self createQuestionUnitView:CGRectMake(0, orignY, frame.size.width, 215) tipStr:@"7、是否参加力量训练？" btnTipArr:@[@"不参加", @"偶尔参加", @"经常参加"] btnClick:@selector(strengthPracticeBtnClick:)];
        [self addSubview:_strengthPracticeView];
        
        orignY += 215;
        _injuryView = [self createQuestionUnitView:CGRectMake(0, orignY, frame.size.width, 215) tipStr:@"8、是否有手腕或肩部的伤病？" btnTipArr:@[@"没有", @"手腕有伤病", @"肩部有伤病"] btnClick:@selector(injuryBtnClick:)];
        [self addSubview:_injuryView];
    }
    return self;
}

- (void)strengthPracticeBtnClick:(UIButton *)sender {
    if ([sender isSelected]) {
        return;
    }
    NSArray *btnsArr = [_strengthPracticeView subviews];
    for (UIButton *btn in btnsArr) {
        if ([NSStringFromClass([btn class]) isEqualToString:NSStringFromClass([UIButton class])]) {
            [btn setSelected:NO];
            [btn setBackgroundColor:mUIColorWithRGB(239, 247, 244)];
        }
    }
    [sender setSelected:YES];
    [sender setBackgroundColor:CustomGreenColor];
    //力量自评 1不参加 2偶尔 3经常参加
    [self.myDelegate strengthPracticeChooseDone:(sender.tag/100)];
}

- (void)injuryBtnClick:(UIButton *)sender {
    if ([sender isSelected]) {
        return;
    }
    NSArray *btnsArr = [_injuryView subviews];
    for (UIButton *btn in btnsArr) {
        if ([NSStringFromClass([btn class]) isEqualToString:NSStringFromClass([UIButton class])]) {
            [btn setSelected:NO];
            [btn setBackgroundColor:mUIColorWithRGB(239, 247, 244)];
        }
    }
    [sender setSelected:YES];
    [sender setBackgroundColor:CustomGreenColor];
    //伤病史 1没有 2手腕有伤病 3肩部有伤病
    [self.myDelegate injuryChooseDone:(sender.tag/100)];
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
    CGFloat vGap = 4;
    CGFloat btnWidth = self.frame.size.width;
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
        [chooseBtn setFrame:CGRectMake(0, orignY+(btnHeight+vGap)*i, btnWidth, btnHeight)];
        [chooseBtn setBackgroundColor:mUIColorWithRGB(239, 247, 244)];
        [chooseBtn addTarget:self action:callBack forControlEvents:UIControlEventTouchUpInside];
        [unitView addSubview:chooseBtn];
    }
    return unitView;
}

- (void)resetView:(NSInteger)powerSelfEvalu injuries:(NSInteger)injuries {
    NSArray *btnsArr = [_strengthPracticeView subviews];
    for (UIButton *btn in btnsArr) {
        if ([NSStringFromClass([btn class]) isEqualToString:NSStringFromClass([UIButton class])]) {
            powerSelfEvalu = (powerSelfEvalu > 0 && powerSelfEvalu < 4) ? powerSelfEvalu : 1;
            if (btn.tag == powerSelfEvalu*100) {
                [btn setSelected:YES];
                [btn setBackgroundColor:CustomGreenColor];
            } else {
                [btn setSelected:NO];
                [btn setBackgroundColor:mUIColorWithRGB(239, 247, 244)];
            }
        }
    }
    
    NSArray *btnsArr1 = [_injuryView subviews];
    for (UIButton *btn in btnsArr1) {
        if ([NSStringFromClass([btn class]) isEqualToString:NSStringFromClass([UIButton class])]) {
            injuries = (injuries > 0 && injuries < 4) ? injuries : 1;
            if (btn.tag == injuries*100) {
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
