//
//  LikeButton.m
//  QiuPai
//
//  Created by bigqiang on 15/11/27.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "LikeButton.h"

@implementation LikeButton

- (instancetype)initWithFrame:(CGRect)frame numTip:(NSString *)numStr {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [self setTitle:numStr forState:UIControlStateNormal];
        [self setTitle:numStr forState:UIControlStateHighlighted];
        [self setTitle:numStr forState:UIControlStateSelected];
        
        [self setImage:[UIImage imageNamed:@"like_normal.png"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"like_select.png"] forState:UIControlStateSelected];
        [self setImage:[UIImage imageNamed:@"like_select.png"] forState:UIControlStateHighlighted];
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
//    self.titleEdgeInsets = UIEdgeInsetsMake(0, 22, 0, 0);
    self.imageEdgeInsets = UIEdgeInsetsMake((self.frame.size.height-22)/2, 0, (self.frame.size.height-22)/2, self.frame.size.width -22);
}

- (void)setTitleTip:(NSString *)numStr {
    [self setTitle:numStr forState:UIControlStateNormal];
    [self setTitle:numStr forState:UIControlStateHighlighted];
    [self setTitle:numStr forState:UIControlStateSelected];
}
@end
