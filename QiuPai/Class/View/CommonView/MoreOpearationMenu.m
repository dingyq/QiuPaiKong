//
//  MoreOpearationMenu.m
//  QiuPai
//
//  Created by bigqiang on 15/12/29.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "MoreOpearationMenu.h"

@interface MoreOpearationMenu()

@property (nonatomic, strong) MenuItemClick    clickBlock;
@property (nonatomic, strong) MenuItemCancel   cancelBlock;
@property (nonatomic, strong) UIView *bgMask;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation MoreOpearationMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

static CGFloat ContentViewH = 0.0f;

- (instancetype)initWithTitles:(NSArray *)titles itemTags:(NSArray *)tags {
    self = [self initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _bgMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight)];
        _bgMask.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _bgMask.backgroundColor = mUIColorWithRGBA(0, 0, 0, 0.2);
        [self addSubview:_bgMask];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_bgMask addGestureRecognizer:tap];
     
        NSUInteger count = titles.count < tags.count ? titles.count : tags.count;
        CGFloat btnY = 0.0f;
        CGFloat gap = 4.0f;
        CGFloat btnHeight = 49.0f;
        ContentViewH = (count+1)*btnHeight + gap;
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kFrameHeight, kFrameWidth, ContentViewH)];
        [_contentView setBackgroundColor:Gray240Color];
//        _contentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_contentView];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_contentView addGestureRecognizer:tap2];
        
        for (int i = 0; i < count ; i++) {
            UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
            [item setFrame:CGRectMake(0, btnY, CGRectGetWidth(self.frame), btnHeight)];
            item.tag = [tags[i] integerValue];
            [item setTitleColor:Gray51Color forState:UIControlStateNormal];
            item.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            [item setBackgroundColor:[UIColor whiteColor]];
            [item setTitle:titles[i] forState:UIControlStateNormal];
            [item addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            [_contentView addSubview:item];
            btnY = btnY + btnHeight;
            
            if (i != count - 1) {
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, btnY-0.5, kFrameWidth, 0.5)];
                [lineView setBackgroundColor:LineViewColor];
                [_contentView addSubview:lineView];
            }
        }
        
        btnY += gap;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        btn.frame = CGRectMake(0, btnY, self.frame.size.width, btnHeight);
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn setTitleColor:Gray51Color forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:btn];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    return self;
}

- (void)clickAction:(UIButton *)sender {
    if (_clickBlock) {
        _clickBlock(sender.tag);
    }
    [self dismiss];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _bgMask.alpha = 0;
        [self.contentView setFrame:CGRectMake(0, kFrameHeight, kFrameWidth, ContentViewH)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showActionSheetWithClickBlock:(MenuItemClick)clickBlock cancelBlock:(MenuItemCancel)cancelBlock {
    _clickBlock = clickBlock;
    _cancelBlock = cancelBlock;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.contentView setFrame:CGRectMake(0, kFrameHeight-ContentViewH, kFrameWidth, ContentViewH)];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)dealloc {
    //    NSLog(@"%s",__func__);
}


@end
