//
//  DDActivityIndicatorView.m
//  QiuPai
//
//  Created by bigqiang on 15/12/17.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "DDActivityIndicatorView.h"

@interface DDActivityIndicatorView() {
    UIActivityIndicatorView *_actiIndicator;
}

@end

@implementation DDActivityIndicatorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, 54, 54)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        _actiIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 54, 54)];
        [_actiIndicator setCenter:CGPointMake(frame.size.width/2, frame.size.height/2)];
        [_actiIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        [_actiIndicator stopAnimating];
        [self addSubview:_actiIndicator];
    }
    return self;
}

- (void)hide {
//    [_actiIndicator stopAnimating];
}

- (void)show {
//    [_actiIndicator startAnimating];
}

@end
