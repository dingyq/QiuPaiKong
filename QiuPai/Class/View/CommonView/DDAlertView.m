//
//  DDAlertView.m
//  QiuPai
//
//  Created by bigqiang on 15/12/31.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "DDAlertView.h"


@interface DDAlertView()
@property (nonatomic, strong) MenuItemClick    clickBlock;
@property (nonatomic, strong) UIView *bgMask;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *contentView;
@end

@implementation DDAlertView

static CGFloat cViewH = 153.0f;
static CGFloat cViewW = 216.0f;

- (instancetype)initWithTitle:(NSString *)title itemTitles:(NSArray *)titles itemTags:(NSArray *)tags {
    self = [self initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _bgMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, kFrameHeight)];
        _bgMask.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _bgMask.backgroundColor = mUIColorWithRGBA(0, 0, 0, 0.2);
        [self addSubview:_bgMask];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_bgMask addGestureRecognizer:tap];
        
//        _contentView = [[UIView alloc] initWithFrame:CGRectMake(kFrameWidth/2-cViewW/2, kFrameHeight, cViewW, cViewH)];
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(kFrameWidth/2-cViewW/2, kFrameHeight/2-cViewH/2, cViewW, cViewH)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        _contentView.layer.borderWidth = 1.0f;
        _contentView.layer.borderColor = [[UIColor clearColor] CGColor];
        _contentView.layer.cornerRadius = 4.0f;
        [self addSubview:_contentView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(cViewW/2-90, 15, 180, cViewH - 15*2 - 34)];
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _titleLabel.textColor = Gray51Color;
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        _titleLabel.numberOfLines = 0;
        [_titleLabel setText:title];
        [_contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerX.equalTo(@0);
            make.top.equalTo(@15);
            make.width.equalTo(@180);
            make.height.equalTo(@100);
        }];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame) + 15, cViewW, 0.5)];
        [lineView setBackgroundColor:LineViewColor];
        [_contentView addSubview:lineView];
        
        NSUInteger count = titles.count < tags.count ? titles.count : tags.count;
        CGFloat gap = 3.0f;
        CGFloat btnHeight = 34.0f;
        CGFloat btnWidth = 100.0f;
        CGFloat btnX = cViewW/2-btnWidth/2 - (count/2)*(btnWidth/2 + gap/2);
        CGFloat btnY = cViewH - btnHeight;
        for (int i = 0; i < count ; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
            btn.tag = [tags[i] integerValue];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:CustomGreenColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            [_contentView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make){
                make.bottom.equalTo(@0);
                make.width.equalTo(@(btnWidth));
                make.height.equalTo(@(btnHeight));
                make.left.equalTo(@(btnX));
            }];
            if (i > 0) {
                UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(btnX - gap/2, btnY, 0.5, btnHeight)];
                [lineV setBackgroundColor:LineViewColor];
                [_contentView addSubview:lineV];
                [lineV mas_makeConstraints:^(MASConstraintMaker *make){
                    make.left.equalTo(@(btnX - gap/2));
                    make.top.equalTo(@(btnY));
                    make.width.equalTo(@0.5);
                    make.height.equalTo(@(btnHeight));
                }];
            }
            
            btnX += (btnWidth + gap);
        }
        [lineView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(@(btnY));
            make.left.equalTo(@0);
            make.width.equalTo(@(cViewW));
            make.height.equalTo(@0.5);
        }];

    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    return self;
}

- (void)showWithClickBlock:(MenuItemClick)clickBlock {
    _clickBlock = clickBlock;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        [self.contentView setFrame:CGRectMake(kFrameWidth/2-cViewW/2, kFrameHeight/2-cViewH/2, cViewW, cViewH)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)clickAction:(UIButton *)sender {
    if (_clickBlock) {
        _clickBlock(sender.tag);
    }
    [self dismiss];
}

- (void)dismiss {
    _bgMask.alpha = 0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        [self.contentView setFrame:CGRectMake(kFrameWidth/2-cViewW/2, kFrameHeight, cViewW, cViewH)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
