//
//  AutoResizeLabel.m
//  QiuPai
//
//  Created by bigqiang on 15/11/28.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "AutoResizeLabel.h"

@implementation AutoResizeLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self updateSelfFrame];
}

- (void)updateSelfFrame {
    CGRect orignNameFrame = self.frame;
    CGRect newNameFrame = [self.text boundingRectWithSize:CGSizeMake(orignNameFrame.size.width, orignNameFrame.size.height) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName: self.font} context:nil];
    [self setFrame:CGRectMake(orignNameFrame.origin.x, orignNameFrame.origin.y, newNameFrame.size.width+5, newNameFrame.size.height)];
}

@end
