//
//  HotSearchWordsView.m
//  QiuPai
//
//  Created by bigqiang on 16/3/13.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import "HotSearchWordsView.h"

@implementation HotSearchWordsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)initHotWordsBtn:(NSArray *)btnTitleArr {
    if (!btnTitleArr) {
        return;
    }
    if ([btnTitleArr count] < 1) {
        return;
    }
    for (UIView * tmpView in [self subviews]) {
        [tmpView removeFromSuperview];
    }
    UILabel *tipL = [[UILabel alloc] initWithFrame:CGRectMake(0, 98, CGRectGetWidth(self.frame), 30)];
    [tipL setText:@"热门装备"];
    [tipL setTextAlignment:NSTextAlignmentCenter];
    [tipL setFont:[UIFont systemFontOfSize:14.0f]];
    [tipL setTextColor:Gray153Color];
    [self addSubview:tipL];
    
    CGFloat xGap = 6.0f;
    CGFloat yGap = 6.0f;
    CGFloat btnW = (CGRectGetWidth(self.frame) - 28)/3;
    CGFloat btnH = 30.0f;
    CGFloat pX = 16.0f/2;
    CGFloat pY = CGRectGetMaxY(tipL.frame) + 10;
    
    for (NSInteger i = 0; i < [btnTitleArr count]; i ++) {
        UIButton *wBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [wBtn setTitle:[btnTitleArr objectAtIndex:i] forState:UIControlStateNormal];
        wBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [wBtn setTitleColor:Gray153Color forState:UIControlStateNormal];
        [wBtn setFrame:CGRectMake(pX + (btnW + xGap) * (i%3), pY + (btnH + yGap) * (i/3), btnW, btnH)];
        [wBtn addTarget:self action:@selector(hotWordsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        wBtn.layer.borderColor = Gray153Color.CGColor;
        wBtn.layer.borderWidth = 1.0f;
        wBtn.layer.cornerRadius = 2.0f;
        [self addSubview:wBtn];
    }
}

- (void)hotWordsBtnClick:(UIButton *)sender {
    NSLog(@"%@", sender.titleLabel.text);
    [self.myDelegate hotSearchWordsBtnClick:sender.titleLabel.text];
}

@end
