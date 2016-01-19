//
//  StepControlToolBar.h
//  QiuPai
//
//  Created by bigqiang on 15/12/15.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, StepState) {
    StepStateFirst = 0,
    StepStateMiddle = 1,
    StepStateLast = 2,
    
};


@protocol StepControlToolBarDelegate <NSObject>

- (void)preStepBtnClick:(UIButton *)sender;
- (void)nextStepBtnClick:(UIButton *)sender;

@end

@interface StepControlToolBar : UIView

@property (nonatomic, weak) id<StepControlToolBarDelegate> myDelegate;
@property (nonatomic, assign) NSInteger numberOfStep;
@property (nonatomic, assign) NSInteger currentStep;

- (void)setNextBtnState:(BOOL)enabled;
@end
