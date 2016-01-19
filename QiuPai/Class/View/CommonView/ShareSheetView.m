//
//  ShareSheetView.m
//  QiuPai
//
//  Created by bigqiang on 15/12/22.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "ShareSheetView.h"
#import "ShareSheetItem.h"

#define SHARE_VIEW_TAG 9991

@interface ShareSheetView()

@property (nonatomic, strong) ClickBlock    clickBlock;
@property (nonatomic, strong) CancelBlock   cancelBlock;

@property (nonatomic, strong) UIView *backgroundMask;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, retain) UIScrollView *scrollView;

@end

@implementation ShareSheetView

//- (instancetype)initWithTitles:(NSArray *)titles iconNames:(NSArray *)iconNames {
- (instancetype)initWithTitleAndIcons:(NSArray *)config {
    self = [self initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.backgroundMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight)];
        self.backgroundMask.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundMask.backgroundColor = mUIColorWithRGBA(0, 0, 0, 0.2);
        [self addSubview:self.backgroundMask];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self.backgroundMask addGestureRecognizer:tap];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kFrameHeight, kFrameWidth, 170)];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:self.contentView];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self.contentView addGestureRecognizer:tap2];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 121)];
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setScrollEnabled:YES];
        _scrollView.backgroundColor = [UIColor whiteColor];
        
        CGFloat itemWidth = 50.0f;
        NSUInteger count = config.count;
        CGFloat gap = (self.scrollView.frame.size.width - count*itemWidth)/(count+1);
        CGFloat itemX = gap;
        for (int i = 0; i < count ; i++) {
            NSDictionary *configDic = [config objectAtIndex:i];
            ShareSheetItem *item = [[ShareSheetItem alloc] initWithFrame:CGRectMake(itemX, 25, itemWidth, 85)];
            item.btnIndex = i;
            [item setTitle:configDic[@"name"] image:[UIImage imageNamed:configDic[@"image"]]];
            [item addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:item];
            itemX += (itemWidth + gap);
        }
        _scrollView.contentSize = CGSizeMake(itemX, CGRectGetHeight(_scrollView.bounds));
        
        CGFloat btnY = _scrollView.frame.size.height + _scrollView.frame.origin.y;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        btn.frame = CGRectMake(0, btnY, self.frame.size.width, 49);
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:Gray51Color forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        [self.contentView addSubview:_scrollView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, btnY-0.5, kFrameWidth, 0.5)];
        [lineView setBackgroundColor:LineViewColor];
        [self.contentView addSubview:lineView];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    return self;
}

- (void)clickAction:(ShareSheetItem *)item {
    if (_clickBlock) {
        _clickBlock(item.btnIndex);
    }
    [self dismiss];
}

- (void)setContentViewFrameY:(CGFloat)y {
    CGRect frame = self.contentView.frame;
    frame.origin.y = y;
    self.contentView.frame = frame;
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.backgroundMask.alpha = 0;
        [self.contentView setFrame:CGRectMake(0, kFrameHeight, kFrameWidth, 170)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showActionSheetWithClickBlock:(ClickBlock)clickBlock cancelBlock:(CancelBlock)cancelBlock {
    _clickBlock = clickBlock;
    _cancelBlock = cancelBlock;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.contentView setFrame:CGRectMake(0, kFrameHeight-170, kFrameWidth, 170)];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dealloc {
//    NSLog(@"%s",__func__);
}

@end
