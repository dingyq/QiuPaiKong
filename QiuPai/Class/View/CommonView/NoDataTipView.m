//
//  NoDataTipView.m
//  QiuPai
//
//  Created by bigqiang on 15/12/18.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "NoDataTipView.h"

@interface NoDataTipView() {
    UILabel *_tipLabel;
}

@end

@implementation NoDataTipView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame tipStr:@"暂无数据"];
}

- (instancetype)initWithFrame:(CGRect)frame tipStr:(NSString *)tipStr {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat tipWidth = 200;
        CGFloat tipHeight = 60;
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2 - tipWidth/2, frame.size.height/2 - tipHeight, tipWidth, tipHeight)];
        [_tipLabel setFont:[UIFont systemFontOfSize:15.0]];
        [_tipLabel setTextColor:Gray202Color];
        [_tipLabel setText:tipStr];
        [_tipLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_tipLabel];
    }
    
    return self;
}

- (void)setTipText:(NSString *)tipText {
    _tipText = tipText;
    [_tipLabel setText:tipText];
}

- (void)showWithTip:(NSString *)tip {
    if (tip && ![tip isEqualToString:@""]) {
        [_tipLabel setText:tip];
    }
    [self show];
}

- (void)show {
    [self setHidden:NO];
}

- (void)hide {
    [self setHidden:YES];
}


@end
