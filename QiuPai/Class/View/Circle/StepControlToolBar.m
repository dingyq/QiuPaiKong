//
//  StepControlToolBar.m
//  QiuPai
//
//  Created by bigqiang on 15/12/15.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "StepControlToolBar.h"

@interface StepControlToolBar() {
    
}

@end

@implementation StepControlToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
        [lineView setBackgroundColor:LineViewColor];
        [self addSubview:lineView];
        
        _currentStep = 0;
        _numberOfStep = 3;
        
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setFrame:CGRectMake(0, 0, frame.size.width/2, frame.size.height)];
        [btn1 setTitle:@"上一步" forState:UIControlStateNormal];
        [btn1 setTitle:@"上一步" forState:UIControlStateHighlighted];
        [btn1 setTitle:@"上一步" forState:UIControlStateDisabled];
        [btn1 setTitleColor:CustomGreenColor forState:UIControlStateNormal];
        [btn1 setTitleColor:CustomGreenColor forState:UIControlStateHighlighted];
        [btn1 setTitleColor:Gray153Color forState:UIControlStateDisabled];
        [btn1 setTag:100];
        [btn1 addTarget:self action:@selector(stepBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn1];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setFrame:CGRectMake(frame.size.width/2, 0, frame.size.width/2, frame.size.height)];
        [btn2 setTitle:@"下一步" forState:UIControlStateNormal];
        [btn2 setTitle:@"下一步" forState:UIControlStateHighlighted];
        [btn2 setTitle:@"下一步" forState:UIControlStateDisabled];
        [btn2 setTitleColor:CustomGreenColor forState:UIControlStateNormal];
        [btn2 setTitleColor:CustomGreenColor forState:UIControlStateHighlighted];
        [btn2 setTitleColor:Gray153Color forState:UIControlStateDisabled];
        [btn2 setTag:200];
        [btn2 addTarget:self action:@selector(stepBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn2];
        
        [self updateSelf];
    }
    
    return self;
}

- (void)stepBtnClick:(UIButton *)sender {
    NSLog(@"%ld", (long)sender.tag);
    
    NSInteger btnTag = [sender tag];
    if (btnTag == 100) {
        _currentStep -- ;
        if (_currentStep < 0) {
            _currentStep = 0;
        }
        [self updateSelf];
        [self.myDelegate preStepBtnClick:sender];
    } else {
        _currentStep ++;
        if (_currentStep > _numberOfStep) {
            _currentStep = _numberOfStep - 1;
        }
        [self updateSelf];
        [self.myDelegate nextStepBtnClick:sender];
    }
}

- (void)setNumberOfStep:(NSInteger)numberOfStep {
    _numberOfStep = numberOfStep;
    [self updateSelf];
}

- (void)setCurrentStep:(NSInteger)currentStep {
    _currentStep = currentStep;
}

- (void)updateSelf {
    UIButton *preBtn = [self viewWithTag:100];
    UIButton *nextBtn = [self viewWithTag:200];
//    [nextBtn setEnabled:nextBtnEnabledState];

    if (_currentStep == 0) {
        [preBtn setHidden:YES];
        [nextBtn setHidden:NO];
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [nextBtn setTitle:@"下一步" forState:UIControlStateHighlighted];
        [nextBtn setTitle:@"下一步" forState:UIControlStateDisabled];
        [nextBtn setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    } else if (_currentStep == _numberOfStep-1) {
        [preBtn setHidden:NO];
        [nextBtn setHidden:NO];
        [nextBtn setTitle:@"完成" forState:UIControlStateNormal];
        [nextBtn setTitle:@"完成" forState:UIControlStateHighlighted];
        [nextBtn setTitle:@"完成" forState:UIControlStateDisabled];
        [preBtn setFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
        [nextBtn setFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height)];
    } else if (_currentStep < _numberOfStep-1) {
        [preBtn setHidden:NO];
        [nextBtn setHidden:NO];
        [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [nextBtn setTitle:@"下一步" forState:UIControlStateHighlighted];
        [nextBtn setTitle:@"下一步" forState:UIControlStateDisabled];
        [preBtn setFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
        [nextBtn setFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height)];
    }
}

- (void)setNextBtnState:(BOOL)enabled {
    UIButton *nextBtn = [self viewWithTag:200];
    [nextBtn setEnabled:enabled];
}

@end
