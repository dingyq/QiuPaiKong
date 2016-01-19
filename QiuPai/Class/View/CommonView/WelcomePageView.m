//
//  WelcomePageView.m
//  QiuPai
//
//  Created by bigqiang on 16/1/4.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import "WelcomePageView.h"

@interface WelcomePageView() <UIScrollViewDelegate> {
    UIScrollView *_contentSView;
    UIPageControl *_pageControl;
}

@end

static NSInteger pageCount = 1;

@implementation WelcomePageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        _contentSView = [[UIScrollView alloc] initWithFrame:frame];
        _contentSView.pagingEnabled = YES;
        _contentSView.contentSize = CGSizeMake(frame.size.width*pageCount,frame.size.height);
        _contentSView.showsHorizontalScrollIndicator = NO;
        _contentSView.showsVerticalScrollIndicator = NO;
        _contentSView.scrollsToTop = NO;
        _contentSView.bounces = NO;
        _contentSView.delegate = self;
        [self addSubview:_contentSView];
        
        for (int i = 0; i < pageCount; i++) {
            UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i*frame.size.width, (frame.size.height-401)*0.5, frame.size.width, 401)];
            imageV.image = [Helper bundleImageFile:[NSString stringWithFormat:@"tutor%d.png",i+1]];
            [_contentSView addSubview:imageV];
        }
        
    }
    return self;
}



@end
