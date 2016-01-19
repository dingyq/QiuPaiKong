//
//  ButtonImageView.m
//  QiuPai
//
//  Created by bigqiang on 15/12/2.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "ButtonImageView.h"

@implementation ButtonImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [editBtn setFrame:CGRectMake(frame.size.width - 20, 0, 20, 20)];
        [self addSubview:editBtn];
        [editBtn setBackgroundColor:mUIColorWithRGBA(0, 0, 0, 0.2)];
        [editBtn setTitle:@"X" forState:UIControlStateNormal];
        [editBtn setTitle:@"X" forState:UIControlStateSelected];
        [editBtn setTitle:@"X" forState:UIControlStateHighlighted];
        [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        editBtn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
        [editBtn addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)editButtonClick:(UIButton *)sender {
    [self removeFromSuperview];
}

@end
