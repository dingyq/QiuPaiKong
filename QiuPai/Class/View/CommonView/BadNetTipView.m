//
//  BadNetTipView.m
//  QiuPai
//
//  Created by bigqiang on 15/12/18.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "BadNetTipView.h"

@interface BadNetTipView() {
    UIButton *_bgBtn;
}

@end

@implementation BadNetTipView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame withRetryEvent:nil];
}

- (instancetype)initWithFrame:(CGRect)frame withRetryEvent:(RetryConnectNetEvent)event {
    self = [super initWithFrame:frame];
    if (self) {
        _retryEvent = event;
        [self setBackgroundColor:[UIColor clearColor]];
        
        CGFloat originY = frame.size.height/4;
        CGFloat imageWidth = 33.0f;
        
        _bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgBtn setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_bgBtn setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_bgBtn];
        
        UIImageView *_tipImage = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2 - imageWidth/2, originY, imageWidth, imageWidth)];
        [_tipImage setImage:[UIImage imageNamed:@"bad_net_tip.png"]];
        [self addSubview:_tipImage];
        originY += imageWidth + 20;
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, originY + imageWidth + 20, frame.size.width, 30)];
        [tipLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [tipLabel setText:@"无法由网络获取相关信息"];
        [tipLabel setTextColor:Gray153Color];
        [tipLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:tipLabel];
        originY += 20 + 30;
        
        UIButton *tryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tryBtn setFrame:CGRectMake(frame.size.width/2 - 85/2, originY + imageWidth + 70, 85, 31)];
        [tryBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [tryBtn setTitle:@"重新加载" forState:UIControlStateSelected];
        tryBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [tryBtn setTitleColor:Gray85Color forState:UIControlStateNormal];
        [tryBtn setTitleColor:Gray85Color forState:UIControlStateSelected];
        tryBtn.layer.borderColor = Gray102Color.CGColor;
        tryBtn.layer.borderWidth = 1.0f;
        tryBtn.layer.cornerRadius = 2.0f;
        [tryBtn setBackgroundColor:[UIColor clearColor]];
        [self addSubview:tryBtn];
    }
    return self;
}

- (void)bgBtnClick:(UIButton *)sender {
    [self hide];
    if (_retryEvent) {
        _retryEvent(sender);
    }
}

- (void)setRetryEvent:(RetryConnectNetEvent)retryEvent {
    _retryEvent = retryEvent;
}

- (void)show {
//    [self setHidden:NO];
    [self setHidden:YES];
}

- (void)hide {
    [self setHidden:YES];
}

@end
