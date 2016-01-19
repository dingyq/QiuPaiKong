//
//  DDPlayYearPickerView.m
//  QiuPai
//
//  Created by bigqiang on 15/12/20.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "DDPlayYearPickerView.h"

#define kDuration 0.3

@interface DDPlayYearPickerView () {
    NSMutableArray *_playYears;
    NSMutableArray *_selfEvaluArr;
}

@end

@implementation DDPlayYearPickerView

- (instancetype)initWithFrame:(CGRect)frame pickerStyle:(DDPickerStyle)style delegate:(id<DDPickerViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        _playYearPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        // 显示选中框
        [_playYearPicker setBackgroundColor:[UIColor whiteColor]];
        _playYearPicker.showsSelectionIndicator = YES;
        [self addSubview:_playYearPicker];
        
        self.delegate = delegate;
        _playYearPicker.dataSource = self;
        _playYearPicker.delegate = self;
        
        _pickerStyle = style;
        
        if (style == DDPickerStylePlayYear) {
            _playYears = [[NSMutableArray alloc] init];
            for (int i = 0 ; i < 70; i++) {
                [_playYears addObject:[NSString stringWithFormat:@"%d", i]];
            }
        } else if (style == DDPickerStyleSelfEvalu) {
            _selfEvaluArr = [[NSMutableArray alloc] init];
            for (int i = 10; i < 75; i+=5) {
                [_selfEvaluArr addObject:[NSNumber numberWithInt:i]];
            }
        }
        
    }
    
    return self;
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_pickerStyle == DDPickerStylePlayYear) {
        return [_playYears count];
    } else if (_pickerStyle == DDPickerStyleSelfEvalu) {
        return [_selfEvaluArr count];
    }
    return 0;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *textStr = @"";
    if (_pickerStyle == DDPickerStylePlayYear) {
        textStr = [_playYears objectAtIndex:row];
    } else if (_pickerStyle == DDPickerStyleSelfEvalu) {
        textStr = [NSString stringWithFormat:@"%.1f", [[_selfEvaluArr objectAtIndex:row] integerValue]/10.0];
    }
    
    UILabel* myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 30)];
    myLabel.text = textStr;
    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.textColor = [UIColor blackColor];
    myLabel.font = [UIFont systemFontOfSize:15.0f];
    myLabel.backgroundColor = [UIColor clearColor];
    return myLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_pickerStyle == DDPickerStylePlayYear) {
        _playYear = [_playYears objectAtIndex:row];
    } else if (_pickerStyle == DDPickerStyleSelfEvalu) {
        _selfEvalu = [[_selfEvaluArr objectAtIndex:row] integerValue];
    }
    
    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        [self.delegate pickerDidChaneStatus:self];
    }
}

#pragma mark - animation

- (void)showInView:(UIView *)view {
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    
    if (_pickerStyle == DDPickerStylePlayYear) {
        [_playYearPicker selectRow:[_playYear integerValue] inComponent:0 animated:NO];
    } else if (_pickerStyle == DDPickerStyleSelfEvalu) {
        NSInteger row = ((_selfEvalu-10)/5 > 0) ? (_selfEvalu-10)/5 : 0;
        [_playYearPicker selectRow:row inComponent:0 animated:NO];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
}

- (void)cancelPicker {
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}



@end
