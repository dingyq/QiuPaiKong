//
//  UserHeaderView.m
//  QiuPai
//
//  Created by bigqiang on 15/11/22.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "UserHeaderView.h"
#import "UIImageView+WebCache.h"

@interface UserHeaderView(){
    UIButton *_attentionBtn;
    UIView *_circleTip;
    UIButton *_headTapBtn;
}

@end

@implementation UserHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CAGradientLayer *_gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
        _gradientLayer.bounds = self.bounds;
        _gradientLayer.borderWidth = 0;
        _gradientLayer.frame = self.bounds;
        _gradientLayer.colors = [NSArray arrayWithObjects:
                                 (id)[CustomGreenColor CGColor],
                                 (id)[mUIColorWithRGB(1, 158, 99) CGColor], nil];
        _gradientLayer.startPoint = CGPointMake(0.5, 0.42);
        _gradientLayer.endPoint = CGPointMake(0.5, 1.0);
        [self.layer insertSublayer:_gradientLayer atIndex:0];
        
        _headView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 52, 67, 67)];
        _headView.layer.borderColor = [UIColor whiteColor].CGColor;
        _headView.layer.cornerRadius = 67.0/2;
        _headView.layer.borderWidth = 2.0f;
        [_headView setClipsToBounds:YES];
        [self addSubview:_headView];
        
        _circleTip = [[UIView alloc] initWithFrame:CGRectMake(7, 52 - 3.5, 74, 74)];
        [_circleTip setBackgroundColor:[UIColor clearColor]];
        _circleTip.layer.borderWidth = 0.5f;
        _circleTip.layer.cornerRadius = 74.0/2;
        _circleTip.layer.borderColor = mUIColorWithRGBA(255, 255, 255, 0.5).CGColor;
        [_circleTip setCenter:[_headView center]];
//        [self addSubview:_circleTip];
        _headTapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headTapBtn setTitle:@"" forState:UIControlStateNormal];
        [_headTapBtn setFrame:CGRectMake(0, 0, 74, 74)];
        [_headTapBtn addTarget:self action:@selector(headImagePress:) forControlEvents:UIControlEventTouchUpInside];
//        [_circleTip addSubview:_headTapBtn];
        [self addSubview:_headTapBtn];
        [_headTapBtn setCenter:[_headView center]];

        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headView.frame) + 6, 69, 130, 23)];
        [_nameLabel setTextColor:[UIColor whiteColor]];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:19.0]];
        [_nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_nameLabel];
        
        _sexImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame) + 3, 15, 15)];
        [self addSubview:_sexImage];
        
        _ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_sexImage.frame) + 4, CGRectGetMinY(_sexImage.frame), 35, 18)];
        [_ageLabel setTextColor:mUIColorWithRGB(97, 255, 195)];
        [_ageLabel setBackgroundColor:[UIColor clearColor]];
        [_ageLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_ageLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_ageLabel];

        _otherInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kFrameWidth/2, 97, kFrameWidth/2 - 7, 16)];
        [_otherInfoLabel setTextColor:[UIColor whiteColor]];
        [_otherInfoLabel setBackgroundColor:[UIColor clearColor]];
        [_otherInfoLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_otherInfoLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_otherInfoLabel];

        _racketLabel = [[UILabel alloc] initWithFrame:CGRectMake(kFrameWidth/2, CGRectGetMaxY(_otherInfoLabel.frame)+3, kFrameWidth/2, 16)];
        [_racketLabel setTextColor:[UIColor whiteColor]];
        [_racketLabel setBackgroundColor:[UIColor clearColor]];
        [_racketLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_racketLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_racketLabel];
        
        _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attentionBtn setFrame:CGRectMake(kFrameWidth - 100, 75, 75, 29)];
        _attentionBtn.layer.borderWidth = 0.5f;
        [_attentionBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        _attentionBtn.layer.cornerRadius = 2.0f;
        _attentionBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [_attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_attentionBtn addTarget:self action:@selector(attentionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_attentionBtn setHidden:YES];
        [self addSubview:_attentionBtn];
    }
    return self;
}

- (void)attentionBtnClick:(UIButton *)sender {
    [self.myDelegate sendAttentionUserRequest:@""];
}

- (void)setHeadViewImage:(NSString *)strValue {
    [_headView sd_setImageWithURL:[NSURL URLWithString:strValue] placeholderImage:[UIImage imageNamed:@"placeholder_head.png"]];
}

- (void)setNameLabelText:(NSString *)strValue {
    [_nameLabel setText:strValue];
    [_nameLabel sizeToFit];
    if (_isMyHeader) {
        CGRect originFrame = [_nameLabel frame];
        originFrame.origin.x = kFrameWidth/2 - originFrame.size.width/2;
        [_nameLabel setFrame:originFrame];
        [_sexImage setFrame:CGRectMake(_nameLabel.frame.origin.x - 15 - 3, _nameLabel.frame.origin.y+5, 15, 15)];
    }
}

- (void)setSexImageTip:(NSInteger)sexIndictator {
    NSString *sexStr = @"tip_female.png";
    if (sexIndictator == 0) {
        if (_isMyHeader) {
            sexStr = @"sex_male_white_indicator.png";
        } else {
            sexStr = @"tip_male.png";
        }
        
    } else {
        if (_isMyHeader) {
            sexStr = @"sex_female_white_indicator.png";
        } else {
            sexStr = @"tip_female.png";
        }
    }
    [_sexImage setImage:[UIImage imageNamed:sexStr]];
}

- (void)setAgeLabelText:(NSString *)strValue {
    [_ageLabel setText:strValue];
    [_ageLabel sizeToFit];
}

- (void)setRacketLabelText:(NSString *)strValue {
    [_racketLabel setText:[NSString stringWithFormat:@"使用球拍:%@", strValue]];
    [_racketLabel sizeToFit];
}

- (void)setOtherInfoLabelText:(NSString *)strValue {
    [_otherInfoLabel setText:[NSString stringWithFormat:@"打法:%@", strValue]];
    [_otherInfoLabel sizeToFit];
}

- (void)setIsMyHeader:(BOOL)isMyHeader {
    [_racketLabel setHidden:YES];
    [_otherInfoLabel setHidden:YES];
    _isMyHeader = isMyHeader;
    if (isMyHeader) {
        [_ageLabel setHidden:YES];
        [_attentionBtn setHidden:YES];
        [_headView setFrame:CGRectMake(kFrameWidth/2 - 67.0/2, 28, 67, 67)];
        [_circleTip setCenter:[_headView center]];
        [_headTapBtn setCenter:[_headView center]];
        [_nameLabel setFrame:CGRectMake(kFrameWidth/2 - 130.0/2, 108, 130, 23)];
        [_sexImage setFrame:CGRectMake(_nameLabel.frame.origin.x - 3, CGRectGetMaxY(_nameLabel.frame) + 5, 15, 15)];
        
    } else {
        [_ageLabel setHidden:NO];
        [_attentionBtn setHidden:NO];
        [_headView setFrame:CGRectMake(35, 52, 67, 67)];
        [_headTapBtn setCenter:[_headView center]];
        [_circleTip setCenter:[_headView center]];
        [_nameLabel setFrame:CGRectMake(CGRectGetMaxX(_headView.frame) + 10, 63, 130, 23)];
        [_sexImage setFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame) + 3, 15, 15)];
        [_ageLabel setFrame:CGRectMake(CGRectGetMaxX(_sexImage.frame) + 4, CGRectGetMinY(_sexImage.frame), 35, 18)];
    }
}

- (void)setUserAttentioned:(NSInteger)attentionState {
    NSString *titleStr = @"+关注";
    if (attentionState == ConcernedState_HuFen) {
        titleStr = @"已互粉";
        _attentionBtn.layer.borderColor = mUIColorWithRGB(97, 255, 195).CGColor;
        [_attentionBtn setTitleColor:mUIColorWithRGB(97, 255, 195) forState:UIControlStateNormal];
    } else if (attentionState == ConcernedState_Attentioned) {
        titleStr = @"已关注";
        _attentionBtn.layer.borderColor = mUIColorWithRGB(97, 255, 195).CGColor;
        [_attentionBtn setTitleColor:mUIColorWithRGB(97, 255, 195) forState:UIControlStateNormal];
    } else {
        _attentionBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [_attentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [_attentionBtn setTitle:titleStr forState:UIControlStateNormal];
}

- (void)setLoginState:(BOOL)isLogin {
    if (isLogin) {
        [_sexImage setHidden:NO];
        [_nameLabel setHidden:NO];
        [_headTapBtn setEnabled:NO];
    } else {
        [_headView setImage:[UIImage imageNamed:@"placeholder_head_logout.jpg"]];
        [_sexImage setHidden:YES];
        [_nameLabel setHidden:YES];
        [_headTapBtn setEnabled:YES];
    }
}

- (void)headImagePress:(UITapGestureRecognizer *)tap {
    NSLog(@"headImagePress");
    if ([[QiuPaiUserModel getUserInstance] isTimeOut]) {
        [[QiuPaiUserModel getUserInstance] showUserLoginVC];
    }
}


@end
