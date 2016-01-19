//
//  KnockUpQuestion5View.m
//  QiuPai
//
//  Created by bigqiang on 15/12/15.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "KnockUpQuestion5View.h"

@interface KnockUpQuestion5View(){
    UIView *_regionView;
    UIView *_styleView;
}

@end

@implementation KnockUpQuestion5View

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:VCViewBGColor];
        
        CGFloat orignY = 0;
        _regionView = [self createQuestionUnitViewWithImage:CGRectMake(0, orignY, frame.size.width, 227) imageArr:@[@"question_region_all.png", @"question_region_up.png", @"question_region_bottom.png"] tipStr:@"9、你偏向于下面哪种打法？" btnTipArr:@[@"全场型", @"上网型", @"底线型"] btnClick:@selector(regionBtnClick:)];
        [self addSubview:_regionView];
        orignY += 227;
        
        _styleView = [self createQuestionUnitView:CGRectMake(0, orignY, frame.size.width, 215) tipStr:@"10、你更喜欢哪种击球风格？" btnTipArr:@[@"上旋球", @"平击球"] btnClick:@selector(styleBtnClick:)];
        [self addSubview:_styleView];
    }
    return self;
}

- (void)regionBtnClick:(UIButton *)sender {
    if ([sender isSelected]) {
        return;
    }
    NSArray *btnsArr = [_regionView subviews];
    for (UIButton *btn in btnsArr) {
        if ([NSStringFromClass([btn class]) isEqualToString:NSStringFromClass([UIButton class])]) {
            [btn setSelected:NO];
            [btn setBackgroundColor:mUIColorWithRGB(239, 247, 244)];
        }
    }
    [sender setSelected:YES];
    [sender setBackgroundColor:CustomGreenColor];
    //活动区域 1、全场 2、上网 3、底线
    [self.myDelegate regionChooseDone:(sender.tag/100)];
}

- (void)styleBtnClick:(UIButton *)sender {
    if ([sender isSelected]) {
        return;
    }
    NSArray *btnsArr = [_styleView subviews];
    for (UIButton *btn in btnsArr) {
        if ([NSStringFromClass([btn class]) isEqualToString:NSStringFromClass([UIButton class])]) {
            [btn setSelected:NO];
            [btn setBackgroundColor:mUIColorWithRGB(239, 247, 244)];
        }
    }
    [sender setSelected:YES];
    [sender setBackgroundColor:CustomGreenColor];
    //击球风格 1、上旋 2、平击
    [self.myDelegate styleChooseDone:(sender.tag/100)];
}

- (UIView *)createQuestionUnitViewWithImage:(CGRect)viewFrame imageArr:(NSArray *)imageArr tipStr:(NSString *)tipStr btnTipArr:(NSArray *)btnTipArr btnClick:(SEL)callBack {
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
    CGFloat btnHeight = 50;
    for (int i = 0; i < [btnTipArr count]; i++) {
        NSString *btnTip = [btnTipArr objectAtIndex:i];
        UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [chooseBtn setImage:[UIImage imageNamed:[imageArr objectAtIndex:i]] forState:UIControlStateNormal];
        [chooseBtn setImage:[UIImage imageNamed:[imageArr objectAtIndex:i]] forState:UIControlStateSelected];
        chooseBtn.imageEdgeInsets = UIEdgeInsetsMake(2, btnWidth/2-68, 2, btnWidth/2+1);
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

- (void)resetView:(NSInteger)region style:(NSInteger)style {
    NSArray *btnsArr = [_regionView subviews];
    for (UIButton *btn in btnsArr) {
        if ([NSStringFromClass([btn class]) isEqualToString:NSStringFromClass([UIButton class])]) {
            region = (region > 0 && region < 4) ? region : 1;
            if (btn.tag == region*100) {
                [btn setSelected:YES];
                [btn setBackgroundColor:CustomGreenColor];
            } else {
                [btn setSelected:NO];
                [btn setBackgroundColor:mUIColorWithRGB(239, 247, 244)];
            }
        }
    }
    
    NSArray *btnsArr1 = [_styleView subviews];
    for (UIButton *btn in btnsArr1) {
        if ([NSStringFromClass([btn class]) isEqualToString:NSStringFromClass([UIButton class])]) {
            style = (style > 0 && style < 3) ? style : 1;
            if (btn.tag == style*100) {
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
