//
//  SexChooseView.m
//  QiuPai
//
//  Created by bigqiang on 15/12/14.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "SexChooseView.h"

@interface SexChooseView() {
    NSMutableArray *_btnArr;
}

@end

@implementation SexChooseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:VCViewBGColor];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, kFrameWidth - 20, 16)];
        [tipLabel setTextAlignment:NSTextAlignmentLeft];
        [tipLabel setText:@"1、选择性别"];
        [tipLabel setFont:[UIFont systemFontOfSize:15]];
        [tipLabel setTextColor:Gray85Color];
        [self addSubview:tipLabel];
        
        CGFloat btnWidth = 96.0f;
        CGFloat btnGap = 60.0f;
        CGFloat btnOrignX = (frame.size.width - btnWidth*2 - btnGap)/2;
        _btnArr = [[NSMutableArray alloc] init];
        UIButton *maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [maleBtn setFrame:CGRectMake(btnOrignX, 140, btnWidth, btnWidth)];
        [maleBtn setTitle:@"男" forState:UIControlStateNormal];
        [maleBtn setTitle:@"男" forState:UIControlStateSelected];
        [maleBtn setBackgroundColor:mUIColorWithRGB(44, 187, 232)];
        [maleBtn setImage:[UIImage imageNamed:@"sex_male_white_indicator.png"] forState:UIControlStateNormal];
        [maleBtn setImage:[UIImage imageNamed:@"sex_male_white_indicator.png"] forState:UIControlStateSelected];
        [maleBtn addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [maleBtn setTag:100];
        maleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        maleBtn.layer.borderColor = [[UIColor clearColor] CGColor];
        maleBtn.layer.borderWidth = 1.0f;
        maleBtn.layer.cornerRadius = 19.0f;
        [self addSubview:maleBtn];
        
        UIButton *femaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [femaleBtn setFrame:CGRectMake(btnOrignX+btnWidth+btnGap, 140, btnWidth, btnWidth)];
        [femaleBtn setTitle:@"女" forState:UIControlStateNormal];
        [femaleBtn setTitle:@"女" forState:UIControlStateSelected];
        [femaleBtn setBackgroundColor:mUIColorWithRGB(240, 117, 137)];
        [femaleBtn setImage:[UIImage imageNamed:@"sex_female_white_indicator.png"] forState:UIControlStateNormal];
        [femaleBtn setImage:[UIImage imageNamed:@"sex_female_white_indicator.png"] forState:UIControlStateSelected];
        [femaleBtn addTarget:self action:@selector(sexBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [femaleBtn setTag:200];
        femaleBtn.layer.borderColor = [[UIColor clearColor] CGColor];
        femaleBtn.layer.borderWidth = 1.0f;
        femaleBtn.layer.cornerRadius = 19.0f;
        [self addSubview:femaleBtn];
        
    }
    return self;
}

- (void)sexBtnClick:(UIButton *)sender {
    if ([sender isSelected]) {
        return;
    }    
    [self resetSexBtn:([sender tag]/100 - 1)];
}

- (void)resetSexBtn:(SexIndicator)sex {
    NSInteger tag = (sex + 1)*100;
    UIButton *maleBtn = [self viewWithTag:100];
    UIButton *femaleBtn = [self viewWithTag:200];
    if (tag == 100) {
        [maleBtn setSelected:YES];
        [maleBtn setBackgroundColor:mUIColorWithRGB(44, 187, 232)];
        [femaleBtn setSelected:NO];
        [femaleBtn setBackgroundColor:mUIColorWithRGB(245, 215, 220)];
    } else {
        [femaleBtn setSelected:YES];
        [femaleBtn setBackgroundColor:mUIColorWithRGB(240, 117, 137)];
        [maleBtn setSelected:NO];
        [maleBtn setBackgroundColor:mUIColorWithRGB(189, 231, 244)];
    }
    [self.myDelegate sexChooseDone:sex];
}
@end
