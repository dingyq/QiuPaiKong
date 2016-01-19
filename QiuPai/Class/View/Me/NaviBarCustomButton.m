//
//  NaviBarCustomButton.m
//  QiuPai
//
//  Created by bigqiang on 15/11/23.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "NaviBarCustomButton.h"

@interface NaviBarCustomButton() {
    
}

@end

@implementation NaviBarCustomButton

- (instancetype)initWithFrame:(CGRect)frame numTip:(NSString *)numStr tipTitle:(NSString *)tipStr {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *tipTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/2 - 2, frame.size.width, frame.size.height/2)];
        [tipTitleLabel setTextColor:Gray51Color];
        [tipTitleLabel setBackgroundColor:[UIColor clearColor]];
        [tipTitleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [tipTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [tipTitleLabel setText:tipStr];
        [self addSubview:tipTitleLabel];
        
        [self setTitle:numStr];
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.titleEdgeInsets = UIEdgeInsetsMake(2, 0, self.frame.size.height/2, 0);
}

- (void)setTitle:(NSString *)strValue {
    [self setTitle:strValue forState:UIControlStateNormal];
    [self setTitle:strValue forState:UIControlStateHighlighted];
}


@end
