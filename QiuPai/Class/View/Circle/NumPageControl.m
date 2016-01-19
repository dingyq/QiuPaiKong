//
//  NumPageControl.m
//  QiuPai
//
//  Created by bigqiang on 15/12/14.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "NumPageControl.h"

@interface NumPageControl() {
    
}

@end

@implementation NumPageControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _gapOfIndicator = 18;
        _pageIndicatorTintColor = mUIColorWithRGBA(0, 0, 0, 0.2);
        _currentPageIndicatorTintColor = mUIColorWithRGBA(0, 0, 0, 0.6);
    }
    return self;
}

- (void)drawRect:(CGRect)rect {

}

- (void)updateDots {
    CGFloat widthMin = _gapOfIndicator * (_numberOfPages - 1);
    
    for (UIView *dotView in [self subviews]) {
        [dotView setHidden:YES];
    }
    
    for (int i = 0; i < _numberOfPages; i++) {
        NSInteger tag = 100+i;
        CGFloat width = 9.0/2;
        UIView *tmpView = [self viewWithTag:tag];
        if (!tmpView) {
            tmpView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height/2, width, width)];
            tmpView.layer.borderColor = [[UIColor clearColor] CGColor];
            tmpView.translatesAutoresizingMaskIntoConstraints = NO;
            tmpView.layer.borderWidth = 1.0f;
            [tmpView setTag:tag];
            [self addSubview:tmpView];
            
            UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
            [tipLabel setTextColor:[UIColor whiteColor]];
            [tipLabel setText:[NSString stringWithFormat:@"%d", i+1]];
            [tipLabel setTextAlignment:NSTextAlignmentCenter];
            [tipLabel setFont:[UIFont systemFontOfSize:12]];
//            [tipLabel setCenter:[tmpView center]];
            [tipLabel setTag:999];
            [tipLabel setHidden:YES];
            [tmpView addSubview:tipLabel];
            
//            NSLayoutConstraint *tC = [NSLayoutConstraint constraintWithItem:tmpView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:10];
//            NSLayoutConstraint *lC = [NSLayoutConstraint constraintWithItem:tmpView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10];
//            NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:tmpView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-widthMin/2 + i * _gapOfIndicator];
//            NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:tmpView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
//            [self addConstraints:@[tC, lC]];
        }
        [tmpView setHidden:NO];
        UILabel *tipLabel = [tmpView viewWithTag:999];
        if (_currentPage == i) {
            width = 15.0f;
            [tmpView setBackgroundColor:_currentPageIndicatorTintColor];
            [tipLabel setHidden:NO];
        } else {
            width = 9.0f/2;
            [tmpView setBackgroundColor:_pageIndicatorTintColor];
            [tipLabel setHidden:YES];
        }
        tmpView.layer.cornerRadius = width/2;
        [tmpView setFrame:CGRectMake(self.frame.size.width/2 - widthMin/2 - width/2 + i*_gapOfIndicator, self.frame.size.height/2 - width/2, width, width)];
        [tipLabel setCenter:CGPointMake(width/2, width/2)];
    }
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    [self updateDots];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    [self updateDots];
}


@end
