//
//  PlaceHolderTextView.m
//  QiuPai
//
//  Created by bigqiang on 15/11/19.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "PlaceHolderTextView.h"

@implementation PlaceHolderTextView
@synthesize placeHolderLabel;
@synthesize placeholder = _placeholder;
@synthesize placeholderColor = _placeholderColor;

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setPlaceholder:@""];
    [self setPlaceholderColor:Gray202Color];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)setPlaceholderColor:(UIColor *)placeholderCol {
    _placeholderColor = placeholderCol;
    [self.placeHolderLabel setTextColor:placeholderCol];
}

- (void)setPlaceholder:(NSString *)placeholderStr {
    _placeholder = placeholderStr;
    [self.placeHolderLabel setText:placeholderStr];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if( (self = [super initWithFrame:frame])) {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:Gray202Color];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
        
        placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, (self.bounds.size.height - 24)/2, self.bounds.size.width - 16, 20)];
        placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.font = self.font;
        placeHolderLabel.backgroundColor = [UIColor clearColor];
        placeHolderLabel.textColor = self.placeholderColor;
        placeHolderLabel.alpha = 0;
        placeHolderLabel.tag = 999;
        [self addSubview:placeHolderLabel];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification {
    if([[self placeholder] length] == 0) {
        return;
    }

    if([[self text] length] == 0) {
        [[self viewWithTag:999] setAlpha:1];
    } else {
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if( [[self placeholder] length] > 0) {
        
        placeHolderLabel.text = self.placeholder;
//        [placeHolderLabel sizeToFit];
        [self sendSubviewToBack:placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 ) {
        [[self viewWithTag:999] setAlpha:1];
    }
}
@end
