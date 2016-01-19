//
//  CustomImageButton.m
//  QiuPai
//
//  Created by bigqiang on 16/1/17.
//  Copyright © 2016年 barbecue. All rights reserved.
//

#import "CustomImageButton.h"

@interface CustomImageButton(){

}

//@property (nonatomic, strong) UIImageView *tipImageV;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *titleL;

@end

@implementation CustomImageButton

- (instancetype)initWithFrame:(CGRect)frame norImage:(NSString *)norImage selImage:(NSString *)selImage imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets title:(NSString *)title tip:(NSString *)tip {
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:norImage] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:selImage] forState:UIControlStateSelected];
        self.imageEdgeInsets = imageEdgeInsets;

        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width*2/5, frame.size.height/2-20, frame.size.width/2, 20)];
        [_titleL setTextAlignment:NSTextAlignmentCenter];
        [_titleL setText:title];
        [self addSubview:_titleL];
        
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width*2/5, frame.size.height/2, frame.size.width/2, 20)];
        [_tipLabel setTextAlignment:NSTextAlignmentCenter];
        [_tipLabel setText:tip];
        [self addSubview:_tipLabel];
    }
    return self;
}

- (void)setTipColor:(UIColor *)color {
    [_tipLabel setTextColor:color];
}

- (void)setTip:(NSString *)tip {
    [_tipLabel setText:tip];
}

- (void)setTipFont:(CGFloat)pointSize {
    [_tipLabel setFont:[UIFont systemFontOfSize:pointSize]];
}


- (void)setTitle:(NSString *)title {
    [_titleL setText:title];
}

- (void)setTitleLabelColor:(UIColor *)color {
    [_titleL setTextColor:color];
}

- (void)setTitleLFont:(CGFloat)pointSize {
    [_titleL setFont:[UIFont systemFontOfSize:pointSize]];
}

@end
