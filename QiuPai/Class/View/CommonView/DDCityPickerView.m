//
//  DDCityPickerView.m
//  QiuPai
//
//  Created by bigqiang on 15/12/18.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "DDCityPickerView.h"

#define kDuration 0.3

@interface DDCityPickerView () {
    NSArray *_provinces, *_cities, *_areas;
}

@end


@implementation DDCityPickerView

-(DDTLocation *)locate {
    if (_locate == nil) {
        _locate = [[DDTLocation alloc] init];
    }
    return _locate;
}

- (instancetype)initWithFrame:(CGRect)frame style:(DDAreaPickerStyle)pickerStyle delegate:(id<DDPickerViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        _locatePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        // 显示选中框
        [_locatePicker setBackgroundColor:[UIColor whiteColor]];
        _locatePicker.showsSelectionIndicator = YES;
        [self addSubview:_locatePicker];
        
        self.delegate = delegate;
        self.pickerStyle = pickerStyle;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        
        //加载数据
        if (self.pickerStyle == DDAreaPickerWithStateAndCityAndDistrict) {
            _provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Area.plist" ofType:nil]];
            _cities = [[_provinces objectAtIndex:0] objectForKey:@"cities"];
            
            self.locate.state = [[_provinces objectAtIndex:0] objectForKey:@"state"];
            self.locate.city = [[_cities objectAtIndex:0] objectForKey:@"city"];
            _areas = [[_cities objectAtIndex:0] objectForKey:@"areas"];
            if (_areas.count > 0) {
                self.locate.district = [_areas objectAtIndex:0];
            } else{
                self.locate.district = @"";
            }
        } else{
            _provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"City.plist" ofType:nil]];
            _cities = [[_provinces objectAtIndex:0] objectForKey:@"cities"];
            self.locate.state = [[_provinces objectAtIndex:0] objectForKey:@"state"];
            self.locate.city = [_cities objectAtIndex:0];
        }
    }
    
    return self;
}

#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.pickerStyle == DDAreaPickerWithStateAndCityAndDistrict) {
        return 3;
    } else{
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return [_provinces count];
            break;
        case 1:
            return [_cities count];
            break;
        case 2:
            if (self.pickerStyle == DDAreaPickerWithStateAndCityAndDistrict) {
                return [_areas count];
                break;
            }
        default:
            return 0;
            break;
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    NSString *textStr = @"";
    if (self.pickerStyle == DDAreaPickerWithStateAndCityAndDistrict) {
        switch (component) {
            case 0:
                textStr = [[_provinces objectAtIndex:row] objectForKey:@"state"];
                break;
            case 1:
                textStr = [[_cities objectAtIndex:row] objectForKey:@"city"];
                break;
            case 2:
                if ([_areas count] > 0) {
                    return [_areas objectAtIndex:row];
                    break;
                }
            default:
                textStr = @"";
                break;
        }
    } else{
        switch (component) {
            case 0:
                textStr = [[_provinces objectAtIndex:row] objectForKey:@"state"];
                break;
            case 1:
                textStr = [_cities objectAtIndex:row];
                break;
            default:
                textStr = @"";
                break;
        }
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
    if (self.pickerStyle == DDAreaPickerWithStateAndCityAndDistrict) {
        switch (component) {
            case 0:
                _cities = [[_provinces objectAtIndex:row] objectForKey:@"cities"];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                _areas = [[_cities objectAtIndex:0] objectForKey:@"areas"];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.state = [[_provinces objectAtIndex:row] objectForKey:@"state"];
                self.locate.city = [[_cities objectAtIndex:0] objectForKey:@"city"];
                if ([_areas count] > 0) {
                    self.locate.district = [_areas objectAtIndex:0];
                } else{
                    self.locate.district = @"";
                }
                break;
            case 1:
                _areas = [[_cities objectAtIndex:row] objectForKey:@"areas"];
                [self.locatePicker selectRow:0 inComponent:2 animated:YES];
                [self.locatePicker reloadComponent:2];
                
                self.locate.city = [[_cities objectAtIndex:row] objectForKey:@"city"];
                if ([_areas count] > 0) {
                    self.locate.district = [_areas objectAtIndex:0];
                } else{
                    self.locate.district = @"";
                }
                break;
            case 2:
                if ([_areas count] > 0) {
                    self.locate.district = [_areas objectAtIndex:row];
                } else{
                    self.locate.district = @"";
                }
                break;
            default:
                break;
        }
    } else{
        switch (component) {
            case 0:
                _cities = [[_provinces objectAtIndex:row] objectForKey:@"cities"];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                self.locate.state = [[_provinces objectAtIndex:row] objectForKey:@"state"];
                self.locate.city = [_cities objectAtIndex:0];
                break;
            case 1:
                self.locate.city = [_cities objectAtIndex:row];
                break;
            default:
                break;
        }
    }
    
    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        [self.delegate pickerDidChaneStatus:self];
    }
}

#pragma mark - animation

- (void)showInView:(UIView *)view {
    self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
    [view addSubview:self];
    
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
