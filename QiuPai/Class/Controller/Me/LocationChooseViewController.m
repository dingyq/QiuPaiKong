//
//  LocationChooseViewController.m
//  QiuPai
//
//  Created by bigqiang on 15/12/18.
//  Copyright © 2015年 barbecue. All rights reserved.
//

#import "LocationChooseViewController.h"
#import "DDCityPickerView.h"
#import "DDPlayYearPickerView.h"

@interface LocationChooseViewController () <DDPickerViewDelegate> {
    UIButton *_pickerBtn;
    
}

@property (strong, nonatomic) DDCityPickerView *locatePicker;
@property (strong, nonatomic) DDPlayYearPickerView *playYearPicker;

@end

@implementation LocationChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:VCViewBGColor];
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setFrame:CGRectMake(0, 0, 40, 25)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateHighlighted];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [saveBtn setTitleColor:Gray153Color forState:UIControlStateDisabled];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
//    _playYear = @"";
//    _province = @"";
//    _city = @"";
//    _district = @"";
    
    [self initCityPickerButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updatePickerBtnTip];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveBtnClick:(UIButton *)sender {
    if (_modifyType == InfoModifyTypeLocation) {
        [self.callDelegate locationChooseDone:_province city:_city];
    } else if (_modifyType == InfoModifyTypePlayYear) {
        [self.callDelegate playYearChooseDone:_playYear];
    } else if (_modifyType == InfoModifyTypeSelfEvalu) {
        [self.callDelegate lvEveluateChooseDone:_lvEvalu];
    }
    [self backToPreVC:nil];
}

- (void)initCityPickerButton {
    _pickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pickerBtn setFrame:CGRectMake(0, 64 + 17, kFrameWidth, 43)];
    [_pickerBtn setBackgroundColor:[UIColor whiteColor]];
    [_pickerBtn setTitle:@"" forState:UIControlStateNormal];
    [_pickerBtn setTitle:@"" forState:UIControlStateSelected];
    [_pickerBtn setTitleColor:Gray51Color forState:UIControlStateNormal];
    [_pickerBtn setTitleColor:Gray51Color forState:UIControlStateSelected];
    _pickerBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_pickerBtn addTarget:self action:@selector(openCityPickerView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pickerBtn];
    
    UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 0.5f)];
    [upLine setBackgroundColor:LineViewColor];
    [_pickerBtn addSubview:upLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 42.5, kFrameWidth, 0.5f)];
    [bottomLine setBackgroundColor:LineViewColor];
    [_pickerBtn addSubview:bottomLine];
}

// 打开picker选择器
- (void)openCityPickerView:(UIButton *)sender {
    if (_modifyType == InfoModifyTypeLocation) {
        [self cancelLocatePicker];
        self.locatePicker = [[DDCityPickerView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 216.0f) style:DDAreaPickerWithStateAndCity delegate:self];
        [self.locatePicker showInView:self.view];
    } else if (_modifyType == InfoModifyTypePlayYear) {
        [self cancelPlayYearPicker];
        _playYearPicker = [[DDPlayYearPickerView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 216.0f) pickerStyle:DDPickerStylePlayYear delegate:self];
        _playYearPicker.playYear = _playYear;
        [_playYearPicker showInView:self.view];
    } else if (_modifyType == InfoModifyTypeSelfEvalu) {
        [self cancelSeleEvaluPicker];
        _playYearPicker = [[DDPlayYearPickerView alloc] initWithFrame:CGRectMake(0, 0, kFrameWidth, 216.0f) pickerStyle:DDPickerStyleSelfEvalu delegate:self];
        _playYearPicker.selfEvalu = _lvEvalu;
        [_playYearPicker showInView:self.view];
    }
}

- (void)updatePickerBtnTip {
    NSString *tipStr = @"";
    if (_modifyType == InfoModifyTypeLocation) {
        tipStr = [NSString stringWithFormat:@"%@ %@", _province, _city];
    } else if (_modifyType == InfoModifyTypePlayYear) {
        tipStr = [NSString stringWithFormat:@"%@", _playYear];
    } else if (_modifyType == InfoModifyTypeSelfEvalu) {
        tipStr = [NSString stringWithFormat:@"%.1f", _lvEvalu/10.0];
    }
    [_pickerBtn setTitle:tipStr forState:UIControlStateNormal];
    [_pickerBtn setTitle:tipStr forState:UIControlStateSelected];
}

- (void)setPlayYear:(NSString *)playYear {
    if (![_playYear isEqualToString:playYear]) {
        _playYear = playYear;
        [self updatePickerBtnTip];
    }
}

- (void)setSelfEvalu:(NSInteger)selfEvalu {
    if (_lvEvalu != selfEvalu) {
        _lvEvalu = selfEvalu;
        [self updatePickerBtnTip];
    }
}

- (void)setCity:(NSString *)city {
    if (![_city isEqualToString:city]) {
        _city = city;
        [self updatePickerBtnTip];
    }
}

- (void)setProvince:(NSString *)province {
    if (![_province isEqualToString:province]) {
        _province = province;
        [self updatePickerBtnTip];
    }
}

- (void)setDistrict:(NSString *)district {
    if (![_district isEqualToString:district]) {
        _district = district;
        [self updatePickerBtnTip];
    }
}

// 触摸事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (_modifyType == InfoModifyTypeLocation) {
        [self cancelLocatePicker];
    } else if (_modifyType == InfoModifyTypePlayYear) {
        [self cancelPlayYearPicker];
    } else if (_modifyType == InfoModifyTypeSelfEvalu) {
        [self cancelSeleEvaluPicker];
    }
}

// 关闭网球自测水平选择
-(void)cancelSeleEvaluPicker {
    [self.playYearPicker cancelPicker];
    self.playYearPicker.delegate = nil;
    self.playYearPicker = nil;
}

// 关闭球龄选择
-(void)cancelPlayYearPicker {
    [self.playYearPicker cancelPicker];
    self.playYearPicker.delegate = nil;
    self.playYearPicker = nil;
}

// 关闭所在地选择
-(void)cancelLocatePicker {
    [self.locatePicker cancelPicker];
    self.locatePicker.delegate = nil;
    self.locatePicker = nil;
}

#pragma mark - DDPickerViewDelegate
-(void)pickerDidChaneStatus:(UIView *)picker {
    if (_modifyType == InfoModifyTypeLocation) {
        DDCityPickerView *picker1 = (DDCityPickerView *)picker;
        if (picker1.pickerStyle == DDAreaPickerWithStateAndCityAndDistrict) {
            self.province = picker1.locate.state;
            self.city = picker1.locate.city;
            self.district = picker1.locate.district;
        } else {
            self.province = picker1.locate.state;
            self.city = picker1.locate.city;
        }
    } else if (_modifyType == InfoModifyTypePlayYear) {
        DDPlayYearPickerView *picker1 = (DDPlayYearPickerView *)picker;
        self.playYear = picker1.playYear;
    } else if (_modifyType == InfoModifyTypeSelfEvalu) {
        DDPlayYearPickerView *picker1 = (DDPlayYearPickerView *)picker;
        self.selfEvalu = picker1.selfEvalu;
    }
}

@end
