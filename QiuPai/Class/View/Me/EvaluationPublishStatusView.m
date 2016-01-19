//
//  EvaluationPublishStatusView.m
//  QiuPai
//
//  Created by bigqiang on 15/11/27.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "EvaluationPublishStatusView.h"

@interface EvaluationPublishStatusView() {
    UIProgressView *_progressView;
    UILabel *_sendTipL;
}

@end

@implementation EvaluationPublishStatusView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0]];
//        [self loadMySubView];
        [self initSendTipView];
        [self setWindowLevel:UIWindowLevelAlert+2];
    }
    return self;
}

- (void)initSendTipView {
    UIView *sendTipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
    [sendTipView setBackgroundColor:[UIColor blackColor]];
    
    _sendTipL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
    [_sendTipL setFont:[UIFont systemFontOfSize:12.0f]];
    [_sendTipL setTextColor:[UIColor whiteColor]];
    [_sendTipL setText:@"发送中0%"];
    [_sendTipL setTextAlignment:NSTextAlignmentCenter];
    [sendTipView addSubview:_sendTipL];
    
    [self addSubview:sendTipView];
}

- (void)loadMySubView {
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [_progressView setProgress:0 animated:YES];
    [_progressView setProgressTintColor:[UIColor redColor]];
    [_progressView setFrame:CGRectMake(0, 64, kFrameWidth, 30)];
    [self addSubview:_progressView];
}

- (void)updateProgress:(CGFloat)gress {
//    [_progressView setProgress:gress animated:YES];
    [_sendTipL setText:[NSString stringWithFormat:@"发送中%.0f%%", gress*100]];
    NSLog(@"gress is %.0f", gress*100);
}

- (void)show {
    [self makeKeyAndVisible];
}

- (void)hide {
    [self resignKeyWindow];
    [self setHidden:YES];
//    [self setWindowLevel:UIWindowLevelNormal];
}

@end
